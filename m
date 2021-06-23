Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290C23B1885
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhFWLKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:10:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21888 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhFWLJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:09:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yDyNUpCpBTNbFxDC2WQuaaPWytT5QLCtZC1t66JXAlk=;
        b=HghLPu/6cLfRJgCvUyZzMOADyhneoMvrhonyjKx80rLTAMV6oU+GkJXwUsfia9QAri9Z0C
        elBNp6vGPEVoBoHgMMTHGVC0lcOAgCfkUqn6yE5YnkG4nTcsfDWn3PPBLnyMlPNJghQysu
        WhkjVVhuTq/GLcdXO5n3tktchYQfeDA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-zZI-8p0ONi6z11oObLh7Ag-1; Wed, 23 Jun 2021 07:07:40 -0400
X-MC-Unique: zZI-8p0ONi6z11oObLh7Ag-1
Received: by mail-ed1-f69.google.com with SMTP id w1-20020a0564022681b0290394cedd8a6aso1089883edd.14
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yDyNUpCpBTNbFxDC2WQuaaPWytT5QLCtZC1t66JXAlk=;
        b=eWs/sdp02CUYmC9JLmGhmAna/8F08jD0Hm2D8p6B1ZEwbN6TK6MH5hfmJDYToYyfY7
         aNYh7kT0H3v7swvJ3Lsl0YK2kaJZB5o9qLkmHMEIKJk08VFOOdH8lx/S7zx6CPEs+ymP
         jEeARxWuTQvGF9Ho32YXF/QeE9qovB/7lOiw0aHld6nsU4cIYA0HU1MJZvUg38pIX4iu
         CZitUuXfTRUy+RQw6Z25xv0eqUedbVl/2w3AYlm3BMkSmc6y1cbogAUYPqhbV0ivD7uG
         t/qz78wz25P2in0Cm8dFsUbQsWHmaVETgFrh18liSYwd4mJv0ecEYdIODSK5T+NyX5oJ
         XOyQ==
X-Gm-Message-State: AOAM533KwBx7r2hmNlrhwiStV507pqcKiIJ57277/2h0CZvS+cQz/qR3
        8cYg0iDDZlEsCUtjhfKN17zPdpB4aY3sPGXG2f9931MJyhnE3f39SodK/8yIe1iZmL0iqQfQw5H
        4MuhqC8pu4O2ju03w
X-Received: by 2002:a17:906:841a:: with SMTP id n26mr9052469ejx.430.1624446458601;
        Wed, 23 Jun 2021 04:07:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiCn+E0GqnflDNDr2cZUSBElhE9Z+SzSMhk9zf2y/FqN45sosWDLQuM6WRitS6qMnDZWcnwQ==
X-Received: by 2002:a17:906:841a:: with SMTP id n26mr9052436ejx.430.1624446458285;
        Wed, 23 Jun 2021 04:07:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j19sm3767903ejo.3.2021.06.23.04.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:07:37 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 804F0180741; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH bpf-next v4 17/19] netsec: remove rcu_read_lock() around XDP program invocation
Date:   Wed, 23 Jun 2021 13:07:25 +0200
Message-Id: <20210623110727.221922-18-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netsec driver has a rcu_read_lock()/rcu_read_unlock() pair around the
full RX loop, covering everything up to and including xdp_do_flush(). This
is actually the correct behaviour, but because it all happens in a single
NAPI poll cycle (and thus under local_bh_disable()), it is also technically
redundant.

With the addition of RCU annotations to the XDP_REDIRECT map types that
take bh execution into account, lockdep even understands this to be safe,
so there's really no reason to keep the rcu_read_lock() around anymore, so
let's just remove it.

Cc: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/socionext/netsec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index dfc85cc68173..20d148c019d8 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -958,7 +958,6 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 
 	xdp_init_buff(&xdp, PAGE_SIZE, &dring->xdp_rxq);
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(priv->xdp_prog);
 	dma_dir = page_pool_get_dma_dir(dring->page_pool);
 
@@ -1069,8 +1068,6 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 	}
 	netsec_finalize_xdp_rx(priv, xdp_act, xdp_xmit);
 
-	rcu_read_unlock();
-
 	return done;
 }
 
-- 
2.32.0

