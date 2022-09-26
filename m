Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005CB5E9B36
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 09:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbiIZHuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 03:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiIZHtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 03:49:51 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2128.outbound.protection.outlook.com [40.107.220.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD6E3AB0D
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 00:46:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRErS59Mep5PJNgtI6chYFnp2ItsN7Xh9U2TocGjB0Q+FXjDCPQJ/g0vNPUWumetj6s9JLPD3oeLKjUipj3NeaUPjT6BTb3qz67XoGXVeVFNdo2r8ml+ogA44rsSGCvmG+FihQenNY//4sAt0zWf+2l4hZgvLFYUdRd3p+z1NRdgvnH8e9zwFWEHtsuBsBhjF/2CigjjTV+XGaMyLdghm2EruclY3RX0CDXw+XDAZlM3WzzdPkWEtSMCkV2q5PhTNTYk3gxThhL3R5YLLHnytql3n085gjxjLglPH9GXDY53wHVEeam3UZLFL/pHkomm1H5Q8ipnUsaqgPAr7ZgmFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAytzP/NFORr9plkgTO//Bixar6ySospgEqETwulKvc=;
 b=dnxsmfB4OZORNLqLQ/DRHbqZxVpxmMZC1vPeaKjh4ZNr27++a2VE6u0awJBC545qGGiVMJ5Df3JExGOmzTtAq1ui17zsHuf8psXJfLsr8+R/h/vPDBkiwV+05kXvOplbvcI89ZhGw7o5EIJUlubcgLYnYy53GGQwrUfXWOq0kdsgcm/YCA8RP/zvYUgqtc8YfBaQ0BDPW2zthZzdyeZUvZ7itaI3Yp2LrSwUZvst6yYQbvqkNDLIK+qfF0j+frxymjYfif5M+Ar+lbvky2n/RgogVZMRNBfO8AwMrD+dRGOW78zzWpfqQLL5ctRNM6VuZOFRx5Qx9CbJJQiWZMqsSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAytzP/NFORr9plkgTO//Bixar6ySospgEqETwulKvc=;
 b=WUPmE5rUKv2NDpnr93mmaueBe/qbVuZkIakKyUq6d+6e0CRA8olBwbm4XA/Ph6NLv1iJtIlczje71TdsNwNhoBySOzfrZMgYFA7ewg9fJEC0NMDZ4h7wMkaZStWPv64lZOGp1P0SMlfbV/9ww+Mhn/0/pnaZCWqSBOYODm1ClFo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4713.namprd13.prod.outlook.com (2603:10b6:610:c6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.14; Mon, 26 Sep
 2022 07:45:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Mon, 26 Sep 2022
 07:45:29 +0000
Date:   Mon, 26 Sep 2022 09:45:22 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, skhan@linuxfoundation.org
Subject: Re: [PATCH net-next 2/3] ethtool: use netdev_unregistering instead
 of open code
Message-ID: <YzFYkjt7MgQroFtL@corigine.com>
References: <20220923160937.1912-1-claudiajkang@gmail.com>
 <20220923160937.1912-2-claudiajkang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923160937.1912-2-claudiajkang@gmail.com>
X-ClientProxiedBy: AM9P192CA0021.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4713:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f2eac30-dec1-41dd-3ac7-08da9f931527
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqBvki0etl6iZ1MAmS67bud/FOqz+Y2698uXRtx5uBCtIa48JQCuy7+eQkduPuygTd85ljHE1R/0NyhbbT6muiLTJfuKjGnHCkfWrTfIy6K24oMU5lOcbAsxXV/CQZiMJILh0ovk6Y/YjeNH25wf/Fp01Jt+whqusxJ6YJiCzj68q9LsVWCUvi+2vWWF5i7c7W9idByWz2q9/y8RsW7HxCOyHrKA9s0958z/Ys9bX8CscruYUo8ygoTI48iUlAJ90u5xDfsvnz4dtIV4UBHqHoujzheEormGn9gGj+12URdcOw+sZN+FSL93dd9v3eRapOqaPfcRxgQqpj4YSvYy2fpedP6pMqBhuqlv4T/F5xyPxM+k1juH5VZTL8bqv807YzQs7A1yVImbMRCU4GpX0tf5s3Pb64ZWsg2T/SG7Gl4NImZRQRHIsQ7scclbOZZUrv6lsvK55dyzhUBryPGKFkXW5tfmYNfS5TO/q3V5c2KqzjkDm6bXNkfdCBlL2osMrXIalj7RKeKQa/9+7WEeN9iMHxIQYLNx/RtZqRi0l3A6Xinc0T4XMtQHScpgtsJVod83BF1ET2CJQtdiyT76T9DPiykODFLXs01DwoFX8BSjoBF66Qj36hv6Ihcw6dBHw58orx89NexoCfUvu0KLVpd399WOjz2ka6OqSDazuFlFjWAWlgN8n37XmRtk7DX2Ji/VGIaSS2H7wLyxhFTVdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(376002)(346002)(39840400004)(451199015)(2906002)(2616005)(186003)(316002)(41300700001)(6666004)(6486002)(478600001)(36756003)(6512007)(66946007)(66556008)(44832011)(4326008)(66476007)(8676002)(4744005)(5660300002)(86362001)(6916009)(966005)(8936002)(6506007)(52116002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yj2WJnG0jKcrTN2GPpGC8WKt+MvNjYcjUx/hVUjXKurBHxAZoNQK2kRMEAoS?=
 =?us-ascii?Q?JYedVqphZauYOMAh6Xig47BmY95POkrfeJ8b+q0kDHpvEzT7Up641AbjjKRb?=
 =?us-ascii?Q?DGVYJq3cLCbDZBa7Zy+GBPykNit0fA1jrPEZS9F5wFyjeYzo2YP9TCajpulh?=
 =?us-ascii?Q?G+IXTtOtfDRtUsBzhvp9ZGMhdQTmZd+806h4njpyOz54vWW3R2+QYLy7UJL8?=
 =?us-ascii?Q?Txsrek8YcgaYmp3DSAZ6waMoA+nHBh1vPc7dIYWSa4/EuU/XjFq+c4MasOiO?=
 =?us-ascii?Q?PmERXDmdDEjC3081ykemkwmn63FhQlgFlqdzZR9l/qRZwDuRIKZQkjZQKi8K?=
 =?us-ascii?Q?S0t3LlrQZ9Fq8GdH/40V3ux4uvLdC6rKRcwZhOwv6yoFH4+e3qqvtI78yhbY?=
 =?us-ascii?Q?ysnK2J5lj6jfnzjdxUKzFmzU6wse74eH7+zGQDJ+urc6wAj9tdb8rwtnYqAk?=
 =?us-ascii?Q?ajUkFdImgerL8z73q+j+aiGQMXQp0DHfVycJQmSmX4ygKeXAhEM/R4PxYsT6?=
 =?us-ascii?Q?Di51vfUVtuWbq4RFagNQzKNNQg5hawMwGNlB7OHfsVTBh9HvzY1OALVi2tot?=
 =?us-ascii?Q?4LrcbA2V2DtVW0x2TvzgdJ+jilc+JFpNqzHEm0duiNU37r/qyl4uT/ZAZeCY?=
 =?us-ascii?Q?Vk8xolJ24RFBBoyXQqsraA5ckRdZo4Z7X78h4xJt+vgv+suehHUnjnNu50Tk?=
 =?us-ascii?Q?VJw+s7nX1d+dw2VU15jzzX2IR1gClQJQs6Id5VJCXo9iF8OeVNompvv+wRVX?=
 =?us-ascii?Q?6x9J/ln9Hy/73nQltISMeFGkHY0DVXECoHpoyJY5hFWkGBRiZsjEm5kX+kNM?=
 =?us-ascii?Q?5mFnyMc1ZBUwrRKrfpkkIRpVLKexZNM7vk4gywSdWgw+/qweZ6IizcgAxfaX?=
 =?us-ascii?Q?qJ95AE97D0yKNkiIeVHYdaXX+63LVASnpSFnNPk68YDIGpwXuIWGVVQ6ggFG?=
 =?us-ascii?Q?rPZ2mCwbkKtsJMKoPO/oN1IzdPxVD9BpaFxTbRdLQruobHqv8veZOqLbHYmD?=
 =?us-ascii?Q?hYNzXB/4wRdzC/EZibY6TUB9c8zDp5UD8k+qmeC3bdODxOKZkU0Guda+QVwR?=
 =?us-ascii?Q?5LIQ2W+kHY9g9kO3cpYefP+hy1znRHJIgbkMbV4Dt+eKF83zHe/uQM7cESvL?=
 =?us-ascii?Q?xSaek8tuY6kJukS95G7EzpzEyXU7MSRAaAG5Ssk+E6BApUbut3vUd+uJ+ADw?=
 =?us-ascii?Q?tDJSdxnpUpq08ImZuYc3G8884sykRrbLkzt2jRTG7xZYXtUdZSI6eOLanDZZ?=
 =?us-ascii?Q?HOsUxbQ74NNfBhfn8sGXnWkXPcNMbmzoIVZ/DpFcaZsuKt5gVqLkUxCPIMHV?=
 =?us-ascii?Q?e+Ch979I9ihrHeahxgX9AzS7swpDasN6jYu+mYB02aqBXXJjoHvHiMyGtcGZ?=
 =?us-ascii?Q?NVF6ZLbPxjFnk8u+eObTl60DoB+4/94uZa7SmemUvEaWyMTATVqxD+zfn285?=
 =?us-ascii?Q?HB4DeVob0Q50J8IgF4P0McKHQbUNYxzhhLL/5sm0d+9C+lSyPyLq5X0BtUbF?=
 =?us-ascii?Q?3WXjrq5FOi9U5+MBLww/ZotnXnQJXAFRktIK3KL3OR+v4rzLvseFbs+8ttGN?=
 =?us-ascii?Q?GYP2Y7Ugf7oANPkMNv80YhoVqUDndsWoUIgRvV89K0nC0bBAXRNEuXvsvnDR?=
 =?us-ascii?Q?ec9rrXW8rwSPVN9n/QmsMtTZ3z05tEmNzi7yEHzkUQtLcPOfHS0RCAFP+Kei?=
 =?us-ascii?Q?s3ug4g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f2eac30-dec1-41dd-3ac7-08da9f931527
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 07:45:29.1029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jmC0RemfXpHS4fJIIZscqkgPk6S+iJavqfmACFUOm5Z4kfCLicCv/LHqWf9OhzhJeplTw3pAguiDE+C8l1JOhTAOXaPBEqOSAz2vw16O844=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4713
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 01:09:36AM +0900, Juhee Kang wrote:
> [You don't often get email from claudiajkang@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> The open code is defined as a helper function(netdev_unregistering)
> on netdev.h, which the open code is dev->reg_state == NETREG_UNREGISTERING.
> Thus, netdev_unregistering() replaces the open code. This patch doesn't
> change logic.
> 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
