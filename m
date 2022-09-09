Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4620C5B42F4
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 01:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbiIIXN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 19:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiIIXMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 19:12:51 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE2F10D5;
        Fri,  9 Sep 2022 16:12:38 -0700 (PDT)
Message-ID: <cd8d201b-74f7-4045-ad2f-6d26ed608d1e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662765156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PoPM4vkRbQB1tHhn1Z6nSXXJew8NzEe8rDHAGmUdcmM=;
        b=tL0lKysEt/BLJTNOSttnRXbl7IpxeTcMuvYfdfdgCKATWR7QPdEKNTOprrZgwrShxoC3AQ
        Ip/qfihZ7m7+tohWugzjzBz62ZIt0w6jAb0HBySdKccNIgFnM2i3XV71CHXUtUAJURrLFn
        ZbtLowdytRQFg7eJKDPvFJFyziTSmzA=
Date:   Fri, 9 Sep 2022 16:12:31 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v6 1/3] bpf: Add skb dynptrs
Content-Language: en-US
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        martin.lau@kernel.org, kuba@kernel.org, memxor@gmail.com,
        toke@redhat.com, netdev@vger.kernel.org, kernel-team@fb.com,
        bpf@vger.kernel.org
References: <20220907183129.745846-1-joannelkoong@gmail.com>
 <20220907183129.745846-2-joannelkoong@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20220907183129.745846-2-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/22 11:31 AM, Joanne Koong wrote:
> For bpf prog types that don't support writes on skb data, the dynptr is
> read-only (bpf_dynptr_write() will return an error and bpf_dynptr_data()
> will return NULL; for a read-only data slice, there will be a separate
> API bpf_dynptr_data_rdonly(), which will be added in the near future).
> 
I just caught up on the v4 discussion about loadtime-vs-runtime error on 
write.  From a user perspective, I am not concerned on which error. 
Either way, I will quickly find out the packet header is not changed.

For the dynptr init helper bpf_dynptr_from_skb(), the user does not need 
to know its skb is read-only or not and uses the same helper.  The 
verifier in this case uses its knowledge on the skb context and uses 
bpf_dynptr_from_skb_rdonly_proto or bpf_dynptr_from_skb_rdwr_proto 
accordingly.

Now for the slice helper, the user needs to remember its skb is read 
only (or not) and uses bpf_dynptr_data() vs bpf_dynptr_data_rdonly() 
accordingly.  Yes, if it only needs to read, the user can always stay 
with bpf_dynptr_data_rdonly (which is not the initially supported one 
though).  However, it is still unnecessary burden and surprise to user. 
It is likely it will silently turn everything into bpf_dynptr_read() 
against the user intention. eg:

if (bpf_dynptr_from_skb(skb, 0, &dynptr))
	return 0;
ip6h = bpf_dynptr_data(&dynptr, 0, sizeof(*ip6h));
if (!ip6h) {
	/* Unlikely case, in non-linear section, just bpf_dynptr_read()
	 * Oops...actually bpf_dynptr_data_rdonly() should be used.
	 */
	bpf_dynptr_read(buf, sizeof(*ip6h), &dynptr, 0, 0);
	ip6h = buf;
}


> +	case BPF_DYNPTR_TYPE_SKB:
> +	{
> +		struct sk_buff *skb = ptr->data;
> +
> +		/* if the data is paged, the caller needs to pull it first */
> +		if (ptr->offset + offset + len > skb->len - skb->data_len)

nit. skb_headlen(skb)

The patches can't be applied cleanly also. Please remember to rebase. 
eg. commit afef88e65554 ("selftests/bpf: Store BPF object files with 
.bpf.o extension") has landed on Sep 2.


