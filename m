Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE15A2DF01A
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 16:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgLSO7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 09:59:37 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:9610 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgLSO7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 09:59:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608389976; x=1639925976;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=tvjbOZ8zpKBoBtL3XeqPW67PPKjbir27mkK3gEAWW7Q=;
  b=iBTFaSv2yMJf4M1g5SGzPQNJKnxMB5jifYkh4E+IlI7ALZvrG7kxUz3r
   cIbvGA0VvHdsB+pKkP5Ne6eJXxt4MfNyr2oRq8sNTx70/QmbkytDUDfU9
   qSmBi5UN97zqpmemxXQpLxOcCUxpZam5P1gThwdCSHqzp2etdKrw6r3kl
   I=;
X-IronPort-AV: E=Sophos;i="5.78,433,1599523200"; 
   d="scan'208";a="104462864"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 19 Dec 2020 14:58:49 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id E0481225F69;
        Sat, 19 Dec 2020 14:54:27 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.161.43) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 19 Dec 2020 14:54:20 +0000
References: <cover.1607349924.git.lorenzo@kernel.org>
 <21d27f233e37b66c9ad4073dd09df5c2904112a4.1607349924.git.lorenzo@kernel.org>
 <5465830698257f18ae474877648f4a9fe2e1eefe.camel@kernel.org>
 <20201208110125.GC36228@lore-desk>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <sameehj@amazon.com>,
        <john.fastabend@gmail.com>, <dsahern@kernel.org>,
        <brouer@redhat.com>, <echaudro@redhat.com>, <jasowang@redhat.com>
Subject: Re: [PATCH v5 bpf-next 03/14] xdp: add xdp_shared_info data structure
In-Reply-To: <20201208110125.GC36228@lore-desk>
Date:   Sat, 19 Dec 2020 16:53:57 +0200
Message-ID: <pj41zlk0tdq22i.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.43]
X-ClientProxiedBy: EX13D22UWB004.ant.amazon.com (10.43.161.165) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> On Mon, 2020-12-07 at 17:32 +0100, Lorenzo Bianconi wrote:
>> > Introduce xdp_shared_info data structure to contain info 
>> > about
>> > "non-linear" xdp frame. xdp_shared_info will alias 
>> > skb_shared_info
>> > allowing to keep most of the frags in the same cache-line.
[...]
>> 
>> > +	u16 nr_frags;
>> > +	u16 data_length; /* paged area length */
>> > +	skb_frag_t frags[MAX_SKB_FRAGS];
>> 
>> why MAX_SKB_FRAGS ? just use a flexible array member 
>> skb_frag_t frags[]; 
>> 
>> and enforce size via the n_frags and on the construction of the
>> tailroom preserved buffer, which is already being done.
>> 
>> this is waste of unnecessary space, at lease by definition of 
>> the
>> struct, in your use case you do:
>> memcpy(frag_list, xdp_sinfo->frags, sizeof(skb_frag_t) * 
>> num_frags);
>> And the tailroom space was already preserved for a full 
>> skb_shinfo.
>> so i don't see why you need this array to be of a fixed 
>> MAX_SKB_FRAGS
>> size.
>
> In order to avoid cache-misses, xdp_shared info is built as a 
> variable
> on mvneta_rx_swbm() stack and it is written to "shared_info" 
> area only on the
> last fragment in mvneta_swbm_add_rx_fragment(). I used 
> MAX_SKB_FRAGS to be
> aligned with skb_shared_info struct but probably we can use even 
> a smaller value.
> Another approach would be to define two different struct, e.g.
>
> stuct xdp_frag_metadata {
> 	u16 nr_frags;
> 	u16 data_length; /* paged area length */
> };
>
> struct xdp_frags {
> 	skb_frag_t frags[MAX_SKB_FRAGS];
> };
>
> and then define xdp_shared_info as
>
> struct xdp_shared_info {
> 	stuct xdp_frag_metadata meta;
> 	skb_frag_t frags[];
> };
>
> In this way we can probably optimize the space. What do you 
> think?

We're still reserving ~sizeof(skb_shared_info) bytes at the end of 
the first buffer and it seems like in mvneta code you keep 
updating all three fields (frags, nr_frags and data_length).
Can you explain how the space is optimized by splitting the 
structs please?

>> 
>> > +};
>> > +
>> > +static inline struct xdp_shared_info *
>> >  xdp_get_shared_info_from_buff(struct xdp_buff *xdp)
>> >  {
>> > -	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
>> > +	BUILD_BUG_ON(sizeof(struct xdp_shared_info) >
>> > +		     sizeof(struct skb_shared_info));
>> > +	return (struct xdp_shared_info *)xdp_data_hard_end(xdp);
>> > +}
>> > +
>> 
>> Back to my first comment, do we have plans to use this tail 
>> room buffer
>> for other than frag_list use cases ? what will be the buffer 
>> format
>> then ? should we push all new fields to the end of the 
>> xdp_shared_info
>> struct ? or deal with this tailroom buffer as a stack ? 
>> my main concern is that for drivers that don't support frag 
>> list and
>> still want to utilize the tailroom buffer for other usecases 
>> they will
>> have to skip the first sizeof(xdp_shared_info) so they won't 
>> break the
>> stack.
>
> for the moment I do not know if this area is used for other 
> purposes.
> Do you think there are other use-cases for it?
>

Saeed, the stack receives skb_shared_info when the frames are 
passed to the stack (skb_add_rx_frag is used to add the whole 
information to skb's shared info), and for XDP_REDIRECT use case, 
it doesn't seem like all drivers check page's tailroom for more 
information anyway (ena doesn't at least).
Can you please explain what do you mean by "break the stack"?

Thanks, Shay

>> 
[...]
>
>> 

