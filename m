Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F94045D807
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 11:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354416AbhKYKPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 05:15:23 -0500
Received: from smtp2.axis.com ([195.60.68.18]:43622 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354391AbhKYKNW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 05:13:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1637835012;
  x=1669371012;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GdIrusbwRXXLYGW13kTKv3iwu2ddLrB+iTcqiTjJaeo=;
  b=jajnKAODDJwFxONv7H5T9Qay8wejY2kquQX/fSlORGliWeym1PwFAoaX
   c+hyYHlj5mL9IdgHRChiHz0W+fpW6Z0S1J/jruCVLNumsKzTIKYXQNndT
   SZrgyEBkd9x2yqf12eC11Gq7qUmN0D7Z3Ii0llbwI3uv7hkk6S7PHYN5D
   YQZ9KD/4Aoy4D8FOAMFtzMkX34JbDP8p71KdWu1o4s8Af4w0pBu8e3ivk
   2lnq6TqqavbaUAdIFxwQqJ4YexQGCVR6n9JTmxsNvu3KKxw6bAZj4lVli
   UG+e3drTpZek+n8GmfUBw64JH6b6uocq4peGodIA4gfYQoGNyfv3NsOpT
   Q==;
Date:   Thu, 25 Nov 2021 11:10:07 +0100
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, kernel <kernel@axis.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH] af_unix: fix regression in read after shutdown
Message-ID: <20211125101007.GA13511@axis.com>
References: <20211119120521.18813-1-vincent.whitchurch@axis.com>
 <YZ19J+jZrOXxR1oR@unknown>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YZ19J+jZrOXxR1oR@unknown>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 12:45:43AM +0100, Cong Wang wrote:
> On Fri, Nov 19, 2021 at 01:05:21PM +0100, Vincent Whitchurch wrote:
> > On kernels before v5.15, calling read() on a unix socket after
> > shutdown(SHUT_RD) or shutdown(SHUT_RDWR) would return the data
> > previously written or EOF.  But now, while read() after
> > shutdown(SHUT_RD) still behaves the same way, read() after
> > shutdown(SHUT_RDWR) always fails with -EINVAL.
> 
> Maybe just lift the socket tate check in unix_stream_read_generic()?

That would have have handled the specific case of read(2) on
SOCK_STREAM, but the sk->sk_state is checked in many other places in
af_unix.c so there would still be userspace-visible behaviour changes in
several other situations, which could cause regressions.  Just to give
one such example, the sendfile(2) call in the following program gets
killed by SIGPIPE on earlier kernels but would now instead start to
return -ENOTCONN:

#include <err.h>
#include <errno.h>
#include <stdio.h>
#include <sys/socket.h>
#include <sys/unistd.h>
#include <sys/sendfile.h>
#include <sys/types.h>
#include <fcntl.h>

int main(int argc, char *argv[]) {
  int sock[2];
  int ret;

  ret = socketpair(AF_UNIX, SOCK_STREAM, 0, sock);
  if (ret < 0)
    err(1, "socketpair");

  ret = shutdown(sock[0], SHUT_RDWR);
  if (ret < 0)
    err(1, "shutdown");

  ssize_t bytes = sendfile(sock[0], open(argv[0], O_RDONLY), NULL, 16);
  if (bytes < 0)
    err(1, "sendfile");

  printf("sendfile %zd bytes\n", bytes);

  return 0;
}

> > 
> > This behaviour change was apparently inadvertently introduced as part of
> > a bug fix for a different regression caused by the commit adding sockmap
> > support to af_unix, commit 94531cfcbe79c359 ("af_unix: Add
> > unix_stream_proto for sockmap").  Those commits, for unclear reasons,
> > started setting the socket state to TCP_CLOSE on shutdown(SHUT_RDWR),
> 
> Not sure why it is unclear here, for an connection oriented socket, it
> can be closed for just one direction, in this case we want to prevent it
> from being redirected in sockmap, hence the point of the commits.

I must admit I'm not really familiar with either af_unix.c or sockmap,
but clearly the existing code in af_unix.c does not expect sk_state to
be changed in shutdown.  If we want to prevent UNIX sockets which have
had shutdown(SHUT_RDWR) called on then from being redirect to sockmap,
then maybe some other flag should be used to achieve that?

(Also, I wonder why the code added by the patch handled SHUT_RDWR
 differently from a SHUT_RD followed by a SHUT_WR?)

> > while this state change had previously only been done in
> > unix_release_sock().
> > 
> > Restore the original behaviour.  The sockmap tests in
> > tests/selftests/bpf continue to pass after this patch.
> 
> Isn't this because we don't have shutdown() in sockmap tests?

That may well be the case, I just assumed that the tests added along
with the new feature were comprehensive.
