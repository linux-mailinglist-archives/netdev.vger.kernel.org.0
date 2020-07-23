Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B356522A652
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 06:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgGWD7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 23:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgGWD7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 23:59:52 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4374C0619E1
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 20:59:52 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id F0F1F891AE;
        Thu, 23 Jul 2020 15:59:50 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1595476790;
        bh=GYrgwdy9HxEFRNvvN5BSWUNM2GgwbbW2QZdiyLeAqjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=SQ1GR1OR9V/AtFiLIIELOcXqk7FbpOutB/49hUfkz8UCXufjkqaycQ5GnTLIF/N0S
         9fw+RlAvvKntVH9SZBDvQhJlOscV5QzNCiufPY4BE+h2p4cIU9jrl20f+fqfFcAeN1
         l58iklhPOw9C6dMqWC0yHi5eRnTpnCl9bNMdIlz9k4YtnLPgCOpwdXdEb/lSGLJNA1
         XSIyUATaJ7tkL/Vvhn1UCCcXn/qW3m0V9gE3/G+fwUnPROW+qQQXAJgDxVvtbXCWQI
         xnG+7eVrHFEBrCgOlJfDKcp4wFDKDx3O6+/si6sR/hQiToo4G1WcqNvrXJA6Ux7ZDm
         OWwZ3yGUpXk3g==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f190b370001>; Thu, 23 Jul 2020 15:59:51 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 9A5DB13EEA1;
        Thu, 23 Jul 2020 15:59:49 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id CA658280079; Thu, 23 Jul 2020 15:59:50 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 2/4] net: dsa: mv88e6xxx: Support jumbo configuration on 6190/6190X
Date:   Thu, 23 Jul 2020 15:59:40 +1200
Message-Id: <20200723035942.23988-3-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
References: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MV88E6190 and MV88E6190X both support per port jumbo configuration
just like the other GE switches. Install the appropriate ops.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

I'm including this change in my series for completeness. Looking at the
datasheets I think this is an unintentional omission but I don't have act=
ual
hardware to test this change on so some testing from someone with access =
to the
right chip would be appreciated.

 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index fbfa4087eb7b..c2a4ac99545d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3933,6 +3933,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops =3D=
 {
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods =3D mv88e6352_port_set_egress_floods,
 	.port_set_ether_type =3D mv88e6351_port_set_ether_type,
+	.port_set_jumbo_size =3D mv88e6165_port_set_jumbo_size,
 	.port_pause_limit =3D mv88e6390_port_pause_limit,
 	.port_disable_learn_limit =3D mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override =3D mv88e6xxx_port_disable_pri_override,
@@ -3991,6 +3992,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops =3D=
 {
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods =3D mv88e6352_port_set_egress_floods,
 	.port_set_ether_type =3D mv88e6351_port_set_ether_type,
+	.port_set_jumbo_size =3D mv88e6165_port_set_jumbo_size,
 	.port_pause_limit =3D mv88e6390_port_pause_limit,
 	.port_disable_learn_limit =3D mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override =3D mv88e6xxx_port_disable_pri_override,
--=20
2.27.0

