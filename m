Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575456364E2
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbiKWPzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238939AbiKWPzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:55:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2138.outbound.protection.outlook.com [40.107.93.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A329095B8
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:54:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwWOaEna64uKxNGqJbR2/7tnVGzkMf35Ld+Z6o7tvGN0IG8oPFa9ECmlz/G53hX43EOyXqurZ/rleOSi6tJJzs8MHS7+W1HF6VxKtM/5CGm1X0qPU7VRWmuo7oe47V+oCFrG1bj+UVZzLISGaZBFMXhop9cYA6K00nkVRAQYHCBQSE2o6Hvas8F71/Gm13m5nXLVLPYrlskmYVfszEK9IqVuV4L+03uOqnjMIVh1qsmgRkhUXHJpKY6JMANCqFT/slVBseROY3NOsFnmxZ+fxSD4EllUo1UBbceDDatiEWgWSIgVO47S2gKpum1/ajoRgpxqu5lwn6ggM5rhilQK6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEDoCY6OR3zOoysjpmfdLT0N1bgr3IvOcHZR956dZLo=;
 b=HLG87qp/reKxhKQ0C6NY2Z7eIXms3GT/+bbXzrDZ29NWw7+6SERjNfX/o/fd0HfzTxSBiYO7ea5ytZVkItel3LScBENpk1ZGTi6NJFd5RYKfQFoUcAIJG51hVeDrEGGrevRdtD8NYqobPeoXuAPIIn7zGewSeG2Jp9/1OclD7uwA7/HESi/aa7Sg/Shk34AZ2pey6KvoJbWVw8+MLCXvzWpg3scwJZpmN2ezNTUaAU7Sk1rD2BxBYPpW0iWD9F/A2EYx/EZUBUJp1d3Xov5jU6F+TVstC8vF3k+3wdJFTRieLPozSrkm9hkASPS4w2LmlBENeShLLMqPa8O47sYB3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEDoCY6OR3zOoysjpmfdLT0N1bgr3IvOcHZR956dZLo=;
 b=nTcJyX/7iEPdC31pyM6zFAYDXV06NueW9sR57NcUIepRdx62f2LnPlocmxNaqi68RVok1e0Kn/B8JhqUm3ICSpkkU2KBN3M6+wgl9d+u61voP2WA4TJ/D2S3Vnc8y6r7AkRTgRJkn7LpmF97yJhiwGYVeXe+URS6+vh4qKVtpiM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5627.namprd13.prod.outlook.com (2603:10b6:303:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Wed, 23 Nov
 2022 15:54:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 15:54:12 +0000
Date:   Wed, 23 Nov 2022 16:54:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Lai Peter Jun Ann <jun.ann.lai@intel.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH iproute2-next v1] tc_util: Change datatype for maj to
 avoid overflow issue
Message-ID: <Y35CHrnLRhsVis29@corigine.com>
References: <1668997749-5942-1-git-send-email-jun.ann.lai@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668997749-5942-1-git-send-email-jun.ann.lai@intel.com>
X-ClientProxiedBy: AM4PR05CA0004.eurprd05.prod.outlook.com (2603:10a6:205::17)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5627:EE_
X-MS-Office365-Filtering-Correlation-Id: b037dec0-b306-4c28-25a4-08dacd6af74f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dd9gcVDNy83P/915kvo13Kv7gsQgyAf7iHWJYfSW5IlTyR6P2OoHtdZ+Dg5VNTww0kVPpa2pzduBBrpaZBGz2UeuxlrPIZuTDZuLHF/Cq5NDJr7k6FJTtP3jMn8nwJsYt1P9TvDt3tHozPeOgoQXRxKiocjxy5qWAdm8wXyVUIVC/WGtcNtShAB3PnZrv13y0FHZEopvlygEU4dcXKrqk1ADM+gojkTqkNLM5KjQEzw0NdWvFmr0oTTZdDHG0vM5WjAOXuzCx6/Z/5L3mkmVWD7OgFBdsyw9FsKTLB0+6C1Ds+VG7tmnExBaefJwjH3SmX79kggzLO93Mt1SVJjWt2nSfZBjwITumsAHLkJXuXbLcdla1tStcaFKDPHCel3Nuyo1qEfcqSR1/cSS6vurhzneobru1RlMumcZiQIqZ4pXhufKhLaNqeCwFraHxsPlzrVZxPl3JGoKusldjg2WSVuafJaVxhFWcwzokatpqzuqZZhZFU3kc+ejHX8g6f1/EC9z+H3Qq+zlRYtfAQx/YgW6zMNX+zNxmB8BMXb0YgiJvCXc+zD9iMMbgfDZY7aV/WydaPOSJapySIYSBZOdP7Z1oN79KcZIDEh2xDZHGorEEVVdcJpyPfaN/JcfcPmaU0iNmFqqgF9UwCfwRkNi61CxagcOiq00NbfC+2mJ5cpSYW+5mUKahPOdLZxPfjaQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(366004)(346002)(39840400004)(451199015)(8676002)(66556008)(66476007)(38100700002)(4326008)(66946007)(5660300002)(44832011)(41300700001)(2906002)(8936002)(36756003)(86362001)(4744005)(478600001)(966005)(6486002)(54906003)(6916009)(316002)(186003)(2616005)(6666004)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SWeEjsqU7o4NyOHpkEVNO5PrbhWaCbnfmsixEZu7eMdHNkL6r24CVgOR5Hhw?=
 =?us-ascii?Q?8Z//FdMtBZ2As0aIgR4/yDUJT07A4O7P8HQNt8QUcCy6/q8EjDORaBrlkgKI?=
 =?us-ascii?Q?855PzkHXGvh3bQceit0/d44zfsQLdGUYTT9dUNgrplnI8CL6ZYcVvQ+T1CgP?=
 =?us-ascii?Q?5DJpgsXrfEbw4vxqWVBFiLMUoGGY5Yzzd1GL1cBMajOIJGTxdaxfY9d7flio?=
 =?us-ascii?Q?Ro8mFQmjo4niiZ1Eg3S1P7TTGwc7xA0YnQWtoYkPa0Bx92pQXh+eT/frU6Bx?=
 =?us-ascii?Q?Y9IBiJDrvuaygoBh+Uaj4a4EnVPZ4vJsYX45OCug0ewJ4v1awXUkM1fgLu+4?=
 =?us-ascii?Q?QkV1MoLW9ZoQgYfXG+YXYqcSpAMSYr5NaZwWHfMdpl4BNGzGxgEa7exLtUFr?=
 =?us-ascii?Q?UOIUnLsbOSYZ77xXfsJb/fv8ZTEu57hFvS3D2z24RG65wXrWxzdgP8h5aHR5?=
 =?us-ascii?Q?5Wv4xqVn9TwwfaULJhM2zdsIKEm3fcGuRvfjN1FwdlXrd79yOSp24vrif/xt?=
 =?us-ascii?Q?RQksNr2nSce8nxXSA3zH852H7nJPR6QbZkvnQcaUqb1LQ2hhASn/lhQXDMzP?=
 =?us-ascii?Q?UHLGLqAnVanofRC26JYv2/hFkQaGfmh4KFYOiyg2jfOZSdrhdQKNEsIgHuRj?=
 =?us-ascii?Q?hJ5J9jaAeBHMt+5NdOKLOND1C3KEkw7UJ84QCFgbmwM9McY4RwkpGIK39xu8?=
 =?us-ascii?Q?GgxtuXCgdZYPcgYnaNBoueZvEYdvWJOYnePJW4yi1q6Bu2NBWnLf7V2TM/xt?=
 =?us-ascii?Q?8LB42+2qBUz1enaPvwCXMbB7cZj66nnOSBEuZHIYrPXiWwVkyp01NSKPACxK?=
 =?us-ascii?Q?nln3ygyRySF8qSCK1SKjxorFLLh/M8nBEIRB0tW5p/k0dz8gyEleo75EEo41?=
 =?us-ascii?Q?DoUWKJliuiwvafFEaezkbcIEaT812GQpRL6OxjeXcyVaGwFYlj79q3wmTtfF?=
 =?us-ascii?Q?HRnLMHDYHFpROOGTXtHaHfPP0AHWbS8OJx6v36DnVsWIjQN+DcjFOXM4S4m5?=
 =?us-ascii?Q?Oxn/flot/BoZ5g2PCpYQWCdMXEi/DTm4ExTPHUU0sfUdoPEsh//RZHi/iiBx?=
 =?us-ascii?Q?Qf/KphB5tdgS8oAq41ymq8T7AZ4iXhEzVVQF7fsl679Qv5ISBGcBKXhMhW0B?=
 =?us-ascii?Q?gn5mUpbiyk0saf5wE966ieaYFy0YB+ZAlvvU2vizfwIwjdvrAUyc4YH+7VPA?=
 =?us-ascii?Q?xTn5l1OT8S+oIthOIlctHVQ5bV/YU1uAJk5zYtnxVBAPJMCzCZvchkoUaLKA?=
 =?us-ascii?Q?jKfdLPd1yvoXJNu0p42Kz+46G3GFuJkqptdYhR/Z5mqX4g4RDf/tkrhqh51E?=
 =?us-ascii?Q?wIxxMWxOqpBzmidnhdoCulOUbuxDQLmooYf1pfgHKEAjFJT58hUS9h0EJuMQ?=
 =?us-ascii?Q?twL6xT0Imwi+Xahx7cYxANU+jeJAPcmQnVjiCGk3prTcukAl7TU9u4va/kzV?=
 =?us-ascii?Q?jyf03Pg1Lv0KBgXjsB2l9tcJj/NAfvSge6Rqhf9APWdq5+5Gf3mmmoPJDhrn?=
 =?us-ascii?Q?LLXUSA6rKRE16Hengji7JShagMuM2Nzo/tG1/Srxqw/TfJ7S17Qg7jTrd18l?=
 =?us-ascii?Q?jkmBz5PC9sI3RbEWFHPVfmnOuAwSuc1FlgIG8GQ49h+j87krgQ49zJJi4TbK?=
 =?us-ascii?Q?KxjoUWl/Zfz6fAulcqcFH0zIFsHRcf5ZWHDSs20nnzvXEDe/ASUAduqcFG0W?=
 =?us-ascii?Q?bZv1gA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b037dec0-b306-4c28-25a4-08dacd6af74f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 15:54:12.6826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4NbiTVAuJGecRgBgkdkw5NVz40fJRP92/SlyHYlpr3a4HWHS2tn7fVLIZOt/4DhnGDBe6nALG3Q95bFJ6XUpQZznoJVQbJ8AtQ2gb0Xgzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5627
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 10:29:09AM +0800, Lai Peter Jun Ann wrote:
> [You don't often get email from jun.ann.lai@intel.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> The return value by stroul() is unsigned long int. Hence the datatype
> for maj should defined as unsigned long to avoid overflow issue.
> 
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Signed-off-by: Lai Peter Jun Ann <jun.ann.lai@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
