Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA2D8F80B
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfHPApJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:45:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52138 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfHPApH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:45:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so2701264wma.1;
        Thu, 15 Aug 2019 17:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RiXMeYkIURxOlpteZs7xGB2oEQUNanLqRdsxWuqWYeI=;
        b=MEDofrhU0mfvUWlwADfaLgabvtFh3xNEKKmycWXLLY01qZ7fn85mEgkzo8URLf5yno
         J4A++l9qoRHPep/Yw4bG5jylO2zWYyvEd4JDgVTq/7fp+Lc2o1l476UP36hdEQLVpL9S
         JmEdkokMgH+jYZpsPQtuzJk8x5til8y4tWSz3fCaXUAew53pg+tYAJS+LHZIYHcw2JY9
         H4yoFTHG5ayRrofp/Y2Q5sZEY9O4qm+G0/LtIAxXjsnVp96S00ybR4+TDrfPNwpDjzgh
         w3v2K9SRRsvwSNq63Pjj0Ddrm0uGOJSEYjLDCxqpHKQbNJoXFsJ5jtb/BHrsGfeAxvZS
         zOyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RiXMeYkIURxOlpteZs7xGB2oEQUNanLqRdsxWuqWYeI=;
        b=uHZ1rNQJJaQD98Daju01VrrPGDYrkxY8BqMKkU1Zy+yEh/t5pk04r9Jb7IvQXU7wkb
         pQn02b8omrfJjc+NIrnPVwKXyoqCFebqWpzUUiAUvxNdjNjgnCW+IFYFunxIWkm/fGbW
         MwzWL1m1ejiIMQ1UZh/Pau6/Nmt1+LvHi8Jv7IdXguZzdrynug96qx75hNYQCK2GNO27
         ShhHe0yxeK6ZrIBLcYLJhBvU3JedOEiCmiqpOPXLD/3HaiKKqZ62mUJWe2J4BZslbEqU
         xSagDA00zgqxDkbHKgv4aKVxIn6mMxCVFiMQXd2yZbKfsXof4hzij7nqHQEj4iQaX8rs
         yLEA==
X-Gm-Message-State: APjAAAXFfwpJa9xBR2PI7/7piOkzZZ29HPHczna/4crCockn5tH59t7E
        vaCYGqTTSLjWXoN0tIODZ7Q=
X-Google-Smtp-Source: APXvYqyne/aFJnQUJBD10JuToneiTd/HGfgoRs6AJbQ/H6XFviRp6AAwB+ZJfrGBvnyZZUgZhYczOQ==
X-Received: by 2002:a05:600c:24cf:: with SMTP id 15mr4651382wmu.76.1565916305139;
        Thu, 15 Aug 2019 17:45:05 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id k124sm6451204wmk.47.2019.08.15.17.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 17:45:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 03/11] spi: Add a PTP system timestamp to the transfer structure
Date:   Fri, 16 Aug 2019 03:44:41 +0300
Message-Id: <20190816004449.10100-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190816004449.10100-1-olteanv@gmail.com>
References: <20190816004449.10100-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SPI is one of the interfaces used to access devices which have a POSIX
clock driver (real time clocks, 1588 timers etc).

Since there are lots of sources of timing jitter when retrieving the
time from such a device (controller delays, locking contention etc),
introduce a PTP system timestamp structure in struct spi_transfer. This
is to be used by SPI device drivers when they need to know the exact
time at which the underlying device's time was snapshotted.

Because SPI controllers may have jitter even between frames, also
introduce a field which specifies to the controller driver specifically
which byte needs to be snapshotted.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/linux/spi/spi.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index af4f265d0f67..5a1e4b24c617 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -13,6 +13,7 @@
 #include <linux/completion.h>
 #include <linux/scatterlist.h>
 #include <linux/gpio/consumer.h>
+#include <linux/ptp_clock_kernel.h>
 
 struct dma_chan;
 struct property_entry;
@@ -842,6 +843,9 @@ struct spi_transfer {
 
 	u32		effective_speed_hz;
 
+	struct ptp_system_timestamp *ptp_sts;
+	unsigned int	ptp_sts_word_offset;
+
 	struct list_head transfer_list;
 };
 
-- 
2.17.1

