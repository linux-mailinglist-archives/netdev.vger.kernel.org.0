Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BD868DF17
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 18:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjBGRi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 12:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjBGRiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 12:38:25 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30504421A;
        Tue,  7 Feb 2023 09:38:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7JB9QxvxPJemZidkFQQqundi5J2yrUk48dTIxsRNTR21PQnD+t67if9ZNGZuodLxj9c9z/M20lEcdvHT4hOmjQxerCrJOVvaxIA+H8xdN1YnnKWYCxfXU3C4bIDFge98knMM9tWlkKbtYXON/LPna+0YSkQ5C+5aJqDJ2Aztk4Q+R6KDMx8ZnhzHrqkbYZN1aXqbNyqcMKIDEdYM1pgFN6JDAb15jb5sahibG1US8+kwId+3niQae203ZuxYpdCCQs+aU+MIl9W80r4a+f2V2wa1RZRGjuyX0E62Z0b4dE0IEqeMUvWWTY+B3pE18rXgH8ibSiokf4YniFvU/rRUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9lu6t0MN5pG54gOzRvBlq3lUhj/mp1omL5jl/Ph9fPQ=;
 b=NlzCzGacLYQ52YYx7beqJx2BcxX1fmwwzawn3PSgjobzvm2CGAwsLvkXwZ1cajtzRx8WnoVgHabcOw8a7pYnZZFzMoqhZJihM4rISKzQygA1je/zGZNs78DmatuUjwfo13vE4GdfoT6V4u8rFSiAsZDG2mhQwVGDd7p6pokNaaYTdHwy8AbenqDruL8d+ZJ7mAW5fExvvqHmghemCeA0QwaUHLowBT9QoQ/bbdE8EBBB2uIbf2UdO+aJkYMcMyZ7h0l3yhCpw8RHC99h1mMI2jq+uDKVuaFyMqPOxfnnu9qiU1BSkoWt9lipdEi26sJY/d5MQEsFzELAZYJegBxzZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9lu6t0MN5pG54gOzRvBlq3lUhj/mp1omL5jl/Ph9fPQ=;
 b=S0E+LE1iKyg3sHYyw1TaQckH0gv5m5CAi5a1+o6gm/xZEdded4Qw4zE4qSQf4kcFK6yqFgDDoyxO4R5KGiiUOhJgfjKTgDm8JfelqJQKg2G83gEghPU6eN3Kl1JlsH9/13NE5MyAnS51IPxQlhrOOvreVs6E6qirQQvCyIp8MRI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4785.namprd13.prod.outlook.com (2603:10b6:a03:36f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 17:38:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 17:38:21 +0000
Date:   Tue, 7 Feb 2023 18:38:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        helgaas@kernel.org
Subject: Re: [PATCH] PCI: Add ACS quirk for Wangxun NICs
Message-ID: <Y+KMhg145coygAdY@corigine.com>
References: <20230207102419.44326-1-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207102419.44326-1-mengyuanlou@net-swift.com>
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4785:EE_
X-MS-Office365-Filtering-Correlation-Id: d646e2e7-38e4-4f47-526d-08db09321b10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rBxGYTsCjLMvnGK5apeKOEN3qbgTgb3KhBDXdFanHGnMSXvAmxUPIXET7mvynpC2gIntMc9OLNJ9CfPSRUZBVuOyiv0NZ51844QOFbyWFf82werzgulETZ+gR+Kh50z87VY6t75DoPFZKdH+ipSi/fI/boKrTq7jq4Yx8IaAtjqJL6b7A47zhhG2tejn5uWB9adei+E7evU2e4j+WZUfRd9+pbikzhVvjoilrfS9z84tOHbVV48LXCXeodBc8Sb/z0ZnxK1MgkyWJon5J5CK/2bf1zCr8EkfmEjCb3kFlX/1ptQ1Z9uNHVWB1/nEiNWVhkU+uDeoLSNH+rng6Uat4+BiRKTI0V7UbbnojeG2dxsvYHeQXV16qPAn9k0l0P3RfHs5/16tMV0BssYKt/LsdZBaaCKi91H28NN/J778CS1f/sM5Gfmhl51vHxJSM/22wyLUnlBvZqZUc20Z9L8JFbG9AQ+uStsrei/AUE0ScBwuTIANtNg6skCABMTNDa7CauDqYUzw6B468T1YBMReqAQr+V5QgwsI8DXrJSjlJNBN/JrcKYzP6RnmMz92DGwLzrjOHaW/rwCtXQZ6A6YYQVe7OJfos3nlU6BFm4bH7WZBG5623axtxajzY2PHdbUT7D9/AEngMjvno30Vduhb3Ye8OtFTXJN5alNBoZABugaVrdwe6j3WMYahlks13gaV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39840400004)(376002)(346002)(136003)(366004)(451199018)(36756003)(66946007)(6916009)(66476007)(66556008)(38100700002)(8676002)(316002)(6666004)(26005)(6486002)(6506007)(6512007)(4326008)(44832011)(478600001)(5660300002)(41300700001)(86362001)(83380400001)(8936002)(186003)(2906002)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HBbytcFdoe8GyzCeCftaT94ABPn74yNI2rl/US0+qfhjkPUtwx1eMr4Mk1FG?=
 =?us-ascii?Q?B4/0ejbpEE6t3457ECdPhVfmxotCAqA1N0+S8TbopradGsG0JSYmqww1Ck+K?=
 =?us-ascii?Q?XZDm666fHLejHMvtTjUoO0qhJVCp5jrao/E+fvEBO9QLQzIMNkMm7GJfbDN1?=
 =?us-ascii?Q?UOtIN3/AYRC2KOG6vjukwy6C/VMxEgIYFfPUgNad5NPe0cWvtdCva1oMw4qj?=
 =?us-ascii?Q?0Ve0HtxXdbU90Ma3gDFFedMloPBXyQUZ5U+e258Ic6Bly9lsbhgg1A/BKDrH?=
 =?us-ascii?Q?aYySQ8waNYIm7866GAAmwcO3RbY6kc1i4FBzWtk8foD6bVk9pnoiqLJ5/ajF?=
 =?us-ascii?Q?0jIzfvTfw/cblLX36doMTK3j/0kDB6OfCTseeHRM/uJk8O86fpc6nSXnHyfv?=
 =?us-ascii?Q?h/qX68PysbdkCC86HgFluccgUSrzjfH616AWJ6WdqrFew05XGVR+BlwTD8b1?=
 =?us-ascii?Q?EP8uibzu2XUmn4MrXGlEa3Inu7wSQU4wjAyDS3l/8aLTem/gkM7GqXsZF6WK?=
 =?us-ascii?Q?/17M4/dfy0TsqvNGykAiZe7/NnCVgb+C8uObxldWxsnTDaFTHktE9KAgBG8t?=
 =?us-ascii?Q?wEkyX6Spnc67I5QV/DFyQ6GoOHl+25rE7QylNkYtCyCQ7IC+6KKx5ZsNMOCk?=
 =?us-ascii?Q?wzCtUEO6PyopMkQdljJbZGK7TGNXeeCMBlQvDwZlxgeposyh9Y6xFJEq3iGV?=
 =?us-ascii?Q?bfsh7thwcNiOL61Y8/omtVSw4hIGWp228eJ9sRkMqJyEPpEdyrXhZlEv7MqD?=
 =?us-ascii?Q?VUnSzADWFQ5R7C08Pt6mWVLhs1qsf+hj3LzXg3qXoHj9FhINaeKNGbxFlgsG?=
 =?us-ascii?Q?YiR6koipJlId68HgLBfa7eEXExiZq87/JeimZNiMyuPrT2Crn9pXEqQGj7A+?=
 =?us-ascii?Q?dpFERdhoZsFcgO8XL/iJadGCjqwxVs2zSHgFaqH9TclD0GXNiPNxXubzy7BY?=
 =?us-ascii?Q?EFxnoupmAMwLnQfkH0Tc+QPWQbby8nKqdKRiYv3ZGlsZL/H60G2oSOvfgAN6?=
 =?us-ascii?Q?/8D6nAKvRALUU2WMy7CDfz9+s9C3g3dF/JFy0MCtoOzTUng15g1JqLv/G7js?=
 =?us-ascii?Q?nMBIOtkEX57EwU8yEBDe0M+0FVABIFzvIIggTqV97r373p4qvVYgnAuU41sL?=
 =?us-ascii?Q?C63WkUZhNZSWxmjpmke/LRCIweh6JTy2XaAEPyTkZXdu8uZLiykoJYTtwo8H?=
 =?us-ascii?Q?bYMj3pN0Hox0GrZ73QpvBBqByN88iD3K7k1ydT3wQEu2KZq+DcegQ39DHzHd?=
 =?us-ascii?Q?3Ag1TyX/Lq0rOtf5mda584BCmBD2WLeMVIVT4tudC1F9emXD5birr8yv+uIv?=
 =?us-ascii?Q?Y0sOsdnpVtAomKN0tdCmYT4synRusUp576fC8/i6lqb6cmrIO9Iw6JF89JWz?=
 =?us-ascii?Q?XULfwHn1ewZwvUfW/R27G+VhnaRNj+VrLT2+v81SG3Ug9q7HxttL22Q+/Phn?=
 =?us-ascii?Q?zUi0yBm25Jk7f9wt1ZGMA88BSFQ9Z9wDKG96y16iYLESyjgVisWoRr71jnRv?=
 =?us-ascii?Q?EZIg5HwIQCr09/YYLkk9HppBxv9O6K2Qvq8g0JhKH5ywALmpmu+/UcZCmAXv?=
 =?us-ascii?Q?aPlKErCJJaHDL6K5u+AOXUmmMb8NQtWZ11ybGMb5yXZi46Zo+gLw7o9Gubh8?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d646e2e7-38e4-4f47-526d-08db09321b10
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 17:38:21.2157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DirYV+p7Funf9sfeU53KR/SGS1oV7lYiSyV4nvzEg3f3Fk4Izl2HRA0bR/jKd9BkI+h2Aq1oxbtx3qK4FXD2Ff6Bu8/5DKRTnaSEdaRiJOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4785
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 06:24:19PM +0800, Mengyuan Lou wrote:
> Wangxun has verified there is no peer-to-peer between functions for the
> below selection of SFxxx, RP1000 and RP2000 NICS.
> They may be multi-function device, but the hardware does not advertise
> ACS capability.
> 
> Add an ACS quirk for these devices so the functions can be in
> independent IOMMU groups.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>

...

> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index b362d90eb9b0..bc8f484cdcf3 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -3012,6 +3012,8 @@
>  #define PCI_DEVICE_ID_INTEL_VMD_9A0B	0x9a0b
>  #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
>  
> +#define PCI_VENDOR_ID_WANGXUN		0x8088
> +

nit: this is already present in drivers/net/ethernet/wangxun/libwx/wx_type.h
     perhaps it can be removed from there as a follow-up ?

>  #define PCI_VENDOR_ID_SCALEMP		0x8686
>  #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL	0x1010
>  
> -- 
> 2.39.1
> 
