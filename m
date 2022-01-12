Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D30848CAC1
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356116AbiALSN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:13:26 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:31249 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356099AbiALSNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:13:10 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6jBh020242;
        Wed, 12 Jan 2022 13:12:56 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg5xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 13:12:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IF/mGvVtAyWiEwwA2Ms/WaUgJWP1EZ3Cdz0j79PW68lZw+WjwZhjJXBXLo6NIsDeZUjwxr8m4f869S4Gu9ye3qnPYs96ZMDypteAlD3kDJUTLh91pMOxm6qOAwcniaLu00jXJjf9lXtO4z5yGYXDziz/U69GJFpUK4IV2vPig5q4iHz3e3jo66g6iKJBSO1T5PnXEFBWnSgME2mK2ALD5MVmSU2oX0sLrE0S0YA4Etvu2xrNdxtn3zUIs+wj7ehNx8AfkLPmRRpilvTUDyb5koGwHd89vGSHkg7MvPhBOFQEW/Kmtua4biU6Pk1nvToargY+rSEbHCtp/outUxJI2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4Kb+saHsl5nhQCVWvLxud2oStYyT5M4MzU5rhR5KjA=;
 b=kEx9N4NQsiTPi/h6UZricGbKuHY82kb6LGMkBWRmvL2xZzHDfC7psxMA3hhvu1zejeLkBe5Ss/Xp4OvBxXeSaaq5u28vSRb1oMvVlxi7Pv2nZiTez7PFPDHMUt4VeyBoVRyDBToUuu+TeYfSaraoEs/3kOyBkH7jrAjcb+bMgXV6oGEIkmQT29djpsoegtRqFyyQnVz/Dd9SM2E0049yUOdKiQQMqraSVGWdBCn+78L7MvjmMA+5AmKgeAgTzDmQalVB6dHulXmYMRXlRrQHccxL2Ju/fDPjo1yY8I3L7bV7e1Kq9Gkz56Vt1OAsDEV/MtYeJjEUuRWPEmyS9UfTFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4Kb+saHsl5nhQCVWvLxud2oStYyT5M4MzU5rhR5KjA=;
 b=Y4LtUncne4IbDAiZqiJD7EcltJzq7XubdQwj3xEUpUWIdsNdG53jym8bSDbrSMk6sLV9gcZue2RY07pH1r/+jWQojYytTAJh5WSHH3J/mJa5v2t9mbPqBvvDq8yptzv+aom9C5XK7Z6KpP5UHo0arYEmuUIY0UapvWKwyFgQcp4=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT1PR01MB3516.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 12 Jan
 2022 18:12:54 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 18:12:54 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 0/3] Cadence MACB/GEM support for ZynqMP SGMII
Date:   Wed, 12 Jan 2022 12:11:10 -0600
Message-Id: <20220112181113.875567-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0092.namprd05.prod.outlook.com
 (2603:10b6:104:1::18) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebd646a7-d471-4bb1-feb0-08d9d5f7270d
X-MS-TrafficTypeDiagnostic: YT1PR01MB3516:EE_
X-Microsoft-Antispam-PRVS: <YT1PR01MB35169781BABBBE2A232F31BAEC529@YT1PR01MB3516.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rouDoZD8Ct6ay5kmb4Y4PdSnixRiJgqOUF0310pxXuun7afpCLIwAI+f+N2sCoj3tgnnNCL+FrSBmHs79pNYeEdXzciwpUEgGXh7lA/HnczUPIy2W60R3xKVqeA00mpBB5T/PXMEfLsmv7R8n+6f8PQmc/M1fRjNAsXcUcJWS3Z/3idiQPkydSH8oclJp6e/K7PZdivIs0uqB6EzN9hNV/Y4UcRSm1oRLtFF+pMnoMW6u2jwCY2S/aIEt2gpA1QlowLqAR47Aoy0y+k9SIrJPXISq66QMcMq4Aovw4LTLc+syMHxGhUiuSmqgQD8uDlWK16IRPFigKxmNTMRedeoVMD8oQ47XRzbdumVwMPe89zvkleJooRGac/IOyVFyTMiuiehLhEfrznWdfd7t+2HubbvsBtkxm49P8T/oDdLBkKSCO4Ve7DrhxFSR9c4BdJoQQ4BX8iQKD9o/ly9PponbnhlHGOrcikU29W9GwxijmvQW+LJpKE3COpDqE948S/cENL9+ZFb0rN4yUNgVCZlrJSuVJcYdztH2TTvMNu67FnivyqTArOpprXyzIrj24TyEb9QcRUHfMeT6TqZ291UeiH0+65gp4Y1/XubWAmh+Q1eRHybw1Qr87Awk7XausTJeGRtsiIkQLkLAC3/A/hZINFewCn4H+oElYIUWeH3K+FSks/Dyc89GbzKVZdFlX651TtqFw4YfmdDdgdHwS63uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(44832011)(186003)(8936002)(38350700002)(6512007)(38100700002)(8676002)(66946007)(4326008)(2906002)(2616005)(107886003)(26005)(6916009)(83380400001)(508600001)(1076003)(86362001)(4744005)(5660300002)(66556008)(66476007)(52116002)(36756003)(6506007)(6486002)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lkKvzQO2OBeIBxmWvrjIJho+AJoMOBEboz1Ljx1kYk+DVP8hrmYOdpGfXCC+?=
 =?us-ascii?Q?lTWlfi42b/dmX/qLkYWBBpagjSJSwowrTS7N4uQmmHMh5ibG7z7YUmjCLelf?=
 =?us-ascii?Q?wj+ukRXTdOdNTYNGrYCva11v0NZ9EJCcu4QV7MkhVC+4VV8GQJ3+0YyCeZ6l?=
 =?us-ascii?Q?i97aXqy2Fc40umVtCvlUaZDdU6jLl7tbNXw1ZK96IXCXTlBXCETr9xlhg2SS?=
 =?us-ascii?Q?gePOcgfqPQozeUzKkCNVHTcQF/lWRhh1Z1Q2xw6hOkOUGllwVqMLmX7ff6tM?=
 =?us-ascii?Q?5RM8ABQBqk2TXulJRu7yLBska6yWKYNy1xOelKiVHSQ2R9j64MnpaDF39LoN?=
 =?us-ascii?Q?TuDF4d5FKJka8NKYjrI46U4tWO3i9Rmt2747y3ol5WGbok/6CeOJjGhEcoNv?=
 =?us-ascii?Q?SdbYj4HdZoFy7ndC068SXgSPFabOWPCT8nd+I4nNv3gsaB+2K+WRAMheE0sj?=
 =?us-ascii?Q?de+N1VYshxPN5hy9bpJAdG0dje//JyOy3H+XUSZschmq/MZ3nVwvM1/PUFHM?=
 =?us-ascii?Q?nLbONypUQKXcbeCcrp9fAU0dj74mRHxmwqY074ZK8We9RavVY0i/aKdVQlSK?=
 =?us-ascii?Q?xd3v6IDWMZExA0IOsrVkTdfgZqgsjG9d0Q960nuxT722kP4dpOnAFD8KZDnf?=
 =?us-ascii?Q?pABahdxcr+Y9DgzwsYwglI4NX4zszwvqG2IXTrtfJo98KTMCSGu15dtmJWR0?=
 =?us-ascii?Q?tt9HSyUr4Za9GQwBzi0fxsyR9iwGNiQQWGXgzsXqQZRkmqmx5t8Re1zn2LvP?=
 =?us-ascii?Q?J2Xoit9UKwWlVJwbt1+N3yUHsshcgbhRyJwVzYXtqYCrdl9UF8KRCGmVHsE3?=
 =?us-ascii?Q?BrdEJ/x6cZ24hgdUn3Z9Atd93eFzR4INE/81GFXykuHEEexcRA6zG53LpCV4?=
 =?us-ascii?Q?ZULOA4m9Pr5CX1Dh3VRUbzCS34q+aGMhJMzIsoE/64R4LHJ3hhlmFSBjL0n8?=
 =?us-ascii?Q?p7C0cIlnU86ci7uRZQWxodPUWyxmSl4VRxRfVT3wAYyeFFhBGJe1SXzltn0f?=
 =?us-ascii?Q?OmX1qXQ0+lV64JjFf3j0SnmChhzCp16Ko4bzTW0ntgzm/qKLl0ef9Dnj4tIv?=
 =?us-ascii?Q?tUGS5MTtlKyorvSZKzudJdaD89GzBxpcuqEWiHQzTetlWsPVPJ71ChQEBhWY?=
 =?us-ascii?Q?NrfMf/msPBmiI/13HA8xoap0Txp/uHyMhQiwpTjq62N1fjFISuWcM1X7RVzK?=
 =?us-ascii?Q?gi3DuVRjE+YEfexBEcwM1QTsJmUTL/TBnThcr2RDkT5TmUv7YwzyQFnu4PhQ?=
 =?us-ascii?Q?9//rX6EB2fY2tUqee98b+8oQEncGvG3l2A54fymEbMGsSYk+w9CgqEKRRzMH?=
 =?us-ascii?Q?oAELBlkrm8SeJXckZUeU2nBJ8QyAtNNrR53rSIaABc4HDxfNsTNX5K42Z0H4?=
 =?us-ascii?Q?rzGcuX51uLD39y4hQ5RI1tOL7pbymwCJW9Qxw+bp6Jzw6Mru+beq7dwGHa/7?=
 =?us-ascii?Q?uYB3/ZgjC4zraAJ0ialGmSkU9zSl+zzkzb8JsRn+IR0WwPpUqTSPoYHnNAX7?=
 =?us-ascii?Q?6RU905JK0i+m2unv4pGDe55n+ijoxIdF8rhk87Kj1GakU2IAgCp7HemBueEG?=
 =?us-ascii?Q?v5EhQxGDHyWpflpl/u/7tJg1cfBIxCWpVJzncR+CE2cJdBPAXi95JHDKEtje?=
 =?us-ascii?Q?eqYco0uQDN6ypTjBg2vQpmdTitehlQj7PtHjdZGDgZE+qAFOXKvfpvA9DAZA?=
 =?us-ascii?Q?HVxuXKY2XGfWaSrWOkWxUpyVtkI=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd646a7-d471-4bb1-feb0-08d9d5f7270d
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 18:12:54.3211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9iVadMxxiHuOiYNAzkwrATOgA2DdUaaSCmpsgRFEAbHp4Rroa8lUlMk/bhLZhU5kAPaHR/qtAXgMYmoeYtp3iSUN3C8kLnuZSbY7okqWtzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3516
X-Proofpoint-GUID: 6iHnKYnFIOhE10MMJMa-aq0wNsXizSNU
X-Proofpoint-ORIG-GUID: 6iHnKYnFIOhE10MMJMa-aq0wNsXizSNU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=576 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes to allow SGMII mode to work properly in the GEM driver on the
Xilinx ZynqMP platform.

Robert Hancock (3):
  macb: bindings doc: added generic PHY and reset mappings for ZynqMP
  net: macb: Added ZynqMP-specific initialization
  arm64: dts: zynqmp: Added GEM reset definitions

 .../devicetree/bindings/net/macb.txt          | 33 +++++++++++++
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi        |  8 ++++
 drivers/net/ethernet/cadence/macb_main.c      | 47 ++++++++++++++++++-
 3 files changed, 87 insertions(+), 1 deletion(-)

-- 
2.31.1

