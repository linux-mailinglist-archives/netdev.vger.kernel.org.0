Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5011C64BB
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 02:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgEFABi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 20:01:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727895AbgEFABi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 20:01:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588723296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=uPy7LWjiZV38WzP4ia9r6qbCDanZ9+7jGEAYy844X1w=;
        b=VlfY3VSB+yU7MrhrErllB4x2dQZedCoCI4yxeH1J0855cOcq8tLrLUwI9+qIuNxKpqPfrK
        iz3snfPdr+uBH5MRVPaJh1hGbIPhhjq3m6+c0cQz9EyRpUSbajm2aQYTNyZ2GvzwVN3a+h
        BXDioIVv281GCzxPzqbRE1oBAdLpJVU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-EyKN1IgjO4eZYlrJ9gBrxQ-1; Tue, 05 May 2020 20:01:34 -0400
X-MC-Unique: EyKN1IgjO4eZYlrJ9gBrxQ-1
Received: by mail-wr1-f70.google.com with SMTP id s11so284935wru.6
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 17:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=uPy7LWjiZV38WzP4ia9r6qbCDanZ9+7jGEAYy844X1w=;
        b=lfFaZYDelnEw4VsMs4gOG9CPjXjI0h7GdFABff6dlmngtK7B+rlxIcUc9daBxNYk20
         Mm/J+RVSmyrZthXltfSe/IVZRtR4kgclJPY+Cd15tcfsqG83/Ivf4Kfq1KqzqWRJH7CL
         2dwmMBYywYXIRQ0FPj3cJc4R3k8jwCJ4a7L4eYGOz06dMowmsES7YF0H9gtOIacFej5c
         ALGQ3HCHS1TYHL2aEYU2pi8WD/9as2bzNAxFwb4sM5TufpyGdcAd1tTIRvijF+BafTD2
         Ifh4Cfyy4HzOVBR/+OjqWRalmFwQUZbNkg5wsflAdz3Y8gJkxPLF+VcaN3abmjoYmC9J
         Rzhg==
X-Gm-Message-State: AGi0PuY7YLm8DBHcuYfY0WNUZcHxS1g5yy83m13jgWjTMgQjn8xm1ZhA
        /O2Irf536zOw2Ud5Ez30jege1pu/ntuQO2rrv/MpLA5V98gMkQmZbxmFUdTxNoq4Scq/yKQuyjM
        gI0TnQyBeJKaN4tLh
X-Received: by 2002:a1c:668a:: with SMTP id a132mr1374910wmc.46.1588723293809;
        Tue, 05 May 2020 17:01:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ8RYGHvYZzJ/QpEX2WdgeFSAVsMNA2jw0S7Y/1PxVtp3/Bj3PJc6VuKrGHjyReVPI+0wkbBw==
X-Received: by 2002:a1c:668a:: with SMTP id a132mr1374894wmc.46.1588723293612;
        Tue, 05 May 2020 17:01:33 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id n7sm447wrm.86.2020.05.05.17.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 17:01:32 -0700 (PDT)
Date:   Tue, 5 May 2020 20:01:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] virtio_net: fix lockdep warning on 32 bit
Message-ID: <20200506000006.196646-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we fill up a receive VQ, try_fill_recv currently tries to count
kicks using a 64 bit stats counter. Turns out, on a 32 bit kernel that
uses a seqcount. sequence counts are "lock" constructs where you need to
make sure that writers are serialized.

In turn, this means that we mustn't run two try_fill_recv concurrently.
Which of course we don't. We do run try_fill_recv sometimes from a fully
preemptible context and sometimes from a softirq (napi) context.

However, when it comes to the seqcount, lockdep is trying to enforce
the rule that the same lock isn't accessed from preemptible
and softirq context. This causes a false-positive warning:

WARNING: inconsistent lock state
...
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.

As a work around, shut down the warning by switching
to u64_stats_update_begin_irqsave - that works by disabling
interrupts on 32 bit only, is a NOP on 64 bit.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

I'm not thrilled about this but this seems the best we can do for now.

Completely untested.


Thomas, can you pls let me know the config I need to trigger the warning
in question?


 drivers/net/virtio_net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 6594aab4910e..95393b61187f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1243,9 +1243,11 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
 			break;
 	} while (rq->vq->num_free);
 	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
-		u64_stats_update_begin(&rq->stats.syncp);
+		unsigned long flags;
+
+		flags = u64_stats_update_begin_irqsave(&rq->stats.syncp);
 		rq->stats.kicks++;
-		u64_stats_update_end(&rq->stats.syncp);
+		u64_stats_update_end_irqrestore(&rq->stats.syncp);
 	}
 
 	return !oom;
-- 
MST

