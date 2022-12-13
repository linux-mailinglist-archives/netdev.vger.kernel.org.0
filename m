Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150D664B714
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 15:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235835AbiLMOOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 09:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbiLMOOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 09:14:12 -0500
Received: from mail.rosalinux.ru (mail.rosalinux.ru [195.19.76.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30928EA7;
        Tue, 13 Dec 2022 06:12:39 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rosalinux.ru (Postfix) with ESMTP id ABDB75D46449;
        Tue, 13 Dec 2022 17:11:17 +0300 (MSK)
Received: from mail.rosalinux.ru ([127.0.0.1])
        by localhost (mail.rosalinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id C3-AkuSBZ0QK; Tue, 13 Dec 2022 17:11:17 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.rosalinux.ru (Postfix) with ESMTP id 770C85D46455;
        Tue, 13 Dec 2022 17:11:17 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rosalinux.ru 770C85D46455
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rosalinux.ru;
        s=1D4BB666-A0F1-11EB-A1A2-F53579C7F503; t=1670940677;
        bh=NBPMYEaaLH5R+99CmkIyf3c/V2azpfSSPiOU7qSM5x4=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=TwrXXglvtP3bo3T+TBAYEv/pNkgkVlLMJVa9wTT7Eb9FUWiV0PPILNx5MP1BEHQzl
         C4JoLkZR1ZIYs4UIU8kauJAWELPcE8rl1KGQJZXKzchfy97+4n4An1DWGgC93kQdVY
         NjdNiBffF8zrflf/KYfMBNihvi1mNkScRyC3EgerTEhNNpH5B1sSKPHlsNXz1ziCfe
         tUbSqyIOHFJKsvVrIkF2BArhL8KRY1cZCBU0l42uN0uoy2cMShFR5ktydl3lE0ikUs
         2z/5J+75PkQMT+ZRrYQYAeBvYbWmTRYHBLuvca/5w8kHpssTH9hd0Mha/fJsZSIgz2
         7YEee1tzbkvJA==
X-Virus-Scanned: amavisd-new at rosalinux.ru
Received: from mail.rosalinux.ru ([127.0.0.1])
        by localhost (mail.rosalinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yq_WSSdlXZ1e; Tue, 13 Dec 2022 17:11:17 +0300 (MSK)
Received: from localhost.localdomain (unknown [80.75.131.190])
        by mail.rosalinux.ru (Postfix) with ESMTPSA id 025795D46449;
        Tue, 13 Dec 2022 17:11:16 +0300 (MSK)
From:   Aleksandr Burakov <a.burakov@rosalinux.ru>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc:     Aleksandr Burakov <a.burakov@rosalinux.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] nfc: st-nci: array index overflow in st_nci_se_get_bwi()
Date:   Tue, 13 Dec 2022 09:12:28 -0500
Message-Id: <20221213141228.101786-1-a.burakov@rosalinux.ru>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Index of info->se_info.atr can be overflow due to unchecked increment
in the loop "for". The patch checks the value of current array index
and doesn't permit increment in case of the index is equal to
ST_NCI_ESE_MAX_LENGTH - 1.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: ed06aeefdac3 ("nfc: st-nci: Rename st21nfcb to st-nci")
Signed-off-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
---
 drivers/nfc/st-nci/se.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index ec87dd21e054..ff8ac1784880 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -119,10 +119,11 @@ static u8 st_nci_se_get_bwi(struct nci_dev *ndev)
 	/* Bits 8 to 5 of the first TB for T=3D1 encode BWI from zero to nine *=
/
 	for (i =3D 1; i < ST_NCI_ESE_MAX_LENGTH; i++) {
 		td =3D ST_NCI_ATR_GET_Y_FROM_TD(info->se_info.atr[i]);
-		if (ST_NCI_ATR_TA_PRESENT(td))
+		if (ST_NCI_ATR_TA_PRESENT(td) && i < ST_NCI_ESE_MAX_LENGTH - 1)
 			i++;
 		if (ST_NCI_ATR_TB_PRESENT(td)) {
-			i++;
+			if (i < ST_NCI_ESE_MAX_LENGTH - 1)
+				i++;
 			return info->se_info.atr[i] >> 4;
 		}
 	}
--=20
2.35.1

