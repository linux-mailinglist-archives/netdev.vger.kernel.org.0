Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F733A1153
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbhFIKkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:40:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23055 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238481AbhFIKkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623235127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fbz4hNWvQ8PWHu2W2MZOy7/gDDHCdFCTVBAhydE+f+U=;
        b=d0KHZyXu/rUrTirwBwL+icr0SGViqpPEfHAqoE1F/snqvwjmGOKzGIR73sWvcrUTPd6fmn
        mlY2rCL2kH7RuZoHjiSJ7rL3viTW6MkSTzy21xnLkB3iRSuhKI8H2E5PapDtM9siOpFHS2
        CZMkyCtiAWSBvtQsXnxlyMW90PGZEKg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-w5ECZ5B6OF6-aL3a_QhUuA-1; Wed, 09 Jun 2021 06:38:45 -0400
X-MC-Unique: w5ECZ5B6OF6-aL3a_QhUuA-1
Received: by mail-ej1-f71.google.com with SMTP id b10-20020a170906194ab02903ea7d084cd3so7854806eje.1
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:38:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fbz4hNWvQ8PWHu2W2MZOy7/gDDHCdFCTVBAhydE+f+U=;
        b=T66a34uktx7y5+FH5g/nC0kj9/hQ0+H8NBG1AMOCSMcefqFYrlqboNbFk1h3EL33Xp
         rKxl8E1MBLMuMqNdfESN8YQIpFEMiPEJEHBb7i/jIQ9gYLV5pK/cvBhvPt9WT4IYXfBQ
         NXsaxz+LHst4iLFQo3+K4+D5q8GGN/HdpU/iMb0qS5ppvTmR+JlPlHb9kw1w3nW/YSpc
         avqCBHjUzDxvJuGDxpnPt/MZ33gYOiyC3s5aoYNQC22C24nc1hmloxpgBkEFOd2ctXin
         1KjNsX2/GvH6mX7Zv48ZlS4zNKNqX932mYttQziFPURdHTfCWHN5zO8hy5Xt1Aca3KFy
         y7xQ==
X-Gm-Message-State: AOAM533DmZGdy9Rd5cbtzERrKWIJbXXqVtwi1/BTbArPq7PTC6avVB6I
        nWknhIWivDuQLCNJHniQ9KDIzqBKf65rfMZ20/XcuXy/pR54i7KBJl9EFaIhqJpdrojtnuniBvN
        xBIIKIObnG9vONLRj
X-Received: by 2002:a17:906:869a:: with SMTP id g26mr27319304ejx.94.1623235124592;
        Wed, 09 Jun 2021 03:38:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwm+3mBcadPMLcwFavHgtOiY5Hjn0DBjRErakIm0gzowEegpnSOcGNewwLjLGNQf5IFEnMNOw==
X-Received: by 2002:a17:906:869a:: with SMTP id g26mr27319296ejx.94.1623235124461;
        Wed, 09 Jun 2021 03:38:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id dh18sm966979edb.92.2021.06.09.03.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 03:38:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D4A32180731; Wed,  9 Jun 2021 12:33:30 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com
Subject: [PATCH bpf-next 13/17] qede: remove rcu_read_lock() around XDP program invocation
Date:   Wed,  9 Jun 2021 12:33:22 +0200
Message-Id: <20210609103326.278782-14-toke@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609103326.278782-1-toke@redhat.com>
References: <20210609103326.278782-1-toke@redhat.com>
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
2.31.1

