Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF0960492F
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiJSO1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiJSO0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:26:45 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20714.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::714])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3CB17A02D
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 07:11:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLC9QRbDRKe9UhEoH3hOJ8FRnSZhZg+nwoYp+jA6jg8QhuJQr6Krw6Eqiow+Q0BnUuBeP+6t6J70SfLpEmWPUYZcgBW535XZv761lOd9L2bxqB/fRDG2ZzkvVDg3u4Z3kcLkn4ooTBT/JH9TcUibDGbJMgISZhb754TqazcKLn+iGweBLyp/nSEsN+Dm/40TjwN39ki2OC23Zk5J09LFyl8mD6I/r/R8Ps8fBFHBDdaat52ygw/tI8zn4RnvXRTcXpWfKCW7wOQB92tx0zIMuhiW5UIIqWWPPK0fvoOgB+49tmRKIqOsjSsPrT52PgkeeNSS4HL1W4IJ7XNXgJp/RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q4ICoY4aauXSeeYS/sm2CgMpnWiWYnSlTR3rQlxk7Tk=;
 b=FOwv+MZgSV5VvJ43WQZZsfYQGcgzsxs7p9AyEKx80UItXNfkppzaph6Bw4h/MxlPvuWkTkPjcfRVkVylF8pM03TTs35nRjDa03yZbKbJgWQiRdbqiRjvIQ7pal7vXMkFbBqLQClozJvRHhNBuwhkjbda89Y0yY7owLc9+SHtrEC9iYGDGmtZaDa6GsbOAA+DFXJiWLtgfljhLk/ZpRkshBuTvh0nW4xHGeElcOJzIfxGRKj9/TJ6YSwmgwvPW8uR2dYHLLvqwmbzyPmPDTJWFUgfBlrriFb5CGX1FFWEGk7z4QGoGIA1vQB2uk1g7SVsRDxbM1tAZmtKSMyMWw5Vtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q4ICoY4aauXSeeYS/sm2CgMpnWiWYnSlTR3rQlxk7Tk=;
 b=aKh0BOCtMLY0gLfLUB6xeAf3EXuOCrpy2MI/9IyBQzUL9W140aMQEVFsWWBayKzi00YyW86ac1X9av4Wwxn3bg1GKXUdDH2DHJW61xxoAZZnPeKRrDHhHjAXch8k8q01/hDA9QGwi7OzbvTfLQnMclhcj9kdRwIyXk/6FWjpc7M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4404.namprd13.prod.outlook.com (2603:10b6:208:1c9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.20; Wed, 19 Oct
 2022 14:10:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161%6]) with mapi id 15.20.5746.016; Wed, 19 Oct 2022
 14:10:18 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Peng Zhang <peng.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next 0/3] nfp: support VF multi-queues configuration
Date:   Wed, 19 Oct 2022 16:09:40 +0200
Message-Id: <20221019140943.18851-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0008.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4404:EE_
X-MS-Office365-Filtering-Correlation-Id: 84bc7631-21f5-499d-70ec-08dab1dba6d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kkijcg6nhVRSd6cMtsHxGKvuK+DMRRhZSeBbiPVxjIzRBbINvoCtnpk4bpEXT3YBTMlDh3Gt1ffbp+Cn7j3T6azuA2d3bhLT2KMKRKB53HuthYLRw7Ds3iF04WBaAi0nkiyUgGOhlbA9vJvB+WJx763i4itEZ6gMP92qeU9Vf/RH62JUNwYjA/QAYRYVDKWvK+98J4HRd0soZtMxirnjAwN9JDfGS5vt0nZPyJ+YL6rgey4HNk+RmnnBNcE1Ua/ES737FMv05xwB4hQIIVzEd07W/sNYVbufkSzRAPVc8AOVojYtphuPzP77fygYz4ZpUCWUeWx++xrGseR+i3pRqKM31bM63ofze8uMe6ZMTapuqhAKZKZpU6sYqrxfWaQw5hkT3AvXeIymI36yECifjjr9Yjapbk1VljMunpatB97Jm25RakMeeHi3nQuxJg+p2Y7Pxxnv1yLo7Hx5TQBtJWU41zpfoQA486QPtcZUPYdPgJbzu4rMx2aWGQpfAY9uRdaL6ZnuYJ8yRN158lYpWiGmK2WN06oPAQ6IYyUiO2NiUS4Hgw70uh6LXJnc3JNyJrHGm2ODkz0xS3aaOhE06bmaWok/+SDt5ds0tZmjxoGJOa7aYiiWxaS5sZ4nXjP+iWq3codifNub3vFx1rKURPQcqqDcPNZnIV6ogGSCIcJUKRJpgEM5eXscdnfnqOgM1F3xyeajoSpgcf6hi2vjpOEqHECyKSSTGCD5NStinEO6UTSHTMPW6JKK8CkwfarQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39830400003)(366004)(346002)(376002)(396003)(451199015)(1076003)(4326008)(66556008)(41300700001)(66476007)(7416002)(5660300002)(6506007)(2906002)(8936002)(52116002)(2616005)(6512007)(6666004)(107886003)(186003)(44832011)(86362001)(36756003)(8676002)(66946007)(6486002)(478600001)(110136005)(38100700002)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P+aWytosOnEh+U2JlTrJ8cNdQCK8SML5BXHPXvoXSjb33oWu3tKlC3po378n?=
 =?us-ascii?Q?+bYxiRbSmY9+WQ53+fQcXCBEmq2zK2nGPBHr2GBPXMv+5z/QlAdBr49EUd3o?=
 =?us-ascii?Q?LqyRYOzlLagQHqot6doQ/aEc9Wx0T5Cev2mlB6KL8nEEGVPfQ/OwvgGM+hGL?=
 =?us-ascii?Q?jZ2IyVWogdBubsjpQQTVkL5nPvyo8kzZtWgX6LpzZ8ZBOe/bB/jU6k/68hSO?=
 =?us-ascii?Q?0/RYDkV+3OJXue74/sCLFxIiJvCALiF6c3rA8GLp1dg4MEvJ6PyG8kF340od?=
 =?us-ascii?Q?S+zeWAppDc3sJcGO5FN3GNZCBunCAh6kXr1ENIQXf23m8Td1pQvC5lz5uFC0?=
 =?us-ascii?Q?iTDneiEFUxSwpgKr66G2WLuM78UzGPF4WBoJrzzK2CHi5LAi7LSMyMkCjQqt?=
 =?us-ascii?Q?C9rqD1X9ysD08YfNX/PrWJuUg6EZYuhYXjugdCQbG8If4P3ZFm88DTje0O+v?=
 =?us-ascii?Q?DVD+QQ0h7gZYVutUsiWClvsCey7ZRHYr94AHEmwuKDhCAU6wONaaQRa9pmqP?=
 =?us-ascii?Q?nbwia+fFZ3mjA/JZR6+QdlA5Xatu4q2dSipefhIA2o9p3+c0tI0VZjt3QMI3?=
 =?us-ascii?Q?ejWYeToItewXlvDEUOnMZPsa82wdiBgD8suxGVvjpW8d18kakbqTDCntYlQX?=
 =?us-ascii?Q?b9Gys6YpGDU6BhQznoFlVp0jeqMwwoY1rmNWAfzn/YE+8+ItGMNNe2AoKFK+?=
 =?us-ascii?Q?evHGe1ZnGtqd2XaGyu8NY3IwfwgsYyBKTJz9DmAgy+o3DCebgAm5PMKagqwl?=
 =?us-ascii?Q?wzP1ShLQoUzxWFUxD1bKCMy68ygAjjshvfF3rzgG2abwnwntHWsafm5IqJ1P?=
 =?us-ascii?Q?eeHh3E5+GeEYzIRrvENWrDdrXvcESFzif4RI7YuWiNtr4KixnrJRUdPoKY0q?=
 =?us-ascii?Q?k8RxyIfoHe7BmH9vi44fnifjBSP/SNvS881mg2V7Pba6yypN6LXWyomCkwS3?=
 =?us-ascii?Q?ljNVd34Yop94KbqbDtz6P18V4vX5G08C+Hp3BsKlx1K+feIG5UIVRIsmGxAH?=
 =?us-ascii?Q?IKBLy6Nz+UPUzifYzPNc0b1pcEvy7Ipoq1qH20xULL+ZTdH02I4eX1cbkp3e?=
 =?us-ascii?Q?USZowa1pEVyKdLqJE6ldWkl3+GruDu8mBa7tvzel2TGcDmUpN+PEI2GgJPY+?=
 =?us-ascii?Q?E9I2K4jnaRMkI4uWNIrBoPCkQStN/n9KaH0+maxpuar9Kvw3to1ZoXfjb/Gv?=
 =?us-ascii?Q?sWbYOFc3J1fjrU/OCBk0rYAHXkOLuN+74smZhn5+Bktbilj+6Vw1j/uwMPbG?=
 =?us-ascii?Q?X1RuyENu0U6DosI9snHWrSsl9kyOxebxalHlu9ylbM7wTcRDkb5zidW1JTLz?=
 =?us-ascii?Q?13cXQuUf3R8g4We20LmzsxR8FsBjWXt+xybfJRa3Ipj+c48dgh8bL5Mbqa5D?=
 =?us-ascii?Q?NE++2ekd+ME4pCId9mL+ovLs7rVSL1nELwUFg4+l+dwfiLrTPVOvXjpsm4Zn?=
 =?us-ascii?Q?puGQbp9PV5tyYmChgcYPZ8NFAXDbLCu8uvSJ+n5+tfA53/BujFtqNYm5NuEf?=
 =?us-ascii?Q?vW1he7KKyp8I82GYn8i1tlND3WvdmhckVoBU/EYD+V1Ti1oOFZWn4H9kygjQ?=
 =?us-ascii?Q?qIgRfpVleGBeaUOAMNcED6s44ZxoJJyFNmYFfVJda0HdJo8LULRsZfxbEtsB?=
 =?us-ascii?Q?JN99h2Mszwp0zWW3J+q1sm0Wp9Q6KgouuktKOnSpnvV06UI5FRLLHNJYlFuq?=
 =?us-ascii?Q?C7FNdA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84bc7631-21f5-499d-70ec-08dab1dba6d4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 14:10:18.4365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rTzzVi8ZsDFvFilOQXGphDR6YHCDZOpSyxwQe1GjPc/gW0lXU0u+pQbKeMnTIweDvJa2UOknaMG/cI40DyGJUSIJli3x0NwAFUVoF0BcfdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4404
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series adds the max_vf_queue generic devlink device parameter,
the intention of this is to allow configuration of the number of queues
associated with VFs, and facilitates having VFs with different queue
counts.

The series also adds support for multi-queue VFs to the nfp driver
and support for the max_vf_queue feature described above.

Diana Wang (1):
  nfp: support VF multi-queues configuration

Peng Zhang (2):
  devlink: Add new "max_vf_queue" generic device param
  nfp: devlink: add the devlink parameter "max_vf_queue" support

 .../networking/devlink/devlink-params.rst     |   5 +
 Documentation/networking/devlink/nfp.rst      |   2 +
 .../ethernet/netronome/nfp/devlink_param.c    | 114 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_main.c |   6 +
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  13 ++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   1 +
 .../net/ethernet/netronome/nfp/nfp_net_main.c |   3 +
 .../ethernet/netronome/nfp/nfp_net_sriov.c    | 101 ++++++++++++++++
 .../ethernet/netronome/nfp/nfp_net_sriov.h    |   3 +
 include/net/devlink.h                         |   4 +
 net/core/devlink.c                            |   5 +
 11 files changed, 257 insertions(+)

-- 
2.30.2

