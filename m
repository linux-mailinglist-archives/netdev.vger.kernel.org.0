Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7939C292360
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 10:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgJSIGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 04:06:15 -0400
Received: from mail-eopbgr40132.outbound.protection.outlook.com ([40.107.4.132]:60982
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727349AbgJSIGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 04:06:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYMVhmWAyFPSuNCLJI5ojIGcpzzZWmDOH7j8T023IpXMCdF8wWu5/eqEHaWRvOKRoktiWOo2g36W/QRZ/q3Ib2F5b5RIcBks+vL9MAG8CKCX43ov3ANSMqLZZ5rfZdKRDhQNQqlSTEVuJj7mHaXoZwrvtF9VCn5W2r+8q7C9aOMBLlr8fjU2NYMvAC9L0v6+l8XONmQ6Vx67YQRRrzrQpgYGlPTX7Icko/0kxh/zsQAHCHSikmnhELvHCKvr8ZkyJ3wJPvZROiP8Lb1AZOqCiHJKGwFwa7795gEjpGO+xtVqa6KToCeXWVVHZ9yv8KHWt9yAw7yNWozbrBXkKTrHjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKsASKRtt4ZRrm6/wCKM85dRjL8wNXrn5nVCKqzI7Es=;
 b=mvQE0cRxKLN1/335VxyduiRBcELNi25uLlphH9a9CvikUyafjT3i17vtP8sAHCc6qUR2Qx6DwYch7m8yHq4wvlHAKH9FHoP35wlKXGOlrol2p/MrIk5MDmzz/aqlI8/ZZsKX/takS+EXSY9pmOMJBDHAb0IIkzsAzawrunbi9jnOuXn8yaicTHOAU2B32qEQbxgbZ4faEzSNhg9lBp6z1UOd4/sl+9DrGtFeUj973GRuHjWARs1X9D63/ML/7QhryIp9Qu1/pDc4prkY3KSIJ6Ap3RTW6EnHRm2XMlzNMGE2nsKVOgu0aYXhbDgQ+OgII03ECZTLCWi40/I60g5npQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKsASKRtt4ZRrm6/wCKM85dRjL8wNXrn5nVCKqzI7Es=;
 b=imvtqLmE8hpvFTtLhGS5wlnl3CIq4Tg0aYXMN4nBVsj2EmqtB4zWJcQSfqc/+6IbJcE7xV2wGJ9k4wC3H27Rp14F2jpHCJI7dBdtYUZmbpHBhaU2L7rhYJDfyAg94zOx3GtEJjDwOqN2mLSvAiwX31grlv1VMPaBFBZQKTgZAB8=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB4258.eurprd05.prod.outlook.com (2603:10a6:208:64::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Mon, 19 Oct
 2020 08:06:01 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 08:06:01 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: [PATCH net v3 4/6] igb: skb add metasize for xdp
Date:   Mon, 19 Oct 2020 10:05:51 +0200
Message-Id: <20201019080553.24353-5-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201019080553.24353-1-sven.auhagen@voleatech.de>
References: <20201019080553.24353-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.24.174.41]
X-ClientProxiedBy: AM0PR06CA0138.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::43) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.hq.voleatech.com (37.24.174.41) by AM0PR06CA0138.eurprd06.prod.outlook.com (2603:10a6:208:ab::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.23 via Frontend Transport; Mon, 19 Oct 2020 08:06:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a44c9d23-c4f4-4946-1cf7-08d87405d15e
X-MS-TrafficTypeDiagnostic: AM0PR05MB4258:
X-Microsoft-Antispam-PRVS: <AM0PR05MB4258A571862D139F92B4C6ABEF1E0@AM0PR05MB4258.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQVXlcBC82F4lW7JZGtcmSAxMfwEVakqBpMOTwftOzk5VMebKZcXuI86JNAXkVI10z7bjiLpa7c5xCMCvQ4mt5vCx+kIaCrSIhBdRMuwk5LBGLfN0zkW6NhgWOJBzclKD6ASRhb5Gmil40UIWdNwV8gUzlyv9EekmUXAwUBjr4JWofN1AqSGSqdFckx0cqfbrechtqYw1g4sDKZ+LWvIR0rqKSkLarabVvRopEMcZyxlwhBEoolkbpTTOu2JcciuzWe+yVfU0whFXB7GI0FyZ7rPBmBLk5SfTyP4REQ+8KNwvZWS0ERN9etu29Vc8aZuM/6/09Fq3ytX+7O5uVEY4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39830400003)(366004)(396003)(136003)(956004)(2616005)(6512007)(478600001)(52116002)(316002)(86362001)(8936002)(6506007)(5660300002)(9686003)(1076003)(6666004)(2906002)(66476007)(26005)(4326008)(186003)(66556008)(7416002)(16526019)(66946007)(6486002)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 12dg/ubbhdOIj/FYmek7FoISha+wVPW5WAunoIzPLcc9pX2438EkGZbtiV3Nf94yQ5uFJgR1nIlTHp3/p5AUymJ6wI9HaCM3EOCb6Z6YVjQNlh43To6CIfjXPnE3ClgYBZViji/cGkTyZC4rzEl6gKF/HMbo0mchjoyFVcLuURhHkQVr5BEmbsxCBYBMDQGGS51Nzc/HdxZbpv9bezDUUYj5ebP1nQOXxzzad4sTfifqyMQP7iQSZuatOp6Xxcpg9gacIFGJVsIxuYflWMm7v2sgPDi6xrfixpd3aeIaTTNMZKc4YyTSdq4LKtJYxG8cfT+nkcQlCKKmTyY4UoO6qEN7kql8o33F1zKOU6Cv/nsPbSoxK72rIvW4OH/RRpDR27cuFCWhCKOMss4PqW/ywlbghgSxDWIoJFwES6AAopd09/1qrNnsqLAVFgcpa1tx8vSDAO5qcQSTWIRALDfgaihicdBfkvPfgx454FvwMDHS4EYJPM4SOmjh/oAG3IeCB0wtvvbwcf7X0hHzmY2xyPDQoRev1nkfKK51VZF2nIrAjec/iZLIRly2k09GdMNjPbkC8/RdhkT33MV4pDdlCPdouL//i3xuKCMnOkidmGqx+8qFpE8GAqjQ4xLevaA+Qs+MCMqE4HsbwfqLrLeRKA==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: a44c9d23-c4f4-4946-1cf7-08d87405d15e
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 08:06:01.0732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQyj88flFDju+VkSYPcbPp9hAlqtrLPkgxqN9fGNfOLrYTziPq/lViip1v9dBw42T08uBGbxroAvEz1xRKAzzd3A2dNqeVc/VoUwFN6YckE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4258
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

add metasize if it is set in xdp

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
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

