Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD86B6BEF0B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjCQRBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjCQRBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:01:30 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2111.outbound.protection.outlook.com [40.107.93.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C33720D20
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:01:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPRbtk9odivqhS/9+QgtElWp/RKd2z7ICjp11lWSKEuJETeFMDdccV96KfQlc92rRbcNasaxMWr6PqYESvdkWMP0ORs9Z6gjpr45rg8DPpoa8eYgZ7bL/Zrf/FExCk7DhjWbsEh9Hh69v7l8BzN8J7uoGH6kXImEoqa8u2NO2Q/fQYv7flhQK2HGFRE526Kd/zr/HUYysETTfgIeHFLTFA6n1gWfZILDwKdY0VeVXBt9F4H3oIQh8qKwL5DrvAacOImzY1GGNsVhSaIz0mLG7D29BgVbrssptc/1uH7Tfr15bakjgqvduN7HMB5HVmtiTNkDg/cZvaarIwTnOvsYjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t9BEPb/2R0YReCq3gXe3BurAyXn/TCzbXGF+KKf2EV8=;
 b=LRByE4kI8yJppUWQDnMlVIhNDhI4ZEJVCkSTj9L3qpX+XwBGXd8hPVkVdUnM4gKQLuOW8WUhy7bH6eNQh9DF7I7PPjyZj+Hq8kC5MPJfw2mikartH+V7E6Pkts7BaUnO14Vk00k101WHhpJVluQoMyEzzJmCoFRH7+d3fWHooGzMZQRBuFZ7B3y3SK64McdOl8hxs9FHFUAWwfXufuvh4BOHx8ePjRDfFvkTKAGpaY8Ld2Lc5h+jnvbwoeqED/cfpbR6lf5SsJha4M18yIZwdbNTNv3+5YP25cQYrKgozr5fX6cEGobhPq2ZIwDdRW4XJz4KeUzCaMUxQJ5WGEyUXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9BEPb/2R0YReCq3gXe3BurAyXn/TCzbXGF+KKf2EV8=;
 b=ZopZBil3vqOq4ecXcKhSXuxZX4XSvlWlo4qcXeSN9ILq5B/5ibpgen1J1x6no+4jxJVPLjt6+zwQB+DMtcVpf41vy2umaaGYEEy9vFGeupMJDkGC/tHvSsSyNu7u2qWUYKvGsNfm7JOqHT/bT0jCBY5nwJQIaKHYF7YPsDi2pzY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4440.namprd13.prod.outlook.com (2603:10b6:a03:1d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 17:01:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 17:01:24 +0000
Date:   Fri, 17 Mar 2023 18:01:18 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com, Karsten Graul <kgraul@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Jan Karcher <jaka@linux.ibm.com>
Subject: Re: [PATCH net-next 07/10] smc: preserve const qualifier in smc_sk()
Message-ID: <ZBSc3oBpB5CncUJo@corigine.com>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-8-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317155539.2552954-8-edumazet@google.com>
X-ClientProxiedBy: AS4P195CA0047.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4440:EE_
X-MS-Office365-Filtering-Correlation-Id: 821784ff-fc6a-4ba2-79db-08db27093d72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ycXyE4H119EiMShFKU7aSI4M+CmC3LACfKvNwnGfdq4c3NfxzFylPH9y2jNKn4BUtahnnFirSOacL8qqXa7n5JRvm5WCT+UjsHfT9MvFy2yvmpXNRxd7pOw00ZbJ/WpwQxrgTtOjz/grlU4VY4CInohwfe/mKOtXj/Kiol0gqsCGu2Z5LpeGrc/5BgrBsyHODuVWf2EY3bzXSn/hbsthtDuhyKPluFOXkmNxG514QlU+zi3Deuwzt4jJp8BhOHZpVs3H9bUuN2Nm+vgdTNNdVOIZLwycAD/x5P7fl0qROvikxAt16khBq0RlVjjau8Tzp3GT8tszxINv1dOcrdhiZvl4nWx91KWSAMAHUrh7TizWRuzkngVAzDnhMsh76PQXs8CH5XsITDNSfeQEEHq2dUA5p60OT/K017lC2mGf0OpnvnoPZPuk3cVp9/5My7cTgQ9L6TBqUw57GdSYOnOJYx5Zdu2RtO2DoGs6LcrOizUKyK/2AM7T3vCqk/xwpfC61OfEeE22QHmCO5Xy1eafoVMurDJR43ntzXzUALjs9imT5UBqXEAFYJeTIlCZLKWq3nrLkRHXBL7OkFiC9eqr35SFDUt9b+pIzCvieXUJoiIyF/T4vdB00/AzgFwaiciNXj1SA6t+q720y8f4ItKTZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(396003)(346002)(376002)(366004)(136003)(451199018)(86362001)(36756003)(4744005)(8936002)(44832011)(41300700001)(4326008)(5660300002)(54906003)(6916009)(316002)(8676002)(66556008)(66476007)(7416002)(478600001)(66946007)(2906002)(38100700002)(6666004)(6512007)(6486002)(6506007)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cNu6ai+XenP/kegF3oJ+eEfg31K+ilPVEOWZnGjod7EKS2xdu73N/kVY7WCG?=
 =?us-ascii?Q?zSUONslAerAWcMzKnznnaYdR1vQNL9ityiNm7NN1w/N/mZn949p6tH6WfDDO?=
 =?us-ascii?Q?Ibx3ejrHO9jxpVtxpPZUwlRt5k5q4o2ZzkbwGaV+B2oPS3YkMZLUn6EoMtNV?=
 =?us-ascii?Q?hB34AOYPEXk1jBqtfpMJ9Mw3vzPt+gPoH8hXrcLEatnXJ/ht6d6L2KFu+RjG?=
 =?us-ascii?Q?Hj1dkrdKjjtd7wjXOPabVj2JEDDA6GwTvXnNCct9FyQJwS+pAitdgraXi1cJ?=
 =?us-ascii?Q?Qo+kCe7l1Z9N+7xX2jE2xhsq+5wQezxeTm1HNNQ/rtQ8ATVmNWtfNobm3HBB?=
 =?us-ascii?Q?7vh5LK2XAg/zudgylsHcPsXE+eVLsVVvtT49/C7Dr520DrY+rFh8OK6lH1lq?=
 =?us-ascii?Q?MjBqvE/+0u/Zh4uh2o//IeBcmSOs3AfY231sdzdUCVtdUV1gmFCpWmrHYWGz?=
 =?us-ascii?Q?tw0Y2mk1Plxrnkoky0V07qqRQ8Fz9mLssbKR7zutg/gtbnaPLwWfBY2a6KFM?=
 =?us-ascii?Q?eZvkSwenGwDLMmfyZGXHQI4g7oFAqER6q7Iqe7+Ldd3iWMjh5rHQiXOdIRWr?=
 =?us-ascii?Q?2/MTAJwKOpqfL0CA41tiuCug697CkQ6l/M9AkYsYPVuTyEPlg6t8CJijKLYc?=
 =?us-ascii?Q?FaZDT4XBXw+ssTfpCYUjpvvDjxHYDb0IO1DLVAS6EVCjT6FcJ/iz5xl4L4IO?=
 =?us-ascii?Q?I8ucQ4+/0UnyW5EQpWllvuP2TfSW4NfJNzN3ZP/688C1HGNy7a11NYYbpLXc?=
 =?us-ascii?Q?edFugQVDk4ibQLM+NMIyfnsOkTVTnJbqXrzqmx0/Hme/XAtHjJvzpAU1AVgp?=
 =?us-ascii?Q?EPcLMEhy5yns5yS4mtaKxMJmaaz/aUK75GZTzIwEfsOb8HwKyun54XBdzFyS?=
 =?us-ascii?Q?RIx5sDHzv+/Ox9lVoXXdPagABvrVeJrWKFDTOCe7wzD+KO9B7ydXGIqPLcBn?=
 =?us-ascii?Q?lgHh7RPiVeu79tt7PK/Ax3ML0pf4sNcMN+6TTNkcZ7+3Z3rTIzqfvd7WTboq?=
 =?us-ascii?Q?30jTAhRnUdmcfTi5a6MStHci3pS0NO0YnSNjPM1B25peDmwmn0aM7ZE1r6DJ?=
 =?us-ascii?Q?8PPM3IY/8w404bUAkCBuOpDyBV30WcWtSRbztt5kmNTuvGY7pE8kP7VzgygH?=
 =?us-ascii?Q?baRpD44c7VV7sDhfL6KIHXuTblmof9hdiZrfG1vovBYEesFjMvBpaL1M1euL?=
 =?us-ascii?Q?x8oHIgc9+YlLK3EMC3d02iHfnenRuGm/hGqAKrt3gMfV6v+zSMCdevY5vzPk?=
 =?us-ascii?Q?JDa8rz3CYMDDQeCB4ugsIgvN7QdOtij+VjHmduE1N1swPa5/vFxW+VBjgbh1?=
 =?us-ascii?Q?qdg6I3GYgomWefu8at2G4Unz9cwFokXPBZSRP3Juoy3BW4f2T8pYiwTLI7PH?=
 =?us-ascii?Q?yrcKmTf82MO/7ZHjoySbNvAJEi8LvovdPC7mKuSNV255lWj8RmaMaDgb3usU?=
 =?us-ascii?Q?3jOVppIeoNOQx+K8bpNlmTDz9d6r6TB9T3Olfz/WJPDRJna0waDyUXNjNl1J?=
 =?us-ascii?Q?oZD8q/XWTxQTgewG/C6mP7AYIT+AjHnnn5hCj++DLSmiQlnv7vtak2WnYWTC?=
 =?us-ascii?Q?sSnTcTadJycO1OXsLum8Z2UaPnKzPUsqERpz1r191cwXCW1nGY1ec4TVDSMU?=
 =?us-ascii?Q?FfrkXR048vLvifDLCgNsOB5Foir81QyX0+FztMs9NdozO3q7iLBFqTa5w826?=
 =?us-ascii?Q?tjegTw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 821784ff-fc6a-4ba2-79db-08db27093d72
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 17:01:24.4189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x4S/GeZ7PLA9WbBCsjVyyxiRCr5wuDjqn4aynLrZRjICsZCbL8I4KEPYCbc/ZbFzf5yburYnKxDzsC4IIthjZUuDZUTgCsqs/1lwj9nEnNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4440
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:55:36PM +0000, Eric Dumazet wrote:
> We can change smc_sk() to propagate its argument const qualifier,
> thanks to container_of_const().
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Karsten Graul <kgraul@linux.ibm.com>
> Cc: Wenjia Zhang <wenjia@linux.ibm.com>
> Cc: Jan Karcher <jaka@linux.ibm.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

