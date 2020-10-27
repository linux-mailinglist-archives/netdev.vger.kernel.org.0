Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B029429BAD1
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1807689AbgJ0QNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:13:04 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:38332 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1807528AbgJ0QLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 12:11:32 -0400
Received: by mail-il1-f196.google.com with SMTP id x7so567114ili.5
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 09:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ad72dxioIj0WvztwIzeKe/eV2acq7ZrfSLr7+KsEV38=;
        b=VRwwuISiYiZN11L+3Px0fVLbhozomhs+sqQ56pf9DCaS76YnvjAoCSbSaXpZ1bj+BU
         GLUvCOJBOJhbKZgAh26jmy53SJzfZAmgY9Rxnm58kbf93qUmwBpkVVQXpcINgjWbTBx6
         CuBWaZt1ZJLkMrtLBqDR0oqlchnUxhGyciwBDRzy4klsq6PXntwT5GoWxbt4SjQ/tT0V
         QWcrazgS0EIm+inQu975p7lUAI9yXhjh6KdKQOr4CgkifgjCR31jo6EqQUfPzfc0RLi6
         lBF+TB7w90/31GTBgyLnKYRxDoL8IiH4cq9OItqOhGykMYpPj4FKnY/4k/2ZciPctSf/
         yWKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ad72dxioIj0WvztwIzeKe/eV2acq7ZrfSLr7+KsEV38=;
        b=LMfRZL/aSetsBqoyWA2kfqmmabs8u4kDgzfSoXrXKOpv6UmW5/c9vOTeIS/uOwSO9O
         WyB+yMZx7gHGMJcoYRfYL06rXxlpqH9hhPMOBVTjNDjiwkIbFeXyOKUIuOhZX9sLmdw8
         s+W9S/M9lDyRSeiUnPOvjhaRAweseYcoMP+uaibm7DGLgjPjMi0T7P6GzVioeqFFlVW1
         oFgQdoe9izh0E1jGw04zzfcR3i7b7QngafF6nTJTWQuVsqOTAjG7fOlKwq+/dVLM+Xlf
         vcpIndZotFASIngaO3otyP9mzsXds6xf2cVrrcm5/yIZ2y68iqHYqTkwKDUvmLjXEs0+
         BYEQ==
X-Gm-Message-State: AOAM530WGUU7YHDPW6prMhuOHkmjlIcYJjFKAxUFw20C5YHls3YL/fqR
        Ot1/oKb7er2eWAxg4zay53393A==
X-Google-Smtp-Source: ABdhPJzk6E0qpw177yElmVAtBNKUbp7dtI1iF/Sy1UZKDvQ56hpn+d3QEKE5N2XORaoJVC7/JKogvA==
X-Received: by 2002:a92:494c:: with SMTP id w73mr2514250ila.104.1603815091319;
        Tue, 27 Oct 2020 09:11:31 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w15sm1082264iom.6.2020.10.27.09.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 09:11:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 3/5] net: ipa: assign endpoint to a resource group
Date:   Tue, 27 Oct 2020 11:11:18 -0500
Message-Id: <20201027161120.5575-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201027161120.5575-1-elder@linaro.org>
References: <20201027161120.5575-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPA hardware manages various resources (e.g. descriptors)
internally to perform its functions.  The resources are grouped,
allowing different endpoints to use separate resource pools.  This
way one group of endpoints can be configured to operate unaffected
by the resource use of endpoints in a different group.

Endpoints should be assigned to a resource group, but we currently
don't do that.

Define a new resource_group field in the endpoint configuration
data, and use it to assign the proper resource group to use for
each AP endpoint.

Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c |  4 ++++
 drivers/net/ipa/ipa_data-sdm845.c |  4 ++++
 drivers/net/ipa/ipa_data.h        |  2 ++
 drivers/net/ipa/ipa_endpoint.c    | 11 +++++++++++
 4 files changed, 21 insertions(+)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index d4c2bc7ad24bf..37dada4da6808 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -24,6 +24,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.seq_type	= IPA_SEQ_DMA_ONLY,
 			.config = {
+				.resource_group	= 0,
 				.dma_mode	= true,
 				.dma_endpoint	= IPA_ENDPOINT_AP_LAN_RX,
 			},
@@ -42,6 +43,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.seq_type	= IPA_SEQ_INVALID,
 			.config = {
+				.resource_group	= 0,
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
@@ -65,6 +67,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.seq_type	=
 				IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP,
 			.config = {
+				.resource_group	= 0,
 				.checksum	= true,
 				.qmap		= true,
 				.status_enable	= true,
@@ -88,6 +91,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.seq_type	= IPA_SEQ_INVALID,
 			.config = {
+				.resource_group	= 0,
 				.checksum	= true,
 				.qmap		= true,
 				.aggregation	= true,
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index de2768d71ab56..a9a992404b39f 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -26,6 +26,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.seq_type	= IPA_SEQ_DMA_ONLY,
 			.config = {
+				.resource_group	= 1,
 				.dma_mode	= true,
 				.dma_endpoint	= IPA_ENDPOINT_AP_LAN_RX,
 			},
@@ -44,6 +45,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.seq_type	= IPA_SEQ_INVALID,
 			.config = {
+				.resource_group	= 1,
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
@@ -67,6 +69,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.seq_type	=
 				IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP,
 			.config = {
+				.resource_group	= 1,
 				.checksum	= true,
 				.qmap		= true,
 				.status_enable	= true,
@@ -90,6 +93,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.seq_type	= IPA_SEQ_INVALID,
 			.config = {
+				.resource_group	= 1,
 				.checksum	= true,
 				.qmap		= true,
 				.aggregation	= true,
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 7fc1058a5ca93..d084a83069db2 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -109,6 +109,7 @@ struct ipa_endpoint_rx_data {
 
 /**
  * struct ipa_endpoint_config_data - IPA endpoint hardware configuration
+ * @resource_group:	resource group to assign endpoint to
  * @checksum:		whether checksum offload is enabled
  * @qmap:		whether endpoint uses QMAP protocol
  * @aggregation:	whether endpoint supports aggregation
@@ -119,6 +120,7 @@ struct ipa_endpoint_rx_data {
  * @rx:			RX-specific endpoint information (see above)
  */
 struct ipa_endpoint_config_data {
+	u32 resource_group;
 	bool checksum;
 	bool qmap;
 	bool aggregation;
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index b40b711cf4bd5..7386e10615d99 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -751,6 +751,16 @@ static void ipa_endpoint_init_deaggr(struct ipa_endpoint *endpoint)
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
+static void ipa_endpoint_init_rsrc_grp(struct ipa_endpoint *endpoint)
+{
+	u32 offset = IPA_REG_ENDP_INIT_RSRC_GRP_N_OFFSET(endpoint->endpoint_id);
+	struct ipa *ipa = endpoint->ipa;
+	u32 val;
+
+	val = rsrc_grp_encoded(ipa->version, endpoint->data->resource_group);
+	iowrite32(val, ipa->reg_virt + offset);
+}
+
 static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 {
 	u32 offset = IPA_REG_ENDP_INIT_SEQ_N_OFFSET(endpoint->endpoint_id);
@@ -1328,6 +1338,7 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 	ipa_endpoint_init_mode(endpoint);
 	ipa_endpoint_init_aggr(endpoint);
 	ipa_endpoint_init_deaggr(endpoint);
+	ipa_endpoint_init_rsrc_grp(endpoint);
 	ipa_endpoint_init_seq(endpoint);
 	ipa_endpoint_status(endpoint);
 }
-- 
2.20.1

