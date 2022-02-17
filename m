Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DFF4B9DC7
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiBQK5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:57:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbiBQK5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:57:30 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2125.outbound.protection.outlook.com [40.107.100.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE6815A32
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:57:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V17kPfgsa3dSD+PkaMjUdm0snYzaf8ilTSAk8Bhpi51tVMy/FNM5eJ/do8CwSZHHhuW3e8tyMX/YG/FgTTuFO39VYAFqKxeR481F0K2jrQBvW20aYiazsUFIYxJ/s4GUEo93xgeBNyyH9qpk9JG3/8QJpLhxZh3jw1bIeM5bOlId1C2J0oTMB+WhwBEsagKwFKTSHVp0MMmSFKMA6aIMgW5/68tAD9P6bVlJSlzdrAYrFq3otNUmaLlxamysxf4QuNJAoFti654lkEgQycLJHa3B4FBm7oACq6hgT7FWnQRb6SpUJSuf36xCZEBCx8Cs1tioMqjEbRRGsyBdVLGObQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09Pb0i2sANGoBA31UlBGyVxkwnl1mIJGHAWvwv6ox0I=;
 b=oTHlR6E0P0B/qM1hW2M2Wv12eD9z5Dc5NQ0R9r6Xn7ihJP4u512FI1KM6azUxqfRfsPkScGDjbzDSu/vLp/DYYPCzsHlkCtjCwbdsquHDIYwKpBYXVvyx34HdzKbKoN5RbcW/m/tzZwzZBvPiDnaU50n3K0raHmmFb0Do69zU7DNT87T1/AVbWF70iKIB5gN65VEMrZZWq2YPEpOoOV2B8pedeaiui8Q83lLlm1xksixLi2Afo3RMZ6WAfwtIWJjQAHm0v4vNsANH+hlkaFWlCvA+XJ16OedoLH56vz7cQ7ySbTP7WsenLakLOM9ocU11veSB2fPeYo064tkWoDwBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09Pb0i2sANGoBA31UlBGyVxkwnl1mIJGHAWvwv6ox0I=;
 b=T0JVal2plXbfnGFgUvdLMz5S+QZT1zN078NVY4im3yPPAPB5JREkCQ2ZUvd09KSK4mzxNEX/2dcDE3Je9pbFkLLIox09u0jkzTkrrQUQCsTGOHgOmRGe3wFO1v/68l/xoveP9BX2/pQpcgx514JhGOooRKEjTe/tQGpEUWTxt4U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1397.namprd13.prod.outlook.com (2603:10b6:903:136::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Thu, 17 Feb
 2022 10:57:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.015; Thu, 17 Feb 2022
 10:57:12 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 0/6] nfp: flow-independent tc action hardware offload
Date:   Thu, 17 Feb 2022 11:56:46 +0100
Message-Id: <20220217105652.14451-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0081.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca0a79e1-92ad-47ab-ef30-08d9f2044001
X-MS-TrafficTypeDiagnostic: CY4PR13MB1397:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1397B34CF87F1A3F536A05A8E8369@CY4PR13MB1397.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3QDXLjHRNTJtu62lTGtmQoMDS0in9UIx0lfWkmEcBFVE1HsI2Lg9SyCL/cG1jdrco6VYYP698kHkY89V1k7KlkjYz+TjbzukQLWkPos/Z4XSoi5lBekqfF9kJGfl9YL3FqmP0O/MIjEtpkwTH9SD95McSR1eutmu1SurTuGTAzSoQy0zZ6sakCOsmQibWRDQrnF5/CWTBXhJCHXgsEcUwNYtuf2eGcYy0vE0FkvtxbSdRq8M/COvJ4LD1i1qSprA55LNoEgryvF+EnFAO8rWTVk5SshSNKFKP9u9kkC5xNGGYZBGMMu9gtydSus3KxeXNpsD3nbkzYr7a9sf7wGazt1KHG7DmBB9Z2fF0sDNulcEaERbkTFY3sScGn781b2uinGQ+XlsDMnxnemuKyu1cVAAPLbUrmlwORewpg7GKZLx5+NGoWwATSeFIt3LtSlvS+YgG6FTLUKibNjcw7YZN50pzCsG6SAdQrC1c/s/MVsLy8OLaJjjmKmt9yUTQpcas8lODBISb95k5VPxMayyvLJVXmjizRQ6ip9jqfE59kjlqaswbZfWZl/nKYVs8Mev/sx/GH8l5koIyRtcvIIfmLM8PFjdy1s239aBG8paadtIrLwiprQmRHf6rBJDkWGqFbonraG66QLZl7c5tPz7Gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(39840400004)(136003)(396003)(376002)(366004)(8676002)(66476007)(316002)(1076003)(6666004)(6506007)(2616005)(54906003)(186003)(52116002)(38100700002)(6512007)(66946007)(66556008)(4326008)(86362001)(110136005)(6486002)(83380400001)(508600001)(107886003)(44832011)(36756003)(2906002)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R2blMHaoT1TEB7Kj7AatDNIHR3UkCFTmiv7BqzeVYGMWoF/AMiPoRmh2oOxx?=
 =?us-ascii?Q?Z3jmpEFiIh6Hyz0s2BzlezEuRZo5/smMQ4dYqjqTgJPp3IVLHhUBYdEiZM6P?=
 =?us-ascii?Q?Q/Iftp8Kz2Ph+oJPAk9jKeqLLzTit3/TknmJilZCezJMvuQ0lTN3Jot1DwVC?=
 =?us-ascii?Q?vapFTM7Ku22i8Tqzl7lIJ0K/0Y+ieNZ6aZBPOmgH07L/rsExB+gfkqEKUovZ?=
 =?us-ascii?Q?eOjIdBN5g7hF4IpdSfLr/gfcHBiactTQajGvEp+73qxQJp0iA9dVGwtv3No9?=
 =?us-ascii?Q?X3fNa2O24HmCrkAWNAppLouUaFRdyCMz8IgUpS9HPUNtw7h8mTbuOMpeEcN7?=
 =?us-ascii?Q?zSTARUqHkhDwl9u9DG7nkxieTdVNYp4z4HuE6qKUna5u5FebolZFhcoQjycf?=
 =?us-ascii?Q?x5luEbFqDaE9ui3k/CK1I5He4guTbofFkb9Bb8jqtjL7s11WeBNGZKncBtmX?=
 =?us-ascii?Q?T3jkdLVR1jNzkXl1FRwkudAZcILJg9qXyS6nFXieut6d+85EYMtpff0UvAgU?=
 =?us-ascii?Q?VKaX9sssS+8/dxRh1FWq3ra2MR4G0hrNJij/awu9ig0BLncxm7ZXuQrBJV8b?=
 =?us-ascii?Q?y6OVLdsVeG07s1QCsI19OikFKqSnie+dWJrec9LJL8Ke4OHJFbz7cPeFWHQi?=
 =?us-ascii?Q?V5YCDwJ982MPBDcn/lXGslY1GjTI/lLNh6uTDOj3ykq1Lo+rdfGvqIHhIlMl?=
 =?us-ascii?Q?kphO94oAN19vbqyAJbq9IAW2KHMh18fCSUvGXm3rxpbzU2WhVMAv4CBscPo+?=
 =?us-ascii?Q?LsXRBc2o12n6C0BeUsyyK/cEnrGmPaQl7ovMK4Mgjm7z24D0/ivMUKdaDbE/?=
 =?us-ascii?Q?yVG+/utgnS4INLKfjsbFbVM2+RdP/iM8GV+YIBKaAcoM3Oec7U4/h8ukYDNq?=
 =?us-ascii?Q?7K1WF9FapLpDW+VuXVCX9Yn2K8CIONQiqqHrSvHu3FmGDohKRhtZJPgQPqol?=
 =?us-ascii?Q?y21QOIFKEWOlfIxRq+j5A/gDH4qXsaIjQ3duxX/JKDei5f6pHBrjFWbmPyuM?=
 =?us-ascii?Q?/H7rCjdQ836tare5/gBJhNhAat1hzdJZhMC2Ouq9KvCH8UarSiPA81TZZdAo?=
 =?us-ascii?Q?B1PJ1t63TM+0J95dVzOPMleEGfOCjN7EMgGnF3ApGGzdDmD81vI3P6FdmVNf?=
 =?us-ascii?Q?hMcS7ST+AQNA45EEHFm2zIuHIugBDe6XAl4iz5ibuNpv5XVqyOqVmZCpJBMJ?=
 =?us-ascii?Q?5zsz8Cijehe4wyjbEbS4bytsfukPUgX1/c5P4CCw4bwT1slS0IfhxtQ15Hg1?=
 =?us-ascii?Q?DexrytiHgWwyhQW/q1oUadCGqYL+n9wy04Y7BnDnsQEiHNOUGnDTMi3+46SQ?=
 =?us-ascii?Q?SNcOhnd4+XisaV8OFtOHtZcB9gHfJh2x2T3YghV914N/qCJf09uDDIrOaFGh?=
 =?us-ascii?Q?uE6g0QNtU2apG/uTw4UnZermHdFMU1q46M6FUQXAOWpf6jLNzHjz3MW/LPlg?=
 =?us-ascii?Q?sOihCaMDmrxgreLpGwjE7AGVAQKqsiMrBnxZzCvSffhyQU+Ac+N81OIIHGKM?=
 =?us-ascii?Q?t8Xk4P6vw2Tt3LQHYWeU4Hip3IZFj3OUZ+r8LPq7czAwfFcGFkAlCmFTj9uo?=
 =?us-ascii?Q?Sye78hMI9KdvWolxVHXtAt5ON9Ody5PjhrSIHlGcRyFYXTyDt9kJZeynw3sN?=
 =?us-ascii?Q?osRQygW9trzWm3LND3Qx09klCH0o6v9krBFzKGhSPgR/JplRDQ4Ki8mBPmrZ?=
 =?us-ascii?Q?NBXk48Vvi+a8UYEMJww66f+EvUwDV6SkO8sU0KE/sPUPb90bCOgEHhm5SwvQ?=
 =?us-ascii?Q?y/gNIkK70VR0pGcvjf3i5t9IxRVmKBs=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca0a79e1-92ad-47ab-ef30-08d9f2044001
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 10:57:11.8545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WdFgpyw7/vmhV3LAiz8PS+wlNujPAg9XDMfnt5L80+BfpnV1Q0kd43RFvJbDpRVO2s8y0K1O5oOe4KHrvpBl8QWOnW3SSM479fqPrPPrIK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1397
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Baowen Zheng says:

Allow nfp NIC to offload tc actions independent of flows.

The motivation for this work is to offload tc actions independent of flows
for nfp NIC. We allow nfp driver to provide hardware offload of OVS
metering feature - which calls for policers that may be used by multiple
flows and whose lifecycle is independent of any flows that use them.

When nfp driver tries to offload a flow table using the independent action,
the driver will search if the action is already offloaded to the hardware.
If not, the flow table offload will fail.

When the nfp NIC successes to offload an action, the user can check
in_hw_count when dumping the tc action.

Tc cli command to offload and dump an action:

 # tc actions add action police rate 100mbit burst 10000k index 200 skip_sw

 # tc -s -d actions list action police

 total acts 1

      action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify
      overhead 0b linklayer ethernet
      ref 1 bind 0  installed 142 sec used 0 sec
      Action statistics:
      Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
      backlog 0b 0p requeues 0
      skip_sw in_hw in_hw_count 1
      used_hw_stats delayed

Baowen Zheng (6):
  nfp: refactor policer config to support ingress/egress meter
  nfp: add support to offload tc action to hardware
  nfp: add hash table to store meter table
  nfp: add process to get action stats from hardware
  nfp: add support to offload police action from flower table
  nfp: add NFP_FL_FEATS_QOS_METER to host features to enable meter
    offload

 .../ethernet/netronome/nfp/flower/action.c    |  58 +++
 .../net/ethernet/netronome/nfp/flower/cmsg.h  |   7 +
 .../net/ethernet/netronome/nfp/flower/main.h  |  50 +-
 .../ethernet/netronome/nfp/flower/offload.c   |  16 +-
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 440 +++++++++++++++++-
 5 files changed, 545 insertions(+), 26 deletions(-)

-- 
2.20.1

