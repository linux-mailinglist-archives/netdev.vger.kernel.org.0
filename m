Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208F42873A7
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgJHL5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:57:15 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:40513
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbgJHL5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 07:57:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+bNxzwzdFAE9tOHp50+wQ5AMe+ZmiBUA9N5TqV+URYWQ+OPqFEJl8tCOSC1TnY27D2kuz1lkksFNztFjS3V7gBe4zaozhoZyv9Q09xOxyeXfjBEWHRp+arj+BQsqW+oO0UqfOtQhoqmtglwrzkfu4dtmQwuGXPQTxlkHZiVEQcC8zvmanUxHeR9T+KD+m5QGcjsnUfv+/DJ5nVWNaQjDMhSQczXndsha0/hhJP7Jmzyk6fZv60HxZlm2lVrqqcr4GlSFsk2GRMYE8oxRiHw/EdCL3jsEApB/XMT4rGmywe1PAc8q7GC6a9jQ4WeLDGOBZnGc5e4tQdIMC0VZpxXsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0CejpGlAgvWDZEBwHCXfgfa5k9UCwHlcHtC9I4+4zPo=;
 b=Ya5OxNSU24dpVeGeS9WA3iENP0z9/34qk/qjJ7QCDeDGVUE0QXpHAlaBXLn0JbLuPoyO0D+DfV7pTyAMwgsjMgMzp2xTYBl+1x3euVsMs3W5m7diLiPM8EOaD72L/A8swFt/1/o3d1C5l894Q2UmBFfFVfBbzlpeOKz8Se59B/8umwhmuwSsL3vxgZ9rD7SW/SaRWCt7tAdmbD+FUQqGKlFArQZ5TsSw2f48C3ONWhTqHCyJ2TpTvums42zaR1LqHvJldMtZrwIHXZG3j/PWsA/abHoIhNeadalqI091hP+bZTL811xBGHHBRq3HTR0q2aI7/6v5RUCps+A59N1ZxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0CejpGlAgvWDZEBwHCXfgfa5k9UCwHlcHtC9I4+4zPo=;
 b=Ka3lJ82r9qKtw4E/uYBWEBzMVtpydKfXS0etpFIUW6pBunDspleTRyX9ToH/AhdYTzvGOSY5DUjySVGcMkfKHDE1tBKamVM24KJT9tLa0qAc7aZL3UVBGQsU3OwHtzBDwkGKXolRoLpLx5GSt6jtE7CD6IPJDsKQxNBvGhdx8YI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3709.eurprd04.prod.outlook.com (2603:10a6:803:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Thu, 8 Oct
 2020 11:57:11 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3455.024; Thu, 8 Oct 2020
 11:57:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/3] Offload tc-vlan mangle to mscc_ocelot switch
Date:   Thu,  8 Oct 2020 14:56:57 +0300
Message-Id: <20201008115700.255648-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM4PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:205::23)
 To VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM4PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:205::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Thu, 8 Oct 2020 11:57:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9692da28-fe0d-47b1-14a2-08d86b8149d0
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3709BA0BFC51E48A01D88022E00B0@VI1PR0402MB3709.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HBZVPeP1wKgCCeF/VPD0kAOIqS2wyvY9v39oEZpmzKu7rAftBkHx7dlg+LN+a7ZT+N5kvVCnc9EfX6eWtmyXt7VyL9TrFwi7zAEshvLtqYP7Wf/fQcGd6zJxn2+06Ja8CZZpjOP/dj1xsJ8icLtKiCF2tr5vkcpT0I0Hcca7uqq8P0CRsM3m7glDK8Lg7OyHYR93gtXmwA4DO8BCWOqtTOwytuHTMqqBsxy5AUHhtA48JuEfQSiA7VipW7HxG5IVFaxo0z8iuHg69S6Y0YPzV7QjFeMvnpbpI12KvKK+nrLo5IF3xtyvpXKMpPpMSPyT2zppq+d8LZMCWgGFldYrJO4ZtkhzmmDo8gb1syoBkp6ESBXYt60Wq8jAQAvT2NAD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(4326008)(6916009)(66946007)(4744005)(6486002)(8936002)(83380400001)(86362001)(26005)(36756003)(6506007)(16526019)(2906002)(478600001)(44832011)(66476007)(186003)(66556008)(8676002)(6666004)(956004)(1076003)(52116002)(5660300002)(316002)(69590400008)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: poNq6CHu0OkwtrdIfOY64U5+4WhwBGg4+eVesWhmAo3cFBu4BLndbeaA0vFfGJuGksATPc/W4gZzDaH5fJIbeBU/SBtj6TtoIR5fivz/rTPgKeqHF/7jZVmjS4D1W6n63OhRk+/jv5CVIJ8/8wcKPlc9mOIf4736ky/v5zmAZrRmy47ueMyLvbtxjFDn4g1+jhzXlkmB2yAuCMIm+FspFK8SDBUinXJuKsH8WvxdeKp0fWAlvPLwvudUEYB035RQtyZ2+ILqIxp8Gmj/+xIrlJcbyzNChTO6uI+Ix4so+83XybdJjr+gMOLbfg6K6b3lOa+/i3XSXjseT2MToxJEueF/pod1QkJ4PKvUvy/9rs2zFKHGXZ71qspidec7VV/5IBZR22Eh1/S/1Ll9r5CcoWrTqpTrUce9gPu3zHAz9vlapMUQuRGKyQGoopm2nlS5eg+JOsI758EyLV2WBZ4lSy4BhF5TiovLJY5dl5+ZPS/qn3sMQrDLT1RqaDl42LagSToNFnhikOjbODabKEuTXlPLhusiaIuPllaVbk2LbyiKRWWC7UHc6lmdgjdeIXGrLuI/Yc8Ft2Qv/SYa61KmTrWWdyXWe/b7hG+OO9TY1Ef206xY1qK5a78/ssvi7Lph8jhRA5wcgL8gw2HRgIO80g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9692da28-fe0d-47b1-14a2-08d86b8149d0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2020 11:57:10.9050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZfcQFNOJ0bsI1vupLDidIqUVsD8Q/HQfoq3l7a9OBwnSSu6oaMm7019xqLg5MaUnu3k8EqxFwtzAX+17ipyzCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series offloads one more action to the VCAP IS1 ingress TCAM, which
is to change the classified VLAN for packets, according to the VCAP IS1
keys (VLAN, source MAC, source IP, EtherType, etc).

Vladimir Oltean (3):
  net: mscc: ocelot: offload VLAN mangle action to VCAP IS1
  net: dsa: tag_ocelot: use VLAN information from tagging header when
    available
  selftests: net: mscc: ocelot: add test for VLAN modify action

 drivers/net/ethernet/mscc/ocelot.c            | 15 +++++-
 drivers/net/ethernet/mscc/ocelot_flower.c     | 29 ++++++++++--
 net/dsa/tag_ocelot.c                          | 34 ++++++++++++++
 .../drivers/net/ocelot/tc_flower_chains.sh    | 47 ++++++++++++++++++-
 4 files changed, 119 insertions(+), 6 deletions(-)

-- 
2.25.1

