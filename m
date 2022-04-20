Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A71507E6E
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 03:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354044AbiDTBty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 21:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348404AbiDTBtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 21:49:53 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2127.outbound.protection.outlook.com [40.107.237.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD93332980;
        Tue, 19 Apr 2022 18:47:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIcfc0lskDYk1r54VomwYr4HYiq8cZ2MKVWKBvK7ktQbvyWXzMFpyqwkDJ7OAvCNvO6SbSw3AXQrEjHGyueynR4A7yJnLUsnZfsFGa3mz3ZmjskOQWhKDy0YeY4TN5aTMmIxxNZDjzyoPuyT5YZl9WTSWD52VHzND5HClak3jKy4U5jYPC1xF9DhMb+WjZGfzLIhxECow4C6BAAbfaMUbgKEzZJSRY/XlXceqP+OG3imF6D4waKoCPZKMM4o8kTUD+OguXrCthBAEts4KNXLo2hgvHSV66aH6nus3H/BVGbD+gmW+APU9CN2guOKh9FJP2eIUKpyE93p+0Pfuvfd6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQT+tZ3SestjOul9we1JowupMCOL/VYtPbcOLelUpeQ=;
 b=obecEOk1nJod4u9TTW0o/fKmPWSGRm8KoqdVNr+puP6xVj/TdotfuGIdE19/7dCLx8dz2+uJPJvC4WnRG9/AIMGHJZ3T5NV1obBew+FynaI8NbOjIyHX8TFFdMrpD6dkEPm/JNc0y8IwjoMt4xrdf/lkeRIxS/h56KIHSuT/yEoSD0V6WjxR10C+TE3PNJbDZtGXLQbJ3iD7ydlKzWxh7Plql5hnPZzB/msXe4MEuQlAw0bFWIXYNIBhtqvFns+y2kclZeyLqaKH1yprpEbYFiiBraatOmIUknHKbYGjEYgrmxFGryNLXJXY8iFM4AbViraZ8ync0yOt4A7NfZJjcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQT+tZ3SestjOul9we1JowupMCOL/VYtPbcOLelUpeQ=;
 b=QI5o/gpH2KSN8+muZJkMPKpmAQ0Fnu2iTh3n/GH36bc0jmFstA50apZAyef5htlzyGn+sOhDwtug/NU4dEAFkYiXj80DXEHYeMe4rGzthwAmj6QrAxNkKMR5BiS+SCBPOadCJgoKEKR1VHv3Y0n5i5UVII1pBAWPv0/B7BoNl6Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from CH2PR13MB3702.namprd13.prod.outlook.com (2603:10b6:610:a1::20)
 by CO1PR13MB4949.namprd13.prod.outlook.com (2603:10b6:303:f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Wed, 20 Apr
 2022 01:47:04 +0000
Received: from CH2PR13MB3702.namprd13.prod.outlook.com
 ([fe80::9d2f:9b88:eb97:a9f4]) by CH2PR13MB3702.namprd13.prod.outlook.com
 ([fe80::9d2f:9b88:eb97:a9f4%9]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 01:47:04 +0000
Date:   Wed, 20 Apr 2022 09:46:57 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next] PCI: add Corigine vendor ID into pci_ids.h
Message-ID: <20220420014657.GA4636@nj-rack01-04.nji.corigine.com>
References: <1650362568-11119-1-git-send-email-yinjun.zhang@corigine.com>
 <20220419142310.GA1197793@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419142310.GA1197793@bhelgaas>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: HK2P15301CA0010.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::20) To CH2PR13MB3702.namprd13.prod.outlook.com
 (2603:10b6:610:a1::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7799925e-6497-4ef2-d146-08da226fab42
X-MS-TrafficTypeDiagnostic: CO1PR13MB4949:EE_
X-Microsoft-Antispam-PRVS: <CO1PR13MB4949D2963488C74E51FD80AEFCF59@CO1PR13MB4949.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YIWtDBLVfK4ANzgcWZ5PbtS+g4eUwHQouaQlbMHipUZQ82bgs5B4iRDFzwqDiUfa0hfc8DreocqQ67Ye2uBImAP2Z+rpvaMNpfdNwfHBCd1sHoYObmSFUx37orumX4nkm6ct1VR7Ow8G237hT51AnhnkG8poDPmbKFw24MGKVTIzNdrRDHwYMivTD5vSx6qNowwyBezskuZQ0bj0d31ICIM2PkCEfU67+fnh5AZ12i0ggum+Dbsgvtweg1Vp3tuj4P1CXicBgVjy0n3QnoBgJ4+R3Reu445a/v6CCaS8dSDT1ea68fIXhBAPvS7nfg3F9RUEI1VbU5Qvxm5wSLj3/EFZUwFMUmZ6soSHSWbOeRLROlbcTJDIIcPpeZMxTC7KftSI4qcm5rsar4ub5QDjkNvHvRaijf+WSXXtarVo2VoYFl0zOWtRnz7FeTvnX4imW5r7gUReUmN7xv1aJTxFhEukVXNPTwdGNlicQgNN5vU8+fK0JaFFcTvKmXRI1yFS4rpUCUxheshxHogF6UxRVSlC3P1hg5JZQ9CfUhB+S/Gyg7Mq9Fp1pomkB3e5BCSF+WYbuttLybffsvSyFFF+09mdqFZAj+0WDuuDU7pdnLVX7UDZmXvjxSOF19yn6gYEu6w4W2MSiSPoDWQom8XKxXrwMl05no+6IdIIrG1Ve5c3g7C+h6mphE22ULpvbnVHdCAzaOBb0jR19pZz3SWDdJzg60os4+OYnEVVHZi4LY24ta5kOHbmuGiZSs993aUznJPr7VXbcbYCZUQe91uxTiqLYYEqSJgQc+0GsnBjQTw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3702.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(346002)(136003)(39840400004)(376002)(366004)(5660300002)(316002)(6916009)(38350700002)(54906003)(86362001)(8936002)(44832011)(38100700002)(66946007)(4326008)(8676002)(2906002)(66556008)(66476007)(6512007)(1076003)(107886003)(83380400001)(26005)(6486002)(508600001)(966005)(52116002)(6506007)(6666004)(186003)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ERKPr6G2qumCil5hebeTucv6+xPu2qr4ZJ2ltW5yeZ35rJERM8Oj4nDxzIZF?=
 =?us-ascii?Q?Yq+Y4lDy5C7O+VklOvUff/EchrAETH2GsGSQIY5RL34Qhk8tmB5jSvf9pu1S?=
 =?us-ascii?Q?QY0Aqjf9HeNF0TBPqbNeOVoHSOujTvBCHG58VbPGaHILRt66S/+uOLxO8MR8?=
 =?us-ascii?Q?cCA7gaiBLuVCoUdT6SXHxdOxiKdX8uZeEOYpYZGfT9diT6W8E0MndQCUziAS?=
 =?us-ascii?Q?YcP4BZ7gdre2GUU8mwmA7+NnmwfewcGTQ6e7kOlsd0iGcbxEe7G1MZMtFSa2?=
 =?us-ascii?Q?v3ErocJcQBgMqGBhSH91gs3cNhFzoGMwTh+YHFc/nv6mtENXmTDDjOKT/5yu?=
 =?us-ascii?Q?4C7+RXI3+nSc+rKj9wrr/TH48udjKh1VJOjp6Gt8mZ2Sl/lS9X+0u9O6Oyyt?=
 =?us-ascii?Q?ZjlWGjuuDH+HcyTFUBDHpCabPA6th0DFfN54AmnTLt/qUDrcx6pV19TmdFgp?=
 =?us-ascii?Q?XT2MvwAvODGSe1fdUaRloiarGz6353EN+jnoiA8PT2B4MnRAlrcHU4LPkv4R?=
 =?us-ascii?Q?/jQ+AgYCOr35VOzHvtFOpUeOU4K/27WZYVf+y5AYiDNkL4+1tUPIUuQqVPD8?=
 =?us-ascii?Q?pjKHLt2yDfNKKbu2+t6INJfaBN0KbLXI57l1FdprrIrGcyo/4SSFT1TLEDPE?=
 =?us-ascii?Q?wWo9v1bhMi4TTh5kl8xst5mHlr95VJ/PpM2Otz5ADP3JGnsd5u/zbQAEgAWT?=
 =?us-ascii?Q?X4BqPeR+YSN5I+yCsO1nzSkn1lx8UqsF5oI+f9cb/KQBaBg3V43baemvns2E?=
 =?us-ascii?Q?3lPOXJwu9jQUlCInegVVBa5xypFA15B08vruywc4Py546CdAUe04hd2eywD1?=
 =?us-ascii?Q?S266CjOQUP7X8uLKExZLQdQnLasNMzlQanI7TkPU5bBfm+tH+a03WRIwKiTc?=
 =?us-ascii?Q?f9NAgTP261+32kAiLrLiC5Jc7BpidiA7Wu5Nm8gtVWo98IA9myqMTQoxUgtV?=
 =?us-ascii?Q?syPtvCwS3fadwtOkC0C+MQlhbYs4oQvPmXaBxCTZcR+3vHAvubDwahTW4d39?=
 =?us-ascii?Q?LLhWgHbMPy6vdGcl1NqZBG1jtKDBbizlnPW+lygbYMwe2uY7iWbWyEMytJjK?=
 =?us-ascii?Q?9F1J2NEqD1o33b8nAthh+GBprTOyEOBfxqcaOOCH1/49voaQKqM0sd8Lk4uz?=
 =?us-ascii?Q?d3XvSjOB0eDzrQ4mbWZmJZw5vO587JJqMcmMI7Q6gHMKyPxP2OOf/cFwp8RR?=
 =?us-ascii?Q?fNREx39oHJhZzckLPNZGgwCUVf/Rljdy0B+QE9E8OH2EspNXrvqwka+YGcNl?=
 =?us-ascii?Q?0W/YA0ADPimJWhoYVvaH5JrU1Vgl/TLwfMtDxQZLxTG5lgsFhK0IucRn8JIQ?=
 =?us-ascii?Q?bkaYJCoVeJ243bmWWuOXOoB927PcnxMrctNpN6Lla39VrcyJBFc9VfRV3/WE?=
 =?us-ascii?Q?p0D7VxBjf6dV+DxixQda8vy320sWBKftGgedqxXp5hlPMVTV1tkJWZbU4Y6A?=
 =?us-ascii?Q?O9teUICWhIBzH38qoqjRX+qA47hs6ijAl0nGoKdaXagMV7bAgZP6h4xcE2pI?=
 =?us-ascii?Q?bbXVXjTbLDn8q0P4AyvCgIUpaDF5rpgeVRw2Y9Zf18cawwVYH59SHFPlKvFi?=
 =?us-ascii?Q?x73ENTWuePkJ7vD1eUJPquPEyHlvfJK2bibhvh9QdqC4Rzv2v9cKqSh2Pf7j?=
 =?us-ascii?Q?QPgXaA+S9InT+JDJXEm8NEtGb9pg6+5y6+Br7FyirX+sIB6kYOzGEvM74k+c?=
 =?us-ascii?Q?iL17PzGb7rUUPXMUCuiCBBjPIBV1D2cRuI3jVdIHT89Cj7sk9IswUqTtHkZG?=
 =?us-ascii?Q?RhsfsBSp2PciI/uZPBQ9t7Xi9fxkZHM=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7799925e-6497-4ef2-d146-08da226fab42
X-MS-Exchange-CrossTenant-AuthSource: CH2PR13MB3702.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 01:47:03.9311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zh7rG9kVcBIsenrMZdC0vlWrzx/kF+OyuteXFBRNDYsM7TJ0L2XuEYJpaPvIc/Ab++XV1eurBfxAc6IZdFZ0VVJwKuz0WpcbnVt2CqR55TM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4949
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 09:23:10AM -0500, Bjorn Helgaas wrote:
> On Tue, Apr 19, 2022 at 06:02:48PM +0800, Yinjun Zhang wrote:
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: linux-pci@vger.kernel.org
> > Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> I'd be happy to apply this, but since I'm in the cc: line, I assume it
> will be applied with other patches that use this.  Let me know if
> otherwise.

Yes, it will be used by coming-up patches which will be submitted to
net-next tree, so I'll appreciate that if it can be applied to net-next
tree first.

> 
> I see that you also added the ID at
> https://pci-ids.ucw.cz/read/PC/1da8; thank you for that!  
> 
> But it looks like the "name" part isn't quite correct -- at
> https://pci-ids.ucw.cz/read/PC?restrict=1, "Corigine" isn't shown, so
> I think lspci won't show the right thing yet.

Yeah, I presume that it's not approved yet by the administrator.

> 
> > ---
> >  include/linux/pci_ids.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > index 0178823ce8c2..6d12b6d71c61 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -2568,6 +2568,8 @@
> >  
> >  #define PCI_VENDOR_ID_HYGON		0x1d94
> >  
> > +#define PCI_VENDOR_ID_CORIGINE		0x1da8
> > +
> >  #define PCI_VENDOR_ID_FUNGIBLE		0x1dad
> >  
> >  #define PCI_VENDOR_ID_HXT		0x1dbf
> > -- 
> > 1.8.3.1
> > 
