Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983815EB6B1
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 03:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiI0BOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 21:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiI0BOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 21:14:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2134.outbound.protection.outlook.com [40.107.223.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDB09C2D7
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 18:14:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxJ1M36otytTgplpr7Y4i5cAGcKWGVp+ang1b62DR3T1d0GdGx9vu2gz8E1KdZhPOfXj2wuEG2JejO7UH+btVDUAu6gt4ZfehCp/qwVPl88+FsB4gQDO0ftDlMxtCbG5lcrHJa5qt67hxear5CLy4/jCLt6+8gD67LLKnAJyvX4T23wA2hmXdrsbOXEUtz31zW2/8TIVYP5QYnZVI1Me4xySps+PpQ9cecIFFNjrgJBnlRXyQittfDKSKBeYC662gaRz8guQ1Q17PetOr5UImHQNchutRRcxLk3kobwkK2gyLH5M9n+ngYlmIo5CNrX57HsoTWZsoQHZ2blRvzsffw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/qlyNMlBYed85SFiy+ZqGjuI4HPeEpe6W55QCT6CW8=;
 b=eNEavPZwHj7sj2PZe7rWLjaT/k04zioAcyhcc+XcXCxAl37/b3TNGTocoMKL1cUNDBay7B22jfqj5rUHMBXhn70jUQFjw4E/mpubcOWlPEi2/4beeReDIGviR3R2PL3qAG5k6vmX5IGb8d93jvazIKwgS5SGzpjK2Xxytf9+HfVdDODgPKZphopCHfKr8dlWjFIp706YGk17OONBfJMjyva12SQMX97NhWPXG+ESPHsU3pv4ufWnUYU0k5/FRx2jiPa3W1znRLiKEJxfiYWMQ19fQU4J1PddPGOq8/JxgllGVYM7zZHUAgoLIudW4KuOlFNzqJenCOjYOVuDBsKeZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/qlyNMlBYed85SFiy+ZqGjuI4HPeEpe6W55QCT6CW8=;
 b=mwqN/L8tMJjyKSkbcMRvkeT0vn/L8CPeT8o6E+BtHHrs8J/O/baSwceeLVCp0trqLwjrL4ix8oIvxxuTQNra8a0T0NB4CQac4BlyisgA/R7YQqxPP8O6Z7E+gp4XN4cdP99Dao5wYEjzeXYZzZeD2yOcbnexpPWSGNohEURW5Mw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by PH0PR13MB4858.namprd13.prod.outlook.com (2603:10b6:510:98::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.14; Tue, 27 Sep
 2022 01:13:59 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be%6]) with mapi id 15.20.5676.014; Tue, 27 Sep 2022
 01:13:59 +0000
Date:   Tue, 27 Sep 2022 09:13:53 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next 2/3] nfp: add support for link auto negotiation
Message-ID: <20220927011353.GA20766@nj-rack01-04.nji.corigine.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
 <20220921121235.169761-3-simon.horman@corigine.com>
 <20220922180040.50dd1af0@kernel.org>
 <DM6PR13MB3705B174455A7E5225CAF996FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20220923062114.7db02bce@kernel.org>
 <20220923154157.GA13912@nj-rack01-04.nji.corigine.com>
 <20220923172410.5af0cc9f@kernel.org>
 <20220924024530.GA8804@nj-rack01-04.nji.corigine.com>
 <20220926092547.4f2a484e@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926092547.4f2a484e@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SJ0PR03CA0095.namprd03.prod.outlook.com
 (2603:10b6:a03:333::10) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|PH0PR13MB4858:EE_
X-MS-Office365-Filtering-Correlation-Id: 15f8beed-5e22-436b-e905-08daa0258e7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: So80zn00fPQbQMmkRBVB8YmT8+dqHlbimQuDxZkuSa+cjllE99iXuiDXrRP8PHdaPC+gmVGXeL9EJKjTekQy7147TJSHRDMhld5769HgefiW4/5/gsZW5RXgsBjr1oqnOSH3dITzSMt3HFcQFmEjEKNhQcBa1JVTvdQ0XZnAD4aMHrx27BejenPpwBiCimdLJ0UArm1nE0SxU9DdHum88sVgogzHM9OFmJIoMjBQkjPohgwphyuYawWlmZSHkhm///NPDkJZj2rMRliG9TPwCkhJZEkRBVZlfYW1LZw+q2ef/6a3qsXTKpb96ny+7l29MKFGWh/9EnAikylkMsDtOImqDlNKZLCaSclUDk9M9Noht9f7y6DVuYk3/H+Huus872X65sdXr857Z1SlQckTnxxeLrY0n9kx94pKsp0bPsLbw2hm7Fd/b7KKnqRwGuI/qAvRmJX0J3E58jvs1DOBa9Ej8w0wEtdQtnXRphL56LmNHamfzPr+/8kOOvMiQ5rgVijpS5gshd8SYetXrSoZ8Ni5r5xfZaADwtq6bWBN5CmyCAkobAwsRNlxkcnDu4y9mRzxWmvkOzCgEOTq/hmNhgjS4gTKwqHH+6+sbudle2I3yZ7Be8m0Xhg4PNoHPEEcTKc8AGEai+uKKqWWfTmMWnwsM2nBAFA6jltVU5K2Hu/9x8tDrZn6h0yhUS55BSUTgRpBNe6VUhdltamtf4dAbuIodZ/qlZWZ1rkKKXwsID8sTzVHEPaqd1oSrqS1cl2o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(136003)(376002)(39840400004)(451199015)(86362001)(33656002)(316002)(54906003)(2906002)(6916009)(66556008)(66476007)(66946007)(41300700001)(8676002)(4326008)(8936002)(44832011)(5660300002)(38100700002)(38350700002)(6512007)(6666004)(6506007)(26005)(107886003)(478600001)(6486002)(52116002)(1076003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qex34xOmlrnGCHbqe2AlkEexfnZ46tkPi4lBi5/hKah/XQMiEToOeopx/4DF?=
 =?us-ascii?Q?MlWHNfMW/DQdn9HUMi2wnnAE1MtzQmsgHOwNM6QqveC6B+dPZUkAkBrj9jHo?=
 =?us-ascii?Q?cPGOlim6tlo4kx1aAb/DcwAipKUciSVZG5WNA33klXbKdYacmjVVoluWlnWJ?=
 =?us-ascii?Q?BM2GrSMEhNwV0gL28R56E61nIQNucNbHofdswsegXSNtobrEJWRxftdpU4hY?=
 =?us-ascii?Q?5A7OCyYb4wGUOQ6V+8bPRw3H4//NPe+zqvW9ayH3C9bhGhtpfutwcPlLcPUr?=
 =?us-ascii?Q?EtrgyahkeutX1XKOBHgJzXVGkTbrS955GWfJdYYhJ1+yeMdjr3ohP2D3Hq3/?=
 =?us-ascii?Q?GliINd3kwqp7vX2htqAvJ0o3Lqz1fw6URdOK+OMpgl6nprInXjFhMAuieAFQ?=
 =?us-ascii?Q?8XhWDMNEXe5AoHMGsNZGjAUjiCqcpsCqPcJ02arjS+4XnxbYsd5xheq6AWGi?=
 =?us-ascii?Q?PjyglM95OscuKvJQ3DaYwuijE0TCoNctgBxn9yy+oYHbTLcRm7DyuM1WYIsA?=
 =?us-ascii?Q?14nY3XZMsNbNNHdCJaaPem6aUzrohy+DZZQbkPWwVjXlEboNgg0NYM4U12Ys?=
 =?us-ascii?Q?z6ArONhaFt24qOhq6PX37cwn9BZzY+AKOPqjK7hEpqCxs6WWIpowReibhsFR?=
 =?us-ascii?Q?vNrp/nCgBp2X9LZyFcWP0Mro7ePjNRKliNnBw6wC4xJAFNLDpn5XZW6uwBjI?=
 =?us-ascii?Q?HPekWVATMqTgopYphxZ9z+fIHC4kq5q9HGuL0Kz8iEprnogNJyU+d9wwuRh8?=
 =?us-ascii?Q?E+tDmj0s32mv7iaF00m9PjMwp2dihxCg0miL1AFD1bYBiS+LdguR/5xdx+iF?=
 =?us-ascii?Q?yME6bP3V315j1y+WxN++u3Q1B3GrdgSL+NlKyol13fBdUABpwSMwRUZFV4Si?=
 =?us-ascii?Q?Kl+nrvcfLil25RRseAS3nw9fB1TRYO/VWHVeYDWGzr8pdz+49LcuiAd8RmAa?=
 =?us-ascii?Q?pI17saAiMzizE6yU6Fj4vHrKQGOmfbIpB1c/v2k7CPR89M3F/kboEmeHcWRk?=
 =?us-ascii?Q?BRjHpMjOw3lH09ab3t2OWDJxxCopSFMaLzi4w7k0gZcUBOqQ8HKGDioQZY9B?=
 =?us-ascii?Q?wXiJuJw2yNKXdkc9XwNEUEaW8465nN0FATjAKq30KJhoF3oip1ux1+R/hI7t?=
 =?us-ascii?Q?J9WhPm1h7O7Xutk9SryxlCbAc3Fg+jqbWhjmlxHM0FPTguen/p+cDg7N1Nw9?=
 =?us-ascii?Q?sUtNdoxMp8mxqVlCTzvCmj7eYf17lxzI43co5u8VZrBwmeafBeJYHTWOnd54?=
 =?us-ascii?Q?+Gye+rdJwCPdltDcyHu1Kutf1mW8j8eqHDJYAM9HAmKLwxrRdvKQGKZYiQ1P?=
 =?us-ascii?Q?e4c29X2s4KkyiS+lBIhPhPf0KTV8NkL0Rt7auNO7HDgiAvRbSn7Pn0KplNzu?=
 =?us-ascii?Q?8Ws3aVJLewAZaowStOdmXSKl5Omy2wubeDLpNVQcuwCnLyOijm0Fs1MlpcTm?=
 =?us-ascii?Q?fKYTAiErxPX69EoGiFzcr481lRaIm3lNo/MBdVM8GJTJzf4tjp6KAU5HR7dl?=
 =?us-ascii?Q?o0LGMYW3ZBPlJDnBpbV0f1GmuW/izuqjsAYb1lOUvbhPCnIXic4jBC54V7Fk?=
 =?us-ascii?Q?6R6/fxairl3bbMztPX5TTAYQXsrKRxpvHX+0A4Y7rERWTqaB5T53SYiIVSLZ?=
 =?us-ascii?Q?iQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15f8beed-5e22-436b-e905-08daa0258e7e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 01:13:59.2356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDmkg8K9DE2NUQUgl9pWfvUM2tonYa+HfqzBwP71sNzorwPYJhjfN0x2bjVQgZ/cYSO5rRtxRRDPXIGFEOQT3lUneaGCQrNQbapgle9hBq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4858
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 09:25:47AM -0700, Jakub Kicinski wrote:
> On Sat, 24 Sep 2022 10:45:30 +0800 Yinjun Zhang wrote:
> > On Fri, Sep 23, 2022 at 05:24:10PM -0700, Jakub Kicinski wrote:
> > > > Because the value of sp_indiff depends on the loaded application
> > > > firmware, please ref to previous commit:
> > > > 2b88354d37ca ("nfp: check if application firmware is indifferent to port speed")  
> > > 
> > > AFAICT you check if it's flower, you can check that in the main code,
> > > the app id is just a symbol, right?  
> > 
> > Not only check if it's flower, but also check if it's sp_indiff when
> > it's not flower by parsing the tlv caps.
> 
> Seems bogus. The speed independence is a property of the whole FW image,
> you record it in the pf structure.

It's indeed a per-fw property, but we don't have existing way to expose
per-fw capabilities to driver currently, so use per-vnic tlv caps here.
Maybe define a new fw symbol is a choice, but my concern is it's not
visible to netvf driver.
Any suggestion is welcomed.
