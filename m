Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C42B4977F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 04:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfFRC2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 22:28:05 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35944 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfFRC2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 22:28:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id r7so6711731pfl.3
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 19:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vUKofOGH1gvwBEeVpzpc3PDw0IJK5kw+zNbRlBvh8Wc=;
        b=uajXNxSKC1SFWJGVhdex7K4MJXQmW4tcDMvL7y7FvDJNFFtDajbI4btsNSHp/ADnYF
         irYKj7xYgB4Azy2grGjX4rn7Ypy8pWZhNbCNsN4nY4gUoGmPSIQOK5Mq4mHOxIfxdnHP
         43QfKCFYarbAgr42kmSGDFA1VADlh+5lmYql8kzfZBtyPzSIQkshLOSR3ZXZ17NoJH/N
         GNd1B/rbN544TbefRP704oD65iHyhqkTpbQJ4cTViQiqNRrlMFRxAirQhxn43YrVakVS
         X8bb82VH/DaXZBVGcym9w3dsleDmtgkK2GGrPy/YneRYXsktrFydpr+EuuvMZtwUWqLx
         U5IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vUKofOGH1gvwBEeVpzpc3PDw0IJK5kw+zNbRlBvh8Wc=;
        b=el4LB+mDm4W7xMaRVSaaLZY3GuoOB0wQiFoiYgz1Qkkc06COc+kDYMaeC4oQB3E0Qx
         kmxB8cvgsJa4vCD9zT7DO/Ak64W/E1+bGoYlxB+zBMQKngDpGGp8FXGzeIF6ZqAE4bZG
         TY1asJsaJcReqWQTvgXpupxIeHaRUAVcuT5DXboEwoYhWYar88VereTVjUyZtMErZbon
         37ziLnT3meGusnXtWv161PtDctghJ6TVMWoOjSducBPd+s3OYFnEyQbQfBLBazDZEXCA
         cQuynqLK3Gw8rvFg1Csa7vN8a7wqfAiNQtUjEF5uXa4Q4JkHyaHyV/swg4zSukiVc2t7
         uZMg==
X-Gm-Message-State: APjAAAWZn+Aed8kUW05sgSjcVZF3szjrrm6qZR1SeN9HL8kyA/wDzbjc
        BxJlH9RcfevHKvakskZO39X6vAZd
X-Google-Smtp-Source: APXvYqz4Sa+aFvqEDWV0uXgl/UyeL7i/IEdt0yQRz80ChTaRHR6qidxoXODBJIYsqh/PX4JrhqLGfA==
X-Received: by 2002:a62:e806:: with SMTP id c6mr6562164pfi.158.1560824884375;
        Mon, 17 Jun 2019 19:28:04 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id n17sm24422424pfq.182.2019.06.17.19.28.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 19:28:03 -0700 (PDT)
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dustin Marquess <dmarquess@apple.com>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
Date:   Mon, 17 Jun 2019 19:28:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/19 5:18 PM, Christoph Paasch wrote:
> 
> Hi Eric, I now have a packetdrill test that started failing (see
> below). Admittedly, a bit weird test with the SO_SNDBUF forced so low.
> 
> Nevertheless, previously this test would pass, now it stalls after the
> write() because tcp_fragment() returns -ENOMEM. Your commit-message
> mentions that this could trigger when one sets SO_SNDBUF low. But,
> here we have a complete stall of the connection and we never recover.
> 
> I don't know if we care about this, but there it is :-)

I guess it is WAI :)

Honestly I am not sure we want to add code just to allow these degenerated use cases.

Upstream kernels could check if rtx queue is empty or not, but this check will be not trivial to backport


Can you test :

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 00c01a01b547ec67c971dc25a74c9258563cf871..06576540133806222f43d4a9532c5a929a2965b0 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1296,7 +1296,8 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
        if (nsize < 0)
                nsize = 0;
 
-       if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
+       if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf &&
+                    !tcp_rtx_queue_empty(sk))) {
                NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
                return -ENOMEM;
        }
