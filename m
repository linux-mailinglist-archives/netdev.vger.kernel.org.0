Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45DBE595E9
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfF1ITA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jun 2019 04:19:00 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33487 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfF1ITA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 04:19:00 -0400
Received: by mail-ed1-f65.google.com with SMTP id i11so9912027edq.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 01:18:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=U/u5RYq5eCPirSbgbY9HORy03rZZ7Zk/HbJlb1Wg1Q0=;
        b=SF1MN3iONAufSlj5acu0EYej9IEfqom5XXswa5dXQSBdblw13HVM7kce4qEOy0Xjna
         4m6S9s/Grnk1euhiELXwmmQug063OTNJHZUtXuLBxEPdXA5wfZq9DcCHMVO12EwxaXyn
         QccWnpN6xPCaHiLiHurqv62g9lisCyzY7CUnZKBssFOTjbP4bIuioBboIWUkxRDTsvbl
         QXd0CimHb2zesSy+Tz2aSlQMVFfjMPEj3gYQ8gYEmMlaHZqNUTuFkgrgG7jt/27fQpXQ
         I8op/6jOOAu7rty+DZuSsdR3GQXx/vrFD1O+u7ndO1bw+wVVYYMyKlYkvk8wPY/Eva9S
         /9bA==
X-Gm-Message-State: APjAAAV2yvN1Fxki7SgklC4ylRsPEA5uO4Zw4tt5d+hYD2H6rvoLzib1
        WkKj0l6xCBwMb0Cb+CjoXL6haQ==
X-Google-Smtp-Source: APXvYqwlOGiSwiGWCEs8uU3RmkeqQpWJ2nutWQiGqLFnEUXsHozoUaeIWXQ4OfOFy14jXqpoQYlOqA==
X-Received: by 2002:aa7:ca54:: with SMTP id j20mr9748402edt.50.1561709938908;
        Fri, 28 Jun 2019 01:18:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id p3sm478714eda.43.2019.06.28.01.18.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 01:18:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7CE24181CA7; Fri, 28 Jun 2019 10:18:57 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v5 2/3] bpf_xdp_redirect_map: Perform map lookup in eBPF helper
In-Reply-To: <d3f76a90-5cf4-4437-e3e1-75fda1248e53@iogearbox.net>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1> <156125626136.5209.14349225282974871197.stgit@alrua-x1> <04a5da1d-6d0e-5963-4622-20cb54285926@iogearbox.net> <874l4a9o2b.fsf@toke.dk> <d3f76a90-5cf4-4437-e3e1-75fda1248e53@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 Jun 2019 10:18:57 +0200
Message-ID: <87pnmy86mm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 06/28/2019 09:17 AM, Toke Høiland-Jørgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>> 
>>> On 06/23/2019 04:17 AM, Toke Høiland-Jørgensen wrote:
>>>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>
>>>> The bpf_redirect_map() helper used by XDP programs doesn't return any
>>>> indication of whether it can successfully redirect to the map index it was
>>>> given. Instead, BPF programs have to track this themselves, leading to
>>>> programs using duplicate maps to track which entries are populated in the
>>>> devmap.
>>>>
>>>> This patch fixes this by moving the map lookup into the bpf_redirect_map()
>>>> helper, which makes it possible to return failure to the eBPF program. The
>>>> lower bits of the flags argument is used as the return code, which means
>>>> that existing users who pass a '0' flag argument will get XDP_ABORTED.
>>>>
>>>> With this, a BPF program can check the return code from the helper call and
>>>> react by, for instance, substituting a different redirect. This works for
>>>> any type of map used for redirect.
>>>>
>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>
>>> Overall series looks good to me. Just very small things inline here & in the
>>> other two patches:
>>>
>>> [...]
>>>> @@ -3750,9 +3742,16 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>>>>  {
>>>>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>>>>  
>>>> -	if (unlikely(flags))
>>>> +	/* Lower bits of the flags are used as return code on lookup failure */
>>>> +	if (unlikely(flags > XDP_TX))
>>>>  		return XDP_ABORTED;
>>>>  
>>>> +	ri->item = __xdp_map_lookup_elem(map, ifindex);
>>>> +	if (unlikely(!ri->item)) {
>>>> +		WRITE_ONCE(ri->map, NULL);
>>>
>>> This WRITE_ONCE() is not needed. We never set it before at this point.
>> 
>> You mean the WRITE_ONCE() wrapper is not needed, or the set-to-NULL is
>> not needed? The reason I added it is in case an eBPF program calls the
>> helper twice before returning, where the first lookup succeeds but the
>> second fails; in that case we want to clear the ->map pointer, no?
>
> Yeah I meant the set-to-NULL. So if first call succeeds, and the second one
> fails, then the expected semantics wrt the first call are as if the program
> would have called bpf_xdp_redirect() only?
>
> Looking at the code again, if we set ri->item to NULL, then we /must/
> also set ri->map to NULL. I guess there are two options: i) leave as
> is, ii) keep the __xdp_map_lookup_elem() result in a temp var, if it's
> NULL return flags, otherwise only /then/ update ri->item, so that
> semantics are similar to the invalid flags check earlier. I guess fine
> either way, in case of i) there should probably be a comment since
> it's less obvious.

Yeah, I think a temp var is probably clearer, will do that :)

-Toke
