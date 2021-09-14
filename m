Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF30140AC69
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 13:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhINL30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 07:29:26 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:43761 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232065AbhINL3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 07:29:21 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 849D35805A9;
        Tue, 14 Sep 2021 07:28:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 14 Sep 2021 07:28:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=K9xA/itOgD7/PUD9NPffe+zhElX6cckwkTsVzK1EbEA=; b=dlb39cVk
        SGZd6J4X0hZfzZOy1bYYYxlpVOuePKqIuyR0b/RUYz7uzbm4Ws5RSbLx3ZJ7OsZV
        J4M/8vlEIGZ2BudNDES8UyfQDz87wZUhITLUSRs2ncVdR/Hj6xBCqVBOwERCqY5g
        ACVlOSxeowQT62wBjVg/SMh4YSCiyjGkP73VtT+C9ibgejcrcQQvcBuVJjpzmBd4
        b5OKr+/ZzT7PVuJuRGT4CjmjFnR4hva3prIyFrYxtjPNsb3AgysO+wA0/QiTO0L4
        v/NQuUTrUHj6Fjw7WSgO0pXGXMsHCpHBIpCDC2SO7d6DwvxYofyPH3y1kgX1bCPR
        z2dNXKnzjvM+mA==
X-ME-Sender: <xms:RIdAYQ1GQDaub4LdJD5Rg1aCGiKjvEU7oDM_LSIJo2hbL1blcWQ0Cg>
    <xme:RIdAYbGdP_rcJymjQ1DkL5R92YjaJjkRb5exnQ1lxuobAipVEbXm1a1IOwhl-PS0q
    roSPLZrlRScJTE>
X-ME-Received: <xmr:RIdAYY6CT4n8FV7mZ5Emgq-lbWJoKRFpJYRJGSWYRk-51Gm9BnjpzHd8fp3vWULcji9U-kIKsDxR8dMehHYw8YZkYtlPrhFgBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegledgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:RIdAYZ2W8anVMKCeiPsZs7-PRb5ZVl-Kzv-7TSvDcNYOJ_jRK9SoyA>
    <xmx:RIdAYTHzLaR2l4jH_c5g9ov4UFJSz5mfK5gGlVo-f2O-zEvaEh4kEQ>
    <xmx:RIdAYS8uIWDFBB464-wYYoaqnDeqrkEFNKZu_Nzp6mDWwaE1-u4LUQ>
    <xmx:RIdAYZYqPBwsrDYSem0uYR2VMK5e9cd-EVbaDk6uiTVzJZL42zRdeA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 07:28:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        vladyslavt@nvidia.com, moshe@nvidia.com, popadrian1996@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool 2/5] cmis: Fix invalid memory access in IOCTL path
Date:   Tue, 14 Sep 2021 14:27:35 +0300
Message-Id: <20210914112738.358627-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914112738.358627-1-idosch@idosch.org>
References: <20210914112738.358627-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Page 01h is an optional page that is not available for flat memory
modules. Trying to blindly access it results in the following report
from AddressSanitizer [1].

Instead, pass the base address of the Lower Memory. This results in
wrong information being parsed, but this never worked correctly since
CMIS support first appeared in cited commit.

The information will be parsed correctly in a follow-up submission that
reworks the EEPROM parsing code to use a memory map with pointers to
individual pages instead of passing one large buffer.

[1]
==968785==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x6120000001d4 at pc 0x0000004806ee bp 0x7ffefbc977a0 sp 0x7ffefbc97798
READ of size 1 at 0x6120000001d4 thread T0
    #0 0x4806ed in cmis_print_smf_cbl_len cmis.c:127
    #1 0x48113e in cmis_show_link_len_from_page cmis.c:279
    #2 0x4811e3 in cmis_show_link_len cmis.c:300
    #3 0x481358 in qsfp_dd_show_all cmis.c:336
    #4 0x47d190 in sff8636_show_all qsfp.c:861
    #5 0x42130b in do_getmodule ethtool.c:4908
    #6 0x42a38a in main ethtool.c:6383
    #7 0x7f11db6c51e1 in __libc_start_main (/lib64/libc.so.6+0x281e1)
    #8 0x40258d in _start (ethtool+0x40258d)

Address 0x6120000001d4 is a wild pointer.
SUMMARY: AddressSanitizer: heap-buffer-overflow cmis.c:127 in cmis_print_smf_cbl_len

Fixes: 88ca347ef35a ("Add QSFP-DD support").
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmis.c b/cmis.c
index 361b721f332f..1a91e798e4b8 100644
--- a/cmis.c
+++ b/cmis.c
@@ -297,7 +297,7 @@ static void cmis_show_link_len_from_page(const __u8 *page_one_data)
  */
 static void cmis_show_link_len(const __u8 *id)
 {
-	cmis_show_link_len_from_page(id + PAG01H_UPPER_OFFSET);
+	cmis_show_link_len_from_page(id);
 }
 
 /**
-- 
2.31.1

