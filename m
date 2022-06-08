Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83F9543F74
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 00:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiFHWte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 18:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiFHWtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 18:49:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA74228716;
        Wed,  8 Jun 2022 15:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18F51CE2C8A;
        Wed,  8 Jun 2022 22:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C22C34116;
        Wed,  8 Jun 2022 22:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654728551;
        bh=KoDfYZU8H3/Jk6nelCnyzGy1ViLp+HOvc80VTERRhLk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c47L61jNlPTTvhMermxgEoTOR9tWN65ALmSIUqWA/wuOeo+x67eQrpqH+NwJc5S+h
         PXtQCy08WczMlRL1nrqYaTzNO8rQ7ucEMUfc1fak2OFB8n3dUP4d+rjMPwR2VNbPH0
         Mf6l5WTxg4u1Kcn783ubkdYv2krRDz2t1vUTXPBVPXt9B8mkQ0GMHULzam2VTrceSn
         vNzj7lGKeQ8LZvsupIlQG5hs80ef3vrgPzzmPrVZUmCHf0eyTLpjvNj41LJJPA7k1D
         MGP0elVE6cT4SScOWE7iEvpStoF4640FLL1sX7CvK+m4RK4FHM2MPS5Q45TdRfX4j3
         QUGUYhF+ECwLQ==
Date:   Wed, 8 Jun 2022 15:49:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>
Subject: Re: [PATCH v2 0/9] deferred_probe_timeout logic clean up
Message-ID: <20220608154908.4ddb9795@kernel.org>
In-Reply-To: <CAGETcx8UO=4mk31tU4QaWU3RaNM_myA9woe0idBp6p7+X5AEgg@mail.gmail.com>
References: <20220601070707.3946847-1-saravanak@google.com>
        <CAMuHMdXkX-SXtBuTRGJOUnpw9goSP6RFr_PTt_3w_yWgBpWsqg@mail.gmail.com>
        <CAGETcx9f0UBhpp6dM+KJwtYpLx19wwsq6_ygi3En7FrXobOSpA@mail.gmail.com>
        <CAGETcx8VM+xOCe7HEx9FUU-1B9nrX8Q=tE=NjTyb9uX2_8RXLQ@mail.gmail.com>
        <CAMuHMdXzu8Vp=a7fyjOB=xt04aee=vWXV=TcRZeeKUGYFFZ1CA@mail.gmail.com>
        <CAGETcx_Nqo4ju7cWwO3dP3YM2wpCb0jx23OHOReexOjpT5pATA@mail.gmail.com>
        <CAMuHMdXQCwMQj_ZiOBAzusdCxd8w6NbTqD_7nzykhVs+UWx8Gw@mail.gmail.com>
        <CAGETcx8UO=4mk31tU4QaWU3RaNM_myA9woe0idBp6p7+X5AEgg@mail.gmail.com>
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

On Wed, 8 Jun 2022 14:07:44 -0700 Saravana Kannan wrote:
> David/Jakub,
> 
> Do the IP4 autoconfig changes look reasonable to you?

I'm no expert in this area, I'd trust the opinion of the embedded folks
(adding Florian as well) more than myself. It's unclear to me why we'd
wait_for_init_devices_probe() after the first failed iteration, sleep,
and then allow 11 more iterations with wait_for_device_probe().

Let me also add Thomas since he wrote e2ffe3ff6f5e ("net: ipconfig:
Wait for deferred device probes").
