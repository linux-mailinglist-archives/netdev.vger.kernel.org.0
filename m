Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FE451543B
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 21:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380222AbiD2TOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 15:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380224AbiD2TOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 15:14:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3BCD64C7
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 12:11:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9DCCB837BA
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 19:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07846C385A7;
        Fri, 29 Apr 2022 19:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651259479;
        bh=wrutMQpBUdGZWa1r0zxo5BWWgXiLwlwJeTMsSbSkltg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=POWCFUpgIDEvskeTBVdmXTt5e/MuXdyOKBDguXua5vDvMWrUq2k4a2gklR12wiCv1
         tJuScutnTnCt0UnbAUABKGWoIDKDhPDbHv/CiegC7AvkKPapb0UmeGlM19iBaZ34sY
         tEsKhqOXJ0Uo7WchcwLQ2uHTHSsocJ8P1+LrD1tgg9BpYGs7FX1VDGaIUXAkgzBU3x
         Xm2y3meuhgK97dNVVrrDYBYuLOm3InmhMkcb2XqWfT2eUaN5av3qfHzL0hGE31a74E
         l0R7L8cgxUoKQpF9w7GDk3EpTEklcymO4Vq+flEzn23JdoqYlYPYOfpXTpetAQ1KSH
         ctSFnzW3DB9eA==
Date:   Fri, 29 Apr 2022 12:11:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] tls: Add opt-in zerocopy mode of sendfile()
Message-ID: <20220429121117.21bf7490@kernel.org>
In-Reply-To: <d99c36fd-2bd3-acc6-6c37-7eb439b04949@nvidia.com>
References: <20220427175048.225235-1-maximmi@nvidia.com>
        <20220428151142.3f0ccd83@kernel.org>
        <d99c36fd-2bd3-acc6-6c37-7eb439b04949@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 17:21:59 +0300 Maxim Mikityanskiy wrote:
> On 2022-04-29 01:11, Jakub Kicinski wrote:
> >> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> >> index b12f81a2b44c..715401b20c8b 100644
> >> --- a/net/tls/tls_device.c
> >> +++ b/net/tls/tls_device.c
> >> @@ -411,10 +411,16 @@ static int tls_device_copy_data(void *addr, size_t bytes, struct iov_iter *i)
> >>   	return 0;
> >>   }
> >>   
> >> +union tls_iter_offset {
> >> +	struct iov_iter *msg_iter;
> >> +	int offset;
> >> +};  
> > 
> > Is this sort of atrocity used elsewhere in the kernel?
> > If you can't refactor the code you can pack args into
> > a structure  
> 
> What's the point of packing arguments into a struct in this particular 
> case? Depending on zc_page, I need either msg_iter or offset, and I'm 
> reusing the same CPU register to pass either of them. The performance 
> isn't affected, and the amount of memory used is the same. A struct 
> won't allow to achieve this, it would force me to drag 8 extra bytes, 
> but we already use all 6 registers used to pass parameters on x86_64.

I know why you're doing this, but you're not writing assembly:

+	rc = tls_push_data(sk, (union tls_iter_offset)&msg_iter, size,

+	return tls_push_data(sk, (union tls_iter_offset)&msg_iter, 0, flags,

even if it's legal C (i.e. not UB) it looks awkward.

> > but I've not seen people cast mutually exclusive
> > arguments to a union type.  
> 
> It's the purpose of a union, to hold one of mutually exclusive values, 
> isn't it?

The union itself is not the problem.

> > Is this "inspired" by some higher
> > level language?  
> 
> It's unfortunately inspired by C and its freedom to allow 
> microoptimizations/hacks. The hack here is that I use a pointer being 
> NULL or not-NULL as an indicator what type the other argument has.
> 
> The closest alternative from high-level languages I can think of is 
> enums with attached data from rust or swift. However, rust isn't smart 
> enough to perform the optimization I described, so no, it's not inspired 
> by it :)
> 
> Options that I see here:
> 
> 1. Union.
> 
> 2. Just pass both parameters and use one of them. Drawbacks: now we have 
> 7 parameters, one will be passed through the stack, and it's datapath code.
> 
> 3. Pass `struct iov_iter *` and cast it to `int offset` when zc_page 
> isn't NULL. As we are compiling with -fno-strict-aliasing, and int 
> shouldn't be bigger than a pointer on all supported architectures, it's 
> going to work, and we still have 6 parameters.
> 
> 4. Combine `int offset` and `int flags` into a single 64-bit parameter.
> 
> Which one do you prefer, or do you have anything better in mind?

If you declare the union on the stack in the callers, and pass by value
- is the compiler not going to be clever enough to still DDRT?

> >>   static int tls_push_data(struct sock *sk,
> >> -			 struct iov_iter *msg_iter,
> >> +			 union tls_iter_offset iter_offset,
> >>   			 size_t size, int flags,
> >> -			 unsigned char record_type)
> >> +			 unsigned char record_type,
> >> +			 struct page *zc_page)
> >>   {
> >>   	struct tls_context *tls_ctx = tls_get_ctx(sk);
> >>   	struct tls_prot_info *prot = &tls_ctx->prot_info;
> >> @@ -480,15 +486,29 @@ static int tls_push_data(struct sock *sk,
> >>   		}
> >>   
> >>   		record = ctx->open_record;
> >> -		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
> >> -		copy = min_t(size_t, copy, (max_open_record_len - record->len));
> >> -
> >> -		if (copy) {
> >> -			rc = tls_device_copy_data(page_address(pfrag->page) +
> >> -						  pfrag->offset, copy, msg_iter);
> >> -			if (rc)
> >> -				goto handle_error;
> >> -			tls_append_frag(record, pfrag, copy);
> >> +
> >> +		if (!zc_page) {
> >> +			copy = min_t(size_t, size, pfrag->size - pfrag->offset);
> >> +			copy = min_t(size_t, copy, max_open_record_len - record->len);  
> > 
> > Nope, refactor this please. 95% sure you don't need 4 indentation
> > levels here. Space left in record can be calculated before the if,
> > then you can do
> > 
> > if (zc_page) {
> > 	..
> > } else if (copy) {
> > 	..
> > }  
> 
> It'll save one indentation level for the zc_page case, but not for the 
> other:
> 
> copy = min_t(size_t, size, max_open_record_len - record->len);
> if (zc_page && copy) {
>      ...
> } else {
>      // I still have to do this in non-zc case:
>      copy = min_t(size_t, copy, pfrag->size - pfrag->offset);

Can pfrag->size - pfrag->offset really be 0 provided
tls_do_allocation() did not return an error?

>      if (copy) {
>          // Same indentation level as in my patch.
>          ...
>      }
> }
> 
> Is it good enough?

> > We should allow setting the option for non-HW. It's an opt-in, the app
> > has opted in, the fact that the kernel will not make use of the liberty
> > to apply the optimization is not important, no?  
> 
> Yes, I agree that if the application opted in, it should work properly 
> regardless of whether the optimization actually did turn on. However, 
> the indication could be useful, for example, for diagnostic purposes, to 
> show the user whether zerocopy mode was enabled, if someone is trying to 
> debug some performance issue. If you insist, though, I can make 
> setsockopt succeed and getsockopt return 1. What do you think?

I'd say "whether the optimization is applicable" rather than "whether
the optimization is turned on". User can check whether the connection
is using SW or HW TLS if they want to make sure it's taken advantage of.

Speaking of which, should we report the state of this knob via socket
diag?
