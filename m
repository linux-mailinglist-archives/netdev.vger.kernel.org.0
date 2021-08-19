Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853273F1E59
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhHSQuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:50:55 -0400
Received: from mail-eopbgr60041.outbound.protection.outlook.com ([40.107.6.41]:55457
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229465AbhHSQuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:50:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U90El+28dOjbcSskIoPMFcKuyzuHZlqsakKF560E93cBHJWyGRZW4iMMlGx/YbLSyxmGMWUAi42imRYuLBS2/RnG6DplrJEeWxGK6KXuOMnfiIbmV+toO1EoA1Pg+mNtMf00n7ICnck8W9PJE552jKGoYfeqQbjJOxHbDCH3W2WA7zmOIUehVxBY8BU76J39k82KbeKrdLOQVk4ffa5za1ljXdyJuBSmvKNE+u2cCRSnjOeQtbtWqkK4akO9murPzxe+qoPCQLkjyvdrNmGMoh+v7GwDR5ipM5DJEE3O8Zh1aQdrkBOgTKwiHswN50w6Ig/9CNO33BE0H4H0cH5c9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fElHKXYmuAofCBSmQrUppBn488CZBhwdwToROe2+BJ8=;
 b=IOLbjIBDSxNfabKKsN+pLJJqpeWrkVmZ/UP8eX+vXnw2IEJf8IBZHScH+xJeeBoLCQ5mEocgwCAeXWkEVbG4QEiSISEHBNptS4orJEwech0vMkeS4Gs8B9k2IuUx9alBuxhz11pau3z+2AdXUynSZxp2Umr0zpK8fhQ1+WjrTrytrSRr3TizlPqTt19hFDKdzk1XO2ikQyEzdCE7YvNkUm4aU0JofjsAiiDS6+17zOKSeKYGfLSiw2ZSMOAHffbP0Srx/DwsrDSLf74P0qiqBxxc0EDjVc+COR7uzQyzbMk9NSX93qawqLkUEGpn1LPBDU/RMRyjyH1sR718ibw0vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fElHKXYmuAofCBSmQrUppBn488CZBhwdwToROe2+BJ8=;
 b=Fih10esAnL9av6mSfP73oZzz8915u/GlivRpBOlJske9zwc2LE9t/aSNfg9NpiXewDP3DQSOgOb3NNYEdx5bFDolQfgzBgAuLhqUB+PEVVE8FWnP/zQqeG5Lvud4+icqavSkvWJz69oLo0dx4rsuarmO95DsZFG9JhB3NlIfznw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5133.eurprd04.prod.outlook.com (2603:10a6:803:5a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.24; Thu, 19 Aug
 2021 16:50:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 16:50:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 1/2] net: mscc: ocelot: be able to reuse a devlink_port after teardown
Date:   Thu, 19 Aug 2021 19:49:57 +0300
Message-Id: <20210819164958.2244855-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819164958.2244855-1-vladimir.oltean@nxp.com>
References: <20210819164958.2244855-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0009.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0009.eurprd02.prod.outlook.com (2603:10a6:208:3e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 16:50:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 330f863a-2459-4ebb-6547-08d963316a3d
X-MS-TrafficTypeDiagnostic: VI1PR04MB5133:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5133B1CEDA6B5A3A98991F86E0C09@VI1PR04MB5133.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DUtp6rmSQzpR2dckWdTD+Hf8MPWIQpVAeq9axeGtrLTvBxJf+SN6MLGesGcDtr7C/vuOvep/Y0bS4GGvdkcCUmPkK8j5jXz23vfygFb3d9xqB6lwKlv6sAdoFinWIb9rKN7K2PmiG93QHdEaOSKEXJ6rxuBvXNSqAFwDLFTdTfERjNYdvcxeWSlH1u8V9AriJfH6GyTsIC4pxMADMalSNldlVLlIMjzgZRZiaMsOBp7d+aZINCkJGCwaed0l5S+8EQiTbPF7dP5cxAtFQG5s1A76Q6nU7Lr+MMsAA8rrWdPq5qx7kQ6P+f0EkjOppHT+nKSr9cpskmkkhQmWJg3s0ooWP342Rni2uyaOc9qYTb7qmMsx4i4K9KJReTQJZEPm3JjJLZPaWdmiIVFjjOkHgyvsxMxyXM9fslqq9+fOHadeNdmzhRdwfzISlWhApQY82oS671pur51ycFS4Aw7jubwh/UJKZC5dhnoKI32y/gxcaAoJ8ZwKZLp8fVtJJIl0hwxqfOWzZojK7xfZKf5wJH3kyzs2s/6UJa6XqejYzQyXhrSv5mkkwf2LBF1NkwGDtFioNPShJhQCwPB5+ub9MWNEjCCfGkVowQoJCOx856cv9ew609GswVMESF5yoa2/JYoeQic9MdEJj3I12cifHQJw3GBMGLpRCFvYvR1CF6xBjOEkHqMca9BXLHML6hEX2YVfr0nJQuBmeaGyERSryw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(316002)(8676002)(54906003)(5660300002)(2616005)(956004)(4326008)(86362001)(110136005)(66476007)(6506007)(6512007)(2906002)(6666004)(52116002)(44832011)(66946007)(6486002)(1076003)(36756003)(186003)(26005)(38350700002)(38100700002)(66556008)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A3A4/BntqP0nhqOfR1LaaZrqZOHsHyMYrj/QIdNKl4/SughfwynQlCRwSeqx?=
 =?us-ascii?Q?0ZnOzDNcuocb1di75fnvDH4RUvQzgNK9m2d74i3MzF6Y4G8oN+gjXVLvwzML?=
 =?us-ascii?Q?InU3YT6k2VkYi/2hMKcC5yn2GMPDL3V7gsL48JL0KN1BE+sOOy/25EJsOZWf?=
 =?us-ascii?Q?8zw1s6QxVoKE+JKkJ94WwO0v7odYDG3T+GkrzsSdIEnKva+//brq+I7Mm+On?=
 =?us-ascii?Q?/aPs6nnPMmPLEQqvuQ+27PpKVMcrUUky5XKPgi7HuhFj5oAou23MWCWwpJXj?=
 =?us-ascii?Q?7Qq0W+wF4BDW7DQ8PYZ+BYtNaQ4hztluQ4uZlkm/sOWeMpt72tEVxm6TKpaz?=
 =?us-ascii?Q?Q1ztmcKwWc4ihrx/yGXMKXOTRG+N93KPCYi7PJQ2SpnBPRCXvOxt3CQbBud9?=
 =?us-ascii?Q?AjLOeFs790+cMrn6JWPSZG5BxJsu2KcPtSNZeoNkBi3lt5Wim5ZVE/gHDaEP?=
 =?us-ascii?Q?dQGfaduSLdjMJ59mLGuaDZPRDVK6DCumJ0l7S5t/UdcHMNDk1qt87LNoYfCs?=
 =?us-ascii?Q?Fh+xEpAAj5CZD8rOT6rS3OWxt7XA4vBMa9RokKPvHOzispCWDxE9wxrcvRHf?=
 =?us-ascii?Q?yM85OwcqkomCGAfhUvUSPBQw/yFnDTqc0v91gG+AAwcwHhi6BH8atZRO3Or0?=
 =?us-ascii?Q?oPCG8LDDxWqauYMPaxIdsFcb+C7+iAm3CzW/ib4rDTn6DrQ2i4jchhPRvY9h?=
 =?us-ascii?Q?HpuZLPB/om7F/iL3Cbr/nWL+jj4HpRAkVCWvwdFoAf67s/k0fnhqhw6kpaGl?=
 =?us-ascii?Q?zuZQUm9iAoq7Eh6pXGrJ4NXkZsrBBnEjGK+AzhpN9cUtWbhOquny+01AklVt?=
 =?us-ascii?Q?etypNa6EDmpEnh/NUdsfvFu9YzK59RzqrvXgdj7riTvAFZKXdB0mAmq33jJi?=
 =?us-ascii?Q?00bxQbnfHxQSCsrffShaf4/sT6P8G2jK/C1Mt4PAHzQLSGAfY9Y9pfGY3kdW?=
 =?us-ascii?Q?3eiP3ZSnTXeHT32u+/3J8BuVFzIhQMCPmFZP7E4Do9h3eu+74Bs7Fbwfx+dL?=
 =?us-ascii?Q?h6gq1feWM38fAWV4SZIAkCbzfy4A94aF73EmL7RjWbFaT/yvjRIEzMJFVzCP?=
 =?us-ascii?Q?IFHPPKJ0tG9TsPXk/CpsUmIBj1PyGC83WV26S99rHeK48gfDaVpsHUyHdkc/?=
 =?us-ascii?Q?YIVAFm2KOO3vezYiDtFP5wff9QVQdID7jrmL8DtVEuXmJLLAilr1vCtzNRIk?=
 =?us-ascii?Q?BbvfzVAKSJqwb91eNZ93WuDbxzIjnq9D8Vh4iR+MwB026fgvpiKt75hBnvg0?=
 =?us-ascii?Q?b+10kigR+8bGpKQbLK6x3lXgytT5ohPMcaBBpovGvHAYglMRz1IQ3P1lwt/a?=
 =?us-ascii?Q?nUTswmejtRyTUnAL6noryBPC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 330f863a-2459-4ebb-6547-08d963316a3d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 16:50:13.8360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0yndrwodBE0rvBlsAgaS92pgxDWzSrf2SNtegXBepz6BBSsb0tC6PanwiJzW/GxrI2V94/2ZO6KFdgFRQqJQ8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

There are cases where we would like to continue probing the switch even
if one port has failed to probe. When that happens, we need to
unregister a devlink_port of type DEVLINK_PORT_FLAVOUR_PHYSICAL and
re-register it of type DEVLINK_PORT_FLAVOUR_UNUSED.

This is fine, except when calling devlink_port_attrs_set on a structure
on which devlink_port_register has been previously called, there is a
WARN_ON in devlink_port_attrs_set that devlink_port->devlink must be
NULL.

So don't assume that the memory behind dlp is clean when calling
ocelot_port_devlink_init, just zero-initialize it.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 9adf7dfb5389..9745c29c09ef 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -174,6 +174,7 @@ int ocelot_port_devlink_init(struct ocelot *ocelot, int port,
 	struct devlink *dl = ocelot->devlink;
 	struct devlink_port_attrs attrs = {};
 
+	memset(dlp, 0, sizeof(*dlp));
 	memcpy(attrs.switch_id.id, &ocelot->base_mac, id_len);
 	attrs.switch_id.id_len = id_len;
 	attrs.phys.port_number = port;
-- 
2.25.1

