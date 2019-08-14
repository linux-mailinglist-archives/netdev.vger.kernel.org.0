Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBC38D2B6
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 14:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfHNMGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 08:06:36 -0400
Received: from ns.omicron.at ([212.183.10.25]:50962 "EHLO ns.omicron.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfHNMGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 08:06:34 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Aug 2019 08:06:31 EDT
Received: from MGW02-ATKLA.omicron.at ([172.25.62.35])
        by ns.omicron.at (8.15.2/8.15.2) with ESMTPS id x7EC0nuG008548
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 14:00:49 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 ns.omicron.at x7EC0nuG008548
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=omicronenergy.com;
        s=default; t=1565784049;
        bh=oPpHsECv+N0KTQ7Kf9fRwgYsOdQ9YqGNqRqs5CULTY0=;
        h=From:To:CC:Subject:Date:From;
        b=aPtiMtE76+Ogd4Bd93fcfMU9i719yjBYSd2CU3VF+3xEmTByGclsOyUM/ZsoXLN2f
         qri92YiFQtIeaGcTtRwtGp5pQ97JP9ob4IlNipDXRywsIGZbRkTywcraUyl9KCPXIj
         FKCA1xT6UapV6fWkALJH/Xot49E+5v2OqMQXaWkA=
Received: from MGW02-ATKLA.omicron.at (localhost [127.0.0.1])
        by MGW02-ATKLA.omicron.at (Postfix) with ESMTP id 2979AA0054
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 14:00:49 +0200 (CEST)
Received: from MGW01-ATKLA.omicron.at (unknown [172.25.62.34])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by MGW02-ATKLA.omicron.at (Postfix) with ESMTPS id 24302A0064
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 14:00:49 +0200 (CEST)
Received: from EXC04-ATKLA.omicron.at ([172.22.100.189])
        by MGW01-ATKLA.omicron.at  with ESMTP id x7EC0nHX001041-x7EC0nHZ001041
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=CAFAIL);
        Wed, 14 Aug 2019 14:00:49 +0200
Received: from manrud11.omicron.at (172.22.24.34) by EXC04-ATKLA.omicron.at
 (172.22.100.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 14 Aug
 2019 14:00:44 +0200
From:   Manfred Rudigier <manfred.rudigier@omicronenergy.com>
To:     <davem@davemloft.net>
CC:     <jeffrey.t.kirsher@intel.com>, <carolyn.wyborny@intel.com>,
        <todd.fujinaka@intel.com>, <netdev@vger.kernel.org>,
        Manfred Rudigier <manfred.rudigier@omicronenergy.com>
Subject: [PATCH net 1/2] igb: Enable media autosense for the i350.
Date:   Wed, 14 Aug 2019 13:59:08 +0200
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.22.24.34]
X-ClientProxiedBy: EXC04-ATKLA.omicron.at (172.22.100.189) To
 EXC04-ATKLA.omicron.at (172.22.100.189)
Message-ID: <f50fd188-fe43-4bd7-aaa4-4c1c8cb022c3@EXC04-ATKLA.omicron.at>
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables the hardware feature "Media Auto Sense" also on the
i350. It works in the same way as on the 82850 devices. Hardware designs
using dual PHYs (fiber/copper) can enable this feature by setting the MAS
enable bits in the NVM_COMPAT register (0x03) in the EEPROM.

Signed-off-by: Manfred Rudigier <manfred.rudigier@omicronenergy.com>
---
 drivers/net/ethernet/intel/igb/e1000_82575.c | 2 +-
 drivers/net/ethernet/intel/igb/igb_main.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/e=
thernet/intel/igb/e1000_82575.c
index 3ec2ce0725d5..8a6ef3514129 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -466,7 +466,7 @@ static s32 igb_init_mac_params_82575(struct e1000_hw =
*hw)
 			? igb_setup_copper_link_82575
 			: igb_setup_serdes_link_82575;
=20
-	if (mac->type =3D=3D e1000_82580) {
+	if (mac->type =3D=3D e1000_82580 || mac->type =3D=3D e1000_i350) {
 		switch (hw->device_id) {
 		/* feature not supported on these id's */
 		case E1000_DEV_ID_DH89XXCC_SGMII:
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethe=
rnet/intel/igb/igb_main.c
index b4df3e319467..95fc1a178ff3 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2370,7 +2370,7 @@ void igb_reset(struct igb_adapter *adapter)
 		adapter->ei.get_invariants(hw);
 		adapter->flags &=3D ~IGB_FLAG_MEDIA_RESET;
 	}
-	if ((mac->type =3D=3D e1000_82575) &&
+	if ((mac->type =3D=3D e1000_82575 || mac->type =3D=3D e1000_i350) &&
 	    (adapter->flags & IGB_FLAG_MAS_ENABLE)) {
 		igb_enable_mas(adapter);
 	}
--=20
2.22.0

