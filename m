Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EEE8D2B5
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 14:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfHNMGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 08:06:33 -0400
Received: from ns.omicron.at ([212.183.10.25]:50962 "EHLO ns.omicron.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfHNMGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 08:06:33 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Aug 2019 08:06:31 EDT
Received: from MGW02-ATKLA.omicron.at ([172.25.62.35])
        by ns.omicron.at (8.15.2/8.15.2) with ESMTPS id x7EC0xog008592
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 14:00:59 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 ns.omicron.at x7EC0xog008592
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=omicronenergy.com;
        s=default; t=1565784059;
        bh=hvJjyGDbLwQ/MBXPFq7wvY87wg5nsLk7BNsIoy2YOZk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=UAtGOLrqRu0Ho3CrHK9fjKTdUkPAZjBst/hoJFX/fYcI8Ple3ao198jijlieLSmSb
         DKf0BHKnJtvoLc21Q9vnie3MD4YrRkhmEYX4sKRwta5UoYV00PrWWEDsKKEmG4Ehh7
         tCwGi8A3RrqG/msItJqAtDGxhMrWMq4jhxiYU+no=
Received: from MGW02-ATKLA.omicron.at (localhost [127.0.0.1])
        by MGW02-ATKLA.omicron.at (Postfix) with ESMTP id 24B3DA0054
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 14:00:59 +0200 (CEST)
Received: from MGW01-ATKLA.omicron.at (unknown [172.25.62.34])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by MGW02-ATKLA.omicron.at (Postfix) with ESMTPS id 22D41A0068
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 14:00:59 +0200 (CEST)
Received: from EXC04-ATKLA.omicron.at ([172.22.100.189])
        by MGW01-ATKLA.omicron.at  with ESMTP id x7EC0xFH001055-x7EC0xFJ001055
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=CAFAIL);
        Wed, 14 Aug 2019 14:00:59 +0200
Received: from manrud11.omicron.at (172.22.24.34) by EXC04-ATKLA.omicron.at
 (172.22.100.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 14 Aug
 2019 14:00:57 +0200
From:   Manfred Rudigier <manfred.rudigier@omicronenergy.com>
To:     <davem@davemloft.net>
CC:     <jeffrey.t.kirsher@intel.com>, <carolyn.wyborny@intel.com>,
        <todd.fujinaka@intel.com>, <netdev@vger.kernel.org>,
        Manfred Rudigier <manfred.rudigier@omicronenergy.com>
Subject: [PATCH net 2/2] igb: Fix constant media auto sense switching when no cable is connected.
Date:   Wed, 14 Aug 2019 13:59:09 +0200
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814115909.20839-1-manfred.rudigier@omicronenergy.com>
References: <20190814115909.20839-1-manfred.rudigier@omicronenergy.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.22.24.34]
X-ClientProxiedBy: EXC04-ATKLA.omicron.at (172.22.100.189) To
 EXC04-ATKLA.omicron.at (172.22.100.189)
Message-ID: <d3d16e6d-fa28-4842-b353-405ea432fd37@EXC04-ATKLA.omicron.at>
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At least on the i350 there is an annoying behavior that is maybe also
present on 82580 devices, but was probably not noticed yet as MAS is not
widely used.

If no cable is connected on both fiber/copper ports the media auto sense
code will constantly swap between them as part of the watchdog task and
produce many unnecessary kernel log messages.

The swap code responsible for this behavior (switching to fiber) should
not be executed if the current media type is copper and there is no signa=
l
detected on the fiber port. In this case we can safely wait until the
AUTOSENSE_EN bit is cleared.

Signed-off-by: Manfred Rudigier <manfred.rudigier@omicronenergy.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethe=
rnet/intel/igb/igb_main.c
index 95fc1a178ff3..891cd072d4dd 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2064,7 +2064,8 @@ static void igb_check_swap_media(struct igb_adapter=
 *adapter)
 	if ((hw->phy.media_type =3D=3D e1000_media_type_copper) &&
 	    (!(connsw & E1000_CONNSW_AUTOSENSE_EN))) {
 		swap_now =3D true;
-	} else if (!(connsw & E1000_CONNSW_SERDESD)) {
+	} else if ((hw->phy.media_type !=3D e1000_media_type_copper) &&
+	    !(connsw & E1000_CONNSW_SERDESD)) {
 		/* copper signal takes time to appear */
 		if (adapter->copper_tries < 4) {
 			adapter->copper_tries++;
--=20
2.22.0

