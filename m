Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A367754C102
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 07:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240161AbiFOFJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 01:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233958AbiFOFJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 01:09:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202DC1A061;
        Tue, 14 Jun 2022 22:09:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 84BDCCE1B8E;
        Wed, 15 Jun 2022 05:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EFBC34115;
        Wed, 15 Jun 2022 05:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655269789;
        bh=oOgS5P11N6XuYBqlsXOue8yUYaaDwNGTpTh6ZXQNHDU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GdCqQGMCOgreR5Edikv2b71DjwqxZj9+TGPq5JmwyjQhd/Q8bMiNoIOufntN7cDBh
         +QVrtzuE64IWuKyQ7vsZ+yAgczEmEQL/LiTbgRohj5LqCoisjsF80uhQcjIiLyy0kP
         EOuX5VqW58TP0J08gZa9EnYCY8ZrXqWO0AOww3EUz6biBm9eFEBdwP4JGZNeLZIDF8
         ygPksm2dk5m2QPKOrJZrGb7nnwFnO2obgcFQH2Pt0wjV09oQKC+JH9najlBDqyp0sD
         4ChPvvCsya8PLUjMmb7to+v/wFYhMQu8ScduFguJ6XP0SJp/FeDgQhfVBrhb7ZJXEj
         YdiwpXFc45JQQ==
Date:   Tue, 14 Jun 2022 22:09:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: add remote fault support
Message-ID: <20220614220948.5f0b4827@kernel.org>
In-Reply-To: <YqlUCtJhR1Iw3o3F@lunn.ch>
References: <20220608093403.3999446-1-o.rempel@pengutronix.de>
        <YqS+zYHf6eHMWJlD@lunn.ch>
        <20220613125552.GA4536@pengutronix.de>
        <YqdQJepq3Klvr5n5@lunn.ch>
        <20220614185221.79983e9b@kernel.org>
        <YqlUCtJhR1Iw3o3F@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jun 2022 05:37:46 +0200 Andrew Lunn wrote:
> > Does this dovetail well with ETHTOOL_A_LINKSTATE_EXT_STATE /
> > ETHTOOL_A_LINKSTATE_EXT_SUBSTATE ?
> > 
> > That's where people who read extended link state out of FW put it
> > (and therefore it's read only now).  
> 
> I did wonder about that. But this is to do with autoneg which is part
> of ksetting. Firmware hindered MAC drivers also support ksetting
> set/get.  This patchset is also opening the door to more information
> which is passed via autoneg. It can also contain the ID the link peer
> PHY, etc. This is all part of 802.3, where as
> ETHTOOL_A_LINKSTATE_EXT_STATE tends to be whatever the firmware
> offers, not something covered by a standard.

I see, yeah, I think you're right.

But I'm missing the bigger picture. I'm unclear on who is supposed 
to be setting the fault user space or kernel / device?
Reading the codes it seems like most of them are hardware related,
and would get set by the kernel? Or are they expected to be set
by user space based on SQI / tests etc.?
Even for testing kernel can set it when it changes oper_state of 
the device.
