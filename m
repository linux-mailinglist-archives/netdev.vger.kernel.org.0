Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9B681933F2
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 23:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgCYW4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 18:56:30 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51163 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgCYW43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 18:56:29 -0400
Received: by mail-wm1-f68.google.com with SMTP id d198so4657617wmd.0;
        Wed, 25 Mar 2020 15:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gqq+iEQk0lZVQyUXxEQnFYPnI64DfK+xOeis6VQTmuE=;
        b=q4VR61dCxBgohYEPkKRCQOIM9njZ7WHwbPCxRAzfHhBpBUwJvoouQnsnHnlpivflUH
         UvaCYiPst365lEI/vTZ/iVKSmoGIPVjYVZwuTgMsbELnmfgyfPV2/8hi2+O45RG6PkSs
         1ylQkyHfV3KbwL8Oh/N588A4fImAjiUnysKUj2WvlCuhsWkriCXlN4wrg6g9F2ToV25j
         FhrWOkXUolrL9Ef7dxReJ88WGh18RCb4Iv7vpa9p9+hhrmtkjo8isnOEhb4X1VcCEf6n
         kzknugsQsCon/JS3p5FT5HJjLaKfdgxAOjx8+oM+WZB7k7EFl3iCTSepHoQNiny396do
         kqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gqq+iEQk0lZVQyUXxEQnFYPnI64DfK+xOeis6VQTmuE=;
        b=IoKXomok/whtNFZ8sAHTgdW57GcCpl1VNDNXRIl/ciO25AWNOOq5iIk15mrBS1vB7a
         U7VwWIRm4R1h1Es2GIk1e6CWFzQy1UjkPESQ0gdQuvQcT0l3ySvRtWP4AjaXnX3wcoIc
         6fnWeW00er/Y0CI+YxslxsoCr8Eosiz6fOl8ocNHjl6sAWCIh18OOymmjoYvbD4O5uUp
         R4VYhoSGjcwf2rhhHmLtJnlJ2DRj8uPqxq3OKHvW9Dc2TsnfDGlXHL62yG24/hICoWR0
         mz8JtIWRqRwkSKQSU8mapn7QSz1HQXNUwjgqXSwLe6KjzsN1b+PpgQsTsMAepCdeyJr4
         F5mA==
X-Gm-Message-State: ANhLgQ3tt5d/+0s/vEGyFqIEYdEYZLhVt5oblVvKBOHJQ5NyDEBigJRV
        yvEhwf6+eHjPIryCsGr5bCMKp+EVFVrvokHD
X-Google-Smtp-Source: ADFU+vtWjgigRKaSwV3tAObFzQRLpgzZ00p3EIXLCXztBbzhVBlaaRYvJU8tYjngTITdXxv6Y7XUZw==
X-Received: by 2002:a7b:c14d:: with SMTP id z13mr5583008wmi.94.1585176987072;
        Wed, 25 Mar 2020 15:56:27 -0700 (PDT)
Received: from andrea.corp.microsoft.com ([86.61.236.197])
        by smtp.gmail.com with ESMTPSA id q72sm790278wme.31.2020.03.25.15.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 15:56:26 -0700 (PDT)
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
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [RFC PATCH 04/11] hv_netvsc: Disable NAPI before closing the VMBus channel
Date:   Wed, 25 Mar 2020 23:54:58 +0100
Message-Id: <20200325225505.23998-5-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200325225505.23998-1-parri.andrea@gmail.com>
References: <20200325225505.23998-1-parri.andrea@gmail.com>
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

