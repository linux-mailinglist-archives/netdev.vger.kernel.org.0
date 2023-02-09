Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F78690E8D
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjBIQnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBIQnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:43:24 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2117.outbound.protection.outlook.com [40.107.244.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD1C5D1F3
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 08:43:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORtiuf9iWraf3531OH4bHdPYo3NkuzWrYNl32S5PHnhJpcPbFz0RV68S+Y3VKlc2jO7wCuUkQ/xxTsxbSPKXVkWAlzaKo51QnyLQUgfC2qchx5iTetc+Z0pD6vC8kPMyPJDBr4j+qqA/v6hpqZ6EHNN8aXaP9uZLZs9SUnIuwsE2mkQCqoEaz9nFTdjZkzmmGINGGgEPsYsIKwW+btgzVeWBn/FbsNLZWAVCH5E0QmUkF1voS7WGcjfZsLABk2oX9fet9INcVRkPRakN4tB56zURNrB+gnPDaeWJGxexs4Do/eRFsqOEw0tu5aHT3B6Mmf8yGawtxhO3x70y4Mbllw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbQ3KjtAEvChJgSHCuVJFEnkS9HRLat+5ZgWCFbBcCg=;
 b=KES4JkuP5CD9Uojl8QDU4twSw9EpTrrVrs86WTQPzDoFVpybXuN8xiu2c5euPcBD2MpZyd+3q3Ea7g0FRZG7psFHerpSod9qg2HImCyMgiF8Nza3lwpuD7NJTy83RrCDrsSbp0FupEeJxic4aVAyouf2+WLyNXkMS1psEyt6RMeDmmUzXQtlCIREpG/qTTQJlb5714Mj4M2wrWqBGC3t53Cc1bdkyqPgm+F0PVxzMaMaFTWJHapFXP0BN9U3NImbQClCacdk/SDZy/CncXFsYUfVe49dg1klmwrmR565mEYFSaoVslQwASLnIUmIPbG3gCLKDyjGMwiZ3dGMPTHn2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbQ3KjtAEvChJgSHCuVJFEnkS9HRLat+5ZgWCFbBcCg=;
 b=gTrtvCE71P4rGIs1Fn9RKbWRj3W9LPIqc/rJiOdlHoMPYPyiETNJTIUA00EhVoRNYpLPfM9wboF3k7AjxF4V1x3XvuhDivJuHMva+A7peZ+u5FpBgn1Zxxc9XfaaIELbuAVNe3/yDS+1P2wv7axJNFKbZfnq9AHJgMpPl5HZsec=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5361.namprd13.prod.outlook.com (2603:10b6:510:fb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 9 Feb
 2023 16:43:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 16:43:22 +0000
Date:   Thu, 9 Feb 2023 17:43:15 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, jacob.e.keller@intel.com, gal@nvidia.com,
        kim.phillips@amd.com, moshe@nvidia.com
Subject: Re: [patch net-next 3/7] devlink: fix the name of value arg of
 devl_param_driverinit_value_get()
Message-ID: <Y+Uio2ULqYj6jd4F@corigine.com>
References: <20230209154308.2984602-1-jiri@resnulli.us>
 <20230209154308.2984602-4-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209154308.2984602-4-jiri@resnulli.us>
X-ClientProxiedBy: AS4PR10CA0006.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5361:EE_
X-MS-Office365-Filtering-Correlation-Id: b10eecbf-7647-4004-2c23-08db0abcc16a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rlynsPLF1jr7g7WanzUAi7d3k8ipcTfiXHpAiSnaUYNjsdXScgGMCxuTw+hQsGuo5wKmEdqZjVUdeshxnqCYcgJ1KWUPnmCawmqaZSmh8GIoocGS1NKGDtgrsrgSs2FdcJ6OcsKqRlgn+EzpUDE7H2f5cJY/JtTQV/DGKPgBcxQKP2hXPMiCXIzzoK8FurjZwVazAc+rHZSexCouj2IsCUIjjCHkX4DinwleBGerKSmKKsC3zzyWSUWbKuGD9jIkytkIAP7gU9rv9i3qne94hokN4V9CnfoqIDVawORtCa1OPcNNTj14EQmKjFcBuR4fDy7eIq1VbJpQcN1S5A4VAmoMWmFW7uz3EBZ2udKn6az5J2H0nXlNi/ToKuLdDA1ibE6SI0gB9syXmj333uZ+tEHkWprGNy2AvcPd/keY/NQwpzAm0sieLda8tvaMgTiyjlU6i8ZfAN4MQi2JxdNPaX2fbibg/gv2T6jksp07fbuEO28a1XW44Yw5+xUVtGLFhU8mq1W0GTosNbAR6+eCRXu50PhAYB5hdaX0o0BywzTUK6PHVWOTFAVbKqj4qvm1g8cLQbok68teR+GnY29spopodL2pxp3kvlQN0WqpUeBtSTL9k3Xm12SfkX278e69IGCXPlXug4Q7woO06H8OoRH5J9f/zn7tU67ceyCDfeVQxbnmQZkf3RVsLdZAPplO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(396003)(39840400004)(451199018)(6486002)(2906002)(478600001)(186003)(6506007)(6512007)(2616005)(6666004)(36756003)(41300700001)(8936002)(316002)(6916009)(4326008)(86362001)(66946007)(66476007)(8676002)(66556008)(38100700002)(7416002)(4744005)(5660300002)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XpyplYO+M8PL5uNXPW3iYxedrYd7y0/z+7rVAJLUxBEtzcIP3dyI1o7bgixF?=
 =?us-ascii?Q?BJtSQSn7Xc0ydh9TZjZJQ42jD08Ds9JrTKu5F5F3DyOxF9ZrbrTjL98LkbFz?=
 =?us-ascii?Q?TOHHoIRgmWOuK7iJdadhsbexcqfS5EwtU7+t9qp4gWX/cA342alJes6ugcx4?=
 =?us-ascii?Q?uXn1+tmoGEaHCvl25baoyo/XMwbsBR2KhmUsbbeO1LoSpwvoOS2MuZYNGhaW?=
 =?us-ascii?Q?PLje67f4MHLrIcdTJfUeBREF08fm01OxucP0KQbWB/fY7eT3VWMvA9hG1xVf?=
 =?us-ascii?Q?8d/sPQ8r8yZMt5ztORTFPZGqfHtaIJouritQiPfXH/4jg4EYiv/PuNTFC7AT?=
 =?us-ascii?Q?iKYn0ESHnl+7Lnj1h8ZY83aM7UXqbb7q8PkXJUQkjixQ14N1gqmOcoYSAPIO?=
 =?us-ascii?Q?k2Gg0bf65tVJcMvhkC3hUPQMjzJ2415BGI9DRdEac7a42fZa6iyOKkT3bpEL?=
 =?us-ascii?Q?jCWoi4bP4Q8KKv8zA7zLekHifi3qjFtAKCrPNkD0OnRgI5jXKSo88rQ9/468?=
 =?us-ascii?Q?cErN7Zj9aRxFNTmXGVqeM9Wkz52IIi7WgynjIAtwJ84B3yIWrmgK594DalCQ?=
 =?us-ascii?Q?Acz4y1+zqiMMtjn16MSGOKpmWFOrT1fxF2GS5SO4KMp1pLC0TJkT7K66AnZR?=
 =?us-ascii?Q?9RLFYTDk3xIxMVGpBc10xjP5lMPz6bU4aIRbk612LtZ53eWxhaoUmkbbuadK?=
 =?us-ascii?Q?phY1egor0EAxxB+8dISE4VY3sUqQnpKMAxwEbPuhb4Ec00/Cy7MkQcx/za1x?=
 =?us-ascii?Q?uPQgJ6AYoikFjX7tIV328S0Gg4S15Wtb/G/XJH1+BZWXcvp/EE8S5RUd0yyS?=
 =?us-ascii?Q?gKb4vUgV9KiHAAAGCRWKqx0dhcqVylxo56I2+UPxsNmqWotsJ0iqiRkIgdRA?=
 =?us-ascii?Q?WeVmqA871aWTsf+pKn4UtLNPWPzZXWOaS1pZ+1+BoWdMZ60kYqY1uAI16d06?=
 =?us-ascii?Q?GjuLgmym1kM2OWsC1PoR4vxZOID/ojqQQQjwPpMUwXKf02g0kCBkYvZUpO1n?=
 =?us-ascii?Q?ktr1gCInrW94kgUlnpidX8RzekZydWrl1W7q4lkFoRX9M7wXgLgkqBAc3ZlB?=
 =?us-ascii?Q?7jJAfq21+rSBQ9C0Qu/9Qf/FvrNt67NceGj7zkeKhd4i92q1AHaIdH4iXJJO?=
 =?us-ascii?Q?QGtQpiRH++leeja8Paon6OXQlOV4PvCpPg0nh/IZS7S6fVpA1N1SG444bjUr?=
 =?us-ascii?Q?wqRdOoHerS10jgoaothKVLEdr7ukifvcFFzTUNsCZ+GUu6EZ/NVzBPRtgwvU?=
 =?us-ascii?Q?hCDdSQPj38BqDzmMag8pJIFnmTpawtyk4iA/LBHbUEixgQlIOmFKz2D65iNu?=
 =?us-ascii?Q?jOuIgzBxadY1kDTI4l1TJWiu3u6NjAXkJOgsZET3YWQd+Kh3exm4MI7hSFdj?=
 =?us-ascii?Q?Y0CFEqsXg9KiZtaU/jvMFGqQCExgVWYsBnhvok6IUgX/dvSYSRe/WOUif852?=
 =?us-ascii?Q?3u9fio6bGwQNkRAouv9/La6R+ipRpsTn0tnrQAhNc7Oxutgl4h+TqUEhS3rD?=
 =?us-ascii?Q?XMzTbG7KmUzF1dXbxmTiholLFXYrh8+qQSS9hUoV9dMWOi9HRIB/wofujXKS?=
 =?us-ascii?Q?TG9NI93G11+0xUyNE/PR69E6Gz6ceRdqGBL07K+Kr/OsVuE/GOhvu+k5sUQC?=
 =?us-ascii?Q?Xl8mwaYXNlAEerrwfMPaRdmtQOv8qPZQdLHGtQ/e9YnBmSFcNkNPvlmRUs0l?=
 =?us-ascii?Q?QifZdQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b10eecbf-7647-4004-2c23-08db0abcc16a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 16:43:21.9709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fkEc49wr/blm+cGWc5dYxkjFtM5bzjO706q5zBjr7sEwkRTlrJSsE4Ds/zPZ7lpt5ZC1fHJbkgWWH89OjegLspB6RsmjymO2gfidkXPPH+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5361
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 04:43:04PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Probably due to copy-paste error, the name of the arg is "init_val"
> which is misleading, as the pointer is used to point to struct where to
> store the current value. Rename it to "val" and change the arg comment
> a bit on the way.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

