Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA175442B9
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388895AbfFMQZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:25:10 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:40706 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728789AbfFMQZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 12:25:09 -0400
Received: by mail-vk1-f193.google.com with SMTP id s16so4220266vke.7
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 09:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QF5aHDq01mrvmqrbhsgiXkss+ghjibQPk8bwaI3rCI=;
        b=a1ZGCklkE23KFukqsdi9Wk3NktOq9ie/nvkwCmcVyaRv46yLbCXhg2nrddnchIKajk
         XnyKDI26bmLffhJ5t7EVlgt0b3QJy7ygzSNERWZfqyq2wpiZGTMeg8E/5I5jsQ3csGxb
         ckKLX0vnpKfVgZd4iAaI4+05t+5nz1qR5tXWYdrvbIuJEH2K8V6LCWMkWntwtkbRD/M6
         skUAllHs9iYcs8KwqptPEhZ6MQD3hLCK7hpKd5D/U6+YzJWr2tF4LqKGBNkOKu7+FCf+
         hJbaQpCqBaYjVTM/WnofjE8f4SLlJqVDtXG6O7Ap4IrPlOhuuEcj2g5NgANiqE1PAMQJ
         Bubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QF5aHDq01mrvmqrbhsgiXkss+ghjibQPk8bwaI3rCI=;
        b=C1baJ2tnU1E1DsIoqYH6nsQEXbI+6aPpck3RtTXOEaDPPESpkPYzUAaKMSLFR/Aaqh
         KQ0AXW8h/QS3h8PZ9spG7hIY+NFZU2Kt20SGLm1/Nyx14usT16k2lfiAH6aHz9R+2TGj
         YkegfBl7SbJS4p+V0kBkTk9RW4ZbEUhgISr+dVKMoY2VK9BRdTHzYz6jxs2dsL1RZZ35
         Sk9vxeGhZWCTe2HEmcB4Onuwsgk6475rFWbl7Fj888nHVmDI84GDisq6JHCW//76wkg2
         9FTM8U/ik6irUWTMXFcsz2qpuGuDdxNO/uhyZcicx/894WiZhUSnUVREEWmRJfQEUO15
         xd2A==
X-Gm-Message-State: APjAAAUFDN/peORWK8BJ8wob0XFOSD0c/03YIDfuw2OGdsokQF8FbBi9
        E3C3H3qjgZbBFXO4O0pg2qYLdo63
X-Google-Smtp-Source: APXvYqzzyEcjOlTDMfKP11DyX55eeXtsXUZX/j/v3cihYoWztaltL2hFvl8kZ8PnhqZfsucY2o288Q==
X-Received: by 2002:a1f:c251:: with SMTP id s78mr11044998vkf.7.1560443107581;
        Thu, 13 Jun 2019 09:25:07 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id t5sm194018vke.51.2019.06.13.09.25.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 09:25:06 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jasowang@redhat.com, mst@redhat.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] virtio_net: enable napi_tx by default
Date:   Thu, 13 Jun 2019 12:24:57 -0400
Message-Id: <20190613162457.143518-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

NAPI tx mode improves TCP behavior by enabling TCP small queues (TSQ).
TSQ reduces queuing ("bufferbloat") and burstiness.

Previous measurements have shown significant improvement for
TCP_STREAM style workloads. Such as those in commit 86a5df1495cc
("Merge branch 'virtio-net-tx-napi'").

There has been uncertainty about smaller possible regressions in
latency due to increased reliance on tx interrupts.

The above results did not show that, nor did I observe this when
rerunning TCP_RR on Linux 5.1 this week on a pair of guests in the
same rack. This may be subject to other settings, notably interrupt
coalescing.

In the unlikely case of regression, we have landed a credible runtime
solution. Ethtool can configure it with -C tx-frames [0|1] as of
commit 0c465be183c7 ("virtio_net: ethtool tx napi configuration").

NAPI tx mode has been the default in Google Container-Optimized OS
(COS) for over half a year, as of release M70 in October 2018,
without any negative reports.

Link: https://marc.info/?l=linux-netdev&m=149305618416472
Link: https://lwn.net/Articles/507065/
Signed-off-by: Willem de Bruijn <willemb@google.com>

---

now that we have ethtool support and real production deployment,
it seemed like a good time to revisit this discussion.

---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0d4115c9e20b..4f3de0ac8b0b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -26,7 +26,7 @@
 static int napi_weight = NAPI_POLL_WEIGHT;
 module_param(napi_weight, int, 0444);
 
-static bool csum = true, gso = true, napi_tx;
+static bool csum = true, gso = true, napi_tx = true;
 module_param(csum, bool, 0444);
 module_param(gso, bool, 0444);
 module_param(napi_tx, bool, 0644);
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

