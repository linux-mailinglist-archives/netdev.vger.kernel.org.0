Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22958AA46F
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 15:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfIEN1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 09:27:14 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37975 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbfIEN1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 09:27:13 -0400
Received: by mail-io1-f66.google.com with SMTP id p12so4843034iog.5
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 06:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=L1TnfyCLG7rlHGNonZ0i4cKuCdSYVp9z1iWPFj0gqwo=;
        b=f3nEE8flnjwrCDtjgOcBKre/Hn8e6XQ5aBF+kZhhnb8c7RnU1edQbZ/qliD39R7b5R
         sad4WXph+B53SJbBmjzVnWvV2M7FMZLMkcVwx9JcUyfDcL07yYDbWQ7HjabqAucrEijf
         ZYat9r42UMs1gAYpG8076SyePTRwi5CUh59eH78G3F3hLJTOzQJE+JfYh6yW1pg7yHsF
         feJ3927cP+c53BXcKDPJ4L2/KQfeD1gCbTxClHgi3yUDWqdEjwKYma0DvlbC7xflggKY
         0T6DENU7aCWpXxc3n/cWMDy8uO30IRscY0B8lPKJkLn1T5EIVNyFU0HQKAsMrN3p45xX
         enPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=L1TnfyCLG7rlHGNonZ0i4cKuCdSYVp9z1iWPFj0gqwo=;
        b=tUwsnC0tu3AMHqpZbkyRmYd4gq9Ys/AgXGja7oRYJMFKHn8+v5UamkFeqE9iuW2cwz
         lCV+tssmTrWhqNFPq6tuBEXUhHd00azfxyntcaz8gxyxpc8Ot8kW2ZySugQz90BUTpMY
         qWd7nqSExQJbEChZq2ZGyFdpLvZNMTC/ohpSqwFzS+LyT5dhRfxuqDXP8qEeDlNcMAW5
         CdE+FwChj09b9NiBCylmLKCwdOir39f6nEdjz+NOwPxyM8dk0Q3S5M5tNodGVhfYHIIk
         i+gIdfiR9lRhEeGq9JLGXewzgH2zh7jQRnAyU160hyN6NwEH3SNtb3we/65LXteZbdOR
         nlOQ==
X-Gm-Message-State: APjAAAX6gTVLSC5jRlb5lbAMppFonqh2WYknZfqT1ZPBKP63MMdqzupf
        X4g/iM44oxjzeyGsjulq4wU=
X-Google-Smtp-Source: APXvYqyC0oReirvbL19su5YpavGFCppxlCLp+mXwQv2rkfVAFQ8iuQv2C/kTucZnekytIdimNDx29Q==
X-Received: by 2002:a5d:940c:: with SMTP id v12mr4166096ion.233.1567690032389;
        Thu, 05 Sep 2019 06:27:12 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b7sm1653654iod.78.2019.09.05.06.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 06:27:11 -0700 (PDT)
Date:   Thu, 05 Sep 2019 06:27:02 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5d710d26b6a73_d1e2b257ce4c5c4db@john-XPS-13-9370.notmuch>
In-Reply-To: <20190905122022.106680-1-edumazet@google.com>
References: <20190905122022.106680-1-edumazet@google.com>
Subject: RE: [PATCH net] net: sched: fix reordering issues
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet wrote:
> Whenever MQ is not used on a multiqueue device, we experience
> serious reordering problems. Bisection found the cited
> commit.
> 
> The issue can be described this way :
> 
> - A single qdisc hierarchy is shared by all transmit queues.
>   (eg : tc qdisc replace dev eth0 root fq_codel)
> 
> - When/if try_bulk_dequeue_skb_slow() dequeues a packet targetting
>   a different transmit queue than the one used to build a packet train,
>   we stop building the current list and save the 'bad' skb (P1) in a
>   special queue. (bad_txq)
> 
> - When dequeue_skb() calls qdisc_dequeue_skb_bad_txq() and finds this
>   skb (P1), it checks if the associated transmit queues is still in frozen
>   state. If the queue is still blocked (by BQL or NIC tx ring full),
>   we leave the skb in bad_txq and return NULL.
> 
> - dequeue_skb() calls q->dequeue() to get another packet (P2)
> 
>   The other packet can target the problematic queue (that we found
>   in frozen state for the bad_txq packet), but another cpu just ran
>   TX completion and made room in the txq that is now ready to accept
>   new packets.
> 
> - Packet P2 is sent while P1 is still held in bad_txq, P1 might be sent
>   at next round. In practice P2 is the lead of a big packet train
>   (P2,P3,P4 ...) filling the BQL budget and delaying P1 by many packets :/
> 
> To solve this problem, we have to block the dequeue process as long
> as the first packet in bad_txq can not be sent. Reordering issues
> disappear and no side effects have been seen.
> 
> Fixes: a53851e2c321 ("net: sched: explicit locking in gso_cpu fallback")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/sched/sch_generic.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 

Dang, missed this case. Thanks!

Acked-by: John Fastabend <john.fastabend@gmail.com>
