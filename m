Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BB769C8AC
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjBTKgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjBTKga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:36:30 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2133.outbound.protection.outlook.com [40.107.243.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB1193FF;
        Mon, 20 Feb 2023 02:36:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIp6E/EX7KJk7xqPYIqOIDwzgPiZ+1P4BYioljBwC3/zhSeoJ2/e0MBLoCQSpEV3CCAtaf/QkViSDNdaKzoIPGiQA6dkhBEvtwQ852WuPw8kWoT3cKEC/Rtm+NMZuq4unHZG+GeU5115+TruVSqW0oZnqe3t1aeTVam0pC5D5yncvlxr41U2ZHux8Tq0D46HpAlzPO1lNOk1SGAwrNPb1TmQUOnIPT3dI4IybwIu/s516i+LqHcOk+XYaRq85XvIlPGVCLd8KUyrM8MqR/p1EhZavYC6Hcof6HivtzaBICORKzBCfCSEBXr6/1GcBgl7nm9x1LKqjfNYD5Mz+y/N9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkCiAmxQWUkVd9IhlUFXCaCD709HtTEByE4WVc5LNLw=;
 b=lTOm7O/JrPJIko6iiQr/rZiJ9locas2oJdRDvpKZ428zXI6tlZGspRDt79oIM34b9JNeJP6rEK5X997K/xBL8dqp15KX/E57iIjq6e2jpELsgd1mEVOI2OVSr6uBiXOH9BQ3keg6K339gRig+Q++kYpQ8bse3+tZerXPmlPwCYDHTn3JqZ6FulML5gBTF2OVL/634IZiSoXFsc1AJCwpodAFho89JSM8KnVNnr6RwLhKOGMsghG6b2hFaJbUAX3dTT+gs6S0GWNww9Hkh41yhszdY5XhY1rcaw/erumazDsrpglT4NAq+fXDPVbg5QAPkRXOGLTEqsYL/w0lm8AU7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkCiAmxQWUkVd9IhlUFXCaCD709HtTEByE4WVc5LNLw=;
 b=obqEJLoF41r9/wlH8lvbb6mHePMcp1jG/ORLKDYnIKRhnMCTHpksj5Q4rKNDDzkMG6B0eOkYizQAxHQYbMsefgXCGM7LP5UVHe/SXmK+nw08R7NB0WiTEBdoema9hu3VwhsIteKNVyiNmvtdWN+5EueisGysx6WGN83WicSuPcY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4087.namprd13.prod.outlook.com (2603:10b6:208:263::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 10:36:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 10:36:27 +0000
Date:   Mon, 20 Feb 2023 11:36:20 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v3 net-next] sfc: fix ia64 builds without CONFIG_RTC_LIB
Message-ID: <Y/NNJHbIo8oTk5eO@corigine.com>
References: <20230218005620.31221-1-alejandro.lucero-palau@amd.com>
 <Y/IjIlQSaX6iSmWc@corigine.com>
 <DM6PR12MB4202E745A9383463723518E1C1A49@DM6PR12MB4202.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB4202E745A9383463723518E1C1A49@DM6PR12MB4202.namprd12.prod.outlook.com>
X-ClientProxiedBy: AS4P250CA0011.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4087:EE_
X-MS-Office365-Filtering-Correlation-Id: d1ec6bfd-a9a2-4853-8427-08db132e5245
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SzEnkPfD5yph6d6k/d/WIIOA9un5PexHcQJc70Zq1yXSKr9ELll1j2Xkx8Cf2fkPC1HXk5REL1zrHXcnE6XryLRxoLCvVF2FDb8NnKowfXWUdh5cZPdhgnnCZTV34hR2qU6Jn/26cOP7+VL/vrk4OOf+QrTMB5Ur2qnSChAuRwyf0YrayW658Wp2FmW2m+ABomyrNtftnHVDI8J2TCmj2rd7FxDRlmW7f6AvI8cyNUPOfHBX1b3xZbp0vxexeVDPlScey4cVlr5e+iu3QmIoKFjmkAF35l/a+rFH7FRKhVYvGI3UFmwQU6cYd4bG7udyOuBHjbSLA9f3ZfbKWtVCBRjBOArI4Tah2wp5kWAaHO6X+kdPzxxRgfDM9N0xs5Kz8Zs3o+tLDLB6/1/jDWw7cTX28BZeTG6aIVisGudZ9p5lyEDrTNtSbsQ38ppDtfSDjLz4AQvpXd/C+YVjF3/yUIyBpRUci18ohWmrRLx338XJIWnmjOT/+LZfuOuQ1XgjcVufBWHQ2VsnbH8So9VUe7SW4j2dPsz3SgLwRDP3CtBl0kf2+aHbAyAvhvafldoJfqJglFYqXTjE6lBWGSe5t4DvgaXDGUgEl6MQQ3HttYZTdRSbrijWaR3ZC3npnq4+96gCPe9MTv0YfLRKv9KFnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(39840400004)(346002)(396003)(451199018)(38100700002)(2906002)(6512007)(186003)(41300700001)(44832011)(6666004)(6506007)(53546011)(5660300002)(7416002)(2616005)(8936002)(478600001)(316002)(6486002)(66946007)(66556008)(86362001)(66476007)(6916009)(4326008)(8676002)(36756003)(54906003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wf4oX47A4RvDg62gYjLyFAaqJfHGYyjhrNkMA+l+oQTnfuzVSuE8dK4OtT/h?=
 =?us-ascii?Q?zR6GFBhu45nht7gmH4UcJHlE7Bh1ji394BIxMmDnVQmpeYACoRGe91zKtzrm?=
 =?us-ascii?Q?orHhjlS/aU6fQdIj8WcHuPAAgvNmE7KbTHLq/IrM51G86KqubqkVI15x01QU?=
 =?us-ascii?Q?xYh09NKvR9oa94KyL5a+C5h9UGMyBkU1/xeo24/xc6FTeEu+R/6HQScEHfCn?=
 =?us-ascii?Q?2hNJCKJfCaMfgDhUKzgex8mPFrWFR4aUAgYrYNXYFYivuJUGRsNW1rj6uRke?=
 =?us-ascii?Q?veURlLn7NWgYcK0q9qc7dtjnjtKFlu4Zs3P16R195keIIgLkULwh3VLoiuhM?=
 =?us-ascii?Q?pRAhLFftRVffKuwfQYo2fpQqojngpwgsx3L2TpjiOgwdZ+s0eBSjZ77JycwY?=
 =?us-ascii?Q?M6jMIJpgI2e8xk512cQUl/t9AwEB+rjRgBBK7iKRkwRBkB2EQFhuAzYXaE9M?=
 =?us-ascii?Q?Cq+hyi3Iyk+4u0S9DMQ6d6F+egQIcNujH+H8XEDVJrcfx/RY248RY7IxEVHJ?=
 =?us-ascii?Q?gCw9XynqGTvzG5aN2bkiufjVAhB0hiXZsuTVADn5txBWTry5voNQfLzAu07f?=
 =?us-ascii?Q?f1bIjovoHK4Av2SC84a72ke+nmkFJFROZm9xztzbzgElkuXUMXd14xetulWf?=
 =?us-ascii?Q?92o4PLJJ+Ql9QfyLG37FFC1CJ9jd1lGZakrlORg1BWYa5BKssyVAvVuleYXV?=
 =?us-ascii?Q?BROnJ5D1w4+Oj2QpneV6ukC1w9YvmMAa4FbfGBKVUmoXsMq8FwJ+7Xg0edXz?=
 =?us-ascii?Q?98YeHE/RAqc/q6Zfp1OT3hDzzDcJ2UVBLygEDJfv2IplVQLTFhaIvuLRX/QH?=
 =?us-ascii?Q?1PxZCtb20ViG05Gaxa+wlgxubuaIUzZeSVK06h6WpLwx/h2e3KR787zW4B2o?=
 =?us-ascii?Q?zF0BoY9A/YIhAz8LSJPDhNVIWdTkMTFKAw5tSYoXxrj9U3rfuseqH86k/zLh?=
 =?us-ascii?Q?KWzFPQWkPxRy21DCk44/1BM3wFTCxpu97ls9hGsbrMUx6jK7BCwmxK+uehnO?=
 =?us-ascii?Q?U5w7p+p0/pCelb0neLBD1pi8VUZoKo27sz1iqn7yglQiZKzqju9OUmjJzKmC?=
 =?us-ascii?Q?yr5zJPST+EnRt8TI3WMsAPvrVdU2kPNoWpbmaZLwniZ3HyfWAkOja6FKQBhM?=
 =?us-ascii?Q?J5GGzXoJMnF7hgM8dLzwgFoLqxanAEHH5GnzPB6b1ODZ+kFJqkyXU6h7l+av?=
 =?us-ascii?Q?mQO6oN4ghPRYEIKwsy1JUAkRqt5jOnXPkSEGi2IGOZoWAyovDaPviR7tvMDK?=
 =?us-ascii?Q?u0Z3jul+adEWHkW+aj6w9rwJxalmtCT17D4TeW7FgNv9IfoBWnpdoFNqzhbx?=
 =?us-ascii?Q?agp0ApUI/fZW7zbbTG30zOOz51DDUcvobxU0ka48C9b2+RltLvN+v2ukX+Fl?=
 =?us-ascii?Q?0AoWHhGjs9KRv6j+8U0Swat6UosJnqJ18CW6VEBULEkYkfMZXlUH6SavVpsi?=
 =?us-ascii?Q?AqPzZUGy+1TL6Q6g9ZxmiUzvL6LCVyQMcKujSsL0qQL1giD5ZJX5n/uUAr45?=
 =?us-ascii?Q?dO3gK20YtWjXYFcMB9GLYNZnXlxF+n3jFPFblZ8WrepVFbSD/gbnvA4iMywU?=
 =?us-ascii?Q?VxzIXgLcquC14+ASFmzr6kNC7HSja0mBhlCPaPZv/SRp85RWj/Jv2Gphlpf/?=
 =?us-ascii?Q?Dsg4bND/bB6sfSuPSnFdaGikzUs3YDWGRQV0QqJQVk1XwTRzqxAOutO0XTwf?=
 =?us-ascii?Q?kP/Wiw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ec6bfd-a9a2-4853-8427-08db132e5245
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 10:36:27.4330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /GImtTxoD9YcuECYJJdgRtu4q2oHQmrMpD39LRyVU5o9JMtPPDXJHjyQZ8bwJpEvq1JQB0OR2HQyb0lpPee8QFbUEN9eQ6IEtuTYqOYnGMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4087
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 10:27:01AM +0000, Lucero Palau, Alejandro wrote:
> 
> On 2/19/23 13:24, Simon Horman wrote:
> > Hi Alejandro,
> >
> > On Sat, Feb 18, 2023 at 12:56:20AM +0000, alejandro.lucero-palau@amd.com wrote:
> >> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> >>
> >> Add an embarrassingly missed semicolon plus and embarrassingly missed
> >> parenthesis breaking kernel building in ia64 configs.
> > I think this statement is slightly misleading.
> >
> > The problem may have manifested when building for ia64 config.
> > However, I don't believe that it is, strictly speaking, an ia64 issue.
> > Rather, I believe the problem is build without CONFIG_RTC_LIB.
> >
> > Some architectures select CONFIG_RTC_LIB., f.e. x86_64. But some do not.
> > ia64 is one such example. arm64 is another - indeed I was able to reproduce
> > the bug when building for arm64 using config based on the one at the link
> > below.
> >
> > I think it would be helpful to update the patch description accordingly.
> >
> > Code change looks good to me: I exercised builds for both ia64 and arm64.
> >
> Hi Simon,
> 
> I agree. In fact, I did not initially specify ia64 in the subject, but I 
> got a warning suggesting maybe I should do it.
> 
> I guess that suggestion is likely due to adding the Reported and Link 
> tags, but as you say, it is not describing the problem properly.
> 
> I will change it in v4.
> 
> Thanks, and thank you for testing.

Likewise, thanks.
