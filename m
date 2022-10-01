Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1A35F1B66
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 11:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiJAJfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 05:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiJAJex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 05:34:53 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60127.outbound.protection.outlook.com [40.107.6.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D8512AC9;
        Sat,  1 Oct 2022 02:34:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ks0q1nfSyRWNnU9ktA9e/g+Rh3RvCSKUWRci5PLZr6SWEa4tbSfwqUaLegCt8eBuThglm6bXyTACYvewlsr+EDYF0/qJINzvMql40Bx6CFwVWqceO6s24G0PFChVqrKzdIH27updJAxjdgd5Qbv7pdot8pB9NqmM+ov6poMO80wh0EeCSQOFC0NGXtMjXM/PqQA19taJiFvzyhfBhaLeYpRr6vim0CXbmTbjYtNc+wvq/K8CoQDEVdgKQapqn1neyMjK3i+j+0CKzVzL7xKq/w234tXibJTxU0MUMamBPy67IHLmsvmb+56Rrse4jDdVhUvCjn1MqBsjkOPCJRow4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3upemnDjOLGjatZA1k1pwI8OtUkhKLglwq9vxw09Qzw=;
 b=Pei5IfV2kDUNdmBz1N8deuHqffp+oKa65taqJt/Q4hq/8T5NxTreESrdYyr7l5FbVWwVM2thSKm+1hRR9O6R7AT5A+2WRmMjyxAIbQvWRDMSAzyXo9S33cDzWH7M+SssFn5s2eKX8INQSHEEDpgwhzlv/glaYCPyuhJ/zE+oGNOxMWoc0D1pXhd9gXngJINHhwe6cICWwrJ4yX0RbU9VgxQHcXS4JHQpZ+AWaECndrv77iOhNWXepeobSJFHrADU31OtgAahLCyY1eKvoqsSwQJdKlxmjbRXHJGH0Mndm4RtmGllTykO8VUN5LMFPK0bepBd/lsmTmigjAFc/kPWQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3upemnDjOLGjatZA1k1pwI8OtUkhKLglwq9vxw09Qzw=;
 b=Zq/+UrvYpGthroRjYqWiEgvydvqMPDd0l48EOyskd64pfREPejbhmcbT+I0Y+iU+uvKE0HD9vmV1aBkSOwJHRMNl+Q0aJOH/WaSW0e0jN8s+oRM9Em/D4FCKNVVjW5ACup2eUYDCD9CQAPEVVByVvHFcGR9IUhGAgz1ZRhVqx8A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0733.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:121::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:34:31 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0%2]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 09:34:31 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH net-next v7 3/9] net: marvell: prestera: Add strict cleanup of fib arbiter
Date:   Sat,  1 Oct 2022 12:34:11 +0300
Message-Id: <20221001093417.22388-4-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
References: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0696.eurprd06.prod.outlook.com
 (2603:10a6:20b:49f::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|VI1P190MB0733:EE_
X-MS-Office365-Filtering-Correlation-Id: c7a8ccd2-835d-435f-7455-08daa3902484
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3FRY7lnPfGbaBUevJiMChZabPDltK770af7d2sy31kX2RamMOtJLzlTJtNYN4d5urpixoQyW7NR1z6uWthkv0HBTDl3+zPt5eiJHJCJGKKVcePGEitEjUlBZy/8dbmz60clJIHOi5mAjV2sJEBkkko8WfU2FwtDfs6eXyv3jzdfxepyha4QBN/neYGiz1pdR1h2tx5hr6Aic8WFtama1pLvKSmKu3d160hPwe9DVDXCCmWwiwx4coHfPH2UVybjEuOLncPyO7Q5afzIGD7gr19Rp6h+/fSZyhJaCvaymBjhj5oOVHaBJXC1AU70z6Len3etJ0pAX+b5qbDsoOo9qMM8igBuotNPgcaMIreH+8OpudlZJrRNWKzfTcy0lqBIxLHRCcPixhe1R4gt3IJEqdJ9F5QIFH7dm5Q8buv834mzzEluxNYl5EdpQnh1VvDOWA1Z72tJ7fiyMFeWOMQDK3qbO9Fq0fl77jI55JNf+fWWuvFDMd1aNOsggm/EM6B9bd/YUSiyCIeeQ4yErCtbZ+Dqec94E1DEtkswv90UNrRrqJIpicQWsUO4GlY2NumWsu8g3fzvZeAKFr8H1ddVAqyOnVrcXFXcI6fhxI+6dRnpb8mx+ecGJWOQYOp5+QnBPGBS4bdpitLpi0xo96dlhVen6Pr/wrXNN/3eryPsM0JUd6CU8wsrxUnIKaowZfOA1uojKeuml1KhUJiKrB1LZsx7Xxv5cCZT+JfZLq5vMUn/tVHku0FEnnBjiq3v2N7E9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39830400003)(366004)(346002)(136003)(451199015)(66574015)(38350700002)(38100700002)(5660300002)(86362001)(26005)(8936002)(6506007)(6512007)(36756003)(8676002)(52116002)(4326008)(66946007)(66476007)(66556008)(6666004)(83380400001)(107886003)(41300700001)(44832011)(1076003)(186003)(6916009)(2616005)(2906002)(478600001)(316002)(6486002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/vTWym4DLe1FTRWIX86eBq/YaHFBLJOnWU3SaQMENJMmgb+dhpdB6KeoS6xV?=
 =?us-ascii?Q?/590dJSQLPaq5Ejb4sxvr+8+//jZ5BecwqXcDi3bSXQa4rEtdveTVR19MPdk?=
 =?us-ascii?Q?ZomNShUEuE5q66VXEIsRfV021eSRYCk1nxn7lnh77ph+v27wgnXqL4s/WEke?=
 =?us-ascii?Q?WXisNK+LYvVXk+/iAfT3u/8L65eBmXDbKRuNouzEOEB6IqBEIpjv1Q5Im8aC?=
 =?us-ascii?Q?1h/lYlDwvu+5PnTTI4kcCKyq3fdyaz9k/NPmNe5J0uZ/zSu+UNvwTFYapAsG?=
 =?us-ascii?Q?SOSDSKulhP0wPYDFxMCb+ow4KOj4/OpuckOhdHjTFUBHkHf+jgvAvfVug8ve?=
 =?us-ascii?Q?ehG312UL0ez5y/qUz1hgl63OIMKwC1ntXBbRvTmueZinZ2wRwoLkRhUiE4EZ?=
 =?us-ascii?Q?OeVDesvsWnz4h81L11nev4aaeCl0FIuVxa7j0iI84w0FOlKYyvPoPi3Ai9W5?=
 =?us-ascii?Q?28jkqDdA21d89NYdvHVV+OWrlPyGEFmT6sxFDwv0pbBeVat29V/FWxbvl1Fi?=
 =?us-ascii?Q?KpulF5+2HM+5EG4ftSWvUo80l+6GuS49/ZSgOAKYFeEMn621kDEso9X0Ncsz?=
 =?us-ascii?Q?jCEftLVQJjFJ4eUNDi15m/MOfKReBoYQfhy1H9KnUzEmIRHKpOUPA6C7ewcR?=
 =?us-ascii?Q?sUc3DLft48bQXoH8XKENoCvB3TzV3guWc6D/g6/NJ2CBN2VkMSt+Rcahoqoe?=
 =?us-ascii?Q?T7Hv7vRVd9hcwRqf1pI/c81J7x1tInVskpPV55epTTYa0T9ynP3lKZKKArda?=
 =?us-ascii?Q?G2QbER/moPCYhF9Qq78ibgQ6BpxdfU38QCI9gOPhOEcdJmtBd2MUPbdpTXuN?=
 =?us-ascii?Q?1beQIgPMKKvdDAm/hA6rsUIAOc6cDL4sFMHPmBKa8WZSAznQC4ohwzHorUMJ?=
 =?us-ascii?Q?s6P7CEzoEtGPxrkZ5fJRxJFzd5ZdiEUL/X9en+DN31Kco+1wZIcbobrd8uc+?=
 =?us-ascii?Q?B8BXtBW7o1s4ryp44eIfZUPmAlH7pShRnus2eWrXKN1Jmi5OcbLTxChffFX2?=
 =?us-ascii?Q?O9nfMd0yHqLdY/v5k7d0HrS9Rsfx7sUncXZ5Q325kx7Kh07JDb5IVl6cJ8xB?=
 =?us-ascii?Q?C36AktuVMOqxY7LT3uk0XyphobyJRBu1gL45qdJbGItSoWNxjnsYRyWdwz1I?=
 =?us-ascii?Q?WJ92C+tw3oxtr1ytcbK9sX5U6Egtzk5XlkTDCT1EEL21sJTCq/0zYaQ5KNFZ?=
 =?us-ascii?Q?v4Rce+5PLUlMde4dmPS1cY5vbJS30fiwOEJVLe/RmsHNRPQd32keJFroYEg0?=
 =?us-ascii?Q?Sjvkanl8RCG9CjyG2x2Ky0ETbcsPpDW58YQ2zBrG6t7tSjmtCN3W6Rs+eKZr?=
 =?us-ascii?Q?n17sZnkaVG+PKFFDl2f5dCx/cq3UscJDaJ6kXsxRC8dGhncsoDVBgKKhKh7A?=
 =?us-ascii?Q?e9/xOa4L9XbvIp+gJMphyyFHZVut+LhsO+PkKOHuSihwjItMJroBn4ZFW+BO?=
 =?us-ascii?Q?++yn2KH0LBpDdJ0HpPvyyeCldQGBXWN7LUXaauAhtmwgjJ2qmYcw1Z9b8e8L?=
 =?us-ascii?Q?vciZ8HgLVi3sqxF6V+Ltqhhnllbr36Q2L92MpcFjv4dzVrtPYo3coqBG5+hu?=
 =?us-ascii?Q?zGlAlmrUDm0RBSLajDRSD3VOQxQgAXEPrRoyIiuieK5YDE3i8DD76XHC9Z21?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a8ccd2-835d-435f-7455-08daa3902484
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:34:31.0874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OcalUrTGDIaYluWCsbORixl/mnSlYCAS596rzF5QcAtnFFrTTy7tUkrccYdCga8AdBVfXQexdlyAj4GGtObuDblmkotiDF9Fws7AVr9bx2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0733
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will, ensure, that there is no more, preciously allocated fib_cache
entries left after deinit.
Will be used to free allocated resources of nexthop routes, that points
to "not our" port (e.g. eth0).

Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../marvell/prestera/prestera_router.c        | 42 ++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index a8548b9f9cf1..b4fd8276bbce 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -72,14 +72,21 @@ prestera_kern_fib_cache_find(struct prestera_switch *sw,
 	return fib_cache;
 }
 
+static void
+__prestera_kern_fib_cache_destruct(struct prestera_switch *sw,
+				   struct prestera_kern_fib_cache *fib_cache)
+{
+	fib_info_put(fib_cache->fi);
+}
+
 static void
 prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
 				struct prestera_kern_fib_cache *fib_cache)
 {
-	fib_info_put(fib_cache->fi);
 	rhashtable_remove_fast(&sw->router->kern_fib_cache_ht,
 			       &fib_cache->ht_node,
 			       __prestera_kern_fib_cache_ht_params);
+	__prestera_kern_fib_cache_destruct(sw, fib_cache);
 	kfree(fib_cache);
 }
 
@@ -336,6 +343,36 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
 	return 0;
 }
 
+static void __prestera_k_arb_abort_fib_ht_cb(void *ptr, void *arg)
+{
+	struct prestera_kern_fib_cache *fib_cache = ptr;
+	struct prestera_switch *sw = arg;
+
+	__prestera_k_arb_fib_lpm_offload_set(sw, fib_cache,
+					     false, false,
+					     false);
+	/* No need to destroy lpm.
+	 * It will be aborted by destroy_ht
+	 */
+	__prestera_kern_fib_cache_destruct(sw, fib_cache);
+	kfree(fib_cache);
+}
+
+static void prestera_k_arb_abort(struct prestera_switch *sw)
+{
+	/* Function to remove all arbiter entries and related hw objects. */
+	/* Sequence:
+	 *   1) Clear arbiter tables, but don't touch hw
+	 *   2) Clear hw
+	 * We use such approach, because arbiter object is not directly mapped
+	 * to hw. So deletion of one arbiter object may even lead to creation of
+	 * hw object (e.g. in case of overlapped routes).
+	 */
+	rhashtable_free_and_destroy(&sw->router->kern_fib_cache_ht,
+				    __prestera_k_arb_abort_fib_ht_cb,
+				    sw);
+}
+
 static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 					  unsigned long event,
 					  struct netlink_ext_ack *extack)
@@ -602,6 +639,9 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+
+	prestera_k_arb_abort(sw);
+
 	kfree(sw->router->nhgrp_hw_state_cache);
 	rhashtable_destroy(&sw->router->kern_fib_cache_ht);
 	prestera_router_hw_fini(sw);
-- 
2.17.1

