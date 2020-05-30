Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCEA1E8DC9
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgE3E1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:02 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbgE3E1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJb9TXrs+RE+cK4yVdUT3pEZifnX+TxisI7vFXkztWLJLIVyOrbjh1W/XBUebrtD7jSTcrYwuODRXWo2fS8wQ+91k2rmmi7bSuhuaShBadiglnwkYew9mpC7NW3E5DjvGfBBqoZvBwLOWJW0jPXql9Sq1gdcOVfm5D3GLbZOJP4UqaD6Sh4ncxVRCBO1iQyA+y8gM/HPJbMFzGxnD4R9viHLmcl0LYhEv1+lQKiWOt5D/IfJDNtoQAUmiMUf7wM8VGuTVi7Ebxl/UywyI2jXN64oZJG1KIUGafjKoH2lYbNyBnYj2xreWaVTvIX755nFgDw9PNK0QK8HALOqSJahOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JABwtqE3u3mzawpjgidFsauj80ZX5GOmv4htwzup2vI=;
 b=NfSi4xz2phMPINDsYzee4JSsghj5RArFzlzVAXTo3hjFZGjwf3OXKqQLRuUdmo3Si1fLcsvFbQ9Ql6YSIx4NWtR/JveY5oameq7IZGoSsI9x3exETRjMARhYmyGLJzK9GU0T24lZa8lJzfXD9bqK0S3JO7vlWOhz2+fCuZw1R1h9wysh9xPTRWxCrGD/JA+GsPL8B0+qmUjMwO5PZdtbpI/Z4Voxcwnb8Y3YF2gBeh72DupM/p7Jo+DXNxcyngCbdRbwoekAROHUaB5RhRjEQ+cl6Pm4ReJ10ZvMKFDkaaDo4xWG1BPFR0gqllI+l4rMI8V/YnL0CFVQ5hPFJOv0fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JABwtqE3u3mzawpjgidFsauj80ZX5GOmv4htwzup2vI=;
 b=HmPb6SBe9OJZpn24O9pdgt2WFlaSVkobV5+EYIjMxLrCMIJDRYUwK0sn2GsGr7+pL5iKzpDMXQUuG7Jzzko0noz+1pX4OQeRwhNNwmXoxsfWmOp0/az4LG2tm7R3dze9YZYHvO/gb6BWhORZF1lsM5Tq2+rOi5n35ybLU18XX7M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:26:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:26:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/15] net/mlx5e: Don't use err uninitialized in mlx5e_attach_decap
Date:   Fri, 29 May 2020 21:26:14 -0700
Message-Id: <20200530042626.15837-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530042626.15837-1-saeedm@mellanox.com>
References: <20200530042626.15837-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:26:52 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 186c8463-5b79-4f67-f8ee-08d80451ae45
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3408C01C609049FFF0229035BE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:206;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DAiitf3JQ3P+9/vTG8xaaP9D3FQxo7mPz70PAHMo657KgZ9lORoyKNuzS47oAc6mjPGO6zxnTOvl0z99WKBsy3gi57210s+hWsPNwSOZ6P4m7YMk84unXruLhXGC/znmCfLQoDUCFO2LSDroO/NXlyoOh6yGWvsbcRzA38AnRzPWCqfIKgN8GZ/IK4FQAp4ApVoTx77zIyjAXiWeDycoFY1lqw1JZMqM3/zCSXHTHf59qLzkLqvccb8OTiSMCEoTzbk6mXXxWjuOWl1X9oT0RDaQfU2O1H6DYJA+YszzXbd31ad+WGqbK2ri20x92vOJl4L7CLIsPhpX2NeXHuy9aG4LoH9S8a9+JG4Dgbj34p42fUNTHZ3OEs4x0wiFukYxGdYB+cq9gnsBcyS/kN5tl0QMnxlWqE7Xd983x7oY5p1kbs4b7mNengnNi+hcYKkSXzgF4vaU77KdUHPUCxFzkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(966005)(478600001)(1076003)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OSVv25CC5v371Je3JHOJnItrJcemZZkEmmqdjbj41tAkFfcJe1U4nucaAfYMivE4NHw/kCkCrzpI4nYMUELZ8hm3ubIwc+1OArAj3TdNr2gEDVXlFDdCUIHG2tT4pg+Crl8fswMgeV0siwlEW8kGsIdjpa1ElycMZ0zGtghZjafYpAoc6AV/VpmqH827kUiK4ybOWGFxJUKJeJ6hPZm+XjZKeDL+7FeiS9Xjf36p1JOBbKvgH5UhjBHr1k6yky54Z3PtvmS9KWiI+T3RPkgJwQxiJbnGWESL3XXDBzMly81Iad42xHB81R6UailHzEGKEglhhwzr0yerBZIvx8m9z+Aq/qBa4wSGH1noZ3fUOVuusnbLtYqCy4fA2jc7L95gqkOM+Jzgny2iUd/uBWWXDMXH04QTNnJ5CDCUMSZn//zcVgIchIKBmDNcBRYXsT8BC7IBXMoDrRdu/tEBJbiFetoVHad/IDogHSlQMXCIDkI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 186c8463-5b79-4f67-f8ee-08d80451ae45
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:26:53.7697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9mDTQ1PNvcxV0Re9cXM8w9LCDSAR5wappQKePszx+cIbYKftzelnMMrcDQ8A5ieeS+Rhc5KgA/1y9iPbBDWf4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

Clang warns:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:3712:6: warning:
variable 'err' is used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]
        if (IS_ERR(d->pkt_reformat)) {
            ^~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:3718:6: note:
uninitialized use occurs here
        if (err)
            ^~~
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:3712:2: note: remove the
'if' if its condition is always true
        if (IS_ERR(d->pkt_reformat)) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:3670:9: note: initialize
the variable 'err' to silence this warning
        int err;
               ^
                = 0
1 warning generated.

It is not wrong, err is only ever initialized in if statements but this
one is not in one. Initialize err to 0 to fix this.

Fixes: 14e6b038afa0 ("net/mlx5e: Add support for hw decapsulation of MPLS over UDP")
Link: https://github.com/ClangBuiltLinux/linux/issues/1037
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0f119c08b835e..ac19a61c5cbc2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3667,7 +3667,7 @@ static int mlx5e_attach_decap(struct mlx5e_priv *priv,
 	struct mlx5e_decap_entry *d;
 	struct mlx5e_decap_key key;
 	uintptr_t hash_key;
-	int err;
+	int err = 0;
 
 	parse_attr = attr->parse_attr;
 	if (sizeof(parse_attr->eth) > MLX5_CAP_ESW(priv->mdev, max_encap_header_size)) {
-- 
2.26.2

