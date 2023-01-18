Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE7567222D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjARPyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjARPyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:54:02 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BED53F9C;
        Wed, 18 Jan 2023 07:50:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeZq/qjMXaamcIivG0fpTN5DroOBDiEx4M89qU9RDlP+bi3TDMuzMg7l+a0NhG+ZZXjyw0fQ02F6F1A1G/uXPD0+8CVHiLbmGKxAoizcCJIM+HZgyrrzvbQJpkeJqV74KTtDv7hnkrsalcf9HBDR9PlmjWN/2wYSJlaR/Ia/sQl8IeIQQBiaf2J0Ngu+zlo2BG+tpwGSHsQhTBajdSXNqUZImGezdGkV8tzGOaiKoOIkrqTZmGxr+X/DbSydxtkepMsz2M4uelrzbSgg0R+1Qm5N5FTtrjwACJXVPU+2c9u5281gpgfUBTCoMXf6iEINHlSVBhd8N0LITE6tOn4xOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgEqovjobdxRmsbv2PopgzJqQoAPRgyY2K9f8joAt/8=;
 b=MKmW/jvsOOvprrCwjavvKZY0SztF/5TYnidX3azPJIrJYOohT2gVT5VAKE3Kmjxpc6g4zDq8gJJ/cPia0+e710nYwjGT1cY1JwifPWtkKO6Ink/qt6flsD8RLcAIQz8o2jtRrordvoqqP38MN0Xi5fg49ER6F+y6fpCrR/mSIaj3XTOCrkKqynhAeFAcJmxELXVIPOytMW65CAaFIWV6URUw7XdfyaHYsbCvaZp6otSo89MpVKMkCDTKvCG7a1zR9f5ZXz/TFiPI04cdmkScj2UHdzFb48wIGIZZE3KeIa1hjoC22QSqAdNbI+/yy8ARhh2jWo5+hzXipBSTO6C2aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgEqovjobdxRmsbv2PopgzJqQoAPRgyY2K9f8joAt/8=;
 b=H/B8PV57WW50hjSahxANyBwMaLPnTJXzkDET2HbvlJCrgcATmIDw9TVOgTBuI0UDbIgP0AYUnUpcEFHMiY8KbyVzi7BwtDVQSg4uCF3ky+ki+rErtT0yf+76f2pw9+vg/2XNq5ED/ZpYngRx1Bj+SgG1kFGWmv6bhNU9s/6buUZhJ8WuQR000q+aAA7/wG78IJFsDJy3sqdttJUjBRLfMhB5MXztXrkAQUZQ7n5E3edvXjA8XmIHBL+rAewkbn8N9A3dGhmWaeZ4i0yiGdxsPl9Z2Xu2suF0WKi9tdH8c2G7VKCuVC+QPJjDlrgOlnH4eTQTIefiCpWvCx3khv5PFQ==
Received: from DS7PR05CA0081.namprd05.prod.outlook.com (2603:10b6:8:57::6) by
 BL1PR12MB5287.namprd12.prod.outlook.com (2603:10b6:208:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 15:50:50 +0000
Received: from DS1PEPF0000B078.namprd05.prod.outlook.com
 (2603:10b6:8:57:cafe::64) by DS7PR05CA0081.outlook.office365.com
 (2603:10b6:8:57::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.12 via Frontend
 Transport; Wed, 18 Jan 2023 15:50:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000B078.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11 via Frontend Transport; Wed, 18 Jan 2023 15:50:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 07:50:38 -0800
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 07:50:34 -0800
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
 <20230116144853.2446315-3-daniel.machon@microchip.com>
 <87cz7cw1g5.fsf@nvidia.com> <874jsow1b6.fsf@nvidia.com>
 <Y8f6dqXGo8ikcQsx@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Lars.Povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <joe@perches.com>, <error27@gmail.com>,
        <Horatiu.Vultur@microchip.com>, <Julia.Lawall@inria.fr>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/6] net: dcb: add new common function for
 set/del of app/rewr entries
Date:   Wed, 18 Jan 2023 16:42:16 +0100
In-Reply-To: <Y8f6dqXGo8ikcQsx@DEN-LT-70577>
Message-ID: <87zgaf9708.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B078:EE_|BL1PR12MB5287:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a558cd2-ffea-465d-ea1b-08daf96bc4de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bb2rtCoV6moJj7QToUcCJQBG0MMZ+CgYzaBqi8Y9RxccJEJGTghFy0ZmVVNp+AGSNOaUbGkI3G0nnUCqnvzSGrvast1oE/nbkFmXtbHKcu7p1OJhMepFTVhYM2YuHYMzbokxc4JJ2Og0MZzUefC7zpZiLARmOucY7M8tnnN4FC/LcQj9GEE/ebEqtcjG+IEg6TbEpKxbOb4XbpTBO2beJlQtd55JUvfJw/4JupCEuokC3e6BgMAF8IDp0XsDh2gx/YZVHisr9SRZkUQDElWbyLy9NfENUNKxa4f+8ZYhGXTI9RdZUPJN+MN6YzWWsX0YjHJvF2W1ctVHJJJ4+IPmAj4ftKPzF+qYJotrV7I6DClzqupG+sgBF/B79bqf27+eYceRQPoZFxKopvUm4Z0cT8xhcA/07lzYQzAogEkMW56ldf5/FiYILltHVX1bPSHA5njUybmkWwBsQ1M4VLSaG8t3clGgDbx9WDr6JooDB2xKvV8LCQGbxmTZ1cEjrcKygGQT8ogDq0lzivviV9uIPcTOEzSazB3kOhWwcMnnNlLNTtilR4/WFwRLa0yIivMCHfeVJ4u4h3zK2rwQMEMLlscoDliu41NROE6mR7wjzsJ3edcIrJqJuGCKw6fDsK+digfO18uaHsVFzHMTtMlh1t7G8tIdrU+EcTfAIrM4aJ9U4IKSVOQgvFlu98+wY4dz7GyKpzj5eMswaWPqYh+J1w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199015)(46966006)(40470700004)(36840700001)(478600001)(26005)(186003)(16526019)(2616005)(6666004)(54906003)(336012)(8676002)(6916009)(4326008)(70206006)(70586007)(83380400001)(47076005)(426003)(316002)(41300700001)(5660300002)(7416002)(8936002)(2906002)(36860700001)(40460700003)(356005)(40480700001)(82740400003)(86362001)(36756003)(82310400005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 15:50:48.4700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a558cd2-ffea-465d-ea1b-08daf96bc4de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B078.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5287
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>  > Petr Machata <petrm@nvidia.com> writes:
>> 
>> > Daniel Machon <daniel.machon@microchip.com> writes:
>> >
>> >> In preparation for DCB rewrite. Add a new function for setting and
>> >> deleting both app and rewrite entries. Moving this into a separate
>> >> function reduces duplicate code, as both type of entries requires the
>> >> same set of checks. The function will now iterate through a configurable
>> >> nested attribute (app or rewrite attr), validate each attribute and call
>> >> the appropriate set- or delete function.
>> >>
>> >> Note that this function always checks for nla_len(attr_itr) <
>> >> sizeof(struct dcb_app), which was only done in dcbnl_ieee_set and not in
>> >> dcbnl_ieee_del prior to this patch. This means, that any userspace tool
>> >> that used to shove in data < sizeof(struct dcb_app) would now receive
>> >> -ERANGE.
>> >>
>> >> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
>> >
>> > Reviewed-by: Petr Machata <petrm@nvidia.com>
>> 
>> ... though, now that I found some issues in 3/6, if you would somehow
>> reformat the ?: expression that's now awkwardly split to two unaligned
>> lines, that would placate my OCD:
>> 
>> +               err = dcbnl_app_table_setdel(ieee[DCB_ATTR_IEEE_APP_TABLE],
>> +                                            netdev, ops->ieee_setapp ?:
>> +                                            dcb_ieee_setapp);
>
> Putting the expression on the same line will violate the 80 char limit.
> Does splitting it like that hurt anything - other than your OCD :-P At
> least checkpatch didn't complain.

Yeah, don't worry about it.
