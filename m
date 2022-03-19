Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41374DE54E
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 04:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241301AbiCSDRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 23:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241900AbiCSDQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 23:16:59 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2118.outbound.protection.outlook.com [40.107.212.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C4322B6FD
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:15:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzZ59LIZ7vDiNxOMn7zRi/k8wN3t8eaxF7xLRiLWE8KtY+rXO4U44xn2lxGpl3w0yxSb+33DjRs5zV87ap92Kz8RDwkbP8h4wb3hyOvP9dRXmASB2k4nYC2SnYep5+0B4xnGa8S2CAwnDlQoFHzr02ORZvfAfF000gKXj5W2IQk8Xi0Gy+fUidNWZfoG7tPB8sncK4VOiNqPZ3fAn8FF15PvVpxZmt7mXofE8wphnXXkRFQE8zCbubbk6RALaBMe88uJFVpbVJImgersmWoohzguwSIIJcG0zAQDKprkZr7Sys6OxYTRSzSumGTQ2PPaD+0dbjw2XO9n6+/FeHLNqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2yruG62pV/9sEXL5aZFy9EHHRlaR1NZTSC0gWg/gNBc=;
 b=O+/hJNHoaQ57EdL8HtEZhAkR2qYsOQ6MLfk/mXNTE8xV3S3yF4WMA4IAgW6jvzkP718aq/5mrA7rR43/05R0aVyrDmV6ZWFO1ONvoaInBCcrTizYZqTBP4ViZ55fSFFuKpbsUF9gRyChqxVbqEen5CCJyHqkxKmjNkrdN0RMOeokyJZZEPdkSIpRTJJcxGh5fsVfbSSn12soeUdjj9l8gaydJrAhlOBdF3L/Rh+fcBxS1dV4YILOB0+SIq00W49GycLoNIc7dxZagW4xmhAG1FFAihpj6OB2sLhkRaFPgkMJg8HbS8utQjWxkSU183r6/xSq5N6hvBbBiOqYLZpgVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yruG62pV/9sEXL5aZFy9EHHRlaR1NZTSC0gWg/gNBc=;
 b=tQJcoP8N0Kcgi9lL54K4C4rUuG2NRaeLvxxI524ThSfVGhx2KG006SApWv+92lF6+iJQwLzxWDDH2JZC0pK9WijkaSMhGwm2zFzdVl4ZiDlQ1ssqtvkyIU6C49/zpKsDpq9KFrFGbQqxkjS0trWLC0sAMmKsiYeVb0NJcWNeIlo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by CY4PR13MB1286.namprd13.prod.outlook.com (2603:10b6:903:a0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.11; Sat, 19 Mar
 2022 03:15:36 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::755d:450b:de86:75fb]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::755d:450b:de86:75fb%3]) with mapi id 15.20.5081.015; Sat, 19 Mar 2022
 03:15:36 +0000
Date:   Sat, 19 Mar 2022 11:15:29 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 10/10] nfp: nfdk: implement xdp tx path for NFDK
Message-ID: <20220319031529.GA22805@nj-rack01-04.nji.corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
 <20220318101302.113419-11-simon.horman@corigine.com>
 <20220318105645.3ee1cb6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220319015546.GB18238@nj-rack01-04.nji.corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220319015546.GB18238@nj-rack01-04.nji.corigine.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: HK0PR01CA0056.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::20) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e0fb253-3bd6-41f5-c93d-08da0956bc61
X-MS-TrafficTypeDiagnostic: CY4PR13MB1286:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB12866343FE44C20BE386D95FFC149@CY4PR13MB1286.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 680cpm9CrfYtCX4Ho95Zb7X4RjPmqIID2eUvqcPUSO27urvnVEverRaQ+cKD+TdAXVXOJksdMKDSVVXNAa5Gy7aXPXRDLdJdQUjM76aG/SXeyW27K16/HQItGdjbrXNw+a9cL6JD062PI+rA9w2sVAY0/XHaWLivAsj4kqn4xXIlzEWIP5TuqbtmR8E8RIi7KgkXXF42JFCSjrMIeCuIs/kZX1pphXEzHWdAwG3YehEToA1gxSIw8XSuURLvQnrnsJTBoKNcthxFDOzoVqRuxdR9saBJBYcCdtdllYO1NNm5BB+TL4Tu1X+A4LVuZAVVATx7jBebPsaPRWy10rzdoaGIcXYvW/MXGj4JJ08TfGnGcwcSnpcVza71L1wPVFC7TyM5f0PPWHZ89hgxdkXGvBwFXUl7q3peadDb/n1Hg64PKg6mXURRHWo+ETrFZb+T7XVUWxPEIFdzyXh/4kcnIrN4MMV+HCuuMC2rL2oo6qKkTv3x8l1sNuEsCLLGCk3ZyM5Gg9njvc4CImpnblU24H/kOROgK4JW9vDeTxQ/8HASgqxuk23PTfAR1NScfxqho1xsPekpzVZ73vIA3kv21anf4Wh4ujEUBUsMz2n8zjmaOCbeqocUJ7fbox5DkijvkdfMVojL0r9/9E6U7J3XPlzvJYsuV1fznZFl+yezOqXRnwyje8XTc68zVruMXDxbtwBi8X9AlWyYPdnc57sdFgpnX4hlCDOsEjmE2FvsqQZqI4VbxRgxLfUu83BJVn6G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(39830400003)(396003)(346002)(136003)(376002)(6486002)(508600001)(38350700002)(2906002)(86362001)(8936002)(33656002)(38100700002)(5660300002)(66946007)(44832011)(66556008)(66476007)(4326008)(8676002)(83380400001)(6916009)(54906003)(316002)(6512007)(186003)(26005)(52116002)(6506007)(107886003)(1076003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MQwuVrffs64A2+NwXaQ4perlw57p3NbQQuO78/T6HxMQTW8dreCxEQi7VRah?=
 =?us-ascii?Q?Cqz3A/LygZmyxEJSBzGot1H80oNK+doKwQ5f67Yj3iNtmtD5zeXKLVvnnfRl?=
 =?us-ascii?Q?RCkuBtDBojybxqSKTQCn43HSZxS6mepqjj0w1RaZJnTm2cq3IQykfZHfBqVM?=
 =?us-ascii?Q?7uxuink9y1WHTcycU0oMG9B5Rynqmw++Od7lAy/IRdwtOXg1RmvqoxRiQByn?=
 =?us-ascii?Q?VA7Dr7+8bP/TbxD8EcqFyU2kKTU/8UivhenpM+tU4YPT2b4I2gSE/ve9X1vx?=
 =?us-ascii?Q?PU0LueZlQ0xvIGf79FnnZLC5gTTsEAxwWQioIkZu8zb98/wk6pZ0z0gA8nbk?=
 =?us-ascii?Q?XrQf7KVyT/318IpZq2vazF8eiVXtIT7TPQjtazxFHUJL4p3Bj+mpIPK+SI7S?=
 =?us-ascii?Q?zdqcfUV1us8xzy7GL09khUgGYuTIes2FjoXs4R+BuIvd9h9c9gDkNePcFrw4?=
 =?us-ascii?Q?sXwD2fJFnk5HzOqU7r2+V+uj2zYHU3aVRBd+2DwCfVFzAktwJ4fwCXVLJ0mJ?=
 =?us-ascii?Q?Gj0uvErlyjAefjg8hvGzLwOABsaA+uL8G7lHzOUAjh2CH5P7+BYxnP+5havA?=
 =?us-ascii?Q?tW3FoJvvGZSvpNGnoYY9h6FIl+rEwFhxLUWzS+PfbUVL6NQZR7vZacusxuIT?=
 =?us-ascii?Q?PJItyi1dBERcO550tC87Uy6QYL/NspENluxr6J0rk1IifpebSXhevQ8pkDL9?=
 =?us-ascii?Q?blj4ZUYePusrz1WHtzPGxkVl1P9jlIT4mc/2xNEdxsPxZyVORMjceXRgnVvv?=
 =?us-ascii?Q?P0vlBfgUhq88QIgv9s5tf3eoiYDGsAoB4EIlWojMSLrHFSfyDlrQtx17fQH3?=
 =?us-ascii?Q?52ViC12MYzedeDHJsBEDF/vk6olLSAT4ofKGA69AnHbas44VxmqTKy2Qa82w?=
 =?us-ascii?Q?EXCVPypzdr1Pm79F+p6PSAm/77GtkjmTi2KmRex9+bF6MyZvXPqYkJSl9lS7?=
 =?us-ascii?Q?mF3DoyjHX+elFguRJWcvRAtOwtR5/QU4CzV0vk2VfDW8T8e5PTXFX8jOW/XJ?=
 =?us-ascii?Q?EtK42SaNZ49j0PlKGrQX3KDRe2vcwnvIgjIIfx1W9hiJy1RS7gQkojdWorVz?=
 =?us-ascii?Q?aeWE+igZ1p8oVeFSqQXSnK6dO4UNQewD+g2w/ZuOzCyc6NoDYHc0Oka/gUSp?=
 =?us-ascii?Q?OrWpIrvjMtNv3rOTaQ5P04d+NBvwp1mVRjgKZ5jwRLPlBMRSzQXxIFj1gyZH?=
 =?us-ascii?Q?O5L0Fwwe0E/e0TjL/wb8lnv3RRXRwzNYZeYdUdka8lqW9V4uIVER3KIqJV84?=
 =?us-ascii?Q?vfwv6BQqAIW9SNViHpJI0T0mScJS5cWTVsoVZJNJc8l0dDyewdfueZ9y395t?=
 =?us-ascii?Q?DOU7IqhjgX9HUAA6BOaqknBL6Ts6z5ClOKBbxVHTjB2CXWuJf7kT6I+laIHD?=
 =?us-ascii?Q?J/ifdLqob1pmdxp8cBpW4yyALft5fD1d8jthyg38Ah5QI2+NWAJ7ZMLPSGgQ?=
 =?us-ascii?Q?hBfDjHGdqbrF/aiLb6ywuZ5buusdNsrRpoJh23blFIofB6GNV7axWQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e0fb253-3bd6-41f5-c93d-08da0956bc61
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 03:15:36.0128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: duccq+PVzUGJb9P+Qhnk2sG+ArXnng2Rvsosrvaon0CP6vciIzMMOAc6g36QnPxGKqEnjaN/Pyvg1FqnZk+4AaiYSl/qQbMYhJTRFN9uCas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1286
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 19, 2022 at 09:55:46AM +0800, Yinjun Zhang wrote:
> On Fri, Mar 18, 2022 at 10:56:45AM -0700, Jakub Kicinski wrote:
> > On Fri, 18 Mar 2022 11:13:02 +0100 Simon Horman wrote:
> > > From: Yinjun Zhang <yinjun.zhang@corigine.com>
> > > 
> > > Due to the different definition of txbuf in NFDK comparing to NFD3,
> > > there're no pre-allocated txbufs for xdp use in NFDK's implementation,
> > > we just use the existed rxbuf and recycle it when xdp tx is completed.
> > > 
> > > For each packet to transmit in xdp path, we cannot use more than
> > > `NFDK_TX_DESC_PER_SIMPLE_PKT` txbufs, one is to stash virtual address,
> > > and another is for dma address, so currently the amount of transmitted
> > > bytes is not accumulated. Also we borrow the last bit of virtual addr
> > > to indicate a new transmitted packet due to address's alignment
> > > attribution.
> > > 
> > > Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> > > Signed-off-by: Fei Qin <fei.qin@corigine.com>
> > > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > 
> > Breaks 32 bit :(
> 
> You mean 32-bit arch? I'd thought of that, but why needn't
> `NFCT_PTRMASK` take that into account?

I see, because `nf_conn` is allocated from kmem_cache which is
created as 8 bytes aligned. I'll modify our implementation.
