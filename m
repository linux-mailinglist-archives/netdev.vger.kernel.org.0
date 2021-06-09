Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966383A1128
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238867AbhFIKfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:35:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59580 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238911AbhFIKfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623234818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I6RFVrIlNJV4mNL6ANvqt/Qw3/Fb8/fimwbEL77gRdY=;
        b=U3yor96ClRYTS854rKiFVnIzXZ23EpLD+hDM2U3zQrc9iSiTpYfmjobnYc+IbzoUQ3XJoT
        +Ln7j96JuXvyNcMM8tbb2NN5LQY9Jh8bQv8JDOIxch1M2TuOZAEM8maYfNfhugu478j1S1
        IfLVyYr4LLI477Gr36MIH96n657JjLI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-LtQD2_jXPymmaDCvxSJi1Q-1; Wed, 09 Jun 2021 06:33:35 -0400
X-MC-Unique: LtQD2_jXPymmaDCvxSJi1Q-1
Received: by mail-ej1-f69.google.com with SMTP id e11-20020a170906080bb02903f9c27ad9f5so7817111ejd.6
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I6RFVrIlNJV4mNL6ANvqt/Qw3/Fb8/fimwbEL77gRdY=;
        b=iOSFQpZZ5qB42ZE1h0c4jg2FyMERULyOHf9QGmknsQw7EANY0yZPy0wlrRZ4AqYuEr
         CRY19beO7YV2bOmV3YUP5XH5N2FFludNntgWRTFCMDkYzcYuG2G0T88oMia+FuwJeUKt
         WMIeYkO/az/3xVtAeZyYNn98NDk5aVr/XpZsTbh86IVCsINd7CvreRoky59h8RUXjixL
         q9I8kdfFwFozLgJtYukQfhSuwapZJU1lb+EVmVym4SYuuXeb2+TXCnmUwYPRYM7kXPXW
         eQoukXKBOFrwQ+PQ3WFQUliPoFkZleHYjBGjiIy7kdq/i4CTEugbWEa/doSPQ9Yq8FwR
         7KQg==
X-Gm-Message-State: AOAM531zqSqF1yRhlYnoA4SYyNe25meXNZny9cZBo59BJArzVFwiQcmR
        VlZTVM5H/DAcRBnSc64uQPQVUw/0lXn/zHNPkNKv3ZpeV39ScITft5DHFAjfIyOwZmoeOa55MIu
        LwlkCEzOnx1lWDjGJ
X-Received: by 2002:a17:906:1792:: with SMTP id t18mr16230745eje.38.1623234814355;
        Wed, 09 Jun 2021 03:33:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSS/+KNKnXT0QQpuEWI8iYGTn6gTZHYpHRtIhPO3wIfSXPTo2W2Il/Qh2CqA4beAkAqr+45A==
X-Received: by 2002:a17:906:1792:: with SMTP id t18mr16230736eje.38.1623234814221;
        Wed, 09 Jun 2021 03:33:34 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id cx7sm967596edb.65.2021.06.09.03.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:33:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7FE50180729; Wed,  9 Jun 2021 12:33:30 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>
Subject: [PATCH bpf-next 05/17] ena: remove rcu_read_lock() around XDP program invocation
Date:   Wed,  9 Jun 2021 12:33:14 +0200
Message-Id: <20210609103326.278782-6-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609103326.278782-1-toke@redhat.com>
References: <20210609103326.278782-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ena driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
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

Cc: Guy Tzalik <gtzalik@amazon.com>
Cc: Saeed Bishara <saeedb@amazon.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 881f88754bf6..a4378b14af4c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -385,7 +385,6 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	u64 *xdp_stat;
 	int qid;
 
-	rcu_read_lock();
 	xdp_prog = READ_ONCE(rx_ring->xdp_bpf_prog);
 
 	if (!xdp_prog)
@@ -443,8 +442,6 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 
 	ena_increase_stat(xdp_stat, 1, &rx_ring->syncp);
 out:
-	rcu_read_unlock();
-
 	return verdict;
 }
 
-- 
2.31.1

