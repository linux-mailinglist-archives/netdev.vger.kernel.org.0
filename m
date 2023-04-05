Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D138A6D7CAB
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbjDEMcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238025AbjDEMcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:32:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F255B9D;
        Wed,  5 Apr 2023 05:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=R0oXmomB7CE455X2FHzGCtcL8upYdv/7BC030arTe9s=; b=Aq0Kq05NbpaT3FgQF09VSkWq90
        vjaB/TXCx4ewCShuCMYVBLYXnNCtPEvBkc4H6wfKd+AHZmzANfgx9EV4ofCkMlmyIjmzAnG8eXesO
        54U+A4HaZxxlp27LYexXLsW5HjIYsOnHvSKnfGb2qVcx06ZE7SE87Qm3XW0l0XsDKX6Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pk2J6-009WGo-Mv; Wed, 05 Apr 2023 14:32:08 +0200
Date:   Wed, 5 Apr 2023 14:32:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 00/12] Rework PHY reset handling
Message-ID: <da635af8-2052-40d5-846f-eda14af8c69b@lunn.ch>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 11:26:51AM +0200, Marco Felsch wrote:
> The current phy reset handling is broken in a way that it needs
> pre-running firmware to setup the phy initially. Since the very first
> step is to readout the PHYID1/2 registers before doing anything else.
> 
> The whole dection logic will fall apart if the pre-running firmware
> don't setup the phy accordingly or the kernel boot resets GPIOs states
> or disables clocks. In such cases the PHYID1/2 read access will fail and
> so the whole detection will fail.
> 
> I fixed this via this series, the fix will include a new kernel API
> called phy_device_atomic_register() which will do all necessary things
> and return a 'struct phy_device' on success. So setting up a phy and the
> phy state machine is more convenient.

Please add a section explaining why the current API is broken beyond
repair.  You need to justify adding a new call, rather than fixing the
existing code to just do what is necessary to allow the PHY to be
found.

	Andrew
