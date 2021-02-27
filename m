Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D5F326D1D
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 14:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhB0NUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 08:20:20 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:34773 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhB0NUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 08:20:19 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3E4062222E;
        Sat, 27 Feb 2021 14:19:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1614431977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xKtdxwb28gZ9pdGPvFfAHLs97DZ5HUXdDgEhq5YsiXM=;
        b=hkuj6z3ot5nI7PtiHFf46x0pcKvjCpWnPsVkWysyLGWSvsmVq8ilqhnzcEz0HZEu+0XZW9
        AkuHpmsTvOGeWE41FjuN77H6RT3E02jYmRwDJXOv9L8TnEvo4pyb2787/ugQ4APCX2+HtR
        CYrdZcSqxjLQnsCp8IuNGk+327GNYSI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 27 Feb 2021 14:19:37 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net 2/6] net: enetc: initialize RFS/RSS memories for
 unused ports too
In-Reply-To: <20210225121835.3864036-3-olteanv@gmail.com>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-3-olteanv@gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <d8e5e57392fec5aff2b65beceda161ea@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-25 13:18, schrieb Vladimir Oltean:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Michael reports that since linux-next-20210211, the AER messages for 
> ECC
> errors have started reappearing, and this time they can be reliably
> reproduced with the first ping on one of his LS1028A boards.
> 
> $ ping 1[   33.258069] pcieport 0000:00:1f.0: AER: Multiple Corrected
> error received: 0000:00:00.0
> 72.16.0.1
> PING [   33.267050] pcieport 0000:00:1f.0: AER: can't find device of 
> ID0000
> 172.16.0.1 (172.16.0.1): 56 data bytes
> 64 bytes from 172.16.0.1: seq=0 ttl=64 time=17.124 ms
> 64 bytes from 172.16.0.1: seq=1 ttl=64 time=0.273 ms
> 
> $ devmem 0x1f8010e10 32
> 0xC0000006
> 
> It isn't clear why this is necessary, but it seems that for the errors
> to go away, we must clear the entire RFS and RSS memory, not just for
> the ports in use.
> 
> Sadly the code is structured in such a way that we can't have unified
> logic for the used and unused ports. For the minimal initialization of
> an unused port, we need just to enable and ioremap the PF memory space,
> and a control buffer descriptor ring. Unused ports must then free the
> CBDR because the driver will exit, but used ports can not pick up from
> where that code path left, since the CBDR API does not reinitialize a
> ring when setting it up, so its producer and consumer indices are out 
> of
> sync between the software and hardware state. So a separate
> enetc_init_unused_port function was created, and it gets called right
> after the PF memory space is enabled.
> 
> Note that we need access from enetc_pf.c to the CBDR creation and
> deletion methods, which were for some reason put in enetc.c. While
> changing their definitions to be non-static, also move them to
> enetc_cbdr.c which seems like a better place to hold these.
> 
> Fixes: 07bf34a50e32 ("net: enetc: initialize the RFS and RSS memories")
> Reported-by: Michael Walle <michael@walle.cc>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

I had this patch in my tree for a while now. As we've learned, it
really depends on a particular power-up state for the error to happen.
So take this with a grain of salt: I haven't seen the error anymore,
albeit multiple power-cycles. Thus:

Tested-by: Michael Walle <michael@walle.cc>
