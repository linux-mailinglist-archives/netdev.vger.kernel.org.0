Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56A05969D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfF1I5Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jun 2019 04:57:16 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42503 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfF1I5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 04:57:16 -0400
Received: by mail-ed1-f65.google.com with SMTP id z25so9970809edq.9
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 01:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=BfhANZFC/pdpdewgrXRERfqh4Hf74DJq5+zYZ3tzAgw=;
        b=qRpWX1p1bxRvOYAXANyaqqjPKbX6AKfPw4Sr8oDx+apFpImJyNeMx6ibc5aPQj1m5f
         2lkxXbnNYJtPUJniNY2hoCHp+k5RXqGPwH1+9iFtH+HSqVPmKFMtHVnOW0uEp9tk+Eos
         BLINFZWVf2KbTns9F73loBPwc7RBMpq5KmowfHnA7r8lCWzO99LeyIlxOuPdUV+TXK7C
         ZiEQlVvEjsLiDBgoWA+iv+yJLrJNic2MR0Mg8G1d1lsAm5D4lyiIh5nA9LGVzkxjHwVd
         ZM4wNh5JsNVvLienMweR/axOV6oJMV9g6TPenuGvM7eHICFK3ud15cKjyW8s6DYjT+dm
         HIzw==
X-Gm-Message-State: APjAAAWgGxHEtiHvuyspuD9VLmiGf1Mz2nOZthxfi+S8AX7XcU9VCWmQ
        HFoFi1Yiss+h3+H/01cocON/Pg==
X-Google-Smtp-Source: APXvYqxDmsiGLRZIDd27Edo4rWvEoCNHXp2OctY9f57YrPAnkvhisn+72oxipforcZAxGHphYWsokQ==
X-Received: by 2002:a50:9929:: with SMTP id k38mr9703747edb.4.1561712234416;
        Fri, 28 Jun 2019 01:57:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id w17sm477261edi.15.2019.06.28.01.57.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 01:57:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 44689181CA7; Fri, 28 Jun 2019 10:57:13 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v5 2/3] bpf_xdp_redirect_map: Perform map lookup in eBPF helper
In-Reply-To: <87pnmy86mm.fsf@toke.dk>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1> <156125626136.5209.14349225282974871197.stgit@alrua-x1> <04a5da1d-6d0e-5963-4622-20cb54285926@iogearbox.net> <874l4a9o2b.fsf@toke.dk> <d3f76a90-5cf4-4437-e3e1-75fda1248e53@iogearbox.net> <87pnmy86mm.fsf@toke.dk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 Jun 2019 10:57:13 +0200
Message-ID: <87mui284uu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> writes:

> Daniel Borkmann <daniel@iogearbox.net> writes:
>
>> On 06/28/2019 09:17 AM, Toke Høiland-Jørgensen wrote:
>>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>> 
>>>> On 06/23/2019 04:17 AM, Toke Høiland-Jørgensen wrote:
>>>>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>
>>>>> The bpf_redirect_map() helper used by XDP programs doesn't return any
>>>>> indication of whether it can successfully redirect to the map index it was
>>>>> given. Instead, BPF programs have to track this themselves, leading to
>>>>> programs using duplicate maps to track which entries are populated in the
>>>>> devmap.
>>>>>
>>>>> This patch fixes this by moving the map lookup into the bpf_redirect_map()
>>>>> helper, which makes it possible to return failure to the eBPF program. The
>>>>> lower bits of the flags argument is used as the return code, which means
>>>>> that existing users who pass a '0' flag argument will get XDP_ABORTED.
>>>>>
>>>>> With this, a BPF program can check the return code from the helper call and
>>>>> react by, for instance, substituting a different redirect. This works for
>>>>> any type of map used for redirect.
>>>>>
>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>
>>>> Overall series looks good to me. Just very small things inline here & in the
>>>> other two patches:
>>>>
>>>> [...]
>>>>> @@ -3750,9 +3742,16 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>>>>>  {
>>>>>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>>>>>  
>>>>> -	if (unlikely(flags))
>>>>> +	/* Lower bits of the flags are used as return code on lookup failure */
>>>>> +	if (unlikely(flags > XDP_TX))
>>>>>  		return XDP_ABORTED;
>>>>>  
>>>>> +	ri->item = __xdp_map_lookup_elem(map, ifindex);
>>>>> +	if (unlikely(!ri->item)) {
>>>>> +		WRITE_ONCE(ri->map, NULL);
>>>>
>>>> This WRITE_ONCE() is not needed. We never set it before at this point.
>>> 
>>> You mean the WRITE_ONCE() wrapper is not needed, or the set-to-NULL is
>>> not needed? The reason I added it is in case an eBPF program calls the
>>> helper twice before returning, where the first lookup succeeds but the
>>> second fails; in that case we want to clear the ->map pointer, no?
>>
>> Yeah I meant the set-to-NULL. So if first call succeeds, and the second one
>> fails, then the expected semantics wrt the first call are as if the program
>> would have called bpf_xdp_redirect() only?
>>
>> Looking at the code again, if we set ri->item to NULL, then we /must/
>> also set ri->map to NULL. I guess there are two options: i) leave as
>> is, ii) keep the __xdp_map_lookup_elem() result in a temp var, if it's
>> NULL return flags, otherwise only /then/ update ri->item, so that
>> semantics are similar to the invalid flags check earlier. I guess fine
>> either way, in case of i) there should probably be a comment since
>> it's less obvious.
>
> Yeah, I think a temp var is probably clearer, will do that :)

Actually, thinking about this some more, I think it's better to
completely clear out the state the second time around. I'll add a
comment to explain.

-Toke
