Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95C4403D10
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 17:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352198AbhIHP6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 11:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349791AbhIHP6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 11:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE7660EE6;
        Wed,  8 Sep 2021 15:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631116646;
        bh=ELvutsBWnKljahCvmsUf1lTmYmJcUrk25vI9Qu6RLeU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PPKnDcaUpF7UJAtCrxsg6TaImq+zosSFohM4v+Two1N1RTL0H2O6LjldOSv8+ajsI
         NPSLzjOfRmv+DcULTsCoJ5/Qow+YUMoZH4wvHKIYmrxuO8WC2HWywg6OPIzfnKKIVz
         r5gd0praMBEggJVNzQ29xSyYQ9XAVhbqMv7LQqt1smeFME3oK0G3vJYhA/SrYJb3Eo
         mKAjKg9iEK4Kge0vMJ9Syj7hQ4FxpBYMoCJT8W6B751ZJho+gikM7kQOAb5mV8qNBZ
         sFeKCTwBaopKA9DyrnlMkaYVawj8tOIxUsiiocQ5hrx5wj8iY+7J9zki+nLs3PAQmm
         /r1vcY8pBCpBQ==
Date:   Wed, 8 Sep 2021 08:57:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     moyufeng <moyufeng@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        alexander.duyck@gmail.com, linux@armlinux.org.uk, mw@semihalf.com,
        linuxarm@openeuler.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, thomas.petazzoni@bootlin.com,
        hawk@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, akpm@linux-foundation.org,
        peterz@infradead.org, will@kernel.org, willy@infradead.org,
        vbabka@suse.cz, fenghua.yu@intel.com, guro@fb.com,
        peterx@redhat.com, feng.tang@intel.com, jgg@ziepe.ca,
        mcroce@microsoft.com, hughd@google.com, jonathan.lemon@gmail.com,
        alobakin@pm.me, willemb@google.com, wenxu@ucloud.cn,
        cong.wang@bytedance.com, haokexin@gmail.com, nogikh@google.com,
        elver@google.com, yhs@fb.com, kpsingh@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, chenhao288@hisilicon.com
Subject: Re: [PATCH net-next v2 4/4] net: hns3: support skb's frag page
 recycling based on page pool
Message-ID: <20210908085723.3c9c2de2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YTjWK1rNsYIcTt4O@apalos.home>
References: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
        <1628217982-53533-5-git-send-email-linyunsheng@huawei.com>
        <2b75d66b-a3bf-2490-2f46-fef5731ed7ad@huawei.com>
        <20210908080843.2051c58d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YTjWK1rNsYIcTt4O@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Sep 2021 18:26:35 +0300 Ilias Apalodimas wrote:
> > Normally I'd say put the stats in ethtool -S and the rest in debugfs
> > but I'm not sure if exposing pages_state_hold_cnt and
> > pages_state_release_cnt directly. Those are short counters, and will
> > very likely wrap. They are primarily meaningful for calculating
> > page_pool_inflight(). Given this I think their semantics may be too
> > confusing for an average ethtool -S user.
> > 
> > Putting all the information in debugfs seems like a better idea.  
> 
> I can't really disagree on the aforementioned stats being confusing.
> However at some point we'll want to add more useful page_pool stats (e.g the
> percentage of the page/page fragments that are hitting the recycling path).
> Would it still be 'ok' to have info split across ethtool and debugfs?

Possibly. We'll also see what Alex L comes up with for XDP stats. Maybe
we can arrive at a netlink API for standard things (broken record).

You said percentage - even tho I personally don't like it - there is a
small precedent of ethtool -S containing non-counter information (IOW
not monotonically increasing event counters), e.g. some vendors rammed
PCI link quality in there. So if all else fails ethtool -S should be
fine.
