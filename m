Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7856528620F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgJGPZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:25:32 -0400
Received: from mail-eopbgr00116.outbound.protection.outlook.com ([40.107.0.116]:11397
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727817AbgJGPZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 11:25:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5EL7TcCh/4zK0QXyNuhJQMrdju9cJL8B4xuAAWqg3K8Dl8zWHFmC6BsIuTlR5lfvGBjwnaYjsEg0MS3SzLYSveU9f25cwAcx+5bFYDpr3S6BVajsVBUTVx4dyqVXu+oDFHwDTpAXmctIES/0RRwPscynp/Nxf547qs4EgbQZ04tVSHzAOZx062WVeaEWu9oiNUT6cwzv5FlKq9d+XY6jcSiBEM5fiCDOU384VfkxpmoD/VJ9ih+zzW1+3f+yVcUn5ZbE6A8I+RlxvqMpYFu/XADBvDVEGJeAOzZvS896VCdFUcMhH0z4juVX5tplHaNBTczmrfAvNd/98jAvpccBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GrTuW1kyJ5GOXh4wrZclcvKN7O/b8G4kDI/WcLavfQ=;
 b=LdGorRe3eMbZ8dyKr8YOAehFqvoFHF8vLDRYL3CR9F2I8aTx2skyW9rRi5LJbfKX+C1nQ8T3Y3UPwPndLSJ82UFvzwRfI8MdWb5qsqrJUvwpKBpkFsaqJEr7ZLT0hIx+NR+gG9QP7A92uPGw4LiuYYybD2QYiBX8VWkOzHIf84xcLWPdQnEtQ3qugXt3elB0KnbcdxsHbNgJEKX9eQvKk5hAmyuUPkn++i864oG+ROP+8CuhvU51pQ/IJHKH3h4/4/Xmjwzfy8xOFIwyX7arj9TxxYeY7uPjHSBJpjQacM3BG2S36R1p1FtkKMZKfx3oJod1JrHa3SJFZOcDHGIvPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GrTuW1kyJ5GOXh4wrZclcvKN7O/b8G4kDI/WcLavfQ=;
 b=dJuduJ6999Qt18taNlyAUfqTTIkyYZE2SSN7ByoGVjP9mFC8/i+sBP1QKBSZTO9fjUcfRqgMNYBlWSAsBhhtnmYX98gOHayd7qAg4wFjsVtC0fz3zixF2Njcjzb7EE6MAfKRcUBqJygVg/dH5oVHef8cP7sRiTbtT9c781e/pMg=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB6082.eurprd05.prod.outlook.com (2603:10a6:208:125::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 15:25:18 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3433.045; Wed, 7 Oct 2020
 15:25:18 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, sandeep.penigalapati@intel.com,
        brouer@redhat.com
Subject: [PATCH 4/7] igb: skb add metasize for xdp
Date:   Wed,  7 Oct 2020 17:25:03 +0200
Message-Id: <20201007152506.66217-5-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201007152506.66217-1-sven.auhagen@voleatech.de>
References: <20201007152506.66217-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM0PR05CA0077.eurprd05.prod.outlook.com
 (2603:10a6:208:136::17) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from svensmacbookair.sven.lan (109.193.235.168) by AM0PR05CA0077.eurprd05.prod.outlook.com (2603:10a6:208:136::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Wed, 7 Oct 2020 15:25:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72b76a87-a47b-43e4-da83-08d86ad53260
X-MS-TrafficTypeDiagnostic: AM0PR05MB6082:
X-Microsoft-Antispam-PRVS: <AM0PR05MB6082C6CCF42B71C7AEDF722FEF0A0@AM0PR05MB6082.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GDMMNCZYBJPXMBd/SGykremIt73d86AbAnBxiV07X6OXbTd7yelto5zmUS2o1GuOrH8dez7ARdDlWQfmGxM3Jby0EUMkzFKrM7LMRmUcCvVfoMKxrT9UBzoMxRnOrYdpLXr7XcdWkvMQaoGaGXB/USvUc0msHLdhX5xlKhop7eNZQt3aadWT2OO+zx9u/Knm7cWhv5j8AxkrjXbYgA0LjWhpwLFonZcs7UFBaJfmGd/5CHH/WGEEJE1STe7xNq3Q16O/mDGODkOmpO8ShsYTeIEjfwfXHTA8rlmpUc/iXJIZqCaSa8KZN909kLC10a4feLlO4MII5Xe/s3p9q8Z7rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39830400003)(136003)(366004)(346002)(376002)(186003)(66476007)(16526019)(2906002)(26005)(6486002)(5660300002)(9686003)(66946007)(6512007)(6506007)(6666004)(52116002)(66556008)(8936002)(36756003)(316002)(86362001)(8676002)(956004)(2616005)(1076003)(478600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: NOn7AXTGz0lvVZIsGkme4lo/0udZnvHy50dnMsxXSiU2cijiFdpekdhy6J259Hsp62YFrCwIl55e4Zsa1RuWc/U3kw1olft/mA9dPjGbv8uAzk8nX4zHHRV8BEdAC5metq7srYXO1bceDxDtNAmlGKRAhL+FOcWY92OxDyebS35fKfLSj44GUXSDBCttprH46A1mvgbVTASwQeisFbyCqXINa5sQJVChZqdb5T9MtS2+czFcmMvNq7xi8pZ/aU2/3ykFSfRF4K0eP7fKhUxeSqdyh5OBZ5whLc3Ct8oDTTrE5odW0PgtKNUjP/jP023JAerRzExq/eOD7EQKXxbj8Xz108YEmMdpCAy+Rugjc1QAl0Mv9cGU8S5/dYJpsehXYSHtqsoO1A7Q6z3+EQjsKuMTwD4inphRxjTZZ8vWINQUwMt3QRnYvwq6HZZKTtsXZxY/CvVILSPZisl1X3hQOTdvSFkXql0LRH4kBfOh4L5uqwnmFHVfXp0+3GCm/lLL1+MLrf9oJvqLfSwXHNfP495wBmpmdt/BxsR7A3z4zD1YGAQP0S0luZ3Mmh2db8tbO121xdU9vlvMEJcLDL/Z5sFlzFiIsi90X60I/QMwIwMgWaclPMnxbUbJnURWjWt+07ce1lxv+U+jjkoaeR+kpQ==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b76a87-a47b-43e4-da83-08d86ad53260
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 15:25:18.0364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cdeBQuTU5c9mW1SNwCtjLjRmCi7KIZNPycJ9TkZeAz/gNG8zYYSj/0nPh0o4LVX7zQGXtPU5FIq3FWd/95IpWc7ljVz3ea3QKcDk5c1wG3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

add metasize if it is set in xdp

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 088f9ddb0093..36ff8725fdaf 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8345,6 +8345,7 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 				     struct xdp_buff *xdp,
 				     union e1000_adv_rx_desc *rx_desc)
 {
+	unsigned int metasize = xdp->data - xdp->data_meta;
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
 #else
@@ -8366,6 +8367,9 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	__skb_put(skb, xdp->data_end - xdp->data);
 
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
 	/* pull timestamp out of packet data */
 	if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
 		igb_ptp_rx_pktstamp(rx_ring->q_vector, skb->data, skb);
-- 
2.20.1

