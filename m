Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B2C3B154B
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 10:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFWIDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 04:03:36 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:58033 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhFWIDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 04:03:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6477E58070E;
        Wed, 23 Jun 2021 04:01:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 23 Jun 2021 04:01:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=MXmnEKvwlwdvA3DAlhcuaoIxaFThqGtxYqAmSLjeoDs=; b=kjY9xA83
        2srl6VQrD9Hy+LqyVmiGRchtRL9gC9nOgOTAsvOhgqt8srY7PjZxUMz9TrrgAU9m
        P6QEkQG3fZG5x70X6sawDlgZwamdOtihtKrTXjTzsC3T8cCES+cus493HYORgJk9
        UoRfFPKA6eai/KfzwKX6h/b0HMyfv/pwim48j5Z2BNzUJNyMrqbac4jbAKDioQ6p
        tUB7gQRND+nnTVenldP+n198FRMKkKbn5idyUfwHwlekDfqx/WmahbTOcjF6VG3j
        2Hez3VvIfzxfVD2QE9FCUJf/g+d3W55Dn/l/4VJE2wNpNnzYw4qm2L+oz4FA0PzP
        EXVjhoIeB8OaXg==
X-ME-Sender: <xms:S-rSYGa7KE23M97x2Ltwxk6dpnFJHHKQHDAABPbcGlAVuta7J2fuzQ>
    <xme:S-rSYJaKs_C2pKjz8ucmJluwbGQluO0HvmTLxkjlNBPoiH9mZob5proFsTeQlBsU6
    lSNsdc3I48pD7g>
X-ME-Received: <xmr:S-rSYA8enZhRJn5yykPWy7_l6OEk77yRtDAtcVeipHrB9YN7rPYBp6rSmprBnfAqGQVc_2WA9fE87m5Ikvq-8hUTkl8EetWJ2e-LExu28gqJUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegvddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:S-rSYIqyniBtdouZXpMIw058uNeJ0FbTEH6WGdDsYaqrwRHSeUs4jA>
    <xmx:S-rSYBrFdfc8Robra_DulCovtxXwGix5hYnRypLx420ku55ehziyRg>
    <xmx:S-rSYGTkGO2PcrHi84HYHqSyk_cv9K6kEuCRS_bGTv9dJc2xrpu0Fg>
    <xmx:S-rSYFeom3B9dCWqHaLxWuEGFFfVCxB88Oe8LLOP_q3uZxVsFN4V3Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Jun 2021 04:01:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 1/4] ethtool: Extract module EEPROM attributes before validation
Date:   Wed, 23 Jun 2021 10:59:22 +0300
Message-Id: <20210623075925.2610908-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210623075925.2610908-1-idosch@idosch.org>
References: <20210623075925.2610908-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Move the extraction of the attributes before their validation, so that
the validation could be easily split into a different function in the
subsequent patch.

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/ethtool/eeprom.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 7e6b37a54add..ed5f677f27cd 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -158,6 +158,9 @@ static int eeprom_parse_request(struct ethnl_req_info *req_info, struct nlattr *
 	request->i2c_address = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS]);
 	request->offset = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_OFFSET]);
 	request->length = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_LENGTH]);
+	request->page = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_PAGE]);
+	if (tb[ETHTOOL_A_MODULE_EEPROM_BANK])
+		request->bank = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_BANK]);
 
 	/* The following set of conditions limit the API to only dump 1/2
 	 * EEPROM page without crossing low page boundary located at offset 128.
@@ -165,7 +168,6 @@ static int eeprom_parse_request(struct ethnl_req_info *req_info, struct nlattr *
 	 * either low 128 bytes or high 128 bytes.
 	 * For pages higher than 0 only high 128 bytes are accessible.
 	 */
-	request->page = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_PAGE]);
 	if (request->page && request->offset < ETH_MODULE_EEPROM_PAGE_LEN) {
 		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_PAGE],
 				    "reading from lower half page is allowed for page 0 only");
@@ -183,9 +185,6 @@ static int eeprom_parse_request(struct ethnl_req_info *req_info, struct nlattr *
 		return -EINVAL;
 	}
 
-	if (tb[ETHTOOL_A_MODULE_EEPROM_BANK])
-		request->bank = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_BANK]);
-
 	return 0;
 }
 
-- 
2.31.1

