Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC55304D8B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732367AbhAZXKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732110AbhAZS5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 13:57:51 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AECCC06178A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 10:57:11 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id u17so35865315iow.1
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 10:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s57J/xOFhvFT/dyDrXRhATPPv+j4to5KF2lppSb4o8g=;
        b=ZXj3KnRJ+AZ2oQv2hFwmxefm0sC68as2h+Om3u7UOUUgj0xSGu2PBFrOC9ybY9B9mR
         PBPaXPHGoiLFeBvex0wWol7uYTm7gIylX0nMvNuT/KD2B9ASwddajdQdXGnogeQn7H0o
         LJhXxNVaxqlf/Oa7jbQeh+v7XbJQKhkHFKFNsYmfyfdMoxyOXfygun3EcLiJ8bN0Omk4
         eEQQDAGwn+EiYR2WcQpTjk6kyCY1LFVcBJOkK/HQCZ+bXNwxXl7ZRpaQs/oVZrHL7AfD
         ln5AIFhgWcqUHcvUlmHIp1iWBG5h21bpCHNsXQq8T5eh8byKtqbS32V0gY+0O/phDR8M
         yzQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s57J/xOFhvFT/dyDrXRhATPPv+j4to5KF2lppSb4o8g=;
        b=SPEw4h0rXx5M8eB2/lSc2qiXw/1aSM2/iCUMHnDep+J8DwkSzhvQzdXPXLe56Ak+pL
         VnESj/gz0RLv3fLl+vDP/p/isiC4vHqqOevUxIDqO7E4Z9+7PaQwNdmwL/2v+b+oUDrr
         Dkr4Q0/rip8Qw6OxXw+g+M/FeqMI2/VlqSdNieu7XsaF5gGB231vAsipomwYO1NLsMDw
         8NX5AOdoqwAlc0d+qfAHgI1DbRKg3ExbvnS9oJ7gLfJ2kNivudWCFZYXGaFj82AxRqU3
         kOGJVeZTkAIUGcSnZ5OazvilrsfhlBFlxdgBvaZqN7i/2UDPLd908canCSMp5+UldyJo
         Cggg==
X-Gm-Message-State: AOAM530qfsuXiOAgsHh55Hs6V1TY4aD9cz9qz0xukoyNfk9vB4eYNhcJ
        A75ptTWBjtIcDE1omHd8HgvX4g==
X-Google-Smtp-Source: ABdhPJwzjzL6SPuRvYcTaKjp4ZgB3S6hJkrZC+DodSVJlvG+qQYk39E1wSYOtAtJwWTx2NQbVKU39g==
X-Received: by 2002:a05:6638:3006:: with SMTP id r6mr6228829jak.72.1611687430604;
        Tue, 26 Jan 2021 10:57:10 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l14sm13060681ilh.58.2021.01.26.10.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 10:57:10 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/6] net: ipa: drop packet if status has valid tag
Date:   Tue, 26 Jan 2021 12:57:00 -0600
Message-Id: <20210126185703.29087-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210126185703.29087-1-elder@linaro.org>
References: <20210126185703.29087-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ipa_endpoint_status_tag(), which returns true if received
status indicates its tag field is valid.  The endpoint parameter is
not yet used.

Call this from ipa_status_drop_packet(), and drop the packet if the
status indicates the tag was valid.  Pass the endpoint pointer to
ipa_status_drop_packet(), and rename it ipa_endpoint_status_drop().
The endpoint will be used in the next patch.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Use le16_get_bits() to access the status mask tag field properly.

 drivers/net/ipa/ipa_endpoint.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index c5524215054c8..68970a3baa47a 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -69,8 +69,11 @@ struct ipa_status {
 };
 
 /* Field masks for struct ipa_status structure fields */
+#define IPA_STATUS_MASK_TAG_VALID_FMASK		GENMASK(4, 4)
+#define IPA_STATUS_SRC_IDX_FMASK		GENMASK(4, 0)
 #define IPA_STATUS_DST_IDX_FMASK		GENMASK(4, 0)
 #define IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK	GENMASK(31, 22)
+#define IPA_STATUS_FLAGS2_TAG_FMASK		GENMASK_ULL(63, 16)
 
 #ifdef IPA_VALIDATE
 
@@ -1172,11 +1175,22 @@ static bool ipa_endpoint_status_skip(struct ipa_endpoint *endpoint,
 	return false;	/* Don't skip this packet, process it */
 }
 
+static bool ipa_endpoint_status_tag(struct ipa_endpoint *endpoint,
+				    const struct ipa_status *status)
+{
+	return !!le16_get_bits(status->mask, IPA_STATUS_MASK_TAG_VALID_FMASK);
+}
+
 /* Return whether the status indicates the packet should be dropped */
-static bool ipa_status_drop_packet(const struct ipa_status *status)
+static bool ipa_endpoint_status_drop(struct ipa_endpoint *endpoint,
+				     const struct ipa_status *status)
 {
 	u32 val;
 
+	/* If the status indicates a tagged transfer, we'll drop the packet */
+	if (ipa_endpoint_status_tag(endpoint, status))
+		return true;
+
 	/* Deaggregation exceptions we drop; all other types we consume */
 	if (status->exception)
 		return status->exception == IPA_STATUS_EXCEPTION_DEAGGR;
@@ -1225,7 +1239,7 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 		if (endpoint->data->checksum)
 			len += sizeof(struct rmnet_map_dl_csum_trailer);
 
-		if (!ipa_status_drop_packet(status)) {
+		if (!ipa_endpoint_status_drop(endpoint, status)) {
 			void *data2;
 			u32 extra;
 			u32 len2;
-- 
2.20.1

