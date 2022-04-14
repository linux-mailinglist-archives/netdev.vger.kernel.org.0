Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E95501E46
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347015AbiDNWas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347011AbiDNWap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:30:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4ABFC4E02;
        Thu, 14 Apr 2022 15:28:18 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23EH5dxk023270;
        Thu, 14 Apr 2022 15:28:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=6Qy9kUyU0eZAN13FNx/57FrDW5C/bMIY/znM5fXkHic=;
 b=Gkvk7zutZbPikncZlajQYxDYKQXmEVu2nQMHh1rkwoSFCmhmn/qzfqCNY1RcJsMPH9Fo
 xHeoWaCRPSwfRsitUW4/VKPzZTWEsugSTA+63j55Nc2fQypIN8+QNqokSFEnOtXbCK4U
 pFlsWajpMGFa3BGa93MzjjKORXV70zCTihg= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by m0001303.ppops.net (PPS) with ESMTPS id 3feqq8a388-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 15:28:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DAK9XHmNBJTrvZNvBT7KAMd6mndGaYcscOl+42tioI/tpVxRWjw0n8uZk2P5GtzdEvsUpp4QJHG0JfCI6i0KD4eK0/tYlPsect/gNnd6GDqv+pfi73nt4avIrYnTh0MHP9A3POed61euptrrlmG/NdSir/cC5+jIVdOKJCtZ+wDMNHnCBr/1SumyS6cFgG//Npbn4tiQcuX/BV3fpGzEGUhKXNnzdiNlvxgPkrIvMjYQn0T3iI+292jVseDjZUn7oV6KI+1dW38lDG7nNSiSDELSBM2YNdHDKynHIhJ+xXvQ0Zm8Dg5GZGXUQ6nvpCRDVgKK3LSXeBpM4UQ6RMMSOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Qy9kUyU0eZAN13FNx/57FrDW5C/bMIY/znM5fXkHic=;
 b=lF345FGPsRn0cFsx9aFu9YM3ZHeuq06CfLtCBM5F0dgnpyuQD7NLOfGpYDlQPgaUFxy8/2zd5etQkbP3yQphirJx/jU9DT28AsPG1sE+JU3aHoAQAnhyqFWepoDzLhuQLx9brUjWdKt8B8MJfqjwrgH9VVrVWOKLsUVMy0PXzx3hv6MHq4xdnGgu0QwiJTvGPKDEBStExpcEMI4Lq/5YnYdGwnzj80xXvouf2Jju4bO0XRA8uFFQHTGfgutz16vO/LaOjljuA2EcqWb+uG+2Ejb9qWchLPIEjKOT4CrTZ1BRaMftrzjycDBqtJ+KULf+zjKZVhhkzUgeJJduFVCGrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR1501MB1957.namprd15.prod.outlook.com (2603:10b6:4:a5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 22:28:15 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b%6]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:28:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Liu Jian <liujian56@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "sdf@google.com" <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH bpf-next v3 2/3] net: change skb_ensure_writable()'s
 write_len param to unsigned int type
Thread-Topic: [PATCH bpf-next v3 2/3] net: change skb_ensure_writable()'s
 write_len param to unsigned int type
Thread-Index: AQHYUAeHyKUOjUE7/0a4cal3mPGSmKzv/c0A
Date:   Thu, 14 Apr 2022 22:28:15 +0000
Message-ID: <2AA08189-EB2F-4240-8FD8-49F5A4786500@fb.com>
References: <20220414135902.100914-1-liujian56@huawei.com>
 <20220414135902.100914-3-liujian56@huawei.com>
In-Reply-To: <20220414135902.100914-3-liujian56@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0776abe9-04f1-4135-cd0a-08da1e66115a
x-ms-traffictypediagnostic: DM5PR1501MB1957:EE_
x-microsoft-antispam-prvs: <DM5PR1501MB19574D0A54DC2558A33F8EFDB3EF9@DM5PR1501MB1957.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mfLWdxDtlmqce0XCjn4sMZ79e0a26QybXfMrGLtZ1V/lRMO2WZdBQblLYzlgRhQujiaA/f2rXRbTcEIt41jnYe3m6OM5aQhmfk7MTddNGKs9OAJ/rWcFj+q4C4HyNzzGz2Gr3ujG5e1do2wuN+6MeyTdj8Rfnr/D0vysS6OUCuUVFs2CRMzryV0wfPzjyFDgi2jHcYSpyWx/j18To1cdc4/oDfKeJxSYo5OXt6Laj3YX2bBl/Hj+EHjRqilm025BwpAqsbNBjCNhwxMyhkWBky0f25Sc4ub3yayJcvgkxD9bh/Tr7rjV2RjQxUo7jCXyNW57yoPbspWVdfLfmDP/6svf+6V/z9vgGKorTwPjU+mcT24yD9HxJoB34DzNa0zzR/M9avpgdEm0nuhNNGsbHzkkOhZF3aFxu21UFFJiLitJ6DE9EDojHpuZjdyIODIV9hf3+pbBQQ+WtrYElvJFLt9E2eKbzOyqSHGdXTYrTI0Ade6J0lWhN0oVRYAr5gKKwZQxm/LLq3saWfPjelwml4I06VJRG40orFah12tJNYBtbqPO7mZ5jpcK6aZWdKu9NFEG1eKP8xzzEVTAnpvG5TMaVkdhS6cG0gCkuAOF2Dz3+NKnvm1qBd8xg7vXRiU4eCMu/uU8iqB7J8ievf8r8KQr/Iwr11eM29un3UEAunzHBNblS41N5Xk6T68HsKFIg4VUKXmLZDWC8EWBBz/09EIAIGwxx4o7rRh6VnizcI905YAMtmUfwocydP8s/jKw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(36756003)(66446008)(186003)(2616005)(83380400001)(91956017)(64756008)(66476007)(38100700002)(2906002)(66946007)(7416002)(71200400001)(122000001)(8936002)(6512007)(33656002)(508600001)(8676002)(6486002)(6506007)(38070700005)(316002)(86362001)(4326008)(76116006)(53546011)(6916009)(66556008)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?L2hweym68gtwoiHkAVVu5tDKV2yIiWReNx3NIsGpVTqpB1ZR0S/t+s6Bpu5m?=
 =?us-ascii?Q?13TUH4jqm3ytNNAf0sdqjfihzFhV0NqqNWkhjOUzzPa0pFf4VdVxPW/ArGNC?=
 =?us-ascii?Q?npkotF1swTm53gNB6HVVmRGoWoa/Qyd17omu40hVRXGDdyVv6gh0IatUOh9m?=
 =?us-ascii?Q?3Ez/HEVKY5uN3mlU8sgzkq/1JvuSZcnTFkKcBUV1/+l/0OIqK5H5jFd6hbU0?=
 =?us-ascii?Q?plRamnWUg5v4ce6bvw6iSbAbWAdv0dUSukMC8hj3G9rIc/nWuvvb30nUr57k?=
 =?us-ascii?Q?Bu8tA/0CwltYzOvoSM3Y38We2Fo4FKy6sUFjHyNezE0e1zawAAwgz2eiTGa9?=
 =?us-ascii?Q?YL5KevHOcGMPCKuakIkhr9qMhAQrDuPE+4qtassSktXM8RYqH+PasrSZIbzH?=
 =?us-ascii?Q?WFkL8ZWVt+taAiW1aWWJrhk4RMj+erdaxW+njJ76S2XUxWBNcdPhH4FwwaHy?=
 =?us-ascii?Q?e8vnrYm6xO8PiyAQUUThDoZ3jQLtdne4hDHeioAT9foI7qvC0/yUwD/8dvYu?=
 =?us-ascii?Q?jbmJqgJm2V/TrGV4gIxLC3ivnMNhrrWRSbOfvnl7LM9CxXOTVTEIW4l2EgXR?=
 =?us-ascii?Q?Pk7qd/SImidG2hwwHw2zxYVTvOy8d1MqdUSdSLeK8W1x9Si5g6nfsuZ2dI8R?=
 =?us-ascii?Q?PjK8J6G1kZPqnnHpfxY5Nd2CCDy+MaxtDmJG/xtRpDHBUZpc2ciBmSVQd61V?=
 =?us-ascii?Q?lwnNd7x4MIZ05KsJ7gJY++XKHZ8nvKLDZ3V7IrGJa4BYpVdyTlmshTrFRzSz?=
 =?us-ascii?Q?wt6HZnP4CTppYaxVDpdkq/EXwtoyYHMiX5Vjjjq1iq3pvnH9MWfr8epH9GQX?=
 =?us-ascii?Q?VciRQTySfRlwslUjqgpfAooFyBaavY4yLMZ4dtZE5YwfhmKebcHcWQ/gKmRz?=
 =?us-ascii?Q?V3Z0kpnZT7876CeHYM5rGFfswREms1mXF3Sxfspk/mJvlnt4E7Pdr8tlS1F6?=
 =?us-ascii?Q?T68db6gKk2UNlBI18kysWTlwc+8fOymDYG41aHuWt+LU1MNPogIHEBhyN9fm?=
 =?us-ascii?Q?wkZjWxKlHJCYOTnJAP+VR1NuT1hJXCtLA9/W5qtVkgtS161Zk0z1IcJ9iql2?=
 =?us-ascii?Q?pYmoTQmYfWm4J8qz89aEW8uVUDEXUa8yrPVUud9O+LNRLqKd7el4p9XvNrZe?=
 =?us-ascii?Q?We7CN2Xik3GIITFolqr9hZufFVn6mubDRf9E5kQnGqDJXgt/YTXB2opO6QLO?=
 =?us-ascii?Q?yxnPulRdtHGEdcwrl7YjOPcobOn3wed6J0Kdgbnm4n/myvpwWFRGfQ+4uCiY?=
 =?us-ascii?Q?57xo3+st7dZFBA4wE7wWt9TI4yqAl/CU2E0rkHn2VIcfD28vNnN81JPvP80s?=
 =?us-ascii?Q?BmZmjAuxM0dgN2yZtj9epN5B8UgXgUusE1dAb4AT91PYlaurVbOYRqH2EXio?=
 =?us-ascii?Q?IUcdZOX6a7tYB5a18ek7WHW4IKfZtXvJP8J8AzYGrdghtpbGHt9+dPZEUJjM?=
 =?us-ascii?Q?vkQVKLuG9m3VTOwS8pssTrZslU3osKhlsqznuYFv8PSBfl70zSF0Aiu2HSXl?=
 =?us-ascii?Q?LLrJFdaVhZ6FCY23LWUpPU4QiR0ngCnrQwKCFhnT+X00mRlEdHoZRWZLcPre?=
 =?us-ascii?Q?d+WXaVvExqngjYvYQifOrTxxQZ6TOUwFxf5rSGHDIwVuBIPBvAxxz2Tn05ug?=
 =?us-ascii?Q?HuzdWzbtw6B05hy/BHTPqIY/xmi8FX8hyqIwNzGv/aLp9Fvg3sYJsRebL1GP?=
 =?us-ascii?Q?jTFKOccEL8zWO95n2zdTEJUiKWQGQIvvRnpm7NrqPhwY+5FMJwWgAn2wR0cP?=
 =?us-ascii?Q?KAmyUC2Ekl2leZfNKWA/Kzmt9Vjhcl+lsol2KYAHpc0kEZ3OJLru?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C8C1664531C7EB45B117BE835BAB9EE3@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0776abe9-04f1-4135-cd0a-08da1e66115a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 22:28:15.1913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V7QTrEjuPLTGi3Ezdsqzn8fzTesBApbRuv5FP2lSZATgne+76TPlrIbeB7NxaufdppJVJfOs28vlNnZacI4R+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1501MB1957
X-Proofpoint-ORIG-GUID: EpjsJVgwsE2IW2q9r-CE1ikBCgcIFUst
X-Proofpoint-GUID: EpjsJVgwsE2IW2q9r-CE1ikBCgcIFUst
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_07,2022-04-14_02,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 14, 2022, at 6:59 AM, Liu Jian <liujian56@huawei.com> wrote:
> 
> Both pskb_may_pull() and skb_clone_writable()'s length parameters are of
> type unsigned int already.
> Therefore, change this function's write_len param to unsigned int type.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> include/linux/skbuff.h | 2 +-
> net/core/skbuff.c      | 2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 3a30cae8b0a5..fe8990ce52a8 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -3886,7 +3886,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features);
> struct sk_buff *skb_segment_list(struct sk_buff *skb, netdev_features_t features,
> 				 unsigned int offset);
> struct sk_buff *skb_vlan_untag(struct sk_buff *skb);
> -int skb_ensure_writable(struct sk_buff *skb, int write_len);
> +int skb_ensure_writable(struct sk_buff *skb, unsigned int write_len);
> int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci);
> int skb_vlan_pop(struct sk_buff *skb);
> int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 30b523fa4ad2..a84e00e44ad2 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5601,7 +5601,7 @@ struct sk_buff *skb_vlan_untag(struct sk_buff *skb)
> }
> EXPORT_SYMBOL(skb_vlan_untag);
> 
> -int skb_ensure_writable(struct sk_buff *skb, int write_len)
> +int skb_ensure_writable(struct sk_buff *skb, unsigned int write_len)
> {
> 	if (!pskb_may_pull(skb, write_len))
> 		return -ENOMEM;
> -- 
> 2.17.1
> 

