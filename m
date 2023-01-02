Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09ECE65B846
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 00:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjABXrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 18:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjABXrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 18:47:45 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D99C9597
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:47:44 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 17so30962644pll.0
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 15:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=schmorgal.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JOJePOLkyAub1OvU/RtVRIRBGDGjX/Knwa0G9aCvK9s=;
        b=ZYt8DQVSZohU3I0vAylSd9bi1vQm+NcPY+p4d/TXR7MnuEtEm24YUpSjHjOIcDLX2V
         gz/wDIbcdcYPlWE16IfcUL5NQvnehBWzYaZDC/jw5KscbimTIbfbjok57XegeTkkQv7y
         RcxDwlTo4GhRu6xiLzYM8OL91iSsTVUrr/tnI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JOJePOLkyAub1OvU/RtVRIRBGDGjX/Knwa0G9aCvK9s=;
        b=KqWEornJ5jH87VMZH51Xy6KUA9H9dKuI8Ga7Gvh5bi6Xp7ABY+dCo8hBBkcVQ2Biwk
         J1lM/yqBss+zr3NxBmKg+2Er+FWuiHJvE8kAhL12BtzUSshukTJdMd0hkxQOlnA7LrvA
         Z4f2GDNkto9qe14xge/c16Hu87LSB42wwsVzxD0tccUIpZp6MJqIyfREyFNCVFL7fbKp
         QwB3TkLXn4RICyzi841l9+6cYtMZq1If49IzSi2sspZZ0MMBopnIqlVYaVeg9ylEv0yP
         STN99ZMnWaZK62bmIArDc7orwE4/f0/pJKXtMwJlF7icofjmDlLNbKm2itaPVotn99fk
         nICQ==
X-Gm-Message-State: AFqh2kocVsZOtnwKtNcFCzNlhCOaf5/ysIanJdr1WKU4ZYRG2gxcGhf8
        hInbv272ipYRDgwrUj7uX82paA==
X-Google-Smtp-Source: AMrXdXuKdqOGbB1H+6tUZLmpw/v3LZcT9KUPcGSFcbvMXfu5Pi30fyYkmwSsZ15nTn9w+dEMLgj/Qg==
X-Received: by 2002:a17:902:ca89:b0:190:ead0:7b1d with SMTP id v9-20020a170902ca8900b00190ead07b1dmr40471588pld.42.1672703263954;
        Mon, 02 Jan 2023 15:47:43 -0800 (PST)
Received: from doug-ryzen-5700G.. ([192.183.212.197])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902684400b00189f69c1aa0sm20739531pln.270.2023.01.02.15.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 15:47:43 -0800 (PST)
From:   Doug Brown <doug@schmorgal.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Doug Brown <doug@schmorgal.com>
Subject: [PATCH] wifi: libertas: return consistent length in lbs_add_wpa_tlv()
Date:   Mon,  2 Jan 2023 15:47:14 -0800
Message-Id: <20230102234714.169831-1-doug@schmorgal.com>
X-Mailer: git-send-email 2.34.1
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

Fix this by returning a length that only factors in the single IE that
was converted. The firmware doesn't seem to support the additional IEs,
so there is no value in trying to convert them to additional TLVs.

Fixes: e86dc1ca4676 ("Libertas: cfg80211 support")
Signed-off-by: Doug Brown <doug@schmorgal.com>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 3e065cbb0af9..fcc5420ec7ea 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -432,10 +432,9 @@ static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
 	*tlv++ = 0;
 	tlv_len = *tlv++ = *ie++;
 	*tlv++ = 0;
-	while (tlv_len--)
-		*tlv++ = *ie++;
-	/* the TLV is two bytes larger than the IE */
-	return ie_len + 2;
+	memcpy(tlv, ie, tlv_len);
+	/* the TLV has a four-byte header */
+	return tlv_len + 4;
 }
 
 /*
-- 
2.34.1

