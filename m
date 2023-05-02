Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289126F4241
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 13:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbjEBLFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 07:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbjEBLFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 07:05:34 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FF4D2
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 04:05:30 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 18BDBFF803;
        Tue,  2 May 2023 11:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1683025529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Ayj5lQtzQL5po8g9dKUOVARlBnR7zFnt2GHuiHmIBo=;
        b=FinDVppd8MxUVazxd5MihvXyOFgCq3IKwzQzQizuQv4LPE5h2St4013f9f+RmF8mAwapDb
        3wbjMwCMePBr/6PHYM1x2PjREBhyZ23rYt3s91NgeXweXitG/qVgjl96SBZoU9BSQsDoe1
        n0jHXRrXMz1QX7J8VpxhjdlAhievZYg0LFKg8Uc6taO7qyrAxSdTtFki5pdPrS1Blj2o5D
        eDMbLnUsGtoe1dJDWBnWMtcZDPKD5Yeca5eCkOmGvmt78jhIE1TahKHdi04RWYOAHEVzam
        bopgZC2h6qbKOoGGyI2+B+ixKcNZI2rCBxTsLtP7yI7gvJuBVcdTriv15jQyww==
Date:   Tue, 2 May 2023 13:05:25 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <20230502130525.02ade4a8@kmaincent-XPS-13-7390>
In-Reply-To: <20230429175807.wf3zhjbpa4swupzc@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
        <20230406173308.401924-1-kory.maincent@bootlin.com>
        <20230406173308.401924-5-kory.maincent@bootlin.com>
        <20230406173308.401924-5-kory.maincent@bootlin.com>
        <20230429175807.wf3zhjbpa4swupzc@skbuf>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Apr 2023 20:58:07 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

Thanks for the review and sorry for the coding style issues, I forgot to run the
checkpatch script.

> >  
> >  #if IS_ENABLED(CONFIG_MACSEC)
> > @@ -2879,6 +2885,7 @@ enum netdev_cmd {
> >  	NETDEV_OFFLOAD_XSTATS_REPORT_DELTA,
> >  	NETDEV_XDP_FEAT_CHANGE,
> >  	NETDEV_PRE_CHANGE_HWTSTAMP,
> > +	NETDEV_CHANGE_HWTSTAMP,  
> 
> Don't create new netdev notifiers with no users. Also,
> NETDEV_PRE_CHANGE_HWTSTAMP has disappered.

Ok, right you move it on to dsa stub. What do you think of our case, should we
continue with netdev notifier? 

> > diff --git a/include/uapi/linux/ethtool_netlink.h
> > b/include/uapi/linux/ethtool_netlink.h index 447908393b91..4f03e7cde271
> > 100644 --- a/include/uapi/linux/ethtool_netlink.h
> > +++ b/include/uapi/linux/ethtool_netlink.h
> > @@ -41,6 +41,7 @@ enum {
> >  	ETHTOOL_MSG_TSINFO_GET,
> >  	ETHTOOL_MSG_TSLIST_GET,
> >  	ETHTOOL_MSG_TS_GET,
> > +	ETHTOOL_MSG_TS_SET,  
> 
> The way in which the Linux kernel ensures a stable API towards user
> space is that programs written against kernel headers from 5 years ago
> still work with kernels from today. In your case, you would be breaking
> that, because before this patch, ETHTOOL_MSG_CABLE_TEST_ACT was 26, and
> after your patch it is 27. So old applications emitting a cable test
> netlink message would be interpreted by new kernels as emitting a "set
> timestamping layer" netlink message. Of course not only the cable test
> is affected, every other netlink message until the end is now shifted by
> 1. This is why we put new enum values only at the very end, where it
> actually says they should go:

Sorry for that, this indeed didn't cross my head. I will fix it.

> >  
> > +/* TS_SET */
> > +const struct nla_policy ethnl_ts_set_policy[] = {
> > +	[ETHTOOL_A_TS_HEADER]	=
> > NLA_POLICY_NESTED(ethnl_header_policy),
> > +	[ETHTOOL_A_TS_LAYER]	= { .type = NLA_U32 },
> > +};  
> 
> I wanted to explore this topic myself, but I can't seem to find the
> time, so here's something a bit hand-wavey.
> 
> We should make a distinction between what the kernel exposes as UAPI
> (our future selves need to work with that in a backwards-compatible way)
> and the internal, unstable kernel implementation.
> 
> It would be good if, instead of the ETHTOOL_A_TS_LAYER netlink
> attribute, the kernel could expose a more generic ETHTOOL_A_TS_PHC, from
> which the ethtool core could deduce if the PHC number belongs to the MAC
> or to the PHY. We could still keep something like
> netdev->selected_timestamping_layer in code private to the kernel, but from
> the UAPI perspective, I agree with Andrew that we should design something
> that is cleanly extensible to N PHCs, not just to a vague "layer".

Just some thought:
Maybe we could create a PHC_ID 0xXY where X is the layer and Y the PHCs number
in this layer, but what will append if there is two MACs consecutively?
Also in case of several MACs or PHYs in serial
netdev->selected_timestamping_layer is inappropriate. 

Maybe using it like 0xABC where A is the MAC number, B the PHY number and C
the PHC number in the device.
For example if we select the second MAC and its third PHC, PHC_ID will be
0x203. Or if we select the second PHC of the PHY it will be 0x012.
