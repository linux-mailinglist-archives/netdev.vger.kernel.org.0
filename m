Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488776DE25D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjDKRWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDKRWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:22:14 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11038122;
        Tue, 11 Apr 2023 10:22:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiSjZxHD9IWnDadNDOvdgHVAjtWxeOdxvMFFQUZry6Pu1v7ttDrerKqZx3qJaf3tBZCSOJnwhaqYrewd7/9Yjyc/uomSIQgRihCA9LMR2OGzRxVWDd2+ll43sN/Gv2FNGlwQsix4gApOKBuemqgAmpa9cCed+5QLxU8iVvB2zWGX5BrsBZFgC7YZcPTH8Vu+YID1jyc9JBzDwL503lnGMLrV8mn+w6G5LjHQ7G88dVfn59HcOk0qO03xT+83zDXN5/4GOlBL8gttrt1a4LfEpbvV0XZWHWniOnOoGGOvhXalilioRc9EEE4g4kNaWbXA0hXUvV4NFdcg9dRnBgQPpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oxf1y/vV7Apt8hhPIhYZnVjhgKJGvno1B3FuVUznCTE=;
 b=NrqJ+hfyZjBBVR34whNTwB3wkEcXaIKPDEQCZdrhKWxdMTBVOb3+Ojh9K9+fa5PSThS/8pEP5T6aKwK/8zWkRjTSqNSANkRPb5RqAunPG9bCmGd/dOtnj7QsJ9IJ+Rke9/ccJ/kLQD5KLiqHDOh0QJ1cJgckCYZMW28hoITYHAWrLBGUyoc+qK/p8YYbwClgm9mP4NWL/TBQ67FDQsFOGYhn+KDWtw9lrOyeDvfORkCPbR/nmxAEag/W5zLOzKwP/D2BNmcxepqnBqTxs4oEBj9q5s84sgULwM1cdp2uAaPvdE9eNNZzgBlo/TecdBaTRMjDFoxeiaG0WmX/reFNcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CO1PR01MB7306.prod.exchangelabs.com (2603:10b6:303:155::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.28; Tue, 11 Apr 2023 17:22:08 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::342f:eeac:983e:3e2f]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::342f:eeac:983e:3e2f%5]) with mapi id 15.20.6298.025; Tue, 11 Apr 2023
 17:22:08 +0000
Message-ID: <38f748a8-be3b-6b64-665c-676805ce3555@talpey.com>
Date:   Tue, 11 Apr 2023 13:22:05 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v6 12/18] siw: Inline do_tcp_sendpages()
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org
References: <20230411160902.4134381-1-dhowells@redhat.com>
 <20230411160902.4134381-13-dhowells@redhat.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20230411160902.4134381-13-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:208:23b::8) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|CO1PR01MB7306:EE_
X-MS-Office365-Filtering-Correlation-Id: 239b5b62-c6ee-457c-7d7a-08db3ab14729
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MwEBK9k2bC7N8PdsfrdyNDFcwE6EzjcxIGuPJtHQbO9TmWV9vMxL+3I+NJLhHmPQfWkyC7pdNzjMgysqhnBmsnqtK3JhenLs7J1QdQ+OBdmAVEE7ahL0EDlx7X2nCUlDP5QPVA1x/6u7257Nh6tdj3R/G8q9FaXnzeRiY/ZOQ9TNB2FhukEI7jSnFUKzLIT4q//XmGHj3r3zq/OB5UP/leQOC2raGu1qPjhUlxNFufYFr5BdyEUuaZ2QdQCqvAsxzhkh7yXUunRdn2Kr5gbA9XT3Q1UfV8ZfINt8iMoiMbd7uW5aPlPr847i5+jL4Y86q+Msy2afJyOl7SfTJ9LIZ2WA2RE1j9Dw/NQoUgElsntu9AW4d6ekKvOtkGtF4jITzftDXpbgx66xDtuLQxYzvbcBqg6tET8JSel+JsNT+r2TMlULcpxrP/Pei0EFH6gvBaHCREjHfXjSsUQk1Gxcj1C9t7tkgcJvyewgzWoCgsApifUGNIJwhnrVLYmfLKQWPkSWc2f1llibAVtJbsNfsX3g33XyAaDtpvTZ4jJsMaHvxkOuSpN+mCLhg0A/oYaB8hPF0QmWCuO84QF+ZpTqAg+TOL2FEUTj3o8AEbnLZtGFewyDz725nOlDvSwE2Z3Oi/zap43qOzgydy6R2ar6ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39830400003)(346002)(376002)(396003)(451199021)(6486002)(52116002)(2616005)(26005)(6506007)(6512007)(53546011)(38350700002)(36756003)(316002)(41300700001)(2906002)(83380400001)(38100700002)(86362001)(31686004)(186003)(6666004)(31696002)(478600001)(66946007)(4326008)(66476007)(66556008)(8936002)(8676002)(54906003)(7416002)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2ZyMGl0NGVLU0FDdmVVbW5vTkRYR2w2WEN2T0ZhSGxZaGRQd0pSUlBOUytm?=
 =?utf-8?B?VUZha3Z6OGxCYVpoOHRTaGFhVWdYU2J5c3JqTVlKTXZnenJ6R2srNk9POGFU?=
 =?utf-8?B?YkZtQ1lsdGlHeHo4eUJwemsxdDdrUkk5cmNkamsvQmxSc1NQY1llTHVaMWZK?=
 =?utf-8?B?MzNwdk41SzZBUzFpbW84UkV4TzJwdmNBSzJ0VmFBMGovV2hNZ29qVDdxS3Zv?=
 =?utf-8?B?VkVxUStubktHY3o4eXdUdEtSQ2N2NVZhMWxvSDhzczRuTGwySndQTy8vYmJy?=
 =?utf-8?B?L1I5ZXVxMWdWNUQ2MmxoUU13U2IwSnVNTUpRZlJBc0JHeG1RZFFteGx4TzR0?=
 =?utf-8?B?Tm5Ub01ZWC9YVnFDOGdSUnRKTDlXd0YrSW1leWdPam1CcWVlaElwbTNCam81?=
 =?utf-8?B?enROS1pvcVFnMnJ3T3hlaW5ub0sycTBtQUhTK3VXMGwxY0Jnemx0VW9NN1R1?=
 =?utf-8?B?NDZlZkJId215NmJVQmJEM3BJbGhoZ3lZK3hIUEtwK3FSVVp0NDBVU0tXamdM?=
 =?utf-8?B?cG9wSHprcmFseHkzSGdYZk1YTm1CV2Y4YlpXS3YvR29tRTNkUUZUVU5MUEYr?=
 =?utf-8?B?b1NPd0FlQmhMZG5CcjJJTkg3ekVRelV4dEtmYXh5bkVXakZNUE9OZXFmYmdv?=
 =?utf-8?B?R3hWTXZGTERWNWxBTGJmMWJKUWdyUTdxV0dDa2dTZUFIdWxqRmwxWDZEdVNq?=
 =?utf-8?B?cUtRY3RFbkM3Y3dCa003M3ZvVVZFa0F4TVd1bnVYdGhSbERYNW4xcHFvVlYz?=
 =?utf-8?B?MFRxa2hsTHg2UU5IZHJxWEFmblhyT1dRR3JOOENVSzNtWDhhdWVML3cwb2Zt?=
 =?utf-8?B?L01Rbno0QkdEaWtTeFlSSytZYy96N05XSmVhVHN5S2dNaXNBVnMwSDB0NlNz?=
 =?utf-8?B?bTNrK0k0MXZWTytFaUllaXgyZ1YxVmxQT0lOb0dVSlMxMWM3bjFwT3ZyLyta?=
 =?utf-8?B?SEtxODh2dFRmd0JGZXVjYnJkR21sb3ZzYkVpZUpGbllYU0Fwak5MR01XSVVz?=
 =?utf-8?B?Q0hQcGxrT0pvNXArRkJ6RWdUK1FPSXI5V3ZTTUtRR1hUbUZnNFRYaTArdGhR?=
 =?utf-8?B?T1BYVWsyM1NuMlYrQkpmdlREMHZnS0JFSHhvK0VRd1ppMUYxOTdpbUxGQ2Rk?=
 =?utf-8?B?bEl3Vjh1M2l4cGQxeUx3YzFzblRyRFo0d01hY3lmR0dRTkhXYnFtcjA0cHlV?=
 =?utf-8?B?KzQ5Nm1PSkthdmlySHQycG51TUdIZHVIRWpZdi9lMVErVGJPa2lnY2lKaXZm?=
 =?utf-8?B?NGZLbWdzalNLcFNtNE91RG0rRWxWZjgzVVpHVlBnaElQYkl2YTMrTUZoVzFB?=
 =?utf-8?B?QWU3QnZ4UWp5eGVYeEdQbitJa1RPNGRSZ1RmNFFockVVbGE0TitobG1odDJa?=
 =?utf-8?B?azRCSk9YQkIvcjZrRDlWVVVDWGlnUlBUK1hkT0I0QVc1ZnBTS01RZUVFbWUx?=
 =?utf-8?B?SkY5aHc3VVRkU0N4dlFLMkRCdndPeDBQZlEyUUEvVzZtbFp2Q3hUOWNOOVd5?=
 =?utf-8?B?NzlCT2d2N3R6S1JKaWVIeXBLY1Fjc0Jnc3YwWE5qRXZTVFBTdmpmYmNhTGxn?=
 =?utf-8?B?S3RRUXRoamh1Q1oyVlJESVY4c1FjVkxWWXJjZy9CVjB6aGlQUEIvMGVsazVr?=
 =?utf-8?B?ZXprdjlXeXZjS2tVbFlHeDd0cVBpLzNBd0wrUnd2RVJCclZkNFY2ZnN0WXJK?=
 =?utf-8?B?UWRORnJWUzRTcEg2cUhxQmtGRitIU0dCd2dmZ3F3QXU5YUowU09xQXYrbGFF?=
 =?utf-8?B?ekh4NDNOaG1yb0Q2V1J4RnI2N3FqZEhNUEk4UW43VU5wNG4wMUJUUklsNnJy?=
 =?utf-8?B?K0EwMnYwNCs2bGs2NzcxSlVxYUUrY2lROG0ydzlYeElXZ2lKS1hwVFNHQTYw?=
 =?utf-8?B?dFNjYzY1OHlVY3JxSEs5dlNJTEpOQnhvczlPY2JIcG9DaGdSUXN6d2tOc3pz?=
 =?utf-8?B?YkJrdk9nN0hhNXJuUU44aTlZeEF5TDhOSWJ6SjJvc1AxYnowVFdxMm90d0Jz?=
 =?utf-8?B?S0FxYXFwM05nekpDOG1LdTlGcDlRS1JiQkEyOHRNNHdrMzFjL1AraUwraWp6?=
 =?utf-8?B?bWw1QnZNcHpwOHczTTJuY3lNaEhoaTIyMkdjdS9vU21jRmd5ZE0wdmpxUHNp?=
 =?utf-8?Q?EdlKOGh4+1onYYo9nrpkyAx5P?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 239b5b62-c6ee-457c-7d7a-08db3ab14729
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 17:22:08.2490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWRqnkG5RyQpVwd8SP19GsKEXb6MZoWp0WZqAq6138pphc7piezAi5m9Eq0n45OO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB7306
X-Spam-Status: No, score=-2.2 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/2023 12:08 PM, David Howells wrote:
> do_tcp_sendpages() is now just a small wrapper around tcp_sendmsg_locked(),
> so inline it, allowing do_tcp_sendpages() to be removed.  This is part of
> replacing ->sendpage() with a call to sendmsg() with MSG_SPLICE_PAGES set.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
> cc: Jason Gunthorpe <jgg@ziepe.ca>
> cc: Leon Romanovsky <leon@kernel.org>
> cc: Tom Talpey <tom@talpey.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: linux-rdma@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
> 
> Notes:
>      ver #6)
>       - Don't clear MSG_SPLICE_PAGES on the last page.

v6 looks good, thanks.

Reviewed-by: Tom Talpey <tom@talpey.com>


> 
>   drivers/infiniband/sw/siw/siw_qp_tx.c | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
> index 05052b49107f..5552e60bb927 100644
> --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
> +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
> @@ -313,7 +313,7 @@ static int siw_tx_ctrl(struct siw_iwarp_tx *c_tx, struct socket *s,
>   }
>   
>   /*
> - * 0copy TCP transmit interface: Use do_tcp_sendpages.
> + * 0copy TCP transmit interface: Use MSG_SPLICE_PAGES.
>    *
>    * Using sendpage to push page by page appears to be less efficient
>    * than using sendmsg, even if data are copied.
> @@ -324,20 +324,27 @@ static int siw_tx_ctrl(struct siw_iwarp_tx *c_tx, struct socket *s,
>   static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
>   			     size_t size)
>   {
> +	struct bio_vec bvec;
> +	struct msghdr msg = {
> +		.msg_flags = (MSG_MORE | MSG_DONTWAIT | MSG_SENDPAGE_NOTLAST |
> +			      MSG_SPLICE_PAGES),
> +	};
>   	struct sock *sk = s->sk;
> -	int i = 0, rv = 0, sent = 0,
> -	    flags = MSG_MORE | MSG_DONTWAIT | MSG_SENDPAGE_NOTLAST;
> +	int i = 0, rv = 0, sent = 0;
>   
>   	while (size) {
>   		size_t bytes = min_t(size_t, PAGE_SIZE - offset, size);
>   
>   		if (size + offset <= PAGE_SIZE)
> -			flags = MSG_MORE | MSG_DONTWAIT;
> +			msg.msg_flags &= ~MSG_SENDPAGE_NOTLAST;
>   
>   		tcp_rate_check_app_limited(sk);
> +		bvec_set_page(&bvec, page[i], bytes, offset);
> +		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
> +
>   try_page_again:
>   		lock_sock(sk);
> -		rv = do_tcp_sendpages(sk, page[i], offset, bytes, flags);
> +		rv = tcp_sendmsg_locked(sk, &msg, size);
>   		release_sock(sk);
>   
>   		if (rv > 0) {
> 
> 
