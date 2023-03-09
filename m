Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01046B2584
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCINdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjCINdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:33:54 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2112.outbound.protection.outlook.com [40.107.92.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849A36920F
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 05:33:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaPtWgICByVJVDrs9n1DJIrGe700k54lAAaZMQRFB7HvsQdkxzwb7Bz2DT0BCoPXv20EJyDMAIs+o4dufMJokiFJ1X93YwRsYt9eRoJ8wBBpO30hoLdHQPZaX7PmuIxIuxlsUTnJHINgnF9tYJSP1DifDoVxI9DzIDNCtEesXH4xCXUmsREBLXCfRq3gYVnNLgrclPpAi5DMwcrtTxoaC95FJmD9WCqqDY3RXLmXCgZErC9zkt/B0s/eIJtiQQBYJ2rR2/zSWTqIWD5iGl2jCjNz5KhOr3Rv/sqfR+cc1cXRTgUhTZlvtsAdb1Npf/vKAgF2KDhKuLgJJcyqE+7SSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lmwjCr8IZTH7JD4vPXlDXUCzTfJg7ereKnW2kPLrwY=;
 b=aCJQSBFQr782pdtK2hs3AA384luWwjf8ckVojPGKXZo9oE4qZkQZ7M0nLFUWg4bsHY73GG4MQIkhpV3OoFLfgpX9BP2Mt2qhipR88UXBoNPc00ZUkVPgVkIIkBRVXP20+FlXvoJfDPdwnz4cuGto+M2f8aU+x+NrEoteNzulPo3HSBBsOn8GDN0tanxQ0Z9rUYcIZHJlZd4svQ8Zc/WrVvm1hvy8G0mJSov9RJT6tt5vDJcj3WILfsqQ7imHY8gBBc1J8Wy91OrDAh9Ve+q6bQN1k8tuUAGJPpjrmWvhneJJ6/eN/gT11E9nHJEJmT1NCw2heptB45xTLbekFNEOVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lmwjCr8IZTH7JD4vPXlDXUCzTfJg7ereKnW2kPLrwY=;
 b=dByinjacWhiXEAidK5k5Y+WLzl2EKKEkehTBVWF0SGM7kXQYlaYyEj4KZl8CHrrIS5L8ilGnZ5/blxM8Vpq+nqS08VvB9I1eKOWNldRqjrMXxIEnhNmzY1YySXK4HC3Jnt6GKGCiL8R/4u8T3egqHnYwO9h75x6BlM761nnMF3w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5925.namprd13.prod.outlook.com (2603:10b6:303:1c8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 13:33:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 13:33:44 +0000
Date:   Thu, 9 Mar 2023 14:33:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>
Subject: Re: [PATCH net-next v2 2/2] skbuff: Add likely to skb pointer in
 build_skb()
Message-ID: <ZAngMiF+G9agDf+M@corigine.com>
References: <20230308131720.2103611-1-gal@nvidia.com>
 <20230308131720.2103611-3-gal@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308131720.2103611-3-gal@nvidia.com>
X-ClientProxiedBy: AS4P192CA0021.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5925:EE_
X-MS-Office365-Filtering-Correlation-Id: d7bdc598-fe22-4f94-5b97-08db20a2e78f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NMApr2kThIVDA391FvyoG9usYm/X9s3QwmH5j4O10eiE4kEuZyvir8ZrWlKgoH8IIWPoTHgXg908Ry6Cw1V3PAwvCCT7ITxCcwViRnU71hFDQndP8t0Fewk1cUPuyUF/xytzhic3NAvJyNoFGUfbPujTCLwVMEm9XQePdVW/XShY6RZ5ZwkAFJXRD9XQOm9EOFktn3qbsvMpn5it8gtl5pslfvT/eKxWm8aAMsDwZoo42gPhTISvBU3e0PMaJIUZtCD1g2ei0A/vks0x8Ps/9ON1oMHJRrSGi/Hh2tebuVO3jBfwNlQ37ZwvFCeePQoiETTMY4nFWxL6j58b+19HqXOP23Azr+Kn7tPu1etvMuSaet2LirbazG8ym5blckKSXf6/2Ek4E+V3auj3g5eK2csXcjLa4ejAtDgqDrYz95PdbWbK4G4v+oirdfn08dlWfEqJBRFWDjtXXaYi1sSC97v5UF6k2r5a45G4vmAWeRUF6Q6vfL32z6Mj9+V/1Hh7kR2xkaiDJv7N6jZ1okqUlVWCv2V6+lYCVlbzGiKUquiMS4g5YHPsDWpGYak6ngu0o09LBXwnIE9VV+BYFnyazxOae6lyatXTndu5vqvKkbHNwZjBURBOWLa1NLyEjFAjkM1lHVkPuZ1SJbWlplowTYacwDXaak7olpoG/R6gY8LzE0M0BJSB7X/RcIypMD98
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(376002)(39840400004)(366004)(451199018)(2906002)(44832011)(5660300002)(4744005)(8936002)(36756003)(41300700001)(66476007)(66556008)(66946007)(4326008)(8676002)(6916009)(316002)(86362001)(54906003)(478600001)(6486002)(6666004)(38100700002)(6506007)(6512007)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?erAbWcJTXzN8S+YWZDH5xTAiB9Dxe69NI8d7Tnf824TMnvcmUaYoiyVs7WYQ?=
 =?us-ascii?Q?Y2DUny0fqOnFyvvHuQBx/NF55ozgwo3H2M4WaxqWb7GqHlMk0HQlVt7w+gD3?=
 =?us-ascii?Q?QdsCcqqbO4U09491e+U1QK8I0h1jryP9ps39wGGHy7SSJVR4oCIRnIi66sCu?=
 =?us-ascii?Q?9yp9lF6lHX7uz0/LRgMzy98/s1w8eH/yZuAq4onYgrgYZM1uYo/Le6dLe1IQ?=
 =?us-ascii?Q?Csp7OJUECEcFOTnKp15eCRmT48nqzUF8/1LTRmiz8+54tiOENyvIm5onzPyD?=
 =?us-ascii?Q?ombNlUWM3h5eKDh0LLrGJMt/yFB0xplPL6OUPyOk0Uev1CSiY+oeCE2du36w?=
 =?us-ascii?Q?aKTyDQyjhXfzFIGJXoteZKtXYjKGzeoEwip0pH5NtyNIyobmuKVQQuDiaYbF?=
 =?us-ascii?Q?BYZDjpHuH+8Ux5h0CqUFCmMhRUrqNBdIOzDUpAsHU2EdVeo1eQbK+nWuIheB?=
 =?us-ascii?Q?JQOV7FfhJNOuaRdGhFpEiD7E5wbkOqF0JDZfRiXyfHEA2Z/ySWOK+1Gbqqr2?=
 =?us-ascii?Q?vDYmHzMTEPvnBceKjUPdcOAZQHUdAqiJsBD1PMPJCzmhkHMvZBoR6UegSR6d?=
 =?us-ascii?Q?IVTGvhavxPZ2rRA5umUaa1cZ/BwIN9cGj3Xtlm1kKBO3U+vbzZrRS2lg/skD?=
 =?us-ascii?Q?kQaUyIRD3UlFDGBI+xs2w8Hn5sBBlUQDTzPtPu8Yb8a61khWpf+xMk3K660U?=
 =?us-ascii?Q?ElCfYDNakA/JFjdkpfLJJwdtOmtW3S3PaQV/wGDFxKrb/ehsVsGm8lPqwAE/?=
 =?us-ascii?Q?q9TiPhNLfsDlsNATOhA5FTM09ZMouR/nbJccySJvdbZcsT1jUWvF8m1+6hrC?=
 =?us-ascii?Q?kFTpnHIG5hIyJ5K2ZbDrT+F3FT/NNPeDMtAUJd89GlVO8ia3dAfQwGlWfFYQ?=
 =?us-ascii?Q?qbF+EumzTNAJaITtPXCNugX7f5+GreyDSb+fRjmuTT1DUJ3K10ZGxnrqd57V?=
 =?us-ascii?Q?88/YwjYQPD9wSHtjjMow9V9bUe63rMiUcenDrZCanfJmtZheKFfJcZFLgY8B?=
 =?us-ascii?Q?2W3CAm6Jbdt5tqge1lvGZL1LknaqSmh1fdKxC7qDnjmG8B9MixpW2oPPW50w?=
 =?us-ascii?Q?GFhgnDOYfJuq9aNhaILlfJOhoVAUqxrG+DfHfuy+kgwm1hBdjTrStjt5fYau?=
 =?us-ascii?Q?V6LeNhC82pwNPobw+xlLUix453ctwIHA2S1O+PwVI+OTEEyDlToJbNKPsivV?=
 =?us-ascii?Q?h3vAHdFUo093znVxzpfPz74Cg26hASNWwHP4UuCL0DTBd3Yr8XJzRPGa2cRc?=
 =?us-ascii?Q?BKr9q8XUJrZO1Gt9GKW7L/L6m0zcEfNRiwqmwncVelOj92W6qH3pVReVfVsR?=
 =?us-ascii?Q?elYwTfiahgVWQfBhJD56edr1wC+r+U5kqAuQZRlgVueuVaRFptnWnXhKh9sd?=
 =?us-ascii?Q?dZmjPRy3ZS/ImpYQtoINDRmDiOCWpBpPWqDTazO1RTVa+tRQCpKPIIkWVpBJ?=
 =?us-ascii?Q?gMxvMp0SziK6xFSgnOKAJWrTQLUGZMd4JRL4SjfmPqoSxrNLI62Zn4K77kQs?=
 =?us-ascii?Q?sdpzE44oYcz0f75HcXkTQvOokbh5PtxTCZA1XIoOQ8ymcM6WjL7qXYnfAFSL?=
 =?us-ascii?Q?bFanZhpTUHJfp0el7ZFkqWD3lRGe9gkxkmtMb33vHNtjyEBjzFNc2FcKY/XH?=
 =?us-ascii?Q?hie5a8EGMaxL5j7DMdjyjrg4+i1Avj+b3EGHmtopON7VdpUPb4RJ/ZDbUJZn?=
 =?us-ascii?Q?Ra9rDg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7bdc598-fe22-4f94-5b97-08db20a2e78f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 13:33:44.6185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QBP4RMf+cdUAk3wDzhqKGzSrl4AediYvGnchHDoYdGDjsvqWs7QwgjlyulIp1MIhU5lWLPH9vtbqQs8JNr/2/r1qGcSsFriZo5DloUcoE90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5925
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 03:17:20PM +0200, Gal Pressman wrote:
> Similarly to napi_build_skb(), it is likely the skb allocation in
> build_skb() succeeded. frag_size != 0 is also likely, as stated in
> __build_skb_around().
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

