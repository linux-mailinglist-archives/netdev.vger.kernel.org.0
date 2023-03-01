Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476FF6A6AEC
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 11:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCAKj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 05:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjCAKjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 05:39:24 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC0D30B3C;
        Wed,  1 Mar 2023 02:39:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfZ5jVIhhEem6Tj533RgW7EFchbkC4o+c80aYOZLvKEllMja2Txw5xcwBXnXbcrOLTTBy2jmK6thoS4iOh3F3oH6muiwqrELLyctKf8LLooES4kaWEOTd9SLJKCh6FLQU02c0NdE0Z+l+wLuhngCxJdkGa029xE71PjZiCDnaYLaaQqhgJ69M6GekUph9ESp10/KgKUJfEA47bC96lwpLA6zChlKMgpOzBmVnVQtcL2oO7MKGfIiCSVLkDCoE4JmmRtoT02uQxb/IKYWJLtaYdj9Q22fta819yzST69tHZ7FsjNKBQbCvOTTLmki4/a/vPKnnBaNQIPieqilx0Rt0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rkphRyxkscrYIkL2XD/CIXDS1iPkQBl5ljszcWoB38=;
 b=lt8JzbyB0/OHNQnsVvCg/EGio5MV7nSMK8lW4UhDM8Oxh5HA/Pw2mNn9lsmK2ujegT5W3jCJf4RiJEhCZKzEGfvtxAjZg7t7LpMOHciH8Z/nfXOMpD6dlt3jmlmZPoz4Ci1kA66ysfQR73XF1Sn52S9GQ3Ffo7Z8eRPy6/Rh0E1KG1zWaxuhO3Hp7HKdpjs+WMzWZFBjo2N+eI08DY7HWjGvhxZmAaq9rbUlxJw3tnaGaZgH63glvKmr3yLFG3B/NAxr4tgzCeaTaCyIdVuJKc6OFDyUQE+KUld2C4R5xyXDQPS6k+PsbPS6qWnOa+/CC9xq9ZW0Lc6/qnxKYpQi8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rkphRyxkscrYIkL2XD/CIXDS1iPkQBl5ljszcWoB38=;
 b=ivNVlvGDNmNw5PpxJbxKfsclJoNns2ypuod9AOK4Wdur85hCDebesrPMl9F51yobJ04AlWf2IrOxAdwMi0JDc16Xr2lDN4gPCQ3aohFzkq6KyC5xalkqhkxOPYdLZ+sz0EXOTbhZqibrAJ59Q2jmlSb16NsniqlR3ysF80/cqsw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5517.namprd13.prod.outlook.com (2603:10b6:510:142::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Wed, 1 Mar
 2023 10:39:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.018; Wed, 1 Mar 2023
 10:39:21 +0000
Date:   Wed, 1 Mar 2023 11:39:13 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] rtlwifi: rtl8192se: Remove the unused variable
 bcntime_cfg
Message-ID: <Y/8rUTtuzcgp34KQ@corigine.com>
References: <20230228021132.88910-1-jiapeng.chong@linux.alibaba.com>
 <Y/3gUquaPNlaLaKt@corigine.com>
 <1d262829764d40a086e93f0c7d0541bc@realtek.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d262829764d40a086e93f0c7d0541bc@realtek.com>
X-ClientProxiedBy: AM3PR05CA0156.eurprd05.prod.outlook.com
 (2603:10a6:207:3::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5517:EE_
X-MS-Office365-Filtering-Correlation-Id: a406bd20-7fe5-4916-51b0-08db1a41374f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZmVX5sqxXDVN4LupXNZEl+sKodzK1sBzap/YyxvJmS82KmCYCROve/JoaVqQjn05fS/Mx/ttNoqtt9PNFOxeUgLRnxlhcQF+U5B2Eaq8NmVkiiecoSRrQG3JrWtL9SHLd71Tckk0sf3a6464sQOcwjtGUxFWNzHEmEAwcyeR9mtoAxVUeqOQA4IxLPFEf+eZ8UjVxDo1Pkq4vLuCNB+P5oECgitOH/dQPhC/K1BZLiU2SNpTHKK2LCAyJ/orhinyTCYTocE9yMbsXKb1Oy7QIIYQkdMcMdORqUhxeNvZpQHPo+l6DwtLIeoTo2Vi5A4PAiTK3XGMN3LMmOhJM/XWs0Zyx3CzYcChDcM4fMxQvKdlcwOxu3LVt3h/CHmJeC7MdeXZAs/YIdRB4ghqHoYbgq0jn/r1XA857abDxBGOVIrTau2tpxhpPdCdre2+ccPhwlVyeJ0vwmwleyPaPZ5CLDjowhtf0MUiSXoOw3wxm/BK43OIThKYZB9edmd/7BVvKBUEske1e0y00dJqPVxdp0+J97AzikndUZqYlJgix0UdMVIIa1puYtIAIuqHnlYPHhVDMsHBzzxeoWg3FJAsxXCEJhtvBRBQewXD84XxplyL4Ps6bNFrc3oXGPJnlJB6cHK7m8a+aeVCDAkyKZ4eWYg7CxjMebPscnWJDX1Uxp89yq8SMqICeACPU4K4YLf+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(39830400003)(346002)(366004)(451199018)(36756003)(86362001)(66556008)(41300700001)(66476007)(66946007)(7416002)(5660300002)(8676002)(6916009)(8936002)(44832011)(2906002)(38100700002)(4326008)(6666004)(54906003)(6486002)(966005)(478600001)(316002)(83380400001)(186003)(2616005)(53546011)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yE5KkApZWfEaSLI5JnokKoY6dPAFX9y7l4YjerBAK546pyJz2JDXGwiVeTj8?=
 =?us-ascii?Q?7S6wo8NvzuB92sQPud+WycKHA+UTmEMUNmb3WK69TB5Xmct8gy5QiEVM6goJ?=
 =?us-ascii?Q?nEOhN4OrmwDkORE5sMuuDeP+FBTwlVGnrz7liBSfryq2JA7X8YBuftKXo/TC?=
 =?us-ascii?Q?lLHFzMoexL17qOdd/P/OXmcoxsxKECG8qXS4SpsR/c4CPvRQ1EWqytm6NgZH?=
 =?us-ascii?Q?qSXd6MucNXZiGMH3X3PqOPV4OMTm5by5FuJAJt9eHIZr5VmOabvhYn1rmrcC?=
 =?us-ascii?Q?DvqMt6qMhMdYCIDYhol67OqCz11xr6bTLTOIKOEN4JsjL31priEzZJ9r7XrI?=
 =?us-ascii?Q?9F0ukMCyD/4OXuAQLs9vbHTack7sPoTbyfQmnqyoR+jZs2p6C0qjjG0/dxbS?=
 =?us-ascii?Q?YKfOlUi6wmHZQNBz3jixr/4jn2nP5cG59TzymAFwDDsUczlGM+r1+TqAv7s2?=
 =?us-ascii?Q?ors3kIBic+LFOpZtTOWsVx54XvI3SagU6HHuNV8q29iZ+Uw2+1VC/MQs4tea?=
 =?us-ascii?Q?kofj9uS13v340jIJdDLoMJNDaOVhgoBUUFlQUWgltGHTmGm8zPbTuNRKGwsO?=
 =?us-ascii?Q?i4EazSRfGDjB9zwIkxWZmyaM4DIlLyAsIkvmzN58I7R4RxstEGvz3Ycm2LBr?=
 =?us-ascii?Q?1dBTPWCKtvdnO9Svfm54G/qU/74Lhtyt6VrQlxqThw4mDIhUZciqGUI961BX?=
 =?us-ascii?Q?88R4ITOIvshnRLOWB4PRDi/r1pQ4/JaEZTOQCQniB23MA2KV5A01xicq5PNu?=
 =?us-ascii?Q?my8Ry3m42vL08ifx3sv9tBfod63GpMWh/OgS4tFd1wvJND7SdxyyB6JNOyTP?=
 =?us-ascii?Q?fAnDx8g8yH6UMB6f7z+ktC62D24+feXgbcrn4qXPontRDICqhMSePrzTUoSh?=
 =?us-ascii?Q?g1fpLcJc9IjzCA2pBH0PBLKXFypNgs53J1e8ye9r3ucn3aeDnkxLlrd7E2LY?=
 =?us-ascii?Q?xObV3+20HMdImCdK9WCqMflg4b+4nWT5vW9SaiHESvq+WUoiKos6JVSxU98m?=
 =?us-ascii?Q?PuOkvcpiqFbZAJOEVe6TRqmSf8Zv+QpQje5xs0F1RcAvK4a4H2hCQcfYm/y1?=
 =?us-ascii?Q?H7djWrdoJOCzfRVNYh4joT0u3A7GFz+sCWC1k/cBn1+iTXVu1+SIfJllX+t7?=
 =?us-ascii?Q?RQRr3dyR4SBJuGNEQynDIOUgxoNvoG5yPm1Mf8ys6/pxIEzZWUFbGzKAglsQ?=
 =?us-ascii?Q?YcxVbE8zZjzqKOhflPFbfe7IxtctHKi/eUG0gR00e2yI0hpcfEO3QPlz0vnj?=
 =?us-ascii?Q?wTMyKTTLYdIaj8rqNU6vylvPnrZmurO69Yzs5HJq1Eu6rrWBzZxejgv3oGkb?=
 =?us-ascii?Q?0cneQKcNs/08R1Ua8Q+FG5rxgcoktYz+dW9/8YWo0NSu/GjEFifxQIPj0oi0?=
 =?us-ascii?Q?pNeC1p6JAh9C7qC26AEv+w04zcvnQG6DOmmq+kBITASfSibYJVKh2MrEZl5e?=
 =?us-ascii?Q?GNO0kKr+nJfcfevsFfAAJlHZudkPyKEEYB5XkmdP3xDS19SWOu10ygcpS3HM?=
 =?us-ascii?Q?uEe2N/vg78rBSW8ngxCvEzTfNruJRnQb5HbgwugH+DZQ3imp7hEN0vnY3x0p?=
 =?us-ascii?Q?AqgRiz6ocZl8+w8Otl0bV0gT13QpBy855YBjo1+QRrIoMVX/hMyd67s+zidd?=
 =?us-ascii?Q?+b606Ia0RGIsUpy4JHlhW5rEtkc1p9aUUFyew485BO8tGEBkuOyDpboHrcke?=
 =?us-ascii?Q?Wwmeyg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a406bd20-7fe5-4916-51b0-08db1a41374f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 10:39:20.9804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 40OKCuZyQH6Takw8XdnILFyY98ZhFZwn81lPBw+74J7nGoo6DhBltG9MyA55qHZthKkkkUJ8PptrpkmQEl6kchYs/Tc9mzJKShHlIlMwi8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5517
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 12:32:38AM +0000, Ping-Ke Shih wrote:
> 
> 
> > -----Original Message-----
> > From: Simon Horman <simon.horman@corigine.com>
> > Sent: Tuesday, February 28, 2023 7:07 PM
> > To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> > Cc: Ping-Ke Shih <pkshih@realtek.com>; kvalo@kernel.org; davem@davemloft.net; edumazet@google.com;
> > kuba@kernel.org; pabeni@redhat.com; linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Abaci Robot <abaci@linux.alibaba.com>
> > Subject: Re: [PATCH] rtlwifi: rtl8192se: Remove the unused variable bcntime_cfg
> > 
> > On Tue, Feb 28, 2023 at 10:11:32AM +0800, Jiapeng Chong wrote:
> > > Variable bcntime_cfg is not effectively used, so delete it.
> > >
> > > drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:6: warning: variable 'bcntime_cfg' set but not
> > used.
> > >
> > > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > > Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4240
> > > Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> > 
> > Hi Jiapeng Chong,
> > 
> > this looks good to me.
> > 
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > 
> > While reviewing this gcc 12.2.0 told me:
> > 
> > drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:25: error: unused variable 'bcn_ifs'
> > [-Werror=unused-variable]
> >  1555 |         u16 bcn_cw = 6, bcn_ifs = 0xf;
> >       |                         ^~~~~~~
> > drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:13: error: unused variable 'bcn_cw'
> > [-Werror=unused-variable]
> >  1555 |         u16 bcn_cw = 6, bcn_ifs = 0xf;
> >       |             ^~~~~~
> > 
> > So perhaps you could consider sending another patch to remove them too.
> > 
> 
> These errors are introduced by this patch, so please fix them together by this
> patch.

Yes, indeed. Sorry for missing that important point.
Had I noticed it my advice would have been the same as yours.
