Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5EAB6555FE
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 00:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiLWXbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 18:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiLWXbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 18:31:39 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2100.outbound.protection.outlook.com [40.107.244.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CF710FCF
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 15:31:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0j29h17azxwQMq9VXgmgnbduOvTKBm7qYnkjjnNF7lrQcCIAyOkaCnzJsNfYRNmhNW9LnY8IToDklZg0g0LubGyLcSKg4uKZiluG/cwSC7BS6w2VM9wLv43nZthaWHeGZipaLf3zYO64PHGrGfIA87eFzM/OwArbLkpIKF65syTS9cxEVYfWmNPck0gQOVfYmYSxmnFkYKFTi78/i/X92RzXSvHN007ave8J1o6BTIRaeYu8QR9ty4tLuSx2hLQdMNGN2SIlp2q5tUy3GhXPtmOdWyarUd4UQMDoRA31EzFUcN4LzAsTbprvkFQqGT9YzthvV4n3l6cum0JjYJJ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=udXIeqoMRdO3MX2p6Tdw8FQ95ZbpVfgCFNMvMyvWBdU=;
 b=mJn8ACtb5WLThoimq7tFFcEehhXnmdRd8R4T8heUmZpJl2+76oboD3jCIz7+ucxSKTZHy0ecvrHpZnOJ4vIXkTKX9mAGSerlQhE2u4cxxNr/M4GZoTqaH3ADLUR4FtC2OrC8D4kH9ZznQacGha78UisKcYXSI2sz/Mb4DgqA84PMK4inYf3n6UEoAvK8slXGVVCEOLk2YTucj66kn2i+JyLvOe8gYiZZ9sP6zRuY4Ru+Iu7b3J5JZH58htkspOsNnonLUdiO/yoTucNQxS4ktl4KCqXy4IyNNaWnqqb62T4F1W5zM/f6MhV0JJEYS6LReOYXgv+l/tanGvxPFPZ6iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udXIeqoMRdO3MX2p6Tdw8FQ95ZbpVfgCFNMvMyvWBdU=;
 b=QwhLvYFSeIop/hWWe80N4X0aiemakcoWBq1Tdp4xVjqyd05O42fQyD9czXErO2SlaoRfR4AyGuxHbs1bTjmmAVdu0yGJ0Awxtdan0/M9OZ4FRm8WiyMsLSku5QrUOY0EOpl5WCp/kDwwgum2GfcWH+S61JR48iYbe3hQKOrCl8s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA1PR10MB5783.namprd10.prod.outlook.com
 (2603:10b6:806:23e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.13; Fri, 23 Dec
 2022 23:31:35 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.013; Fri, 23 Dec 2022
 23:31:35 +0000
Date:   Fri, 23 Dec 2022 15:31:32 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org
Subject: Re: Crosschip bridge functionality
Message-ID: <Y6Y6VDwAIPgZoJOJ@euler>
References: <Y6YDi0dtiKVezD8/@euler>
 <Y6YKBzDJfs8LP0ny@lunn.ch>
 <Y6YVhWSTg4zgQ6is@euler>
 <Y6YbPiI+pRjOQcxZ@lunn.ch>
 <Y6YtiwqJWyv3yW9r@euler>
 <Y6Yzp84WW1tQLdsB@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6Yzp84WW1tQLdsB@lunn.ch>
X-ClientProxiedBy: BYAPR11CA0047.namprd11.prod.outlook.com
 (2603:10b6:a03:80::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA1PR10MB5783:EE_
X-MS-Office365-Filtering-Correlation-Id: c95e951b-2391-4518-b919-08dae53dd4d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0kr1819zr34FdKqPMhnRimgj9+LydUEJLkpcR1+C6YgIAduJQWilkZGap1HgyzGHAiILqEqv2G0nwWxpybsvJsh3lnA5ATxP+RO2iHbWCf/jBudlK15D9zAlz+Sw5glJDh6hX2xpNp5iAugN+qGn1L7dlLnD8gFaVtbU0VfENJUhmqH0DCOu0EmXGcYZTj7DmeoC2ImvbgEeXzRF4XlWv3r5jtbXcXaV51RWbSTvXqBgDQdaVp5fDKtJO8NZAqwV480k2kQJDrYgjOigDiqx08FcvkOGrevupBPrDW4vRwxE169H4GvEqsItl7WF4dlwdGHg3M6mrLy+VY3Yg1T6nIeJ5uVXTaP3hMNl8i9IXeuYxxBco3o+IJKxldlUVIVor9GV0p+uMEMRyDytuJmWgINZvRDwnkD8D0v1FOSAkJ9tOSsYk4lYXDVVss6AxIVbu0CV6SvELA348R6TCjROzMsqVV9FaJAWmhEtyPOdZBhe527ohUnLhYx+stUFxOOl15GOfopiZVBVxouHQqdMM+WALGEi/APwZvh55VX2gzQ69yiUxOZjniWI/wK2TpkW1Qo9vOXqDDSkLKCa8bsUMltcrUm4YKpwGcGPkUi7utj0Fa0G2lwaDHSCPNsP+ZH/DG4MUULYwve7eXgvKNd5Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(39830400003)(346002)(396003)(376002)(136003)(451199015)(54906003)(6916009)(316002)(38100700002)(66556008)(66476007)(8936002)(66946007)(7116003)(8676002)(4326008)(41300700001)(9686003)(6512007)(26005)(186003)(86362001)(3480700007)(33716001)(478600001)(558084003)(6486002)(6506007)(6666004)(2906002)(5660300002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OiRvZRB4f0O8Wi1/Gnr7Uo0bNcDEE/WBNw+75sK936rNWXu/HcNtP1mRzvwA?=
 =?us-ascii?Q?4aHA+kizqYdAIBnuItPblXul+cT0bRFky9bcHacuSzf43Iv/ElcnydGWGPE+?=
 =?us-ascii?Q?CYcPBCYkR77AvpUEX/cppBCQjXx7ATC5wZoPZAgmtvQYKyHF1ty9ed1SudIN?=
 =?us-ascii?Q?j9K/doNVdm1DIXn5+idAR3KfoWbhh3bixz6JDk1LOJxlNPzvfiUHnHml3nrY?=
 =?us-ascii?Q?c1uRVK8e1V3/rUI6Hh9Hh4707o1FUUlZXCUn/lTvnDLJ0V7bxpBgGKBMMkj4?=
 =?us-ascii?Q?yekX9a4F6gvWcGGTEu9ZCxK0QMJhUxya3ILxXlk3URtbpeQoNaKoDx5qhEYn?=
 =?us-ascii?Q?WBIM2oxYjAWZRTTwGfLVsC1atNxnsb6b6MLp8jMMyqp03mlV1SUnSJGPSJqf?=
 =?us-ascii?Q?Ve7MBqRUYvhqfNNwyVkkhORNZ6Mh9nvJJcRyjni9UXZOJOud6s5CVm6lHFj0?=
 =?us-ascii?Q?Iuuktj4kF78Kx/DxgHLCQFFqEEzgasB2KoKo3XqSUW7THlk+fxDUBeV13R9f?=
 =?us-ascii?Q?6o5rT9GXyfRfAXdBY3HljEr+26+3/Ug6BBfb8vlmi6V/SE021dSg7bc/kk9O?=
 =?us-ascii?Q?S2t1zti6P5wyWFaWc/HrcmvULfFZ1Wtb15FSXBF/ZQDTJWb6DNvV++dw8GEY?=
 =?us-ascii?Q?fUQkEdm3YY2sh/zf8Z+sExK0p6helVzjPIZUuxdn37AZ85g03i8EHnL96NC9?=
 =?us-ascii?Q?rpW1dqbhIDleIRePEHM5zH5E/Cycnr43NQxCaE5Ilo8MMOc7Y7oyDckVwtdR?=
 =?us-ascii?Q?5VMlM54L7wy8uK3ch7kDVj0/FHxCLdOq58qEEgmcPd/QzY5p2L4MXOV9kxbY?=
 =?us-ascii?Q?kj8kOuAbdMmNjjIyQMdsNPfqPwOsu0YXPna1YqpjnVDxjE0zIG1ujrYoOyV6?=
 =?us-ascii?Q?fvA+3lYtoZciWNktLfX+XKAILfcnGuvGLkQNCp5lcTnnHjf6j6fBfBWmM7gI?=
 =?us-ascii?Q?+SpvYxvNIGAWvsxw0Pyu34eVsLm+x/0YBvIu0Obro36wCPxDU4hZbzai965/?=
 =?us-ascii?Q?XSXJIXR/06C6pPQxNuAYbTb2Eax2O88mepLoYbUMzh107Pl8uVciSGCG8dS8?=
 =?us-ascii?Q?Rp7d0ZiIcyHJAgPEJJ68H7hGh8vmIBYIvvLn8fPhzb2RNtkh7GnGrofYjDEc?=
 =?us-ascii?Q?NLKEQHcBOr6pFv4qZREJsIIZ2lcnt/ymOChZX2A/IbY40DvauaksSevDXjnm?=
 =?us-ascii?Q?rwKqUsnicPxr8T5h4wqATwh1AOnN66JEpE276joKOrRwJsc3erBryI3v0Hxk?=
 =?us-ascii?Q?BwRtPhAcSxQMeuGaEIJUZUCawb+0HOreF4MSkqkUnlmz3jQzZdSg1xkBABJ7?=
 =?us-ascii?Q?+5s/eZF2uDlKmoMRgRkXArm+7edndhdfW3yLP6TpK3+nyBorxHPXjYYwS4FQ?=
 =?us-ascii?Q?TJQ6aePsk+yO5AYzQk6tMPdXjKMH1rpdjZ2rFwpQ6H4OD1xopN4r53CwJzTm?=
 =?us-ascii?Q?kBm331XICNfp7tojWzHB4+mCuD16DblzOHErNWVH899heCZkIlIABb4zSp7G?=
 =?us-ascii?Q?hhpJq5FN4LQ2TDMb9hQFR3E3Xrgm/F3aj31pMwDzA5sJUqCXzmPLaVRegRgS?=
 =?us-ascii?Q?q+5GpRL1F2hBMQVXItywGGifxMCL9Vk92JQGerHo19XzGFxPvTswI0NQkiZv?=
 =?us-ascii?Q?KuIuYHOZNJ4kQWAR6XA5Y1E=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95e951b-2391-4518-b919-08dae53dd4d2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2022 23:31:35.4254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vg5+im4wdCXGEhRCLaPE7jbMk0mtQUubd7kezRh/zjPT+Q1vIknAHCw3ddhd1t3a5DB5vhWgWEE+fDyxDiVAEKEMQTIbtg8Y62vGofrhviU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5783
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 24, 2022 at 12:03:03AM +0100, Andrew Lunn wrote:
> You might want get hold of a Turris Mox system, with a few different
> cards in it. That will give you a Marvell D in DSA system to play
> with. And your system seems quite similar in some ways.

Indeed I do. Thanks Andrew!

