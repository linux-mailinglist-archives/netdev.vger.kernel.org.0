Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAFF42A5A2
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbhJLN2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:28:22 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42195 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236908AbhJLN2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:28:11 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id A41055C01BC;
        Tue, 12 Oct 2021 09:26:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 12 Oct 2021 09:26:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=JrR6LFw0cH07p12nEyXRwaUsm0JI4q95ulVrTEBW/IE=; b=LkSgvEHK
        87UDjTpIXwf1mWpP2Y7isO6clC6PqvKTQl8LnXOXMK+MF6c+Uf8/e61GJxC173k2
        Pw6Xo4pjKnb2cOrn7pfNdfRImZaoa98Htzdw6MqWnqPZF3k7K4pnE8tgg66gtHe7
        Nzoedrx4MVeo/+n1TiH9Ii3Go+uTiJ+3K0LEVqA0y+T0THSIKe2jru0hg0BcP7Xn
        r59kfrB7ghl9HGqnKPzEJsczLQNvdHiAEoRO5ZHvlZzIfyjd02rRx4PhuPp6L8gW
        EJBHuoXTeyE8LkJqdHhXVZxzZNgeGMpeiFKgSrZjbbQLASjvRL28eB8GDo2DU5Vh
        nBVeJdcsHMHBIg==
X-ME-Sender: <xms:8YxlYQiYBLJzMuNwU-hHCSvnYP3xgIM5OLt59azPphWPcZi8k6K_uA>
    <xme:8YxlYZAH4kt-_cgkurY2XXf8oWxsjbcwzi98z127ICTjJdlIBaCWR2af_nHxWYv0z
    Rq6_d_W8xM7BN4>
X-ME-Received: <xmr:8YxlYYHwKDJeKbMzsdxuMLARtKIRhVieIZfnMiCdt7Pqtd5AL1oY4Z4n72LOLDPCjXJruilcR4lUTvBwVOfyn-fH61vYK8eR8liU7XdzkbQr_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepgeenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:8YxlYRS5Uf04kY-1KiOx1i0V75ZfH-RkjmeUu6inlTR_YlPeCmAsxw>
    <xmx:8YxlYdyJx3oZC46P7GPFKLRvTY0Y_EUWlacPbHxtPW4seZZfgyXvWw>
    <xmx:8YxlYf72h-zbeq1oXOwVV6DkKk9b0tnSziF7YiMHW4wXXHbX8xMN6g>
    <xmx:8YxlYftHeYlqLS-t-VSUQXBP9Yl6DGYnPxhKCQNvMKMv5VnnQXJsgg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:26:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 08/14] sff-8636: Consolidate code between IOCTL and netlink paths
Date:   Tue, 12 Oct 2021 16:25:19 +0300
Message-Id: <20211012132525.457323-9-idosch@idosch.org>
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

Note that the switch-case statement is not necessary for the netlink
path, as the netlink code (i.e., netlink/module-eeprom.c) already
performed the check, but it is required for the IOCTL path.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/qsfp.c b/qsfp.c
index 354b3b1ce9ff..4aa49351e6b7 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -898,6 +898,19 @@ static void sff8636_show_page_zero(const struct sff8636_memory_map *map)
 				     SFF8636_REV_COMPLIANCE_OFFSET);
 }
 
+static void sff8636_show_all_common(const struct sff8636_memory_map *map)
+{
+	sff8636_show_identifier(map);
+	switch (map->lower_memory[SFF8636_ID_OFFSET]) {
+	case SFF8024_ID_QSFP:
+	case SFF8024_ID_QSFP_PLUS:
+	case SFF8024_ID_QSFP28:
+		sff8636_show_page_zero(map);
+		sff8636_show_dom(map);
+		break;
+	}
+}
+
 static void sff8636_memory_map_init_buf(struct sff8636_memory_map *map,
 					const __u8 *id, __u32 eeprom_len)
 {
@@ -931,16 +944,7 @@ void sff8636_show_all_ioctl(const __u8 *id, __u32 eeprom_len)
 	}
 
 	sff8636_memory_map_init_buf(&map, id, eeprom_len);
-
-	sff8636_show_identifier(&map);
-	switch (map.lower_memory[SFF8636_ID_OFFSET]) {
-	case SFF8024_ID_QSFP:
-	case SFF8024_ID_QSFP_PLUS:
-	case SFF8024_ID_QSFP28:
-		sff8636_show_page_zero(&map);
-		sff8636_show_dom(&map);
-		break;
-	}
+	sff8636_show_all_common(&map);
 }
 
 static void
@@ -974,8 +978,5 @@ void sff8636_show_all_nl(const struct ethtool_module_eeprom *page_zero,
 	struct sff8636_memory_map map = {};
 
 	sff8636_memory_map_init_pages(&map, page_zero, page_three);
-
-	sff8636_show_identifier(&map);
-	sff8636_show_page_zero(&map);
-	sff8636_show_dom(&map);
+	sff8636_show_all_common(&map);
 }
-- 
2.31.1

