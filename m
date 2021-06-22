Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784193AFD65
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhFVGya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:54:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32885 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230363AbhFVGyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:54:21 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E0C415C00D5;
        Tue, 22 Jun 2021 02:52:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 22 Jun 2021 02:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=mMqNjTDPdW4oNzL8NkjlTgglCo7s/+5jjOlbm3dJ8lk=; b=gUc6YiEu
        SuSW8wduyD8ar06ZxgelgdPcV/AVHszwW9nB9PbXZlf8rNbya6KoGpNlFibKP9V3
        5/iCsplUQuYwaBFECUyOANs9ioc4uXVESGDS/4w0lV9Z/GunuHiqqmAfMJ42cLpN
        j6cOd5CNKLx17pxfphkc6S02re3TJ367lbKn3UP9TSvG2uYNdW1RFIx2RDYowV2W
        lTLohlGnjBFQOHLsgDd8hZaFPDjzwfOvqMzXX6DUVz6fKF/YcMGHbN65foVc5pSF
        BpchCN8LH+mdipPcSmzefA7gO7CCvlq1tlF2rgyx0ZQ4TXSbtC/oXltibDHObLzL
        kG1oGDrRjcRY+Q==
X-ME-Sender: <xms:lYjRYPWoGFnbwtk6rJc2y3Y2qV-D-BBOicsrPrxnrsndaW0RJdj3ig>
    <xme:lYjRYHkqHpfXZXINe_4U8SUOQwA7qmvT-v9bBBNO4RtSp_XyiNMxHcTxpFFCwdf-T
    XBV7HEr7V6xx1Y>
X-ME-Received: <xmr:lYjRYLYj7X57z55ytcydZBFV0ocxaBzGoGieIR3a8EQkU-GzNAMSH9xghFAQBMMy5wXstdAYOx7O5ve7AqxqtEz4ElMyYQFtdfbI0zQVxqlgAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegtddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:lYjRYKUkuR0J4VsIQ-LejC4djOsCBqF_W7x5SulM1ZZGeduU50WgUQ>
    <xmx:lYjRYJmcIBkyM8Nlrtd4HbtG82kArUiCKip-bMCCetY_mVMvWEfhGA>
    <xmx:lYjRYHe_hosc5UkVNErle6ZCFfPhED6KB9I__tOL6X6EyqAjPWW79Q>
    <xmx:lYjRYHY1BusaPYTcM8CTPJ4w9Q1upuc75FAS1B-j3ISxINkvpU0e4w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Jun 2021 02:52:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vladyslavt@nvidia.com, mkubecek@suse.cz, moshe@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/7] ethtool: Validate module EEPROM length as part of policy
Date:   Tue, 22 Jun 2021 09:50:51 +0300
Message-Id: <20210622065052.2545107-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622065052.2545107-1-idosch@idosch.org>
References: <20210622065052.2545107-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Validate the number of bytes to read from the module EEPROM as part of
the netlink policy and remove the corresponding check from the code.

This also makes it possible to query the length range from user space:

 $ genl ctrl policy name ethtool
 ...
 ID: 0x14  policy[32]:attr[3]: type=U32 range:[1,128]
 ...

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ethtool/eeprom.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 5d38e90895ac..1e75d9c1b154 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -159,9 +159,6 @@ static int eeprom_parse_request(struct ethnl_req_info *req_info, struct nlattr *
 	request->offset = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_OFFSET]);
 	request->length = nla_get_u32(tb[ETHTOOL_A_MODULE_EEPROM_LENGTH]);
 
-	if (!request->length)
-		return -EINVAL;
-
 	/* The following set of conditions limit the API to only dump 1/2
 	 * EEPROM page without crossing low page boundary located at offset 128.
 	 * This means user may only request dumps of length limited to 128 from
@@ -237,7 +234,8 @@ const struct ethnl_request_ops ethnl_module_eeprom_request_ops = {
 const struct nla_policy ethnl_module_eeprom_get_policy[] = {
 	[ETHTOOL_A_MODULE_EEPROM_HEADER]	= NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_MODULE_EEPROM_OFFSET]	= { .type = NLA_U32 },
-	[ETHTOOL_A_MODULE_EEPROM_LENGTH]	= { .type = NLA_U32 },
+	[ETHTOOL_A_MODULE_EEPROM_LENGTH]	=
+		NLA_POLICY_RANGE(NLA_U32, 1, ETH_MODULE_EEPROM_PAGE_LEN),
 	[ETHTOOL_A_MODULE_EEPROM_PAGE]		= { .type = NLA_U8 },
 	[ETHTOOL_A_MODULE_EEPROM_BANK]		= { .type = NLA_U8 },
 	[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS]	=
-- 
2.31.1

