Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84DE44DE66A
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 07:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242277AbiCSG2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 02:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242264AbiCSG2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 02:28:22 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2098.outbound.protection.outlook.com [40.107.95.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5CD2D5A0A
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 23:27:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYy5EQapd+c0/KfdHk31pnL89sg8rZ4MKrTTtKYVLn/u+voxsuECYMhZ+XKQ8omX4h8P2/Cr9DsOADQvM+d0jPQu7oeLIra0fEu+cotJmZErhphMdJh3JLI6d3Q/o5/gFWGvUFt+GN7gEduGEG7GHnhdtXLTRwufalWIwcAkrc5Qu7vg1WnZLk/pNXed3HZVhqH2bbQwKSMa+lcoMMbIbcQbTvaOU7pi4R4NHSWwGX+9Zy5lYf2ILeHaw5T2LGj9zS+rQRik3qhlY2bfbz+YxL6KIpew8jblUHDb1UOD+fsHS3HmRVQFK0mrOvS4qi6pwKUwh5Ce7edhSJSHSlU4HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2C/D19bN0uVAoRz36sSoouUvPSTAv7CwI7GFZsS+1iM=;
 b=Oj+X45WDWxKYYlYJ87lQJg6G9PfMSrCHCWHQ5EFuGE+9maoCjoR+vpwRw/59QtbDknHV52HlrmJ4VN00eCOayXgDNiaGrzVmY+X04ZjKNm2+UiNBj5uZYRgzUBcsYeSNf6E/kiUD3istX4nXCPm15biEZHLByOa1jb/es/ooJr77Y7+43hBruFAtmbXF7FJ+oOoy6leLzWzbul8TCJwLBL2pJY4bNJTBZ+GbXKRJMLAS2xwkJWH1LmyR+jBJcrrSu1b08TX/naHVp+F5URCIVCDymKt8fr7Yx7My4xlmrrzGG1+viVssR3/FwbjLJf9Rko59OyEV8a4k4mygr8gMtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2C/D19bN0uVAoRz36sSoouUvPSTAv7CwI7GFZsS+1iM=;
 b=H5T3Q0btvJ58EhKGOu9HLS+2RenLSPLhAf9Mm8NOcQ++bGhzG8XZ5VUqk0b85C8wPed/7223YpvkapFXiJX544Ei09epvMIeUp/z9a2IQ5WbpcCRxC5E0ya93Y583JTZ/lzR+YCgM9aCUkCRSrLL8Qv9yPhrossriqlUdqaTvTo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by BN6PR1301MB2116.namprd13.prod.outlook.com (2603:10b6:405:32::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.10; Sat, 19 Mar
 2022 06:26:59 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::755d:450b:de86:75fb]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::755d:450b:de86:75fb%3]) with mapi id 15.20.5081.015; Sat, 19 Mar 2022
 06:26:59 +0000
Date:   Sat, 19 Mar 2022 14:26:52 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 10/10] nfp: nfdk: implement xdp tx path for NFDK
Message-ID: <20220319062652.GA9633@nj-rack01-04.nji.corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
 <20220318101302.113419-11-simon.horman@corigine.com>
 <20220318105645.3ee1cb6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220319015546.GB18238@nj-rack01-04.nji.corigine.com>
 <20220318213012.482a1edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220318213012.482a1edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SJ0PR03CA0180.namprd03.prod.outlook.com
 (2603:10b6:a03:338::35) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fc2ad09-061e-4d7f-4bb0-08da097178c1
X-MS-TrafficTypeDiagnostic: BN6PR1301MB2116:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1301MB21167068BCE8F8C642316F10FC149@BN6PR1301MB2116.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7rcEjmaj6r1ib4aTT/uZkOIKGmfmiXIBpsFsvPTNqigDZmoSl1v0SRJx0nlpSVCg5itDsS7mVHNtMm1QGD3fWNBcneCukHAmZB+oZEhB8xSsbzJQqB7DHkTe/nmVim6bt80SrJwR8PS67jRwWc6i+uNfnb8C6/i4oRVu6sZaoINZXI0OqK0+BLZ8NT6Usl2Lj6CrclC2bHp/5HTsTqaU8OEZfT0fub77veUGGxClSGKGZIONU5fY7tUphvGrDGyi51P8GrpshhQnUmBpDgUIJoMG6RSaadANeJQNRCnKvX+GKX3gBdzJYMXzJvrIBpCt7np0CAY4Zlu1CqDaBB+uVY+/x+Dpd9Dxo8ts/ppj5HoSAqO24gtArneZjHXXnUocTFH2jTLy7SlYrlaWzeyCVe8cM1efazOmomk2c2KpTBiNabaIqiSQmfJLxMH3XYDoQnHf8To7qIbM+RAZVewd4gPKvC+4TSkrVbHskHVUBKxqmP6dsDVriziFqZ4cHHSKTGERdQVKyVQtPLWTjsHbGV3npBVeRmgj+h3TlbIn23wYWwmBBYs2MqsPiJNqoyvUXGxTab+gbUdNV+WSfVBF87TcEv7jgehGdC0dM+RmCgZxAwiNzNBwG31bn9kVZfSuQSWljTjqo0eo15saEaihqF0MIhk5QZ3osL4fLRyuCNy81Eq9Qnq3rqcmO4pb5xIgbbNYT5IlHpN9ViUNaX+WZarb/NoZWJcu/dlcIVot67aeIE6m+Dpn+q0txKZja1S3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(376002)(346002)(39830400003)(396003)(33656002)(86362001)(8676002)(4326008)(6666004)(5660300002)(44832011)(6506007)(52116002)(8936002)(38100700002)(6916009)(38350700002)(6486002)(54906003)(316002)(66476007)(66946007)(66556008)(508600001)(83380400001)(6512007)(2906002)(1076003)(26005)(186003)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmJmaFNoUGNEeHYrTjRTdFNSWllxYmVsa3loTHFqVG9wTW1qY1ZwQ09qYmhE?=
 =?utf-8?B?TldERG5vK1BHVTVNR2pXSWszczU4VnYza0dCTSs3R2FJeXk3Mk5HV3FSVjRT?=
 =?utf-8?B?dS9wYkhYUzR6cmdIbmxBMzRqS0JMNDV1MGRtcHhJWFlZTGZNcndRcGF1YzVm?=
 =?utf-8?B?WEhLSVZCSG1VQXl4RVNnd25SYUhmb1FYamNGa3hqaEE4Z3lIY2NYQTgzTlZ2?=
 =?utf-8?B?d1dlZzNuaXFicitBanhadHpiSnEzUWNkbXFZSEVjTzVjMlNIcGVESXZpOGEr?=
 =?utf-8?B?bGZncTVjT296NnllMWJwT2ZLZEpWS1JIKzBKRlpCVFpuZDFpQnJya202NTBK?=
 =?utf-8?B?V2s3RlBPTTZrWkxadEZGaWsyMExWdTU0VUJIN2RBYWh4TWRPU2lVZklkWCs0?=
 =?utf-8?B?VTNuamVVSDlzN2JtN3lwdDI1a2xQNjZubTBZQ240QWtod095aW5KVzlmUzhw?=
 =?utf-8?B?SFZXay9PSzJQdUxQNGFoSHZxRGV4Y3hEblN2OFF3QkYyNElFZ2twdkNzaFlE?=
 =?utf-8?B?ZlJNdVEvUnZONGFpTVJydkVQN2lMY0F5U1M5cm1xQ3JQMnpWT09pSWhaWW1o?=
 =?utf-8?B?cUdTd1llNE55dGxmL1lFVjgyTFZNWHlqUk8vL1RERnBJK3JaY2s1eXF0RzZ1?=
 =?utf-8?B?bjNLSmJTNC9HWlhwdnZpaDQ3WEJiVDR3VUxVM3NsZSt1RXhtYllPZUErcUZF?=
 =?utf-8?B?TklzOW5mV0RIcDR4bGtqcUpaVFR1d3l3QktGeTZMNTd2YWh4SlNTVmdES1Yr?=
 =?utf-8?B?akVKUnBKUWlYOHc2UUQ4K3lVaW1iVG9HVkNjbTBGYmVFRUowTDV4cEZKRmlz?=
 =?utf-8?B?YUVjcXYzRmZBczNNejZCMFZiSEMxbmluQkxESDY4VURMb1NpMmc0eEZmWXBJ?=
 =?utf-8?B?V3FBd0UyYUUyM0NvdTFpQncva1NoWXVKK3JFYktXWHFuVHFSMkNpLzZkSUxv?=
 =?utf-8?B?VmtJeFM1VjkwK0RjcVY1V0E3bkk1SG1nbXVTRzdNU2dUWDZqb1dXT2kyeDV2?=
 =?utf-8?B?Y21OUDhXSFNXR0s2NThGNVg5NGdmbk54VXh4YWIxWStmWWUvLzA3ZXRLdHZR?=
 =?utf-8?B?dDkwdFM2NG9qa0NYcjBVczZQeUZkOXZTM3QvbHF5WHRIV0E2M05tQ2RCaW44?=
 =?utf-8?B?QWJvOFVYL2IvdER2TTlMcEV6anVLTk4yVHp0MjJFM1VWQXAxUmFOK2E5SlNT?=
 =?utf-8?B?UXViby9scmpPNUJVRE9RVU1pL2JNcmR6YVVNY1dTSGNPcHFBQW1FeTNHV1Ey?=
 =?utf-8?B?MVpYbENtcVdwaTBuNnBhOGJOeWdzcDhBN3NaT1BwZER5cXc4NWF0QXFMMWZQ?=
 =?utf-8?B?QThIbmJCeWowejVxOWt4QmlMYzg4bW5vUGdmaUVtSXJTb0gzWlZHWHZiSXN5?=
 =?utf-8?B?MG5ReDlVS3JtUHpPcjFpMDZhSXNTTzdVcWIxWGZzc0ozN3JhakthdHZTUVJm?=
 =?utf-8?B?MWtIdnlTaWZ1cFVOdU9NTFROczJrNVpoVVQ5bVJjVmhwcXFHcEhkSkdXVXZF?=
 =?utf-8?B?c3I5amJFNkRCTEViYzJkRUpBUzFkeVQ1NEo3OW9zcVU5THpJR2o1b2VnZHNU?=
 =?utf-8?B?eDlsZU5tdWFoTE03RTFSQThXWFNIaDlnS0t6cmhwazNVc3Z4cUp0VG5pemtR?=
 =?utf-8?B?RjczMTNMVmZJKzBTSjVoekVVWkczSVIvK0lNV2VMdVF6Q0dwOTh2bFlSOEpn?=
 =?utf-8?B?QXlNVU9aRTNYZFpwMGVSd044QUJUeXVvY2cyUER2UjlZR0FSalF0K2dxL1dB?=
 =?utf-8?B?ZlU3NXpyMk1UNkxPQ1h6ZGdxdnpsNXZMeW1nQ205Y2dGOWxuellWR0lmSmtr?=
 =?utf-8?B?R0tjQUllZ1BxeDhPdnVrM29WcE41UDBOZElPbWZybFQ4dGIwR0h6Mm45WlFt?=
 =?utf-8?B?QTJzM3g1R21HaWRLNnlqVkFHUkdaYWVWVVBoa2IwM2oxeUVTdnhreUZiQkp0?=
 =?utf-8?B?cnhnYXE2dUt3L0JtUC92N1BoSzdEd0FlZEZYWUxTZENkUDA0RCtBNm1raFBz?=
 =?utf-8?B?Um9FYk9LdHZnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc2ad09-061e-4d7f-4bb0-08da097178c1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 06:26:59.0421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLLV35EuWr36Js0stIC1S+g3CkuiXoqJxFURFWrF2i6FwLpq/c0bKPOlMyQzSBdwjbuNm9m01CvhFMbHfrBXl5XHoFduBzyAtCFgzJaGDAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1301MB2116
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 09:30:12PM -0700, Jakub Kicinski wrote:
> On Sat, 19 Mar 2022 09:55:46 +0800 Yinjun Zhang wrote:
> > On Fri, Mar 18, 2022 at 10:56:45AM -0700, Jakub Kicinski wrote:
> > > On Fri, 18 Mar 2022 11:13:02 +0100 Simon Horman wrote:  
> > > > From: Yinjun Zhang <yinjun.zhang@corigine.com>
> > > > 
> > > > Due to the different definition of txbuf in NFDK comparing to NFD3,
> > > > there're no pre-allocated txbufs for xdp use in NFDK's implementation,
> > > > we just use the existed rxbuf and recycle it when xdp tx is completed.
> > > > 
> > > > For each packet to transmit in xdp path, we cannot use more than
> > > > `NFDK_TX_DESC_PER_SIMPLE_PKT` txbufs, one is to stash virtual address,
> > > > and another is for dma address, so currently the amount of transmitted
> > > > bytes is not accumulated. Also we borrow the last bit of virtual addr
> > > > to indicate a new transmitted packet due to address's alignment
> > > > attribution.
> > > > 
> > > > Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> > > > Signed-off-by: Fei Qin <fei.qin@corigine.com>
> > > > Signed-off-by: Simon Horman <simon.horman@corigine.com>  
> > > 
> > > Breaks 32 bit :(  
> > 
> > You mean 32-bit arch? I'd thought of that, but why needn't
> > `NFCT_PTRMASK` take that into account?
> 
> Simpler than that, I just meant the build.
> It's about casting between 64b types and pointers:
> 
> drivers/net/ethernet/netronome/nfp/nfdk/dp.c: In function ‘nfp_nfdk_xdp_complete’:
> drivers/net/ethernet/netronome/nfp/nfdk/dp.c:827:38: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>   827 |                                      (void *)NFDK_TX_BUF_PTR(txbuf[0].raw),
>       |                                      ^
> drivers/net/ethernet/netronome/nfp/nfdk/dp.c: In function ‘nfp_nfdk_tx_xdp_buf’:
> drivers/net/ethernet/netronome/nfp/nfdk/dp.c:909:24: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>   909 |         txbuf[0].raw = (u64)rxbuf->frag | NFDK_TX_BUF_INFO_SOP;
>       |                        ^

I see, thanks for capturing this, will fix that in next version.
