Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8F030750
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfEaDyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:54:09 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44394 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfEaDyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 23:54:09 -0400
Received: by mail-io1-f66.google.com with SMTP id f22so6986170iol.11
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 20:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qcjrhVYsZg52RJ5XXriOknCyqMNzK66d33ZzlwDcMVo=;
        b=W3TwW4DqsezXBlUJHicJWKqM/j0qAEnP6ywmwbFYab/eJVNGGidy9owsITmfaNAdf6
         Fz5fuAuBri9mUH60zR3nugFjCv3odkZK6b4QYl4vGiQCDYsAc+9+SB1gAXM8GLdw+1eR
         q/MWSwM0Q45OYgflLad5PZ2BGq5fTi6Zh5TtBnmnOq2f31aSzXW0kPNfq+dFmxNe3bLW
         xDC2BU3ZbGf9oaByMK8aQe0qmfaNHtkNnyuES5HZvwzjktrsL/wwUV3DtJss56WiImYG
         588YsvLCDWIkiEHFIAb0j8CR+dgreVIM0l064j6cYll80b80qiv2Bf4TCK3groaINQrC
         k+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qcjrhVYsZg52RJ5XXriOknCyqMNzK66d33ZzlwDcMVo=;
        b=N/eIhtITlCoBI0O1wE4CMRQbiXWvyHPdbDpO+A5+Yt1eAmCAxJd/eFcmozc1Y2qqG/
         Qbp4D9H1VVGK27ZHWoffvMiqhMqO6FSlUYi2tNk9lU8JJ4T9jjIzxEoLCJlAjmXpd21u
         flpqHMICKv/1mAzglQAZlh/RGRFQdYbbDo3RNLnL6yr7U1JjUWSuZUK/CzcTszjkZ1Tl
         /WWTVCOvtSYvsDNWVxPYXgyN/fRBqTrD+bzfaSUclEl1L7F5MhlMCWuoopDEpLpNMzSV
         a89F3zKYKTNBLMo6g9AAPbIyv9FozCBdfiat3lQ7uT06RdWpzOwW1CylVD2EeUajH0yZ
         Z5aw==
X-Gm-Message-State: APjAAAVt/qceY0W0h1HaeVPQX/EPU78R/7Qpahw9KogVNKsZYoKIDmec
        cGXOvimEEzRFwQ5LIVrA+sb1hQ==
X-Google-Smtp-Source: APXvYqyoSK33VrVMXXIhBImgNXPM19PElBRuQNwVsxLaDvN7FuwTs/xkVcRJ5E34mPw9RNG7aVFRmg==
X-Received: by 2002:a5d:9518:: with SMTP id d24mr5008878iom.21.1559274847945;
        Thu, 30 May 2019 20:54:07 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id q15sm1626947ioi.15.2019.05.30.20.54.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 20:54:07 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, arnd@arndb.de, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 09/17] soc: qcom: ipa: IPA interface to GSI
Date:   Thu, 30 May 2019 22:53:40 -0500
Message-Id: <20190531035348.7194-10-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190531035348.7194-1-elder@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides interface functions supplied by the IPA layer
that are called from the GSI layer.  One function is called when a
GSI transaction has completed.  The others allow the GSI layer to
inform the IPA layer when the hardware has been told it has new TREs
to execute, and when the hardware has indicated transactions have
completed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_gsi.c | 48 ++++++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_gsi.h | 49 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)
 create mode 100644 drivers/net/ipa/ipa_gsi.c
 create mode 100644 drivers/net/ipa/ipa_gsi.h

diff --git a/drivers/net/ipa/ipa_gsi.c b/drivers/net/ipa/ipa_gsi.c
new file mode 100644
index 000000000000..7f8d74688c1e
--- /dev/null
+++ b/drivers/net/ipa/ipa_gsi.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+
+#include "gsi_trans.h"
+#include "ipa.h"
+#include "ipa_endpoint.h"
+
+void ipa_gsi_trans_complete(struct gsi_trans *trans)
+{
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+	struct ipa_endpoint *endpoint;
+
+	endpoint = ipa->endpoint_map[trans->channel_id];
+	if (endpoint == ipa->command_endpoint)
+		return;		/* Nothing to do for commands */
+
+	if (endpoint->toward_ipa)
+		ipa_endpoint_skb_tx_complete(trans);
+	else
+		ipa_endpoint_rx_complete(trans);
+}
+
+void ipa_gsi_channel_tx_queued(struct gsi *gsi, u32 channel_id, u32 count,
+			       u32 byte_count)
+{
+	struct ipa *ipa = container_of(gsi, struct ipa, gsi);
+	struct ipa_endpoint *endpoint;
+
+	endpoint = ipa->endpoint_map[channel_id];
+	if (endpoint->netdev)
+		netdev_sent_queue(endpoint->netdev, byte_count);
+}
+
+void ipa_gsi_channel_tx_completed(struct gsi *gsi, u32 channel_id, u32 count,
+				  u32 byte_count)
+{
+	struct ipa *ipa = container_of(gsi, struct ipa, gsi);
+	struct ipa_endpoint *endpoint;
+
+	endpoint = ipa->endpoint_map[channel_id];
+	if (endpoint->netdev)
+		netdev_completed_queue(endpoint->netdev, count, byte_count);
+}
diff --git a/drivers/net/ipa/ipa_gsi.h b/drivers/net/ipa/ipa_gsi.h
new file mode 100644
index 000000000000..72adb520da40
--- /dev/null
+++ b/drivers/net/ipa/ipa_gsi.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019 Linaro Ltd.
+ */
+#ifndef _IPA_GSI_TRANS_H_
+#define _IPA_GSI_TRANS_H_
+
+#include <linux/types.h>
+
+struct gsi_trans;
+
+/**
+ * ipa_gsi_trans_complete() - GSI transaction completion callback
+ * @gsi:	GSI pointer
+ * @trans:	Transaction that has completed
+ *
+ * This called from the GSI layer to notify the IPA layer that a
+ * transaction has completed.
+ */
+void ipa_gsi_trans_complete(struct gsi_trans *trans);
+
+/**
+ * ipa_gsi_channel_tx_queued() - GSI queued to hardware notification
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel number
+ * @count:	Number of transactions queued
+ * @byte_count:	Number of bytes to transfer represented by transactions
+ *
+ * This called from the GSI layer to notify the IPA layer that some
+ * number of transactions have been queued to hardware for execution.
+ */
+void ipa_gsi_channel_tx_queued(struct gsi *gsi, u32 channel_id, u32 count,
+			       u32 byte_count);
+/**
+ * ipa_gsi_trans_complete() - GSI transaction completion callback
+ipa_gsi_channel_tx_completed()
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel number
+ * @count:	Number of transactions completed since last report
+ * @byte_count:	Number of bytes transferred represented by transactions
+ *
+ * This called from the GSI layer to notify the IPA layer that the hardware
+ * has reported the completion of some number of transactions.
+ */
+void ipa_gsi_channel_tx_completed(struct gsi *gsi, u32 channel_id, u32 count,
+				  u32 byte_count);
+
+#endif /* _IPA_GSI_TRANS_H_ */
-- 
2.20.1

