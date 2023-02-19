Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50AFE69C075
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjBSNx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjBSNxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:53:48 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2041.outbound.protection.outlook.com [40.107.14.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DAF8682;
        Sun, 19 Feb 2023 05:53:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ad3UTFdIqaPl6i7KXCR/qLDL6BO5TbRTM4KrHW7nWeu8CRbgfi/BA5fWeBemoToLGd6FlkokL1HWPNw2D09Gb/Lyr6lHJIYK27pXzjnxhBEIJo8idWll5ai26oouunuDWGdSObd2PFCHQ1jv43F26O9PPLoWLX2uq6NZoy37cMT9Ahs+fCpp9JgzylheZIbbWy/cjQXfRv+anXkD9rnJtuIaHUUIc3m1a11ddhPHQWx11UNbhPqibf0swxqmAm6J/00ES3IpZTHSrN+BZFwtIDM1uYJhD56JgVbFvDNHlaPq1wYOC1lmjwpyc0tXGDTNvJIVpWlvnIll6LW7drPvSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KAcT0HkzHfhthUr00XV9F6JG0Hk17BzdNfP36HDxFrY=;
 b=comU/+GSPPKxs0o+V07X5kzz3vtere5vDkkGzgpLxdlUyJGugporBtVh/OwXYovyrI0ThcwV54rHvzEcrnYo2WzwvnswE7XB8vgBoAYB/pGZ11Li+h4EoWr6PlLFYEywb/+nO0qznbAzCFhSVBhKhd/k/6K//el1nkNwdRiZ8OmEut4FEY/80T1EWWH55syEY2ZjPdmKY1SZtONrxE8yGPTDcnZet9LFePhOTiy9jtm800ExEMvofNJ8XUsgMMpu9pY3mC0dRqmRBn9kDOZ7Y6YBimJFYKrKDSL0HDwOhWY37c09KwzN3c9AVduMObCrSCqnGqcm/6EWKY/jA69IwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KAcT0HkzHfhthUr00XV9F6JG0Hk17BzdNfP36HDxFrY=;
 b=MvtwJ1ip5XOGHJoywKxc5OOH8wOficX2cPYsxyvTLwVl9g/ZEs7UU+nUmOKQZDKXrdvMZ5L8cO3uKf90pWZoLP99zIzbcYpOvfBmpCBqqQ+DTwCe2OYcWXf8nhQPtVeDwmDWe8AboPzDkjKXqMLmfuTiyERVzhKN5fdA6VK9T7U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:53:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:53:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 04/12] net: ethtool: fix __ethtool_dev_mm_supported() implementation
Date:   Sun, 19 Feb 2023 15:53:00 +0200
Message-Id: <20230219135309.594188-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230219135309.594188-1-vladimir.oltean@nxp.com>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: 1065324f-985e-4e8e-ce7a-08db1280b79e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AFWGWZQmktRWd33jNytt2rojoBUGD2k8Yc82GgQWFKgXNxEFIF1FQdRm2FFtU8YHuY2FQCZUII7U6p/RW0C+/oJzA9AJU9oRWH0WRkZAmhFl8cXiLUlJj65mMPu221wx/rAMVup3HlSwlRb/oKDzGyD/laG8DMwm74DOGxhaW2TX1tjI+DvAGkdeuOhdVPHukHvE0W7c9VyeYlAS2yZ6oRjy/2qe9ar2/q3DQwLgFCkJmFdretYTDMAA6Gf8v61plbMPX+GIY32svAq1x7YRA+UbxnZiqEo9+Q8zvbJg6ut9An0N4niO9/B4tQtndYOpxolwdOrTxVJVAuSFM4huH7yxTQFR0ZvvdOsHV2YDBLpKX2kUT33Dl9Nav6KT+GIUxJNZ8d+bHirrEvx9cwlxMy/ki0xDKIgTlJLVdythMvLH4S5RbhVRaLzmOVanENib/dI0NZYTph7zuUWdAN8WctRme+CwQ3J85rCH4wxzt40yqvJumgdMF/wRzLsdpHEEBJI5eJkaNz+5Ei/UygU+6X9XSMH3Ihh0yaYDjAPNaEoO9v0CdlBxbuwkdnXc8Paxt59FFKM7Q7cOch3F+sQqkk4gji8o8LGK1Fjx1NeLSR3eZipn/nHnBPyKa7za1HEb/RlNZxQAbgJlkn3ZgjFC1FSVYNE5U4405jeldlqE3oZTTlQjS8rdyBGMFjSsVIsRTmfG3u0ZkcY8j813ftrXYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(4744005)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6666004)(6506007)(186003)(26005)(2616005)(83380400001)(52116002)(6486002)(478600001)(966005)(1076003)(36756003)(316002)(54906003)(2906002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tpv/veH8FN4HiKcdueRMYHZ9xqXrZ2omjrgCKV1GjlPmy1bpi/ziNi47DUJ6?=
 =?us-ascii?Q?QmJNDifhOa+Ga6aluTJpmXcUs3YFG+no8P3NTEi2CccmWx1yVuQXj8efv1Bs?=
 =?us-ascii?Q?ZNcHJBC3Ps/j/T0vOgisB9fODScT8gr/a9+ubKlXtsW4ceSzp9x7W/m+Fusy?=
 =?us-ascii?Q?Mi4qAepjPZASJmPFtcshQLqw5JbbKJzwbZTxV4S0eU2jcc+tycgfuX73A2Ty?=
 =?us-ascii?Q?GmMioRYjy63L3tsVfeVt5HERkS2URLK6m1eJpQa+ctqBi2GXzrnf49eSV2De?=
 =?us-ascii?Q?5R5trSfThM7OQgNbrdmXbLWUibsRWfFdOK4+n5RIr2H9W1iKeFOoM8aHwYzV?=
 =?us-ascii?Q?ubuXwmQ2ms9uxtcqHS+iboIl+kVn4N5YgsBU1XUJvDLkmE6UcVlutnPfNzZJ?=
 =?us-ascii?Q?JUz9He6TPCdPvUXuLMvjMwhSqM4DXMHMFd40uZRnyzoDGTQdVH9v4pjJVJUY?=
 =?us-ascii?Q?AHSI8yKC2rc/u4SVEGgtg2g7EuFN4TGF2+6bntYhdueno3whAw8ECa8+2tyK?=
 =?us-ascii?Q?K9nK4HFv/H+WBTfpa7Gl70LrHjUpt/DX4a3nBkp74sIQfe0Bc8T0uuXFnR3d?=
 =?us-ascii?Q?AhSMZJW1WvbPxua9jrfflNNEghOop8mBPmUEuqfzci3JwHWBCXibC7O5gqBY?=
 =?us-ascii?Q?KMYtp9ZYWGI3KKf0BrK4PvmpA0sui+n3hhm2rqdx3z5Ps3quGg4u7JD0DacK?=
 =?us-ascii?Q?iGaCjOJxvrNnsfIAxET46piVdeMV0EQB0IJC3N1Hd9k0qPforEka5wceJzuf?=
 =?us-ascii?Q?nkqjMa2GPzOerY43RkW6wbJm/fynW8ht8CigE8Mfbxj5yhYk31gZCcPJoXNL?=
 =?us-ascii?Q?O4b/mBiLajyVhrb5idUy8F+CbfgzsNvGEXjmsTPxtfWhzumH8updhy9p60FN?=
 =?us-ascii?Q?caMirGN68ZoPdqSgcAd//0NJQ/omacXY96/kun6ftpgj6B+T2MDc72ZZfMbg?=
 =?us-ascii?Q?8p6jQ1iScl8e0/95Zpkwf5pDxrLztCwp/BbEsaThwqHzinAkah3XUWe7PbsT?=
 =?us-ascii?Q?9/gW5UK8gYtZvLVsfEY9A1w03kJkx85gF+gyklcHtrHRIeAJeaku76DI+y0R?=
 =?us-ascii?Q?ac37abZjgmr+SCwZd/wiZZHXI+4GbtjDo+YITWx4Kw9MDNmpbFORi5lp2ZXH?=
 =?us-ascii?Q?Mb3hpADRlbixY6KXImsiItCJlAfMyP4kUdc+PtyJ+G5v+PuXFz8dNOFJ4xqv?=
 =?us-ascii?Q?pGGGcoRuXu9KOojTUNiFbnLngrfFYzl23eXODM6lLtAD+hnAY/Cg3fmkZdoH?=
 =?us-ascii?Q?nMpnDIDttgHg3CC3Gm/X5j4Jsklx8EVtXJDq0Ru6oETCKJYApA9xrCjU+0X0?=
 =?us-ascii?Q?dhwb+PiffWM9Ioyr4krQQMNS0ERniIh9IvJYA8A1h6gxp3npgfczZPUAiOP5?=
 =?us-ascii?Q?AeindV/wQVzvbuVo7A19I+0ikjqovuTaeFLLKxcnTuV7gsr1RVVc9aqERIK7?=
 =?us-ascii?Q?ZdrWmZcYfT4NMaVvd0zlovTXJEcQiN3B4I6dLxf5M6OgKZgbzCCeQij8fq4q?=
 =?us-ascii?Q?MHXD7SzO/27U1q38Lxqr6RjLcIbDdgjzzTBprhKiXXg66GdeXkfG9tISS6g0?=
 =?us-ascii?Q?3X40Y1GDb6j6CKUXBkO+Mwgrre6cNhIlHnoFGQ+huJZmnZrTL8kpdzVzl1DB?=
 =?us-ascii?Q?tg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1065324f-985e-4e8e-ce7a-08db1280b79e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:53:45.0996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nEK9m9NPv52IjDXXbjP1S8ov+aD30ndPd8tAS7Srj3/dt9BN9ANYB6Hk3MR6C/jq2L9qtiwAOFcDukWb6yGOXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8238
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC Merge layer is supported when ops->get_mm() returns 0.
The implementation was changed during review, and in this process, a bug
was introduced.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230111161706.1465242-5-vladimir.oltean@nxp.com/
Fixes: 04692c9020b7 ("net: ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/ethtool/mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index e612856eed8c..fce3cc2734f9 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -247,5 +247,5 @@ bool __ethtool_dev_mm_supported(struct net_device *dev)
 	if (ops && ops->get_mm)
 		ret = ops->get_mm(dev, &state);
 
-	return !!ret;
+	return !ret;
 }
-- 
2.34.1

