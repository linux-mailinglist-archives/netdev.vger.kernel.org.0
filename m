Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06326E9835
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjDTPUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjDTPUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:20:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCCD1BD2;
        Thu, 20 Apr 2023 08:20:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5K0SQKgY9RGg9AM+QRVW+wdSJGhfdtKBIS2yvD/ygFi5VVx2lAX2jzTTg7LT8TwrIwpsHbbDNYszDLJIRWJZMXByTeWbYLIKdwUYlP6R66Z7ubwAivfbLR9y2nnCtZp8UT2Agx2yUxN7pO89BpTzB1sQVd9jmQIv+1sIIZsxG0csS8MGjZTwe3rh0v95MsooIK+aUZUwo5jCTHLDvCf6kHf9XI5Qfuvc7CmTgA8PMvA88PK4/4uuCfwML6XdDo5y1scrSFOGAE93fQvA0UORcHwEH6thbOYLwCc2v8awEtzYTbyiqaB96NujjXFz3EqJHfTTOLZJ6NlE1/vX5vBqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+kmfW2zy87RcIBM0ahktT8Q1K+YOi6mbX3uQ3bZ9ZgU=;
 b=S06NCaUlmcm0kOcUjU3pYgqtYuZhn/S+IXGM71Cv2Els6Ifs6QMjy3PDOb73AvwiqKrSK1nOD6YBWil3vrmD94lnI4+OuHvTe1/3Q/JrV9i3YyrQGj2CCX7/XFV14Z9LExYWip+1vKzg0zlhe3CSuCxY7vc4hSoJhV9Sply1BjjqGiCU2uCHy6lIZ6QGm08bBHDVgpQed8a2mXSJfsidX2fyNizefCf8CXIYzksW23fFxXqixAKQAd7VHYFgBqA4XIJFagFcDoEfLkvzmXAUOVqVuCsRbR4J2uG/IIqSKtaPJBEDWHtoOfWfdp62x4gWsvrZHDejAczT3DZ9tv9+jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+kmfW2zy87RcIBM0ahktT8Q1K+YOi6mbX3uQ3bZ9ZgU=;
 b=ljAjBDuOFtf0MEuJrDVtXuYSZQAlfQIugsyNB5VdyXjvQnZk4ZOqEgxCmzpXdnlVewA3v6q+6hyz+ocLpxuYl8bKgNinz3X7Z15h/LA6T5tiZLO9L+hw72HhfDTsKp22F8BpmmFGXrVPF4AfcoO5rqSB1HfGp9Bq+sr7QELcG5o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5849.namprd13.prod.outlook.com (2603:10b6:510:171::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 15:20:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 15:20:46 +0000
Date:   Thu, 20 Apr 2023 17:20:40 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH net-next v4 2/3] net: extend drop reasons for multiple
 subsystems
Message-ID: <ZEFYSMNsJVUeBqZ8@corigine.com>
References: <20230419125254.20789-1-johannes@sipsolutions.net>
 <20230419125254.20789-2-johannes@sipsolutions.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419125254.20789-2-johannes@sipsolutions.net>
X-ClientProxiedBy: AM4PR07CA0026.eurprd07.prod.outlook.com
 (2603:10a6:205:1::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5849:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d7deed8-f2cc-479c-95bf-08db41b2d053
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3M6krbG3az2VC3zXf79LZUVXJP7sJ16pq80QE5RHZuirRWPbHwG5Ml5uvX0CKwm2nh7QxXZOKYOgjC+PI3XyQNvjItzmTUTCe7RECbTzyAEWUUWNf4F+IACu7FLDANss4LGGoy47KfT3ZZqBCRrrQ70ISAugQwbYii4OJ7zE7wB+MoHxjgxjspG/Bg/tLKU1TyUzVlYPe8Qi+fk4cIbSpgak0GqTAd5StaYXhcJF4VSCEfzG7tydjrywrzTWq51u7O/WqtBKHyujBBs3LKL3aE1KiWR0H/egkpZVfOXW/Uun1NrvqWdkzNK5LlYjPTd+t887liaipSSgRXWO2BYvDHqiA3yIlCiS5OYIaUNRcwQIWNBykGhEo1yKoZVwi+FqYlELDdQGq+Pkfo6Ib4eZtCz/JrG+L+HMKy51cQDvmKWOUoNvv4UwXFf6JR+ldCxoMmYf7hqRo2522sd7HKTPysrBjJxGFUvYwnqmoMtvKnGJa1UPYTTtvyKlOrrbSkiFs2k3eYAIkNajoOZfB8gs0b7qC55+ela/qDyiZy5I9ET7lj0GJiPFBSyj7xjCk5Kn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(396003)(346002)(136003)(376002)(451199021)(2616005)(66556008)(4326008)(6916009)(66476007)(66946007)(83380400001)(6486002)(478600001)(38100700002)(8676002)(8936002)(316002)(6666004)(41300700001)(44832011)(4744005)(5660300002)(2906002)(186003)(6506007)(6512007)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zvy2G5SXQJLAIduv6lrr0/57oCpF0KlxX58Ax3G4lu0CzdPDDMS4MudR+/p3?=
 =?us-ascii?Q?ZqPDCoXTs/ci1UGmgcdPuyz8Cabful9SJCArjMquYQLChh9G5PtY3gbfjYU4?=
 =?us-ascii?Q?9gw7FYDuNJrHDgqfhk2K8XQ/JyMHBX93NAtPdBpXTGhe0g0SQA1iloeVL/fM?=
 =?us-ascii?Q?ctSsL6pFPOcA8F6IFXzBJlLG1zdagIMH2BqXRTyPged9faSIB0ZFjX17/Nzo?=
 =?us-ascii?Q?wKqDxvEDmJdyWX7AksyWfYLMM+bb4FeiGKTiz9gvRNYI5UnuEVMn992vE/u1?=
 =?us-ascii?Q?35dRY4irXp7exSwrxUC/V+1Ak/LR60C2iu/CezpslA51QpXRUrhY0olo1YMH?=
 =?us-ascii?Q?V/dOHgIQDtgFONg50z18/pO9VXDX+WpUIPlZexUJ0CxLWSM8HXj6tUEDn+Hf?=
 =?us-ascii?Q?vmimUCjB+JkqoLbXymMQ4BV8OG1zw1RS7yQTuqh+CgJTnLF6p41riyZhYPl1?=
 =?us-ascii?Q?1TPKyVU+7mMKUYZjA87yDqr0tMDlf/uIMAAmO/p9mdpQe1ApjC0Ymyo1E/d5?=
 =?us-ascii?Q?pcK/jWZXshP083GYLR4+3yvepEG7iSXI8Kup69DI/qRACoSlIdQMOOKIA2QV?=
 =?us-ascii?Q?3eF/84HwNr/wLnN3PJHaod+no/mD8m9BXMgFQhoa/FfTe20SGfTjT/xfKd0h?=
 =?us-ascii?Q?Ds8K86PWE6STdXdYRtfOEq0pqXjnqsLP7fbPW8gWcnekibff2rtqJc2HFI6H?=
 =?us-ascii?Q?miqoW7RX9yj3zyjI27FBDJOU08SbuXywyRpSDPtBraX1r5zdvaq4zJ57olBt?=
 =?us-ascii?Q?N2MC19RmJ+g5Cihct19+xtoi8LPBA5FczTDAkoHOntnnL1SQP+5MwqQfszpW?=
 =?us-ascii?Q?mIgBCg7y7VX3/zuingVV/VZ4E1cStB/Mh3iPp6WztjR3JiEXLdxDqpxrrVou?=
 =?us-ascii?Q?5Zp6BYPD43wChnJCOe44X5IywVIwMS+H2a0XkJoGzcl8TQYDAioKJwieCrLn?=
 =?us-ascii?Q?U/LMH/rQHvK3tikW2U/22FNJHPwkw/aACKYUF5naVd52RAW44FDYYiviBa0i?=
 =?us-ascii?Q?vF9RfEGlW5upVJzeF22j7taabhjMly/xGPyN7yI9wYrPyo5TQHWmseJIfM1f?=
 =?us-ascii?Q?6go0kQDPtSfD1lTxEfdJ4o2GEYHSb4eJAXU7SpJ1CoVTdY745qwuRn8/Kb4l?=
 =?us-ascii?Q?j8b4YLnyexKjdf/9Ayvegtw0/Rpwj8VLXIy1lpLe7v3KgL58wZKzf2IIAx9/?=
 =?us-ascii?Q?I99MRnBvdCmXHf1koP8frFi5ZiqquVty0BCS6hrwwR3SYGtDATdarRW1jkUc?=
 =?us-ascii?Q?PQ81WpPTY48nrRkDTZdwF/XkSICi/BIAvk+PUc/F3ieSvFQJazbLrh0nH/CE?=
 =?us-ascii?Q?feSW6fpJCF3v/ibXckj6BjB/mF91CXy6GCxXNu84Way5klWTPGtQUg8I7zDr?=
 =?us-ascii?Q?l0RWJTEG3Ku34tunWL2MeY3DlQnm14fkqF5js9k+6XQd9yAKGd8ZngJC1DAD?=
 =?us-ascii?Q?nGiNPk0IUDAplF/EsNt4JyjefZy4nLbEOWy2W+f1t+Yf3AwPPQRlFqXVg4Jt?=
 =?us-ascii?Q?yLeC6NAxeN0oxFLNiuAiCQpCw9Zb15WK47FDZtlTxysXsjxGnbdb1oaVcjg/?=
 =?us-ascii?Q?0lpXw1ONST85LPn4Ne6YdNUbjpoZKZfi9iK9VJRkAFBJlCfE3QfrVWSuNPAJ?=
 =?us-ascii?Q?4QK9Ny7FqISJb2KZB1xSzFQOIp/rCiYeLLE8GdOBtsm4TxPjfZC6OiZjq4TJ?=
 =?us-ascii?Q?2/QUdg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d7deed8-f2cc-479c-95bf-08db41b2d053
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 15:20:46.4922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uC7IvQbkmwDUm9OFb21Ijc/qHbNZwuzXaezPSvcnsXiBCcDXO9LXwhP/fJNKuJcGYNvIi6GikpJWRktydwqpH0mq2FrA4y9Mpbf12gAe4EE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5849
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 02:52:53PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Extend drop reasons to make them usable by subsystems
> other than core by reserving the high 16 bits for a
> new subsystem ID, of which 0 of course is used for the
> existing reasons immediately.
> 
> To still be able to have string reasons, restructure
> that code a bit to make the loopup under RCU, the only
> user of this (right now) is drop_monitor.

Hi Johannes,

a minor nit from my side that you may want to address if you need
to re-spin for some other reason:

s/loopup/lookup/
