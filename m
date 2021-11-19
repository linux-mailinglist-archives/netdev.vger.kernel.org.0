Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAB945706C
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbhKSORX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:17:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhKSORX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:17:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F41861261;
        Fri, 19 Nov 2021 14:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637331261;
        bh=5UbpRd7CsvaSQlr5T3i7B4sg1JPqvuBdnTrSuCLXN/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WUpoPnBLG/Z+ebvnjGCaan3a1l7Dys8RLU/LlFcHE6UEjJtr7FNvjqZQfrweTOKvS
         uy2sXh+E3S7PcQXzR4j8J5lVO375y+ZJaJisFnB7IQWNLP/B4PN/SCKEDOoodNeOU8
         YBAUR8WJYjPccfMpiV5ysbg1gZ65HiAMmdH4w1RSbM8HYyV3z5qn4+MoxSo7GrayMw
         JbhJXxUyz+k3aVZGGeLFyqJS8+PfO1iQl81Y3vv6wlH8MEjNoPTrlhlu8KuH9NrjIX
         H3icXoHaFP/Svci0gzYRBLXWekjxEX5GbJGPdQ1EYg/GNhvJuZtEIGGL1tEEUAFTyo
         IZTH3w43pJk2g==
Date:   Fri, 19 Nov 2021 06:14:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiang Wang <jiang.wang@bytedance.com>, <cong.wang@bytedance.com>
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        <bpf@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>,
        "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <20211119061419.270007d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211111140000.GA10779@axis.com>
References: <20211004232530.2377085-1-jiang.wang@bytedance.com>
        <20211111140000.GA10779@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 15:00:02 +0100 Vincent Whitchurch wrote:
> On Mon, Oct 04, 2021 at 11:25:28PM +0000, Jiang Wang wrote:
> > Commit 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
> > sets unix domain socket peer state to TCP_CLOSE
> > in unix_shutdown. This could happen when the local end is shutdown
> > but the other end is not. Then the other end will get read or write
> > failures which is not expected.
> > 
> > Fix the issue by setting the local state to shutdown.
> > 
> > Fixes: 94531cfcbe79 (af_unix: Add unix_stream_proto for sockmap)
> > Suggested-by: Cong Wang <cong.wang@bytedance.com>
> > Reported-by: Casey Schaufler <casey@schaufler-ca.com>
> > Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>  
> 
> This patch changed the behaviour of read(2) after a shutdown(2) on the
> local end of a UDS.  Before this patch, reading from a UDS after a local
> shutdown(SHUT_RDWR) would return the data written or EOF if there is no
> data, but now it always returns -EINVAL.
> 
> For example, the following test program succeeds with "read 16 bytes" on
> v5.14 but fails with "read: Invalid argument" on v5.15 and mainline:

Cong, Jiang, was this regression addressed?
