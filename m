Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE51544D7B9
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhKKOCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:02:54 -0500
Received: from smtp2.axis.com ([195.60.68.18]:10210 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231739AbhKKOCx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 09:02:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1636639205;
  x=1668175205;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RFcG43MDtINsUV9C/D4kpj+78WwyKwfn64tSQhJrSn8=;
  b=dHPXd1tqw+n6RIIpjF8+O8CkdgEnRQaKCghI5/p0yBbvRNyWWLJCKImm
   LggvCs+0ANwG7FBbzhD5xESXjlj/s0nuTInGLCOEs7iJ53QKIpP+bkIhJ
   c9EehaEwV8acSflQ96BWZVYSKyo3JeHWqVU8Dlf1CZRu8aGAMDKe/NH+T
   cbldJc/5kTNmwgPBiF1k8+U2kLIroTLhwgRcrrySlsAQRYN6OR7deg3Nh
   H2/Q0hfGUgmmbTXJ94DbtdnOO+PPzAHSCEUN071qQcdB4+DdDjkm4tBHw
   YJ40senz4jiSCGQsITdyI8ugUnvrq9pA7l3kjJ2gbXV9pCa1l7izPl2xl
   w==;
Date:   Thu, 11 Nov 2021 15:00:02 +0100
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Jiang Wang <jiang.wang@bytedance.com>
CC:     <bpf@vger.kernel.org>, <cong.wang@bytedance.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Rao Shoaib <Rao.Shoaib@oracle.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf v1] unix: fix an issue in unix_shutdown causing the
 other end read/write failures
Message-ID: <20211111140000.GA10779@axis.com>
References: <20211004232530.2377085-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211004232530.2377085-1-jiang.wang@bytedance.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 11:25:28PM +0000, Jiang Wang wrote:
> Commit 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
> sets unix domain socket peer state to TCP_CLOSE
> in unix_shutdown. This could happen when the local end is shutdown
> but the other end is not. Then the other end will get read or write
> failures which is not expected.
> 
> Fix the issue by setting the local state to shutdown.
> 
> Fixes: 94531cfcbe79 (af_unix: Add unix_stream_proto for sockmap)
> Suggested-by: Cong Wang <cong.wang@bytedance.com>
> Reported-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>

This patch changed the behaviour of read(2) after a shutdown(2) on the
local end of a UDS.  Before this patch, reading from a UDS after a local
shutdown(SHUT_RDWR) would return the data written or EOF if there is no
data, but now it always returns -EINVAL.

For example, the following test program succeeds with "read 16 bytes" on
v5.14 but fails with "read: Invalid argument" on v5.15 and mainline:

#include <err.h>
#include <errno.h>
#include <stdio.h>
#include <sys/socket.h>
#include <sys/unistd.h>

int main(int argc, char *argv[]) {
  int sock[2];
  int ret;

  ret = socketpair(AF_UNIX, SOCK_STREAM, 0, sock);
  if (ret < 0)
    err(1, "socketpair");

  char buf[16] = {};
  ret = write(sock[1], buf, sizeof(buf));
  if (ret < 0)
    err(1, "write");

  ret = shutdown(sock[0], SHUT_RDWR);
  if (ret < 0)
    err(1, "shutdown");

  ssize_t bytes = read(sock[0], buf, sizeof(buf));
  if (bytes < 0)
    err(1, "read");

  printf("read %zd bytes\n", bytes);

  return 0;
}
