Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D2E6A5D5F
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjB1Qpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjB1Qpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:45:45 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3E934033
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:45:36 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 8F83C3CF;
        Tue, 28 Feb 2023 17:45:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1677602704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1mR+R1sZqxbQDImYO5fktPk6wHsPPKnFAmMEOpH7N2I=;
        b=kQEd8ieNgxXh7OFMvp6TackrTpxu3YMbzE0g5HRgH2JkyCbkxYnSGA8PVob7k8tiK8Fv6h
        oxp3luzVHJszbpm0V72p2XA7t5xbJWacIYDty2sOXNGvwySThv2z/L9tLgKbUxVI7QdtQ9
        ipPWdlw0FYql6B/YOMteHiIU7zgYoJsws8gUfZgWo1o+BQ9U0Q6WbdObEjU2TaYuDybLFg
        L2C0nSOMfkhYZQJmLmqJ9Lz5QPaKfXUfN8xQi5u9n7RAnv5FrW5/AcgiHprnL/ZKHzDz8P
        siERDuuLGGwSSk1elqGxjG4EC/Mett2JKS/RJLdXvJbjil5NrrxdeBC+2xEWAg==
From:   Michael Walle <michael@walle.cc>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kory.maincent@bootlin.com, kuba@kernel.org,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, thomas.petazzoni@bootlin.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support [multicast/DSA issues]
Date:   Tue, 28 Feb 2023 17:44:35 +0100
Message-Id: <20230228164435.133881-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
References: <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> 4. Letting drivers override PHY at run time.
>
> I think this is the only sensible solution - we know for example that
> mvpp2 will prefer its PTP implementation as it is (a) higher resolution
> and (b) has more flexibility than what can be provided by the Marvell
> PHYs that it is often used with.

Please also consider that there might be one switch with a shared
PHC and multiple PHYs, each with its own PHC. In this case, it is a
property of the board wether PHY timestamping actually works, because
it will need some kind of synchronization between all the PHYs. Whereas
the MAC timestamping just works. Or we dodge that problem now and these
kind of drivers might not use PHY timestamping. But AFAIK microchip is
working on PHY timestamping for their quad PHYs which are used together
with a LAN9668 switch.

-michael
