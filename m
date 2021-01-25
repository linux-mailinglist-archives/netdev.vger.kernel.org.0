Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9434F303022
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732865AbhAYX2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732615AbhAYVbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 16:31:14 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E825EC06178A
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:29:55 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id y19so29620701iov.2
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U2sFIZtfJJ0QC3wGockY2PpSjOlVKhMWufupSAbCHfM=;
        b=HsoNMJjY0ptFTHawJovVbdo1QvUvx9PhrtAZ6L6h1g1m6G7S9GFWrsTCw4kZGubZdn
         nIoQEdms4zJbAQFuqF1gpw50hs+7mRMH4LxVDmu/cKQU3VVeJWslp/V0LvM1mgrSKuy7
         6WTPkeBsafEiAUh1wGI+RjTpGdtKe0D84QO3P/+Fn9LMhKVsxMKbk4S5tuZ8bQUy/Wu6
         RRFxlMa4Pw4PuvzlrHUTaQvxP4exslRv5lqIuIiCKLRoSXZPru0MxRARMN8Kcl3VTMDj
         9ghslcKvgaVZITssbx7OMA79nEJw9lJaCu0bQ6R8/PHuiEqxpQkZalFcN2S5hMX1YIjT
         z16A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U2sFIZtfJJ0QC3wGockY2PpSjOlVKhMWufupSAbCHfM=;
        b=Lgv3xAYzwlYMJe4XcbKdMuL3pMIbqVR1LiYpvpLna4J9xge+BVoS4Ge+SGZzleCzHW
         OyC4xmhDmjsH9IY+7I7p501tsm3KJFVZ565nJmROcJ1ogCWDdxlsMgTStBPJBSZSql3s
         4Pq+47MT2R9K8+P4VhFVNHvvyE5O3bkcUz0uuVtaZXN3eNeOXfRjqILQun5QYoLe4SCi
         /EMlLaq5ZvydJl3w6qXKpm1U78RpJX0p3XakMO1eZmv+bFcoNlOrBxri0oxbMiHyVLfZ
         zTJCNrPcAIx66vrK7iRHyL33fT4SCzaE060CsViB5Uh0oasvX0k0Q4mU90WXVw+PBmud
         aLwA==
X-Gm-Message-State: AOAM531c37npk2r4UgVhSrnsYWJvWHFVtftazAbDMVTh6x+wqHQk83BQ
        v+bs723N0TrrccD/iVgOxfSpfQ==
X-Google-Smtp-Source: ABdhPJwP/V1jgGaBUV0O14grNW5IDNvFYdbq+qUncFxBb0kvhir3BCgU/lIT5beImnvo0VooNC8/Ww==
X-Received: by 2002:a05:6602:154e:: with SMTP id h14mr1952503iow.1.1611610195348;
        Mon, 25 Jan 2021 13:29:55 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o18sm11136241ioa.39.2021.01.25.13.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 13:29:54 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: drop packet if status has valid tag
Date:   Mon, 25 Jan 2021 15:29:44 -0600
Message-Id: <20210125212947.17097-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210125212947.17097-1-elder@linaro.org>
References: <20210125212947.17097-1-elder@linaro.org>
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
 drivers/net/ipa/ipa_endpoint.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index c5524215054c8..f1764768f0602 100644
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
+	return !!(status->mask & IPA_STATUS_MASK_TAG_VALID_FMASK);
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

