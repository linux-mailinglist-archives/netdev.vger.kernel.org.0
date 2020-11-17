Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1738E2B6C29
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgKQRrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:47:40 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:46055 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728761AbgKQRrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:47:40 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 0A792EA5;
        Tue, 17 Nov 2020 12:47:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=WY/L200lo7M/hIXr1SO7KhQBKI/WdfLb8Wit3mStcLo=; b=jfWLM7H4
        xVSIdc2lMr07w1F8pn6YROhk4NKcxVH2fiRxhhILCPcMxqvzVzRJ2DD4FsVVpikq
        1haxZD1kNVimd9lyNUFo+nuXBOtunZqMq+k/n9RAi4hTVlTaGvtXQsjvzvooQquR
        nzSFIEMA9KOoTIsJt3oeKSVqeYwbvLZejxpleqSGiHy4wND86f03yOfEKU6Mc51u
        E7G8cetsnuA2MbNnvK12aq3Ga9dAnIATPYUGubi0nJQBkJXznzpFcXen1ary0pfz
        QvWN5yun5fkOfzJrJm6aL2FPw0ozbf0UDVCn4us4E78uynmsr0Fv6H7W6DRxRwG3
        dYunwNTleRoYmA==
X-ME-Sender: <xms:ugy0Xwb_-cWZSF0Lg9bEueOHkwFa5BIGwbrDvotsO3RsKZQJ9iNvhQ>
    <xme:ugy0X7YVD3wUFQ9GmC2_-EMVSr0Qpj882ROmtM75dwru_ezplxVH80vdcgIQhaAwU
    jIamBoPtn32K4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ugy0X68aFi_vpQciIoO4pWPMpfHt_Lsgv4LMRYpj9HhLMdIoZ5yO5w>
    <xmx:ugy0X6oCmogCgyVXzawNhatuQRzGyFYowJq1IF3yvEssaDJRgJNyKQ>
    <xmx:ugy0X7qi86RnQH7AJqKQTSnS5-6jlVMA3uNf9F1cyjGE8VdWMy-ENg>
    <xmx:ugy0X6WTu4ZZAic3iOzUp1sDs9zALNLqqHd2Ypj1yZ9Dlq7ZGvgAvw>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 048A1328005D;
        Tue, 17 Nov 2020 12:47:36 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/9] mlxsw: spectrum_router: Set FIB entry's type based on nexthop group
Date:   Tue, 17 Nov 2020 19:47:00 +0200
Message-Id: <20201117174704.291990-6-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117174704.291990-1-idosch@idosch.org>
References: <20201117174704.291990-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The previous patch associated a nexthop group with the FIB entry before
the entry's type is determined.

Make use of the nexthop group when determining the entry's type instead
of relying on helpers that assume that the nexthop info is not a nexthop
object (i.e., 'struct nexthop').

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index c791e7f75cca..4f5c135bc587 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4778,16 +4778,16 @@ mlxsw_sp_fib4_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 			     const struct fib_entry_notifier_info *fen_info,
 			     struct mlxsw_sp_fib_entry *fib_entry)
 {
-	struct net_device *dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
+	struct mlxsw_sp_nexthop_group_info *nhgi = fib_entry->nh_group->nhgi;
 	union mlxsw_sp_l3addr dip = { .addr4 = htonl(fen_info->dst) };
 	struct mlxsw_sp_router *router = mlxsw_sp->router;
 	u32 tb_id = mlxsw_sp_fix_tb_id(fen_info->tb_id);
+	int ifindex = nhgi->nexthops[0].ifindex;
 	struct mlxsw_sp_ipip_entry *ipip_entry;
-	struct fib_info *fi = fen_info->fi;
 
 	switch (fen_info->type) {
 	case RTN_LOCAL:
-		ipip_entry = mlxsw_sp_ipip_entry_find_by_decap(mlxsw_sp, dev->ifindex,
+		ipip_entry = mlxsw_sp_ipip_entry_find_by_decap(mlxsw_sp, ifindex,
 							       MLXSW_SP_L3_PROTO_IPV4, dip);
 		if (ipip_entry && ipip_entry->ol_dev->flags & IFF_UP) {
 			fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP;
@@ -4821,7 +4821,7 @@ mlxsw_sp_fib4_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_UNREACHABLE;
 		return 0;
 	case RTN_UNICAST:
-		if (mlxsw_sp_fi_is_gateway(mlxsw_sp, fi))
+		if (nhgi->gateway)
 			fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_REMOTE;
 		else
 			fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_LOCAL;
@@ -5640,7 +5640,7 @@ static void mlxsw_sp_fib6_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_BLACKHOLE;
 	else if (rt->fib6_flags & RTF_REJECT)
 		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_UNREACHABLE;
-	else if (mlxsw_sp_rt6_is_gateway(mlxsw_sp, rt))
+	else if (fib_entry->nh_group->nhgi->gateway)
 		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_REMOTE;
 	else
 		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_LOCAL;
-- 
2.28.0

