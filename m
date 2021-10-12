Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5009C42A59E
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbhJLN2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:28:01 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59805 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236769AbhJLN2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:28:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 479C65C014E;
        Tue, 12 Oct 2021 09:25:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 12 Oct 2021 09:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=AZ9OUKDBXPMAGKRA7grvHq1EjbgZoKUzbfCwh9tJmrw=; b=Rk5JRrYn
        LiF0fak12BF7wVfoWk6dcC7psGcsc1VmEFkl2bknijIG1VXt4x/ylr2nEEByOw3a
        E8c9Q/8YVPGjseSNWrIUoHKbrxxtit6SY+DU3U4yGV5NKYWe+Kzoywwtd2qQ70Lj
        rJzJ530boRJtFmHeYq22uinPAXzLvLmwxzDgi9Y4MCGnobwYluxEYLzq7DprNzTw
        dX5e59Mux6gLgKtvgHGxwx/IYu18ynrtPAgiSosqtW8cJyDrCqt80qREzWAQBNVn
        jbdL+JDLP9WunhQAQiUWcRcLlbG9op21GEP5EkVzscOZ7V9/eNVjdafmxmiupWUR
        dn6eWhYZX5eDjQ==
X-ME-Sender: <xms:5oxlYc_ZetfRzfu-cLtn1MqV39isVihZuuJquvVhuKBy3WCIDTK_Nw>
    <xme:5oxlYUvTyLMTwQKM6u64gEmPUphZepST0eDvoRc2tx4hshsmyOIuqCrTbVIxH2De7
    l0DI0GBYeXcVtU>
X-ME-Received: <xmr:5oxlYSCx28RlZlqxU0jaUV8nHTAZsPMw9ZtKCSwH0W4BOB0YYqIcJfrPbmvh7Ivg5Iwok3_qiECtkCZwCvdFRqKtVAr42NFXsZX9H9j223PeaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:5oxlYceWEIHS_gQ0DxLgSTgKnc5AyCNoIKfbc5isf-5cSlRdnTyVDA>
    <xmx:5oxlYRPBPqlF6Y6ZOXWufYmNdOffZ3Jhh53uKBX2WCMeVwAqTDIG_g>
    <xmx:5oxlYWnjmWkQeIAoHcwVtzJ4PiXwTon6_jSTYoXOspN_eJ5JZ4bXFw>
    <xmx:5oxlYWpW-cScnEcSAJ2FQOKFCsxIyLhr5ESA4ZghBi8BKqNmC2n_4A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:25:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 03/14] cmis: Use memory map during parsing
Date:   Tue, 12 Oct 2021 16:25:14 +0300
Message-Id: <20211012132525.457323-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Instead of passing one large buffer to the individual parsing functions,
use the memory map structure from the previous patch.

This has the added benefit of checking which optional pages are actually
available and it will also allow us to consolidate the IOCTL and netlink
parsing code paths.

Tested by making sure that the only differences in output in both the
IOCTL and netlink paths before and after the patch are in a few
registers in Page 01h that were previously parsed from Page 00h.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 175 +++++++++++++++++++++++++++++----------------------------
 cmis.h |   1 -
 2 files changed, 88 insertions(+), 88 deletions(-)

diff --git a/cmis.c b/cmis.c
index 8a6788416a00..2e01446b2315 100644
--- a/cmis.c
+++ b/cmis.c
@@ -22,19 +22,19 @@ struct cmis_memory_map {
 
 #define CMIS_PAGE_SIZE		0x80
 
-static void cmis_show_identifier(const __u8 *id)
+static void cmis_show_identifier(const struct cmis_memory_map *map)
 {
-	sff8024_show_identifier(id, CMIS_ID_OFFSET);
+	sff8024_show_identifier(map->lower_memory, CMIS_ID_OFFSET);
 }
 
-static void cmis_show_connector(const __u8 *id)
+static void cmis_show_connector(const struct cmis_memory_map *map)
 {
-	sff8024_show_connector(id, CMIS_CTOR_OFFSET);
+	sff8024_show_connector(map->page_00h, CMIS_CTOR_OFFSET);
 }
 
-static void cmis_show_oui(const __u8 *id)
+static void cmis_show_oui(const struct cmis_memory_map *map)
 {
-	sff8024_show_oui(id, CMIS_VENDOR_OUI_OFFSET);
+	sff8024_show_oui(map->page_00h, CMIS_VENDOR_OUI_OFFSET);
 }
 
 /**
@@ -42,9 +42,9 @@ static void cmis_show_oui(const __u8 *id)
  * [1] CMIS Rev. 3, pag. 45, section 1.7.2.1, Table 18
  * [2] CMIS Rev. 4, pag. 81, section 8.2.1, Table 8-2
  */
-static void cmis_show_rev_compliance(const __u8 *id)
+static void cmis_show_rev_compliance(const struct cmis_memory_map *map)
 {
-	__u8 rev = id[CMIS_REV_COMPLIANCE_OFFSET];
+	__u8 rev = map->lower_memory[CMIS_REV_COMPLIANCE_OFFSET];
 	int major = (rev >> 4) & 0x0F;
 	int minor = rev & 0x0F;
 
@@ -58,17 +58,17 @@ static void cmis_show_rev_compliance(const __u8 *id)
  * [2] CMIS Rev. 4, pag. 94, section 8.3.9, Table 8-18
  * [3] QSFP-DD Hardware Rev 5.0, pag. 22, section 4.2.1
  */
-static void cmis_show_power_info(const __u8 *id)
+static void cmis_show_power_info(const struct cmis_memory_map *map)
 {
 	float max_power = 0.0f;
 	__u8 base_power = 0;
 	__u8 power_class;
 
 	/* Get the power class (first 3 most significat bytes) */
-	power_class = (id[CMIS_PWR_CLASS_OFFSET] >> 5) & 0x07;
+	power_class = (map->page_00h[CMIS_PWR_CLASS_OFFSET] >> 5) & 0x07;
 
 	/* Get the base power in multiples of 0.25W */
-	base_power = id[CMIS_PWR_MAX_POWER_OFFSET];
+	base_power = map->page_00h[CMIS_PWR_MAX_POWER_OFFSET];
 	max_power = base_power * 0.25f;
 
 	printf("\t%-41s : %d\n", "Power class", power_class + 1);
@@ -83,20 +83,20 @@ static void cmis_show_power_info(const __u8 *id)
  * [1] CMIS Rev. 3, pag. 59, section 1.7.3.10, Table 31
  * [2] CMIS Rev. 4, pag. 94, section 8.3.10, Table 8-19
  */
-static void cmis_show_cbl_asm_len(const __u8 *id)
+static void cmis_show_cbl_asm_len(const struct cmis_memory_map *map)
 {
 	static const char *fn = "Cable assembly length";
 	float mul = 1.0f;
 	float val = 0.0f;
 
 	/* Check if max length */
-	if (id[CMIS_CBL_ASM_LEN_OFFSET] == CMIS_6300M_MAX_LEN) {
+	if (map->page_00h[CMIS_CBL_ASM_LEN_OFFSET] == CMIS_6300M_MAX_LEN) {
 		printf("\t%-41s : > 6.3km\n", fn);
 		return;
 	}
 
 	/* Get the multiplier from the first two bits */
-	switch (id[CMIS_CBL_ASM_LEN_OFFSET] & CMIS_LEN_MUL_MASK) {
+	switch (map->page_00h[CMIS_CBL_ASM_LEN_OFFSET] & CMIS_LEN_MUL_MASK) {
 	case CMIS_MULTIPLIER_00:
 		mul = 0.1f;
 		break;
@@ -114,7 +114,7 @@ static void cmis_show_cbl_asm_len(const __u8 *id)
 	}
 
 	/* Get base value from first 6 bits and multiply by mul */
-	val = (id[CMIS_CBL_ASM_LEN_OFFSET] & CMIS_LEN_VAL_MASK);
+	val = (map->page_00h[CMIS_CBL_ASM_LEN_OFFSET] & CMIS_LEN_VAL_MASK);
 	val = (float)val * mul;
 	printf("\t%-41s : %0.2fm\n", fn, val);
 }
@@ -126,14 +126,17 @@ static void cmis_show_cbl_asm_len(const __u8 *id)
  * [1] CMIS Rev. 3, pag. 63, section 1.7.4.2, Table 39
  * [2] CMIS Rev. 4, pag. 99, section 8.4.2, Table 8-27
  */
-static void cmis_print_smf_cbl_len(const __u8 *id)
+static void cmis_print_smf_cbl_len(const struct cmis_memory_map *map)
 {
 	static const char *fn = "Length (SMF)";
 	float mul = 1.0f;
 	float val = 0.0f;
 
+	if (!map->page_01h)
+		return;
+
 	/* Get the multiplier from the first two bits */
-	switch (id[CMIS_SMF_LEN_OFFSET] & CMIS_LEN_MUL_MASK) {
+	switch (map->page_01h[CMIS_SMF_LEN_OFFSET] & CMIS_LEN_MUL_MASK) {
 	case CMIS_MULTIPLIER_00:
 		mul = 0.1f;
 		break;
@@ -145,7 +148,7 @@ static void cmis_print_smf_cbl_len(const __u8 *id)
 	}
 
 	/* Get base value from first 6 bits and multiply by mul */
-	val = (id[CMIS_SMF_LEN_OFFSET] & CMIS_LEN_VAL_MASK);
+	val = (map->page_01h[CMIS_SMF_LEN_OFFSET] & CMIS_LEN_VAL_MASK);
 	val = (float)val * mul;
 	printf("\t%-41s : %0.2fkm\n", fn, val);
 }
@@ -155,21 +158,24 @@ static void cmis_print_smf_cbl_len(const __u8 *id)
  * [1] CMIS Rev. 3, pag. 71, section 1.7.4.10, Table 46
  * [2] CMIS Rev. 4, pag. 105, section 8.4.10, Table 8-34
  */
-static void cmis_show_sig_integrity(const __u8 *id)
+static void cmis_show_sig_integrity(const struct cmis_memory_map *map)
 {
+	if (!map->page_01h)
+		return;
+
 	/* CDR Bypass control: 2nd bit from each byte */
 	printf("\t%-41s : ", "Tx CDR bypass control");
-	printf("%s\n", YESNO(id[CMIS_SIG_INTEG_TX_OFFSET] & 0x02));
+	printf("%s\n", YESNO(map->page_01h[CMIS_SIG_INTEG_TX_OFFSET] & 0x02));
 
 	printf("\t%-41s : ", "Rx CDR bypass control");
-	printf("%s\n", YESNO(id[CMIS_SIG_INTEG_RX_OFFSET] & 0x02));
+	printf("%s\n", YESNO(map->page_01h[CMIS_SIG_INTEG_RX_OFFSET] & 0x02));
 
 	/* CDR Implementation: 1st bit from each byte */
 	printf("\t%-41s : ", "Tx CDR");
-	printf("%s\n", YESNO(id[CMIS_SIG_INTEG_TX_OFFSET] & 0x01));
+	printf("%s\n", YESNO(map->page_01h[CMIS_SIG_INTEG_TX_OFFSET] & 0x01));
 
 	printf("\t%-41s : ", "Rx CDR");
-	printf("%s\n", YESNO(id[CMIS_SIG_INTEG_RX_OFFSET] & 0x01));
+	printf("%s\n", YESNO(map->page_01h[CMIS_SIG_INTEG_RX_OFFSET] & 0x01));
 }
 
 /**
@@ -182,14 +188,14 @@ static void cmis_show_sig_integrity(const __u8 *id)
  * --> pag. 98, section 8.4, Table 8-25
  * --> page 100, section 8.4.3, 8.4.4
  */
-static void cmis_show_mit_compliance(const __u8 *id)
+static void cmis_show_mit_compliance(const struct cmis_memory_map *map)
 {
 	static const char *cc = " (Copper cable,";
 
 	printf("\t%-41s : 0x%02x", "Transmitter technology",
-	       id[CMIS_MEDIA_INTF_TECH_OFFSET]);
+	       map->page_00h[CMIS_MEDIA_INTF_TECH_OFFSET]);
 
-	switch (id[CMIS_MEDIA_INTF_TECH_OFFSET]) {
+	switch (map->page_00h[CMIS_MEDIA_INTF_TECH_OFFSET]) {
 	case CMIS_850_VCSEL:
 		printf(" (850 nm VCSEL)\n");
 		break;
@@ -240,22 +246,22 @@ static void cmis_show_mit_compliance(const __u8 *id)
 		break;
 	}
 
-	if (id[CMIS_MEDIA_INTF_TECH_OFFSET] >= CMIS_COPPER_UNEQUAL) {
+	if (map->page_00h[CMIS_MEDIA_INTF_TECH_OFFSET] >= CMIS_COPPER_UNEQUAL) {
 		printf("\t%-41s : %udb\n", "Attenuation at 5GHz",
-		       id[CMIS_COPPER_ATT_5GHZ]);
+		       map->page_00h[CMIS_COPPER_ATT_5GHZ]);
 		printf("\t%-41s : %udb\n", "Attenuation at 7GHz",
-		       id[CMIS_COPPER_ATT_7GHZ]);
+		       map->page_00h[CMIS_COPPER_ATT_7GHZ]);
 		printf("\t%-41s : %udb\n", "Attenuation at 12.9GHz",
-		       id[CMIS_COPPER_ATT_12P9GHZ]);
+		       map->page_00h[CMIS_COPPER_ATT_12P9GHZ]);
 		printf("\t%-41s : %udb\n", "Attenuation at 25.8GHz",
-		       id[CMIS_COPPER_ATT_25P8GHZ]);
-	} else {
+		       map->page_00h[CMIS_COPPER_ATT_25P8GHZ]);
+	} else if (map->page_01h) {
 		printf("\t%-41s : %.3lfnm\n", "Laser wavelength",
-		       (((id[CMIS_NOM_WAVELENGTH_MSB] << 8) |
-				id[CMIS_NOM_WAVELENGTH_LSB]) * 0.05));
+		       (((map->page_01h[CMIS_NOM_WAVELENGTH_MSB] << 8) |
+			  map->page_01h[CMIS_NOM_WAVELENGTH_LSB]) * 0.05));
 		printf("\t%-41s : %.3lfnm\n", "Laser wavelength tolerance",
-		       (((id[CMIS_WAVELENGTH_TOL_MSB] << 8) |
-		       id[CMIS_WAVELENGTH_TOL_LSB]) * 0.005));
+		       (((map->page_01h[CMIS_WAVELENGTH_TOL_MSB] << 8) |
+			  map->page_01h[CMIS_WAVELENGTH_TOL_LSB]) * 0.005));
 	}
 }
 
@@ -275,28 +281,16 @@ static void cmis_show_mit_compliance(const __u8 *id)
  * [2] CMIS Rev. 4:
  * --> pag. 84, section 8.2.4, Table 8-6
  */
-static void cmis_show_mod_lvl_monitors(const __u8 *id)
+static void cmis_show_mod_lvl_monitors(const struct cmis_memory_map *map)
 {
+	const __u8 *id = map->lower_memory;
+
 	PRINT_TEMP("Module temperature",
 		   OFFSET_TO_TEMP(CMIS_CURR_TEMP_OFFSET));
 	PRINT_VCC("Module voltage",
 		  OFFSET_TO_U16(CMIS_CURR_VCC_OFFSET));
 }
 
-static void cmis_show_link_len_from_page(const __u8 *page_one_data)
-{
-	cmis_print_smf_cbl_len(page_one_data);
-	sff_show_value_with_unit(page_one_data, CMIS_OM5_LEN_OFFSET,
-				 "Length (OM5)", 2, "m");
-	sff_show_value_with_unit(page_one_data, CMIS_OM4_LEN_OFFSET,
-				 "Length (OM4)", 2, "m");
-	sff_show_value_with_unit(page_one_data, CMIS_OM3_LEN_OFFSET,
-				 "Length (OM3 50/125um)", 2, "m");
-	sff_show_value_with_unit(page_one_data, CMIS_OM2_LEN_OFFSET,
-				 "Length (OM2 50/125um)", 1, "m");
-}
-
-
 /**
  * Print relevant info about the maximum supported fiber media length
  * for each type of fiber media at the maximum module-supported bit rate.
@@ -304,9 +298,19 @@ static void cmis_show_link_len_from_page(const __u8 *page_one_data)
  * [1] CMIS Rev. 3, page 64, section 1.7.4.2, Table 39
  * [2] CMIS Rev. 4, page 99, section 8.4.2, Table 8-27
  */
-static void cmis_show_link_len(const __u8 *id)
+static void cmis_show_link_len(const struct cmis_memory_map *map)
 {
-	cmis_show_link_len_from_page(id);
+	cmis_print_smf_cbl_len(map);
+	if (!map->page_01h)
+		return;
+	sff_show_value_with_unit(map->page_01h, CMIS_OM5_LEN_OFFSET,
+				 "Length (OM5)", 2, "m");
+	sff_show_value_with_unit(map->page_01h, CMIS_OM4_LEN_OFFSET,
+				 "Length (OM4)", 2, "m");
+	sff_show_value_with_unit(map->page_01h, CMIS_OM3_LEN_OFFSET,
+				 "Length (OM3 50/125um)", 2, "m");
+	sff_show_value_with_unit(map->page_01h, CMIS_OM2_LEN_OFFSET,
+				 "Length (OM2 50/125um)", 1, "m");
 }
 
 /**
@@ -314,25 +318,26 @@ static void cmis_show_link_len(const __u8 *id)
  * [1] CMIS Rev. 3, page 56, section 1.7.3, Table 27
  * [2] CMIS Rev. 4, page 91, section 8.2, Table 8-15
  */
-static void cmis_show_vendor_info(const __u8 *id)
+static void cmis_show_vendor_info(const struct cmis_memory_map *map)
 {
-	const char *clei = (const char *)(id + CMIS_CLEI_START_OFFSET);
+	const char *clei;
 
-	sff_show_ascii(id, CMIS_VENDOR_NAME_START_OFFSET,
+	sff_show_ascii(map->page_00h, CMIS_VENDOR_NAME_START_OFFSET,
 		       CMIS_VENDOR_NAME_END_OFFSET, "Vendor name");
-	cmis_show_oui(id);
-	sff_show_ascii(id, CMIS_VENDOR_PN_START_OFFSET,
+	cmis_show_oui(map);
+	sff_show_ascii(map->page_00h, CMIS_VENDOR_PN_START_OFFSET,
 		       CMIS_VENDOR_PN_END_OFFSET, "Vendor PN");
-	sff_show_ascii(id, CMIS_VENDOR_REV_START_OFFSET,
+	sff_show_ascii(map->page_00h, CMIS_VENDOR_REV_START_OFFSET,
 		       CMIS_VENDOR_REV_END_OFFSET, "Vendor rev");
-	sff_show_ascii(id, CMIS_VENDOR_SN_START_OFFSET,
+	sff_show_ascii(map->page_00h, CMIS_VENDOR_SN_START_OFFSET,
 		       CMIS_VENDOR_SN_END_OFFSET, "Vendor SN");
-	sff_show_ascii(id, CMIS_DATE_YEAR_OFFSET,
+	sff_show_ascii(map->page_00h, CMIS_DATE_YEAR_OFFSET,
 		       CMIS_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
 
+	clei = (const char *)(map->page_00h + CMIS_CLEI_START_OFFSET);
 	if (*clei && strncmp(clei, CMIS_CLEI_BLANK, CMIS_CLEI_LEN))
-		sff_show_ascii(id, CMIS_CLEI_START_OFFSET, CMIS_CLEI_END_OFFSET,
-			       "CLEI code");
+		sff_show_ascii(map->page_00h, CMIS_CLEI_START_OFFSET,
+			       CMIS_CLEI_END_OFFSET, "CLEI code");
 }
 
 static void cmis_memory_map_init_buf(struct cmis_memory_map *map,
@@ -363,16 +368,16 @@ void cmis_show_all_ioctl(const __u8 *id)
 
 	cmis_memory_map_init_buf(&map, id);
 
-	cmis_show_identifier(id);
-	cmis_show_power_info(id);
-	cmis_show_connector(id);
-	cmis_show_cbl_asm_len(id);
-	cmis_show_sig_integrity(id);
-	cmis_show_mit_compliance(id);
-	cmis_show_mod_lvl_monitors(id);
-	cmis_show_link_len(id);
-	cmis_show_vendor_info(id);
-	cmis_show_rev_compliance(id);
+	cmis_show_identifier(&map);
+	cmis_show_power_info(&map);
+	cmis_show_connector(&map);
+	cmis_show_cbl_asm_len(&map);
+	cmis_show_sig_integrity(&map);
+	cmis_show_mit_compliance(&map);
+	cmis_show_mod_lvl_monitors(&map);
+	cmis_show_link_len(&map);
+	cmis_show_vendor_info(&map);
+	cmis_show_rev_compliance(&map);
 }
 
 static void
@@ -403,22 +408,18 @@ cmis_memory_map_init_pages(struct cmis_memory_map *map,
 void cmis_show_all_nl(const struct ethtool_module_eeprom *page_zero,
 		      const struct ethtool_module_eeprom *page_one)
 {
-	const __u8 *page_zero_data = page_zero->data;
 	struct cmis_memory_map map = {};
 
 	cmis_memory_map_init_pages(&map, page_zero, page_one);
 
-	cmis_show_identifier(page_zero_data);
-	cmis_show_power_info(page_zero_data);
-	cmis_show_connector(page_zero_data);
-	cmis_show_cbl_asm_len(page_zero_data);
-	cmis_show_sig_integrity(page_zero_data);
-	cmis_show_mit_compliance(page_zero_data);
-	cmis_show_mod_lvl_monitors(page_zero_data);
-
-	if (page_one)
-		cmis_show_link_len_from_page(page_one->data - 0x80);
-
-	cmis_show_vendor_info(page_zero_data);
-	cmis_show_rev_compliance(page_zero_data);
+	cmis_show_identifier(&map);
+	cmis_show_power_info(&map);
+	cmis_show_connector(&map);
+	cmis_show_cbl_asm_len(&map);
+	cmis_show_sig_integrity(&map);
+	cmis_show_mit_compliance(&map);
+	cmis_show_mod_lvl_monitors(&map);
+	cmis_show_link_len(&map);
+	cmis_show_vendor_info(&map);
+	cmis_show_rev_compliance(&map);
 }
diff --git a/cmis.h b/cmis.h
index 53cbb5f57127..c878e3bc5afd 100644
--- a/cmis.h
+++ b/cmis.h
@@ -100,7 +100,6 @@
  * that are unique to active modules and cable assemblies.
  * GlobalOffset = 2 * 0x80 + LocalOffset
  */
-#define PAG01H_UPPER_OFFSET			(0x02 * 0x80)
 
 /* Supported Link Length (Page 1) */
 #define CMIS_SMF_LEN_OFFSET			0x84
-- 
2.31.1

