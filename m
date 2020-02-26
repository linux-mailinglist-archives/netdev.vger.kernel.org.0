Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5E616F4D3
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgBZBN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:27 -0500
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:6175
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729828AbgBZBN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwjAmbhR47DS8jGf8EcHmrO/PPNn0iX1V/6pUTIlgpV13xpp1YDKOJhHC/5rm6Zz0wof2jMbaSUDS5jyTqd3ZN/fY0MkPQLOsFgsecA6Et8Ce61VJpxMU/A9dffPqoVSJFYMTgKn7tcsdp7m+lcrTzCvlwKTv2Yxp4j21ogek6KYduIIsxiI49maQJC7VUTU3sHvS6aPc2JYIurTPCj5QHvMCyAd3imAbXUD16NtMvlEnyjpqnrFhqZreAmWwHzqkLJzmhwzpUj8XGQHZlsmgYTPNdCTFufyaNck0Tymx3mmYT4/kUul3HTwk2z0kWc1uFof9u7ZBgmxvljWaZmehQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3SGnuF5WhQsmJ3JWMA+hqhBILusMhlf4wBliZDZ0/M=;
 b=jcLUAJHNfHhw5WzVekRC0NcSRkJKRvXlEcXW/ve482U8oSi65eBiRDe2o4v8p6LyuxivkoC/cwy4Lq1kQwne5yemIcqfleXMfM09GYpVkbGT4G6HY55WK4IGRkY373/RHXH0Vfb3eV7llj2BylVCRLY0JhkZV4I4nlzxJ9TdEWACuN0HtmDvCQYeqx1cS/tJCYy2Lo1Yl5Ti1SslXkyo/rZeR4lK1x10ltwMaov+7ijE+4H9S6/IBOuyrmAkl7zmumzXpIDR8TtEa7LmuANQlQv63Vnqeqikc9gGu34+zISdzCVNzDWhRXf4rWpfQTLeYLC7oalrDIzBRwYp15Zbdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3SGnuF5WhQsmJ3JWMA+hqhBILusMhlf4wBliZDZ0/M=;
 b=lD4uBbHZtgaytG+mZSnPePwRVnr38uZ7EefxJl45zzkD+bJynpBHyqbA9giZ9smBqvj3lx5BrCe1Dm3T8yQ8TzEaaAgYrvdv01fJjdYaavDuF7fTL5A7qKawjiTWLOQkYVRxG9SQCR6yd8yZNwO+wytT8mXGvvvjEBFSD5i2KAA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB7038.eurprd05.prod.outlook.com (10.141.234.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Wed, 26 Feb 2020 01:13:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/16] net/mlx5e: Define one flow for TXQ selection when TCs are configured
Date:   Tue, 25 Feb 2020 17:12:31 -0800
Message-Id: <20200226011246.70129-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:10 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 35d37133-d37c-4409-4b53-08d7ba590c6c
X-MS-TrafficTypeDiagnostic: VI1PR05MB7038:|VI1PR05MB7038:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7038483CC04BFCCCBEF8AC9BBEEA0@VI1PR05MB7038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(189003)(199004)(81156014)(66556008)(6666004)(4326008)(36756003)(66946007)(1076003)(5660300002)(66476007)(16526019)(6486002)(186003)(8676002)(81166006)(8936002)(54906003)(6512007)(2906002)(2616005)(86362001)(316002)(956004)(26005)(52116002)(478600001)(107886003)(6506007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB7038;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AvUO6ELf2TI1yJrVzPsiBP3t96FTn0s9qZdB9ZgQ+yUFhWkITrl9UJF8HpFWFbVZUw6n5ePWOPdzp5RY59m7CuOWPi+WldEpWOsRtSTNTr1f+o3Y0i0CGQrLOflQXuzM214dOpn1b8uS+ZQ+ifCBJYD9kVZptaF4mJ+BBCfUdHHmTwU8IS/RL/Htdf3nB3KBh5RCaNwOU5932lqxW4SFmQwPQZXB5nxj3iZ1u8DGctRQ+5FNqUUU33UF4uksd5y6n+do1cQ7AxlZIZDV1THk0lRO90w1HmBxK/KuQXsGqma4eG+wsBRVHXB1qRV3TLMhSyb7oEOt5moxpOQU2CZ5wnIqx1onTFwW9uMyYKnym1zr/LT82FUsnf5YDS6JJDvSw4D+nkQGp0SEzNJrwBWagmcYjU4Xa/Us210rZ2zE7KU9cLIypzhTCJePFcg3Q59l4C3Be0uPcQuP88sQOFpnOuh+Iox0iO5GtSjHCJgvCwinVax/xQkDXaXm4u3z11O+JU4aN2OTmK85ytIr6N/uAGheaki2D6op7xBvQGCOOTw=
X-MS-Exchange-AntiSpam-MessageData: ZLsiXTbnmSmR+I7QqtWuZ21G7Bf884SM6YJk4MA1HMkonsJL/jRoaNgh7TuUndRSH7VAA/sZwQ2kP6SXuNVTe1d1ok56yhomGmwzcNDAQP4TEc8yv114z5LL7QY0C8lW05UEPFucWdUXg7pccWm2+g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d37133-d37c-4409-4b53-08d7ba590c6c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:12.2032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+7xRsuIDlIErHtG6xAK1SfqXd0/rqlSaznUk+PKm3cks26MvIt1W6RiTwpjzf5i4tkmUOy0KA7VK6bSvR3PDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

We shall always extract channel index out of the txq, regardless
of the relation between txq_ix and num channels. The extraction is
always valid, as if txq is smaller than number of channels,
txq_ix == priv->txq2sq[txq_ix]->ch_ix.

By doing so, we can remove an if clause from the select queue method,
and have one flow for all packets.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index ee60383adc5b..fd6b2a1898c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -72,8 +72,8 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 {
 	int txq_ix = netdev_pick_tx(dev, skb, NULL);
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	u16 num_channels;
 	int up = 0;
+	int ch_ix;
 
 	if (!netdev_get_num_tc(dev))
 		return txq_ix;
@@ -86,14 +86,13 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 		if (skb_vlan_tag_present(skb))
 			up = skb_vlan_tag_get_prio(skb);
 
-	/* txq_ix can be larger than num_channels since
-	 * dev->num_real_tx_queues = num_channels * num_tc
+	/* Normalize any picked txq_ix to [0, num_channels),
+	 * So we can return a txq_ix that matches the channel and
+	 * packet UP.
 	 */
-	num_channels = priv->channels.params.num_channels;
-	if (txq_ix >= num_channels)
-		txq_ix = priv->txq2sq[txq_ix]->ch_ix;
+	ch_ix = priv->txq2sq[txq_ix]->ch_ix;
 
-	return priv->channel_tc2realtxq[txq_ix][up];
+	return priv->channel_tc2realtxq[ch_ix][up];
 }
 
 static inline int mlx5e_skb_l2_header_offset(struct sk_buff *skb)
-- 
2.24.1

