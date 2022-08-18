Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C515987E1
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344069AbiHRPtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344119AbiHRPte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:49:34 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8799D558C3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:49:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXF2JbN5vIXuux7H8d7AySXZu85UNH+6L5HfKiICStK5d4IPBTG6E80MZH39bpnfzFP3BRFQf1xcB6i1yvg/2HqyQDFeeW4ezwcdnVaH1tCrgxLrUEOEjy2e8MWDwrjFCB01kRLz1SRLdBviij3A6ipXBrOINFaoqm6t9wzz6gS6fofK9W3Z/YslOTR0EbZEZXEwVSgkqasmXnAWQy8mS7uAn9j+THCV0fPlYl2zUWYKpBVSQTJq7ypPvRRoURO0irbmYswA4mOkqJoDAAAG8+euqWOra2f3Hw9QI4lUNta9rDbX2WCcBO+oWX9HgH2z7GZzMAtSKPa4uhGb14cmXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMLCLGy5BJif8zRNNi13Qvqmaj63A5rAtSlATd+/f4Q=;
 b=hgWZS7eKPpZ9pNrdGgSGRJ2tLP1I7You8oGYc/OztJ6V8CQ1MDhu/MWw3IEt0iS1ZQQwqq0LX5mVWhSJs5XmqS7AC9j1AZOwjLw2URfmKX06HmpSC4y8vQUyGK9NYllXey/w1ivKyqmKJqJO1EI8sKxLbARcv1KQNJ9wpvoAxlHChmWKcIHRUBVWXXK+mh9LTwa9Y1x+Z2UvH50v3frKwpu4okqkQuN0AqXV+RPqo2Txl8Ucpq018hnMSp6UPpu+6D86AAW6sJ1+SsNMHUJZOvVGT4UdEmtJojzmNqK0jdfrdblmUiuxZi+gzYj7z1k5lsrmkz0CJHlhAfGooCWY5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMLCLGy5BJif8zRNNi13Qvqmaj63A5rAtSlATd+/f4Q=;
 b=cUeCqVn/Dy3izn29PyXUb6psdDjrHF+6IDAxAk6fKkiOgl1OArgZVYnIBMQx1AZEEQG3o2/KJ128KbICq1jnq7k1X8/g9mXxWwyLV6zY9djraacfJb6bmRGu2VtYCcQQtRiDDFhyyCDFm4YZPgD2vGZFn7xO8NNC5C6VFktT5D4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5648.eurprd04.prod.outlook.com (2603:10a6:803:e5::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 15:49:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:49:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH net-next 01/10] notifier: allow robust variants to take a different void *v argument on rollback
Date:   Thu, 18 Aug 2022 18:49:02 +0300
Message-Id: <20220818154911.2973417-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
References: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0074.eurprd05.prod.outlook.com
 (2603:10a6:208:136::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b772a3a0-6019-4669-8d94-08da81313b01
X-MS-TrafficTypeDiagnostic: VI1PR04MB5648:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKTfe3Oq0AGpzf0fkz9/Ov6GgKL6auZ/zHk6pBdvsEY+9vEWA6VFX5ASMMoF+JRh4nMlJfDxddFrlxn0DcIH66QbSwf9KBGI9zeyZDF563i0XqgtAFXcUoEGOHu1B3cnDyT9Wbjs5Utd+yHdq9pZ3Vl47emW1BGkNuTN8CpJ7RDKRyPmmSlfoXt09lmgrS+hEk5tSfdWwBfQjHEnSbSkRM0kEppcdD88xq86UgU+FXqMPfMpoqGx5F+qrOCa6QttTUcYIy6RjMBirxTONLyFYgCEko2qWhoyzhks+mFB4qu3AMubFSrFe8kAdNnCvE3INSYxd9DYrpjN7cJLM1I3nVg7rlC+oNONcaLwWBeufAdy33HPISQ6ATMnP5NdvxEXK9ThBfRUeF/lzhVxmR5TnA6xZZ/4MfV59pvLFZZrThThBI7FvVcw4zheOrBHTEAk+42mtoinsrer10VxtO2GtQuZo0yeD/PmT6YzcaYfNuByHG0eIR7gDat/p2WW8f7key3YGdv0uZXabXpv7nfxHyy5ig/qD0vhAUweRV6xP1ZB41351zJyL8R8X+DFbAKrXVuVetm7w4DlHsc/Rdw1gFCjO4UasbT/qOaqOlu1yAVHVQAjLJOHrHMPdkkX1z9C/z4QNdIkur3Z5CGMzLuUR143Al2e68mmMy4fS4oiIZmQGShiQafeQQssHui1EYFfh32a3bHCkkvdcuveXoaC3eNQNDSRhsvOUdUHP5mF8BmGTudtWpeAlGS+6r7y3dHFb2ReBPxrpaLXgHtJ+XqJnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(6486002)(478600001)(38100700002)(38350700002)(83380400001)(6666004)(186003)(2616005)(1076003)(7416002)(5660300002)(44832011)(36756003)(6506007)(52116002)(2906002)(86362001)(41300700001)(6916009)(66476007)(4326008)(66556008)(66946007)(8676002)(316002)(8936002)(54906003)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CHKdr1z8oBo2erBVtgqdS7aVNtQ9ESCXO+cvbUt4KKeAsjXcN2sEeLHKWgG8?=
 =?us-ascii?Q?wx20fRLbdAcrRyCDczcomXbOlqqQCKD7uOBDIUkK4TMcWZYWNU69RR45m0tc?=
 =?us-ascii?Q?eKtsEVdsD4fuTE3IbfLSADVSKRN9/DvrInnBgTi5hxiGF6DHmnHzzhAoPEM9?=
 =?us-ascii?Q?UgpVSH1vWYU9DxQo93kPy476l3ZuuZYxA9BQUzR4ySBewC5rDiS1TDfKoeh9?=
 =?us-ascii?Q?8vbMEgOoRTA6OgSCXCQahj4sXD2T7pfL1mTtppeRf9UfeWHPz+oYqNIcVb7+?=
 =?us-ascii?Q?3eXls3N1eR9a+2NxcUvfe5t/xEGNcxI7y2TGsgxiEZeKPl30fMAaXF4xKvwA?=
 =?us-ascii?Q?YRiMME17QRY5W17riYsqEJaEkMZ97ta7sZcHH7r95gmwimRsXehyKxjkY/dR?=
 =?us-ascii?Q?gZQiPbbaRaoFGEvqZQcGs3xzbfuItV4EtViN2os649UmIlgp7MEaYj5Ydujf?=
 =?us-ascii?Q?m/VbwV66evY76RMvvy3KHhG8AsXjayNuN6J3vWE3GeVK2W2RY4CuOj/3Fh3G?=
 =?us-ascii?Q?ULodgcHvXcV51nrGWs6Ilur8MzfR2lVlJTGS48Scx9Kewwha5Xb/IZ+hqYQ2?=
 =?us-ascii?Q?bqdJhi1rpkvruj7l4fcaPUCmP9HOEEUAtSW5tlmfM9repx/P6zYyW7Mfcmgi?=
 =?us-ascii?Q?kiW3TXmr1vLLIVHlSMKoq7lbzfXqCsG8U4HVuNZAR3i9DRCY3ZGRggN8cq+g?=
 =?us-ascii?Q?qPX9kEXlc9wm8kfbU6smwhUoH68SOPUPUkh6wZDUmap2mmR4ddZagj6s4HUn?=
 =?us-ascii?Q?wmiPRs6H8yhQeMp9042ijUqi7ZaqtG3/yDlFZ63c1MQ+oYfydcgkWfJb8TiN?=
 =?us-ascii?Q?RZHUqLWtDKC7I4GPof64WZY30xFlb/YWcovm29Bc5H1OwVcOjx+JabFTfG2T?=
 =?us-ascii?Q?1OXAwpHFTbjTPLf9kSk+/mM3TboV8+DZkWGmGZfWcsJgfUP8s41XcKUitusc?=
 =?us-ascii?Q?TGPyJ+TtpmGT8Wh6wTQaM7ik9BxxsVhGg34ELHYl1ArHf6tnfIrDRemIZPHe?=
 =?us-ascii?Q?KXcNDo8i9UIr7LqUxFz9/LSBzOPvFBDhlcIN7Y6UJBvgxXMkOKaDQNO7ME8R?=
 =?us-ascii?Q?i9gtCDg2DF1Q1cQwo0LleraR6ZLvJ2y9GF49nskDHK26q6IeDPMlb5Bl8Zun?=
 =?us-ascii?Q?TFfWxF/jnPrvXN6vepP5qMKQ9huCx4W+7xLa0XBdxS/r1ljY9WF0TyBszZcp?=
 =?us-ascii?Q?Bu3zPqgYodzOYzxckRg0Y7SwCDIHC8vSSuIyDTuKOULm7zSFALS+JHnYHPWB?=
 =?us-ascii?Q?aQqHJOxyDp2saKMrXIQhm5kdhRB899WVihAAs9rm+V0GpVhd5IQsz1UNRchn?=
 =?us-ascii?Q?mWUBXD1JfcjiDyWfixuLuoaZmDQxxBkMQ2ex89sIxraSXnZO2i5FZNCiX5ru?=
 =?us-ascii?Q?xqRmrYhnM/Bfam5ZL61KqekuaUVca5Nz5VA3MbwUE0sAI/yiviAPPOjx+goo?=
 =?us-ascii?Q?GGme0oMMm5D15sdHBFhSEsQQeyqrJQhJwPazkcdSHrsVbCrx/zJ7zTX5tf6u?=
 =?us-ascii?Q?GzGS9GNtjlJfTm1M/daqPMKd5fmGj5dGPi/h7h8Uq7ZFirfB1kjM0ZLq7gMm?=
 =?us-ascii?Q?uSNAuijDLTuLubpjdegaJ6gYVJMxZZA1PCe1Zw/0RBvNK/drwPmLdXQH1IkB?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b772a3a0-6019-4669-8d94-08da81313b01
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:49:27.1090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFXRj3CUhQ2wtYgr6ToGb6Tj+HOppKY7JwSCSib6xiG4PSXQ16TRpMHx8WQwZGCrkVXN4thEyhgG+NZXchC25Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5648
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More notifier call chain users would like to convert to the robust form
to simplify the rollback, but sometimes the events are of "SET" type,
and the void *v describes the object to set. In that case, the rollback
will also be a "SET" event, but the void *v has to describe the old
object. This pattern is not possible using the current
notifier_call_chain_robust() function.

Expand the prototypes of blocking_notifier_call_chain_robust() and
raw_notifier_call_chain_robust() by explicitly asking for the void *v to
use on rollback. Modify all callers to supply the same "void *v" as for
the normal call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/base/power/domain.c |  4 ++--
 include/linux/notifier.h    |  8 ++++++--
 kernel/cpu_pm.c             |  3 ++-
 kernel/module/main.c        |  4 +++-
 kernel/notifier.c           | 21 +++++++++++++--------
 kernel/power/main.c         |  3 ++-
 net/core/dev.c              |  2 +-
 7 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 5a2e0232862e..0b85236249c7 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -504,7 +504,7 @@ static int _genpd_power_on(struct generic_pm_domain *genpd, bool timed)
 	/* Notify consumers that we are about to power on. */
 	ret = raw_notifier_call_chain_robust(&genpd->power_notifiers,
 					     GENPD_NOTIFY_PRE_ON,
-					     GENPD_NOTIFY_OFF, NULL);
+					     GENPD_NOTIFY_OFF, NULL, NULL);
 	ret = notifier_to_errno(ret);
 	if (ret)
 		return ret;
@@ -554,7 +554,7 @@ static int _genpd_power_off(struct generic_pm_domain *genpd, bool timed)
 	/* Notify consumers that we are about to power off. */
 	ret = raw_notifier_call_chain_robust(&genpd->power_notifiers,
 					     GENPD_NOTIFY_PRE_OFF,
-					     GENPD_NOTIFY_ON, NULL);
+					     GENPD_NOTIFY_ON, NULL, NULL);
 	ret = notifier_to_errno(ret);
 	if (ret)
 		return ret;
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index aef88c2d1173..d5e9c0aea933 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -174,9 +174,13 @@ extern int srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 		unsigned long val, void *v);
 
 extern int blocking_notifier_call_chain_robust(struct blocking_notifier_head *nh,
-		unsigned long val_up, unsigned long val_down, void *v);
+					       unsigned long val_up,
+					       unsigned long val_down,
+					       void *v_up, void *v_down);
 extern int raw_notifier_call_chain_robust(struct raw_notifier_head *nh,
-		unsigned long val_up, unsigned long val_down, void *v);
+					  unsigned long val_up,
+					  unsigned long val_down,
+					  void *v_up, void *v_down);
 
 extern bool atomic_notifier_call_chain_is_empty(struct atomic_notifier_head *nh);
 
diff --git a/kernel/cpu_pm.c b/kernel/cpu_pm.c
index ba4ba71facf9..32ca243f0306 100644
--- a/kernel/cpu_pm.c
+++ b/kernel/cpu_pm.c
@@ -51,7 +51,8 @@ static int cpu_pm_notify_robust(enum cpu_pm_event event_up, enum cpu_pm_event ev
 
 	ct_irq_enter_irqson();
 	raw_spin_lock_irqsave(&cpu_pm_notifier.lock, flags);
-	ret = raw_notifier_call_chain_robust(&cpu_pm_notifier.chain, event_up, event_down, NULL);
+	ret = raw_notifier_call_chain_robust(&cpu_pm_notifier.chain, event_up, event_down,
+					     NULL, NULL);
 	raw_spin_unlock_irqrestore(&cpu_pm_notifier.lock, flags);
 	ct_irq_exit_irqson();
 
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 6a477c622544..d92d6e142d11 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2638,7 +2638,9 @@ static int prepare_coming_module(struct module *mod)
 		return err;
 
 	err = blocking_notifier_call_chain_robust(&module_notify_list,
-			MODULE_STATE_COMING, MODULE_STATE_GOING, mod);
+						  MODULE_STATE_COMING,
+						  MODULE_STATE_GOING,
+						  mod, mod);
 	err = notifier_to_errno(err);
 	if (err)
 		klp_module_going(mod);
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 0d5bd62c480e..db71eb12ad98 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -114,14 +114,14 @@ NOKPROBE_SYMBOL(notifier_call_chain);
  * Returns:	the return value of the @val_up call.
  */
 static int notifier_call_chain_robust(struct notifier_block **nl,
-				     unsigned long val_up, unsigned long val_down,
-				     void *v)
+				      unsigned long val_up, unsigned long val_down,
+				      void *v_up, void *v_down)
 {
 	int ret, nr = 0;
 
-	ret = notifier_call_chain(nl, val_up, v, -1, &nr);
+	ret = notifier_call_chain(nl, val_up, v_up, -1, &nr);
 	if (ret & NOTIFY_STOP_MASK)
-		notifier_call_chain(nl, val_down, v, nr-1, NULL);
+		notifier_call_chain(nl, val_down, v_down, nr-1, NULL);
 
 	return ret;
 }
@@ -333,7 +333,9 @@ int blocking_notifier_chain_unregister(struct blocking_notifier_head *nh,
 EXPORT_SYMBOL_GPL(blocking_notifier_chain_unregister);
 
 int blocking_notifier_call_chain_robust(struct blocking_notifier_head *nh,
-		unsigned long val_up, unsigned long val_down, void *v)
+					unsigned long val_up,
+					unsigned long val_down, void *v_up,
+					void *v_down)
 {
 	int ret = NOTIFY_DONE;
 
@@ -344,7 +346,8 @@ int blocking_notifier_call_chain_robust(struct blocking_notifier_head *nh,
 	 */
 	if (rcu_access_pointer(nh->head)) {
 		down_read(&nh->rwsem);
-		ret = notifier_call_chain_robust(&nh->head, val_up, val_down, v);
+		ret = notifier_call_chain_robust(&nh->head, val_up, val_down,
+						 v_up, v_down);
 		up_read(&nh->rwsem);
 	}
 	return ret;
@@ -426,9 +429,11 @@ int raw_notifier_chain_unregister(struct raw_notifier_head *nh,
 EXPORT_SYMBOL_GPL(raw_notifier_chain_unregister);
 
 int raw_notifier_call_chain_robust(struct raw_notifier_head *nh,
-		unsigned long val_up, unsigned long val_down, void *v)
+				   unsigned long val_up, unsigned long val_down,
+				   void *v_up, void *v_down)
 {
-	return notifier_call_chain_robust(&nh->head, val_up, val_down, v);
+	return notifier_call_chain_robust(&nh->head, val_up, val_down, v_up,
+					  v_down);
 }
 EXPORT_SYMBOL_GPL(raw_notifier_call_chain_robust);
 
diff --git a/kernel/power/main.c b/kernel/power/main.c
index e3694034b753..edc49debbecd 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -84,7 +84,8 @@ int pm_notifier_call_chain_robust(unsigned long val_up, unsigned long val_down)
 {
 	int ret;
 
-	ret = blocking_notifier_call_chain_robust(&pm_chain_head, val_up, val_down, NULL);
+	ret = blocking_notifier_call_chain_robust(&pm_chain_head, val_up,
+						  val_down, NULL, NULL);
 
 	return notifier_to_errno(ret);
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 716df64fcfa5..5820f18c2e1d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1968,7 +1968,7 @@ call_netdevice_notifiers_info_robust(unsigned long val_up,
 	ASSERT_RTNL();
 
 	return raw_notifier_call_chain_robust(&net->netdev_chain,
-					      val_up, val_down, info);
+					      val_up, val_down, info, info);
 }
 
 static int call_netdevice_notifiers_extack(unsigned long val,
-- 
2.34.1

