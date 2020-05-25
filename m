Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9341E1816
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388992AbgEYXGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58301 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388814AbgEYXGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8E0075C0186;
        Mon, 25 May 2020 19:06:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=WWr3QRO1Ac5s7q5/MQ/dNltUwdNWdCUqynThwMVBBTQ=; b=ZRsl5LlO
        qgKX+MapUQ3rNaTkYGpf8ewBD08uf+2+jMReC0vNWS8CYpHshKmo1i1+pynz43Gs
        EW9uLs7a0sTLjnscU9PnYniFN6jew2P6z5KvkqJ7ycNrvavUEro+xlRbOmwBfZeQ
        GuN1gAj3obLOBVURuzAC2kX6Y5ptWy+UQNgpNyjp4uraSNqjicCB3cPl00SDwoDY
        Ng/hnacIwapxoVaXDiOAWVZTweMO2m6ERMhT9fSolA6oNM3ioruCYgoZeOy2LLFQ
        fhL6kgGavnjhF5ynSlfrWibW8ILk2NTUMQQ7f2YUdWuokL3waViPrWCsSTLdgEW9
        BBd8nzLUiUBYNA==
X-ME-Sender: <xms:dk_MXn9PiSqX6AdAX9q8ZZel8YNMs9MOM_tJK3n0T2DQ6F2fwO3_2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:dk_MXjsP7SxJ6CWpfbJtLE2kXph1oyMG-OcqNDJp7-j5inodcFNNsg>
    <xmx:dk_MXlDWYkj3DlPHHGLpqLSXTqjKhfznpLfjkktfVa943OTjRrgoSA>
    <xmx:dk_MXjeMRNX2zdi5s6iq-4ps_Ym7z9eRKJ3aJe_BXfahatenFtlYJA>
    <xmx:dk_MXm1HNpkYpo0x8cIy2hVz2q1VmhQ-tuV7M0zCdCcwuK_jRBhnvw>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 449683280059;
        Mon, 25 May 2020 19:06:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/14] mlxsw: spectrum: Share one group for all locally delivered packets
Date:   Tue, 26 May 2020 02:05:53 +0300
Message-Id: <20200525230556.1455927-12-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525230556.1455927-1-idosch@idosch.org>
References: <20200525230556.1455927-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Routed IP packets with the Router Alert option need to be trapped to
the CPU as they might need to be locally delivered to raw sockets with
the IP_ROUTER_ALERT / IPV6_ROUTER_ALERT socket option.

Move them to the same group with other packets that might need to be
trapped following route lookup.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index b10e5aeaedef..016df2c14f0e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4089,8 +4089,8 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(L3_IPV6_REDIRECTION, TRAP_TO_CPU, IPV6, false),
 	MLXSW_SP_RXL_MARK(IPV6_MC_LINK_LOCAL_DEST, TRAP_TO_CPU, ROUTER_EXP,
 			  false),
-	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV4, TRAP_TO_CPU, ROUTER_EXP, false),
-	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV6, TRAP_TO_CPU, ROUTER_EXP, false),
+	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV4, TRAP_TO_CPU, IP2ME, false),
+	MLXSW_SP_RXL_MARK(ROUTER_ALERT_IPV6, TRAP_TO_CPU, IP2ME, false),
 	MLXSW_SP_RXL_MARK(IPV4_VRRP, TRAP_TO_CPU, VRRP, false),
 	MLXSW_SP_RXL_MARK(IPV6_VRRP, TRAP_TO_CPU, VRRP, false),
 	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_SIP_CLASS_E, FORWARD,
-- 
2.26.2

