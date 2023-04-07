Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECCB6DAA58
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240348AbjDGIop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240340AbjDGIom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:44:42 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2100.outbound.protection.outlook.com [40.107.223.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B61A24A;
        Fri,  7 Apr 2023 01:44:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sacoqd3Gnj5/c8zib8pjAMdQE5roUGnjClcvB2vkL3Q8+GRELU3x6501Sw3NV1/r9TN3WyaIwuBEj91u/6vYBQX3pGOlZQE0c2O+7OblWA8IZXH7UibrsRfKxt9/f+lK2kGyJmXMF17WhxZtt2rHz4E0y9DwdnDIkfVDXdlTGvT3WEPUlZ5PlQ975bYecvcl4+P5scx09M0PTUhqzG6Vilj3S6NJD8XGwld0RQQKww+nI3+zDPQPXmAHWvRzfsF2doOggkU16yiWgeT8zxisKDplkRAVsKK10rwMCz9ylJPDAz9n4Cl+f0a4Hxq1JlXXIOwSH18kA9vDR/7+v6tyww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4jl42y66YT7kmPqrkxK02MNyDx81GfcQAEVTEWgHtGk=;
 b=P/FPw2o3cEM3C2RNy9nB7maJ0BqUVgH4IALBxvwN70mDbPb5ZPbRh2LaclTD04M/zgPne4etHC5qZeYEGAe7XU0VX76fM7GzijB+IplJSllOoOldIrQ8lLTiLleq9aG0jE+0rJWmi1sVj6T8vAjy69HdjNJWtDFWIYw9bVDLUegMHjJbpJBD48rtvq/JgTZVw3xGjUhQZZ1g5fUvnHHTdnrJjBWPjipRxxP0ab49aPoGI+nnc/EesxPpKSOBiyJM8rFYV6cuqUfF+NpbELKoi0d2DdDJdzftqz+cnu9qUF0HE6IIAUjw7LQXUsPyDjo8xZfEBl80nfnk8HKbVZEGtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jl42y66YT7kmPqrkxK02MNyDx81GfcQAEVTEWgHtGk=;
 b=QcHEjchiSS2hnUegeFLA1c6C2X4svl6SzAxM5/1XWJNATOI3SLvGLTKqziplB3yKB+cAqbWdCQEEa1nTLtCGg6tT5BZx/R2ZL8FFWdPXOh3MaqFkmGivg+0Cy1tjowxqQ+/RBpc80s2OtJohuokxEgAphlMHdRXf7TWKz/6AaF0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4470.namprd13.prod.outlook.com (2603:10b6:a03:1d1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Fri, 7 Apr
 2023 08:44:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 08:44:35 +0000
Date:   Fri, 7 Apr 2023 10:44:28 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Felix Huettner <felix.huettner@mail.schwarz>,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, pshelar@ovn.org, davem@davemloft.net,
        luca.czesla@mail.schwarz
Subject: Re: [PATCH net v3] net: openvswitch: fix race on port output
Message-ID: <ZC/X7Dqv+X2vwLgM@corigine.com>
References: <ZC0pBXBAgh7c76CA@kernel-bug-kernel-bug>
 <20230406190513.7d783d6d@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406190513.7d783d6d@kernel.org>
X-ClientProxiedBy: AM8P190CA0001.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4470:EE_
X-MS-Office365-Filtering-Correlation-Id: 9060f2c1-f2b7-4324-4cd2-08db37445026
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eHq39PVWWSsKtOtYpafWEvFzLDiwvRaAuaLF6QQAweeE10zMmjgkriQ9u3eyg1eMago+F1v8tiH4xTCf6+k0AUQhSdE+JNq2mSyfOVO/c6xjbIKOmuDN2rWcSOs4kwu5kg+dvikM0ivP4V9YxleiLrd+mKIS4fV2lyuFqlnB4INDBh5CngUZpyDRC4PJdpWhxuQSBGtAGI2op5OD07HncPTiBq3Ak5o1417xy9dxKHVCY9NPb92atA7vfEwYkumyE9yhfxitlDoVC/O317Y2ihHwf3LAKBANaoft2xvoph0EF6Sxo4AQBHvtgzsT9h9F3+yQb1Dk8GhtKl89IyAT4izO+lHeP9e3JpZvBvV7TPhN9oJ01iSEALhVc9Viw0m8Du0cLzkJS18vZDTBO9Y2Fkk43SEdw5+mahAyWXjB7GE8OMvoi5DyCYUtuIchgQps1Xbut5T+bsdrIRx5USzQG3QvwJ5yQTFPNBCeiktq3b5VKJ4KygBZtvyze/mO8FOhT3uCQrnSH029iMxAozzkR/xbPRKy9O7Q4NL3G4aDsXAR0dM/aLWmMdO0LVCSVocR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39830400003)(396003)(136003)(346002)(451199021)(6666004)(6486002)(36756003)(86362001)(2616005)(38100700002)(6512007)(6506007)(186003)(2906002)(7416002)(316002)(66556008)(6916009)(66946007)(44832011)(66476007)(4326008)(8676002)(4744005)(8936002)(41300700001)(5660300002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e3jzBm1VLqRi03zpBECv7gWpQpL4DvV2nnn73WEwHblsgMqIRA00vZrOQacq?=
 =?us-ascii?Q?RXEytReq5IsoSEsMtF/oFYMsR4TvvHK7tjPeB3aU7srq1nubCbfkKYwESogS?=
 =?us-ascii?Q?Xzp3qQTzDwwBu5mhG+g30fhyAC7S9Cx3D1G47BHCq9k+aBHHsFMFo0u2N8pi?=
 =?us-ascii?Q?75Xber3FTP27FFqUMclOOJfFey7ywMZ7hiUn2/zgqC67nt0K1mRfn4Vxr6OP?=
 =?us-ascii?Q?/oZq5tO7VsLIYB5enJBB7oxb1tDmcPe7TbVZ6rdtLoni8ywS0iW85GU39AF3?=
 =?us-ascii?Q?+AX7gH926Pv5Zw9BzR1YzsSjGTtemDp+/FALaJwpyFdC7TMirKpnBVF7u7vO?=
 =?us-ascii?Q?yEFIitPiIxavtEiHDgsweK1GtJJ1XT1p2nUlxxe1ZvVwEgorIuhmnBLMg6q5?=
 =?us-ascii?Q?mScJRHRRlgO64q7hh+XeeFArb1yPHRW/CjCpDHQxdAxFqYTsueLNoqpRgF4C?=
 =?us-ascii?Q?jCG6KBlb9X6t4m3s3/AoYIZKxf9C9LPxMeqU+VY9/KXr3CXByoXxRTNmSDw/?=
 =?us-ascii?Q?MmqdBMLI0R62RH7geCVikqVnd0N6qDYu+osb6xeNlNhQ9hiUZzqAzOJusln2?=
 =?us-ascii?Q?iBBKZad2ixNxvCO/PCxj4ZlIK9IZLuxWb0ONtlAft8TECdCgIelp4P+yvPAu?=
 =?us-ascii?Q?4Mw3Nd0zayj8gM4NefMSN1sCKVWyk3bTLvRMYn69Du+hnlBa+rnUqLuthjYy?=
 =?us-ascii?Q?3IFHGkF8GffhgMkUJ70CLoK11LOr4xBbafPY7nsjs+vDpXAxwtcv7jKq9AUV?=
 =?us-ascii?Q?tSVcjwI/Du+s7KoPInF3oIOdQDPFLtENaygpHKpYdc2hpBo+ib/vXCNBLJbx?=
 =?us-ascii?Q?jJkgs9Iy12aR48Ynn0rlnbM3pNalwn1Pfg0wB1q1zQRZnwtUnGQ2+Vc92c45?=
 =?us-ascii?Q?gKeEgfyceuq9+Mvas4w5VS2TDpBmsRis1ju4zz9hcNavOXF62SskuOFtyhfs?=
 =?us-ascii?Q?tRrKnbH0eloQN8SN0osK4sFYhY+BWfmvaAuF6EQVdLCyYoclQk7slSoZB3DZ?=
 =?us-ascii?Q?uVzmIcBJbmxxr1x5b5ANJRxAkmlsVZ1j1NrkUaAa44B2JM8TjW1Ce0Sv4kub?=
 =?us-ascii?Q?4fimorIHxxbxTQlWUk7OoW7hAA0uHRDEMFYNPgECzI7tModzCb5EqaTsdjor?=
 =?us-ascii?Q?DS7bG2ZqfHaZ3zns19J3rnmZBfhX0NaEoOZEp/GJTtynYyMqU5I3Q2aXMCv9?=
 =?us-ascii?Q?GltxVrDhXr9phctBpMHUspToaXy9T5wFX7yMKRTe19duIzdHQty8Z9AFuUMr?=
 =?us-ascii?Q?0/wxeY6xGccVcRHuqM63NC2InsI0M0Aqho7OTkO2SGEdTeTBjzrRJ9tAVTmA?=
 =?us-ascii?Q?niULW8bluomLazBPz+V0nY6Ixqkym5WrBo5kaz50CU6DsYKQpl2MBK+CSBIz?=
 =?us-ascii?Q?rJA3BoIsNsT86tPwX6sL/rUynTHlwMPdSIUzQbi69KAXCBSyIguHpzcHdzf6?=
 =?us-ascii?Q?WzAuNlloUgDCB4EelVeFqlPEAXfeB1MbRYwbHc1NmftpeSnhb5kl2hup8r4R?=
 =?us-ascii?Q?x/rDMXb/Nerlxf1KfJ5ewKFzuizAm52spFBuNCY/cZarDktUzcc/1yTrGQqT?=
 =?us-ascii?Q?pgTzkd7335QSBBTF1EGvg+SRdzcNWPOkFxylMzT+pg6l4jRcuJWJI8Gr3z8K?=
 =?us-ascii?Q?ifH7Pk9bezEcvh18rajOcaDkH74gp5pL2f9s0bWmNI18MD2/ymgn2t1AEle9?=
 =?us-ascii?Q?5dZvYw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9060f2c1-f2b7-4324-4cd2-08db37445026
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:44:34.8629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTiHnRp70cK0QqqkONAxi7jTEDqDacEX0ggBhyEVcGt1dwm0yARTbVe1h44lXwY0fQCCpXa0CRhFBPmGFRHaNmBhKJzKVM7QsxpVkpv1fSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4470
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 07:05:13PM -0700, Jakub Kicinski wrote:
> On Wed, 5 Apr 2023 07:53:41 +0000 Felix Huettner wrote:
> > assume the following setup on a single machine:
> > 1. An openvswitch instance with one bridge and default flows
> > 2. two network namespaces "server" and "client"
> > 3. two ovs interfaces "server" and "client" on the bridge
> > 4. for each ovs interface a veth pair with a matching name and 32 rx and
> >    tx queues
> > 5. move the ends of the veth pairs to the respective network namespaces
> > 6. assign ip addresses to each of the veth ends in the namespaces (needs
> >    to be the same subnet)
> > 7. start some http server on the server network namespace
> > 8. test if a client in the client namespace can reach the http server
> 
> Hi Simon, looks good?

Thanks Jakub, will check.
