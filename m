Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AEA3B18A2
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFWLQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:16:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230286AbhFWLQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZRUA/Y9lIwzUgTw5uRoa39eJ4yIyIch6xpJH66I9Qdc=;
        b=GwDinBErv5wJKP4y4NTW/bHXFy0yBYewemOyr1eva2xHMFEBfPIb8DKEOHLo0gz5yeYrEI
        LxNlw7x6XB2td7GryvfhYOjvt7KdBg0qk0LkLxw0E6vbFtZYC60ZoJHpPTTWPgRUuLN7e6
        3DTzSJEF1sW9RpcV4JfiOycKPOoLa/w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-pM7iJNsZOxGjBg3sNlPFNQ-1; Wed, 23 Jun 2021 07:13:43 -0400
X-MC-Unique: pM7iJNsZOxGjBg3sNlPFNQ-1
Received: by mail-ed1-f69.google.com with SMTP id m4-20020a0564024304b0290394d27742e4so1105700edc.10
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:13:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZRUA/Y9lIwzUgTw5uRoa39eJ4yIyIch6xpJH66I9Qdc=;
        b=Zg3cLQuDe4LJ9hzHmm5Od8I3n7jtruhlWH2HggZjJIWeC5D0Eavi83lq1wLpTLQsBY
         qpJhGPdpAz4Yd3Hga7+NaGRwRQuS2/yPjyTK8wXH7HgaRQJZ0IPsMj72jB2wy3qMwbUP
         12yCxAIdV9L1wZC7jT7DPmzd3Em/xoz9dLnxEPChEfOA9zNzKjsT0ZE6iNwVdCogpCrP
         A7a7tJ1IcsBtM6ovguY114pO8pcj4IN6YV1FUV+oYrqwIKboWhIit8CkXu8sg8Y+vaXb
         cuz0Rwc6igqPbUtZfr/jrmr6tL+Rt3s9ilXRe8cSyygFFabQ3dH0oRGc5W9SRX13bbNC
         Z1JQ==
X-Gm-Message-State: AOAM531EIE3mU495WkBibrHUv/YBFq8q0WTCfQrqatJzNl5TEuuP2llq
        Uvjgri+pZ2rVx5MsmzEMAKEai+FlhXnbIlnrrwZqUfFzOEtRF+Lcsy+qIx5HZqCPaWhfMaalpZm
        Pdg5dTKi75ZUM2TX3
X-Received: by 2002:a17:906:34cf:: with SMTP id h15mr9261311ejb.526.1624446821842;
        Wed, 23 Jun 2021 04:13:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNBQa0CtVLyqSCtU7E+yLdrrdnxdFKoAi4uPGzq58jwGDY1F5UViDRBybswKmPs7D4pY6M7Q==
X-Received: by 2002:a17:906:34cf:: with SMTP id h15mr9261282ejb.526.1624446821485;
        Wed, 23 Jun 2021 04:13:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id ml14sm3124574ejb.27.2021.06.23.04.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:13:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6C06218073F; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com
Subject: [PATCH bpf-next v4 15/19] qede: remove rcu_read_lock() around XDP program invocation
Date:   Wed, 23 Jun 2021 13:07:23 +0200
Message-Id: <20210623110727.221922-16-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qede driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
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

Cc: Ariel Elior <aelior@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 8e150dd4f899..065e9004598e 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1089,13 +1089,7 @@ static bool qede_rx_xdp(struct qede_dev *edev,
 	xdp_prepare_buff(&xdp, page_address(bd->data), *data_offset,
 			 *len, false);
 
-	/* Queues always have a full reset currently, so for the time
-	 * being until there's atomic program replace just mark read
-	 * side for map helpers.
-	 */
-	rcu_read_lock();
 	act = bpf_prog_run_xdp(prog, &xdp);
-	rcu_read_unlock();
 
 	/* Recalculate, as XDP might have changed the headers */
 	*data_offset = xdp.data - xdp.data_hard_start;
-- 
2.32.0

