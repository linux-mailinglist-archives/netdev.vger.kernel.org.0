Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB463F9D6A
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhH0RQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:16:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237166AbhH0RQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:16:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630084532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9Gafj8sxsDqc97Bfoh5OIubdmjwxbqAMG/Cf5EW4CHA=;
        b=avpwbox7cr/nD0NuikOZHgJhfXJ6oo/htQZZzX/FweHHHrlB0pxRURvl5zLqd1Ht8EMhqu
        jFtmOhev46CxxRhPEcWbde/zOIFMoErj6SsoKVo4r93AZj5e55RW7uCErrfcIJgMeKIWQv
        KBOqSsK0vD//JNp4N7hY+iVMnTU3nlQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-mB9VNEM2MK-PTRl0T_yARg-1; Fri, 27 Aug 2021 13:15:31 -0400
X-MC-Unique: mB9VNEM2MK-PTRl0T_yARg-1
Received: by mail-qt1-f197.google.com with SMTP id k6-20020ac84786000000b0029d8b7a6d1eso1554205qtq.4
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 10:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Gafj8sxsDqc97Bfoh5OIubdmjwxbqAMG/Cf5EW4CHA=;
        b=HWYmvyf0r2JJQiFbXcgWmRnLi+nSMOQZkiImpITGOuK/WghYEALKELTNNsTnr5WEvv
         IyRCCrsV6I/FMb0eEfnMqJoC7sM90YXF+bNEP+N2upTcYXo7jJc7qJ8W6iFrPEpw/d5h
         jaOwn242x/o+6Up1oa4qqpSOVAzipjObLQ8WsC4B3Uponsk299H3wb46ZFT6o/KWRz/k
         PLVQg8fJjbOojAMS7MnxWUWSfMKq8ogdUgXP7myL5XWLq4YJc1z6ZMJnGbULBvU64ZGd
         FBTB8+MttW9PJ6OhsduA2llBjHQmYMSnyzGM0rALhB2NCnCSyBTjXt0+MeadwcKKe+ud
         fHDA==
X-Gm-Message-State: AOAM532IpP3YLUwE817hivsLD/SzK1ttst0pVpIQ971iPeKjoyXl0Zgl
        spwe0GGpL67pgVTWuqTWsn+Emg5iiFc3LQw6eJrV0kX9YADHRZynv8VuGggHtD9rHn5QXJTORV7
        JRSqOKBA+CxZ2XGbi
X-Received: by 2002:a05:622a:650:: with SMTP id a16mr9368936qtb.157.1630084530829;
        Fri, 27 Aug 2021 10:15:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+mGVdS88FWRCD11ZTp8zbd10l92FiowGcA/FEWX67lzhyonxWS4Z0phgbqe+R7LCZiA3JOA==
X-Received: by 2002:a05:622a:650:: with SMTP id a16mr9368915qtb.157.1630084530614;
        Fri, 27 Aug 2021 10:15:30 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id q14sm5119552qkl.44.2021.08.27.10.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 10:15:30 -0700 (PDT)
From:   trix@redhat.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] igc: optimize igc_ptp_systim_to_hwtstamp()
Date:   Fri, 27 Aug 2021 10:15:15 -0700
Message-Id: <20210827171515.2518713-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Static analysis reports this representative problem
igc_ptp.c:676:3: warning: The left operand of '+' is a garbage value
                ktime_add_ns(shhwtstamps.hwtstamp, adjust);
                ^            ~~~~~~~~~~~~~~~~~~~~

The issue is flagged because the setting of shhwtstamps is
in igc_ptp_systim_to_hwtstamp() it is set only in one path through
this switch.

	switch (adapter->hw.mac.type) {
	case igc_i225:
		memset(hwtstamps, 0, sizeof(*hwtstamps));
		/* Upper 32 bits contain s, lower 32 bits contain ns. */
		hwtstamps->hwtstamp = ktime_set(systim >> 32,
						systim & 0xFFFFFFFF);
		break;
	default:
		break;
	}

Changing the memset the a caller initialization is a small optimization
and will resolve uninitialized use issue.

A switch statement with one case is overkill, convert to an if statement.

This function is small and only called once, change to inline for an
expected small runtime and size improvement.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 0f021909b430a0..1443a2da246e22 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -417,20 +417,14 @@ static int igc_ptp_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
  * We need to convert the system time value stored in the RX/TXSTMP registers
  * into a hwtstamp which can be used by the upper level timestamping functions.
  **/
-static void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
-				       struct skb_shared_hwtstamps *hwtstamps,
-				       u64 systim)
+static inline void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
+					      struct skb_shared_hwtstamps *hwtstamps,
+					      u64 systim)
 {
-	switch (adapter->hw.mac.type) {
-	case igc_i225:
-		memset(hwtstamps, 0, sizeof(*hwtstamps));
-		/* Upper 32 bits contain s, lower 32 bits contain ns. */
+	/* Upper 32 bits contain s, lower 32 bits contain ns. */
+	if (adapter->hw.mac.type == igc_i225)
 		hwtstamps->hwtstamp = ktime_set(systim >> 32,
 						systim & 0xFFFFFFFF);
-		break;
-	default:
-		break;
-	}
 }
 
 /**
@@ -645,7 +639,7 @@ void igc_ptp_tx_hang(struct igc_adapter *adapter)
 static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 {
 	struct sk_buff *skb = adapter->ptp_tx_skb;
-	struct skb_shared_hwtstamps shhwtstamps;
+	struct skb_shared_hwtstamps shhwtstamps = { 0 };
 	struct igc_hw *hw = &adapter->hw;
 	int adjust = 0;
 	u64 regval;
-- 
2.26.3

