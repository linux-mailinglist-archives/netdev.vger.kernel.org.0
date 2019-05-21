Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F1B24B42
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 11:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfEUJMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 05:12:32 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33066 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfEUJMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 05:12:31 -0400
Received: by mail-pf1-f195.google.com with SMTP id z28so8768842pfk.0;
        Tue, 21 May 2019 02:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WFNnK9H0K3Ber2neUCNJ4Uwp9UCDDXpkHqDNEykoK1U=;
        b=W644JxlBVI3+KbYZ/4msgiMKep2yUr1vVE8T9T59526jPWWcWIAodg0uZrPmJmvQ2P
         JGI1l5zrMJpy+g1HaUtg9Do8pAKqYRUHUUxrDP9n1RUWZzrHJQeIZJ2yN/g9YIoMY8LN
         gKr1o3vOv4ployX/pkhR4dwSEh8YzODeZp57kseFQ5jr8achYT3s5L6tY2Q17D476kFM
         R3f750EXEkhfDIEDlJFpmoaV3GtUmgxmWr/BMGE79REiPKy8RmnsNhZtQayV5S0OmPuw
         /eZKGY2dbp3HZtONbwJ/iycJXh2ifSCI07nfof9iRV9xEpnr3XIkqu4hJ30xthX1gj5u
         oPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WFNnK9H0K3Ber2neUCNJ4Uwp9UCDDXpkHqDNEykoK1U=;
        b=BBgeVD+maijPnOoo5YMOdPzzh7hQfqWB4qL8FG92785zmZS4B0w4I8ZFIlS9GfG7am
         NLllu2fbcuieiD890dZnOYgVEbLHa1KU7EAzGgZNmFM7FQE688Tq+orCBP/L4Wq407Tw
         Srnx+aQAX1dJv/znkGrEkB1pmIX7KZIegmlH3eTtcobwGsf0EZBJyH4rcWPpGjNdLGUU
         f7z5J5sN/M+7nVa3ewWakAm+LfH3qUcN8UPyjb+mlEIfC/m5Ebo0b6bunSDqPuaLOn+U
         /tLKy8kNrV3xmLgmzi+X82UceWBn0glD/Ks1YDDq2UFQBwv1ZoA98xrR1fgkW2LymfFA
         OmLQ==
X-Gm-Message-State: APjAAAWU2b39BcABs0mlGdHqs7i2BQw83loIDoEWoHVyq6qANLiL2NMM
        tLVsjzgwxHIJF6l/0NoTZ/0=
X-Google-Smtp-Source: APXvYqzOAOrYS9rJhvcv1i/2h2CrHY8ltTh6nYiFU1m7HP097CbBxTgHa0DVHHQxMdoRZvpYb2g74Q==
X-Received: by 2002:a65:42ca:: with SMTP id l10mr27448771pgp.181.1558429951093;
        Tue, 21 May 2019 02:12:31 -0700 (PDT)
Received: from localhost ([115.82.227.102])
        by smtp.gmail.com with ESMTPSA id 129sm23870702pff.140.2019.05.21.02.12.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 02:12:30 -0700 (PDT)
From:   neojou@gmail.com
To:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net,
        rafal@milecki.pl, hdegoedg@redhat.com,
        p.figiel@camlintechnologies.com
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@braodcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>
Subject: [PATCH] brcmfmac: use strlcpy() instead of strcpy()
Date:   Tue, 21 May 2019 17:12:20 +0800
Message-Id: <1558429940-8709-1-git-send-email-neojou@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neo Jou <neojou@gmail.com>

The function strcpy() is inherently not safe. Though the function
works without problems here, it would be better to use other safer
function, e.g. strlcpy(), to replace strcpy() still.

Signed-off-by: Neo Jou <neojou@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 96b8d5b..9e0bd2b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -269,7 +269,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 
 	/* query for 'ver' to get version info from firmware */
 	memset(buf, 0, sizeof(buf));
-	strcpy(buf, "ver");
+	strlcpy(buf, "ver", sizeof(buf));
 	err = brcmf_fil_iovar_data_get(ifp, "ver", buf, sizeof(buf));
 	if (err < 0) {
 		bphy_err(drvr, "Retrieving version information failed, %d\n",
-- 
2.7.4

