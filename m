Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7C719EEE3
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 02:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgDFAQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 20:16:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44960 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbgDFAQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 20:16:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id m17so15284771wrw.11;
        Sun, 05 Apr 2020 17:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FvMvQjpl3mBryOKnAJVIyuL3RVW4h7gov14bS75FPXw=;
        b=axToHqAOIoUW0tPCyPuw3kbwg+yxpmxuRs14EhH2H9LOXll04vRfBWWefKvv1mv3iK
         p9qmgBefhF/WhX2V6ehkGx2pws6u3Q8E4DfQ7ljlaEWVZBZHujGmRN592sjuq8NceZOR
         x6LSN/tyWbZBa4llilQohu4V7DpAp6bAsgI8CDLeSKscpcuZ33Ik94FJjltx67Bpvx+U
         TNFyfso74w67dnugOYpkzBk8IDwyAkpmgWM3JgZxnzc7/WUUqDaAADpz2zTh/m6iijz0
         zSUkbD9m2pz95T+Gooy7TswRBjnkGuIwXzO3EHIAEoSGw4ljVW4oJX23UJ+IMBORmzmW
         Vk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FvMvQjpl3mBryOKnAJVIyuL3RVW4h7gov14bS75FPXw=;
        b=GtyyrTzd0Snn5NSLJ1vuO9av4EtJxH6v8XXi6vGKB8l4nCMOP+4e5iGqnnaCwBxL+5
         bXuCPPYlwFg5dS2qll1Jn4iJQW0O90cbfqwpVxKs7S55QKYYaHNndcOKWMZJ8OudRkcD
         e2ISRiPCvoSWE7bNJvKJdvrrlIQSGKFk4k+hJn4qaOlVmRILkmQgB18g533C9qCuvrSk
         Xe+/F0ppKVBuCInXcJgQr1eBl4h/19dJsPfQroy76NT6KMX5psmORLtjPjeH6hLfN7il
         965kkauf5AGrfeWq0y0qTNPwgWTl1+H3waVygr71ZN9+QGoC0prMRFR4c8XmAG+i/Toe
         as7Q==
X-Gm-Message-State: AGi0Pub29Xfh5/YbwBcIOvN4RgG3RwAfuZvJGSccHqPCE69j2vaBV10d
        SvPAKFWt6cDiO0XyKGdwoaxtrdcfOV0eZA==
X-Google-Smtp-Source: APiQypK3XzE+6NIr8zjtUViz/a9SkhUeZK56DNz+xwEsJe995dzNDz2TX+wPuV7ulrdX0U7xICpdUQ==
X-Received: by 2002:adf:e445:: with SMTP id t5mr21431205wrm.352.1586132207027;
        Sun, 05 Apr 2020 17:16:47 -0700 (PDT)
Received: from andrea.corp.microsoft.com ([86.61.236.197])
        by smtp.gmail.com with ESMTPSA id j9sm817432wrn.59.2020.04.05.17.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 17:16:46 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 04/11] hv_netvsc: Disable NAPI before closing the VMBus channel
Date:   Mon,  6 Apr 2020 02:15:07 +0200
Message-Id: <20200406001514.19876-5-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200406001514.19876-1-parri.andrea@gmail.com>
References: <20200406001514.19876-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vmbus_chan_sched() might call the netvsc driver callback function that
ends up scheduling NAPI work.  This "work" can access the channel ring
buffer, so we must ensure that any such work is completed and that the
ring buffer is no longer being accessed before freeing the ring buffer
data structure in the channel closure path.  To this end, disable NAPI
before calling vmbus_close() in netvsc_device_remove().

Suggested-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>
---
 drivers/hv/channel.c        | 6 ++++++
 drivers/net/hyperv/netvsc.c | 7 +++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 23f358cb7f494..256ee90c74460 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -609,6 +609,12 @@ void vmbus_reset_channel_cb(struct vmbus_channel *channel)
 	 * the former is accessing channel->inbound.ring_buffer, the latter
 	 * could be freeing the ring_buffer pages, so here we must stop it
 	 * first.
+	 *
+	 * vmbus_chan_sched() might call the netvsc driver callback function
+	 * that ends up scheduling NAPI work that accesses the ring buffer.
+	 * At this point, we have to ensure that any such work is completed
+	 * and that the channel ring buffer is no longer being accessed, cf.
+	 * the calls to napi_disable() in netvsc_device_remove().
 	 */
 	tasklet_disable(&channel->callback_event);
 
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 1b320bcf150a4..806cc85d10033 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -635,9 +635,12 @@ void netvsc_device_remove(struct hv_device *device)
 
 	RCU_INIT_POINTER(net_device_ctx->nvdev, NULL);
 
-	/* And disassociate NAPI context from device */
-	for (i = 0; i < net_device->num_chn; i++)
+	/* Disable NAPI and disassociate its context from the device. */
+	for (i = 0; i < net_device->num_chn; i++) {
+		/* See also vmbus_reset_channel_cb(). */
+		napi_disable(&net_device->chan_table[i].napi);
 		netif_napi_del(&net_device->chan_table[i].napi);
+	}
 
 	/*
 	 * At this point, no one should be accessing net_device
-- 
2.24.0

