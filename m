Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76AD638CA4
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 15:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiKYOp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 09:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiKYOpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 09:45:40 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B2345A0C
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 06:44:25 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 6084D1B40;
        Fri, 25 Nov 2022 15:44:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1669387448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NkZcVOep0ooTgoue2QfFAN6OhB9Sx5HtmhGtHfVzhIY=;
        b=P03RubB1G7ILwvFR7kKVR/Tnj6KlxdO80BNwYti1GSajxf3yTH4ErnsjRvdqZfhLbTgVRk
        ze9xfEQnejAfoK1lWfxPkSfHKFgNI0Ukpbz0szMSd9T+JGZ+WXc0tvHBdxSHPNCOXL5awj
        yybEXtgUX5VDj3atiOjYKBt+vnOso43+ydQEmY7DHT30xFGs4tmqlL+Rn7PYOoncH1tdjX
        BynqixalH1FjVzyoCygG6dD1TgCNDdfQ2Dho4kkxwuYWKPG4Cx7w1WGOYVFjZrv2PNUZ/f
        1GWOFuJqASjtWNOwlflmx0yyblId1S+vFgK9qoQJEVm0GqDTKX5E3FAGa6BDGg==
MIME-Version: 1.0
Date:   Fri, 25 Nov 2022 15:44:08 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Xu Liang <lxu@maxlinear.com>
Subject: GPY215 PHY interrupt issue
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <fd1352e543c9d815a7a327653baacda7@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've been debugging an issue with spurious interrupts and it turns out
the GYP215 (possibly also other MaxLinear PHYs) has a problem with the
link down interrupt. Although the datasheet mentions (and which common
sense) a read of the interrupt status register will deassert the
interrupt line, the PHY doesn't deassert it right away. There is a
variable delay between reading the status register and the deassertion
of the interrupt line. This only happens on a link down event. The
actual delay depends on the firmware revision and is also somehow
random. With FW 7.71 (on a GPY215B) I've meassured around 40us with
FW 7.118 (GPY215B) it's about 2ms. It also varies from link down to
link down. The issue is also present in the new GPY215C revision.
MaxLinear confirmed the issue and is currently working on a firmware
fix. But it seems that the issue cannot really be resolved. At best,
the delay can be minimized. If there will be a fix, this is then
only for a GPY215C and a new firmware version.

Does anyone have an idea of a viable software workaround? The only
one I can think of is to disable the interrupts for the GPY215
altogether depending on the firmware version. For now, I haven't
described the interrupt line in the device tree. But that cannot be
the solution here ;)

If anyone is interested in the scope screenshots:
https://walle.cc/d10/gpy215_fw7_71_link_up_mdio.png
https://walle.cc/d10/gpy215_fw7_118_link_down_mdio1.png
https://walle.cc/d10/gpy215_fw7_71_link_down_mdio1.png
https://walle.cc/d10/gpy215c_fw8_111_link_down1.png

Red is MDIO, yellow is PHY_INT#, in all cases the second
transaction is the read interrupt status of the PHY which
asserts the interrupt line. Please note, that this is a
shared interrupt line. The first link shows the correct
behavior.

-michael
