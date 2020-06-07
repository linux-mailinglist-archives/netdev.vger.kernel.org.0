Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6630C1F0A89
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 10:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgFGIhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 04:37:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38137 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbgFGIhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 04:37:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3C3D85C00A9;
        Sun,  7 Jun 2020 04:37:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Jun 2020 04:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=MIs+5qkZvBWBhbhVfsQUMMCEM4REDFnZoBmJ5PoHGHE=; b=AZGomvwW
        3NkKWyLCsav6UZQOY2ahVNqa8QahxYHrn6sKG7eKJ2AqVxaZSLkRNwxyB7Q3IxzA
        ffqRXVCLdV0HPMbd4fNbf/71KBfJepW11sDOl+Q+Coy/BGuMh9Ckw3xS3Ih681WT
        2XLAxOWftnk1u6FGXSdqUgvEW+VW3YTj82+glEn7TugVngIxFzgxg6dCzJ0LlDeo
        rzSkXqCsPZX2IwLZE6sYoX7QYK7tub+1UQPEr/COXmYHtkF193BINpCgAbLgdoQL
        ccY7Ncw4FOyGDmP+1RhMDJ1ubkniv047ENW/rSfplZ8PDgAjgWYRYVxqE+VwKN7b
        iYBnTxpzWC2jVQ==
X-ME-Sender: <xms:P6fcXpwHfiYzgpands3burvAv-wKVMpST-pbng51lZmuMbKkm1RxnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudegledgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejkedrgeehrddvvdef
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:P6fcXpSBRTKa806e_6FIn2dnWqINERbjSh_YdcCY5OMKW9syWKapiQ>
    <xmx:P6fcXjV8052-ncgtZ5QjEBzdEUbxIqLI_jMorf7SEjVs2qa1C98xQg>
    <xmx:P6fcXrjsYvAGKK-rMFcoKj2t3C82NocIWTI_q2PX1CUaste0r3STEQ>
    <xmx:P6fcXg7XtQfg-plNof_uKq9vWCWO-cmGiYfyiYHRtgcT2WBnLcpU2Q>
Received: from splinter.mtl.com (bzq-79-178-45-223.red.bezeqint.net [79.178.45.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id F172B3280059;
        Sun,  7 Jun 2020 04:37:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2 1/2] devlink: Add 'control' trap type
Date:   Sun,  7 Jun 2020 11:36:46 +0300
Message-Id: <20200607083647.2022510-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200607083647.2022510-1-idosch@idosch.org>
References: <20200607083647.2022510-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This type is used for traps that trap control packets such as ARP
request and IGMP query to the CPU.

Example:

# devlink -jp trap show netdevsim/netdevsim10 trap igmp_v1_report
{
    "trap": {
        "netdevsim/netdevsim10": [ {
                "name": "igmp_v1_report",
                "type": "control",
                "generic": true,
                "action": "trap",
                "group": "mc_snooping"
            } ]
    }
}

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 devlink/devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 507972c360a7..f06e7c2a0a29 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -7073,6 +7073,8 @@ static const char *trap_type_name(uint8_t type)
 		return "drop";
 	case DEVLINK_TRAP_TYPE_EXCEPTION:
 		return "exception";
+	case DEVLINK_TRAP_TYPE_CONTROL:
+		return "control";
 	default:
 		return "<unknown type>";
 	}
-- 
2.26.2

