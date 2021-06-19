Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1393E3AD651
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 02:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbhFSAkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 20:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234620AbhFSAkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 20:40:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E33D36124C;
        Sat, 19 Jun 2021 00:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624063119;
        bh=mP7tDiOcpNjEq88FHza9d1X97mpYxtBkgmm1X01yAQA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mx37JGeiBfvsxF9ov9oi3/SG5pBcaQ4hSc7Qsa3Jsqa42J1FEIJWIzUJlEf8neuer
         Yp+4Afyw+qdfTHisqLbTGkuTUPD7qkfb2eR42lbTejXKnuonTtj8DSnAxN7w5RnuOo
         JitY/lKdKVWJw6CfpImGbWKJkfBzcSWTEY2Di6/Hb27XB21dSiKGtalt2Fz3uduAlL
         iANAze31asnMnZTgNEab/ZX5RNVNSDm7yxn6TyIu4m3AsuxCLB/F0Rrki0Oz4Dq8dI
         17XUVEGMdBWpAFBu7+wmRBim2tSHh27iDakSlR15d2IafObb6NN+NDpfyhNe+ztXBt
         2RdBEdia7PQNQ==
Date:   Fri, 18 Jun 2021 17:38:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <olteanv@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>, <edumazet@google.com>,
        <weiwan@google.com>, <cong.wang@bytedance.com>,
        <ap420073@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <mkl@pengutronix.de>, <linux-can@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <mkubecek@suse.cz>, <bjorn@kernel.org>,
        <alobakin@pm.me>
Subject: Re: [PATCH net v2] net: sched: add barrier to ensure correct
 ordering for lockless qdisc
Message-ID: <20210618173837.0131edc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210618173047.68db0b81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1623891854-57416-1-git-send-email-linyunsheng@huawei.com>
        <20210618173047.68db0b81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Jun 2021 17:30:47 -0700 Jakub Kicinski wrote:
> On Thu, 17 Jun 2021 09:04:14 +0800 Yunsheng Lin wrote:
> > The spin_trylock() was assumed to contain the implicit
> > barrier needed to ensure the correct ordering between
> > STATE_MISSED setting/clearing and STATE_MISSED checking
> > in commit a90c57f2cedd ("net: sched: fix packet stuck
> > problem for lockless qdisc").
> > 
> > But it turns out that spin_trylock() only has load-acquire
> > semantic, for strongly-ordered system(like x86), the compiler
> > barrier implicitly contained in spin_trylock() seems enough
> > to ensure the correct ordering. But for weakly-orderly system
> > (like arm64), the store-release semantic is needed to ensure
> > the correct ordering as clear_bit() and test_bit() is store
> > operation, see queued_spin_lock().
> > 
> > So add the explicit barrier to ensure the correct ordering
> > for the above case.
> > 
> > Fixes: a90c57f2cedd ("net: sched: fix packet stuck problem for lockless qdisc")
> > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>  
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Actually.. do we really need the _before_atomic() barrier?
I'd think we only need to make sure we re-check the lock 
after we set the bit, ordering of the first check doesn't 
matter.
