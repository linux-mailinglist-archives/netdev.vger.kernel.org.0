Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358B35B79D0
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbiIMSkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiIMSkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:40:02 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2099.outbound.protection.outlook.com [40.107.20.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0108287F;
        Tue, 13 Sep 2022 11:10:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+iAZoxKH5bj7wwU3nZrNJrVcYXqb5l/JBQrHru9FQ8bYS/i+Las6FRoKVNn3IkTykIWGYDNKHPlZzZ+H0ddRcCF1CUEnO0t5pU/l39cbsXD/ZG7LZkQsAFpIRogzm6oYMUj275O6vIFjZrS04T5HdWk51QuzCIwF8sHJFMBltfHgWvHAg7SidHsSHcuv3Ft5ZO19uKKilBY0z6zvw6H75i+BpiMMpDdo4L7HFA7YeNSGxwjp7hRwOkxz7BIKDYVMpp7/IpOdW6HKM2iXTqO/GOI7aNK2T7qXDSkhnTDQDIfufscC47FRmQZnTQFufUHXYWe1bSgn0TNOM5TQ3MCBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBXv5ryV0SR2EaMDdtE5JU0n06D7/nES5oVVmsxETeQ=;
 b=CMygcTthkxIaFU+CAd/MxCJHK3cpGPDEhbHDy102zhMrX78vTxcfj6pLsxBcEbRK5P66gkB9ZnKNr+OLUpDF5zAXbZ9tCWChQ9Z18dYcLiuSVx9SEfPgmQapF1YMPpJcfM/WfogJoG8w6ty1gbRE0hpzcmumn02EzKmPkKnvbK48WLtgSUBIhbheREhgS9uBF7vB89KYDr3b+pMNyK1MyjESvR8Q0gbK0CJsWmcun6ovCrisBHW+BMygIYKCIuGA+e448TvuEE8vhode/PQb6vD+kcIwh4Y4qDKQ0ZEs+XMewXc7PVcTGaxZFxRTFZ2MaNyNXOe6ZZMOTvLX9zEU7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBXv5ryV0SR2EaMDdtE5JU0n06D7/nES5oVVmsxETeQ=;
 b=iiw074o4h+3DjJCSHgGWg0Ldv1WQSdUk6nrHzTvqHm576wGUKVzSCgqwQdQJP1FzQ3Ua39L65XeHpDLvkr6zyVS3zAA5LNmBi62Uv0Pd+vfqUgb1Iv1/qfEbmR4PAZT1nD7vazZRc8iJSqf1aGRh2+3A8SSBf32XZMGX+BCEYH8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 18:10:21 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::c761:b659:8b7a:80ea]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::c761:b659:8b7a:80ea%5]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 18:10:20 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, hkallweit1@gmail.com, andrew@lunn.ch,
        linux@armlinux.org.uk,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH 0/2] net: sfp: add quirks for FINISTAR FTL* modules
Date:   Tue, 13 Sep 2022 21:10:07 +0300
Message-Id: <20220913181009.13693-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0180.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::13) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1P190MB2019:EE_|PAXP190MB1789:EE_
X-MS-Office365-Filtering-Correlation-Id: ae5fc287-4ed8-4a9c-eb56-08da95b33866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EUXuiE5NSu3RdwN9DBhIP3mNHyy26ZcSl/lMeVQDTYLHKt4suqi6lr4QN0O4pzfW5L7T4XWa+mC7S5KQkqVSKBo6vzBZr7Wp5tOjE2zrgRNmPFfaoOSVLlNn+EiHstL4APCNuTqlAUjq11H8MN6bm6WdfX8nDA3nJF3z9Ma8LpanBVa3oCZaTIfM06caqPsyX146a1rGGL09QCqjbkeeQ/MSNmhisrDpzrRENJdgHXD7b+sF1EM9q3cx6aKqhYSE3LI/y6TJ53qydEZag8TT+ul5WnLEEGyUhy3XuFHs6e4wyKMJb/NeU2v4hiNYTkHgFVDa5QV3iB3XCzFU9YNDgVK2mfDOqBC445hZ3360248a/7PTRC4T1vsNJ7xeEbPNQR25oRNZZQK4SOx3yS3c1CXKNXScjFkRNSPtBL5JK8DR8oT2jagxHY03cohJXwdPUj1lWCjN6Rlvo51nkv3ipo8JFKCguMTtafABpkPEeVgRf4z19t9KP81W0MDcO+/ymlklrjvXByUEkEvoLGmUz/qI3sa7piyp1fS7emijMUg9QoCL9OxBiu621nvA71IV1ocuqyCkIJRbUdCmPIiM17QIembf0xhMG5vzpVz/TdqYDMcGmoOhPI//jyFQE8CNLR882CUyIi8Ok5djxKmO5YoVpPDSCCCS/VpLl1qWcVAmB0atkULTc8/19MEFXvcoZh172sCfRPxvs9+xlx6Wm0xJwr8kCf85FOXkk2tVj3MKKUvIsZTs6/btz0BhHghA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(376002)(366004)(346002)(396003)(136003)(451199015)(52116002)(66946007)(8676002)(186003)(66476007)(5660300002)(478600001)(1076003)(66556008)(107886003)(44832011)(38100700002)(38350700002)(86362001)(8936002)(4744005)(41300700001)(26005)(6666004)(6512007)(6486002)(6506007)(316002)(2906002)(2616005)(4326008)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Nz0k7mDNQgCuvYng9yhMUeGPdXigHGXtFTn3lx7Oz9E2mWIAwEOTfPFDnb/?=
 =?us-ascii?Q?93eIi4qrlXbkZ2aiLyCYJiBPqbKAN8z1Kx0oahVqO4yNauIHIXi+RwzKfwas?=
 =?us-ascii?Q?b+6Tvf0dsd/MQYyqIEzHwK6SwtQZdVNL1Sp3nzf8bWITXpeg4Q2DbTdnPiIf?=
 =?us-ascii?Q?Wbj1yOeTUyhFZe65dwV9aT8Db++I964zgRW5iCQBXbQIskZaHC1ULdpZRn0G?=
 =?us-ascii?Q?Ng+EIQ6OYAJETSIjQC5E26XGJD6xGoaZIDdVbduzDDatg2fFGLrFgwRbMkly?=
 =?us-ascii?Q?etBH9Of78uh0ksFtBYvRxXX2kaef+BnMaRoZ2Q9LECXS/qg+rsdhTKu4hxxl?=
 =?us-ascii?Q?eR9/Ocw9rLxy59U02W0+5JZ2+xmzYn0GAq9zhYBhILfHJO+vKGRicqQBv7Q3?=
 =?us-ascii?Q?/mYaiLRTAEouLxtpIs+gLtbpmw0TXnpeqIB69QYFrEclUeQd0Ry05YxMBJ53?=
 =?us-ascii?Q?jfAqI3IhqPf4EYuP17mmIwmiduUBaflrkgcxIDNBau5VS4AV5TwxSTnmwBL5?=
 =?us-ascii?Q?T6BF0dH0+4I49bV45QU69ryqhqKUW6bEDhN46RlEMcpL/dhHA3NzVilHV0FG?=
 =?us-ascii?Q?OMNpcqPGaVaO5YYJk36ooiGN2FAMGnS0mn0UqZV2W6EgjSrFBdIpjgZfxL3p?=
 =?us-ascii?Q?VyABN04IDLFn5+aRzZUKXv2W0focwP/E6aSKGSjD0nhHUQnk4LO7LAPNHKjq?=
 =?us-ascii?Q?c+XUgyHI1quvAgb9ZS3+V0K9yfKoF5fL2DPek3pn69aX8muivKnlKQo9+Ekw?=
 =?us-ascii?Q?4zqEV+kttkfydp3PqbuRqQBRJYbAfrvFvXZLCXm7tAa6Q7alJBFUzHzQeHgv?=
 =?us-ascii?Q?Kuo7IEZiIuP6O3gRDfy/FqXDmot+vdRukmqegCh89VaKYgOjRy+nDtNamaPT?=
 =?us-ascii?Q?rVJuXXQSiPnCuCgslyMdd6x2iT6jdMLriQ1qKhwNEW17qpvGn8nJ05Hi6MrM?=
 =?us-ascii?Q?p686yuNGKCFpKOJXLYnQT30hnqqvLEB+0GSQoq2QcHS8HzTUsMUBDVKlC5Ft?=
 =?us-ascii?Q?i6oIPXWN5jYgN4g5F2vUsjTp+KwfBOYu7gNfFEQjkG4HEc5Lfypx3OGONZCR?=
 =?us-ascii?Q?u4mWfFDHv3KZhdYjcO7gDkY5spuAC4jsVMXc31UpQAzQN9g8W7QKHBYlq6AA?=
 =?us-ascii?Q?NUxadWeAZWDjO3+cuYfbpsqcYEHdDCZ1fIzYbgqvuOWqnBA/3KGt4y+TMGDP?=
 =?us-ascii?Q?NiiL/2nMcevuMnSka3WLQPaQGy3Zqw9sljn764nSCTA7TzYAjQMtj2G/GLmI?=
 =?us-ascii?Q?tNkXautbSRtgZsCh7+Zyi14DHbDJPUhwx0ukzbxDDpl1v5UKMQ2NBzPey+gF?=
 =?us-ascii?Q?N+bYBSy0Mkpp36sxWRPlbHVEOB3ftXzB4Qgh/0bTsMblHkJNBnsTSEYIqmGt?=
 =?us-ascii?Q?SN+K3fKQ0qxK1byfUlXRtrVGb+IUFu3D9tqswlmispMzzewfN//7w95acl2C?=
 =?us-ascii?Q?H6bBzr9W2PnI2fFYrI6J+vfqgQnKZPQM4hAtyk72HV3xqOzk+JqVHQYKcXfS?=
 =?us-ascii?Q?nr0TH1ySlyHYB4xhy3w4CBG6szFnTHKEgeXDFIfgv90536i+ghiLQ/mR/oNV?=
 =?us-ascii?Q?q9nn9L+O8F58zKbd1Ci8WBHcgTuXVJJVhLrm/k7hgCGfiuNZXldFV7Y8+N0M?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ae5fc287-4ed8-4a9c-eb56-08da95b33866
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 18:10:20.6799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eRDXPe32Qfts3OGrhXVQ4wdIYHC2JzeQK3cfYA0i5QHH+pWTMqEOL+NeRh+rRa1lj/2QtnjkD1FiIRcgCPcfIl2jsrBPhkwzKuxB2R5mMok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP190MB1789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds quirks for three FINISTAR sfp modules, which
report not all supported modes and thus must have some software fixups
to overcome the invalid EEPROM data.

FTLX8574D3BCL and FTLX1471D3BCL EEPROMs are missing supported
1000baseX_Full mode, while FTLF8536P4BCL's EEPROM doesn't
report both 1000baseX_Full and 10000baseSR_Full which it (module)
supports.

The patches are combined into a series to ease-out applying
(one of the commits is based on another one, to overcome the
merge conflicts in case if one of them gets applied, if sent
in separate).

Oleksandr Mazur (2):
  net: sfp: add quirk for FINISAR FTLX8574D3BCL and FTLX1471D3BCL SFP
    modules
  net: sfp: add quirk for FINISAR FTLF8536P4BCL SFP module

 drivers/net/phy/sfp-bus.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

-- 
2.17.1

