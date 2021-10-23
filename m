Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E93F438401
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 17:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhJWPKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 11:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhJWPKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 11:10:20 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F277AC061714
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 08:08:00 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Hc4Mx61hMzQkJM;
        Sat, 23 Oct 2021 17:07:57 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1635001675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z5w+PPsi+iT9XfGWM1K580HqRWCzTpIr4O28tJCOeW0=;
        b=y1PztHIRP/qOatBYM1uUUqWrmlFyPzijbU1f26stqwy5otALrHNbtcAPQmwtUmSzCWdvSF
        XMBMMNE1xpA+mSq0h00/5sbhL6wlKckbPMVW5ZTLe1OVMIISduR/UJ8SmGOqxTod2Ipah2
        aHJcyHfZtgdiepT0E8VL3AiXokr78wXtxv3AHRdbKvjd+q4WkcqWFZGmTqycQP0pFLqcA7
        CsAXfgdOB9d6oa+QfxpfDVUHefGe2xSQK2p5BljC9l7vkBAX6Ah/KH3QmoeOMTqs5GoFtt
        /rnSEMyrmaRrItzcod+7qWIXE54hDSjBSzTxCYW6mplFxDujApbzXaVAB9isNg==
Subject: Re: [PATCH v4 net-next 5/9] net: dsa: lantiq_gswip: serialize access
 to the PCE table
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
References: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
 <20211022184312.2454746-6-vladimir.oltean@nxp.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <fdee4167-4eb9-774f-b28d-1d59db4b295e@hauke-m.de>
Date:   Sat, 23 Oct 2021 17:07:49 +0200
MIME-Version: 1.0
In-Reply-To: <20211022184312.2454746-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9F72A22F
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 8:43 PM, Vladimir Oltean wrote:
> Looking at the code, the GSWIP switch appears to hold bridging service
> structures (VLANs, FDBs, forwarding rules) in PCE table entries.
> Hardware access to the PCE table is non-atomic, and is comprised of
> several register reads and writes.

The switch has multiple tables which can be accessed with indirect 
addressing over the PCE registers.

> These accesses are currently serialized by the rtnl_lock, but DSA is
> changing its driver API and that lock will no longer be held when
> calling ->port_fdb_add() and ->port_fdb_del().
> 
> So this driver needs to serialize the access to the PCE table using its
> own locking scheme. This patch adds that.

The driver also uses the gswip_pce_load_microcode() function to load a 
static configuration for the packet classification engine into a table 
using the same registers. It is currently not protected, but only called 
by the DSA setup callback.

> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v3->v4: call mutex_init
> 
>   drivers/net/dsa/lantiq_gswip.c | 28 +++++++++++++++++++++++-----
>   1 file changed, 23 insertions(+), 5 deletions(-)
> 
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>


