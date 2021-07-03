Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13D23BA9E7
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 19:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhGCRzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 13:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGCRzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 13:55:13 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8337EC061764
        for <netdev@vger.kernel.org>; Sat,  3 Jul 2021 10:52:39 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id q16so24395938lfr.4
        for <netdev@vger.kernel.org>; Sat, 03 Jul 2021 10:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=SVryx1Dz/Rfz74aRPewLGgtrWVBrUYm/gw+OgtO6VVw=;
        b=EHFGqHi/88AkaernBatnMRrly5nTGITip4R/pgu0+kZc1Trc5MDMjYqnlDPxF8grNV
         x9/pbBsMzKk4PufhIop1DzPby0j4gQpF+8F+unYta8RDC+tD4aLGqtAqnvES4snd3+WC
         ahYZ8f5WAx1/Z1NWJxMgOr3zUtWeiCv8hW1uc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=SVryx1Dz/Rfz74aRPewLGgtrWVBrUYm/gw+OgtO6VVw=;
        b=lXwKblt+O04enxrO8tWWVMQZ9ADbKBAaUjqmteK+VatESmZobDeS4mqwPtPaeKl9JK
         dGaYjSG0vwNgrFsPRyBorOSKzU/b/iPpfvGQ/G43wqWFAtLGgdX537OZzpUsQwabP6EL
         qbbBUwnVAWP37lxE3kltkKQtirNukC75BVSEoJtLKO2vscyw2ryIzlIr6CwOc9cr+8F2
         Uq+RP1sB3bmwSI3LHZha01O0Jkvdgq0/3BOtfsbsJK7heeV6NHmGIwDLdxirrwCRqmDl
         Lmn+wqb2e3F3ZWpBdxsn3nPVd/D+p1DTxSb2pX1JygxDjrNtZk/CkorZq1hgJakPwz7m
         YRnw==
X-Gm-Message-State: AOAM531R89pYovc4gnYbyVsXvt99YSyot0cm3vZOpNAQ74tSsv4DwWve
        WdyCQtuou7ofoRflweIloVcRKA==
X-Google-Smtp-Source: ABdhPJxJCpLjqT0tvdIFbJ3HqJxKg0sXm8pdpskeoYvL8dToAMzWdT/X4BUOIacHdETZRtOl97GI9A==
X-Received: by 2002:a05:6512:332e:: with SMTP id l14mr4145629lfe.43.1625334757651;
        Sat, 03 Jul 2021 10:52:37 -0700 (PDT)
Received: from cloudflare.com (79.191.58.233.ipv4.supernova.orange.pl. [79.191.58.233])
        by smtp.gmail.com with ESMTPSA id g20sm747080lja.2.2021.07.03.10.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jul 2021 10:52:36 -0700 (PDT)
References: <20210701061656.34150-1-xiyou.wangcong@gmail.com>
 <60ddec01c651b_3fe24208dc@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf v2] skmsg: check sk_rcvbuf limit before queuing to
 ingress_skb
In-reply-to: <60ddec01c651b_3fe24208dc@john-XPS-13-9370.notmuch>
Date:   Sat, 03 Jul 2021 19:52:35 +0200
Message-ID: <875yxrs2sc.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 06:23 PM CEST, John Fastabend wrote:

[...]

>> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
>> index 9b6160a191f8..a5185c781332 100644
>> --- a/net/core/skmsg.c
>> +++ b/net/core/skmsg.c
>> @@ -854,7 +854,8 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
>>  		return -EIO;
>>  	}
>>  	spin_lock_bh(&psock_other->ingress_lock);
>> -	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
>> +	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED) ||
>> +	    atomic_read(&sk_other->sk_rmem_alloc) > READ_ONCE(sk_other->sk_rcvbuf)) {
>>  		spin_unlock_bh(&psock_other->ingress_lock);
>>  		skb_bpf_redirect_clear(skb);
>>  		sock_drop(from->sk, skb);
>> @@ -930,7 +931,8 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
>>  		}
>>  		if (err < 0) {
>>  			spin_lock_bh(&psock->ingress_lock);
>> -			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
>> +			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED) &&
>> +			    atomic_read(&sk_other->sk_rmem_alloc) <= READ_ONCE(sk_other->sk_rcvbuf)) {
>>  				skb_queue_tail(&psock->ingress_skb, skb);
>
> We can't just drop the packet in the memory overrun case here. This will
> break TCP because the data will be gone and no one will retransmit.

I don't think it's always the case that data will be gone. But you're
right that it breaks TCP. I was too quick to Ack this patch.

When running with just the verdict prog attached, the -EIO error from
sk_psock_verdict_apply is propagated up to tcp_read_sock. That is, it
maps to 0 bytes used by recv_actor. sk_psock_verdict_recv in this case.

tcp_read_sock, if 0 bytes were used = copied, won't sk_eat_skb. It stays
on sk_receive_queue.

  sk->sk_data_ready
    sk_psock_verdict_data_ready
      ->read_sock(..., sk_psock_verdict_recv)
        tcp_read_sock (used = copied = 0)
          sk_psock_verdict_recv -> ret = 0
            sk_psock_verdict_apply -> -EIO
              sk_psock_skb_redirect -> -EIO

However, I think this gets us stuck. What if no more data gets queued,
and sk_data_ready doesn't get called again?


Then there is the case when a parser prog is attached. In this case the
skb is really gone if we drop it on redirect.

In sk_psock_strp_read, we ignore the -EIO error from
sk_psock_verdict_apply, and return to tcp_read_sock how many bytes have
been parsed.

  sk->sk_data_ready
    sk_psock_verdict_data_ready
      ->read_sock(..., sk_psock_verdict_recv)
        tcp_read_sock (used = copied = eaten)
          strp_recv -> ret = eaten
            __strp_recv -> ret = eaten
              strp->cb.rcv_msg -> -EIO
                sk_psock_verdict_apply -> -EIO
                  sk_psock_redirect -> -EIO

Maybe we could put the skb back on strp->skb_head list on error, though?

But again some notification would need to trigger a re-read, or we are
stuck.
