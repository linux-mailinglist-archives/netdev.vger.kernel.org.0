Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C727D6E6
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgI2T3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:29:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47934 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgI2T27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 15:28:59 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601407737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ejPlYLuK/RrG1Ug9jUVw+RCh2d2QI9x46n6e3ER5waE=;
        b=jzK31F0hkX+g/zDbClPLlLVu9kXjkbwDQ8nkzQq0VCcBJVBhZYhN+xj4b1uTFaQM5AfIrR
        uUWl8TnasbznKHO3ZGzPaq5nBedDDvTFchDq6KAv4LYEr15ukprwl0bn7iVH9X/9w63zDj
        lJWN4jWRCH6roCHZIateyWxioPGvz8LCBiQs6U4A2cgTC1p+kBpW9+kn/+Wm1G/L0Egx59
        f/Txoex/d1NDspeufn6WmyVxeohT8y0pbgS/Aoh+yv9AY+OXZmerbn1cZWeQicJdLzcT6j
        UkGyRNk11pdzClcFcCe1C1u7ZBrxewV6VGyPwotZHhn2Fx9QN/0yNFuTr1BF+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601407737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ejPlYLuK/RrG1Ug9jUVw+RCh2d2QI9x46n6e3ER5waE=;
        b=k+ngi4uscbIfc6Tr3Nj+6XWKdWQF7D4h/otD/ylBuvXUrkLYijlglYQmd56+0IA4gxOoNv
        ZU+1jxQd9cpV5LAg==
To:     Hillf Danton <hdanton@sina.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     syzbot <syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com>,
        davem@davemloft.net, hchunhui@mail.ustc.edu.cn, ja@ssi.bg,
        jmorris@namei.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org,
        Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH] mac80211_hwsim: close the race between running and enqueuing hrtimer
In-Reply-To: <20200929085749.12396-1-hdanton@sina.com>
References: <20200929085749.12396-1-hdanton@sina.com>
Date:   Tue, 29 Sep 2020 21:28:56 +0200
Message-ID: <87blhojsav.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29 2020 at 16:57, Hillf Danton wrote:
> So the timer was armed at some point and then the expiry which does the
> forward races with the ioctl which starts the timer. Lack of
> serialization or such ...
> ===
>
> To close the race, replace hrtimer_is_queued() with hrtimer_active() on
> enqueuing timer, because it also covers the case of a running timer in
> addition to the queued one.
>
> Link: https://lore.kernel.org/lkml/87pn65khft.fsf@nanos.tec.linutronix.de/
> Reported-by: syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com
> Decoded-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Hillf Danton <hdanton@sina.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
