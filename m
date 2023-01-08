Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210AF6612E7
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 02:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbjAHBbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 20:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbjAHBbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 20:31:00 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF763633D
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 17:30:59 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r18so3636603pgr.12
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 17:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gZnUzt96M2CHw2T17VotljT7ugAqa2z/W5TDXEKxdek=;
        b=a8Aw21mdqnBwiNQAC6YlwGKZTGrHdKVqz7GMHC9WUOUEApaCqM9bbx4CS0jeBEldiO
         3EbAzVDuDCdpzpp4FLt15YdjwnY7FuBVjvKBr6HMWCbkMH6r73KxFhqJH0611ipJ9njb
         ZFFIyOAUDrNACu+h+usurCdIeGQ07p40ATepQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gZnUzt96M2CHw2T17VotljT7ugAqa2z/W5TDXEKxdek=;
        b=HFA1nbkGufiv+wkto43IqlTUHZSi5AhPhqTb38LCbck5lwIVoyc0eZotNVtJz8/nfE
         s/z3INV3O4kEmuj66Qf+4Gl9dwCOeVV2XW+JzVLXsyyPS1sjffrjb1hUyTVnAAtyyMDI
         CCPpn3qT+k4amn5VYnUdKBNUBMH9rVOj1nEK9iOlxerwAmMBTnq0GkFgyVr3AQogoYTI
         E9sPmGnR+tJ7SzUblOwOzgTO8Mnv7xXLTm2EsPIbWhfJe5cd+rtrWT2+n7GZ/h2NQbER
         yK9JEw31ALXaQpU5QDiXOq5zOc9fsLUp2oR8FjSGAD7E4B9Avq8zZrPkBX2lfqIg2FEW
         3MtQ==
X-Gm-Message-State: AFqh2ko+lmQHKWvpflpUni8oURWK0JldiDVGPGO+YSkkbX1CGSm1duVw
        KdeqrSWPVd1fRh2wD5IyJxgCMw==
X-Google-Smtp-Source: AMrXdXsNEgSj+Fg3BAhdyK6itnO+JVw3YnT/0zGRBxhPgoZOvT438HNfu2sNa85PNKDMAjBFdJafhg==
X-Received: by 2002:a05:6a00:1485:b0:574:251b:c5fe with SMTP id v5-20020a056a00148500b00574251bc5femr71889826pfu.20.1673141458702;
        Sat, 07 Jan 2023 17:30:58 -0800 (PST)
Received: from doug-ryzen-5700G.. ([192.183.212.197])
        by smtp.gmail.com with ESMTPSA id x14-20020aa79a4e000000b005811c421e6csm3323714pfj.162.2023.01.07.17.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 17:30:58 -0800 (PST)
From:   Doug Brown <doug@schmorgal.com>
To:     Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Doug Brown <doug@schmorgal.com>
Subject: [PATCH v2 2/4] wifi: libertas: only add RSN/WPA IE in lbs_add_wpa_tlv
Date:   Sat,  7 Jan 2023 17:30:14 -0800
Message-Id: <20230108013016.222494-3-doug@schmorgal.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230108013016.222494-1-doug@schmorgal.com>
References: <20230108013016.222494-1-doug@schmorgal.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing code only converts the first IE to a TLV, but it returns a
value that takes the length of all IEs into account. When there is more
than one IE (which happens with modern wpa_supplicant versions for
example), the returned length is too long and extra junk TLVs get sent
to the firmware, resulting in an association failure.

Fix this by finding the first RSN or WPA IE and only adding that. This
has the extra benefit of working properly if the RSN/WPA IE isn't the
first one in the IE buffer.

While we're at it, clean up the code to use the available structs like
the other lbs_add_* functions instead of directly manipulating the TLV
buffer.

Signed-off-by: Doug Brown <doug@schmorgal.com>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 28 +++++++++++++--------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 3e065cbb0af9..5cd78fefbe4c 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -416,10 +416,20 @@ static int lbs_add_cf_param_tlv(u8 *tlv)
 
 static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
 {
-	size_t tlv_len;
+	struct mrvl_ie_data *wpatlv = (struct mrvl_ie_data *)tlv;
+	const struct element *wpaie;
+
+	/* Find the first RSN or WPA IE to use */
+	wpaie = cfg80211_find_elem(WLAN_EID_RSN, ie, ie_len);
+	if (!wpaie)
+		wpaie = cfg80211_find_vendor_elem(WLAN_OUI_MICROSOFT,
+						  WLAN_OUI_TYPE_MICROSOFT_WPA,
+						  ie, ie_len);
+	if (!wpaie || wpaie->datalen > 128)
+		return 0;
 
 	/*
-	 * We need just convert an IE to an TLV. IEs use u8 for the header,
+	 * Convert the found IE to a TLV. IEs use u8 for the header,
 	 *   u8      type
 	 *   u8      len
 	 *   u8[]    data
@@ -428,14 +438,12 @@ static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
 	 *   __le16  len
 	 *   u8[]    data
 	 */
-	*tlv++ = *ie++;
-	*tlv++ = 0;
-	tlv_len = *tlv++ = *ie++;
-	*tlv++ = 0;
-	while (tlv_len--)
-		*tlv++ = *ie++;
-	/* the TLV is two bytes larger than the IE */
-	return ie_len + 2;
+	wpatlv->header.type = wpaie->id;
+	wpatlv->header.len = wpaie->datalen;
+	memcpy(wpatlv->data, wpaie->data, wpaie->datalen);
+
+	/* Return the total number of bytes added to the TLV buffer */
+	return sizeof(struct mrvl_ie_header) + wpaie->datalen;
 }
 
 /*
-- 
2.34.1

