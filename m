Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A7C14663E
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 12:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgAWK7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:59:49 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35622 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWK7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:59:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id g17so2583923wro.2
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 02:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=FJwE81HpA84lwzOusct7pS7KFJL6gUrNtfHJutZ9uzk=;
        b=LmlbEG15fxTH+EZCc4MvonGzBsLLALHaHWY63qyFwRjj1CmatoUXajjC9WE+SS0Oj/
         ZgXmAKPPVNDwxSGHjxesqkmABZZhxlG64rZ2DfDlcgY9cV8fPg+TCz1YbVHutgtyQbHj
         aEkgX7r1ryj1R7Mx6229GJXWiiikvKby6+lfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=FJwE81HpA84lwzOusct7pS7KFJL6gUrNtfHJutZ9uzk=;
        b=gREXYVWDM+8N3JudV4UsXXZ0/KHlXXib4wjmStIK51tpz5B0f6BoY+uBATtOcXMGjH
         QwSV68aXJRSoqmqmILxGdBD0PaSX9LGubP4H0ZYWFGfw5PXhGf+MgADj+WZhmL35w7W5
         jpcQPpHoDUdvbqwCkC/xdercK4cEO9NMQ0XbbugWbek5dxU5/T5O6QJub5DCygiiX493
         EgthpgqEUKqFzrt4IE7IGfrKA2XXM681lrWl2au/J0OjJIf38WBNNHEqze1V5Ecm40PH
         b+Up376LVSDT2FdiA1PW6kOSNk0dDcVqJsacGT8R7gBFBXNnQThLa/qfC8QcBOJwHW8m
         8rmQ==
X-Gm-Message-State: APjAAAVdnWUnhZCBDi0/e5vEN4W7VLOoKSu8MydSfXK4hrXdCAOFQ6G6
        o+bd9ABBGBmntyZRw5N19DOFVQ==
X-Google-Smtp-Source: APXvYqxid25417v8hQ2sSme55LT5quaEd6yJ7JAaEFNKzPFWdKDJTNYVrrOW7hWgUg8CafqZZ+3aeQ==
X-Received: by 2002:adf:9c8f:: with SMTP id d15mr17712629wre.390.1579777187279;
        Thu, 23 Jan 2020 02:59:47 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id z8sm2539183wrq.22.2020.01.23.02.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 02:59:46 -0800 (PST)
References: <20200122130549.832236-1-jakub@cloudflare.com> <20200122130549.832236-11-jakub@cloudflare.com> <20200122225351.hajnt4u7au24mj5g@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 10/12] net: Generate reuseport group ID on group creation
In-reply-to: <20200122225351.hajnt4u7au24mj5g@kafai-mbp.dhcp.thefacebook.com>
Date:   Thu, 23 Jan 2020 11:59:46 +0100
Message-ID: <875zh230bh.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 11:53 PM CET, Martin Lau wrote:
> On Wed, Jan 22, 2020 at 02:05:47PM +0100, Jakub Sitnicki wrote:
>> Commit 736b46027eb4 ("net: Add ID (if needed) to sock_reuseport and expose
>> reuseport_lock") has introduced lazy generation of reuseport group IDs that
>> survive group resize.
>> 
>> By comparing the identifier we check if BPF reuseport program is not trying
>> to select a socket from a BPF map that belongs to a different reuseport
>> group than the one the packet is for.
>> 
>> Because SOCKARRAY used to be the only BPF map type that can be used with
>> reuseport BPF, it was possible to delay the generation of reuseport group
>> ID until a socket from the group was inserted into BPF map for the first
>> time.
>> 
>> Now that SOCKMAP can be used with reuseport BPF we have two options, either
>> generate the reuseport ID on map update, like SOCKARRAY does, or allocate
>> an ID from the start when reuseport group gets created.
>> 
>> This patch goes the latter approach to keep SOCKMAP free of calls into
>> reuseport code. This streamlines the reuseport_id access as its lifetime
>> now matches the longevity of reuseport object.
>> 
>> The cost of this simplification, however, is that we allocate reuseport IDs
>> for all SO_REUSEPORT users. Even those that don't use SOCKARRAY in their
>> setups. With the way identifiers are currently generated, we can have at
>> most S32_MAX reuseport groups, which hopefully is sufficient.
> Not sure if it would be a concern.  I think it is good as is.
> For TCP, that would mean billion different ip:port listening socks
> in inet_hashinfo.
>
> If it came to that, another idea is to use a 64bit reuseport_id which
> practically won't wrap around.  It could use the very first sk->sk_cookie
> as the reuseport_id.  All the ida logic will go away also in the expense
> of +4 bytes.

Thanks for the idea. I'll add it to the patch description.

>
>> 
>> Another change is that we now always call into SOCKARRAY logic to unlink
>> the socket from the map when unhashing or closing the socket. Previously we
>> did it only when at least one socket from the group was in a BPF map.
>> 
>> It is worth noting that this doesn't conflict with SOCKMAP tear-down in
>> case a socket is in a SOCKMAP and belongs to a reuseport group. SOCKMAP
>> tear-down happens first:
>> 
>>   prot->unhash
>>   `- tcp_bpf_unhash
>>      |- tcp_bpf_remove
>>      |  `- while (sk_psock_link_pop(psock))
>>      |     `- sk_psock_unlink
>>      |        `- sock_map_delete_from_link
>>      |           `- __sock_map_delete
>>      |              `- sock_map_unref
>>      |                 `- sk_psock_put
>>      |                    `- sk_psock_drop
>>      |                       `- rcu_assign_sk_user_data(sk, NULL)
>>      `- inet_unhash
>>         `- reuseport_detach_sock
>>            `- bpf_sk_reuseport_detach
>>               `- WRITE_ONCE(sk->sk_user_data, NULL)
> Thanks for the details.
>
> [ ... ]
>
>> @@ -200,12 +189,10 @@ void reuseport_detach_sock(struct sock *sk)
>>  	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
>>  					  lockdep_is_held(&reuseport_lock));
>>  
>> -	/* At least one of the sk in this reuseport group is added to
>> -	 * a bpf map.  Notify the bpf side.  The bpf map logic will
>> -	 * remove the sk if it is indeed added to a bpf map.
>> +	/* Notify the bpf side. The sk may be added to bpf map. The
>> +	 * bpf map logic will remove the sk from the map if indeed.
> s/indeed/needed/ ?
>
> I think it will be good to have a few words here like, that is needed
> by sockarray but not necessary for sockmap which has its own ->unhash
> to remove itself from the map.


Yeah, I didn't do it justice. Will expand the comment.

[...]
