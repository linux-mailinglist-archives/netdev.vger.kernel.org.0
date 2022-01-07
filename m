Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79002487C6C
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 19:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiAGSs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 13:48:57 -0500
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:58571
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229942AbiAGSs4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 13:48:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjrUx+aZ7eGsRgie/M+xVaF5q2WZN1bkPLAcXtCH9c3BT1qXajy6ghAFbbYkprtp+tjg++/CfPw6E9vrExwMw5Blk5+ZH3YaCMxcILamtXf5EKW53U9GL3mVYUfGUPKR5QVVNA8RBOqvPOVi1kdMpo/yZze88Vqj23oPIkRMr9OWp9KxwksSS9iLNoPTpRCsKkMp4qCkQMnUl1iezLKrWNacD+gxhcQezwWgh6FarhZHGDI7N0F92ZMc5sYAV6sDTZT2MtipV9OK8zrwxX/cfKo+boX1dYmVR/HKCWOvjhXfSGBnfdvELhDBy18laU7GLyu4fzn2iodorCugcuVe1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMkaWcLR18tLzceOZ5E19yI5lnjulDEepn5liwjuxnM=;
 b=kc+QVcAcMh85L9exzzabpi6y9KbfL8JknEhBzK71FHCzw6Vf0S4Hj5CnM9fywAY3PdpWS2MDkiyGpCaPMszhgrI1ychiMbrj5XZZZZzw5+wGvVCn35cR2mEHQs5AJFMH5L64Me9MB8WkMyK4CAbu5tZn4lx1Vz9verQYPBCnPhJwqj/PtfjrxKoGhWuzfYpw++P2P74KihAjYXdnnBzAFMuz15Qgl7fw1hkM4SZ7Ml0Qh2pbbskgmzpnsQ0U6HDqtDPLwnjBKtaUKXXF/bG05gfcENIR3ggrEGJwlAu+0D0l4Z1iZCMa50is/OMEewXeIB0LIETCdAu744ahGxJYaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMkaWcLR18tLzceOZ5E19yI5lnjulDEepn5liwjuxnM=;
 b=hDj2et6ELdLxfpIXZucf4hCB8Z/P0Xw+/1d2trvZgs+mdBLQOG90DwIb8x5XCrMhu/H+0ffvgZYGCfw5v+NrAQdProSKrMxIM5qagJnHkP2T6P0WLsLE0/iW1SXz4xQ1Vxej8S7Rm7zrxFrigDlhgU6EuaByAq6yZbvMDNVDgs8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7470.eurprd04.prod.outlook.com (2603:10a6:800:1a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Fri, 7 Jan
 2022 18:48:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 18:48:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC PATCH net-next 0/2] More aggressive DSA cleanup
Date:   Fri,  7 Jan 2022 20:48:40 +0200
Message-Id: <20220107184842.550334-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR0202CA0058.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4b872d3-3c1c-4e05-56ee-08d9d20e5938
X-MS-TrafficTypeDiagnostic: VE1PR04MB7470:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB7470F20C785980A31E6511BBE04D9@VE1PR04MB7470.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mW1U+4BYl4nANk+rMZjJiDzcJJ4AICtGkStMQ5eyfzm1GZS0Vi4Je8HuT1GfhOTai7WX9DZlnUfpG+A2qHB2K4olo1VbOZZwYQiYm0BSCfsKweiStzyoWXPcDAhGtYI3FxRhH58mLdSceBhRWpMpt9yj0KY60Q4G3VzIJiIMCMokb6WgDmhukB8VdXkTKBJol6wLPTfb+b43GK3EAiOw91qtpEwMZwDpoIP/1yJU9wDx079jEL6jtJdQ17hqYk2FP0kaqNYUNPWNMW41uv5+VIiYfTXOjijTO3E0m9uDpsoY8drqqXChLfUNwYqyGrtnikjUouWktFtivINpqHTk35WH0dwkYIWiJAAQmh/+ys0/2dmDPdEso3o1nS9+UAb2Yj9KkJ/4VM5spRFmG5j+i1QSu5HzS7J6dS+hzawYgSeyE7oUOn/IWY2a8DPc9Mz2JKVonh525Ha34N2PROGyFKdkeFdiL3AB9RBKsHdvpZtfmkWCNEQMqDWTkwSkgYVryenDMgXAR/UmYJsOGsppSI1UgWSGNj4uHb+NS1saPMKJ0Qb082SYmZRj//z+haI+sHmCCq71BzjWJiwjhmHxbZJzQ4x64JSRTtSRp+uxNdBZlZOHY0qlgRjX1FWN1VSCZC4o6R2KhHPG3s97Q3N4RIC5efTGQMXVluxvpOjzrEdYXPWCv6loT3HjRUQO7Yl2fiQRSSBWWbEyBfsMREke3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(2616005)(83380400001)(86362001)(6916009)(4326008)(52116002)(316002)(38350700002)(54906003)(8936002)(38100700002)(8676002)(6486002)(4744005)(6666004)(66946007)(1076003)(66476007)(66556008)(44832011)(508600001)(36756003)(186003)(6506007)(26005)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B41p8oVp6/fwatlK7+ar2PWZgaVxWuzhTPnTLr2a/fqdyE7lUBThX72RlbYd?=
 =?us-ascii?Q?ONyqYBNR4HpPDjElEXSbCS8W2k1b8ebaNgAG3mY7qy70wXStYPvc09IgeSzW?=
 =?us-ascii?Q?ZugLX11pejzjbImC8rWG/SfZeYYl4YxXfsWno8tXUXt5O4Vl5Ej95JcPmTld?=
 =?us-ascii?Q?jYpo4HK7TTQg4eCr7BaPWfQ6ngmzEztyjIc5tp4x14IYGLQYwHcitlqR8COo?=
 =?us-ascii?Q?fEOZMtO0qSD/cKINbl1AInnfVnlp9ub/HGHhcwE7FCVac1wqXMa8Rkr16lzE?=
 =?us-ascii?Q?3SAMj1pdQ26kz3jCykLzugZz/Y1PwoMwEhwJ7kBeCIfTDbSzYv2iFVT1z/eq?=
 =?us-ascii?Q?qLz6O59dm6GtzQWW2HqioTQ6+QB5wjS4umMDX8vTp5Dv9iTtnBsFyRK8rNUR?=
 =?us-ascii?Q?G/hxy12Oe+Gm0Y/+UFu3+XFxRPEGe+OBLmskaV22xFGqNMmJKfapPWof8Hw/?=
 =?us-ascii?Q?4fkvabsMROvoY90IOFqaDTORYW2ZrWPYMx6Ic7c8uH1jFN3Mpv0Cs5gakJRl?=
 =?us-ascii?Q?FfkqkVC96Rvjy8RrUR5AEcGpWHX+NSEVlFhooDlRDqItBmrYvUj44fd180NZ?=
 =?us-ascii?Q?qaqrsPCWzscy0WCqWtAVPnrr5b9fc9C1QI9M/7e3MXWPWdhXS5RN/MfxkJqI?=
 =?us-ascii?Q?Aps/Y9aiFK50B8HYLHndMAZoJL0qbIVdWF3MQhO3f4R2DhtP5WSwngWQM4sO?=
 =?us-ascii?Q?GuJvPwxPdLxVUh2YdIQsh+gLassDS7v9OnQMFOeLBZeavsskZNZMeLtkV/Og?=
 =?us-ascii?Q?evNr4R0y+qmKJaKn874hQgsAZnBQSbVwGWdm60nhrVxGh3+w+F77i696mD7S?=
 =?us-ascii?Q?vDidTJOFQkaLFFJMXl61rQ4RLp3lxbm80F9tmvS/sS5NiUfrNG1ZYyAkuDU1?=
 =?us-ascii?Q?zDtK38WeEjaCtXbYFrq5t7lhVFCqGGwSgxXIQf92zX8zdIhbABOV3ZlZwqbt?=
 =?us-ascii?Q?fpZSJzcubjGOuSGb6DWIzTkacy2efzbYzcyzvnLTDwd354gQ3EzfqpZFk54h?=
 =?us-ascii?Q?AkNfZXOHq8DD0UtjnuzvlFq1Pucj4Hae0sLNMfReiABcNraYgaa0famTUXWw?=
 =?us-ascii?Q?0D7rpNTAieccPACeUZFY6Si3R1KFPT2Jc5ypaj23PZZM46CtxKmATgBpOw3t?=
 =?us-ascii?Q?iOEJ2xWkQyWeayWzVOVB74Q/SVxuP+FQfh4m0sY5urLGYZv0GGavyV/9wbgO?=
 =?us-ascii?Q?WzgAnvUl6vWmDr8cGxxtlGK+GUP6ZrGQP8rkhI2lWxUv2VxnPh3Q4VOmn9B/?=
 =?us-ascii?Q?GJ7CK5gOUlk6u97vskcU+jlCD20ggIDPh+4fl4M+N/fq03K6ZesBUWYBOq/+?=
 =?us-ascii?Q?Uf0lfc2wlmfvqX0rAcHkZ2vknD+KKpBHq2it38Cm21WCPzMhgdmdvfhr/Wlu?=
 =?us-ascii?Q?Jm0wv1aQysg42ZjTKJLwCv9Z1tYNCpL72n3Khzw5xOjknaQjbG3isDEzVBYa?=
 =?us-ascii?Q?S7C7yVL9P9+aljfJGCtMJxriCCpjT1F8++WBUu01SkUX8Ns2LMjaqWMIGWPm?=
 =?us-ascii?Q?ssG/eKhSBmoEJZ1sYMnY4xF/T9dhpZDc42Q+qmF5b7Z7rdkSUIxzaroQe4Cp?=
 =?us-ascii?Q?4dlS2/BOWjbrDaPcurqMZSsIhS0fP8qvpJjF4hREtiMdMArrQ7GuR4XCYCJ/?=
 =?us-ascii?Q?qe3aHDJxU0RyMdLAmXCA4OM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b872d3-3c1c-4e05-56ee-08d9d20e5938
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 18:48:52.0999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /H/2Q40Gw1xLkT1ofnH0t3/aoijPUqexn4m7nwlRF/SIVIT7peDgq69YkNdth7iSXx+Gyf5Xgal+GRFNGpvoJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7470
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sending these as RFC because I'm not 100% sure and may be missing
something. I've had these patches in my tree for a while though, and
testing on my boards didn't reveal any issues.

Vladimir Oltean (2):
  net: dsa: remove ndo_get_phys_port_name and ndo_get_port_parent_id
  net: dsa: remove lockdep class for DSA master address list

 net/dsa/master.c |  4 ----
 net/dsa/slave.c  | 42 +-----------------------------------------
 2 files changed, 1 insertion(+), 45 deletions(-)

-- 
2.25.1

