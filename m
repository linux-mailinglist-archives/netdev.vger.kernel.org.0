Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6636E5B0912
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiIGPqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiIGPqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:46:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719696E2E8
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M3j2ti94ulcMEx9Tac54YYCFvFTHx7LCXv/0luMg6Iw=;
        b=KPDM+pTvNd6ahMUkziYw4tBSiJoIwi4YUgHpgXGxI1z7dLDv+ox/MR+dR62Ol0Aq4lwamj
        WI5Wm4ui/pvz26sHzwz5AnGLOyV9TTRuSKETzcVSqOjjUi/03E4qypy9pPlHbXWo0g+0Tr
        LeB+y9cXm5jROIMEVRrwvmf0ImM1EEw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-UiJN6ZCfMv644hMeL_EwWA-1; Wed, 07 Sep 2022 11:46:13 -0400
X-MC-Unique: UiJN6ZCfMv644hMeL_EwWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9D4F101A54E;
        Wed,  7 Sep 2022 15:46:12 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F08340B40CB;
        Wed,  7 Sep 2022 15:46:12 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 6AE6230721A6C;
        Wed,  7 Sep 2022 17:46:11 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 14/18] i40e: Add xdp_hints_union
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Date:   Wed, 07 Sep 2022 17:46:11 +0200
Message-ID: <166256557140.1434226.13138556693050092410.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The union named "xdp_hints_union" must contain all the xdp_hints_*
struct's available in this driver. This is used when decoding the
modules BTF to identify the available XDP-hints struct's. As metadata
grows backwards padding are needed for proper alignment. This alignment
is verified by compile time checks via BUILD_BUG_ON().

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c |   31 +++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index d945ac122d4c..e21f3ff4c811 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1953,6 +1953,36 @@ struct xdp_hints_i40e_timestamp {
 	struct xdp_hints_i40e base;
 };
 
+/* xdp_hints_union defines xdp_hints_* structs available in this driver.
+ * As metadata grows backwards structure are padded to align.
+ */
+union xdp_hints_union {
+	struct xdp_hints_i40e_timestamp i40e_ts;
+	struct {
+		u64 pad1_ts;
+		struct xdp_hints_i40e i40e;
+	};
+	struct {
+		u64 pad2_ts;
+		u32 pad3_i40e;
+		struct xdp_hints_common common;
+	};
+}; // __aligned(4) __attribute__((packed));
+
+union xdp_hints_union define_union;
+
+#define OFFSET1 offsetof(union xdp_hints_union, common)
+#define OFFSET2 offsetof(union xdp_hints_union, i40e.common)
+#define OFFSET3 offsetof(union xdp_hints_union, i40e_ts.base.common)
+
+static void xdp_hints_compile_check(void)
+{
+	union xdp_hints_union my_union = {};
+
+	BUILD_BUG_ON(OFFSET1 != OFFSET2);
+	BUILD_BUG_ON(OFFSET1 != OFFSET3);
+}
+
 /* Extending xdp_hints_flags */
 enum xdp_hints_flags_driver {
 	HINT_FLAG_RX_TIMESTAMP = BIT(16),
@@ -1968,6 +1998,7 @@ static inline u32 i40e_rx_checksum_xdp(struct i40e_vsi *vsi, u64 qword1,
 {
 	struct i40e_rx_checksum_ret ret;
 
+	xdp_hints_compile_check();
 	ret = _i40e_rx_checksum(vsi, qword1, ptype);
 	return xdp_hints_set_rx_csum(&xdp_hints->common, ret.ip_summed, ret.csum_level);
 }


