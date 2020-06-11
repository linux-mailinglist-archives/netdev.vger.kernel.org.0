Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095761F6564
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 12:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgFKKIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 06:08:20 -0400
Received: from mail-eopbgr70125.outbound.protection.outlook.com ([40.107.7.125]:50286
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726708AbgFKKIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 06:08:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9fq98kwcbHQdUEK75Eru9bCJdrHzrLDjM3XLAAKAs57FUFLhUdmKAuNZDNlPEBfvr3udX89+hVRBBnmLXjeOoPU6XJVqLrwyWEU15ZVptacj3Oo8YWUifSaxmoTqcabmcUvAIDaMexxmoxJBAYP/lAaf1hY8OFZZ2ied8RSErYmfosQaJIDbiDGecQ/8XAjMqpYGmJrxKarBye2WQ/3scqStFia9xrNw0/zqUEftbPFhnL9rtH/5/PPlxTEL317gtGeo0IfWwjqtSmsQ9TZ74PTwb42xxoN8zt7FyFo0DxEif56eEdblz6rxgV6y+BZ72m8ABksuRQGNH3xbnl9Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLjkzazYCGO0tBI/h5SgY3xCwLuAzIunrdOtAPIfKPc=;
 b=WDzhJnax+zPvNQ55ZPH8bpjeXQ/vNqnOuWAHkQf+13ApZ+eK3DlIUr+4eGQFtzfo/wK0B7hmRpQPMXfZEyEs5mDKI3T9oG7R4LKZM+kKo6CU9Y3arFgvlF2idBSsuRpPHC2F9OeBn4KuBF5gXqo/XMXg/hBTv515t7na6iLeAJTcW9diPSRDI2Pd9QvIK2+o1aP2R4b+hyymiEy7pS3/o31YMZlEm/8VOC+Nntc9R0LIva+MB/KF6UzojOUG3HGnJTPgQ27DSVwAj0CbtUvdi9/17lvkTrkauDklFsM1hBYcekBbAt920iV7zfF0c1rcl/mNuFZlLnkZG3lqp0HvHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLjkzazYCGO0tBI/h5SgY3xCwLuAzIunrdOtAPIfKPc=;
 b=lJR9LoBrz43/TyvA+xJLta6pdehM70x9Mv2AjS0a2/RpG/+EDxZ/w8PNmkgQ97pK3Y+ocFpwU3VF90z//VQNfuVPY4AoHyQ9lpr+SQROPdWnMuM6qPLKg2M+8pzcSXlGwmVo3ksI/tQuqGao2n3Q3EcUDpBcVtkd1khe6zOgcnc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6PR0502MB3766.eurprd05.prod.outlook.com (2603:10a6:209:d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Thu, 11 Jun
 2020 10:08:15 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf%7]) with mapi id 15.20.3066.023; Thu, 11 Jun 2020
 10:08:15 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net] tipc: fix NULL pointer dereference in tipc_disc_rcv()
Date:   Thu, 11 Jun 2020 17:08:08 +0700
Message-Id: <20200611100808.24244-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0215.apcprd06.prod.outlook.com
 (2603:1096:4:68::23) To AM6PR0502MB3925.eurprd05.prod.outlook.com
 (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR06CA0215.apcprd06.prod.outlook.com (2603:1096:4:68::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3088.18 via Frontend Transport; Thu, 11 Jun 2020 10:08:14 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf5f309b-617c-4435-2424-08d80def5b84
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3766:
X-Microsoft-Antispam-PRVS: <AM6PR0502MB37667965BAFE9EB95DD6E29CE2800@AM6PR0502MB3766.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M2ixHPNBkByisJUhxOZ3SxnvuOhL0AtCAI53xEYIpISVs8PceFP8CU/E/rk/KNREzOfRSqJ+5L22x2qFsjpdG4km/5Q7kdDQ/IP/vKnwC7f2sE5LuoAflklfN2Ta7SCYTUFR+nMkbck4vx7FhBcx3GEgDklxv8Le80+Mw9f6cZ9IYxPJo5YdlKReaqEfgDftFruKt5R5g7SoUy9oIA+PqgPif0CGmZPR3/tWwzmlx7GCQ8ob5BbKoN3RAE+ccKuE1sLfDA8DVqFjgGeFn3vWk9JQj+GAgAmziPtJf0d4NBPY1EmhTfDqwfDNzIscHjIN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(396003)(39850400004)(478600001)(316002)(36756003)(103116003)(83380400001)(2906002)(52116002)(7696005)(6666004)(1076003)(66476007)(86362001)(66946007)(956004)(4326008)(8936002)(8676002)(5660300002)(16526019)(2616005)(55016002)(66556008)(26005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +N94mZGIFtFFna0cO9ofVoWUjPzXv6sZ9YAYsgwox0hBbsRb9MNrG37jmu4K88NOHQlAJpnLLIfKpAMDEgHzdDeSJ0YG+cxKUe+q5HxPmt3oShYvAIWymFmFz0RnMf2vAOXETzUfO77leNszn44RWoK8M3+qdMx6St1NQz/5lyKxiZzD3jdLwyoY8vKA/OgnfX1iwK5HvH2LkNpfC/gxQgQipzfj8DmiagDjNgQC67rdkAVo4ji/pLrD4d3xJuMDmw7YE9lMa319qOT4tQJshmosmGGbsGEsOPMxyr/OnAnoZFKUaiKwpEPTT99zBwYOznE//1vNHq8Si/O1DpniwHFTmESv1xsgXMr3oM8a+AsBWSM0Ma12C6648B1/31dZunc6hsIrqA7a23C7PCuO8SHTCicNP97esJLXM4kN39rZy4Mx/18ob04xJBkyQ396l2cBATYtOCrgRsOJWZ7oMeQ8Kd+tTR9+GH2lJZMQ5HI=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5f309b-617c-4435-2424-08d80def5b84
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 10:08:15.9025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Anf4ZPt/yQ4ymYVXrE5AN0TkK2FEhKpnxb5XhX/GZgoUfzhcV4YO7uUAX8W40WpLbzXGqWGWUrh4Dit3YjWLdEpQ+HUHCFSiHhMwE1/Qh9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3766
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a bearer is enabled, we create a 'tipc_discoverer' object to store
the bearer related data along with a timer and a preformatted discovery
message buffer for later probing... However, this is only carried after
the bearer was set 'up', that left a race condition resulting in kernel
panic.

It occurs when a discovery message from a peer node is received and
processed in bottom half (since the bearer is 'up' already) just before
the discoverer object is created but is now accessed in order to update
the preformatted buffer (with a new trial address, ...) so leads to the
NULL pointer dereference.

We solve the problem by simply moving the bearer 'up' setting to later,
so make sure everything is ready prior to any message receiving.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/bearer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 34ca7b789eba..e366ec9a7e4d 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -316,7 +316,6 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	b->domain = disc_domain;
 	b->net_plane = bearer_id + 'A';
 	b->priority = prio;
-	test_and_set_bit_lock(0, &b->up);
 	refcount_set(&b->refcnt, 1);
 
 	res = tipc_disc_create(net, b, &b->bcast_addr, &skb);
@@ -326,6 +325,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 		goto rejected;
 	}
 
+	test_and_set_bit_lock(0, &b->up);
 	rcu_assign_pointer(tn->bearer_list[bearer_id], b);
 	if (skb)
 		tipc_bearer_xmit_skb(net, bearer_id, skb, &b->bcast_addr);
-- 
2.13.7

