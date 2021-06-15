Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2BC3A838C
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 17:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhFOPGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 11:06:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59557 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231311AbhFOPGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 11:06:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623769467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nZyBRJPoB1j5/g6EWUWSPPNl7ozTkFFFt8p6irUhI/M=;
        b=DuKb4ZAv55LI5PWv3k3xbZMN3oEaVoTx6K2D7R56EcdkIIAyW8uWtZp6TmEBENBkCy4mcf
        5xryy5tloNrs7ct6lwj+uIOsT8EX3DuiIq/kYVV8YmXJsssKWFiu8qwQZGC4/wVvY9icfw
        bYI6nsjTT7MjTj2oyuEHOx4EX5VbWXo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-oBOgQghXNAGwGqR8PYz-oQ-1; Tue, 15 Jun 2021 11:04:25 -0400
X-MC-Unique: oBOgQghXNAGwGqR8PYz-oQ-1
Received: by mail-ed1-f70.google.com with SMTP id q7-20020aa7cc070000b029038f59dab1c5so22543642edt.23
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 08:04:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nZyBRJPoB1j5/g6EWUWSPPNl7ozTkFFFt8p6irUhI/M=;
        b=b0Tl58LAQCaiPln2kI/p4TPxZRcnZ6+F/xqQtd4UMvm9qXqqnETQxUqsqip8Uhiq1s
         fAK5qfBx4hI6xSs6iaofwIYCHMOheJ+O0K87IYC4BgiI4UjXrgBIGxgU+UUJZ88xg9JL
         nAPL7eeu5Lu6V6R3j7P/+H71SJoaVPqHp9fVx/jpCYb4Cn7Kk9I0SYMkS4WUvRaK7bii
         oA+pqvJ60BudFM9/15xm8C/MFKdDvv+q/yBO9LKbMDryP5JWqF5FCV0GtBhk+UO5iLuB
         cbSdhwoRG6PMrY6VcxyrCCqju3pu3UdLmyQr5mTUiOG14w/W0O/0W7VFGKU/uqrwSPFi
         RyDg==
X-Gm-Message-State: AOAM5330rnhCGyiFVTBMALDC/mkaH3vPbA1E6lCwfDOZaEWk9sCXCYbB
        4Wol5Wb1mOt5xTBEkhm56sXsCNb3YCEc66RGLWgLjC39OwYqxb7NqNHsEx+HkgyMp3iYKCSG4d8
        MhhIhehfwxKt9MZA5
X-Received: by 2002:a50:fb8f:: with SMTP id e15mr23315229edq.46.1623769464512;
        Tue, 15 Jun 2021 08:04:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytWmHoc5NSv2Ml6IB/zXKszT4ABcEjPhTM0+V3qJGdbm2cn7dpYji1+8/ONPwzQWZqoX25Dg==
X-Received: by 2002:a50:fb8f:: with SMTP id e15mr23315193edq.46.1623769464293;
        Tue, 15 Jun 2021 08:04:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u21sm7514919eja.59.2021.06.15.08.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:04:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1744F180736; Tue, 15 Jun 2021 16:54:59 +0200 (CEST)
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
Subject: [PATCH bpf-next v2 13/16] sfc: remove rcu_read_lock() around XDP program invocation
Date:   Tue, 15 Jun 2021 16:54:52 +0200
Message-Id: <20210615145455.564037-14-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615145455.564037-1-toke@redhat.com>
References: <20210615145455.564037-1-toke@redhat.com>
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
 drivers/net/ethernet/sfc/rx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 17b8119c48e5..3e5b88ab42db 100644
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
@@ -295,8 +291,10 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	xdp_prepare_buff(&xdp, *ehp - EFX_XDP_HEADROOM, EFX_XDP_HEADROOM,
 			 rx_buf->len, false);
 
+	/* This code is invoked within a single NAPI poll cycle and thus under
+	 * local_bh_disable(), which provides the needed RCU protection.
+	 */
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
-	rcu_read_unlock();
 
 	offset = (u8 *)xdp.data - *ehp;
 
-- 
2.31.1

