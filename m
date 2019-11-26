Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E1410A191
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 16:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfKZPyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 10:54:39 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37032 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbfKZPyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 10:54:38 -0500
Received: by mail-lj1-f195.google.com with SMTP id d5so20840610ljl.4
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 07:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=mFwfXWuGO5JOurpx5SkPd+KNxxhTjX3Z1Z8V3BB+pts=;
        b=HeXPzxSoFR2LsBmJtbhmxuXXJyaincCrhAliBzNAEN4+y3gntDWnoPNPS72VVOo+OI
         wn5mSOleLOF/enxkyrJdQxpEVOxuaMa9iBQn0SAM12pLG2FpeUHvXBTwuo5Fhx37W7F5
         VzoJ8xc0Z7+riX+ToctBScyFdTFS1UruwGejk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=mFwfXWuGO5JOurpx5SkPd+KNxxhTjX3Z1Z8V3BB+pts=;
        b=qJPm08dDRJXCYY9ZIhLWClhtT2hojuXgH73oYGeikKgVDfNQvXgpdjrUgK/6MhCcrT
         qgkvpRGHyg4upGQwEhbk1+0+3ePGk5KXy+sxnHlOw97cfNG3hHm/7FaV0XmqC0zz940Q
         /qVFrk6NsXrX6bWxCd2krC4n6Yv8etWWZA+Xv/0JKSySjodnU/cK7ZLnAc5H7QUtBzy0
         +WyZycB+VWNhT2zYMK8/lKof5i171rvn/UVNMI4FEfxqFbEgR11GIpuY/v6IVCVWSpTy
         DtrDkHi6HKT38XLrnjt6VkvZotCMXpKLRHMo9yVoOQtHeQkV8003lOTVks822+62JfPl
         BzXA==
X-Gm-Message-State: APjAAAUSfLdbjqB7XKPBgHA6mN1vncsIvtoRfhZ5/NFU/v5HlbzLp94I
        WG+HpdcwUdAt/zhFll5GAVB2iQ==
X-Google-Smtp-Source: APXvYqxJvnCDrbxdgGKMynD+7yJmRV236MQG1514vjQ1bHWW5awLQj2bNOd3+y5E2f/+IVCeFSkSTw==
X-Received: by 2002:a2e:9606:: with SMTP id v6mr15757955ljh.223.1574783675315;
        Tue, 26 Nov 2019 07:54:35 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id 30sm5841826ljw.29.2019.11.26.07.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 07:54:34 -0800 (PST)
References: <20191123110751.6729-1-jakub@cloudflare.com> <20191123110751.6729-5-jakub@cloudflare.com> <20191125223845.6t6xoqcwcqxuqbdf@kafai-mbp>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next 4/8] bpf, sockmap: Don't let child socket inherit psock or its ops on copy
In-reply-to: <20191125223845.6t6xoqcwcqxuqbdf@kafai-mbp>
Date:   Tue, 26 Nov 2019 16:54:33 +0100
Message-ID: <87ftiaocp2.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 11:38 PM CET, Martin Lau wrote:
> On Sat, Nov 23, 2019 at 12:07:47PM +0100, Jakub Sitnicki wrote:
> [ ... ]
>
>> @@ -370,6 +378,11 @@ static inline void sk_psock_restore_proto(struct sock *sk,
>>  			sk->sk_prot = psock->sk_proto;
>>  		psock->sk_proto = NULL;
>>  	}
>> +
>> +	if (psock->icsk_af_ops) {
>> +		icsk->icsk_af_ops = psock->icsk_af_ops;
>> +		psock->icsk_af_ops = NULL;
>> +	}
>>  }
>
> [ ... ]
>
>> +static struct sock *tcp_bpf_syn_recv_sock(const struct sock *sk,
>> +					  struct sk_buff *skb,
>> +					  struct request_sock *req,
>> +					  struct dst_entry *dst,
>> +					  struct request_sock *req_unhash,
>> +					  bool *own_req)
>> +{
>> +	const struct inet_connection_sock_af_ops *ops;
>> +	void (*write_space)(struct sock *sk);
>> +	struct sk_psock *psock;
>> +	struct proto *proto;
>> +	struct sock *child;
>> +
>> +	rcu_read_lock();
>> +	psock = sk_psock(sk);
>> +	if (likely(psock)) {
>> +		proto = psock->sk_proto;
>> +		write_space = psock->saved_write_space;
>> +		ops = psock->icsk_af_ops;
> It is not immediately clear to me what ensure
> ops is not NULL here.
>
> It is likely I missed something.  A short comment would
> be very useful here.

I can see the readability problem. Looking at it now, perhaps it should
be rewritten, to the same effect, as:

static struct sock *tcp_bpf_syn_recv_sock(...)
{
	const struct inet_connection_sock_af_ops *ops = NULL;
        ...

        rcu_read_lock();
	psock = sk_psock(sk);
	if (likely(psock)) {
		proto = psock->sk_proto;
		write_space = psock->saved_write_space;
		ops = psock->icsk_af_ops;
	}
	rcu_read_unlock();

        if (!ops)
		ops = inet_csk(sk)->icsk_af_ops;
        child = ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);

If psock->icsk_af_ops were NULL, it would mean we haven't initialized it
properly. To double check what happens here:

In sock_map_link we do a setup dance where we first create the psock and
later initialize the socket callbacks (tcp_bpf_init).

static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
			 struct sock *sk)
{
        ...
	if (psock) {
                ...
	} else {
		psock = sk_psock_init(sk, map->numa_node);
		if (!psock) {
			ret = -ENOMEM;
			goto out_progs;
		}
		sk_psock_is_new = true;
	}
        ...
        if (sk_psock_is_new) {
		ret = tcp_bpf_init(sk);
		if (ret < 0)
			goto out_drop;
	} else {
		tcp_bpf_reinit(sk);
	}

The "if (sk_psock_new)" branch triggers the call chain that leads to
saving & overriding socket callbacks.

tcp_bpf_init -> tcp_bpf_update_sk_prot -> sk_psock_update_proto

Among them, icsk_af_ops.

static inline void sk_psock_update_proto(...)
{
        ...
	psock->icsk_af_ops = icsk->icsk_af_ops;
	icsk->icsk_af_ops = af_ops;
}

Goes without saying that a comment is needed.

Thanks for the feedback,
Jakub
