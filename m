Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9A91C31A9
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 06:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgEDEQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 00:16:06 -0400
Received: from mail-eopbgr10127.outbound.protection.outlook.com ([40.107.1.127]:8357
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725772AbgEDEQF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 00:16:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PiQ3MtNaU41upZCxjoyLrMExjhbkRCQ+/3Je4Fmq5JF6zxI8O0ZNGzSCy1ZPR7unTzrkO7gzgC1TyN9HjoPcgAS7Eu7ca4NmE+HNBRdkDXMB7NrEqxEpLbFebUWe1WSlBBtpyq3kAcD/sDj5gcn85VRhC+4GdsFcCTdEiA77DPtMfzbWtJrDdqtrEyDA9QOV9BsFucl+Clta1LOPMMYfhrovgxg2e56t1ls+WIkGWPNhl4gWv2nrnbfbYY/6fxZJZLMT4+3YleNvyG9b0O17n80mAJHAXvWkqDcCMwYLUeO32ulEh64nN74fCkZzQ4n/91Dag4fX2Bw3z6DEnpUHVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBrD2UpgAQOkkDU/poOLqRVsxdEdCBDSRKTS9kelTfg=;
 b=ZSn+A2iBg+Vru4oUY6ONW2m38qlye32LpBjGDpZ/w6vcJV5FANZ0xtHfr/FM8mwypFWNL9fDCuXQ2wHwGdjH3bb3ONBjoXgRkPTbfAGSG2Aq9wCrovXl2cf+CoaFEjp9AT3fzmHuAKMyPFW8ddWyUy04PuAlJiCN5y3uIfCxjBR1fHVgFKb17kPXwZCKQUI/wTrM/4lGnerQNt8R6+F74lO+n/TZCR6/SrW0wo/P9AqNS2kPv+v1H6SBWFeLDLeGavfTFZwJ74Hhy8KRXCOR0Fk3xTMQXaEEH4SkfxgJT7yB+bwLnct1dSGd1zWA9KsmXKEGnxrF+UZmIySdC3ZmKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBrD2UpgAQOkkDU/poOLqRVsxdEdCBDSRKTS9kelTfg=;
 b=lLfV2epiczXiOtz3krx/ViMyjXEc4hqNCGn2OiLRIS9PwQbc9q/OwKys/0zKQtiK7G1yCLlnkiOfB0woh7HV37tASzwB5SleHlOKHWhrtTgWB7btFj+w6tNgEG6KyFPOykzkhjsoxIiPwcv8hzHXbVtBF9L4VaxugS+fMSLoBbc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6PR0502MB3720.eurprd05.prod.outlook.com (2603:10a6:209:7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Mon, 4 May
 2020 04:16:00 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::5941:e5bd:759c:dd8c]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::5941:e5bd:759c:dd8c%6]) with mapi id 15.20.2958.029; Mon, 4 May 2020
 04:16:00 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net] tipc: fix partial topology connection closure
Date:   Mon,  4 May 2020 11:15:54 +0700
Message-Id: <20200504041554.3703-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0117.eurprd07.prod.outlook.com
 (2603:10a6:207:7::27) To AM6PR0502MB3925.eurprd05.prod.outlook.com
 (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by AM3PR07CA0117.eurprd07.prod.outlook.com (2603:10a6:207:7::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2979.16 via Frontend Transport; Mon, 4 May 2020 04:15:57 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d79a4451-0948-4559-285b-08d7efe1d9c3
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3720:
X-Microsoft-Antispam-PRVS: <AM6PR0502MB37208A508944A9633A65CE5FE2A60@AM6PR0502MB3720.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-Forefront-PRVS: 03932714EB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PXl/t8CdclZtzIFTbg7BF3fXprWFurXDFGd1G/QdR6N58zGSfvZMaEk3sdxZUa9hI5OGkmeJfkNiHt276GwBWzmoSXPumfz77S7mwRBta76uaniFS2rkfVfXX3xLlLTcQ3tNtQ9Nugw+/R6OMZaZp3XtEsctbO6z3RdwecZWypjj4EDIl5PO/1x2JgleSM1wY/FwaTMCjbVctdGzFN/hFQXYsOiyameN2ntSf5rFwzSWgdNxWHHn6UxZWrkVppNzQMOxxupVPP4RuNhfMRhO1A9Y/kF0B1617zkEuE6lj0tvxfSTOjS1DhYogOqrF1wHg4AQ3llmkvhWpM04VpKoDDhQToLhcY8YRagwwNxFBPAeV5imT6cP0TJX/p09wBAlWqRRqAbNl5pyE5zQGR30Nzk16LhLI6ohaCRv2L/PA3XKetARmJ5PEPAi0zOLgfjy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(39840400004)(346002)(376002)(396003)(8676002)(55016002)(66476007)(66556008)(66946007)(7696005)(6666004)(956004)(52116002)(2616005)(1076003)(8936002)(5660300002)(36756003)(508600001)(86362001)(16526019)(103116003)(26005)(186003)(4326008)(316002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: OAmn2wnUz3zgVdsLl5Zt7fKwJ0Wzve0rmoXFMH63L5SrTZg1JyeREPpRCSBwOy5voioTl9DaYD14tJumVMbADpMwWtEJqcK3aDXamZNuLgOhYtObiqQL+h0ncsvZxKJ95mtwPRNyPvz+cSmtkyZ2e/0mQpP/dFysbG247Vg0SVo+6c9gIZ6DAd+4XKSilhPnZNbRfP4VXpYIce7JLyX0NszcWjhGfdXlNxABLkBDfcC7SpTGPVP6mNgbEEd+vWSBJ8UnoAuwPuvRCvwD6g1H1RL0b2cIll8rp9vIXS5ax7FMq79WemTRXma4tKj4NuTbDSza0ILDkCSJmRhGmChHRIrqHiWRvKNVWeIHVQg/2VOfvcVPNF8Gv/IVfCojOByO9c1xYMJhTyhmhJFmJBKcSjE5O4gM36ikaRh6ID3zXGUl6inYOGFZHdYMs5YloOY/S9aDi4m3ovdAe4tLvagkDUEhkmBvuLzK9D/hpDJVQ/u1HW7omQ7qGDnEjxPtX3BNOHn48iEDQt8DX05HkjEr/nz3t4mCx+Uf1URIi30py0RXLky9CeowaN3lafBFHZDf+lUjnLWiT2p7dtOlR01S0z1v2NRR+LY2BR4xaE/jqnU/hQtuAsJuUW8CstxdGNNFBH03LJTY0soGMi9WRSHrph7w3RP5JuuwxR6yLbmAoLtdl2o4BuTa6ziXkLc0m2sKhO7gf0iTLq9TyJ6KEcEiQVs92JJ+us/UYPODsc4ppO5036RfvBA7Hsa6A43l9BOesvs2j+gHqc8W+s2+cxWDKMdPIdwng0WmVmHIp6BohxQ=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: d79a4451-0948-4559-285b-08d7efe1d9c3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2020 04:15:59.8958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XHfOeC0egj5OzCgeaV5c3dEAaA9cI8fkmv4qNJrrk20lZHVMN/YsMo4aqc+pVSfiwg+tuHFc1a0s8cKv58sCJ7QAAe0sj1OT/b6wBiKJ+TQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an application connects to the TIPC topology server and subscribes
to some services, a new connection is created along with some objects -
'tipc_subscription' to store related data correspondingly...
However, there is one omission in the connection handling that when the
connection or application is orderly shutdown (e.g. via SIGQUIT, etc.),
the connection is not closed in kernel, the 'tipc_subscription' objects
are not freed too.
This results in:
- The maximum number of subscriptions (65535) will be reached soon, new
subscriptions will be rejected;
- TIPC module cannot be removed (unless the objects  are somehow forced
to release first);

The commit fixes the issue by closing the connection if the 'recvmsg()'
returns '0' i.e. when the peer is shutdown gracefully. It also includes
the other unexpected cases.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/topsrv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index ad78f7cff379..c364335623ab 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -405,10 +405,11 @@ static int tipc_conn_rcv_from_sock(struct tipc_conn *con)
 		read_lock_bh(&sk->sk_callback_lock);
 		ret = tipc_conn_rcv_sub(srv, con, &s);
 		read_unlock_bh(&sk->sk_callback_lock);
+		if (!ret)
+			return 0;
 	}
-	if (ret < 0)
-		tipc_conn_close(con);
 
+	tipc_conn_close(con);
 	return ret;
 }
 
-- 
2.13.7

