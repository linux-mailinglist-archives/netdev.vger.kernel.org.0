Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2603767BD3C
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 21:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbjAYUpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 15:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236474AbjAYUpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 15:45:53 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEF52711
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:45:52 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id u8so3975ilq.13
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g9R16wmdsFSlARpIkw628eYGQEzi5HtCrjZCjEhr1Wc=;
        b=QM7n20Ibckf+f+Vc+/CdeIjOQ+T1RMhNd67UeASRLILDWRJ2vZBlJWqhxN28dMTUDi
         3CbYo20udJjfxR+Uhtk96FVqnb6UPt90X2R6GQhThkyghuTYLZ29BdSAx6H9Sy2q7Lwh
         E/t3E0FNJ+olmtndhbIJZ8BimzIdQ67wAByLZj1DblQILaggcX+vonHbSY/jHhod6HQo
         +4tjZ0W8OQmJDANnd0ML08Vl8DLl6LR0bD9afrCMmYuVVfF99iiE2TFMG/7e0sWmOb+k
         Azd42vcc/O/Z5EzZUopnqG9vYUlO0tWJS0o5CPqTQwZpj1O4m1VXrFVJm4UmdM251P06
         2Tjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g9R16wmdsFSlARpIkw628eYGQEzi5HtCrjZCjEhr1Wc=;
        b=6gASRwxoGdiqorgJD9qgSidw/nTyu2f8wEAtXaQ940mVcpFw6qqv4qifM+0F5o1OQ5
         w4WpWyN2xwn8eEgsNN1SBQeEx+xwkRK1RCEAWi2ZEVVaz+X/KJVicPsMbEE08xbZC3q5
         EBjyoB3X/Jz/gkn99YnmYnGWhDS1qLls1TC89U+WKC9UcNMKawbx+Au4CXCneq48J+3T
         dbtGu2Su8qeJLPi47fa890/aqpr7ST5/XCgQYRLbCHECzW+8gxS8iz4Yp7ForMexBAPO
         j1bT/7r8txhNKdsrGYHkdZ5NGFVaQr8n8gpIXtaFrxdLqhvfRwkfjrXXcQAmwAtbvL14
         j0Vw==
X-Gm-Message-State: AO0yUKWos/Xrve3D9h3WunIVBsNZIqQQrEtOblu1ip3s/i9TJPncuCAe
        WpE6y5NLr28y454dw15HB+5oeQ==
X-Google-Smtp-Source: AK7set8yUNgrw8GsgLvvmWr/rD62mY/NcoD5S4iNAvSBFMxu3sOi8yEandYnRrpkoKznzMFcuO4+nA==
X-Received: by 2002:a05:6e02:1d06:b0:310:7c6c:8660 with SMTP id i6-20020a056e021d0600b003107c6c8660mr7037503ila.4.1674679551501;
        Wed, 25 Jan 2023 12:45:51 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id w14-20020a02968e000000b00389c2fe0f9dsm1960696jai.85.2023.01.25.12.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 12:45:51 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/8] net: ipa: stop using sizeof(status)
Date:   Wed, 25 Jan 2023 14:45:39 -0600
Message-Id: <20230125204545.3788155-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230125204545.3788155-1-elder@linaro.org>
References: <20230125204545.3788155-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPA packet status structure changes in IPA v5.0 in ways that are
difficult to represent cleanly.  As a small step toward redefining
it as a parsed block of data, use a constant to define its size,
rather than the size of the IPA status structure type.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 3756ce5f3f310..dd4b2b073aae9 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -70,6 +70,9 @@ struct ipa_status {
 #define IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK	GENMASK(31, 22)
 #define IPA_STATUS_FLAGS2_TAG_FMASK		GENMASK_ULL(63, 16)
 
+/* Size in bytes of an IPA packet status structure */
+#define IPA_STATUS_SIZE			sizeof(__le32[4])
+
 /* Compute the aggregation size value to use for a given buffer size */
 static u32 ipa_aggr_size_kb(u32 rx_buffer_size, bool aggr_hard_limit)
 {
@@ -1397,18 +1400,18 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 		u32 align;
 		u32 len;
 
-		if (resid < sizeof(*status)) {
+		if (resid < IPA_STATUS_SIZE) {
 			dev_err(&endpoint->ipa->pdev->dev,
 				"short message (%u bytes < %zu byte status)\n",
-				resid, sizeof(*status));
+				resid, IPA_STATUS_SIZE);
 			break;
 		}
 
 		/* Skip over status packets that lack packet data */
 		length = le16_to_cpu(status->pkt_len);
 		if (!length || ipa_endpoint_status_skip(endpoint, status)) {
-			data += sizeof(*status);
-			resid -= sizeof(*status);
+			data += IPA_STATUS_SIZE;
+			resid -= IPA_STATUS_SIZE;
 			continue;
 		}
 
@@ -1419,7 +1422,7 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 		 * computed checksum information will be appended.
 		 */
 		align = endpoint->config.rx.pad_align ? : 1;
-		len = sizeof(*status) + ALIGN(length, align);
+		len = IPA_STATUS_SIZE + ALIGN(length, align);
 		if (endpoint->config.checksum)
 			len += sizeof(struct rmnet_map_dl_csum_trailer);
 
@@ -1428,7 +1431,7 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 			u32 extra;
 
 			/* Client receives only packet data (no status) */
-			data2 = data + sizeof(*status);
+			data2 = data + IPA_STATUS_SIZE;
 
 			/* Have the true size reflect the extra unused space in
 			 * the original receive buffer.  Distribute the "cost"
-- 
2.34.1

