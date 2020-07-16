Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A4A222EBF
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgGPXKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbgGPXJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:09:20 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D142BC08C5F5
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 15:47:46 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id e22so6047639edq.8
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 15:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F1Xv8EY4tr8na6kuaCtWsilvcGZDDfcaRiEZknYzr2s=;
        b=DFAUs8siVRJi3XqhS3gg8rNZ1kItgpkM/D0I0UewdzkiVky+dygCCfJFmb9e93dins
         59IPr6RKe5I6Eerunt9zesLxo44/E/c9ecWpZX8k0K7avoGI1pYxmV5R6EHJbRwqYLUK
         6tAaAwYlwHwevrpGhqpEfzYiL8tNcExQm8wq/Zc8BNCLzzTYdoYT2cEn5IbYIi71X+Yt
         rVBUMyIaCpLw7sP1bJ20ZJ+nAzoU+/MEUorEy17C76/qWH/KtffC7zScO+J1HBKxje6V
         /uYNz8tTE/XB2m0OrPwGQGyb0Cgk09OkW3kn2cK0YAQI4o1BuZiEmZOrzs+YZjzKfXFN
         aAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F1Xv8EY4tr8na6kuaCtWsilvcGZDDfcaRiEZknYzr2s=;
        b=ksId5q6xXJ/vW+GUSj6bsOuio1UOjOnE7QHWvbvLuDPANMpoJ/e0eGrjy2s9qJGOrR
         fhmywuFs0kzfszR/Q8uJ86aC98Asld5nJWQVcVnffr0fvADfd3vKQ2UjJ1EAp7dpvONf
         X8WSFPQvsPNSr03Ffr5dOgPADu78EFFWfRqQqCzJTll2gMUqa1uVEj1JEehbty2R5fYO
         D6VIF59lHLjWWawppCsDNS5W2G3L1+pMUn+vO57FpbrqgZrFPx9F/l3JpJ4s9laohYb/
         IecrxKQADtpQPl6IOSQYsuQaKRDaJcudWB5h6x6ODx2SigZ2W5CuMdtILubwaAfObN0s
         E6Aw==
X-Gm-Message-State: AOAM533VahtolqrpxefM3a0WHKH8Jmzs7V3slReIbaS/VwoZATHgNTkr
        +LU4Y42knVVWA1Nwnmz7ZWdsfHPV
X-Google-Smtp-Source: ABdhPJy1R/mX8bB2hFzgRW07oU0zN+RLeO/30aUEEiuO/nahp9XJtCnpIR1ha+MXWQ/dKlOPb0n4xA==
X-Received: by 2002:a05:6402:1250:: with SMTP id l16mr6713331edw.362.1594939665533;
        Thu, 16 Jul 2020 15:47:45 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id ce15sm6285512ejc.86.2020.07.16.15.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 15:47:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 2/3] ptp: introduce a phase offset in the periodic output request
Date:   Fri, 17 Jul 2020 01:45:30 +0300
Message-Id: <20200716224531.1040140-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716224531.1040140-1-olteanv@gmail.com>
References: <20200716224531.1040140-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PHCs like the ocelot/felix switch cannot emit generic periodic
output, but just PPS (pulse per second) signals, which:
- don't start from arbitrary absolute times, but are rather
  phase-aligned to the beginning of [the closest next] second.
- have an optional phase offset relative to that beginning of the
  second.

For those, it was initially established that they should reject any
other absolute time for the PTP_PEROUT_REQUEST than 0.000000000 [1].

But when it actually came to writing an application [2] that makes use
of this functionality, we realized that we can't really deal generically
with PHCs that support absolute start time, and with PHCs that don't,
without an explicit interface. Namely, in an ideal world, PHC drivers
would ensure that the "perout.start" value written to hardware will
result in a functional output. This means that if the PTP time has
become in the past of this PHC's current time, it should be
automatically fast-forwarded by the driver into a close enough future
time that is known to work (note: this is necessary only if the hardware
doesn't do this fast-forward by itself). But we don't really know what
is the status for PHC drivers in use today, so in the general sense,
user space would be risking to have a non-functional periodic output if
it simply asked for a start time of 0.000000000.

So let's introduce a flag for this type of reduced-functionality
hardware, named PTP_PEROUT_PHASE. The start time is just "soon", the
only thing we know for sure about this signal is that its rising edge
events, Rn, occur at:

Rn = perout.phase + n * perout.period

The "phase" in the periodic output structure is simply an alias to the
"start" time, since both cannot logically be specified at the same time.
Therefore, the binary layout of the structure is not affected.

[1]: https://patchwork.ozlabs.org/project/netdev/patch/20200320103726.32559-7-yangbo.lu@nxp.com/
[2]: https://www.mail-archive.com/linuxptp-devel@lists.sourceforge.net/msg04142.html

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
Typo in commit message: period -> perout

 include/uapi/linux/ptp_clock.h | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 1d2841155f7d..1d108d597f66 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -55,12 +55,14 @@
  */
 #define PTP_PEROUT_ONE_SHOT		(1<<0)
 #define PTP_PEROUT_DUTY_CYCLE		(1<<1)
+#define PTP_PEROUT_PHASE		(1<<2)
 
 /*
  * flag fields valid for the new PTP_PEROUT_REQUEST2 ioctl.
  */
 #define PTP_PEROUT_VALID_FLAGS		(PTP_PEROUT_ONE_SHOT | \
-					 PTP_PEROUT_DUTY_CYCLE)
+					 PTP_PEROUT_DUTY_CYCLE | \
+					 PTP_PEROUT_PHASE)
 
 /*
  * No flags are valid for the original PTP_PEROUT_REQUEST ioctl
@@ -103,7 +105,20 @@ struct ptp_extts_request {
 };
 
 struct ptp_perout_request {
-	struct ptp_clock_time start;  /* Absolute start time. */
+	union {
+		/*
+		 * Absolute start time.
+		 * Valid only if (flags & PTP_PEROUT_PHASE) is unset.
+		 */
+		struct ptp_clock_time start;
+		/*
+		 * Phase offset. The signal should start toggling at an
+		 * unspecified integer multiple of the period, plus this value.
+		 * The start time should be "as soon as possible".
+		 * Valid only if (flags & PTP_PEROUT_PHASE) is set.
+		 */
+		struct ptp_clock_time phase;
+	};
 	struct ptp_clock_time period; /* Desired period, zero means disable. */
 	unsigned int index;           /* Which channel to configure. */
 	unsigned int flags;
-- 
2.25.1

