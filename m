Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C2447A805
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 11:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhLTK4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 05:56:50 -0500
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:36832
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230027AbhLTK4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 05:56:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCdI8bK5cCLTFN7/HpA3PFg0z3EJ5XYFKs4DXyuoPXPfE/Aa8OwqbQjIgD9UmvAjHdQLH/EkRN3G68JjM+kBH+PlDD5koEkV/WlVqbC3bDGjbv0prPLZwN8AuIVj/HdtpiIhrxg5raFNZteSEjtRpB9AbgiFgB8SC6NxwBh44XdXEhQeQnkcQvGKwUbXWumT51WJBbdrmk+r4jT9x8UIIJWLUwZ2gHwLsTkLydj06hHZC81v2kr9qrKztwAxhyII4WSZEeC48csmg06zgdOQwFPj7+34D3rwOkVNd0GLaB5SNAOT8eGCXjko4eGvlPItvviHRavwlmkRuyF4PcaXcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ymtBskCge/qsHVCdnsoLKNjs9PbgUlySwt08VRuKO8=;
 b=dkry6XU1SY670z0nKHU7vCJ2TV8OmW9CrWS3m8ejrteMxDBhJUxmYY5g8g1PoKOwVJWfHUSarzMRa2sFNdaNcLV3w3oBHubarb6eYuIDFV60yYZ9ss4+KoGr2ZgO3h3QsCXgsqRcX5k9a5q9/kX451evOvNOUofqPBWDEhXz8n+YaqjgPJGcLKnQOBIx6nRq3+OcGc5cEHy1tWLBpfVVGd49cMqypcac7YQm8ek6HxA7gNiP0DnnRjpPxKYBC5L4bTjO9pAvgPaO1T9+L95eDR0kpM+q4TXuLWGaoF1b6ZO5c3rYNR2oRBHv6C7+62XJulEUtuS1NyzH2QU1X690+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ymtBskCge/qsHVCdnsoLKNjs9PbgUlySwt08VRuKO8=;
 b=Hu6qeQ2TGr7zG1JJ8aJ6JuIHPGFKUIfmbjqRIE+rifgAiG0zQqVLDtZS00hktkJLqWeiN4t9c7E+uzUDPMwOz6ufMrJLJDAJnGP1UaBbhyJ6mYFcsLxdMJ9NSfJX6d1pG0ZVYEgPjOjM8LsqSFvU6d5yz1p9I8Rn8t/43DMjttjC2BvPK5wQhp0fdfOqwPg3uxz3nyPg/zfkmENEkgdUf+4VacPvJGehtzIDZO/SnoVh1ARFJyjueAZwR3zBNfTWAAfzDoaieWIq5tu+r3w73f9HTltxRt/aPtNiSWR4jvEbKY0WA+h7CeuXfcQDvx1BU2Rb1k5EQB4bPKyNcSktIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB4760.namprd12.prod.outlook.com (2603:10b6:a03:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Mon, 20 Dec
 2021 10:56:48 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 10:56:48 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/4] mlxsw: devlink health reporter extensions
Date:   Mon, 20 Dec 2021 12:56:10 +0200
Message-Id: <20211220105614.68622-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0086.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3f::31) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23f50cfa-3410-4186-4928-08d9c3a76b7b
X-MS-TrafficTypeDiagnostic: BYAPR12MB4760:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB476021469D9E1C5BE45C67BDB27B9@BYAPR12MB4760.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GYM/yrih/bcDFhU42tR9XM0EV46+bs9ITNgfwq534YX/2li4fTTBVWLLRsPKIwAEyokz5cyJc6seu04Z8geU8JaVQNanLz9WLieuPljXBss5yE3tPzeEIRpRhNCuQtQ231KTjNoHgcg6y9CiVkM9oSfcu5ESjlSwcf5ZFeeKGEmfcmC8PxeI5nVyHXk9LOZzjX5ejo2wQbTqVpyxl4lR9bpPcN4YSBQsPBckv1dsaUFSUl2eAdd7aqQV/KzCaXbKPbTkEx0hetfHwzjlC4uXxUyd34zRfpq1iTw6KAJxFmuE8utcvBnK/mhDQDxWnP+c2UqGqyrWel8Zp4S2HI4zGQmlgzSBLUS2ZAnnrue8M9Y5PJvi4/l67XtUhtT+wncsyZofl36pFAy2vgUukOp4yzFbMGmaxFvpDPW68Iqd454ccBoWg22zIAQ8atiTc/36f/0rbNKOPyqk2WQgTeMZYXKQpOzJCZJ4woauxBa695nt6modMvtdd5KxUgtjkKGqcaVSxsvSXmtBpH25buDJNEoKg4HW5Bib64oS+oDkGHc0WaAlfv8pUOxTbrCRzMsD2oblmed/R2StkjccMCN0NTFrTJOwvyDoh9jnrcVEF7ZTyMfZoZkvR4JmDPan9PjnD/0LrCYaSVQqWULsZiuwtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(1076003)(4326008)(8936002)(107886003)(6916009)(66946007)(26005)(316002)(86362001)(38100700002)(66556008)(66476007)(6512007)(2906002)(6666004)(508600001)(8676002)(6486002)(2616005)(83380400001)(6506007)(5660300002)(36756003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nCvWztBGuOLT1UG2gtS9hNpIBDeH5GnPS/6hd2UIllkCHdb3QKOdNLbLu495?=
 =?us-ascii?Q?Us9Cn/BEArMSVzsEeG6JtFZHkJ+UwoD094+ykrA7B0y0O13ripclpVDoxDZa?=
 =?us-ascii?Q?iX69fJrj18hHxExR6WGo+F5IE8R3RyuP+UDjcNYtKf1YOn2F8zOe27EQwVw6?=
 =?us-ascii?Q?26Sdaz8JJz54fP8Q7R9h38U/OgCe+ULQNCcvkGCOqX5Mv3/9u0z1UTTW4lxN?=
 =?us-ascii?Q?wWeB+l+IA2UdG4CHQSWqMci6/14e10jNCIlinL4N7soZnjGeOzj4t+XGfOxr?=
 =?us-ascii?Q?TY4hB1guCTh9tqVYLsPlzUPNjfnsb0L/imfYL/5kj7lmnxsYvHt4r6kzByPs?=
 =?us-ascii?Q?CHl0o/VYLUS2JnhmUTgGuDtGhqL6pQpb5rlYuR+q79he5vKpBV7jVMDwLvES?=
 =?us-ascii?Q?Cr0BvTIX2YhDFZxf3dveS6gyhZ9yUCgdIQQ2j5n76WIZ1ZV3HAhZKnLoaWy1?=
 =?us-ascii?Q?mGoRZgl/2IY91HeQNlcBUigWhAFlWF15XhguQKFrpLM7Kcab7uoyoMkTjbzF?=
 =?us-ascii?Q?/c9RTCCbPfkK0bNoR1dxSJyAOvVzUld5/VGh8/Bj4rUrnH9FgQYOm8uRscAq?=
 =?us-ascii?Q?AaJbjy7prb894BnbGel1bMgnju8trvFymE6xqLDop3u5GXxIpMjNlj0wA8eP?=
 =?us-ascii?Q?XlAc1VJ/ShKgUNoBKKzSA0NsMy/lUCz+WOjkf8h1TxM1hg6khPGBAgb1SIOh?=
 =?us-ascii?Q?Fpb/g1s5CjX4lvMDcgCbsPExSvVQrgBgylF41UE4fdGYDPrtJ7vHWw7AGwfD?=
 =?us-ascii?Q?QlyyZf/m7E9tXhEPdJQSd2Hu5XjNaMi3gLVDd5kQckByMMHRZpSJLnp0hM9O?=
 =?us-ascii?Q?7sNn1+nOzou7CQfjH0qWuiNk38mSKwUeLQZaHpfqghvTgYWueDwmWlMMwc/D?=
 =?us-ascii?Q?230zWw0y4Xa5sIX+JlfpunG0keXoe9SxBcn+kmyI1z9BfIVQbdQcL0NovRTh?=
 =?us-ascii?Q?k+i+n4zhsofe7NOgD70TIqgiwFhxto42+Mfjp1OhQ0+6loBe4ty3h8ZC/8IW?=
 =?us-ascii?Q?80BY27xyk3Wn1j+sizIj1MZ38ROIB/AkBXkX12eJoNHkUXlq3+jMg5RtkAyK?=
 =?us-ascii?Q?OylF2tmQq4vtDHZjaXx0Yv88OnzZM7sbWqIfvwqNBQUrYkaOu61chzkE+dWW?=
 =?us-ascii?Q?6lH4wwOopzxlT3sLGYUNhlhJpXJbElY7k2n1o/xNFSA8++Q4gecQpfAmPrcb?=
 =?us-ascii?Q?MW1uKSSj+G7tvMglN172ObQvxAa6gGbcaoBWMoVQvUY0HGOKbZuaJlMLlcAn?=
 =?us-ascii?Q?1QMJTeBSiAYCJqAnwMDMgaY8K+KvcFdX80axgMzJKd60qng0topDbYeC81Sx?=
 =?us-ascii?Q?d0/6xMtXo/pboXLAyp0J2sfXkLpYysb3s5J6+7ae6iQA2EnY40eDMnTdqcRQ?=
 =?us-ascii?Q?TlxnzQ8pZmJl4VKIteNwXaGbfGNpNs8f1NiiQu6GIS9E/EtpkR8MwKloEgco?=
 =?us-ascii?Q?hm6v1a/roN7RjyI9HDVuEs/auxBOVQJ6G6SUF55nxp23gd7NGMGsZjar9dkZ?=
 =?us-ascii?Q?GaNqbSa68pOfLqbBimH3exnj2yRIDT/fsslYRE4mR5pjnRGIP3V4ytqP07XH?=
 =?us-ascii?Q?q3RK5Qgu69IQjCkLNEnfDDM+E674EpSOFykjJDkQnTJwBd4qlV6wTiNhTn6l?=
 =?us-ascii?Q?17UGXjLOimRTnZ7cB//Zp1g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f50cfa-3410-4186-4928-08d9c3a76b7b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 10:56:48.1707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 76ncADuTzB6pdDnRTAu9KUnFhNYiwk/KEqWdTrUcMpWrj9+BgLTCcEb+O7/2z2V4tBwYwJdj5MHsPk0eV37/9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4760
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset extends the devlink health reporter registered by mlxsw to
report new health events and their related parameters. These are meant
to aid in debugging hardware and firmware issues.

Patches #1-#2 are preparations.

Patch #3 adds the definitions of the new events and parameters.

Patch #4 extends the health reporter to report the new events and
parameters.

Danielle Ratson (4):
  mlxsw: Fix naming convention of MFDE fields
  mlxsw: core: Convert a series of if statements to switch case
  mlxsw: reg: Extend MFDE register with new events and parameters
  mlxsw: core: Extend devlink health reporter with new events and
    parameters

 drivers/net/ethernet/mellanox/mlxsw/core.c | 189 +++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/reg.h  | 124 ++++++++++++--
 2 files changed, 283 insertions(+), 30 deletions(-)

-- 
2.33.1

