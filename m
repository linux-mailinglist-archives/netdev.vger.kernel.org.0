Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E364A9D72D
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 22:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbfHZUEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 16:04:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33424 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729144AbfHZUEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 16:04:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id p77so770710wme.0
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 13:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bKlOOGzQn7UNQuXersSFPLBIGdpMs03IGIsGpzGUw2o=;
        b=l9bCcXcSMe5a0fzir4LI/RhuHerpjM2Qp1tXyEUXj4vy0GfzCwCPmxlBZWSyq9jwec
         eNRpJoUCfddhDJPmVHch91//zv45IysCk15HHIOiRaEZGij0ilfYav2938eKs4c1cwAZ
         WTlJr9oD0g0Fb8RJE0HkS4YEt42TXWzjxhhnv1PiLZopJ3zOVWWDzjCgLX6QcMymFhqB
         MueuCJI6nBM73CHBpn9F3lREgWvH8om2GADhmLsfFOyXsDUy9Rhf60UigNiHSEGopKa5
         fBKEqm1MwcoVSnlPzDw52i2Rpc576GWY7sYMgNH6pQW6z/R9prfok1D5nePcu8L8e9S9
         3TXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bKlOOGzQn7UNQuXersSFPLBIGdpMs03IGIsGpzGUw2o=;
        b=RyA8evNOk+J+tAcNb78CZHH3oVwuwGg8yAUReuzyXE+RbFRJwCuTSdM7ixzL8nQ9BJ
         E6UxIATVSPGjeGXdxHYTPREGw0YBps4wdcabIc5Q2lkJXITlHdCvm5DDzRo3mj4g1Q22
         qo4Bv1UnW5+dZQ62EubXlnYj03J/xqczCFRV/isd+638Ks47a4a+wfbFLG+W5J3VzrgO
         jTGQ3+hO3FrxhAXTkSy8L3IVaJ4EW0IjwtS9agmd2Z3SUmc1HT+mFuAe4315QNeMCU9c
         cnxenfteK1Q4/CAniUc2yJJdmbL7lVvwRkEPPDIrz86hOnfZPU2Q0lsTScF4KqJN9+4G
         mpYg==
X-Gm-Message-State: APjAAAUSKARXGbxeip3HkjWZ/Htv7hKzuZSwIHp5JB7hxmBK3WpSKb4A
        vcdZ6+BFyAM75UW3hHCB2UQ=
X-Google-Smtp-Source: APXvYqzeJ7cty9CRgTcVJEtKx6dgbETYX7F2UAf2AYpyeJuld7Y9AJvKXGIXiCWkulVEkVG76WERJw==
X-Received: by 2002:a05:600c:24cf:: with SMTP id 15mr23639999wmu.76.1566849874035;
        Mon, 26 Aug 2019 13:04:34 -0700 (PDT)
Received: from [192.168.8.147] (17.170.185.81.rev.sfr.net. [81.185.170.17])
        by smtp.gmail.com with ESMTPSA id s64sm1229665wmf.16.2019.08.26.13.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Aug 2019 13:04:33 -0700 (PDT)
Subject: Re: [PATCH net] tcp: remove empty skb from write queue in error cases
To:     Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Vladimir Rutsky <rutsky@google.com>
References: <20190826161915.81676-1-edumazet@google.com>
 <58ae43f8-21e7-f08f-2632-ce567661d301@akamai.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ebe471e1-e4ad-4b59-9819-08a7d976beb1@gmail.com>
Date:   Mon, 26 Aug 2019 22:04:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <58ae43f8-21e7-f08f-2632-ce567661d301@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/19 9:56 PM, Jason Baron wrote:
> 
> 
> On 8/26/19 12:19 PM, Eric Dumazet wrote:
>> Vladimir Rutsky reported stuck TCP sessions after memory pressure
>> events. Edge Trigger epoll() user would never receive an EPOLLOUT
>> notification allowing them to retry a sendmsg().
>>
>> Jason tested the case of sk_stream_alloc_skb() returning NULL,
>> but there are other paths that could lead both sendmsg() and sendpage()
>> to return -1 (EAGAIN), with an empty skb queued on the write queue.
>>
>> This patch makes sure we remove this empty skb so that
>> Jason code can detect that the queue is empty, and
>> call sk->sk_write_space(sk) accordingly.
>>
> 
> Makes sense, thanks. I think this check for empty queue could also
> benefit from and update to use tcp_write_queue_empty(). I will send a
> follow-up for that.
>

My plan (for net-next) is to submit something more like this one instead.

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 051ef10374f6..908dbe91e04b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1068,7 +1068,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
                goto out;
 out_err:
        /* make sure we wake any epoll edge trigger waiter */
-       if (unlikely(skb_queue_len(&sk->sk_write_queue) == 0 &&
+       if (unlikely(tcp_rtx_and_write_queues_empty(sk) &&
                     err == -EAGAIN)) {
                sk->sk_write_space(sk);
                tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
@@ -1407,7 +1407,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
        sock_zerocopy_put_abort(uarg, true);
        err = sk_stream_error(sk, flags, err);
        /* make sure we wake any epoll edge trigger waiter */
-       if (unlikely(skb_queue_len(&sk->sk_write_queue) == 0 &&
+       if (unlikely(tcp_rtx_and_write_queues_empty(sk) &&
                     err == -EAGAIN)) {
                sk->sk_write_space(sk);
                tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);

