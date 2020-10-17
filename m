Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A78D29106A
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 09:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411578AbgJQHM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 03:12:56 -0400
Received: from mail-eopbgr80095.outbound.protection.outlook.com ([40.107.8.95]:15328
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2411544AbgJQHMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 03:12:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCVGx8DATYkKta2I+TqUhq/zguGESj9UASgQMjEjDqjsyY7V90xMxi6xJb0Jzuc4CltDynHXbwSIli1XntyMJYCKfIUbVS6YrSWHv3Y1ryGQcefmHOzb3VvmAH34SxfMtD+L4lwwxeeCa2Qc42PDyEL/QnypEkDGROT8k5aHwieqDXUY1tgXouCxTRyJxV1PN4YgJ9uF3VY3ghF48HvItH/peU3sqewyxSCw8TtRRSeBVkEkXzkldOTYBPzTIVeNZaFtTknBBxiz+xh5oZrVsF5a0+i9HZgjdWT4hnKcdUkCNMcnNXUTZCHonpcy2rdgpVEa85AE7kDB1VvhfueGIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Njhp8rDsTkzrzWV5S5Qxgbhm6Dtup7MCDCdv+f/53uc=;
 b=doEN/yGF1k0INj5ay7YuQY5UrMdkxCRpQ6WK6sXZPJi23UHYOIm5tXyvQIxbKcBGiOz2oSJCkTqWEjAvzxP7xBpzUdqtKNG+F2BwewJM9+/1weKx/t0K4bfSFNZL6dr3zpl/azJbVyJKhBMnTAvME03RaaTfC8KhZJWI0QSGZ64KMvBdODcuneUrL8ZQPWsru2lKAzXz8Al3iuKXqqaoaz+U1W0Or01aG6NQMq+xj3JBQ22cLWFgTxdhP9BkYoAEylctO2ad9dDNlpdyi8yBUM7kkgutRMbedouv7+mcjaoyuIBbD8nMpV5NyK50c0izQEIWiIpU6KQAGHfD7D2sIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Njhp8rDsTkzrzWV5S5Qxgbhm6Dtup7MCDCdv+f/53uc=;
 b=EG/5oWKdrD2UNFEC2WHlEswhxUatmZ5fiyFCYTNIgd/Uu5eqquz3iN52fUn0cdxD22t0I+t7kVPBcfgP3OIQYZ55vYsFQmtnZqL4mo3i+IcQm+nuoP0G8YFgqFooVftVYZBWuwgr8oX5fhGUzZRIPWWEvELc5t2tMGBRYH8Qj/A=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR0502MB4018.eurprd05.prod.outlook.com (2603:10a6:208:b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Sat, 17 Oct
 2020 07:12:44 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3477.021; Sat, 17 Oct 2020
 07:12:44 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: [PATCH v2 4/6] igb: skb add metasize for xdp
Date:   Sat, 17 Oct 2020 09:12:36 +0200
Message-Id: <20201017071238.95190-5-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201017071238.95190-1-sven.auhagen@voleatech.de>
References: <20201017071238.95190-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM3PR05CA0087.eurprd05.prod.outlook.com
 (2603:10a6:207:1::13) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (109.193.235.168) by AM3PR05CA0087.eurprd05.prod.outlook.com (2603:10a6:207:1::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.25 via Frontend Transport; Sat, 17 Oct 2020 07:12:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28629b70-c93d-4aa9-0cf0-08d8726c0b29
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4018:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB401818C67D00986D046C4BF5EF000@AM0PR0502MB4018.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5HXmENaNNRUGy07TB0bp8Cfu66GDS8TeHTuDxNDLXnaWXEeljDk59AeJKKzMTi24+va0WvjClD4efJj1W+qrIuKR4xtbFCVLv0YTnqncmkAZ18iUoU2mhzwlaGKGxh3cOK//46dDCxuJ2sTGiaSffbdgMjutlvHuPP525Z3wRDCedAJ5iUGqz+jzxnY6ZPfpps7yxelbbgNHCXOn4N1Iyw//nYFfcjbHsktOXUYwhl2I4dAbRVDR58aAAIrqDi6JHgnmIeY6GCeG1EQNkwcLNatAduElZONvayBPZ+i1qkdnO2IDVFN1y0IhsHk++ARnT5nVwTJpzOscjnaaqt/DBgYutmkH2BGTVJkBsMzYqU5/Qk+lRyLW2rgY7dFZ8yW+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39830400003)(396003)(346002)(376002)(136003)(1076003)(8936002)(66476007)(66946007)(8676002)(86362001)(52116002)(69590400008)(66556008)(6512007)(478600001)(6506007)(9686003)(26005)(4326008)(6666004)(5660300002)(956004)(2906002)(36756003)(316002)(186003)(2616005)(16526019)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: a32Gdnespu1q8vqKgMOci7r7dhm4e3WUqAWYuPOOsyFBYK6IVMrnQBWL5t2xu0YjthK+eq1BxQtC0V8z2/6seMsv3LOBw5gXj57C+6NTlAQUg0LyLxOm/dxSPUzmHVwUldg7nJU/01wyhlCEjGyMicwkgey0WMK2Q3+iKw+bXqsuE+BrPXyEwZ2QAwGplb4+GOmdO+LSV+fYI7R0pVBPaiGSqnA3Ilm4vv16Zcf/kmzQI90BYAewcRtUamszSAA1Liewz2C/tsUkZWoL076rYFXm2mnNhBImS7ycSUFH/6IUEDno7+R5dN8NZdl5CjKQgvUlP83psKdCijSpu33MlREGfe7E4RqZa9o+eaFaT6UZZd0O8J9oLzUL209PcDekPAcBrqBONsRerXdLhGA3EH58bPUjB65bBG90JddqoOc79WQrF43pje/fLEysi6i/E35LUQhSFzi6YVra9kiff3VkfX6LIBSTSqp/n1lV3mMhkbtXxkjIY8SVM3ygWCyGmqDWHK0ZGAcGGzog5It7Ipt2EbksfxRIOfRWH0qwqp5RXFA8C4+gEMPbO7EvCVbuVZEfcFnSGtdurXl32+uFyYCfYV6jM6p8wOpCnV5We58M20mdeAP2267AxXgAsyg0fcGs7RLAEG3FzxRfyYQerA==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 28629b70-c93d-4aa9-0cf0-08d8726c0b29
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 07:12:44.3842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lqk3zrIc43NVis8Ef8XGgVJoVgc2H56CL7Mm8A9gLN3WwgzO5DdE+r5SF2OkC1k7upGzrgbqqSwAr+PndmuzaaFNqTcfGlyt9oKcC4D0MWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4018
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

add metasize if it is set in xdp

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
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

