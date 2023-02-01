Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24552686800
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbjBAOKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjBAOKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:10:13 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2138.outbound.protection.outlook.com [40.107.243.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FF75CFEA
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:10:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnnn8BgRVGSBj6ZfUmHiOKXcAk/ceaxFdZ6yGdi78pBeHYJNl64Mex1NxeStX+4xTuIJtfcMUpqCP9z8SDd4+4xcQH8sCtNdATDyZxqfq53r4Ea2z1DMExmtRmq/MqBTFNzse4021xFIlwpFCM/Lx26W0Q3PLam6/eun2yKXIr/WNL4lewQR14lltt649SZNFgykHjsQ3q9nZogknU1nALOYxx6mw8w2A73hfwgSbiPWbVzWnQfoL2d88A5TUw0LXxig3Ao5itxzTdIqXdPOxV8PujqF4MZBZ+Ldn7XSn5W6GIP1YqWJvRkX2FP/rA9obhiJ6BwdxvPl/u9qGr2DHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=stVx821vy2dMlW0FepiMNbBoypaBEUAf5mbbFhpA5t8=;
 b=QbVCPQfRNmVQOSuxlDTOf6ushm9Vgf23oStbqY+8XbtxAiDjhQ71JAZlgPGK4RaDEeTZXYupherscvzQ6uRvMBbJMDMLHccuWFJ1SM3o87h7rrYG9fwqQRT8hQ54bFuW5GVu3pypsEyueOhDyR5ee/dfF4E19wDBZq3/RsFN1+t/aT8p5F3uyCejY68SIRgqayLJf+WHoKtTe/sSFXMR6cRsLPjldVi+zbKUFfTTcWI3wsOzLEgfaVkKXX8crukYoSSMLnRDs+Pd/xOwkKDEbzf35ivS2YAyyhRV3IbyHstwKxXxho8gQ0c8jcWOXcOYf3lncAzKsunOlcWIsd3olw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=stVx821vy2dMlW0FepiMNbBoypaBEUAf5mbbFhpA5t8=;
 b=n8Fms2e5NNsBh9WYv54FU4OfBVYPZ8mNNhLxirAjmTLwQT71DEr607XQd4DQNftt3kf9flDtQAJfNnZOx27I4CNfFPsY8AKSTcI63NXUNBCIyP0BAUXA2+ir6tGyPT6+tADfdI7Wk3DdnKqdOkeEgvKtuLNXeuLfwswo1/u2lvI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4990.namprd13.prod.outlook.com (2603:10b6:806:1a6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 14:10:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 14:10:10 +0000
Date:   Wed, 1 Feb 2023 15:09:57 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v4 net-next 06/15] net/sched: mqprio: refactor offloading
 and unoffloading to dedicated functions
Message-ID: <Y9pytS/73BJ6hCSf@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-7-vladimir.oltean@nxp.com>
 <Y9pyBhIwtkbRhk5A@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9pyBhIwtkbRhk5A@corigine.com>
X-ClientProxiedBy: AM8P251CA0028.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4990:EE_
X-MS-Office365-Filtering-Correlation-Id: fb2a4d3b-4433-4591-7b7b-08db045e0749
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XQhii4sCqG2qR4qJf5VgX6dEaJSQC0F0DAU0IPK8rbd3GgDiTUywre+HZ0YHVt1bazk6m1MGYQ+C15a5n/H1kYrCwtgTsPpepECPTp/eOZUQs+YysE78muPoHUiI7szsqgWX+Uvm9VXbkfhC4n4lxm+POpZZ/noNWAvOHTSs19wCxgf+sUVeePjG5KDFiC9iW5wYFI60JssNcR9wrPDRfAfvYL9WeC/r7OOXXUUb13GeBt7Gl5Ra1OyY6gb4xg/tnxyXSDbVFfMeO7T8WAzURMhv8ojCPOhQQPN11WpLgfqXvYN7XJzb/1mnpF5iCKSTx+D6N44MU30SOlTVGC0uQnbPHa7E6rJrXu2MS7Ql6StCPRkktBayryFAI+PM30XANkXfbQeNUgIpPO43G3sJ02LLhDu3VxYzsRXWvn+g//B1VA3FiCGICpICLH6Hf2YubH4vHPePH72Il80OvDhRUOLx7lItIIdDKYLZ5/qEZFWbnw1haYMd/c+6GGZ0lASmepxvjbKp5f8uUoAR1VpAbFEtWHvdMjv9CyEU94yOlGtlNboKfxOhwuZ6XdiIDp5wt9e46YIUJepE+Q6EAsEouxFFek2+JdzK3crXiue/h+eWeJaIj5NGRPCkqvi/ZKnPhXdkv2q33mBa4HElpddz+l5XAoiJWQp/2fo9XFfxyvD2Jp1NiRi0RuadElADCg/j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(376002)(39840400004)(366004)(451199018)(6506007)(186003)(6512007)(66946007)(4326008)(86362001)(2906002)(66476007)(66556008)(4744005)(54906003)(41300700001)(8936002)(38100700002)(44832011)(8676002)(6916009)(36756003)(2616005)(7416002)(5660300002)(316002)(478600001)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uO2eo9mYBqg6zHJoWF3Mgvdd5pR39jxqeZ679r5JItnB6+RCnVzdzOp975OG?=
 =?us-ascii?Q?wb1bkRvMbrR4uA8ygIknRo7ytz++BMgkEBzQpcW+6C4ynbRCacd/6xCDI25J?=
 =?us-ascii?Q?zIBYLuOmgxdnK1SV97Td99jAmAMLC4JvtmMB8feTMm+WzDgrSJnY1l6SAS/B?=
 =?us-ascii?Q?+uoBp605b14fOdHflgZ7c2UWrWBNfGFtJMTVDvFReN8a2mNJUmPao6Qss2F5?=
 =?us-ascii?Q?FV7oEZ1pn6LfwH6e3kMgDrSp2nPsUinJOPqKAuSk75Gf8VkKE4U7y/Zevs2k?=
 =?us-ascii?Q?4NOMvH8tBYXDgCqE/g+pkmTDL3MXMrMP/nAsu+hElolnzP1mso+zePQUil2M?=
 =?us-ascii?Q?hiUGRPX2Yio29ERE4pa/E6GkjcScxIYG1gp6Cd8EVVZ/1SmQa7HFXK8P1IJT?=
 =?us-ascii?Q?gMWNV1fby22MbTfVYJVvXTnfQCJ5B1efb8UctO7mc9sg/fWft4UrTxGh9mvs?=
 =?us-ascii?Q?g6L9+KVFt6kMzjmxDe934tlZch72sijENRpIqkMNmUphdLR725NhSCo58Ugy?=
 =?us-ascii?Q?SNUCDdGWdtsAjBHCa/k0JbsLBwoyY5D2fGsl1MHBl3phYoT+du9G1kQjvwzB?=
 =?us-ascii?Q?zDJYvUPlrrZCVUhSVR6sQ4HNvVz+zeBEbPa4KCCdnOJwhCNaI+yZ9NUqVEr9?=
 =?us-ascii?Q?INpLPxhI+d9Egxeqgq/Tj5VBRXB9ECcSDrfyCbQOSjt+7nlacRqPP1JkInt9?=
 =?us-ascii?Q?GNNEEst6s6U8Ht6X5F48nS1tEKIkxl81xI/LQ8kZ3S5gESESDtPK3g3sWHuQ?=
 =?us-ascii?Q?vaTDYD+jDPUP6Bg7KroGW+GDdfih7T7evGwGWuLqGMGCFQnTI8P3m9xzwD3h?=
 =?us-ascii?Q?/dl3Lpw5tkZjAuaVvQ3PUceyj4w3e+mrwRjQT791QCxazBdJ5IvB9GoS9qC7?=
 =?us-ascii?Q?/KrLHwGM2AD5doRy1vzMQzAc9d3fRV8i92Fffo8AgAUZsAGxEY0/SA8jAbnZ?=
 =?us-ascii?Q?Mo0rdSU9yWp+1LDT+VmmB8A2OYXw8WGHrn8/k86Wfd5UH2nbi1uC67b2Knbz?=
 =?us-ascii?Q?2K4QZEPUmtTPrQ1F+69yaAMtk3Oa0L/ADjLFml5GG5C9iOAlFkjOaMVjzSds?=
 =?us-ascii?Q?k3N1t63l45JxsXYVC52oG5O1OvqBYI+ALCXmZ0K5k4ujYbVhnxm846whed6t?=
 =?us-ascii?Q?F16fPNLkBw6hVhoBL+Xgr0W3YLSLws44yEfJzpQ2L2CnjfVkAgsmLOBdIF3/?=
 =?us-ascii?Q?sPW4N05U0W6V7A4VkuQtYXHa04FbiOiYjx6lSjSNM1r6MlsDt6yp7wOFQPcY?=
 =?us-ascii?Q?D+TlyBIBvnBwfdBrT3eXFvtoucSJFAujVNqOPUXY3gH9W9+rhvR/WLSzah8X?=
 =?us-ascii?Q?T3Betf+8zwOraiqMbcaDFPyZ5EVf32i0AEFgXstHpi4u898isZ7e2MOjdBtm?=
 =?us-ascii?Q?9JpTY72+BVzWtqV+lo9IuUuuWB38j6qbwhKHHwXgDqwFt4Pkq3qhPMwOvlme?=
 =?us-ascii?Q?R2U4LVIqcTee5JFNRsBNfpGRooTIuwXII4vzxG9/YUO4RKzodNxyjoC541iC?=
 =?us-ascii?Q?Et1ZJodJPOd19c7x4/ba2A914ck0+MXBRiSTKx+GJUxU3Vg2sFFurxTBv049?=
 =?us-ascii?Q?J62gECBavcZnh+wi1Z1z86PWpmhtO+WZxgP215I9T0aM65QZhZ9cKORKh2ZZ?=
 =?us-ascii?Q?E74hOdwK7bkZkdmPjYEiaGgovosXKoZ0eYd9LgegpjuV+GAvWjJaTrKwU9ex?=
 =?us-ascii?Q?HsgTXw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2a4d3b-4433-4591-7b7b-08db045e0749
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 14:10:10.0937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xX4PcULyOd9Taeldaqx1hlOd4uwKPQGRyoxx3EpNtTW2fI67UJAPSwSCAnPGsNJyhl1sLJTXt/8ze01aosRGS8whCJlHfm6LqcpHM1y3boU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4990
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 03:07:02PM +0100, Simon Horman wrote:
> On Mon, Jan 30, 2023 at 07:31:36PM +0200, Vladimir Oltean wrote:
> > Some more logic will be added to mqprio offloading, so split that code
> > up from mqprio_init(), which is already large, and create a new
> > function, mqprio_enable_offload(), similar to taprio_enable_offload().
> > Also create the opposite function mqprio_disable_offload().
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Sorry, I hit the wrong button.
I meant:

Reviewed-by: Simon Horman <simon.horman@corigine.com>

