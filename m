Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7211C8369
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 09:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgEGH0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 03:26:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725819AbgEGH0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 03:26:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588836362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=MNb3P1C6nMcjTzE7KOYMh3f2/+8YEUojREhYLpZKIq8=;
        b=TlMmaSzlTVXqSjyVpNHFNC2I7JHK2Qv8j+I0rET8FGF+tR+m61lCrnU3n0WDNBZa/YyCyQ
        v8ssbTzlsbBtY9KAnu7i0lDdoPTCWr10eiM+Ye7nWpuw7ZLqWSY+Z43L8IxtTne8iAfjUU
        yPaN5jChX3I1ciTY4tzCSH3V6+1EoN0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-MpGph4QpOV2obFssR5Y_3A-1; Thu, 07 May 2020 03:26:00 -0400
X-MC-Unique: MpGph4QpOV2obFssR5Y_3A-1
Received: by mail-wr1-f71.google.com with SMTP id h12so2862212wrr.19
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 00:26:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=MNb3P1C6nMcjTzE7KOYMh3f2/+8YEUojREhYLpZKIq8=;
        b=ipgY0Nydu9/SWRdW65bxJX1+e9p7Jh7uUW+HaVfzTj/QyG4U3FvkM+qEDjMq2eFtpd
         KwcpiXENZPgGV0QO5fckd9KdZy+7+YmL51IEAeq24tWGFj7kLpbd713RpAOalFyg0lob
         OM4AtTS7ekp6eroUEicBIzM4kLrcViteYRJhTW5ItL2FZ1jivUN27ODFI5pznGDHh1OZ
         2RTBddb/D0hqr5xS1yGklPprmGcO/U5e37tjdYstSKEI//rpiojVrWnnsUVd/HZD4UR7
         yF5ZKs2N6/SGOmhWbySdfGLnrk8R6vqQS1WBTWEjptRHx6olXAtkFkvSCY/GgpOIocux
         xXsA==
X-Gm-Message-State: AGi0Pub4N7KLVn7m9Qb2uCxeiiuCC+MUFl0fIZAZ+QX4QH/3rNlkI3XA
        EclsdYW4ZTmnXBZ3GDWF1Wns4VwQH2m+wM7QYxc5fT2Do+Gp+W+qF3ql3fANFnfa9owyaraV5C2
        vBjDeaNvmgZiQWXjc
X-Received: by 2002:adf:e9d0:: with SMTP id l16mr3446589wrn.69.1588836359015;
        Thu, 07 May 2020 00:25:59 -0700 (PDT)
X-Google-Smtp-Source: APiQypK3v4r+fkltKyHrOlH+oryMeYYEXo3bj8rv8XDyVYT7v3qL9oDVeAXDdb2dOeLpaZveqKy4Yg==
X-Received: by 2002:adf:e9d0:: with SMTP id l16mr3446572wrn.69.1588836358811;
        Thu, 07 May 2020 00:25:58 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id s18sm7318969wra.94.2020.05.07.00.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 00:25:58 -0700 (PDT)
Date:   Thu, 7 May 2020 03:25:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v2] virtio_net: fix lockdep warning on 32 bit
Message-ID: <20200507072525.355222-1-mst@redhat.com>
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
Which of course we don't. We do run try_fill_recv sometimes from a
softirq napi context, and sometimes from a fully preemptible context,
but the later always runs with napi disabled.

However, when it comes to the seqcount, lockdep is trying to enforce the
rule that the same lock isn't accessed from preemptible and softirq
context - it doesn't know about napi being enabled/disabled. This causes
a false-positive warning:

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

changes from v1:
	builds now. lightly tested

 drivers/net/virtio_net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 11f722460513..ce07f52d89e7 100644
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
+		u64_stats_update_end_irqrestore(&rq->stats.syncp, flags);
 	}
 
 	return !oom;
-- 
MST

