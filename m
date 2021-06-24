Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D656B3B33A9
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhFXQQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:16:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230040AbhFXQQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:16:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624551236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cOyh19f+n3Klc9n0Uf50USUZ/OAvnTAcZiRzl4mD+JA=;
        b=QaAx30BLq9Xssu3dc4tRGB973dg9f2LXLDQ4OizivXQLvyFdPc+SHQqwvB01xWAiQxuARQ
        OS/VzA3jhKRpw0+na41G5nP9huDZlFU2YReb0imClaw8jRSU6BLSmoQWfqvjvvp4ZnxXKj
        WXLepa65qi1SYJaVy0y4KhSa0jyPI+0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-4zRlfLC3PeW9gYPisz1ARw-1; Thu, 24 Jun 2021 12:13:55 -0400
X-MC-Unique: 4zRlfLC3PeW9gYPisz1ARw-1
Received: by mail-ej1-f69.google.com with SMTP id lt4-20020a170906fa84b0290481535542e3so2199450ejb.18
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:13:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cOyh19f+n3Klc9n0Uf50USUZ/OAvnTAcZiRzl4mD+JA=;
        b=FZTA7Bxr/IaFtjdoKOSt+ekoMTk9bu+aM+LnBSUrmEmv8FOwg9oM3Zb/yAYyMwWSLn
         FJg85i2fBP4P+QAMdEbqS62CfrMUYXfszrriL2K5KvWZvFvjnmwPqlNicGS/JQBUw9LK
         7tfNXndvoRtbv9CplPwNTLKWha++W33YQf1CUv44z8QKlmWNvQ/RPN/wS72M37ISSpsL
         7uEP+swyXmZRpXVEJSrmuSGdQFRqRAsM0U3Th4wCj/GRWxhEAtHGUbNHGFAWVruoxyga
         MA1PuwXupPs43zoPnX6M661Oq4mpqBHTuChjHAQmYnOcB2Elxmsoi5rTegumvRxqVUUx
         MHJg==
X-Gm-Message-State: AOAM533pH5UM3P1uU0asl+rOWSt72qe9g08wLC3Bw/z9FlnJauJEpdsp
        ULeI7IWPUQngqpRx0AYaw9oTw4LaZZAZAYhs/D+E1pT5NVXVa3k0KpPja+b35sSBf2zcoliEKTa
        tXSd5QnIFeUBNKy3I
X-Received: by 2002:aa7:dc0d:: with SMTP id b13mr8086192edu.288.1624551234002;
        Thu, 24 Jun 2021 09:13:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwO83p9KKeIz6WYXSUxDTv54YrbHmZN8vEVgN4NSgGIUd/3XQocFyAZ4VFu9V7EzZ2au7ZN8g==
X-Received: by 2002:aa7:dc0d:: with SMTP id b13mr8086172edu.288.1624551233868;
        Thu, 24 Jun 2021 09:13:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d2sm1433158ejo.13.2021.06.24.09.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:13:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AC1B8180741; Thu, 24 Jun 2021 18:06:10 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH bpf-next v5 16/19] sfc: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 24 Jun 2021 18:06:06 +0200
Message-Id: <20210624160609.292325-17-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624160609.292325-1-toke@redhat.com>
References: <20210624160609.292325-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sfc driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
program invocations. However, the actual lifetime of the objects referred
by the XDP program invocation is longer, all the way through to the call to
xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
turns out to be harmless because it all happens in a single NAPI poll
cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
misleading.

Rather than extend the scope of the rcu_read_lock(), just get rid of it
entirely. With the addition of RCU annotations to the XDP_REDIRECT map
types that take bh execution into account, lockdep even understands this to
be safe, so there's really no reason to keep it around.

Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/sfc/rx.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 17b8119c48e5..606750938b89 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -260,18 +260,14 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	s16 offset;
 	int err;
 
-	rcu_read_lock();
-	xdp_prog = rcu_dereference(efx->xdp_prog);
-	if (!xdp_prog) {
-		rcu_read_unlock();
+	xdp_prog = rcu_dereference_bh(efx->xdp_prog);
+	if (!xdp_prog)
 		return true;
-	}
 
 	rx_queue = efx_channel_get_rx_queue(channel);
 
 	if (unlikely(channel->rx_pkt_n_frags > 1)) {
 		/* We can't do XDP on fragmented packets - drop. */
-		rcu_read_unlock();
 		efx_free_rx_buffers(rx_queue, rx_buf,
 				    channel->rx_pkt_n_frags);
 		if (net_ratelimit())
@@ -296,7 +292,6 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 			 rx_buf->len, false);
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
-	rcu_read_unlock();
 
 	offset = (u8 *)xdp.data - *ehp;
 
-- 
2.32.0

