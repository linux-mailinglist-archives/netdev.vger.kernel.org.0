Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C751F222DAE
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgGPVVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgGPVVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 17:21:47 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58E3C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 14:21:46 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id rk21so8205004ejb.2
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 14:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zEUsbdz9V+p7q6i8k9696HFeAQGbeDholzejJAbXHbM=;
        b=Ej3sL1gRMZV0g3/h4i+NkXH/+oUvpN+VLyA+JWFmrsyHLhUAzgmQ/mTeht6qDaGhIK
         IZdGa+eQ/+0brFis8vIY/sWqvk03VJI4r3u64r9Dxr3FSTY6YLD+8wKMmG/PVlCkq2y2
         vyjVxGREaZV8EMVK0FQMW+MM7E3L1PF65vquLq0PzMtxv2kPQy3JrYlb5Tiv7cT3RrKc
         O0nVWlyJ+Et9ZLxJL2MUwrJDA+aERBWjxepzZtyejojcqWrZz63ZPaTo4X37jrD1B6Gw
         R/0ftUcU10zMKnoS7sE3RbTuvkPDIaXKeJywEUzxA29MekF51WtDcASt9zGNELPp3FSE
         jFnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zEUsbdz9V+p7q6i8k9696HFeAQGbeDholzejJAbXHbM=;
        b=V/BeMFw5bvPRvO/vqgZlmIVEmXffMVNU65N7c9rAkPeMYD4urbaVNCTL+mDQjbaCKA
         OWRuplbi5GkbErCPZUI5S5ykpZnHPbvLTCTGdILuxpQxJmY/zz01LkzMt4W5TQRhfdBR
         CGBX0LQ7v4DL5QqN6LwUG3ytIbVC28e0cKDK160+6ZmYIMo6syBqhfLNEKPEoErZ9P62
         QBB7j4iw6ZedCkyQQCTK/oZEdu8YDGoucxjNT1x4YSybQOb2uBk8eI0wUIlYmWI9rPnx
         dsBFjTsaSvR8zJ/ph81vTvRH/vogQEcXislB31lt9jFbA5buWznsi/KiGT1qs70IT06E
         wkJw==
X-Gm-Message-State: AOAM530tN+bzD/orZcKyyRF2y//qu70akQoCHEGT0iGLccDNoCpKQIbb
        Ee5JfAzZwLSR8HEbDrvasqU=
X-Google-Smtp-Source: ABdhPJzsK8wjyYkpT5PIZcnlZUfG8Bj/Qz0CoFSf4afZ/yV5/eHmAhc7iHNLsefKvPtg3yvyP9+Iqw==
X-Received: by 2002:a17:906:1a59:: with SMTP id j25mr5293168ejf.398.1594934505277;
        Thu, 16 Jul 2020 14:21:45 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bq8sm6182596ejb.103.2020.07.16.14.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 14:21:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 1/3] ptp: add ability to configure duty cycle for periodic output
Date:   Fri, 17 Jul 2020 00:20:30 +0300
Message-Id: <20200716212032.1024188-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716212032.1024188-1-olteanv@gmail.com>
References: <20200716212032.1024188-1-olteanv@gmail.com>
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

