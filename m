Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801043B33A0
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhFXQQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:16:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229525AbhFXQQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:16:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624551234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yDyNUpCpBTNbFxDC2WQuaaPWytT5QLCtZC1t66JXAlk=;
        b=JfxWsaCs22FzY1pLsCJjrbzP7oF3+E2SSiq2gLzrag15uHro/eMFaXyVu8n8LrV0m9FP9b
        iFnS5BD3EwdeDeLrj24NlaZQn+SkmuPXw/6h4Esj3fMB06AzYMlC3wpPSWHE0N5BL9SP9q
        0b3fg/Ra9LVb6klSDCJGUw1ENNgXbqc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-wEX3OvfsM2aQUUsVJmYf-A-1; Thu, 24 Jun 2021 12:13:53 -0400
X-MC-Unique: wEX3OvfsM2aQUUsVJmYf-A-1
Received: by mail-ed1-f69.google.com with SMTP id h11-20020a50ed8b0000b02903947b9ca1f3so3628168edr.7
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yDyNUpCpBTNbFxDC2WQuaaPWytT5QLCtZC1t66JXAlk=;
        b=q3RwKhEclBCQpZeceFqJHmgPbCzmCQoxrdgvwmqaD3zjDo2t10tyWyawMhwdYW+JmL
         MpszTzjKmE2dhyAHlS4h1mMQBTCWXG3TAWYrxYi8HwjXvbjxlwQvt7sykrIR9xOy7K68
         BaULMCDRh8WtH9q7+/54YznXMZiy4xpIiyBKUJYRVppRdMWNXGME6j1ZizEGGhlbAzx+
         B9gCw+JqJBlC86rl6fHUhQl3oZDHCFBmeP2Kn1tEml05oRBPrzfWbnQv1WMUctrEmEUy
         jgUnfi/hZBhpX9bcP9ji11XnT4ZwMuhbi5na24x+AnLlPP/aq04cCRWJ9kLUjoxyE4ri
         nJpQ==
X-Gm-Message-State: AOAM530DUDa+rn43eVe8b5IvsoaVQ4nIqQl5kymGTTQjZlj8iaZDWV9t
        kjJdDgrvyrZTPA/Rz7JoB25cF51DzxpvxU4VorTq7vJ+owKVHaZ5AIq9Dq/ZPb7Z1iVjyP8OnDq
        F1Cvmcp5V5kKl3xAo
X-Received: by 2002:a17:906:528b:: with SMTP id c11mr6149364ejm.156.1624551232255;
        Thu, 24 Jun 2021 09:13:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmiy/R1V/yo+psYvdlKpfKYxOjFaoS5khi6mncmtsUTrJsrGvD/i4IhsMzsu6FIJJ29TNGlw==
X-Received: by 2002:a17:906:528b:: with SMTP id c11mr6149341ejm.156.1624551231979;
        Thu, 24 Jun 2021 09:13:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w10sm2246691edv.34.2021.06.24.09.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:13:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B294B180742; Thu, 24 Jun 2021 18:06:10 +0200 (CEST)
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
Subject: [PATCH bpf-next v5 17/19] netsec: remove rcu_read_lock() around XDP program invocation
Date:   Thu, 24 Jun 2021 18:06:07 +0200
Message-Id: <20210624160609.292325-18-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624160609.292325-1-toke@redhat.com>
References: <20210624160609.292325-1-toke@redhat.com>
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

