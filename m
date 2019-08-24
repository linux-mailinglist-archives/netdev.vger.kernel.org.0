Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6999BC17
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 08:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfHXGEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 02:04:31 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36069 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfHXGEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 02:04:31 -0400
Received: by mail-ed1-f65.google.com with SMTP id p28so17064127edi.3
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 23:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=zlS7GxEwul9xHBXf0TtmnIw7TkllF8m/gktgPPMmp5M=;
        b=frAY5fnu87ofhmUo4Y6iGlwfLBp3EfiQLcOzIA3P9DX/Y/7U1mHe1BpNbFmqNkVa9x
         u8WUiHdJ4m24D619cJg6eKsOjbKFyui2HsnVtFJlm0DBUa3jQaxxVDX1VCAhzzjoe24c
         QPRuscgZl6yVWJos9aAucxA7toXChN/O/TEYTk3081r9cGkAFnT9+b5/czhTSIA0s0m7
         Q1lVh+xDsBXHgAD8uvTOHvFtoH5EyBvv2cEhRuHObOQ56pq1DosxqfdvKBkBwrqQ23Hf
         KAOkOCQogNvQ6KxcoXi2rYtuiheJViky5oKwLzjumscamJOQrrUEy12/Rvh9WYfZgs+Z
         Wtgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=zlS7GxEwul9xHBXf0TtmnIw7TkllF8m/gktgPPMmp5M=;
        b=B95s/Ety+9Kn6EI5NJ8ODsOzr7OjvShRR6T+Vfad41UtllFCw39tMjw2XN3l6/neDL
         QmKeaVzWjxj59gvBEPWG/F8iw78eJoraczttVxcjtVCKzjUJ5zMOKSsJx58qFojPJQrK
         PrOMycE8ZZ9tt9UGqWp/m7vMNITx8cLkf01wJMdUSwzHOlrXZVrktR/gM/EApa6eE0a8
         vdr/piBx77evWEKWolqCukRINVD+KUPF39betOWjZC7CEWk++IsncU+JW3B5PAv/MZb0
         n25vQlcZut1HoU80QtrZBCMMjpkcN4PXbPlSSjFN2AxbW3VojO6P5cXrCpzP7NG09DP4
         qWjg==
X-Gm-Message-State: APjAAAW7kcxXlV0oqks2jbqUj9l4pkhcqw4BwCQOKSSWG5Q853qTBgNo
        SH9nWjfRbID9iyQiW5gNooDELmhVTgKEfPH/LIO8Q/9c3B4ARIzHFsvQg8TW/DcckfIII0OWtk3
        garK19aJ3MQ==
X-Google-Smtp-Source: APXvYqwSQzvqGDN/okxEn95Se5b2s2pVAe9xETXTw8ID/zK3XHTlz8oYE1Wp9rb0l1zcZ1l8iJFIjg==
X-Received: by 2002:a17:906:9453:: with SMTP id z19mr7499937ejx.287.1566626669855;
        Fri, 23 Aug 2019 23:04:29 -0700 (PDT)
Received: from tim.lan (94-224-35-235.access.telenet.be. [94.224.35.235])
        by smtp.gmail.com with ESMTPSA id z1sm825138ejw.52.2019.08.23.23.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 23:04:28 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     matthieu.baerts@tessares.net
Cc:     aprout@ll.mit.edu, cpaasch@apple.com, davem@davemloft.net,
        edumazet@google.com, gregkh@linuxfoundation.org,
        jonathan.lemon@gmail.com, jtl@netflix.com,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        ncardwell@google.com, sashal@kernel.org, stable@vger.kernel.org,
        tim.froidcoeur@tessares.net, ycheng@google.com,
        netdev@vger.kernel.org
Subject: [PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty retransmit queue
Date:   Sat, 24 Aug 2019 08:03:51 +0200
Message-Id: <20190824060351.3776-1-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <529376a4-cf63-f225-ce7c-4747e9966938@tessares.net>
References: <529376a4-cf63-f225-ce7c-4747e9966938@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8c3088f895a0 ("tcp: be more careful in tcp_fragment()")
triggers following stack trace:

[25244.848046] kernel BUG at ./include/linux/skbuff.h:1406!
[25244.859335] RIP: 0010:skb_queue_prev+0x9/0xc
[25244.888167] Call Trace:
[25244.889182]  <IRQ>
[25244.890001]  tcp_fragment+0x9c/0x2cf
[25244.891295]  tcp_write_xmit+0x68f/0x988
[25244.892732]  __tcp_push_pending_frames+0x3b/0xa0
[25244.894347]  tcp_data_snd_check+0x2a/0xc8
[25244.895775]  tcp_rcv_established+0x2a8/0x30d
[25244.897282]  tcp_v4_do_rcv+0xb2/0x158
[25244.898666]  tcp_v4_rcv+0x692/0x956
[25244.899959]  ip_local_deliver_finish+0xeb/0x169
[25244.901547]  __netif_receive_skb_core+0x51c/0x582
[25244.903193]  ? inet_gro_receive+0x239/0x247
[25244.904756]  netif_receive_skb_internal+0xab/0xc6
[25244.906395]  napi_gro_receive+0x8a/0xc0
[25244.907760]  receive_buf+0x9a1/0x9cd
[25244.909160]  ? load_balance+0x17a/0x7b7
[25244.910536]  ? vring_unmap_one+0x18/0x61
[25244.911932]  ? detach_buf+0x60/0xfa
[25244.913234]  virtnet_poll+0x128/0x1e1
[25244.914607]  net_rx_action+0x12a/0x2b1
[25244.915953]  __do_softirq+0x11c/0x26b
[25244.917269]  ? handle_irq_event+0x44/0x56
[25244.918695]  irq_exit+0x61/0xa0
[25244.919947]  do_IRQ+0x9d/0xbb
[25244.921065]  common_interrupt+0x85/0x85
[25244.922479]  </IRQ>

tcp_rtx_queue_tail() (called by tcp_fragment()) can call
tcp_write_queue_prev() on the first packet in the queue, which will trigger
the BUG in tcp_write_queue_prev(), because there is no previous packet.

This happens when the retransmit queue is empty, for example in case of a
zero window.

Patch is needed for 4.4, 4.9 and 4.14 stable branches.

Fixes: 8c3088f895a0 ("tcp: be more careful in tcp_fragment()")
Change-Id: I839bde7167ae59e2f7d916c913507372445765c5
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Christoph Paasch <cpaasch@apple.com>
---
 include/net/tcp.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9de2c8cdcc51..1e70ca75c8bf 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1705,6 +1705,10 @@ static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
 {
 	struct sk_buff *skb = tcp_send_head(sk);

+	/* empty retransmit queue, for example due to zero window */
+	if (skb == tcp_write_queue_head(sk))
+		return NULL;
+
 	return skb ? tcp_write_queue_prev(sk, skb) : tcp_write_queue_tail(sk);
 }

--
2.23.0


-- 


Disclaimer: https://www.tessares.net/mail-disclaimer/ 
<https://www.tessares.net/mail-disclaimer/>


