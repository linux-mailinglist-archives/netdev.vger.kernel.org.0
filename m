Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEB72D291
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 01:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfE1X6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 19:58:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43740 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbfE1X6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 19:58:31 -0400
Received: by mail-wr1-f67.google.com with SMTP id l17so334872wrm.10;
        Tue, 28 May 2019 16:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tmrU/nzbiwy6RxnR7al3LfOUoLnS2vRplPFJ+vSWK7k=;
        b=BOGu4DWqeqirfeIBaG6w5f5nN8CncXpvt20NeCU+i92yau0OPhEMoIhdlIKP40TM/v
         LG3fMWkwLkfpiP8p4z9gL4zOWyzFBmRhuzIvBXfUyMzx5OTTTv4/wsR8K6ANukY1XJ9+
         Tu15kt6bNR7ixen7qHI3W0s//iA8J/oCRLMjurV2Vsc8F6t7d5ubsdsK0Jqwh6wSTOsW
         WDdbjYL/MvdkIZaTYuM7KASovzGKaU5Jsgttbv4Eu4g2PZpLF95XTqpcjp7oDnTGBZPh
         cqUDQ8dFGyC6tcKBiT/+w4hMrn/wCsuO7NgwX/kx1vgKySpfU/NdsTSV/97I7u6k0XhO
         lbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tmrU/nzbiwy6RxnR7al3LfOUoLnS2vRplPFJ+vSWK7k=;
        b=LJbdx/uqSuxOVsqrUMI04EwpJBQnuBL9lCEJicoZTsIXw3z+O7bQVowSwWacyH2g3K
         7QnEccKbLDgrFbyUSOujWhyCZDrJoI26VIyLV0DJE20+k2IHqbWkIxBO1diLssyjEG9S
         ySZADc0O2icj7VXu8pmiT7v6eqzlJXkgKKGJxuvgm6F9iJ1NlHXK/ZjExTRPWB1VCyuA
         qQ087uw2YFAbL+TFzgkKxx7dP3yt/IRrcnyyd12eeVBO/LF0k/jfEgJQyM/t3kgSYN3u
         ZTqVzXC2JUO0jH1mrQ0lknHhbp/p+YbVNhscecJKkV99ySOJwFY8VJfdiWUgdcn3WDlT
         4vfg==
X-Gm-Message-State: APjAAAUCNh7aV39olng/FJB4PruqYXjw9KpsTZtCmfP9dEsF+DzpB08l
        nPXs6z77iuEgwvigBwxejQk=
X-Google-Smtp-Source: APXvYqxQunx5s6p+SHIyiYDcoAl6YFweZp8qkn+3khqr4GVN2qUDJevkO/Es5T3N6SqUmWQDV6DpXA==
X-Received: by 2002:a5d:628d:: with SMTP id k13mr21475364wru.319.1559087908681;
        Tue, 28 May 2019 16:58:28 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f3sm1207505wre.93.2019.05.28.16.58.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 16:58:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/5] timecounter: Add helper for reconstructing partial timestamps
Date:   Wed, 29 May 2019 02:56:23 +0300
Message-Id: <20190528235627.1315-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528235627.1315-1-olteanv@gmail.com>
References: <20190528235627.1315-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PTP hardware offers a 64-bit free-running counter whose snapshots
are used for timestamping, but only makes part of that snapshot
available as timestamps (low-order bits).

In that case, timecounter/cyclecounter users must bring the cyclecounter
and timestamps to the same bit width, and they currently have two
options of doing so:

- Trim the higher bits of the timecounter itself to the number of bits
  of the timestamps.  This might work for some setups, but if the
  wraparound of the timecounter in this case becomes high (~10 times per
  second) then this causes additional strain on the system, which must
  read the clock that often just to avoid missing the wraparounds.

- Reconstruct the timestamp by racing to read the PTP time within one
  wraparound cycle since the timestamp was generated.  This is
  preferable when the wraparound time is small (do a time-critical
  readout once vs doing it periodically), and it has no drawback even
  when the wraparound is comfortably sized.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/linux/timecounter.h |  7 +++++++
 kernel/time/timecounter.c   | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/linux/timecounter.h b/include/linux/timecounter.h
index 2496ad4cfc99..03eab1f3bb9c 100644
--- a/include/linux/timecounter.h
+++ b/include/linux/timecounter.h
@@ -30,6 +30,9 @@
  *	by the implementor and user of specific instances of this API.
  *
  * @read:		returns the current cycle value
+ * @partial_tstamp_mask:bitmask in case the hardware emits timestamps
+ *			which only capture low-order bits of the full
+ *			counter, and should be reconstructed.
  * @mask:		bitmask for two's complement
  *			subtraction of non 64 bit counters,
  *			see CYCLECOUNTER_MASK() helper macro
@@ -38,6 +41,7 @@
  */
 struct cyclecounter {
 	u64 (*read)(const struct cyclecounter *cc);
+	u64 partial_tstamp_mask;
 	u64 mask;
 	u32 mult;
 	u32 shift;
@@ -136,4 +140,7 @@ extern u64 timecounter_read(struct timecounter *tc);
 extern u64 timecounter_cyc2time(struct timecounter *tc,
 				u64 cycle_tstamp);
 
+extern u64 cyclecounter_reconstruct(const struct cyclecounter *cc,
+				    u64 ts_partial);
+
 #endif
diff --git a/kernel/time/timecounter.c b/kernel/time/timecounter.c
index 85b98e727306..d4657d64e38d 100644
--- a/kernel/time/timecounter.c
+++ b/kernel/time/timecounter.c
@@ -97,3 +97,36 @@ u64 timecounter_cyc2time(struct timecounter *tc,
 	return nsec;
 }
 EXPORT_SYMBOL_GPL(timecounter_cyc2time);
+
+/**
+ * cyclecounter_reconstruct - reconstructs @ts_partial
+ * @cc:		Pointer to cycle counter.
+ * @ts_partial:	Typically RX or TX NIC timestamp, provided by hardware as
+ *		the lower @partial_tstamp_mask bits of the cycle counter,
+ *		sampled at the time the timestamp was collected.
+ *		To reconstruct into a full @mask bit-wide timestamp, the
+ *		cycle counter is read and the high-order bits (up to @mask) are
+ *		filled in.
+ *		Must be called within one wraparound of @partial_tstamp_mask
+ *		bits of the cycle counter.
+ */
+u64 cyclecounter_reconstruct(const struct cyclecounter *cc, u64 ts_partial)
+{
+	u64 ts_reconstructed;
+	u64 cycle_now;
+
+	cycle_now = cc->read(cc);
+
+	ts_reconstructed = (cycle_now & ~cc->partial_tstamp_mask) |
+			    ts_partial;
+
+	/* Check lower bits of current cycle counter against the timestamp.
+	 * If the current cycle counter is lower than the partial timestamp,
+	 * then wraparound surely occurred and must be accounted for.
+	 */
+	if ((cycle_now & cc->partial_tstamp_mask) <= ts_partial)
+		ts_reconstructed -= (cc->partial_tstamp_mask + 1);
+
+	return ts_reconstructed;
+}
+EXPORT_SYMBOL_GPL(cyclecounter_reconstruct);
-- 
2.17.1

