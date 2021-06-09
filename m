Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4443A1ACF
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 18:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhFIQWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 12:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhFIQWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 12:22:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96BF2611AE;
        Wed,  9 Jun 2021 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623255623;
        bh=X7M0xs0eGOmGuyMA4YS5bDY1/R9cG9+jlCsQLk+6Bk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f9wWN/fooTuhyCp0R8Jp2CjqYeL3J0UBFkIffvtnJYsNs3ToYGhvYKqEn5KHZDRXS
         bx/TPjiJWwkpgdpMPu08fRjiiZgYuAEBnVentnCTUZ/SwI0672IoGErniHzwjOi8s2
         hSCD7whhOlz4fmTnDVg5Tg9pWdpuvB/1ZDBlkV553NotAMfXHpP4FnZD3j1hRPbvYX
         1YJ3Kc/MNLLaKtORDj+KXiFUZOJwfDIssdnzwkDyJ4QpH0UUmmoFQHu+Yc1PmMU2S5
         HUg7iCGgHi7Vj+PTnWZZgsh4udEep36w4UJFLg2SEcLjkMGxgP779G5TYteDa0wSlr
         UHdHP8jCEoMdg==
Date:   Wed, 9 Jun 2021 09:20:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>, <cong.wang@bytedance.com>,
        <xiyou.wangcong@gmail.com>, <john.fastabend@gmail.com>,
        <mkubecek@suse.cz>
Cc:     Vladimir Oltean <olteanv@gmail.com>, <davem@davemloft.net>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andriin@fb.com>,
        <edumazet@google.com>, <ap420073@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, <jhs@mojatatu.com>,
        <jiri@resnulli.us>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <jonas.bonn@netrounds.com>,
        <pabeni@redhat.com>, <mzhivich@akamai.com>, <johunt@akamai.com>,
        <albcamus@gmail.com>, <kehuan.feng@gmail.com>,
        <a.fatoum@pengutronix.de>, <atenart@kernel.org>,
        <alexander.duyck@gmail.com>, <hdanton@sina.com>, <jgross@suse.com>,
        <JKosina@suse.com>, <bjorn@kernel.org>, <alobakin@pm.me>
Subject: Re: [PATCH net-next v2 0/3] Some optimization for lockless qdisc
Message-ID: <20210609092016.4c43192f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <64aaa011-41a3-1e06-af02-909ff329ef7a@huawei.com>
References: <1622684880-39895-1-git-send-email-linyunsheng@huawei.com>
        <20210603113548.2d71b4d3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20210608125349.7azp7zeae3oq3izc@skbuf>
        <64aaa011-41a3-1e06-af02-909ff329ef7a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Jun 2021 09:31:39 +0800 Yunsheng Lin wrote:
> On 2021/6/8 20:53, Vladimir Oltean wrote:
> > On Thu, Jun 03, 2021 at 11:35:48AM -0700, Jakub Kicinski wrote:  
> >> On Thu, 3 Jun 2021 09:47:57 +0800 Yunsheng Lin wrote:  
> >>> Patch 1: remove unnecessary seqcount operation.
> >>> Patch 2: implement TCQ_F_CAN_BYPASS.
> >>> Patch 3: remove qdisc->empty.
> >>>
> >>> Performance data for pktgen in queue_xmit mode + dummy netdev
> >>> with pfifo_fast:
> >>>
> >>>  threads    unpatched           patched             delta
> >>>     1       2.60Mpps            3.21Mpps             +23%
> >>>     2       3.84Mpps            5.56Mpps             +44%
> >>>     4       5.52Mpps            5.58Mpps             +1%
> >>>     8       2.77Mpps            2.76Mpps             -0.3%
> >>>    16       2.24Mpps            2.23Mpps             +0.4%
> >>>
> >>> Performance for IP forward testing: 1.05Mpps increases to
> >>> 1.16Mpps, about 10% improvement.  
> >>
> >> Acked-by: Jakub Kicinski <kuba@kernel.org>  
> > 
> > Any idea why these patches are deferred in patchwork?
> > https://patchwork.kernel.org/project/netdevbpf/cover/1622684880-39895-1-git-send-email-linyunsheng@huawei.com/  
> 
> I suppose it is a controversial change, which need more time
> hanging to be reviewed and tested.

That'd be my guess also. A review from area experts would be great,
perhaps from Cong, John, Michal..  If the review doesn't come by
Friday - I'd repost.
