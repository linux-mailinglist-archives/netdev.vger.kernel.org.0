Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4AC6BBCB7
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbjCOSw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjCOSw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:52:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2132.outbound.protection.outlook.com [40.107.220.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E815073F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:52:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUn6W9o81bhXDZj0TvQQayEJ8WR95v2X8TOU6+ksJpdRl+wptP0iiuAR6V/NYB2pBkvU2j9AOInnFMWXGT47848FLzc+zLX7Ehc1lXPJyEDoRcMs70ndYwSMPqtqAGjRdQsZM1RchFuffOYYlrnr6FtDurvpHx3ewTcaFTy9bbES66MW44QXaTZ3jxFNbVugJg+AMQoiU05Z0nZo/wUZSKQ7RHzkjUGY+EZEyityP+huaaldxHW22OpSvh+nj6yg+0gHy/UTNm8v0+EXDxyTeLzb2jt0qHG2GbI44NkmlEsedbYyOYMHjTjlthAmAbEN3o6rxzAQSVlMEgbMYPFVyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+KpV192WANW5/oK6EyqVc09xxIg5hjamOw4XNzqRVw=;
 b=cMrKXWyi74WCjmCDxYDwJ6eapYYa2Q5fRAjjJELmZBDOaGpQT7D/xcm+4r4bVgWQvTWVLSnpxQk5Orsq9hMMifDQpZXGmDTS9FW/LYepw7iEBdL03jqfhzmZT53fxO6czzJzyGW/cdaTK9SW/B1X95Mitm6InYYuYDwO4JRqw1CIXBqS7Y85Y7X7U315kEcdMLMAd/O0e+HSYw8C0HCtOVFrNhq9B4dpyy83Wlod49U/kIC7DFhswFSHyJbNXrMYWoqlft71jo3cYV5cInUtbVd37LloJ6XspeIHMUSfN/E1KQPLfxm4c21A5Pw6NbTs06idytZkclNe38c4LWG2yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+KpV192WANW5/oK6EyqVc09xxIg5hjamOw4XNzqRVw=;
 b=kJGfhme/XjztTQmpZq4IjkHnab7TE1EDtdlpYP1VvLqtSAxwRNqQ20wFqsnAGrrz/WWBQyhBwv/GJcE6NCnKxbWNIjm4071TnwR7NlypEpqexmgdv16d3oioUTc0fZNJDIlFPzTz1H1tf7ktyYhotI8Uq6sw40qT0GShAJMWi04=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3690.namprd13.prod.outlook.com (2603:10b6:5:24e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 18:52:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 18:52:23 +0000
Date:   Wed, 15 Mar 2023 19:52:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 1/8] inet: preserve const qualifier in inet_sk()
Message-ID: <ZBIT4BKzACzHZxBy@corigine.com>
References: <20230315154245.3405750-1-edumazet@google.com>
 <20230315154245.3405750-2-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315154245.3405750-2-edumazet@google.com>
X-ClientProxiedBy: AS4P250CA0026.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3690:EE_
X-MS-Office365-Filtering-Correlation-Id: 87b25e6a-3513-4179-2d39-08db258669a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: niRn+W+J4uNhTD2MnPaNAttpbQMWrG1eHkPNA7t6kHVTGBpNyzrDIbJH4pFY1m1jXfQdOkdjb1scR8m+54C5wmREI3b9r3dXtMQOhjdBccDHg/jv3RfDdeaFSzzM7UVCMQGrFQ532hCZ7ZD9J7OjADhNZsW6yIYKWTEp+2OK8yY4eYEjxYcLYoQcTFvRifaFT15ypmYiBpXJu8FI/Z2dQHa0h9yUDanZW8UCextIl4aZPyV4BHcytlf3ugis3+1DLTQJmdXPux8RYrJCo7YfUrj3z3Y7MMEet6VIboZesaRtsBkvljPxM6ZQwb7y0OrM4+apl/BNu0eifSKJOcQfGckm6eKCQ2y84uFAm4LMXZj2lzl6qa4wLqjXsY3/zjQl4aTdLxSagTQTXFg71dRg0X5f2qtBAOLatbMu+3ULaq9IvfJtnsskDKu4DvknmyWan61scnzFro9UmOEXVrSnEeNKxxEERxfrovjp2s9Fl3Dsfv5FwDF1KiqG+d6dc2kln4faDysWcXbkUU8IXZg+JwnCD8MG+Do8JFTRzm9FwKNUEkDECb6RR7sIKH2hKiOcl/0pfIw3f875k+i6362+0YSvyb0V5mzbFTt/MArOG7NwMNRVjO2Zclwsxpjnb1pYnIj8J4Q2Ei3OCK3afThh8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(136003)(396003)(346002)(376002)(451199018)(86362001)(36756003)(38100700002)(478600001)(41300700001)(44832011)(2906002)(8936002)(5660300002)(4326008)(2616005)(186003)(6512007)(6506007)(54906003)(316002)(66946007)(66476007)(66556008)(8676002)(6916009)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FTvFoNRzvJzsXc0d4+XxnHeknXoshxMgtEpjXgk3yDN2NjAW0CeObiPekBLu?=
 =?us-ascii?Q?hO7xbVQU0hSlEbeVKnwUNd5RDM1+l1ZRTtr2QpMFgqnDyg9L62vmbknkYqSv?=
 =?us-ascii?Q?I+B9CPzRDVWDG93BmxY2fZV1Yo8APmIGfwtFqvhSh0ikshsozCNFjzhykl4I?=
 =?us-ascii?Q?eSxYDW+0Pdd32HwKO2OtCoB9QxzxQSCup6iaQ/svX05O3SaplU060S/WhbNm?=
 =?us-ascii?Q?Qh5nGx00p57iom7gfAvxIhv77P+r8I0X8f2MzAUX8RoM8nyKpNX+MXmSvdSk?=
 =?us-ascii?Q?Vmo22+VpCp/c3yNLOhv1gOc2ZPJ455iVXTGDEmPjL92DVYlTcqZBuxhIAT/M?=
 =?us-ascii?Q?pT/JXFoAF+hckBNxnemQMex/CVCIRzZSdmqNcINdpXxsKjM4pGau49grAgLQ?=
 =?us-ascii?Q?TGJxzFUrh4oFEGnKCGPophkB5olRRxKL3A46ZLkRskZyLMOE+nZKxCKSI9b1?=
 =?us-ascii?Q?Si7YTiml6UDB5voGPWfjDqBQMRW/HuI3lvsSEOONnkJLVHKcCUMsxTuBWpDZ?=
 =?us-ascii?Q?eRvv9Mf2ZcTlZfZrTOx0l4+wWC8kt96rPfl5tG9j/hXL0rWYov15rcmzPwNi?=
 =?us-ascii?Q?HcoeS2+ZHiGlFp1CAN36qa2BDnQHoIgWw1LKRoDBJbHwyVsnEOtDKo7HY695?=
 =?us-ascii?Q?/hgl8G/GQBRkjKcAcX8o7znEZ47wsA1sjVLHB7Vf0W6ejfnL+0tEm/Orrh4I?=
 =?us-ascii?Q?qFelPneEUgfGOMgsFTtn/87jr3bnVY9YTdv4w6GlybhR1QnYPE2rQ/ox+9yH?=
 =?us-ascii?Q?ZjZXofnJ7LHGIxZQuVuTbY50727mcLxMnlDnd4u23lDQu93Pycnl4EssxLZJ?=
 =?us-ascii?Q?ojUWcaXoYKDxKh18I/A3oP8J6Hiy/+LH1wu63vSVRgreaXc5EL/BuhM/FXmU?=
 =?us-ascii?Q?MpZXLG9HjYZMemsmvUaLXo+kG9Sbk2oE6wTxTYviyq9jkscohOuKbSPgI0sk?=
 =?us-ascii?Q?JSz521hJWWxd9ugJpmnhqTibG9QxEU07HX2z7HDQro4Qi+xmgdqjIngRFGUk?=
 =?us-ascii?Q?jo1d7QzGA9/Xw8VsoWjqH797C7yz5jvtQKBxaYtndNjKNP/86TVYRP7TSFK5?=
 =?us-ascii?Q?kMO0iY9ensdKqjbUC2qnK8zGVvlHMbdFRUK+8IUBoNjKy5Q3asZfkm1GAK9s?=
 =?us-ascii?Q?vBO4fSWCWvnJOWlBV/fIZF/w47w1PcJeP1e7ePeq6UCUOpwMakzEXXBaII4K?=
 =?us-ascii?Q?zn1nbaHUIxg/S6b+Oezt/wl3XEnznE2yjQ5VmMkm2kU9dNR/Mu4O1dZVqNc1?=
 =?us-ascii?Q?3D37VAm6ndUE7hmlxipwg+/bSBC9xiTaLF1HgUfvNI09h49mGxOZoTqf4Z++?=
 =?us-ascii?Q?QvuAmEM+TxGjqkyO94eVYY7/Zyq1eQMD43QJEopOd9jx5j9/cVXUwwfWxcXC?=
 =?us-ascii?Q?nTB3kTqp50+cXw+FQ4EBSY/AbVLWduYzFUOkE9hxQnfKMP1NS0tyJ/kSmOCf?=
 =?us-ascii?Q?9ZGdC8HP1EQnJnhfGZvsl2Q7AX66we4ZCnXcGqYrhPhxGPrSwCqI3YYD2495?=
 =?us-ascii?Q?Gfw40UmG29e8aQX3wTUeRFCFm0uHrO6+Z/Slln6g6UBxdvw8FBGz7i322pUs?=
 =?us-ascii?Q?0AZlVaf5GtjkWLqabVPATbw5KVv56JK89DyDMZh9JLRuM8dfuqKeIcpbpgKY?=
 =?us-ascii?Q?DaYQvYoHFMuhnVCaKKRKpwauSlK5bxWUcb09Je7rgTMlTwuXEQj/JaQjfvYi?=
 =?us-ascii?Q?tOU98Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b25e6a-3513-4179-2d39-08db258669a2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 18:52:23.5995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1cSqCRF3Uqb/BDo7po3Qb7SAkUtLipmwRnhAnZYF2xFNhDYSd00GOAYGoqaIk5hOYPWCLz96vydIgwbJBSNdt3OimGnM5xoxdJb/k6oGrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3690
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 03:42:38PM +0000, Eric Dumazet wrote:
> We can change inet_sk() to propagate const qualifier of its argument.
> 
> This should avoid some potential errors caused by accidental
> (const -> not_const) promotion.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Thanks Eric,

very nice to see this kind of change.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
> index 51857117ac0995cee20c1e62752c470d2a473fa8..6eb8235be67f8b8265cd86782aed2b489e8850ee 100644
> --- a/include/net/inet_sock.h
> +++ b/include/net/inet_sock.h
> @@ -305,10 +305,11 @@ static inline struct sock *skb_to_full_sk(const struct sk_buff *skb)
>  	return sk_to_full_sk(skb->sk);
>  }
>  
> -static inline struct inet_sock *inet_sk(const struct sock *sk)
> -{
> -	return (struct inet_sock *)sk;
> -}
> +#define inet_sk(sk) \
> +       _Generic(sk,                                          		\

nit: checkpatch tells me that
     There are spaces before tabs (before the '\') on the line above,
     and this macro uses spaces for indentation.

> +                const struct sock * : ((const struct inet_sock *)(sk)),	\
> +                struct sock * : ((struct inet_sock *)(sk))		\
> +       )
>  
>  static inline void __inet_sk_copy_descendant(struct sock *sk_to,
>  					     const struct sock *sk_from,

...
