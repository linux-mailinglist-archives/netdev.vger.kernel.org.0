Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762B14AC80E
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbiBGR7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345860AbiBGRxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:53:23 -0500
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619C8C0401E4
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:53:16 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 20F5C9C024C;
        Mon,  7 Feb 2022 12:45:47 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id rb8Maz7zMPDt; Mon,  7 Feb 2022 12:45:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id A6A339C024A;
        Mon,  7 Feb 2022 12:45:46 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8DbUYRRHGV_r; Mon,  7 Feb 2022 12:45:46 -0500 (EST)
Received: from sfl-deribaucourt.rennes.sfl (lfbn-ren-1-1441-98.w90-27.abo.wanadoo.fr [90.27.160.98])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id EED189C0207;
        Mon,  7 Feb 2022 12:45:45 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: [PATCH v2 0/2] net: phy: micrel: add Microchip KSZ 9897 Switch PHY
Date:   Mon,  7 Feb 2022 18:45:31 +0100
Message-Id: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2: I was on my way to convert the .phy_id_mask to PHY_ID_MATCH_EXACT()
following reviews, but I discovered that the datasheet actually contained=
 PHY id
registers but they do not correspond to RMII ports. I rechecked the phy_i=
d value
on my KSZ9897 and confirmed that I did not make this up. But this lead me=
 to
find that the KSZ8081 revision A2's datasheet shared the exact same phy_i=
d.
Hence, in order not to break compatibility with this model, I wrote a new=
 way to
differenciate them with the default LED MODE configuration instead of
PHY_ID_MATCH_EXACT() by mimicking ksz8051_ksz8795_match_phy_device().

I abstained from converting MICREL_PHY_ID_MASK to PHY_ID_MATCH_MODEL() be=
cause
it is used in other drivers, and would take a very long time to check all=
 the
datasheets of these models.

Thanks again to Andrew Lunn for your reviews and suggestions.

Original patch v1 discussion:
https://lore.kernel.org/all/20220204133635.296974-1-enguerrand.de-ribauco=
urt@savoirfairelinux.com/

---

Hi,
I've recently used a KSZ9897 DSA switch that was connected to an i.MX6 CP=
U
through SPI for the DSA control, and RMII as the data cpu-port. The SPI/D=
SA was
well supported in drivers/net/dsa/microchip/ksz9477.c, but the RMII conne=
ction
was not working. I would like to upstream the patch I developped to add s=
upport
for the KSZ9897 RMII bus. This is required for the cpu-port capability of
the DSA switch and have a complete support of this DSA switch.

Since PHY_ID_KSZ9897 and PHY_ID_KSZ8081 are very close, I had to modify t=
he mask
used for the latter. I don't have this one, so it would be very appreciat=
ed if
someone could test this patch with the KSZ8081 or KSZ8091. In particular,=
 I'd
like to know the exact phy_id used by those models to check that the new =
mask is
valid, and that they don't collide with the KSZ9897. The phy_ids cannot b=
e found
in the datasheet, so I couldn't verify that myself.

My definition of the struct phy_driver was copied from the similar
PHY_ID_KSZ8873MLL and proved to work on a 5.4 kernel. However, my patch m=
ay not
support the Gigabit Ethernet but works reliably otherwise.

The second patch fixes an issue with the KSZ9477 declaration I noticed. I
couldn't find PHY_ID_KSZ9477, or an equivalent mask in the MODULE_DEVICE_=
TABLE
declaration. I fear the driver is not initialized properly with this PHY.=
 I
don't have this model either so it would be great if someone could test t=
his.

