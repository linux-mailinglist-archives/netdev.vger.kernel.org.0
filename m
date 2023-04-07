Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1730D6DAEAA
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 16:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240502AbjDGOPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 10:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240518AbjDGOPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:15:12 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2073.outbound.protection.outlook.com [40.107.8.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F53AD38
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 07:15:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D71Wm3QkaD7+E0aihe4s83BKO+fecTAFF7F2s2khb4/uz2gklKgX5t+2fJd+v73NBu/4NfLtnqnjvddSNwfdJ81hcbCwmFkQ6HhTXLCTuF8XNrvcVaAEXqbzHkk2lpwjbUfNRS2pxoHh9JHDCBKJVXMl5b4U1ZJLNavKMJ6NXhaZ0AUqrkveSQomaFlh7OQWk/NT/koRcJEE5E4gOrAqd0f4Yah9+kuFqAG/+W/SRfILpHOuOoII1JmplKYuOLCF4xXENPYmeRUkwbZ2aCstEawj4/yd2tu8pRqibgGcAX1tpllgpRSqrGSnAuxaRHfb4w7Ca6BDB+NdPTwYPbT7/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4tRgikrZxd4z9wEeyFx5aTiGG5vw9gXpTa20+QdFhw=;
 b=XCegiEd+KSl4xvW3gP/ns0v/jtSHdboxftvztwdH0wKKb5eqaIwx/XAwSnoNzZbKtOYwNbKKL+EdT/dBuEy4V1FYGWDi+gq1wOGVUVhy7cqLBBVuubAkBT4idJFK2/HZR5Qe/ecCgg8S8g6EtG1P+MY4PSK5Kv4kod5qV/KlbfVjiY8f9AH+TA1PQGC7nI9XUX9TDUuqRKHszy2EQZ5ze+HLw5i4DutsV8ldvF/afmvq3hRwbsx9OVQb476a9aRiTaZ998U91Cag5pmpJe2ceYlkMP2dmTzUThZpZE2erBG5xtFILdYDtprSasEFCYRyLrGRlFai8JugRGKnXMXY3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4tRgikrZxd4z9wEeyFx5aTiGG5vw9gXpTa20+QdFhw=;
 b=qtRNbFYOglciu1hYz8dcQ4Gr1v/bDmeDnzKdoDV/gC3nAYSzLQGzNoAIwJ4LfJeU52YjW8jDIxewojS6DHQ52sCGLu+ozE9rJJT1mj2PZmmdLHjgKRU3gM9vP3gajjMVMSt/8BcetMaTSZK0Th7z9Ny3t3YzjP1UFVewQzjT7Ss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7405.eurprd04.prod.outlook.com (2603:10a6:800:1a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Fri, 7 Apr
 2023 14:15:01 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Fri, 7 Apr 2023
 14:15:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 0/2] DSA trace events
Date:   Fri,  7 Apr 2023 17:14:49 +0300
Message-Id: <20230407141451.133048-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0134.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::39) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7405:EE_
X-MS-Office365-Filtering-Correlation-Id: 033be2e1-a03b-453d-6e40-08db377279f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gBuE2EV8yEnAoosmHXfkD660K9sxAli45P6n8OFWhzj2Assq7VshsavyxKBYcI6SVm+hJVw12l5xhXHYOt2AEOT77VROTtPVKmvono+sBwbGYrPCZXGLLK+NDeGBneJMoV/D/eSZOoCgRdnuPslCpBqc0GW1BzOCmXxmI46gdMLwVXS5lr18nMpC+nwd2KEFFhDT49fcvPfJsn9uhLp0WFrPrgLzLwBNB8Enxzt+t+MF9kDbabzhUf6DOF2/r3i19oab9sEfHMnb6TA5F1ujqe6E42E1z2tvqObX8if29NVlAT9Z7C3GY2cYjkeHK62JXZTmR/eP6dGwJwrUzhAEkx2aPexR07rFX/1tULYZYizQZjZLZne7MBA3bCgfYaYwy8bTzY64LgtfFtFM81eYx0hxj7aoVMMuYsGGla+lNoTqKiTfjiFb+NFS2KBpv/veEf8z57Ie6uy3d3ggX9cKWWegiVHtp52BbXcGbBK9UlVQV2ROa/ZgdeLSbV71liL82Lu0i4f50Fw8d8B9xH2tklJEz0SW3RK1Qf929hcXn6x4xnsRLgWPYH5uI1qqD1mlkAIpIkRpmyTNjsP98Z3SZWXfKaSKqZQXZi3kzp4sK33MNAMTO3JNfBKBI/EyB1NQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(36756003)(86362001)(41300700001)(52116002)(316002)(8676002)(6916009)(4326008)(54906003)(66556008)(6486002)(66476007)(66946007)(478600001)(44832011)(2906002)(8936002)(5660300002)(186003)(38350700002)(38100700002)(6666004)(6512007)(6506007)(1076003)(26005)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qrlB6+hQKoSs5wuP/s14qmL6n2iuNxGnx0GEO2DfL1XSnPKx33MJVjvjIwgu?=
 =?us-ascii?Q?AT/kuZDZeDWyV1KDTXOLB6BjqI7zAjNfqvb5JtKVF79Ncq+z/M6x4GUfzTNF?=
 =?us-ascii?Q?0xjJXdLeIN2eHR37J7ZA8/3yUNtg7Mb2Umrd3vd9/1eT1mDoJ8GavXWLsxe2?=
 =?us-ascii?Q?49veCiZmprXfbf/EQEm+14aJ64crmRmhiR/bX3wL3eGu98BO3MdMRHJOBVVo?=
 =?us-ascii?Q?PDkWxwlE1bywxth/zGNmsPhXZY4EjWwT7PAhEG+9n9GfDNn+fJNhQQDvHd/f?=
 =?us-ascii?Q?J53ibtHxx7R8txRUpdITrG0kAkFh7a/vcLErEBMLwNUthaoMQ9tY1Ebk6tqa?=
 =?us-ascii?Q?3KSYlngnY0//uN40klSWWZD+m0uWNhWMVSHXoFcQ+JNRI3VIejNLMiLQD0cJ?=
 =?us-ascii?Q?SO9lW71bLYPTgIZGjvVbLHActEwFdktDOolUtLtIXksfRxIdQG01hqtEDFor?=
 =?us-ascii?Q?IRtgLlX9V6hyduzQp+uH9K2sVNpYRxpAA0gIkU/kmO3u6XtQmBn5psfQYztu?=
 =?us-ascii?Q?y96BQ5XSWv9oVpBDRFe8oUsx9M+tXzSYlc2MQPmzTSrpgpgciRR9AeUEBa91?=
 =?us-ascii?Q?PFYJOOK2h3hC1nubMjuWLNu9s1uEVsd8rZnmOfHMp34weIwb4CKCtcBbMMzP?=
 =?us-ascii?Q?wUKgd1ebFDIFpL/7FwnJugUrGVr7BLcKDvZAJ3VGiswLP0mn0e8S5ST3rGxq?=
 =?us-ascii?Q?nTHSfyjTcpEDlSjKmouOPqGXoX6isqIPA7Jgv3nWqgAYiyc/PeWIcMLwNb36?=
 =?us-ascii?Q?HrC66JFM0T1lln5Xa4snefbbsbNuprE4bYeL2Mriu5HqC6jH1eC+ksXcRTiO?=
 =?us-ascii?Q?YB1qEQD/Wjy+f9NVSQBs8K8+tKhscUXXAG+BUS/699uDY8M7SZRZz0vYVMhR?=
 =?us-ascii?Q?SsVGkQWiEtn19jZZxBj+1MJ1MDZ3CPjtk7/emAiqqgKVBtpTvrGGPbVdo9hj?=
 =?us-ascii?Q?IS5nSSBB2h1wTskUfatIqDF0s0jlGBNe9UgtkPj4slzAXNglokYS7G0e13dY?=
 =?us-ascii?Q?G+sG3D0Qgodkxv9XNJPSJI1ixw/tlZJ01ifntGeU+HEa0oHGVrmK5LPTuGzR?=
 =?us-ascii?Q?ScH9u5INnqP43aIuBVWEjPy3EjCjGGL5ObSEbzkZFohkpfNvblDVf4jvBSzh?=
 =?us-ascii?Q?3vX+yRIKUwNvxxA5I/W7/PeTpMWhYrSDrwQH6GYWHV64TcIpznTZGhF5zzGH?=
 =?us-ascii?Q?ZobMLbShnT/r4PuHnAOup4r6uzL8ENtKY9bUN5X9Xt6NhwdBQoZKuDcSHG4c?=
 =?us-ascii?Q?n0Ny3R1qbcOld+zdbJ7/vK1RCOHpga2dxO3XLM/5gYEbdUGzqQp9p28UtlDr?=
 =?us-ascii?Q?w+D6pixZWB1RTbly2sLEdUGkYxoSJFWFJPqZfRVmWtTuToK0fYfGr4wz/5hj?=
 =?us-ascii?Q?2J1kC+QrleuLftIuBwefdHIPoO9k4fQ/OqSXrUnov0PA5kZayv6ZIpQww2sI?=
 =?us-ascii?Q?iDG7BZXmj5mC8qZj1jsEXqlWKruPsV8HnI0LKkoTfBnE9P9I71IG8uMVFqsQ?=
 =?us-ascii?Q?JP+N2noSbwJDNdZ2jMUugR9pOCH/ozZ7Bury6+3rzqOzaIeWMwq38SYun+2l?=
 =?us-ascii?Q?SdFkFsKEiKiHcKkOUirqqUeHmbCDgtNmvXVGbAqq2ZyUATQCz6JZb6SzSF7E?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 033be2e1-a03b-453d-6e40-08db377279f2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 14:15:01.7173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PpuwsCYyWWd4JtRex4X+YC8Exs/If73aggP1uWtSr9LNkHd5AY5gT11WjibtUzJfLgpAatL4toKBKB30A0QZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7405
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces the "dsa" trace event class, with the following
events:

$ trace-cmd list | grep dsa
dsa
dsa:dsa_fdb_add_hw
dsa:dsa_mdb_add_hw
dsa:dsa_fdb_del_hw
dsa:dsa_mdb_del_hw
dsa:dsa_fdb_add_bump
dsa:dsa_mdb_add_bump
dsa:dsa_fdb_del_drop
dsa:dsa_mdb_del_drop
dsa:dsa_fdb_del_not_found
dsa:dsa_mdb_del_not_found
dsa:dsa_lag_fdb_add_hw
dsa:dsa_lag_fdb_add_bump
dsa:dsa_lag_fdb_del_hw
dsa:dsa_lag_fdb_del_drop
dsa:dsa_lag_fdb_del_not_found
dsa:dsa_vlan_add_hw
dsa:dsa_vlan_del_hw
dsa:dsa_vlan_add_bump
dsa:dsa_vlan_del_drop
dsa:dsa_vlan_del_not_found

These are useful to debug refcounting issues on CPU and DSA ports, where
entries may remain lingering, or may be removed too soon, depending on
bugs in higher layers of the network stack.

Vladimir Oltean (2):
  net: dsa: add trace points for FDB/MDB operations
  net: dsa: add trace points for VLAN operations

 net/dsa/Makefile |   6 +-
 net/dsa/switch.c |  85 +++++++--
 net/dsa/trace.c  |  39 +++++
 net/dsa/trace.h  | 447 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 560 insertions(+), 17 deletions(-)
 create mode 100644 net/dsa/trace.c
 create mode 100644 net/dsa/trace.h

-- 
2.34.1

