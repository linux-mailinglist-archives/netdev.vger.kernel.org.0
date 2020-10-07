Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA5D286214
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgJGPZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:25:37 -0400
Received: from mail-am6eur05on2103.outbound.protection.outlook.com ([40.107.22.103]:47836
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728365AbgJGPZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 11:25:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OheDZsdaOJdoLtvSJfD5MBv9i98APKFgDlj4jF6+jzVhoinFHSeQZWTh+b7xNPEckbhav414bew7tFiXfCo6pHsZSvDjwj0UhiX9ZT0q7j4dsG9/UbWG+DSCC+gCbfl4XlGSY2tywG5ZpPfpP50usmuoDfEV3OY4cqIx1iKCefIAJOXXjX77Qiz369fRwtW8AFXtf10N1IxekDT6ndPb72z0x5dAKaAVFuDlMImki2wdb3REvjPfoD6K7eOpOeCpfauAOUYNBIbGLjUz38qPvoaLJue0DtO6xZNurDvH0f9sAptxFalQxt2wmpPIpveLUGWS+sbDzSnVpRAz4VK0xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dtP7s34KALyRMZ6z1KK9W3Y2Ni4GBt1Yg1QZXE5dwM=;
 b=iEYKt4ms4Nf1emyvznOCXh45XMiuREwYlGIrcjCo7y/hFn/b+j5ZbKK63AxmyYzz2DuYyCQk2D5SpPE9BOUeQeLcaINQ6an0nw27JQjULUKbbkXUhTH7lJ8z4ONA81nTlLuE9eP4DN72KOpChGpyLZ03EKWhA3qzZ6s2maikX2Ozp9qCF9U1Q+gXljSgBAX8qxqKF2PQYbFKYSpQRWdvjmdrjuz6n93CiWu+m26QcW9BlfxQizjdYL0chUCUyFiHPlDXXAdoaHCm2sJHNG1Pro02SzcYZCmGhf6MYXRBiLuENz58fdLXnOhTCsCYLYZrcWAzxBnFoZiWaen63YqJ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dtP7s34KALyRMZ6z1KK9W3Y2Ni4GBt1Yg1QZXE5dwM=;
 b=ilrLFrLFI5Jh6XWN2lJM2hVVXovPT28FBHvMtEJIwAkAyHoDH5yxNQuP8TxedTr+m8JUeQ8C6c/iiTdrNqWPj+vQVj8JL/UKItGP4ERfKgi4FfWPIvklDqSbbBpgThzwr6HoA9vnIkTgkv+piZilZFL8eHjGEbsc04Fy2yJUtH0=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB6082.eurprd05.prod.outlook.com (2603:10a6:208:125::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 15:25:19 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3433.045; Wed, 7 Oct 2020
 15:25:19 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, sandeep.penigalapati@intel.com,
        brouer@redhat.com
Subject: [PATCH 6/7] igb: use xdp_do_flush
Date:   Wed,  7 Oct 2020 17:25:05 +0200
Message-Id: <20201007152506.66217-7-sven.auhagen@voleatech.de>
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
Received: from svensmacbookair.sven.lan (109.193.235.168) by AM0PR05CA0077.eurprd05.prod.outlook.com (2603:10a6:208:136::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Wed, 7 Oct 2020 15:25:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33a6499a-179c-4c55-db8a-08d86ad5332e
X-MS-TrafficTypeDiagnostic: AM0PR05MB6082:
X-Microsoft-Antispam-PRVS: <AM0PR05MB6082D5B5BCEB45AC73C3D20BEF0A0@AM0PR05MB6082.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:651;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AyLrW+LqGnhwXZylJhXEhqFE9E44j/+pPvVIdpDxORl2fNEVmxSa//ONOg0pOTBM6nHeavba/nH8qFOHZI6Nsc7ndijQ0QXF5+USW059m1xCyI4Q+LBIOWt8MlCgAavlriZ11b0rW2wQCZ3cDvZaCOa/aH7Af45Y3SF7Gpx22mHLEkx7jyil/p6oDiDcse48Qdt9TIwlU3gsS1SX2gcvlIISo3oz5/GkgwqWRQ6A2mu6WtZFrim5X531Sn/ofKY7rNYLsljwJh1oUH2JcLY6jhiAh5fJ6tkYPbEFDq7iNan3Fq2CD/qWY1ITzM2w5NIP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39830400003)(136003)(366004)(346002)(376002)(186003)(66476007)(16526019)(2906002)(26005)(6486002)(5660300002)(9686003)(66946007)(6512007)(6506007)(83380400001)(4744005)(6666004)(52116002)(66556008)(8936002)(36756003)(316002)(86362001)(8676002)(956004)(2616005)(1076003)(478600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: olPi5Xi4scvOrYyIHJrXBKESXhN0qxnGGzfVKOUCUtE6d/5z+azpfS3Mg/AV5i0A3C6JPyyqDEYmf+rr/y+V36i8DtzVswHAQ88llMKGu/JUgB2H2jL8gkAM9mIGYdoR6QYFTPO3XxSyhJBwCLiErpIBZJUgtFJaD6ZP7NZoNyNB2j59jSLT0ffk/j2LM/dhvg/baIxtVsr2ahiKB8PtTqGJ0QzAvlXPWMUZivum6/5wRdFSlUTbhHOZsm5xE2GASH6smssMMIL6bGya5f5/Jkuvn5wqYriuzHoiVLGW+Ti2/41iuwPtGhw0rDDl2eAU1XkpNcV1hUXBdIwNkYQNMeRcvusumx5DR+/tZkToQSJPpPqtj26gSSvJ/EzBdw/r07CxMVR/cu0HxqbHb0shF08z4Wcq494xGKBQlE4GT8h0EkPLhzji6RzAKuvn5LEh/8mFyp/n7CLThaOMF1R0MW0L7oqwev1IHAyt40CFAnMlhDbCMXMReagdPERPUb64Z3rGgRlWGryobQ9eVAXZ47K7L7CDask4AWleFuye1e5zurUe3DFdpdtiZ7ukUE7O9hcy+02A3F9KoPGkj/OTGpVTp8gOr37ZcFPA/EOZ/MpVk2JvILG8tdH/lsTUl1d2GqA1yo6YpmVixDzUL7/Fag==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a6499a-179c-4c55-db8a-08d86ad5332e
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 15:25:19.4064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZ+zNwXwitKQyOyMoMrRHQwz4i9ckghg2LdcYwNflVQMcOn99eXNd/0tr9Gwv3Vec1SvWVPtbPRdQ31B0FrqM81I/QXEZRzm8MDHcobjEQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Since it is a new XDP implementation change xdp_do_flush_map
to xdp_do_flush.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index f34faf24190a..6a2828b96eef 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8759,7 +8759,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	rx_ring->skb = skb;
 
 	if (xdp_xmit & IGB_XDP_REDIR)
-		xdp_do_flush_map();
+		xdp_do_flush();
 
 	if (xdp_xmit & IGB_XDP_TX) {
 		struct igb_ring *tx_ring = igb_xdp_tx_queue_mapping(adapter);
-- 
2.20.1

