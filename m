Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D44B38147D
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 02:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhEOAXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 20:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229898AbhEOAXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 20:23:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B208A61370;
        Sat, 15 May 2021 00:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621038119;
        bh=tTpKD4IrDTTlTh3tvZ6y0j4FaUTzFOPQo5RePfZzqPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PXpB2DanK7yS+7WEEYFQgFsbUtRbheVJzny0iMNoVzXQ3aM5l443/PrNSM92VA3nn
         ERE79adepwN5grt59KgDkUvpPLCDXR6e43GX0l+gfBXqNa76vA1rHK4SNJAK1EkaKe
         HV0WVki9CZlXUDHqvCt6op7f3PwncIeXUGjRvE86s0hhcCnfsIv3wb0skH3ZBgF53l
         ekFjG3WCYwgYYoT5MdyMUKlgvYgtLvl6jPANmrXLjZZh/nyyWM+ZzsyK0sJXT1mqXy
         ioV3+0zefmniPGzbJfwBb+eCgtiK6AakUd2nngHRJITo/KoWoaGJxsQRY+RkHmomil
         GnE82eDDGcApA==
Date:   Fri, 14 May 2021 17:21:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, simon.horman@netronome.com,
        oss-drivers@netronome.com, bigeasy@linutronix.de
Subject: Re: [PATCH net-next 1/2] net: add a napi variant for
 RT-well-behaved drivers
Message-ID: <20210514172157.7af29448@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87y2cg26kx.ffs@nanos.tec.linutronix.de>
References: <20210514222402.295157-1-kuba@kernel.org>
        <87y2cg26kx.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 May 2021 02:17:50 +0200 Thomas Gleixner wrote:
> On Fri, May 14 2021 at 15:24, Jakub Kicinski wrote:
> >  
> > +void __napi_schedule_irq(struct napi_struct *n)
> > +{
> > +	____napi_schedule(this_cpu_ptr(&softnet_data), n);  
> 
> Not that I have any clue, but why does this not need the
> napi_schedule_prep() check?

napi_schedule_prep() is in the non-__ version in linux/netdevice.h:

static inline void napi_schedule_irq(struct napi_struct *n)
{
	if (napi_schedule_prep(n))
		__napi_schedule_irq(n);
}
