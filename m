Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E904D1327
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 10:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345288AbiCHJQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 04:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiCHJQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 04:16:31 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10065.outbound.protection.outlook.com [40.107.1.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1F840A2C
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 01:15:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQ+FDGEq9Ru2fH6AU8Ac6jaebRBfScMf/Seet135qzt0AXYgn2VwTBpdcfzkX6NStHbhvVRtW4B0lXPW/elwllaR6C7aKoQqj7CCxwNL/65YneR0TUEsUU+vJOwN0m+GQte3tpL1sJU6zlils0gb19v5BoE0Q3gAmqD7wG5hmfw9wc6DKh9IbMeMZLk9erM7aphs3TRPL3Aogw/4Sx4SSOiQxB0MSPkVU+bv2UMIvs3TmZVxz2GG2hRxXkm3WlzzhuroUCqQ8LXn5di4HNLu1BIH4rcG+VktpeQKjyBpzX+aipmhG0oOOeHCQpDfiYXqSE05s0HUNX4GGJg99MsQ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PihEpc/1sR1vrmlrigxVvbfDAHNjvx+5wozgvZ95gZY=;
 b=ewecKn6pUyTIuvZiCtFIgzhzxfRkrukIWF7jhT6G9SGgjERpUl54F494zzKdZrxEW0byuushKDMIkJhGRvMJEeV5IRm/bcGIMNzGHCMJXKTjAFwFOifTQb0g7/GzCuzXh33bDrpV9qZt08RnDgAhgvYxKptR2YArMRCqHKqYk6e38ICz0dz/iIWEXzgeP8NHJmQT1BwGWRTqLubHAok4fLb5FO2bEoDMrhB78JArmeMjFY8YAITiitRtyKjUx1aTlOZpI0wbSAPNpD7aXpYGyoJcmrhJiCUslT01P28sQwwT/NR8fS+dEvizI+rnMagTU9wKzvSiMkuonihV02XVsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PihEpc/1sR1vrmlrigxVvbfDAHNjvx+5wozgvZ95gZY=;
 b=AYUqCD0SSFfiJXgfraIMtWxbiGy/n8NBlhOkjw2M7rpIVKuVa/J42Gae5Ohuc0yhHZqlzcYr9tCILvlmaLGQ1RzazU4pjPkjijeN1IFXzp+f7ngOvhnsbnS7Z+Ptba85+c6pjXHkjyQb3/EFW0d/MCNQqihUS3MoBo2U79/evqQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6461.eurprd04.prod.outlook.com (2603:10a6:803:120::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 09:15:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 09:15:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 4/6] net: dsa: be mostly no-op in dsa_slave_set_mac_address when down
Date:   Tue,  8 Mar 2022 11:15:13 +0200
Message-Id: <20220308091515.4134313-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
References: <20220308091515.4134313-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0347.eurprd06.prod.outlook.com
 (2603:10a6:20b:466::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff078a0e-73df-4f71-72f5-08da00e4326d
X-MS-TrafficTypeDiagnostic: VE1PR04MB6461:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB64618E72078D66494B6A91CFE0099@VE1PR04MB6461.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxse3yYqG2MPPyVG7gMrwD37yuqgf9op+rcvOMgodeR9X7LIy4IyQsAz8hDbl2EVqY3wIqeu+/ujQyUhTAtRRG0AZjmcCucD0SxagnCTqhm/pIm1OhuquMIjzn8K3gmmSUBqwJFYiWcqVhpNy2W3v3W1cs146hZqNLZDO+k5d+Wg4iqpVLpVePRXJjyG8mWPO1twezcPyfKhjS91seUgS2DFXtP8/YIkXEQObWurEXysSwWDb2nb5JXOjwXY2fS0km9dl2ZBogPXf0e/b4RZ0PhrS0VplWSzgD1YUzNHo5YWyUOn/Z8l14rg1Q4FPWHpAtv6lyBTetVin+k0g9gKhqrdk3ovrvi/FiV4GBpLclOscP3NTghQ9L8YgGNtNHVceG/8SBFDivJK3RZRJq9j7Is/gfoDpuOtu1FAyoISs1qXpWEXqU4u2JOVz7+0400IXpAPa+1yg9vrVdk8DFkSo1cs7nl4nkXS93sk6AFoAzGysqjaLX2kwcqUpTdETGaJCZI17RGvaRnjvXpBTW78K7OTjz42oYM5gsKLeLSyuB9gxIhkoa3NpSnBD9lpoGlytvhEZv4nQGN+/jehgJ9/X8Xv/06MaID6AY61KFLzEQ/vy9nx5hlnPVjuiTycKIXK0X1xWeeuoGD9G60w+4fYY9IZhuh5gLQCNBx0kmp7QpD82gLxGCA1XfmfqG5u1ScveWY+kost9Ean4WEfKLzwMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(186003)(26005)(508600001)(2616005)(316002)(54906003)(6916009)(6512007)(86362001)(66556008)(66476007)(44832011)(66946007)(52116002)(6506007)(8676002)(4326008)(36756003)(2906002)(5660300002)(38100700002)(6666004)(38350700002)(6486002)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?++G2tzDObwkjzF2tAYqYGtpGq7YsxbJuVsRwSpVJp+lRFoSJNzzw/inUBgeh?=
 =?us-ascii?Q?QfwPD60W/DET7ioyucEs8NFNrmcboBIu16Dbv4B4LQiblbhm00KFmXfO+adW?=
 =?us-ascii?Q?ha8DPk1AQC6illDZEj52U1xbNrPFSanh5dLwJHyN4j5CjflgpdLV3UDdXWzE?=
 =?us-ascii?Q?ZqvwcE48mtGuuN1cWKkCB2Fgpt8agsEqS2NReEPmRSUND4YjbEXogbSoXv7I?=
 =?us-ascii?Q?VRyvsd4S2NPvuSbNuJfnSPIiWj2Rv9pwBwvgY8EjStpA7G6SYuSYHizzzBVW?=
 =?us-ascii?Q?BkwyTUS8zQtgGphcS4AhltfseLdUKkHfQm/22KIot18WkQ7A1tMK8BQlPl9Y?=
 =?us-ascii?Q?InEou/TvvBdei0MBk/D97tFLhAkSmYjD89Xlg81apO9gksjn4pUE5vRrqd6g?=
 =?us-ascii?Q?a128BiAT3dhRuuTNW5JMIRCB82SaozSO8Tw1HBcdQTrelCi0YbTGWdEyWPjf?=
 =?us-ascii?Q?ip4Rr2+eXpsRjpc1sKp9n/YGNfvZvOUo7t7grPpKprV5a6B6LHymxI11t88z?=
 =?us-ascii?Q?Vf55ONUypSTUtJm01A8Ajpr5xvxziiOxNOsvn1rvkr2Jrbd9L7GR8iUB4Eun?=
 =?us-ascii?Q?7hQNFk7Z74DLMrNMDItdKgdg/a5aHKEp4GYLrLQpJCpsYqlgJ01IebYNUTXw?=
 =?us-ascii?Q?VKAUOEOa8hUg9S8inzuKsgGHOkZmMGoMNZKvSs1PLPxc3IO7qnRwwVGGCllr?=
 =?us-ascii?Q?IF9nztmGhDK0rtZB1zzYDFsB3uoc8VH1LVtLPxBLqq/S5p/5su0PruTrd6a9?=
 =?us-ascii?Q?VBQJxYGmN+2diPcqb+b2cJhG44Zq64Qu3BcJZ5j9oLq68cglxIl/IyCebNvO?=
 =?us-ascii?Q?LJDU1SP71pRxNO8ipoi9yPQavOFv42vsFLcOhr81kgDgW5lYIEGVXy6E4MHT?=
 =?us-ascii?Q?lGV4V5bDtHaHHqvzKOdpiurzbR4W0L5pNPxQFQ2u2+fYs2gez3La5cMcVJvS?=
 =?us-ascii?Q?iIRmHuR5CEnwxYKJ0d62hu/WsTgHVsGjPCQLVcvOAYqk3IPHPSE/uFA2z5+D?=
 =?us-ascii?Q?sAhxdrBm9Uy7hL0rcLvOqzV+Po6kZfKIVUL5n6c4/Gj8awz/8zrzPxHGIJF7?=
 =?us-ascii?Q?rzmv6/0DR3niX+9dKgofRwgOS14qdmLPq450sWkaSHtuQsrUjzDJID3E6PBH?=
 =?us-ascii?Q?w0lxeCfhA32ce36aDTRXZzsAz2qNMEisdav+SiLJcLuRTFNH/+KFSJUZf0Sx?=
 =?us-ascii?Q?CK49ZFQszLo+/cGGsBwo4BdHRyvsK5yEgN8Jd1zBE8fEdnWLhwsV/DYqF7kq?=
 =?us-ascii?Q?Xml8QInUo+gAdcP5J02v1o0s9WRCZ31v58TA9RRAkGLhL6lpWFxp2zV692NQ?=
 =?us-ascii?Q?nAJlz5YLCZODpMPsbAZi81vqTJ4/9qADvWWh+Q7r9CXaMzP7khv9I5aPCwBL?=
 =?us-ascii?Q?ZqLEXH1UvaZ1vqODNHfYS9R3a3PRsWpW2+UV8aS8G/jDlPA3JYw7MKl6DXjz?=
 =?us-ascii?Q?aoQzpH4qChVyO3+VjIQe+0NG2gS6Hz/1DH9PizcTAwlxzRMWyc6dCuZFa0Ee?=
 =?us-ascii?Q?ljnWn6Q4ivOWCdkYq1380kJuirhdJFF0hDNfCJIfLiB/YLs2GL8aWMYJrRGa?=
 =?us-ascii?Q?U0DUOg0+HSsYgemqvV5hK+DFL5jLlCEiSq35IXiUPTKsrfXQyfUlrRSvQGE+?=
 =?us-ascii?Q?1EHF2+4NDoUgiBanCgtFUUI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff078a0e-73df-4f71-72f5-08da00e4326d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 09:15:32.8204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WKkLggfrYN2sn845LFImncozQrKsqUBMjAM5MFU6GSg6p5gvSCxgb/Yqw5W3AvcziqG6EGhDjqHOqmUHhcDRfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6461
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the slave unicast address is synced to hardware and to the DSA
master during dsa_slave_open(), this means that a call to
dsa_slave_set_mac_address() while the slave interface is down will
result to a call to dsa_port_standalone_host_fdb_del() and to
dev_uc_del() for the MAC address while there was no previous
dsa_port_standalone_host_fdb_add() or dev_uc_add().

This is a partial revert of the blamed commit below, which was too
aggressive.

Fixes: 35aae5ab9121 ("net: dsa: remove workarounds for changing master promisc/allmulti only while up")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 42436ac6993b..a61a7c54af20 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -305,6 +305,12 @@ static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
+	/* If the port is down, the address isn't synced yet to hardware or
+	 * to the DSA master, so there is nothing to change.
+	 */
+	if (!(dev->flags & IFF_UP))
+		goto out_change_dev_addr;
+
 	if (dsa_switch_supports_uc_filtering(ds)) {
 		err = dsa_port_standalone_host_fdb_add(dp, addr->sa_data, 0);
 		if (err)
@@ -323,6 +329,7 @@ static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
 	if (dsa_switch_supports_uc_filtering(ds))
 		dsa_port_standalone_host_fdb_del(dp, dev->dev_addr, 0);
 
+out_change_dev_addr:
 	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
-- 
2.25.1

