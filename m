Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06AD5B5123
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 22:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiIKUki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 16:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIKUkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 16:40:36 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021023.outbound.protection.outlook.com [52.101.62.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AAE222BC;
        Sun, 11 Sep 2022 13:40:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLFFA4E5qctspooiw5yghbPC0m0qtuy/KRVJsPr+1/jEEpQWvfhcsvG1t7yn1TkHWYdGiGsy+x7Qr97fljyuLCojatP1/9tex7QaMFyYHxh0HDzpdNLt4E3AKrt9sAbvE2uHBc5beaYnf969jxU9zaKva40ZbhvTSGJ5Ue9wB2pGm4HtMKBpo7TM6R/dkx67nGob98zoOxUjEq7dFMcvJWLyALHQf210/cbmdsvtTE16iD2Bti7Nweh0btjVlRBg6PdPA/BVyWtnqtQX0eMty06VlToIeRC7gSaGucy5pw8PGxRMW5X8rm+y4RMlOfDUCo+8+nXEzre3VsqlbVszZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HqZ04fRvj+jUk70oPR9hq9VQGwD/RYO0EaRoRKDKBig=;
 b=XILCDe5SojuDqo2uZgIaHRPK2VOBTbF9+Ph6y/1uD5SYtXStoOafgvK3GIi+yszXG5GsBSgC6fjstwr3EAU7PJE40L4UJeV4kcP3FEgHVGMp1KfildvSEJo8q8rErb4Zt8939bSlGzYgGcexGxptf0ZOH9Q/7RRsU6Rwe1IrQT4TDzanYmSGg09agw2/icJilLmuIZd3Zc4hXY4f1r8Wtd1byMP06asZ6PYjn8aDOi7AHBz7eKww9AHG4XuIN3o37XdHR1EnyGXA2M9kGQTc2UhwvGnJOVs3MUmW2HfdOxnL9swa6+9B/9u4A/Q0lYEHSwMNPqAOZiwNCuH+XIpGPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqZ04fRvj+jUk70oPR9hq9VQGwD/RYO0EaRoRKDKBig=;
 b=DTU4NhBWUoGb1FS5YHfuDG0ynwIFEfnXGfnjn3pUtVkOxB7TrSYmemyVPgRFmVZAONjA+B5k0CbCXtc/672FwgfLmqUI098cfyUgVhjFtr2kFpwle2d7PUQHOiehZ23c0OmX/CAAdZG1lJ8hc63k7et++kdNWkwCvJMd65wg3NQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by DS7PR21MB3694.namprd21.prod.outlook.com (2603:10b6:8:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.3; Sun, 11 Sep
 2022 20:40:32 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3581:1d96:33ac:7305]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3581:1d96:33ac:7305%4]) with mapi id 15.20.5654.003; Sun, 11 Sep 2022
 20:40:32 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH net] net: mana: Add rmb after checking owner bits
Date:   Sun, 11 Sep 2022 13:40:05 -0700
Message-Id: <1662928805-15861-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0159.namprd04.prod.outlook.com
 (2603:10b6:303:85::14) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|DS7PR21MB3694:EE_
X-MS-Office365-Filtering-Correlation-Id: ab5b9f09-c28d-494b-7d1b-08da9435dee3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8aon7iKAHAJnGjsX7ORXiaVuuLlFc9dVbznHu/7f0tyAJaiycx26/7dKPvWqb/orYv76iSnA3KBuszF/HzlxEtmA4MdK9Vi2lUKorY88AGDZWtCz0UFJZXGOK3kGK+AbBV5T4VYbckf7yoKIE0KSPz/xdGYedQM5Uq5niHsCx7O6+bwsCtYhBpakBldnMbuZZBYHsxF5+XbynkmBs2mjgpRFNJl6mS/3TXKZFIMcw+DLFJwESOCTmc65jpDBY7EHk0DjeH7W1QgjSEsEZfhxckr1OWUrjJD+X4stA/RBQ0prbcPk5/6KSSGmsFp+fPN5pFCvMg+mEFO8cAngvEQWm1AaWm3eq+JYkrmGpszLWyx6b0HyPs7uNui/SX0xbp/144R11RbF+fIaKUh50aAUKtIFVOYdCNXEw/86WqgqfSK+3uJ8EpQ+sGEFNsJoGVhsNpUzH/724uCx8HKS4xOaP6DX/k2XlmcJg6Qe4ulDxA7sX0cnKibnphvnMpuQkNaz73+DIWFTVLAVwRVrFB//DxziOelh/gecJeMwWfMx0Xf4feVgn4jXtKbw12wNLFF1auplaJkg5cZ+nSaji4d1rwdY0Rcw5EIZy632vcRdg6E6cUz1SQdk3y1DBke+AXW1Dt5trV+8KIGVVeQ+SqwFumSpJJSsa5znEBYGB32GKk8fEV3gxJZEravhHsPAYKYeXZDwISBMADXJV5AuqIfHe8pGbAWG1NPlYXYk/qBFurDFxJ791claKufzH+w0R9916UTRdo5GgWi1Vb5+oUeWkf7JyKZF6lrxdC9QnQpNC4OeYs4gYbdn9zbt+3MYrsfQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199009)(186003)(82960400001)(82950400001)(2616005)(6506007)(316002)(10290500003)(41300700001)(26005)(52116002)(6512007)(38100700002)(6666004)(38350700002)(66476007)(478600001)(6486002)(2906002)(36756003)(7846003)(8936002)(66946007)(66556008)(4326008)(8676002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pf8PePbBGUIDo85DLjwJB6H6dEki02HPcqGQIHj3LmmOolwjCVbBztnmoLZ5?=
 =?us-ascii?Q?p2Dq+aqGj7dU21e6QS/uIHHF1t7aOYqyO4OH4RYAq53jgFAjE/gYElgJSNbe?=
 =?us-ascii?Q?b3fAzuqF+oyJ94nU7tZtdv/2KDDdq6vb/fPTl/Fb9DRqioelJ2TnF9zhbR+v?=
 =?us-ascii?Q?Q8jGml9HvRvqj0JuCFxjtTWJGABNWRxe9U+LQoTi67ZajLBRT3l81M5KMxZs?=
 =?us-ascii?Q?w4M7X3xV/UzY+EDQ+6r4eoEwAldnHkVcktFMv8Pj3z6GR3hO9sDPG3erpTph?=
 =?us-ascii?Q?yM8zmrBJ9XWBxf5Xau6HPd1Ta6JOOqsZp5byQ4BuexgaavEA9ZmvZHn45VqZ?=
 =?us-ascii?Q?rII/DQQKyXz2cT41U/0PBLf/FYEE0JiHshuVwUzftguNRNYPsctpOlhuhIiE?=
 =?us-ascii?Q?3KWeR07jVqROIK9NQqyzCxQg5UWT/NI8Cws1YgJsuJfQYRSsbRufSkUYyP9P?=
 =?us-ascii?Q?+K5Ppf+NQiMWKrT+8q8ceMqhk2KkyR6OC3T+9ZhTBm1z7f/Zvn+t9hkwTEtN?=
 =?us-ascii?Q?vnV+ngcQxYjmuOV4nCdNi2M6vSM6afiXnVg2jLdtFIyrPZjvY+gzI2c0a58A?=
 =?us-ascii?Q?vUHC+a94kFeqckTrO4PN6V1FPSxkJKf6DGz8OKiWaIgJQVbDQPYP+/2l5A83?=
 =?us-ascii?Q?9QQIVEIiuQo0Qp2dUt0DHZhwJOhjk3NDnhD80588sswUzEF2qGr5lPEW+ojs?=
 =?us-ascii?Q?tiAm1ljhw2a9Q4Fw9zxSQjNB4FGYAbOFaLJNjiAFP1iYrMAL2unma70ae+NH?=
 =?us-ascii?Q?rU5bpLHkDapOTeHB7TGQAx/Ze4xNtKJzpe4Db8modOI899QwSQH/d8aYnflK?=
 =?us-ascii?Q?y0DdL4RcXQB+ImzL1oZYMwhpr5nGihM5RF49joyV6N5FRcy/+gBdpCRcoohS?=
 =?us-ascii?Q?yKGP3GPYimCWMfqGlMsD4hkaw0+oR8GDdWtmavn70RTD5/3eVZi1Efw52h+r?=
 =?us-ascii?Q?vjHYwOMxwAUGthqFpQqGWD67gYiPPKY4es/55hP0U6sfFtjOpF7t7es+eEWX?=
 =?us-ascii?Q?ZI1c46DBj6jxwkr0jU/+7xjRIusf8bLV3K6xpOzLCxfF8l5tpZlLOebwHYiB?=
 =?us-ascii?Q?okQS28TsSO/D+6+bl9kKa9kUuliXymGEnyBmCwA4PD2HroTiOiL3TjmScUXI?=
 =?us-ascii?Q?sWpCvCC11IhJmqX++VxU4/cTbXN4zgtF3KrD6h5WbTPExOFebrQU925irByP?=
 =?us-ascii?Q?vZlAub413rv1iGOg9V0as2sC6LkIRi0JoKdBg0oHgoUs16nybhrHV0LYPZcA?=
 =?us-ascii?Q?hNIx771QIxrBn3Ok4snk8Jb0WJn7PqO/3gYh6JunDEJhm7hzjlnn6qWQT4Yn?=
 =?us-ascii?Q?mQCyDfl7h8q68aCwerizphUN0CkIAL2l/BvfVl8ac0xon1egRFgyznnfQt1W?=
 =?us-ascii?Q?aASh7td5Y31iVRK7Cyby7F2/6sTY0+AOj15ISUOKTt3LWOddX84ScMS6hRKZ?=
 =?us-ascii?Q?JTpSp6pcfGuCaDnD/EKFWUjxGQxPjBtazegaHK7SSnx4rnSt2zKLzabsGTg3?=
 =?us-ascii?Q?GJwN7H3kaK4SKo2d0Ftov1OoSSVsgKwOXyOIK4lvOh8Wv6XvnirXqdMp9b8k?=
 =?us-ascii?Q?tFi+W4AHe9EOpr4izVC8YnPsKYUC0cBHb4WewHhW?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3694
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per GDMA spec, rmb is necessary after checking owner_bits, before
reading EQ or CQ entries.

Add rmb in these two places to comply with the specs.

Cc: stable@vger.kernel.org
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Reported-by: Sinan Kaya <Sinan.Kaya@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 5f9240182351..e10b9f8f89e1 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -397,6 +397,11 @@ static void mana_gd_process_eq_events(void *arg)
 			break;
 		}
 
+		/* Per GDMA spec, rmb is necessary after checking owner_bits, before
+		 * reading eqe.
+		 */
+		rmb();
+
 		mana_gd_process_eqe(eq);
 
 		eq->head++;
@@ -1134,6 +1139,11 @@ static int mana_gd_read_cqe(struct gdma_queue *cq, struct gdma_comp *comp)
 	if (WARN_ON_ONCE(owner_bits != new_bits))
 		return -1;
 
+	/* Per GDMA spec, rmb is necessary after checking owner_bits, before
+	 * reading completion info
+	 */
+	rmb();
+
 	comp->wq_num = cqe->cqe_info.wq_num;
 	comp->is_sq = cqe->cqe_info.is_sq;
 	memcpy(comp->cqe_data, cqe->cqe_data, GDMA_COMP_DATA_SIZE);
-- 
2.25.1

