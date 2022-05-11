Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF187523854
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344458AbiEKQPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244950AbiEKQPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:15:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE32A6B098;
        Wed, 11 May 2022 09:15:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7718461BBB;
        Wed, 11 May 2022 16:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C18C340EE;
        Wed, 11 May 2022 16:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652285716;
        bh=Ca4uNIMYCkcCVvV5JTRUJtd7HnJoFqZvdUrgMli7fpA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ikv/A7sjbhOV4kIRLpKbOKwM+SyBWFHvkUQImOTKTJLB/JoYqNZApe2JjzTkhngp4
         iov0O3dhU2vfKAW3Dj9oXqc71EvUB1dVpCkSBHfangCzrN3cDnsEpJIyDlj+A3iDqm
         HCihkrCeMIuQVqDgNsSl4amizk4nCuj6PKK71cTUIuqEz7123ctPG6V2lW22IQpzrg
         79HS014Fa4RO1MrzczHiwZ5r1R1Rg7ftAwSGALyRUEJmuLs6ANkQSxDsEptt7F3iJQ
         7vyCE5HOoMB0imh17kw7Rh6Ic4Gme954jEcyB8SGS5ejEq2NemgcvFJGO0ajLngdzi
         s8dzrK5rqisow==
Date:   Wed, 11 May 2022 09:15:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>
Subject: Re: [PATCH net-next v2 5/7] usbnet: smsc95xx: Forward PHY
 interrupts to PHY driver to avoid polling
Message-ID: <20220511091514.11601299@kernel.org>
In-Reply-To: <20220511092616.GA22613@wunner.de>
References: <cover.1651574194.git.lukas@wunner.de>
        <c6b7f4e4a17913d2f2bc4fe722df0804c2d6fea7.1651574194.git.lukas@wunner.de>
        <20220505113207.487861b2@kernel.org>
        <20220511092616.GA22613@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 11:26:16 +0200 Lukas Wunner wrote:
> > IRQ maintainers could you cast your eyes over this?  
> 
> Thomas applied 792ea6a074ae ("genirq: Remove WARN_ON_ONCE() in
> generic_handle_domain_irq()") tonight:
> 
> http://git.kernel.org/tip/tip/c/792ea6a074ae

Perfect!

> That allows me to drop the controversial __irq_enter_raw().
> 
> Jakub, do you want me to resend the full series (all 7 patches)
> or should I send only patch [5/7] in-reply-to this one here?
> Or do you prefer applying all patches except [5/7] and have me
> resend that single patch?
> 
> Let me know what your preferred modus operandi is.

Resending all patches would be the easiest for us and has the lowest
chance of screw up on our side, so resend all please & thanks!
