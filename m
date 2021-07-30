Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F463DBD91
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhG3RSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:18:48 -0400
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:45569
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229953AbhG3RSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:18:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obJ7xu8r8zQmgKvLD0wweVRlh9i1O/Qu6rgT07Hg/DExXcq3ez943QzxQRZgPa6tXbDmHzLmt500QIhqmpCVVNQ85XEZ818Yulbnww6D2PjccQknpIHacOO3ddf0XJZt04XeatlS8rauNaZmKJ40dfm47lzEiEAleiohJlLNACuHDrTByqDw6I88XxU0qURRAOAUPaGAf/qgclPHaTfcfDGnqbh81Whrqx81Wqq5xX1m+QpWrtEy3x9TkXcQT1nt5Fclo4ISK3pIhfobLwisyPozI9rDsQO7jyCEDpioP6GlwsuX91iUZ+RZN0D3YskYC71AJFEjHzSo1YMYJtImCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1TEBRpJ6ZYfZQe862Dh8y+udkSg5C4lXjs/m0nxnew=;
 b=AYYMuxls0p8erq/5E22XTkelZOf2H+0wXUm8cDKybJHO/CzpM31lPt4TFqz5SLh3qu07m8bldFMkvJgRnotA79KqlB5DPlbzPDsYWwve/0krbGvYZq0KJs7aebweGtDRsEXa4dgZRFqz7rs5yqCKPG1/MKHukL2zjXG6WGf+Raogy8IcjFyBs8oCIXrzqH605eihL6geRCRE+9xRrmRFbVOLJUHvgymJSDXQLUQaqYuF1WLaL9smGcAEfcC5yW8Gm8kKIJ0zbqWsDKGbeMzpX7LJsWBSSA+WO/R4uDnChlz4yxGm7PJQf8ECUnWXOECaSdshSOGgb54bYl/j6O/OxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1TEBRpJ6ZYfZQe862Dh8y+udkSg5C4lXjs/m0nxnew=;
 b=P5gljALOrc0QSzodRQMFFxKemuOjlp++GDqa3v0Dn1Iynl6FIFCLVRL7ZhZeJe/Im0DOrlhrqro4w0upxhczEn8utoiCX0M+xFzv3rwbPWE6o3IvAZFiQEkU4nsKcCPD6BHTruoZr0MCE7qVkO3ldZFrEpLXKtcrQ/Y4ABo38BY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Fri, 30 Jul
 2021 17:18:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 17:18:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net 0/6] FDB fixes for NXP SJA1105
Date:   Fri, 30 Jul 2021 20:18:09 +0300
Message-Id: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0008.eurprd02.prod.outlook.com
 (2603:10a6:200:89::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0202CA0008.eurprd02.prod.outlook.com (2603:10a6:200:89::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Fri, 30 Jul 2021 17:18:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da746c12-3735-43b3-8367-08d9537e12fd
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB396713A7E8AC1845B797C9F2E0EC9@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dbx3vh2J5XEGpU5DVrL+YlK87M4mSCo3SFcs5M7S+/7RshvHmTD6SG2qeHeVuy1C3VYycYfe5ZvYXOg8aC3We3jdL4Kp/SjRMNURxcqqzJs2Qoyd5EIB4HRtFiTFxT5aUqrpYl9PnHpA6sL10ZQZBoX9in2cQAqX7pPOQGvE347iMzpMNhP+GZMxpTU0zEWvQtEmddLNPPkz6UE5V4sB+AdElwB46q6kP35BHoMdZNRX8HYJ+jc7TzrKyvJ5gBVARQ91lVsui7UKYlPdI9yG2qUX7RoBNkRDxWU8QT5b73dqghcVGwYpusmijk8zuNUdehiXH9t7A2EgrqMu4pH4lPI3K9jNVEH3rcM/ZhnxoRtQkYvBQqTMqguTvhuYXahMjCZknqZPtGjR8Phhy3HNYUcCpk4m1hNz8Uvmisd3jAey5KmPxgenDlBl2FeX4JEFKJJFqW9bmcp5VWAXKLpoSkjQI7tSv1uX8E+yhKtHusWL9LVCV/hEGYtvl1hIzD3XBaNdJqaPBxTsn3JnZfpMDzaeqLUpzE5kka8o289qOFEIkOZKMSSINirR1CISo4QNzJpgsTJ3Rad+S8xG7ZBeaMxdcyDpV2zhbW/v8g+5W0a5eSxAyra6SPQiDtRKo80Cm42kHhvlWGiNPmziN1O6NKFhySXNDp9CA6SfP7G7JMTvzSFWJR+p8iyl/admuSOnACLOzSjx5YnMMh/66IG7+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39850400004)(366004)(2906002)(86362001)(6512007)(6506007)(478600001)(956004)(83380400001)(2616005)(316002)(38100700002)(36756003)(6666004)(38350700002)(6486002)(44832011)(52116002)(186003)(4326008)(26005)(66476007)(8936002)(66556008)(5660300002)(110136005)(1076003)(8676002)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zABnhv+14mJHf9/s6iKhy7fZ6gQcTnfwpHE7k38T6hU9mV1/01aCDIw4FSWs?=
 =?us-ascii?Q?0BrCfBRly3+KMyOpgMR7uJCrBNm6pm7EZz2Hpa1yMr4NjFdohamQUBhnAh/r?=
 =?us-ascii?Q?ZKC+1OztSTwRg5zc35Ni47Qkm0F5GWZf0v1ED/9SCCmNRyFsGI5kE13JWoc3?=
 =?us-ascii?Q?TORfkWAGnYGBUXRFyNh+GW6pWrN/Be4O4sRWF7OL9rGK+SFCLcnTnNFYkMdu?=
 =?us-ascii?Q?PGuR9zUedb75WwtFLE073uEQWdkqzsvUd/6SXN1MRMLie0RdGKrbttczniFd?=
 =?us-ascii?Q?bBRDjTCb+kADAHbcLJO2fQCb3UE17uvUJa+ukTY7tUVFgx5GmtW7NQnbOwcH?=
 =?us-ascii?Q?/Brw1klLGa7QNTGuznkws6qP3gOq6Lv36kBxLVVklW2lK0ordK5ZMMPlxS1z?=
 =?us-ascii?Q?r1+PmVnPyXlLq+JV/ra0mtrmpMRr2/5ZXaTKUqHj0G3eUbWA2lBTM4aS17st?=
 =?us-ascii?Q?wZvkcdZ7RKgugs4QUJ/RbBA89BeIkvvxp23oicp8TDvXs5dxeJnSdoWLqzEf?=
 =?us-ascii?Q?8nob0e9mCqjge9wHioIvGKGROFH0u25Q2ap1uT6o+hH2qfe9iiGdttH16yUm?=
 =?us-ascii?Q?dNU9mN2P+uQiZNibWAjPEQV6tM3Ztv+kCH5mmRqT/YUXvDp7vBCnk/wYZG6M?=
 =?us-ascii?Q?ucqOJEx1IKNa30tCHQwhCE4ZfSiXHIRSEbap82Z18LYFhaJNteCuBEAxo+R+?=
 =?us-ascii?Q?cSFtkikTo7zCzmRa1hVR511E+kg2K+aSKIropKHl8bH6VGqmKUmJP/BX3FOU?=
 =?us-ascii?Q?fEgdvhVTQLYj2lCEFODSlE5nq0W5XnTcoXUBaeghRLldRlnTvip7QFeNdJgJ?=
 =?us-ascii?Q?wlTR4u5A52VGQXUNiZStyQxivT3zcZu2SSdI7C7yO0lD/pjlGcEQThYpDcgw?=
 =?us-ascii?Q?vNienhN9uH59DsBC3YZ9r+71tMqCpBDYrkgQCZJDyuKNaTHlHabtDbMv0+NK?=
 =?us-ascii?Q?Ykrq9HPjC6navhPh3ibXM0rYr53AW1a5RwQEToLiEcLBctdhJ/dcomq17IM2?=
 =?us-ascii?Q?iCls/x1zw7M0TcBWJ3lj8HUseVSWKLLE/8Y5dWgDR0eyKd+aqbUR2zxd2QfV?=
 =?us-ascii?Q?7watTFjYE9H9Rh5gUjs7douTsnfZwU+vGj1lQsOtwpQKNwvM2HtBdF6W5cQ+?=
 =?us-ascii?Q?50Mbtk5Jq9Fufw4gaKSkTTJWJ7IXQ3VHXJKVyQKPQbqD49Bdy/Up1hCqgA/Y?=
 =?us-ascii?Q?SxfzmPjxxspSzN+kP9Pf18IrVfRnM0gCn9bwmKpQtOjZg2EWj9U5ClJ6x0w+?=
 =?us-ascii?Q?OLsxfxkkTojBzy30yfZJwq1mhLo9uIYRbtvSYmpvk7wZDfXgHqpLGdizEo7e?=
 =?us-ascii?Q?KMEoew9PGjc+zT9pYy/Ikctx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da746c12-3735-43b3-8367-08d9537e12fd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 17:18:40.1453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YXkLuoZ0a14HANruq379QewT4WjuneXEOhndlCN0t87u4Z+vWZB99re647iuLXvyirVELHh7sZ9LPsn1ZxmWGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have some upcoming patches that make heavy use of statically installed
FDB entries, and when testing them on SJA1105P/Q/R/S and SJA1110, it
became clear that these switches do not behave reliably at all.

- On SJA1110, a static FDB entry cannot be installed at all
- On SJA1105P/Q/R/S, it is very picky about the inner/outer VLAN type
- Dynamically learned entries will make us not install static ones, or
  even if we do, they might not take effect

Patch 5/6 has a conflict with net-next (sorry), the commit message of
that patch describes how to deal with it. Thanks.

Vladimir Oltean (6):
  net: dsa: sja1105: fix static FDB writes for SJA1110
  net: dsa: sja1105: overwrite dynamic FDB entries with static ones in
    .port_fdb_add
  net: dsa: sja1105: invalidate dynamic FDB entries learned concurrently
    with statically added ones
  net: dsa: sja1105: ignore the FDB entry for unknown multicast when
    adding a new address
  net: dsa: sja1105: be stateless with FDB entries on
    SJA1105P/Q/R/S/SJA1110 too
  net: dsa: sja1105: match FDB entries regardless of inner/outer VLAN
    tag

 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 27 +++---
 drivers/net/dsa/sja1105/sja1105_main.c        | 94 ++++++++++++++-----
 2 files changed, 84 insertions(+), 37 deletions(-)

-- 
2.25.1

