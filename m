Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648445B7C46
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 22:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiIMUqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 16:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiIMUqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 16:46:10 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC0C74BAD
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 13:46:08 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id n81so10219798iod.6
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 13:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=rq4Dj5U2n/e4bQ6bVsh9p/NIDkKotE6vqkg3NdNmgQc=;
        b=yUNlr9V2VMlazKr2AFUIdojFJQe/1zwQBWRwnll4SMA6keT5/+NEOAnBaAezR3tZVS
         uQsM7hUfAJLkLQtIlSn+L9G8p2V6fTeVRoq40rymniINmKHRNOaxpoyFQ0bUfPLc/mRa
         /cLePv18SohOmhcpXlSMEDwSLQ57HB2DE9Vr+wZfQxjrBcd9pwKJ6Erv7AcyFK8NFXsH
         hCUbPfL9M5KotHGvWK3C9g/IykV4t9KR5OVayPQmgARoOqlsUV8NJn9FW3YObjLEygyv
         j0VDx3+XfCD7Uvi3RipL6BrtvhactxgVRp56SwnxzuaxdJlU3/dFCKZL1OlaIecwYjpE
         NKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=rq4Dj5U2n/e4bQ6bVsh9p/NIDkKotE6vqkg3NdNmgQc=;
        b=tu/8t1Ewo+HjVff22RN8NNfWfBRc1ColNJ+TL+fab0tkO+AmvP+U+zBJXLWQFrJMdL
         gM5bfdsQaRdBO6iEQOFcUubrOQ+pKo0ktUGe6UV2fNv2kLkcQt8nGMfvtf/0SxkIDv6z
         4Z5SvAqSbw5PcMfZ4JHyVHKmvNR7GaR9x+4f3rqmXR2yIlFpHqq1qWtbdi/tKK8MuaHV
         OwOOkDf+ro84NCc642iPUJnD9UxQv/BI0phdu5Sm0UibN/O9zZXfR2Ry/dkCd9K5nYTJ
         asW11ZVDPA/e9qpGvFb1+WTcf+zuuQftovikOMPHB42phI1YqOYlFg/dm4TWuGi0GOtZ
         j2pA==
X-Gm-Message-State: ACgBeo309XIi0Z4yOcES7AvmmG/X5k5t9131WdVXgUIooFL5Ruh/mymN
        lOgk8ypIIaxY7Rb51xQRqDeyUg==
X-Google-Smtp-Source: AA6agR77Zj3Vu6lJq4Cvl0xtEib+fKXSPapmzcGGo8o7qp5DuWg5m02BD9x6+7Jcv4Vx4D9hlLDjMg==
X-Received: by 2002:a05:6602:c9:b0:6a1:4e25:8b0b with SMTP id z9-20020a05660200c900b006a14e258b0bmr4534623ioe.188.1663101967998;
        Tue, 13 Sep 2022 13:46:07 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id o35-20020a027423000000b0034286300316sm6009301jac.166.2022.09.13.13.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 13:46:06 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: ipa: properly limit modem routing table use
Date:   Tue, 13 Sep 2022 15:46:02 -0500
Message-Id: <20220913204602.1803004-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA can route packets between IPA-connected entities.  The AP and
modem are currently the only such entities supported, and no routing
is required to transfer packets between them.

The number of entries in each routing table is fixed, and defined at
initialization time.  Some of these entries are designated for use
by the modem, and the rest are available for the AP to use.  The AP
sends a QMI message to the modem which describes (among other
things) information about routing table memory available for the
modem to use.

Currently the QMI initialization packet gives wrong information in
its description of routing tables.  What *should* be supplied is the
maximum index that the modem can use for the routing table memory
located at a given location.  The current code instead supplies the
total *number* of routing table entries.  Furthermore, the modem is
granted the entire table, not just the subset it's supposed to use.

This patch fixes this.  First, the ipa_mem_bounds structure is
generalized so its "end" field can be interpreted either as a final
byte offset, or a final array index.  Second, the IPv4 and IPv6
(non-hashed and hashed) table information fields in the QMI
ipa_init_modem_driver_req structure are changed to be ipa_mem_bounds
rather than ipa_mem_array structures.  Third, we set the "end" value
for each routing table to be the last index, rather than setting the
"count" to be the number of indices.  Finally, instead of allowing
the modem to use all of a routing table's memory, it is limited to
just the portion meant to be used by the modem.  In all versions of
IPA currently supported, that is IPA_ROUTE_MODEM_COUNT (8) entries.

Update a few comments for clarity.

Fixes: 530f9216a9537 ("soc: qcom: ipa: AP/modem communications")
Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Update the element info arrays defining the modified QMI message
    so it uses the ipa_mem_bounds_ei structure rather than the
    ipa_mem_array_ei structure.  The message format is identical,
    but the code was incorrect without that change.

 drivers/net/ipa/ipa_qmi.c     |  8 ++++----
 drivers/net/ipa/ipa_qmi_msg.c |  8 ++++----
 drivers/net/ipa/ipa_qmi_msg.h | 37 ++++++++++++++++++++---------------
 drivers/net/ipa/ipa_table.c   |  2 --
 drivers/net/ipa/ipa_table.h   |  3 +++
 5 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index ec010cf2e816a..6f874f99b910c 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -308,12 +308,12 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_ROUTE);
 	req.v4_route_tbl_info_valid = 1;
 	req.v4_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v4_route_tbl_info.count = mem->size / sizeof(__le64);
+	req.v4_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE);
 	req.v6_route_tbl_info_valid = 1;
 	req.v6_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v6_route_tbl_info.count = mem->size / sizeof(__le64);
+	req.v6_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER);
 	req.v4_filter_tbl_start_valid = 1;
@@ -352,7 +352,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v4_hash_route_tbl_info_valid = 1;
 		req.v4_hash_route_tbl_info.start =
 				ipa->mem_offset + mem->offset;
-		req.v4_hash_route_tbl_info.count = mem->size / sizeof(__le64);
+		req.v4_hash_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE_HASHED);
@@ -360,7 +360,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v6_hash_route_tbl_info_valid = 1;
 		req.v6_hash_route_tbl_info.start =
 			ipa->mem_offset + mem->offset;
-		req.v6_hash_route_tbl_info.count = mem->size / sizeof(__le64);
+		req.v6_hash_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER_HASHED);
diff --git a/drivers/net/ipa/ipa_qmi_msg.c b/drivers/net/ipa/ipa_qmi_msg.c
index 6838e8065072b..75d3fc0092e92 100644
--- a/drivers/net/ipa/ipa_qmi_msg.c
+++ b/drivers/net/ipa/ipa_qmi_msg.c
@@ -311,7 +311,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.tlv_type	= 0x12,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   v4_route_tbl_info),
-		.ei_array	= ipa_mem_array_ei,
+		.ei_array	= ipa_mem_bounds_ei,
 	},
 	{
 		.data_type	= QMI_OPT_FLAG,
@@ -332,7 +332,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.tlv_type	= 0x13,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   v6_route_tbl_info),
-		.ei_array	= ipa_mem_array_ei,
+		.ei_array	= ipa_mem_bounds_ei,
 	},
 	{
 		.data_type	= QMI_OPT_FLAG,
@@ -496,7 +496,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.tlv_type	= 0x1b,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   v4_hash_route_tbl_info),
-		.ei_array	= ipa_mem_array_ei,
+		.ei_array	= ipa_mem_bounds_ei,
 	},
 	{
 		.data_type	= QMI_OPT_FLAG,
@@ -517,7 +517,7 @@ struct qmi_elem_info ipa_init_modem_driver_req_ei[] = {
 		.tlv_type	= 0x1c,
 		.offset		= offsetof(struct ipa_init_modem_driver_req,
 					   v6_hash_route_tbl_info),
-		.ei_array	= ipa_mem_array_ei,
+		.ei_array	= ipa_mem_bounds_ei,
 	},
 	{
 		.data_type	= QMI_OPT_FLAG,
diff --git a/drivers/net/ipa/ipa_qmi_msg.h b/drivers/net/ipa/ipa_qmi_msg.h
index 495e85abe50bd..9651aa59b5968 100644
--- a/drivers/net/ipa/ipa_qmi_msg.h
+++ b/drivers/net/ipa/ipa_qmi_msg.h
@@ -86,9 +86,11 @@ enum ipa_platform_type {
 	IPA_QMI_PLATFORM_TYPE_MSM_QNX_V01	= 0x5,	/* QNX MSM */
 };
 
-/* This defines the start and end offset of a range of memory.  Both
- * fields are offsets relative to the start of IPA shared memory.
- * The end value is the last addressable byte *within* the range.
+/* This defines the start and end offset of a range of memory.  The start
+ * value is a byte offset relative to the start of IPA shared memory.  The
+ * end value is the last addressable unit *within* the range.  Typically
+ * the end value is in units of bytes, however it can also be a maximum
+ * array index value.
  */
 struct ipa_mem_bounds {
 	u32 start;
@@ -129,18 +131,19 @@ struct ipa_init_modem_driver_req {
 	u8			hdr_tbl_info_valid;
 	struct ipa_mem_bounds	hdr_tbl_info;
 
-	/* Routing table information.  These define the location and size of
-	 * non-hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	/* Routing table information.  These define the location and maximum
+	 * *index* (not byte) for the modem portion of non-hashable IPv4 and
+	 * IPv6 routing tables.  The start values are byte offsets relative
+	 * to the start of IPA shared memory.
 	 */
 	u8			v4_route_tbl_info_valid;
-	struct ipa_mem_array	v4_route_tbl_info;
+	struct ipa_mem_bounds	v4_route_tbl_info;
 	u8			v6_route_tbl_info_valid;
-	struct ipa_mem_array	v6_route_tbl_info;
+	struct ipa_mem_bounds	v6_route_tbl_info;
 
 	/* Filter table information.  These define the location of the
 	 * non-hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	 * byte offsets relative to the start of IPA shared memory.
 	 */
 	u8			v4_filter_tbl_start_valid;
 	u32			v4_filter_tbl_start;
@@ -181,18 +184,20 @@ struct ipa_init_modem_driver_req {
 	u8			zip_tbl_info_valid;
 	struct ipa_mem_bounds	zip_tbl_info;
 
-	/* Routing table information.  These define the location and size
-	 * of hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	/* Routing table information.  These define the location and maximum
+	 * *index* (not byte) for the modem portion of hashable IPv4 and IPv6
+	 * routing tables (if supported by hardware).  The start values are
+	 * byte offsets relative to the start of IPA shared memory.
 	 */
 	u8			v4_hash_route_tbl_info_valid;
-	struct ipa_mem_array	v4_hash_route_tbl_info;
+	struct ipa_mem_bounds	v4_hash_route_tbl_info;
 	u8			v6_hash_route_tbl_info_valid;
-	struct ipa_mem_array	v6_hash_route_tbl_info;
+	struct ipa_mem_bounds	v6_hash_route_tbl_info;
 
 	/* Filter table information.  These define the location and size
-	 * of hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	 * of hashable IPv4 and IPv6 filter tables (if supported by hardware).
+	 * The start values are byte offsets relative to the start of IPA
+	 * shared memory.
 	 */
 	u8			v4_hash_filter_tbl_start_valid;
 	u32			v4_hash_filter_tbl_start;
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 2f5a58bfc529a..69efe672ca528 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -108,8 +108,6 @@
 
 /* Assignment of route table entries to the modem and AP */
 #define IPA_ROUTE_MODEM_MIN		0
-#define IPA_ROUTE_MODEM_COUNT		8
-
 #define IPA_ROUTE_AP_MIN		IPA_ROUTE_MODEM_COUNT
 #define IPA_ROUTE_AP_COUNT \
 		(IPA_ROUTE_COUNT_MAX - IPA_ROUTE_MODEM_COUNT)
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index b6a9a0d79d68e..1538e2e1732fe 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -13,6 +13,9 @@ struct ipa;
 /* The maximum number of filter table entries (IPv4, IPv6; hashed or not) */
 #define IPA_FILTER_COUNT_MAX	14
 
+/* The number of route table entries allotted to the modem */
+#define IPA_ROUTE_MODEM_COUNT	8
+
 /* The maximum number of route table entries (IPv4, IPv6; hashed or not) */
 #define IPA_ROUTE_COUNT_MAX	15
 
-- 
2.34.1

