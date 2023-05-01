Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37366F327A
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbjEAPIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjEAPIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:08:06 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2093.outbound.protection.outlook.com [40.107.243.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0806185
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 08:08:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWp/C+5/pSwpvqSCaaqRBtQdwD7XPbg48siPaPe6uOfZD54ed2ZaERdAPRJoktfNet57RVN3Tk1BV9qtSjZIKin2eXJEHH+YzxnOmCF+RN8DCxheIv1fXNglRKSqQ9tJ0e23n2ZE1JFQRSBFkmQxWUt2fYF8sGxDHwxMl5L1rFtsCChtpngmIjeF+b54/MUii0PvfcnLnUGYOvLkQV9nUQFJYVWuFqa6UJ57Ah2wlj7RaJE0WqlDTrHCPjKrR442rAZ4jrsrm7U9i4f1vvJYA8nUzkMcpgscVm0JrhfV2fQgS6blEkv1GwAQ7Ejk2QjTGk8jMy50Sq6FlZiHSgc5lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kPGzvtNRsJWVKaah+YvqvjsNObMU5Y41zukrctKD0M=;
 b=QrsJ+yLjNuS/c7rSrJDkrr/wzJ+njqOL/Vrhpo3R8fgrsioQza74dv5ccD9NLEVxxtJ1oI49NaM4fLa2cwC5fKKH7DxQVE5Qm9lwARZ1jUKhfUwyROdbkXUAgKG+Y6gcYWANhhaCrvVEtf2jnYdolITtUazVVcAIypirRyxdZczqrwu+FFUPPuOw7ERO05w1vRo4R+6esJ5N7yzEyBvSH4pBrbMZQeCf3r5blwxnwHKUtrmkGPKMDmyj0/Q4czY+clUqeQX4X9IW9x/yrh6wkcokKV3YzoNNgWambW5UQiHTS/saAee8vHhojHoZnt8av0u5dyYMzCfNvgwXKnfhDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kPGzvtNRsJWVKaah+YvqvjsNObMU5Y41zukrctKD0M=;
 b=AzHxMEnZIxuv2GTcYWxdQ7s2CSfTVadzJhjCnMIbE87UxOrKSE9jaGl8fyJnbGq65RvLrKXRozJ31vOJdeA5NjoL+7MUnysaeJLa4TRApq2KA+1hd48ShyAKeFTkMXY0i+QH+EdDOvP0FRXLZ5AGDSUyszfGEt+pXDQ/SkaHPOI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3907.namprd13.prod.outlook.com (2603:10b6:5:2a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 15:08:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:08:03 +0000
Date:   Mon, 1 May 2023 17:07:57 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH v4 virtio 06/10] pds_vdpa: virtio bar setup for vdpa
Message-ID: <ZE/Vze62wTo57E+s@corigine.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-7-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425212602.1157-7-shannon.nelson@amd.com>
X-ClientProxiedBy: AM0PR02CA0081.eurprd02.prod.outlook.com
 (2603:10a6:208:154::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3907:EE_
X-MS-Office365-Filtering-Correlation-Id: 4284f3f1-d0b0-42fc-b6de-08db4a55dc28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xAOb7uo+A1E2Gsf3nqXp8ozUDWIAm5rVVvSbGo80Wph9UfpU6oFFh/GP8/SuMoPWPJ7dRBqB9Nfm9cYH50mdQnDJqfpGSg1y/93LjnSZEowyFh8FlvmzOzV6+Pn660V4+jAtHv+LvtwRAqbpkjiEUFe8gz39Sx9I2piw3lcMkJEYrdqsxP4NKgFvtf7oqzYxBpQ8SAGLVmM3IcadEfvjdm84nzpwEp9d6sainU4mHdOZdKxqcDH+qxExun3z0r/Le4fA0s3bM59tUKi4ASZcvVCmT03vSJJUHLzbA8FjnoE4VfLUFnG6cHfrmMqrqhCp8y1uz2BmUY4sKG9oYeELH4p9SrA3iThmhMZNNfUrTOHpdS/bROnMRiMaNYYoAXPwzWoo8h9NLOwcmtjGXtyog7HHO+jgh7KMg+qTqv+7p7L1ofScViUM6uTP8N48t9rLZQ60aAAqqz2mtvwrgUBkNaNzWykPtg9U42Sn30FtYHTzjxbhpk/JB0TPg5WRy2S38nyogUEF+LGUChstUMEpwmWi6CCfDJqa1fP4WGpA4pZK8PIZtrxjw9Tv0dcCxjzzbb07BtnkrSZ7QqRLm7i6uQ3u4obmv7XyHW6s9L70Mjk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(376002)(396003)(136003)(346002)(451199021)(558084003)(86362001)(36756003)(478600001)(6486002)(41300700001)(6666004)(8936002)(8676002)(38100700002)(4326008)(6916009)(66556008)(316002)(66946007)(66476007)(2616005)(6506007)(186003)(6512007)(44832011)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y0kkac3FiKcwrknv945ZJj8d3BGFhiF0cmJN5ulCJfVrf9cHFYNnHS1PhVzC?=
 =?us-ascii?Q?TBtCc4LGQH+2MuKT8UwjYli7ZpnXdmaEfgnXDgl5uBJ0pImG+sMOvw8EGA84?=
 =?us-ascii?Q?O1YweNBA6CrM2s2bOkeyc80zm5bRlwaKPD7R40jaJ6SMeqdS3SKKLMP0qQSA?=
 =?us-ascii?Q?elu9P+EOKcjn0LJme8jn1d0yUKglSf259KxldLHfLtrUrIvycsl6ZOV3hmJI?=
 =?us-ascii?Q?AnY8l0MYlGhLvaN1qdEwtzk2Y4UfXMUW47A6DXH/NDZUriH7Sq658+iJFG0b?=
 =?us-ascii?Q?XIRVozGdroIRz63dJCuHKV0Q3dTpcM6OaJ+9B3Jq/pMtqwwhs4f7inxaC2wL?=
 =?us-ascii?Q?G56ACd8kqvntIUZ6HaWI9m62H3ScXDYXHOgYOg5F76iQwAiLMupXhGl6bMJM?=
 =?us-ascii?Q?tqxpW4+wOPpxuVUGQ0pAhqyBfcTzCwr5IwVJBNdxVoviGcN/FrAwONXPvZC5?=
 =?us-ascii?Q?l+KOtvmwdPI/qe32wTLEQJHENY6ok+uxvHUquyTnVEZYOyt4pkZ3qSOko9+v?=
 =?us-ascii?Q?2xdBt3TXDThHMHBErS3jaPydAZ6l4S4oLQqkaOURnbSXmAn+svxSUnB+6qL7?=
 =?us-ascii?Q?uonPFDsI0AjHO9a7wyTFAZAtqgN/ztwUWEx+i3bU27q6Gt++AHbXBn1rY5Ei?=
 =?us-ascii?Q?D17fUrL7q7YybpZPHTqCJ0TUdqpRw+ZankfGq6IZ0zW6elKEc9Xk6XjwRce3?=
 =?us-ascii?Q?x56yRCMdMbnpmcUDM4p2l7cCkjPzBZwWsjxA3bVPlxCwYfoedskt0S3m6hxC?=
 =?us-ascii?Q?gMQTDfj8n4w7dhKAH5pbszLba1kU8C2v2j4ql0cgbYzESVetnuBczgrSiYJ3?=
 =?us-ascii?Q?SxWxPD6VQU0xNZfgHDNSx1mS0lssC7qcdglxpOBS3RDnF2RltUTmxOLpmkAr?=
 =?us-ascii?Q?WeEhL4mSnm/07PcvRkgWBDjplmkYgw7KwzeOcTuSdj/y6Yg9utHI8dxfnYLa?=
 =?us-ascii?Q?SAOh7G0RJbL9Pb6o2J4GvFdqZiA0gBAiFjczd965csX80audjfbLnwS5/+5u?=
 =?us-ascii?Q?+yhP4/JX4LIPquMbdpisFL1Mc4NvYgfKQFMEZbMd7WqkLOApW6lqWiWCU7Tg?=
 =?us-ascii?Q?hLNFT+PWSa+RLfH9ePvK8h4yf//7mfxvu+z2c5kPwIiaMgbwrJqNh4WPKW8Z?=
 =?us-ascii?Q?ZzzeQSd7DMxITcuqpGxPgUfZlSTPi9eYKXqlR1UsMeTxuSSxmHjJheKVFjgT?=
 =?us-ascii?Q?l1XoB9HB9dDjZl6bfaGU3DYPxic2mLwYFV/gnLEIe+V0gvHsss8YoR482pCd?=
 =?us-ascii?Q?+fluc57HjF1gKjEarP8Uew2Pj/HYlaZTYEL0XEOaFc6BGblPjMypFyhOG4HB?=
 =?us-ascii?Q?nzhP7HFSWqh2qsASx56yTf/jtjQ53s3AIaJlCFsGGKLSV6e5A7M2UtKmpHNf?=
 =?us-ascii?Q?kbp2T70WXw5Zbsa/I7SWJw41ocDMkHLmhcT+eHsfN8TFSLWBIpNkBzvXWwe+?=
 =?us-ascii?Q?ZLdfA0j6Au3sbxwDzwGulr50SIBz3657h96vRiVSzW56XtrcMp8b7SmHTG/W?=
 =?us-ascii?Q?FPQvtgXkJcO1xIiqNsRqaFlHrdPYYK6suK6O/UpdhAxWF9i3C8cL1RVmoTBj?=
 =?us-ascii?Q?tZZSkiIjU8xFDAhRT9KusaIdXIhGpTKsIGbLyTOKQMXfQFJ0/mEctog0nN7u?=
 =?us-ascii?Q?GKS82X59cOiAMXexs+xJi6lYyse7qGWRELyzyrnD5NpOjERQaKiwpR0mBXgN?=
 =?us-ascii?Q?Te0oBw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4284f3f1-d0b0-42fc-b6de-08db4a55dc28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 15:08:03.1329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BYnUowsDpULFkuo63oTmViOtql7deLK+rNeBGtjLPdDUTUwLBgBqVzFHCq8BT85CMewidb1XkrysgjEpoRFdLrsx+URU2lcurW3OWtphPAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3907
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 02:25:58PM -0700, Shannon Nelson wrote:
> Prep and use the "modern" virtio bar utilities to get our
> virtio config space ready.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
