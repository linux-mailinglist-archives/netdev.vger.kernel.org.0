Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0BB5A131A
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 16:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241383AbiHYONe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 10:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241229AbiHYONR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 10:13:17 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2124.outbound.protection.outlook.com [40.107.220.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0753BB3B2B
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 07:12:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMTjZSawr8hpC1NRQl/PToXnm755aDVnSk88z3K2pTFj5tXLAU7sW4+1iigFjsehCfic86q41UlYjyr2eU6S/OD5WzPtKvIDEs2DSFdBDst8Dm5lSGB/NYTovNRcOara3+UeIzvZOj9ZYzWR3hd17jzc3KM9uSxPao2V/7ZkrgCD2178Tu2kJrEdMU1GsdyST7Fum7lUEWlM0fUPoxgfg8aE1NkF/oHse0wiLMeSMs9+pcPgzgxx3LQAqiBWYGqn4c9aFW3JiA4/6MZmHsmYfvJ/215OiTaVDYzhrIDTlxt9+GPn4GV+0ICPUEZ4HtIctkaqRWOSAjH48va24eCEew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TuJpa0lwLy9eMynAqRYN3RQvHA0E0TIBak/ZiV2PhJ8=;
 b=mhHzGsx9hAd5MX+MWzA2BmUXgpo8+0PhwiC9ZsOTyU98YpVR7T0T6lpjb4f+MW8dx9SDikXmw1HEUXMbkTzHJXSLFLTacY5SWnlBOpc0qZXfrOj2soZU+sjMAjDcgulraZxz++mAb2uBdy/yOK+DAbLFJzx7nKML5huyBw4e/n/Z7u4BZPimg2qHfTsjGQ2zYDJnOdLxIRmIEsEbFvOkBZZG2kuNVhFUkRoWYKWtmEQX4jrgBfpD88tFnOMcr1NFUIejcLucxXsZAivWzP58eFNcVqWOjzD5S3OOmlVH7cfHGuCCneV3lvhN5GwVYM+pSrla7Y/m6LbQP9ea6HkkdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TuJpa0lwLy9eMynAqRYN3RQvHA0E0TIBak/ZiV2PhJ8=;
 b=F3lyIRFtv7viJMLDWnTKSVW+qgVbZqz+nlHGPlRi+EcezcXaDPlBHPp7/oCN5zgAMWQHWcXykBhTDMALTFCWDWXWaUF8fmRjzzb5RCj7fY13643SUX/Yfxx0KWBG2P2I4ZvGaeMYe66VIXgAvZUiFRA1Iua8nufy8T3Tg8nm+m0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5401.namprd13.prod.outlook.com (2603:10b6:a03:424::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 14:12:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%8]) with mapi id 15.20.5566.014; Thu, 25 Aug 2022
 14:12:39 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 0/3] nfp: port speed and eeprom get/set updates
Date:   Thu, 25 Aug 2022 16:12:20 +0200
Message-Id: <20220825141223.22346-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0078.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d4ece8b-90c9-4f8e-0731-08da86a3de46
X-MS-TrafficTypeDiagnostic: SJ0PR13MB5401:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xGDwL4fTFPeFE2PkdmFfcS259bAUSn4lAIkuIUeF0yozELv0iqBp+rD9BfTUlD2A51lMOfhQnK9+QLZ1Jq8QQai8NgWyfIZeULWe6MClh0mAZj7SA9zRDoSuTeIl/TqbV2L6gU4QaOf4tcQWQEM/iU0IbKoW3rEGW83btOh1Y5HAmVwo5QCiTfveOTd7VMwcgxcW/wTwn8VT1VEI1bLtgnPCYbFFEOTlIMLkbe7ef+tvmv8q5xDW5rq90q6/fsGBSHPRkAB2zZ/m703vhaxF4BLlx5xdmg9g432UVW32yWgx5jeM3Ya9nny+bml48Ac2uc8M1aSt275Bj1gSvS6MxUb6E/JRQuPJze03hJ6vYcOphhyLNYY0z1qg2LrTndXbwIraB9hWSPMDTdlfgyur2t6V2eWQJR9hPSv/h6Tn4v1XPA159a6SS74oaezTHxu1RFoT/25xMrdQlBowGHoG08p5iE5/kV7qgsGBE8wiXHx81ogxPUBy43x8tLw1nMLbGbqIFowcbhTonG+e97m128LRlr+W6Hl7eSPBRcT5lTso06XWQupQxBVcsaRM4LLW6y6MKa9E/sYZPdf9NI5Z9DfrwvdNIsvYTQQguMfpwHk8Wp6zODMM4G9BbYwf+rBard2tdooBw1k+4APFovE5HYDcih5lK9H32apYb2R0XQC3VWJEPM8kFD5maBB7Y7xV+tZ3t8Dud7rAcAC+eu5YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(366004)(136003)(346002)(39840400004)(86362001)(83380400001)(38100700002)(8936002)(4326008)(66946007)(6486002)(478600001)(8676002)(66476007)(66556008)(52116002)(110136005)(316002)(44832011)(6666004)(1076003)(2906002)(6512007)(36756003)(5660300002)(107886003)(186003)(41300700001)(6506007)(15650500001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9j+buG42gSu7RIt+JhXBL19kj8yTaKNMUPa1scemCTg57gFpHU1idEsGVRfY?=
 =?us-ascii?Q?3SNSf4H//c+mOHAHcuMyZ5vY+2LW0LHsSmeG+J6vTwpBEXodVBiRksIa94SS?=
 =?us-ascii?Q?3VOMd9ikD/m3LLpRhT5MQVN5t1Z/P1AgPxYNYZtQl7fRAaolxM9ad6I01pxi?=
 =?us-ascii?Q?1vU+cXftG+VdT6MHzzL8Iipqvo58VNSTftSH1y87h6C0NcCQ2kfBT6m99o+l?=
 =?us-ascii?Q?FLV9wJigZjRlazfKno4L5+hEeVi08CUHuS0fzOQG7OJbg67zOENJcFSLuOb/?=
 =?us-ascii?Q?Kq7H+KardthDaDZTaqGwKXLFfUwJC+3b2ElczFV4ll7SqSsQ+IPJT7aRZzih?=
 =?us-ascii?Q?6bpY6c0QwAOc8vilhzPUAHUGsBBxhW6gRof0Mf6/liJLspCzfgxfUPBeWrgy?=
 =?us-ascii?Q?QFZhjdRsf4sduorRrvdxZu6Zi+xiPNlIyrsM0LfAV1aVCh3GcNec0YwGi89g?=
 =?us-ascii?Q?U3les2FWZ8ZVbxKu8veAD4n6Ui2jTRLgBDWehJxZfSMMIFyR+jwDLkW3z92/?=
 =?us-ascii?Q?pttCmbdfPA5w8FSg728Mj3hJE1MRUMIc+XdK7ZBjH7nWhii93d9WVFXapPcQ?=
 =?us-ascii?Q?xj1+9vMihA56hJjNyUegN/Q3XZPJy9hv3hxuydTko3Xmi03Ms+dpfBpQH2/I?=
 =?us-ascii?Q?Bkc9r24Bc4fVKIkI/6nA6Pw2iVSWfIuydwCtboiPhIxJFgR3xsEmqxX0zYuT?=
 =?us-ascii?Q?gGcm4YyeP9bMgDyQhReByJLgU178QkQH9iv7OyZjWf2VV2z6FSJY1Vx/UrW8?=
 =?us-ascii?Q?z2plp9T2AO7oNM0JnBREEEoPrKBCFtmS2e6Ocl01qV70pT/yWjDrzhgU6ZlY?=
 =?us-ascii?Q?ITOjPyokBHFZnAs+QrvXtQx08VGhJl3iRrM4fygj0LH10YLkD6YDY9f5xDZh?=
 =?us-ascii?Q?1432DnMYq/C1m6IgVuLQelCVG84YG2LJj/7FrLUxxQDiFciK0POOACdui9RH?=
 =?us-ascii?Q?osGJgcdZffbGKgxUdua70ugqi1f4OyM8GvjCjqJWDTpOLop4h616oOvTmYvH?=
 =?us-ascii?Q?uZXXtRLssOQ46NfLyrnw4LLbNYKp9rzc/OF8iPh0y2c7uCystjLJTVyZdteu?=
 =?us-ascii?Q?KDDLpmnNcaKcCBovs4fhyFiRiFN+g8Ndz97lZgHIRVsqFL0IqHiZMO1Ew/W7?=
 =?us-ascii?Q?jP4ljJx/kq6L9Fuh/mK7GnGHMiKtHvagEZBsMhG3me19WVkm1dLmQ9IAmny2?=
 =?us-ascii?Q?eyTXKDRKaJRB5cSx6NQBEm/MDK7D+0mqUo/QzHm8Oe87BNod1sT/hus3pl5+?=
 =?us-ascii?Q?VjKZDMbNHpoZ+tRppZtWW2blrQPuLMtyYmpGKb48PvpRQmYjEiAMfpTRvP2U?=
 =?us-ascii?Q?bdge635azS8W/6HjeamVWxUopRPAz08LylHj8ftMDybp7SZDuD5Qq9Zrp3LL?=
 =?us-ascii?Q?Rfwy6DSZcYaVMwQSoqTefU3dnze2nKJs60d7LfjkDC6G9SrvQ4/ac3yG9SQH?=
 =?us-ascii?Q?2/xR64ke4zt2DtlNthfJCvgB5ro9LvewViT6+FSdbtAhb/7lQYklcAJd8eCz?=
 =?us-ascii?Q?onzwsaDd4XG9LgW+4CqVu4KdptSlLNBajDN0TaMaICblLSVEYtOGDo05MlS4?=
 =?us-ascii?Q?IsdEvnan7cWtol+gy3tY4zSJtsGPP92/bGbbtikvA19N8NaDMuSKm2xrOHdp?=
 =?us-ascii?Q?ylVYDct0Wx51/tkYL4qS4BnD+TivasX6Iaj7wUyjh+YtDd1JFhXW0VK5DvAG?=
 =?us-ascii?Q?3cly9g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4ece8b-90c9-4f8e-0731-08da86a3de46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 14:12:39.6861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KyodOQkz6/D3B4syPttXFFA9UQHCFvKoy5TeMeyasCXDEqK2Hwx/ImdwyLEsFLGWzcSEzagkdsKcyC6qrXuvSsydgiyCFrXoK/V1rNE/bVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5401
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series is the initial updates for the NFP driver for the v6.1
Kernel. It covers two enhancements:

1. Patches 1/3 and 2/3:
   - Support cases where application firmware does not know port speeds
     a priori by relaying this information from the management firmware
     to the application firmware.

     This allows the existing mechanism, whereby the driver reports port
     speeds to user-space as provided by the application firmware, to work
     in this case.

2. Patch 2/3:
   - Add support for eeprom get and set command

Baowen Zheng (1):
  nfp: add support for eeprom get and set command

Yinjun Zhang (2):
  nfp: propagate port speed from management firmware
  nfp: check if application firmware is indifferent to port speed

 drivers/net/ethernet/netronome/nfp/nfp_main.h |   5 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |   9 +-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.c |   8 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  11 ++
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 187 ++++++++++++++++--
 .../net/ethernet/netronome/nfp/nfp_net_main.c |  98 ++++++++-
 drivers/net/ethernet/netronome/nfp/nfp_port.h |   2 +
 7 files changed, 295 insertions(+), 25 deletions(-)

-- 
2.30.2

