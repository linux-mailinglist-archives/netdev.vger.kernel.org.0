Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAB83711D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 12:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfFFKBK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jun 2019 06:01:10 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45989 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727948AbfFFKBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 06:01:10 -0400
Received: by mail-ed1-f68.google.com with SMTP id f20so2434153edt.12
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 03:01:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Lu5o7unG8OuOdKW8qyYJJHMQHmPgMxzq8A1CmTaMqHI=;
        b=B6kXplvV7dUHb/K8hGfbS5LBivxKfCAUcBZDG9VYslmCcKOLecGNX4ROX9uY4auEFs
         sxvr9qJ9hnVJrRZnqoB5KCpgSh0OveT6jm9qgYwYzYTocG5KL5oSFe4oKWKgJiP+oMo7
         OTl/Ti+q1MJtjwEhBnShposAEn232RwNMw2TT4nqAJ6yGW9bmxyM362RTOIN/dt3ZKw9
         QI+IACBMSivPczZcnyNTFYJkPWOfa9ldvEd7kiqLmUBd6jQ5pS59W2enLrGZEq6r1BhB
         zZAVPg7yQQ+MHPVovLNELCcbQg6dKZ0f1eqUWBr/K46RlFjCkRPIWIdY2t81emUi0/zw
         ODOw==
X-Gm-Message-State: APjAAAWvUQLBjWepVWQCpQ7ZPu4s5qCd/a6HB7EXfwYXRiikXApBn8pJ
        UuDvFhr2j8OhSFNQR2KeG6jvTw==
X-Google-Smtp-Source: APXvYqx0jQYRiogyGxTU5ySCL+4iT2vyx65gYRiGYO07dxedg73jrNw7bqDIwOYBGzNLsjV8HgTvqg==
X-Received: by 2002:a17:906:3444:: with SMTP id d4mr19001659ejb.111.1559815268534;
        Thu, 06 Jun 2019 03:01:08 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id u13sm335879edb.45.2019.06.06.03.01.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 03:01:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2E330181CC1; Thu,  6 Jun 2019 12:01:07 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, brouer@redhat.com,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next 1/2] bpf_xdp_redirect_map: Add flag to return XDP_PASS on map lookup failure
In-Reply-To: <20190605123941.5b1d36ab@carbon>
References: <155966185058.9084.14076895203527880808.stgit@alrua-x1> <155966185069.9084.1926498690478259792.stgit@alrua-x1> <20190605123941.5b1d36ab@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 06 Jun 2019 12:01:07 +0200
Message-ID: <87o93bdod8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Tue, 04 Jun 2019 17:24:10 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
>> The bpf_redirect_map() helper used by XDP programs doesn't return any
>> indication of whether it can successfully redirect to the map index it was
>> given. Instead, BPF programs have to track this themselves, leading to
>> programs using duplicate maps to track which entries are populated in the
>> devmap.
>> 
>> This adds a flag to the XDP version of the bpf_redirect_map() helper, which
>> makes the helper do a lookup in the map when called, and return XDP_PASS if
>> there is no value at the provided index. This enables two use cases:
>
> To Jonathan Lemon, notice this approach of adding a flag to the helper
> call, it actually also works for your use-case of XSK AF_XDP maps.
>
>> - A BPF program can check the return code from the helper call and react if
>>   it is XDP_PASS (by, for instance, redirecting out a different interface).
>> 
>> - Programs that just return the value of the bpf_redirect() call will
>>   automatically fall back to the regular networking stack, simplifying
>>   programs that (for instance) build a router with the fib_lookup() helper.
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>  include/uapi/linux/bpf.h |    8 ++++++++
>>  net/core/filter.c        |   10 +++++++++-
>>  2 files changed, 17 insertions(+), 1 deletion(-)
>> 
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 7c6aef253173..4c41482b7604 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3098,6 +3098,14 @@ enum xdp_action {
>>  	XDP_REDIRECT,
>>  };
>>  
>> +/* Flags for bpf_xdp_redirect_map helper */
>> +
>> +/* If set, the help will check if the entry exists in the map and return
>> + * XDP_PASS if it doesn't.
>> + */
>> +#define XDP_REDIRECT_PASS_ON_INVALID BIT(0)
>> +#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_PASS_ON_INVALID
>> +
>>  /* user accessible metadata for XDP packet hook
>>   * new fields must be added to the end of this structure
>>   */
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 55bfc941d17a..dfab8478f66c 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3755,9 +3755,17 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>>  {
>>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>>  
>> -	if (unlikely(flags))
>> +	if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
>>  		return XDP_ABORTED;
>>  
>> +	if (flags & XDP_REDIRECT_PASS_ON_INVALID) {
>> +		struct net_device *fwd;
>
> It is slightly misguiding that '*fwd' is a 'struct net_device', as the
> __xdp_map_lookup_elem() call works for all the supported redirect-map
> types.
>
> People should realize that this patch is a general approach for all the
> redirect-map types.

Good point, will fix! :)

-Toke
