Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90F7222EB4
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgGPXKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbgGPXJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:09:20 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B27C08C5F4
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 15:47:45 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a21so8479885ejj.10
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 15:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4RFbNa1x/C+YAL/CQbd7Gcy7fP7wQ0wRh0CmZMRwvdg=;
        b=oHMz5HCBOn5JxwgZaoeK79HiaAGsL4Ohw3PKPG88ZtI2zJkurNzH5H53IS9QepUH/y
         qB7jWLbvOSPmP96nPUQV6Tuh1SBL0Hu/Qatd2cptzkJxle4p1jlUUMcP2KTtiavFTL3k
         tUqowTSk8G+QLacEMUWVxsU0GsFI/CMaHvdaH25v15DqeqhcbUadtUiHwz98etXamGCc
         XX2FuPuA+NHQo02+C3wTYPB24Aitd9QKOAxNyjQ9T2doFS0SAoEgiyCvh5RGC2+MhwBW
         3OKIqXPO3HWUKoRwUcu/Lb/LOuouRu7+znxjT6ZPC5mahHBfnnAnFVzXFqkREmaOSlTz
         Alpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4RFbNa1x/C+YAL/CQbd7Gcy7fP7wQ0wRh0CmZMRwvdg=;
        b=ihx6CtEX/8DSL5/GMLcBU4+I70Fs1JZaivioOLjIS+Ib9iK4yb0pLL7Qw42YEnVdDr
         J1yljmrAcckPRng/6V5E8JY4CQFhNu8RL5nX4Pto7XWMFAOHieBIQcxFJEPdb2Ljrhbe
         YPRuRKvPJjOoM4NgCQ5mUn8+n5qNEwKOaANBUiqOBg88I7iVA+G+kcS6RXNyqlqd2seF
         szTSPmbMTxyVcna8FCINXxhSNEsPu2Pt5/A1ltMwnb/+XJfx7W8FYzeBb53kJvcF4su9
         JQzMUWQkVJ7ZfWu1vaBVKouwq06L1XEQrmz75iVxQQXITSbZZHB/p+ZTwcJ+w9GeUGua
         PsSg==
X-Gm-Message-State: AOAM5323Pc5JhERBlkCgLpmJcMQkv4l7O2bFunTsV419mJhzeQND173s
        3etfCo5qVeY0bvije9a0RGw=
X-Google-Smtp-Source: ABdhPJw2vG0jcCIVGG6VK2+X/ZcsHGJGUZJC51xpyPnOiRTIQoBnCgSbxZ3rabhsnqVqkJ92MRmnaw==
X-Received: by 2002:a17:906:b0d:: with SMTP id u13mr5758127ejg.342.1594939664467;
        Thu, 16 Jul 2020 15:47:44 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id ce15sm6285512ejc.86.2020.07.16.15.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 15:47:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 1/3] ptp: add ability to configure duty cycle for periodic output
Date:   Fri, 17 Jul 2020 01:45:29 +0300
Message-Id: <20200716224531.1040140-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716224531.1040140-1-olteanv@gmail.com>
References: <20200716224531.1040140-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are external event timestampers (PHCs with support for
PTP_EXTTS_REQUEST) that timestamp both event edges.

When those edges are very close (such as in the case of a short pulse),
there is a chance that the collected timestamp might be of the rising,
or of the falling edge, we never know.

There are also PHCs capable of generating periodic output with a
configurable duty cycle. This is good news, because we can space the
rising and falling edge out enough in time, that the risks to overrun
the 1-entry timestamp FIFO of the extts PHC are lower (example: the
perout PHC can be configured for a period of 1 second, and an "on" time
of 0.5 seconds, resulting in a duty cycle of 50%).

A flag is introduced for signaling that an on time is present in the
perout request structure, for preserving compatibility. Logically
speaking, the duty cycle cannot exceed 100% and the PTP core checks for
this.

PHC drivers that don't support this flag emit a periodic output of an
unspecified duty cycle, same as before.

The duty cycle is encoded as an "on" time, similar to the "start" and
"period" times, and reuses the reserved space while preserving overall
binary layout.

Pahole reported before:

struct ptp_perout_request {
        struct ptp_clock_time start;                     /*     0    16 */
        struct ptp_clock_time period;                    /*    16    16 */
        unsigned int               index;                /*    32     4 */
        unsigned int               flags;                /*    36     4 */
        unsigned int               rsv[4];               /*    40    16 */

        /* size: 56, cachelines: 1, members: 5 */
        /* last cacheline: 56 bytes */
};

And now:

struct ptp_perout_request {
        struct ptp_clock_time start;                     /*     0    16 */
        struct ptp_clock_time period;                    /*    16    16 */
        unsigned int               index;                /*    32     4 */
        unsigned int               flags;                /*    36     4 */
        union {
                struct ptp_clock_time on;                /*    40    16 */
                unsigned int       rsv[4];               /*    40    16 */
        };                                               /*    40    16 */

        /* size: 56, cachelines: 1, members: 5 */
        /* last cacheline: 56 bytes */
};

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
None.

 drivers/ptp/ptp_chardev.c      | 33 +++++++++++++++++++++++++++------
 include/uapi/linux/ptp_clock.h | 17 ++++++++++++++---
 2 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 375cd6e4aade..e0e6f85966e1 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -191,12 +191,33 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 			err = -EFAULT;
 			break;
 		}
-		if (((req.perout.flags & ~PTP_PEROUT_VALID_FLAGS) ||
-			req.perout.rsv[0] || req.perout.rsv[1] ||
-			req.perout.rsv[2] || req.perout.rsv[3]) &&
-			cmd == PTP_PEROUT_REQUEST2) {
-			err = -EINVAL;
-			break;
+		if (cmd == PTP_PEROUT_REQUEST2) {
+			struct ptp_perout_request *perout = &req.perout;
+
+			if (perout->flags & ~PTP_PEROUT_VALID_FLAGS) {
+				err = -EINVAL;
+				break;
+			}
+			/*
+			 * The "on" field has undefined meaning if
+			 * PTP_PEROUT_DUTY_CYCLE isn't set, we must still treat
+			 * it as reserved, which must be set to zero.
+			 */
+			if (!(perout->flags & PTP_PEROUT_DUTY_CYCLE) &&
+			    (perout->rsv[0] || perout->rsv[1] ||
+			     perout->rsv[2] || perout->rsv[3])) {
+				err = -EINVAL;
+				break;
+			}
+			if (perout->flags & PTP_PEROUT_DUTY_CYCLE) {
+				/* The duty cycle must be subunitary. */
+				if (perout->on.sec > perout->period.sec ||
+				    (perout->on.sec == perout->period.sec &&
+				     perout->on.nsec > perout->period.nsec)) {
+					err = -ERANGE;
+					break;
+				}
+			}
 		} else if (cmd == PTP_PEROUT_REQUEST) {
 			req.perout.flags &= PTP_PEROUT_V1_VALID_FLAGS;
 			req.perout.rsv[0] = 0;
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index ff070aa64278..1d2841155f7d 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -53,12 +53,14 @@
 /*
  * Bits of the ptp_perout_request.flags field:
  */
-#define PTP_PEROUT_ONE_SHOT (1<<0)
+#define PTP_PEROUT_ONE_SHOT		(1<<0)
+#define PTP_PEROUT_DUTY_CYCLE		(1<<1)
 
 /*
  * flag fields valid for the new PTP_PEROUT_REQUEST2 ioctl.
  */
-#define PTP_PEROUT_VALID_FLAGS	(PTP_PEROUT_ONE_SHOT)
+#define PTP_PEROUT_VALID_FLAGS		(PTP_PEROUT_ONE_SHOT | \
+					 PTP_PEROUT_DUTY_CYCLE)
 
 /*
  * No flags are valid for the original PTP_PEROUT_REQUEST ioctl
@@ -105,7 +107,16 @@ struct ptp_perout_request {
 	struct ptp_clock_time period; /* Desired period, zero means disable. */
 	unsigned int index;           /* Which channel to configure. */
 	unsigned int flags;
-	unsigned int rsv[4];          /* Reserved for future use. */
+	union {
+		/*
+		 * The "on" time of the signal.
+		 * Must be lower than the period.
+		 * Valid only if (flags & PTP_PEROUT_DUTY_CYCLE) is set.
+		 */
+		struct ptp_clock_time on;
+		/* Reserved for future use. */
+		unsigned int rsv[4];
+	};
 };
 
 #define PTP_MAX_SAMPLES 25 /* Maximum allowed offset measurement samples. */
-- 
2.25.1

