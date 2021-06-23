Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1FA3B154C
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 10:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFWIDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 04:03:52 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:35409 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230151AbhFWIDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 04:03:35 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9A7C758070A;
        Wed, 23 Jun 2021 04:01:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 23 Jun 2021 04:01:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=zS9tM4dmIwlbodz0mKkPhn3uk5Joo5/en22CRaNA/UU=; b=nXvE2Ofo
        9Rl2jmU+xiEDio35Z8OkHvitRSOUXCwIvN/9EYAJoRlWhRodGRca7lcGTgz+XacZ
        xzf+CPZJMr6g9hYghWEa4rZjMoUzgFe+rtAxLkinjIJ2ITH1PT7R3ip8DO4fxIRW
        UShrJuGmvGdOwYhH3vw1IuHFG4E4TmjXj5nF5kQSwgQ1ocKBsdkHywiI2DIUDKYJ
        GMEKbQyUH46OJPPCBpr/elu4njyX3EMPWS19WQc7/7lMR0wHOcXe47/ZKoyPoTmF
        l068kBCPWrSvaTRuFSIFiRaOPAqPjZkCzN46Hdtzsrm3cX4M61DXryiA2YD2fo/P
        5nbUJ3b3EBqikw==
X-ME-Sender: <xms:TurSYM1aeluj9uqP-fWbDaWH-GHkK9c4qqadCCNEH9icMFGG0zbb4g>
    <xme:TurSYHHznqNq8mhvqbx6f8Lr0v_5OQlKxpFXbVfFttNVLdYEZv2OjxJeSrRirHPfc
    pUkS0ewj41iNxc>
X-ME-Received: <xmr:TurSYE6F8dp9lp7kbDv3WIZv0PMAX_nUCfKK9YTA-SLPCg2048FtU7zSxzu3w94IPBAL_Yr0rYZEJoLF-KNX7u4ZHqC65DjJ-uCgerS15lJu0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegvddguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:TurSYF1CZQNHkb3CACh9xtifQXQeWJUkS-QehWra_7u_OSu1X1L0Eg>
    <xmx:TurSYPGTvHuC2gvDKWkUT4auWcthLiBzhnIR_F9Iyjo6Inq9tVZrqw>
    <xmx:TurSYO8fSP2IkZpMZ5jj6wJexlmX2Ea0C0N9iTRp8hMUexqZbNLaPw>
    <xmx:TurSYFZdZFkMaPgVbOhXLpjBY-zn3DRpMInisMNaUnxbykp0pw9SvA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Jun 2021 04:01:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 2/4] ethtool: Split module EEPROM attributes validation to a function
Date:   Wed, 23 Jun 2021 10:59:23 +0300
Message-Id: <20210623075925.2610908-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210623075925.2610908-1-idosch@idosch.org>
References: <20210623075925.2610908-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The same validation will be needed for module EEPROM write access in the
subsequent patch, so split it into a function.

Modify the extack messages a bit to not be specific to read access.

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/ethtool/eeprom.c | 58 ++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index ed5f677f27cd..945b95e64f0d 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -144,10 +144,41 @@ static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
 	return ret;
 }
 
+static int eeprom_validate(struct nlattr **tb, struct netlink_ext_ack *extack)
+{
+	u32 offset = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_OFFSET]);
+	u32 length = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_LENGTH]);
+	u8 page = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_PAGE]);
+
+	/* The following set of conditions limit the API to only access 1/2
+	 * EEPROM page without crossing low page boundary located at offset
+	 * 128. For pages higher than 0, only high 128 bytes are accessible.
+	 */
+	if (page && offset < ETH_MODULE_EEPROM_PAGE_LEN) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_PAGE],
+				    "access to lower half page is allowed for page 0 only");
+		return -EINVAL;
+	}
+
+	if (offset < ETH_MODULE_EEPROM_PAGE_LEN &&
+	    offset + length > ETH_MODULE_EEPROM_PAGE_LEN) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_LENGTH],
+				    "crossing half page boundary is illegal");
+		return -EINVAL;
+	} else if (offset + length > ETH_MODULE_EEPROM_PAGE_LEN * 2) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_LENGTH],
+				    "crossing page boundary is illegal");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int eeprom_parse_request(struct ethnl_req_info *req_info, struct nlattr **tb,
 				struct netlink_ext_ack *extack)
 {
 	struct eeprom_req_info *request = MODULE_EEPROM_REQINFO(req_info);
+	int err;
 
 	if (!tb[ETHTOOL_A_MODULE_EEPROM_OFFSET] ||
 	    !tb[ETHTOOL_A_MODULE_EEPROM_LENGTH] ||
@@ -155,6 +186,10 @@ static int eeprom_parse_request(struct ethnl_req_info *req_info, struct nlattr *
 	    !tb[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS])
 		return -EINVAL;
 
+	err = eeprom_validate(tb, extack);
+	if (err)
+		return err;
+
 	request->i2c_address = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS]);
 	request->offset = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_OFFSET]);
 	request->length = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_LENGTH]);
@@ -162,29 +197,6 @@ static int eeprom_parse_request(struct ethnl_req_info *req_info, struct nlattr *
 	if (tb[ETHTOOL_A_MODULE_EEPROM_BANK])
 		request->bank = nla_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_BANK]);
 
-	/* The following set of conditions limit the API to only dump 1/2
-	 * EEPROM page without crossing low page boundary located at offset 128.
-	 * This means user may only request dumps of length limited to 128 from
-	 * either low 128 bytes or high 128 bytes.
-	 * For pages higher than 0 only high 128 bytes are accessible.
-	 */
-	if (request->page && request->offset < ETH_MODULE_EEPROM_PAGE_LEN) {
-		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_PAGE],
-				    "reading from lower half page is allowed for page 0 only");
-		return -EINVAL;
-	}
-
-	if (request->offset < ETH_MODULE_EEPROM_PAGE_LEN &&
-	    request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN) {
-		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_LENGTH],
-				    "reading cross half page boundary is illegal");
-		return -EINVAL;
-	} else if (request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN * 2) {
-		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MODULE_EEPROM_LENGTH],
-				    "reading cross page boundary is illegal");
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
-- 
2.31.1

