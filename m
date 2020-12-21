Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB802E01BF
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 21:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgLUU6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 15:58:11 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:38879 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUU6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 15:58:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608584291; x=1640120291;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=MvKgvDWEx8S+EZ4PvITB5lCpyAxK4aFYMOth3rKRNEw=;
  b=BBJfLy+vGSB6tPfhWvLkRabkTYX7QL9beDHr4HoBeesXi7N9+lZg1pie
   RLxGyT2ny+sTOa4vBX1sTqm0rj/BKFGolZ2YHM7vQlNEL6fwGt2ckeu+Y
   5JxCmWuizkSYG/TRIDaGXvFVDrWHBklD2bC/kAErkg74FRhn1D18JzxZ4
   0=;
X-IronPort-AV: E=Sophos;i="5.78,437,1599523200"; 
   d="scan'208";a="105097293"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-e69428c4.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 Dec 2020 20:57:22 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-e69428c4.us-east-1.amazon.com (Postfix) with ESMTPS id 76407C227A;
        Mon, 21 Dec 2020 20:57:17 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.161.68) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Dec 2020 20:57:10 +0000
References: <cover.1607349924.git.lorenzo@kernel.org>
 <21d27f233e37b66c9ad4073dd09df5c2904112a4.1607349924.git.lorenzo@kernel.org>
 <5465830698257f18ae474877648f4a9fe2e1eefe.camel@kernel.org>
 <20201208110125.GC36228@lore-desk>
 <pj41zlk0tdq22i.fsf@u68c7b5b1d2d758.ant.amazon.com>
 <CAJ0CqmWUJzrpOpQ01sr+e5hr1K1U4tsqEiF=FdLL--wLYpu3DA@mail.gmail.com>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "Network Development" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "Jesper Brouer" <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        "Jason Wang" <jasowang@redhat.com>
Subject: Re: [PATCH v5 bpf-next 03/14] xdp: add xdp_shared_info data structure
In-Reply-To: <CAJ0CqmWUJzrpOpQ01sr+e5hr1K1U4tsqEiF=FdLL--wLYpu3DA@mail.gmail.com>
Date:   Mon, 21 Dec 2020 22:55:42 +0200
Message-ID: <pj41zlmty6lvzl.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.68]
X-ClientProxiedBy: EX13D13UWA004.ant.amazon.com (10.43.160.251) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>>
>>
>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>>
>> >> On Mon, 2020-12-07 at 17:32 +0100, Lorenzo Bianconi wrote:
>> >> > Introduce xdp_shared_info data structure to contain info
>> >> > about
>> >> > "non-linear" xdp frame. xdp_shared_info will alias
>> >> > skb_shared_info
>> >> > allowing to keep most of the frags in the same cache-line.
>> [...]
>> >>
>> >> > +  u16 nr_frags;
>> >> > +  u16 data_length; /* paged area length */
>> >> > +  skb_frag_t frags[MAX_SKB_FRAGS];
>> >>
>> >> why MAX_SKB_FRAGS ? just use a flexible array member
>> >> skb_frag_t frags[];
>> >>
>> >> and enforce size via the n_frags and on the construction of 
>> >> the
>> >> tailroom preserved buffer, which is already being done.
>> >>
>> >> this is waste of unnecessary space, at lease by definition 
>> >> of
>> >> the
>> >> struct, in your use case you do:
>> >> memcpy(frag_list, xdp_sinfo->frags, sizeof(skb_frag_t) *
>> >> num_frags);
>> >> And the tailroom space was already preserved for a full
>> >> skb_shinfo.
>> >> so i don't see why you need this array to be of a fixed
>> >> MAX_SKB_FRAGS
>> >> size.
>> >
>> > In order to avoid cache-misses, xdp_shared info is built as a
>> > variable
>> > on mvneta_rx_swbm() stack and it is written to "shared_info"
>> > area only on the
>> > last fragment in mvneta_swbm_add_rx_fragment(). I used
>> > MAX_SKB_FRAGS to be
>> > aligned with skb_shared_info struct but probably we can use 
>> > even
>> > a smaller value.
>> > Another approach would be to define two different struct, 
>> > e.g.
>> >
>> > stuct xdp_frag_metadata {
>> >       u16 nr_frags;
>> >       u16 data_length; /* paged area length */
>> > };
>> >
>> > struct xdp_frags {
>> >       skb_frag_t frags[MAX_SKB_FRAGS];
>> > };
>> >
>> > and then define xdp_shared_info as
>> >
>> > struct xdp_shared_info {
>> >       stuct xdp_frag_metadata meta;
>> >       skb_frag_t frags[];
>> > };
>> >
>> > In this way we can probably optimize the space. What do you
>> > think?
>>
>> We're still reserving ~sizeof(skb_shared_info) bytes at the end 
>> of
>> the first buffer and it seems like in mvneta code you keep
>> updating all three fields (frags, nr_frags and data_length).
>> Can you explain how the space is optimized by splitting the
>> structs please?
>
> using xdp_shared_info struct we will have the first 3 fragments 
> in the
> same cacheline of nr_frags while using skb_shared_info struct 
> only the
> first fragment will be in the same cacheline of 
> nr_frags. Moreover
> skb_shared_info has multiple fields unused by xdp.
>
> Regards,
> Lorenzo
>

Thanks for your reply. I was actually referring to your suggestion 
to Saeed. Namely, defining

struct xdp_shared_info {
       struct xdp_frag_metadata meta;
       skb_frag_t frags[];
}

I don't see what benefits there are to this scheme compared to the 
original patch

Thanks,
Shay

>>
>> >>
>> >> > +};
>> >> > +
[...]
>>
>> Saeed, the stack receives skb_shared_info when the frames are
>> passed to the stack (skb_add_rx_frag is used to add the whole
>> information to skb's shared info), and for XDP_REDIRECT use 
>> case,
>> it doesn't seem like all drivers check page's tailroom for more
>> information anyway (ena doesn't at least).
>> Can you please explain what do you mean by "break the stack"?
>>
>> Thanks, Shay
>>
>> >>
>> [...]
>> >
>> >>
>>

