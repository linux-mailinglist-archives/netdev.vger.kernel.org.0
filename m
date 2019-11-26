Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4DA310A417
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 19:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfKZSgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 13:36:17 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41342 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfKZSgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 13:36:17 -0500
Received: by mail-lj1-f194.google.com with SMTP id m4so21395081ljj.8
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 10:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=KsEBsZKlzhoo/unNBEOdh8ALb9NO6vGmMpoXTg/aNqg=;
        b=NLbk+AeRlyuJx90fgTsj6nV9S2duTsC/Qbp6cxY1tj/MYYQDKCS8eaWaJo7o9yxHLx
         MSQnsGtb5RIzbTIO6vMhEcpzrrDWHYFAEeTD974NjP+36vx/DlbsmEgOnlHZ/zob9JHP
         Kpl+9GTL33ao94W+PVHCZ0BpMobyZ/Y4tCxss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=KsEBsZKlzhoo/unNBEOdh8ALb9NO6vGmMpoXTg/aNqg=;
        b=oAAG4PwOMN2c+IylxZ7gCsxv7MBOwK2SogjoZpxnXpq2jD/Vys3anp0BarBbLMx1yq
         XeWW9N+g4ZwYoSmSjtYYRXrRa4tdga4btv5uAi7uyIecUqQXlExV5/tGa7NtUK+DFqpz
         OD8DNni+qAV9H4sE/qOvcYw6I69qGA+giqAoPO7p5rdNYsIJYf+bt5u4M4IcXER00S6M
         TS9NT6GRQiRI8vPfGdzV2hMeL+h/rnungD197g2ZbRjHk3kAzxVbpa4cOnXS8N1Nq8s1
         WLx3ynQwCCBtJiivWbwL1H4O+atTfcinj2g21ZniYZ4BmuJi/te5wALUAbix6pHFQ/5+
         nX1g==
X-Gm-Message-State: APjAAAUpLcN31t+Y3EvZIKtrAHbvYSRgbbhLADvcgv/ouPbfTNBA8vx1
        +NDqag5RFkz6byTQ4xXbZcszOA==
X-Google-Smtp-Source: APXvYqyD5yqa7Iwcrora7PXu5D+dOBL0tlOiNKWwdlvcvfzvylTqLdDsG+z7SvZb8jGM97XHpDjVrA==
X-Received: by 2002:a2e:8595:: with SMTP id b21mr28123607lji.155.1574793372884;
        Tue, 26 Nov 2019 10:36:12 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id u6sm5575901lfu.49.2019.11.26.10.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 10:36:12 -0800 (PST)
References: <20191123110751.6729-1-jakub@cloudflare.com> <20191123110751.6729-5-jakub@cloudflare.com> <20191125223845.6t6xoqcwcqxuqbdf@kafai-mbp> <87ftiaocp2.fsf@cloudflare.com> <20191126171607.pzrg5qhbavh7enwh@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket inherit psock or its ops on copy
In-reply-to: <20191126171607.pzrg5qhbavh7enwh@kafai-mbp.dhcp.thefacebook.com>
Date:   Tue, 26 Nov 2019 19:36:09 +0100
Message-ID: <87d0deo57q.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 06:16 PM CET, Martin Lau wrote:
> On Tue, Nov 26, 2019 at 04:54:33PM +0100, Jakub Sitnicki wrote:
>> On Mon, Nov 25, 2019 at 11:38 PM CET, Martin Lau wrote:
>> > On Sat, Nov 23, 2019 at 12:07:47PM +0100, Jakub Sitnicki wrote:
>> > [ ... ]
>> >
>> >> @@ -370,6 +378,11 @@ static inline void sk_psock_restore_proto(struct sock *sk,
>> >>  			sk->sk_prot = psock->sk_proto;
>> >>  		psock->sk_proto = NULL;
>> >>  	}
>> >> +
>> >> +	if (psock->icsk_af_ops) {
>> >> +		icsk->icsk_af_ops = psock->icsk_af_ops;
>> >> +		psock->icsk_af_ops = NULL;
>> >> +	}
>> >>  }
>> >
>> > [ ... ]
>> >
>> >> +static struct sock *tcp_bpf_syn_recv_sock(const struct sock *sk,
>> >> +					  struct sk_buff *skb,
>> >> +					  struct request_sock *req,
>> >> +					  struct dst_entry *dst,
>> >> +					  struct request_sock *req_unhash,
>> >> +					  bool *own_req)
>> >> +{
>> >> +	const struct inet_connection_sock_af_ops *ops;
>> >> +	void (*write_space)(struct sock *sk);
>> >> +	struct sk_psock *psock;
>> >> +	struct proto *proto;
>> >> +	struct sock *child;
>> >> +
>> >> +	rcu_read_lock();
>> >> +	psock = sk_psock(sk);
>> >> +	if (likely(psock)) {
>> >> +		proto = psock->sk_proto;
>> >> +		write_space = psock->saved_write_space;
>> >> +		ops = psock->icsk_af_ops;
>> > It is not immediately clear to me what ensure
>> > ops is not NULL here.
>> >
>> > It is likely I missed something.  A short comment would
>> > be very useful here.
>>
>> I can see the readability problem. Looking at it now, perhaps it should
>> be rewritten, to the same effect, as:
>>
>> static struct sock *tcp_bpf_syn_recv_sock(...)
>> {
>> 	const struct inet_connection_sock_af_ops *ops = NULL;
>>         ...
>>
>>         rcu_read_lock();
>> 	psock = sk_psock(sk);
>> 	if (likely(psock)) {
>> 		proto = psock->sk_proto;
>> 		write_space = psock->saved_write_space;
>> 		ops = psock->icsk_af_ops;
>> 	}
>> 	rcu_read_unlock();
>>
>>         if (!ops)
>> 		ops = inet_csk(sk)->icsk_af_ops;
>>         child = ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
>>
>> If psock->icsk_af_ops were NULL, it would mean we haven't initialized it
>> properly. To double check what happens here:
> I did not mean the init path.  The init path is fine since it init
> eveything on psock before publishing the sk to the sock_map.
>
> I was thinking the delete path (e.g. sock_map_delete_elem).  It is not clear
> to me what prevent the earlier pasted sk_psock_restore_proto() which sets
> psock->icsk_af_ops to NULL from running in parallel with
> tcp_bpf_syn_recv_sock()?  An explanation would be useful.

Ah, I misunderstood. Nothing prevents the race, AFAIK.

Setting psock->icsk_af_ops to null on restore and not checking for it
here was a bad move on my side.  Also I need to revisit what to do about
psock->sk_proto so the child socket doesn't end up with null sk_proto.

This race should be easy enough to trigger. Will give it a shot.

Thank you for bringing this up,
Jakub

>
>>
>> In sock_map_link we do a setup dance where we first create the psock and
>> later initialize the socket callbacks (tcp_bpf_init).
>>
>> static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
>> 			 struct sock *sk)
>> {
>>         ...
>> 	if (psock) {
>>                 ...
>> 	} else {
>> 		psock = sk_psock_init(sk, map->numa_node);
>> 		if (!psock) {
>> 			ret = -ENOMEM;
>> 			goto out_progs;
>> 		}
>> 		sk_psock_is_new = true;
>> 	}
>>         ...
>>         if (sk_psock_is_new) {
>> 		ret = tcp_bpf_init(sk);
>> 		if (ret < 0)
>> 			goto out_drop;
>> 	} else {
>> 		tcp_bpf_reinit(sk);
>> 	}
>>
>> The "if (sk_psock_new)" branch triggers the call chain that leads to
>> saving & overriding socket callbacks.
>>
>> tcp_bpf_init -> tcp_bpf_update_sk_prot -> sk_psock_update_proto
>>
>> Among them, icsk_af_ops.
>>
>> static inline void sk_psock_update_proto(...)
>> {
>>         ...
>> 	psock->icsk_af_ops = icsk->icsk_af_ops;
>> 	icsk->icsk_af_ops = af_ops;
>> }
>>
>> Goes without saying that a comment is needed.
>>
>> Thanks for the feedback,
>> Jakub
