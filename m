Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9775C3E1485
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239756AbhHEMQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:16:21 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:63492
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235505AbhHEMQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:16:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cnofp16xDUBqH0f2/82pL+sZStZdN384TdtFlaOlP4eQGg1LhumASoHhZn/jXH1GqIh0MKwYHCBocHdc1eJZZAzFfukr735K0k2VInaeZ5sDmVXHV2MGaZB0DuRqR/DdK/vmGC7lNSSROTqCExslxIJgwWibf/PM0optVOa+8Ylb6LSUh8KnbobC0kZAoWEVMp2ClSgXmdF3Y7LdDlb8Y2cYOnCmIcoyZ6Q1+VR08nykm/R60mFAY6Sg1Ui2lqK0kwHarFMF1xojWBFjDpE9ALb36UVb4jagxBpS+xNCc90x6g99y2PbIqHFsyONEjBz5oTmc7qbDzmF9CYWYdXoiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EijYByxS8Tb91osqzsVE+8V4K/lz/DHwSVcCb5zo9xg=;
 b=SPacGdFTxCAqxFV8Gb3wKMtmffvCAaRv0EegoeGyVELqxWBjsiJeW3fdF10+816TCuyjpMApchu5jsON61Sl06sz1yyDJV0VQLu5HrbHIclPJm2yh1UmF7ENhz3xbt36dUa4NyEt6KiOk1PW2nZZ1/bT2NqPFE8355xpBXNsXCbHRcLYDjLstMqpyiDTz1u9PBarVw7TlhZZCGC9pFMtn5eD9UwPIByYOFbnwV8t4z9Yug0T/ZPCdwGhG1PYXqWclfPDCptYYfcEbgFsKHiELjbRqcolniVkreIoKBOhjdtIl0fTQgw2PtOX5oq57QqkFDz9bEB/jqJuKEOF4JlFlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EijYByxS8Tb91osqzsVE+8V4K/lz/DHwSVcCb5zo9xg=;
 b=E2Q40J3qEDLlSJgA2KPrGa3GjSJt3rujGLSK0WqLxV/5FXaohJHqa7fBh1EqI9+0cHD3VpFrPHFGPQwI/Ag3ufF8jV2M1zrz4eyMS7eU7WJYOeLe2aD0kS8klPaOW6OVotIZbK2gjmtlWEgYxYZPf6OLW7n/PKY+rT8zrm3dZgY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 12:16:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 12:16:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net 0/3] Always flood multicast to the DSA CPU port
Date:   Thu,  5 Aug 2021 15:15:48 +0300
Message-Id: <20210805121551.2194841-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0080.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR0101CA0080.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 12:16:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c404706-b725-44e7-4c6a-08d9580acb96
X-MS-TrafficTypeDiagnostic: VI1PR04MB6269:
X-Microsoft-Antispam-PRVS: <VI1PR04MB626912DDF11FDC66521316DEE0F29@VI1PR04MB6269.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qSNTjuejSQsMbN4RNfFBnyzpqWhsPy4aCfF3mR6qbrn9e4IEN1wB5zeEHZgr2A2Jh5qNMPFuKFq3tgujuaXjc6UInRPKgYgryL4FerEajn6ygjyhjhdl8YXJVwJmErmTwRMlRBXa+j4u0LjTvCd4pHr5hV3XmOWFDGdii2xcPI5GF7Q0DTR2JVNDP4yYwN3XQGnB4lBGTBOH2O0AeQHMWou1oe/1kHzIvXkqUaKSqN5pYDetLmzoShEb601mnO/fbyGknVUbmSNkAZ8VY15251nW7E68JsqhYp4lHFztsZ1gjzW31kVw8PXzUCxn9VsEWibFwtTejDSjNhvFVvjG9z3BN9Sguw1LXS0adIKKDi8HMw+oBmoR5BI1kmkET3oEA129+r26gkmKLfll7nVjooXjX7OxzUHMctOfZq8LoPSACjdYb+8IlR39HyYjdKChafSSMQifm9BBlhEwuzrHe/3b+SXfzrXSnPtSyqS9+Folkao7DO/Ar5R5aQU4lbk0n+dqdaY8dOR1U0zSypPbfLsJGHx37ibDOayixtcwL9mUnfIdBuWbaFRyC5VC24HJ4s5BCh7UtdL4HnmZgBLVz9hxm8fu3xYdRUNIHU/chzQ3KobDjw1UgQECnm8y2CzVlT5puA5pr58U12r8DZphZixtoWmKybUiVJlRNATTs0ht3vuKdCrJaVBPtshbIlw/7+ks+cFPfmi5LxlJPPxS8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39850400004)(396003)(2616005)(110136005)(6506007)(956004)(44832011)(66556008)(66476007)(478600001)(36756003)(54906003)(5660300002)(316002)(52116002)(6512007)(83380400001)(38350700002)(86362001)(2906002)(38100700002)(66946007)(6666004)(66574015)(186003)(6486002)(8936002)(1076003)(4326008)(8676002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QbJRspH0z4nnlSms/+6YzQhK6tZnbpGJlUoz2eGpBE6kB3ZvRr/7bqMYokcd?=
 =?us-ascii?Q?MbK7iIX8svWIzS9c40I/OQ02uXaJHurgoHvWFhHMdsyAjyFvD7HZAuunpPCx?=
 =?us-ascii?Q?6hur/aePz/K6kNBXHY7PoDSpH8Wg3bJuAFsWw0yInbwOy6hdEZe3+o4kSZi2?=
 =?us-ascii?Q?HyzY0Vz2kZbyRK31LM0H2BfCW9JFKsq6Pc2g2RSuOFaUr49EQnkv0eEA9IUw?=
 =?us-ascii?Q?NVYlSbU/gT++897FdwUffUkyzMY8XiwXBQnekDw1BONH0AsLNva152qInBEG?=
 =?us-ascii?Q?yz2MHCnf7u7q4gdd8A6OGGToOV2t31sZs2y4ah95G2cpel+8pe594wiRkvOM?=
 =?us-ascii?Q?MqApK23hNbt4DMztJ8A0iE9IRHIplyIVffUgUh1/2kHpbHibRQSrFzfxWmwe?=
 =?us-ascii?Q?qjoz9yNFxaMKHWG9Ojgm3GdYqRtU69rAi/bZQHpCfg5cw/5XWM5jBUAWpU1Q?=
 =?us-ascii?Q?SlcojA94LZD4XjiwEfBUxQnCfAlDUV5swWnrOtmfmLZjUP4/fPkpKKgEXI7E?=
 =?us-ascii?Q?w4DcMGyqNggDg1AoKmgx3Iq0ebHyqsRW0mRDbPZfVNaqK7/iVyBxS995fUda?=
 =?us-ascii?Q?traSlHiIBe+V4Ya60T1kpZ0nVK84KCEg21LSoB8INeENoYaJWyGK0l8dcfN7?=
 =?us-ascii?Q?Ajq/bYMaYeQqJJ1vfq37uQs5NQeGKacuTD9eT6eR2ijD1ivb9eF9L6+I5Q4j?=
 =?us-ascii?Q?/nPzvhlKAM8eB9otkoxRSBmysW/tvaDd8DjdvRpMVN286z74nWGew+RMLv2K?=
 =?us-ascii?Q?ipyz5Qi1jOOawiRtO0Pi8E1EsMfOy1xyoHpt+ypujoaLZcKkwr+sAdHpmLSv?=
 =?us-ascii?Q?AevgFtxVgeXo6xXuqk83KRU9dvfHHjlq1LulhiZeKxdd10TOzPhU0WBFW4QS?=
 =?us-ascii?Q?Cozrm1TBF7XFIMGOdEXE3jEtzcpKOygxx5T1UMkoMwQ6GBcD34c8BZ4T7LWb?=
 =?us-ascii?Q?5S5drKE41u+PmEPEd0ul0AiNLu7rzFJHo5ZHZhgR3im1ZYsEB66a4c4XhnK8?=
 =?us-ascii?Q?NKkD1v+Z/ddm+QnlrAX4ZMKSGdBlJo0yTAglIewyKB66iJbr3SvpTC7r3a20?=
 =?us-ascii?Q?dVL9ZWidomZfIOW3xIlA9tq3Os1dLQeKX+z45j+xnmuVZ93omW5qRd4QC0Kj?=
 =?us-ascii?Q?plomHh5wOzR7DQZCJnoMClG9P0fHG2BaBCfG1YzBll75fZW79kRg7Xm8DldK?=
 =?us-ascii?Q?HxSIdEQXFgRekgUPoVrPsf2TJQf/VMr/I4EEjspfqeo9GJxarJHwpLDauWh7?=
 =?us-ascii?Q?HRdv7k6Z2tM+rvWJSISdpTyZNPrtWMIhuBXIx1ywho2bve+67FkxD8iAAjV6?=
 =?us-ascii?Q?HHeUXJ9eVN5gA7yb3xD2ma0x?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c404706-b725-44e7-4c6a-08d9580acb96
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 12:16:03.9936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fU6HYkq4gVjpjPlkK8p+Be38zfmC8vhuKHF+h69IhkK01kgrv3ro3IJbYvmf9stau+sD9h2qfjlxDZtLzP5UhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Discussing with Qingfang, it became obvious that DSA is not prepared to
disable multicast flooding towards the CPU port under any circumstance
right now, and this in fact breaks traffic quite blatantly.

This series is a revert done in reverse chronological order. These
should be propagated to stable trees up to commit a8b659e7ff75 ("net:
dsa: act as passthrough for bridge port flags") which is in v5.12.
For older kernels, that commit blocks further backporting, so I need to
send a modified version of patch 3 separately to Greg after these go
into "net".

Vladimir Oltean (3):
  net: dsa: stop syncing the bridge mcast_router attribute at join time
  net: dsa: mt7530: remove the .port_set_mrouter implementation
  net: dsa: don't disable multicast flooding to the CPU even without an
    IGMP querier

 drivers/net/dsa/b53/b53_common.c | 10 ----------
 drivers/net/dsa/bcm_sf2.c        |  1 -
 drivers/net/dsa/mt7530.c         | 13 -------------
 drivers/net/dsa/mv88e6xxx/chip.c | 18 ------------------
 include/net/dsa.h                |  2 --
 net/dsa/dsa_priv.h               |  2 --
 net/dsa/port.c                   | 21 ---------------------
 net/dsa/slave.c                  |  6 ------
 8 files changed, 73 deletions(-)

-- 
2.25.1

