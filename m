Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F1442A59F
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbhJLN2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:28:02 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50645 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236772AbhJLN2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:28:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A813A5C014E;
        Tue, 12 Oct 2021 09:26:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 12 Oct 2021 09:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=6MH5BYG5tURGXGf7Ik6wTUXgfEKG0zCjZVmEnF9GlL0=; b=kApjDgQc
        QIrxFpgyA8kFWCWBqP1LnEToJ5t0WncLb4CLxmCJrUOzs4/z5yJadBpCd1tO3oT2
        3o4A8PKHchnx/gJeJ4VbKfJYTNmxx2IKnBaK3m9NQtyKFNXRNLTkZpgy1E8gDSqd
        CVgjsfmEJ62AUw9zDoh76CrYxRWGI/XabKbJSoytowZMuEF+dwsVRmUxg8cdqKTA
        mZyIXMmD4lHoCRiWddT02pL5RMk59A2hKXGPJpKxFHv9ByVyr7+NYq3yC4aJ60EY
        W+fC33mvkxN8Vb714FbrFMceHLiXvazslimltO48v6ZKKIfLk3T81kjdll2C5gkj
        4wke3O/Gndjy7A==
X-ME-Sender: <xms:6IxlYZtasgL6SgGJHCcXM7OALSBLddAYRi4oVjo68UlhfCqSeCkzug>
    <xme:6IxlYSfyMZzS-KSKFO42u56J1qYZT3YNPd9GgdfMPT6qHABQ2D3Td_WQCRiW1PgQ0
    422-KKF8dRpt4w>
X-ME-Received: <xmr:6IxlYcx8J2b2ei8-70XC4K_p3iuSDzLdSIcGGAfEAB1LWhGqd58uuXDooSwhfxid2voqR6cnXkEQzXsCAnnlT-fYlCxFwuaFMZB7C4Ws3SdoTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:6IxlYQPX4jENi25FA-zLJqzLX5po6h76y31ExLA4KyxL0hn6C8VNsQ>
    <xmx:6IxlYZ8Cyhc18aN1BxU2YJlbMepKD_kKCiJa0d_JWqdngSDx2R8VAA>
    <xmx:6IxlYQWU2GzYM27P0SD6K7RBjzn7igJxfSqnOwp6Pb6Teic_eNymLQ>
    <xmx:6IxlYVYSl2fLGQNR3qFCRePNJt2hHphd4ok-KaimW__yX-tnRVgWiQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:25:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 04/14] cmis: Consolidate code between IOCTL and netlink paths
Date:   Tue, 12 Oct 2021 16:25:15 +0300
Message-Id: <20211012132525.457323-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Now that both the netlink and IOCTL paths use the same memory map
structure for parsing, the code can be easily consolidated.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/cmis.c b/cmis.c
index 2e01446b2315..eb7791dd59df 100644
--- a/cmis.c
+++ b/cmis.c
@@ -340,6 +340,20 @@ static void cmis_show_vendor_info(const struct cmis_memory_map *map)
 			       CMIS_CLEI_END_OFFSET, "CLEI code");
 }
 
+static void cmis_show_all_common(const struct cmis_memory_map *map)
+{
+	cmis_show_identifier(map);
+	cmis_show_power_info(map);
+	cmis_show_connector(map);
+	cmis_show_cbl_asm_len(map);
+	cmis_show_sig_integrity(map);
+	cmis_show_mit_compliance(map);
+	cmis_show_mod_lvl_monitors(map);
+	cmis_show_link_len(map);
+	cmis_show_vendor_info(map);
+	cmis_show_rev_compliance(map);
+}
+
 static void cmis_memory_map_init_buf(struct cmis_memory_map *map,
 				     const __u8 *id)
 {
@@ -367,17 +381,7 @@ void cmis_show_all_ioctl(const __u8 *id)
 	struct cmis_memory_map map = {};
 
 	cmis_memory_map_init_buf(&map, id);
-
-	cmis_show_identifier(&map);
-	cmis_show_power_info(&map);
-	cmis_show_connector(&map);
-	cmis_show_cbl_asm_len(&map);
-	cmis_show_sig_integrity(&map);
-	cmis_show_mit_compliance(&map);
-	cmis_show_mod_lvl_monitors(&map);
-	cmis_show_link_len(&map);
-	cmis_show_vendor_info(&map);
-	cmis_show_rev_compliance(&map);
+	cmis_show_all_common(&map);
 }
 
 static void
@@ -411,15 +415,5 @@ void cmis_show_all_nl(const struct ethtool_module_eeprom *page_zero,
 	struct cmis_memory_map map = {};
 
 	cmis_memory_map_init_pages(&map, page_zero, page_one);
-
-	cmis_show_identifier(&map);
-	cmis_show_power_info(&map);
-	cmis_show_connector(&map);
-	cmis_show_cbl_asm_len(&map);
-	cmis_show_sig_integrity(&map);
-	cmis_show_mit_compliance(&map);
-	cmis_show_mod_lvl_monitors(&map);
-	cmis_show_link_len(&map);
-	cmis_show_vendor_info(&map);
-	cmis_show_rev_compliance(&map);
+	cmis_show_all_common(&map);
 }
-- 
2.31.1

