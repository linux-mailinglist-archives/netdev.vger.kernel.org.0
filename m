Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2FE6774F2
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 06:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjAWFcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 00:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjAWFb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 00:31:57 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0473EC69
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 21:31:55 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id t12-20020a17090aae0c00b00229f4cff534so5628024pjq.1
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 21:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A0fz9zHVDO2m4yGb0WkSftssKbcC8YshpBpIYHhLj7c=;
        b=YtpYWKD1RCi3cTP3XrrnB/WHttQVmyq0+fxnE232LMmf6udL+pQAqDDKcRjxAb4wMf
         6Hvrj9ybI4YT+EuV5AkugIFht0gh0UOT2mWN8lnqKCqeSZjfQOMuIgDtQ1DHIxlz7uXp
         sWpuVFXofqwKkV6JrdJotO5kgr6ypRwjcHfPs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A0fz9zHVDO2m4yGb0WkSftssKbcC8YshpBpIYHhLj7c=;
        b=srAsSIgbEpveaL7OlGWyBiEyaV60OAgDsORJdrp/gul018sqqYWsQm2cv2JVPm5Zno
         6SQsDuWTjegLoehIyQkXYRago97vcqVwIpKU8q4QPJvFV02bEzU4HHsx17zY+KSzgRL1
         Iq0FzmfRbZpQ3kHUNGkIsvzzpflCRk5UQZ/8B/X+ONzUP90d/p82vqNNfRVImFX1X/Zs
         vWRUuZx10Hj9I+HA6q8EiaF1ISj/gVVgTXXQXHslA1bGvBUjVoD872yIEIHdJv73D/1i
         FWKvIawjRXU4R3TpxTb+9zrXBYqzTwWSKjMHwTYulhD9rzOzXFZObTId7hDSZ3wYj6e+
         VXrw==
X-Gm-Message-State: AFqh2kqbnTLZ1WCQwbMMTECcjJm+4US3KgTqZO3skJrJW0BmdZ7lXnVp
        9ixON80xv8KixGjBLxiRcuR3xg==
X-Google-Smtp-Source: AMrXdXusvSxSXsCftAbS8TjS01eWzPAOdRLnzG++9siaPiVBq7PGYvPhjJV7xS1Ofhvxus2zcCY59g==
X-Received: by 2002:a05:6a20:9f09:b0:b8:c6ec:a269 with SMTP id mk9-20020a056a209f0900b000b8c6eca269mr24710795pzb.16.1674451915198;
        Sun, 22 Jan 2023 21:31:55 -0800 (PST)
Received: from doug-ryzen-5700G.. ([192.183.212.197])
        by smtp.gmail.com with ESMTPSA id m3-20020a170902db0300b0018963b8e131sm9125244plx.290.2023.01.22.21.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 21:31:54 -0800 (PST)
From:   Doug Brown <doug@schmorgal.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dan Williams <dcbw@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Doug Brown <doug@schmorgal.com>
Subject: [PATCH v4 2/4] wifi: libertas: only add RSN/WPA IE in lbs_add_wpa_tlv
Date:   Sun, 22 Jan 2023 21:31:30 -0800
Message-Id: <20230123053132.30710-3-doug@schmorgal.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230123053132.30710-1-doug@schmorgal.com>
References: <20230123053132.30710-1-doug@schmorgal.com>
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
index 3e065cbb0af9..3f35dc7a1d7d 100644
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
+	wpatlv->header.type = cpu_to_le16(wpaie->id);
+	wpatlv->header.len = cpu_to_le16(wpaie->datalen);
+	memcpy(wpatlv->data, wpaie->data, wpaie->datalen);
+
+	/* Return the total number of bytes added to the TLV buffer */
+	return sizeof(struct mrvl_ie_header) + wpaie->datalen;
 }
 
 /*
-- 
2.34.1

