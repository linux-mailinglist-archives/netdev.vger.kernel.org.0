Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6F12AF729
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgKKRFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:05:10 -0500
Received: from mail-eopbgr00112.outbound.protection.outlook.com ([40.107.0.112]:45497
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726338AbgKKRFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 12:05:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VN54YIXR4eMFksiGEFniAOLm/e/FpGTPX52KbKlolW0aNvSHvqhFHb1uMPUCBV7xHeZzhc6mScleK65CnC10jBZS4QIHkYjoR4mmzttDH3vTZeIn+M0+nFzi2boMY+x0bOJE6Jnp1LSP2Z/dLkr+2Kub2qK83YZnVpdqucIjcuGT9dg/G1L115UQoG3W3b0eIGpABkY/ggwPBcVjYcbnNm1w2bztSlVXEzYbcvMzufPndaiOVxUZVI41WWAmAL33C9W5v7btTZfWjK3YmacMz7JfmEGSqFzj9bsU+UDbLgeCIUUFEnurmq8O6IlhwPztEDIoCErlsIA6BeC/12EBdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ykcnu/lZP2hQbZer2sAAFOrx5kpJGXJqrdCK9Uwb2w4=;
 b=Lokyk3op+0DiKtvqs0qRE44jEGX2l/Q+odrOMtp1hnMq0MD36UXOqDGc7ztnJjbwlXJvdzUX4drus1iJRJqWduLIzrsNhyASlk+hMuIKyAWvOrOowttdMFelMN6nN10+BryHO4QdmrfbUSCTvTxyHx0OdwNYfOQLJFZu24bAHzvgQ2wcbW+zx/Wg1HEMghZ/nQPMHq3jH5ZP23gsSovmRz5qw3feoNe2cCLCQa+gCuPUJFhuxV3rcXipkMN3amqpHv52DiEZL9sGf2yJFBtn/GkfunkxdDO5T+nq526UdVp4apqOL9H/mOxJG4vB5CLGx5fCJAKWwzDLPJe/Bf+Pug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ykcnu/lZP2hQbZer2sAAFOrx5kpJGXJqrdCK9Uwb2w4=;
 b=SdNYWtk2adf+EY21rs/2DmvmNObZGrPwTfOzzfMCz2aq7nx/8l8+e/CXc/rU1oOUOqJPdPRF5psP+BRnhYMomKVeDlUXTx3/mWEVn3vHxGrPmIpnMN2OoQHwcfJuH0WYzHLi4WVBgjb5QX8t8PYPsfBeDEJS+lssmKBbtHsI0Ag=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR0502MB3921.eurprd05.prod.outlook.com (2603:10a6:208:17::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.30; Wed, 11 Nov
 2020 17:04:59 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 17:04:59 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com,
        pmenzel@molgen.mpg.de
Subject: [PATCH v4 4/6] igb: skb add metasize for xdp
Date:   Wed, 11 Nov 2020 18:04:51 +0100
Message-Id: <20201111170453.32693-5-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201111170453.32693-1-sven.auhagen@voleatech.de>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.209.79.82]
X-ClientProxiedBy: FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::23) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (37.209.79.82) by FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21 via Frontend Transport; Wed, 11 Nov 2020 17:04:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecce5d58-d9d0-4ac0-4176-08d88663ec3e
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3921:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3921D16593F41DEC03333274EFE80@AM0PR0502MB3921.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ePotm8joYR1EII26D94qO31P+88UWkbk13092i5v1Lkpn6h/yGvybr8ezWGKz2XTdrXSFqGHbfja+spKQzxCXoLaiGuKovP/t17Vc11jmHmyqm0jMcIfAMwEmra8abWK0K6+ykXI+879Tzg4rCVi58azI8EnJrcgKeifyi/mC57vbdGYWQNUm8Oz1DFoIN7ltEiTmG/1sn1oUovQmbS2pBf9kI6oHlT+nlCwdTFpSAA08j6PHjK1Ir5RUOhOD5OIahtSnBoixePp8tsKcmZd3W6tmFDBl/mjJLmtzDf5fL3P/7Y4TPtQZxqC9AhvGsytkSwSRkaFBXyqYHTXz1r8/NovOJAjnWOAFkFkBQv9+X+ATsSp5itHxLScjP+70upS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(39830400003)(376002)(16526019)(186003)(5660300002)(52116002)(69590400008)(316002)(8676002)(4326008)(66556008)(7416002)(86362001)(66476007)(66946007)(478600001)(9686003)(1076003)(6666004)(8936002)(26005)(956004)(6506007)(2906002)(2616005)(36756003)(6512007)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: D1xtuImoi66M0ZeJfYY/LCMPwO1QgbEDfbQYQEIYY8w9AVT7KXKArmjjfncTEdDXz50BcT+VInEioHUUleNX/sEEVjBLNVOhaq1cXo9LWGI6QDSdfFbUsmIw3N7UIAXOGHrxczaeuSOUZ44SAfBSrgcVuxE77QVssyEoHlBPY4qVa5iE5EQZbblO+ckHWNVLP6o8qDoTQ+6aALRTqX65V51u57ysEOusPmo/gS1AbJI4TB+T7BvZi3FesajWXeMILkoR7HN+YP7Ih46QwY3Ui16EgSdRudbFnSuOAtPYG6X34KzcMxQ5wFIIHvcbOqacnsFKW1yxohQeIIpnyaCh2OUD3JUlA9F5ypo5DKe1dyDmSzl/5dgBqaCvhEf3KGaUcGmqQPl2Xykfzw4vtC8SYBw6f0uauW6P0ggUWTdxp+ystVzySi/CKsaZqFZUpYfijB7SSdMcw7HNaWe0ktggnhaBoPt/8V1AbTLowAQ4CK/R8rKPfQRPL8q0WGizkIhMP7s9R04kEcABmYQaJmr0FSbdIIwoB9A9KC6am7iUfaw/voDNRjl3zsI21VmaG2lIIjt/m9nNFTZGYA8YqR/mcl6S4PZQxZ2oQL9yQkZkteAOnYaVJdu3ysso7XlSdI6OLjDaxYNIFCngJo5Gjh0zbA==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: ecce5d58-d9d0-4ac0-4176-08d88663ec3e
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 17:04:59.7636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GHcrv+RW4NgBoTrMT7OVUObdLd1FBh+j4esenw6ONw1EarWNwxQbbefhoM7AlkR32+jRnl56yC8fwbL39/47bIMBCngvm8Mvf3klkjXPHqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3921
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
index a0a310a75cc5..fa93aec0ba04 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8350,6 +8350,7 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 				     struct xdp_buff *xdp,
 				     union e1000_adv_rx_desc *rx_desc)
 {
+	unsigned int metasize = xdp->data - xdp->data_meta;
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
 #else
@@ -8371,6 +8372,9 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
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

