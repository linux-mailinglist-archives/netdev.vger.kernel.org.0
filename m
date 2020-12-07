Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DAB2D17DE
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 18:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgLGRut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 12:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgLGRut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 12:50:49 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA09C061749;
        Mon,  7 Dec 2020 09:50:08 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c79so10780741pfc.2;
        Mon, 07 Dec 2020 09:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fUh+4z+VG104kmWgXIS5rqWmBazf/fgwAB8pUJ1DNuA=;
        b=UlrCb3xvzoJdzfZ/x97NJoC+q5KmaKK5qmIm/e9mnRKf4ruOBR8zuVbm3I64wvyd89
         I5PLl4yG4mZaoF2h2sAcMIyHlA2UeoMv+OPzrXMdxrNEyUb1+I2trvKE8BQjMEkc4oId
         thTDnk4SxHBflzpt7BDQRIq0Fl7mHODojBX+pDx42WkfhKACy38gyASMcgfeLYN90MZa
         Wh6uDrHMNCu7zjondL0zE+tTyOUOxx7sz49NeDSQE5QA/y0h63/QeeQSn/CwYSA5Q6V0
         XtC5hvOizHVQzChRHFgDobP1LMT8k3mV++VFdJeP0+wbTOI/AFDTTz6Dr1ewWVGtog5s
         kGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fUh+4z+VG104kmWgXIS5rqWmBazf/fgwAB8pUJ1DNuA=;
        b=Qi27/ZDu9DaqzmOWevXVcl5bi6k6TPfgmRF6iwMXKkGaeKitlpkmiDXFjnzdLIHR4P
         2uLRvIZo5QqiTnm/F/bBZv9dKFt0ic2YneK6e3G1/phmc1GNkGSnPPGeLLG2gVsVZ1ue
         LBr9sEeQLQxfSrlYYGelN+J751PSLZq+wSsrCov2X+g9m0RDAWrdcLyxr41o7Gv5WPnO
         cj/39tMZu4GLx4/b+ZAfTFLRVMv27IPCW/rKN+upaf2pkoqiyvSVKoJU0vLxWzi0lq1C
         O18uj5f2k8XuvrE4H3PUiRzu0pL9lqrRWt0nAODc6EtCzUIlvDZGy3+BY+vOih4XKh3u
         fu7g==
X-Gm-Message-State: AOAM532AmMSODgS+nMO6uhlHtlKcG0V4EVBdUcRXVy9sEJOWZ39s5dMV
        qJvDt5gkbC/jdklyC1xsBJ8=
X-Google-Smtp-Source: ABdhPJwBijIrVQscb6Ya9OufTg3mUKcb0mMt8o0C3jf0JEr+I1L3N8iMAzO6A6Ux6a/QtxvY99NvIg==
X-Received: by 2002:a17:902:8b8c:b029:d8:de6f:ed35 with SMTP id ay12-20020a1709028b8cb02900d8de6fed35mr17502376plb.36.1607363408343;
        Mon, 07 Dec 2020 09:50:08 -0800 (PST)
Received: from DESKTOP-6EISONM.localdomain ([143.248.2.153])
        by smtp.gmail.com with ESMTPSA id mr7sm11173651pjb.31.2020.12.07.09.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 09:50:07 -0800 (PST)
From:   Mincheol Son <encrypted.def@gmail.com>
To:     marcel@holtmann.org
Cc:     johan.hedberg@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mincheol Son <encrypted.def@gmail.com>
Subject: [PATCH] Bluetooth: smp: Fix biased random passkey generation
Date:   Tue,  8 Dec 2020 02:49:57 +0900
Message-Id: <20201207174957.408-1-encrypted.def@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since u32 range size is not a multiple of 1,000,000, current passkey generation logic is biased.

Fixed this by adding a routine that selects passkey again if passkey is 4,200,000,000 or more.

Signed-off-by: Mincheol Son <encrypted.def@gmail.com>
---
 net/bluetooth/smp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index c659c464f7ca..26ed83e0db34 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -922,7 +922,9 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
 	/* Generate random passkey. */
 	if (smp->method == CFM_PASSKEY) {
 		memset(smp->tk, 0, sizeof(smp->tk));
-		get_random_bytes(&passkey, sizeof(passkey));
+		do {
+			get_random_bytes(&passkey, sizeof(passkey));
+		} while (passkey >= (u32)4200000000);
 		passkey %= 1000000;
 		put_unaligned_le32(passkey, smp->tk);
 		BT_DBG("PassKey: %d", passkey);
-- 
2.25.1

