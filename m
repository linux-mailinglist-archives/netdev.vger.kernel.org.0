Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272BF3A71DE
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 00:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhFNW0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 18:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhFNW0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 18:26:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB277611EE;
        Mon, 14 Jun 2021 22:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623709447;
        bh=4ksQOlENPebKjK/wIEgxQ/KlAjO+D/Rs4GvasvFI3x4=;
        h=From:To:Cc:Subject:Date:From;
        b=EAGf9Ug1s41HWevm7Xbn2ejkzCUtG6mRMmLu4+yVy1HUpOeJXPYkFhHcRt6cAEWUF
         4Y7z0GN8RledmtzsBiUk8crDBnhI2oil6BBmrabJte1padwVCycucAkOKtaBtOfKHM
         zZm6+q5TlQZdKoOWHwDhtxLpgFSTz7Myoj7bt33QabqkZDlC21E0ON4ksdyv3Co2CZ
         pxH2MGXP081epTYZfBvx+YOCjtUlg9pjw+Q9zkLeJT1vbMd2p4XQ9uanJVXpW/EYIF
         5vzLD6OI2bDfEvCB5y2hiccV/e4HHfYYaJgDoWyO1fcEKlFoXwOdc7IGPuHrkDGFpv
         ty3+VArJk7DsQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, richardcochran@gmail.com
Cc:     jacob.e.keller@intel.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] ptp: improve max_adj check against unreasonable values
Date:   Mon, 14 Jun 2021 15:24:05 -0700
Message-Id: <20210614222405.378030-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Scaled PPM conversion to PPB may (on 64bit systems) result
in a value larger than s32 can hold (freq/scaled_ppm is a long).
This means the kernel will not correctly reject unreasonably
high ->freq values (e.g. > 4294967295ppb, 281474976645 scaled PPM).

The conversion is equivalent to a division by ~66 (65.536),
so the value of ppb is always smaller than ppm, but not small
enough to assume narrowing the type from long -> s32 is okay.

Note that reasonable user space (e.g. ptp4l) will not use such
high values, anyway, 4289046510ppb ~= 4.3x, so the fix is
somewhat pedantic.

Fixes: d39a743511cd ("ptp: validate the requested frequency adjustment.")
Fixes: d94ba80ebbea ("ptp: Added a brand new class driver for ptp clocks.")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/ptp/ptp_clock.c          | 6 +++---
 include/linux/ptp_clock_kernel.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 03a246e60fd9..21c4c34c52d8 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -63,7 +63,7 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
 	spin_unlock_irqrestore(&queue->lock, flags);
 }
 
-s32 scaled_ppm_to_ppb(long ppm)
+long scaled_ppm_to_ppb(long ppm)
 {
 	/*
 	 * The 'freq' field in the 'struct timex' is in parts per
@@ -80,7 +80,7 @@ s32 scaled_ppm_to_ppb(long ppm)
 	s64 ppb = 1 + ppm;
 	ppb *= 125;
 	ppb >>= 13;
-	return (s32) ppb;
+	return (long) ppb;
 }
 EXPORT_SYMBOL(scaled_ppm_to_ppb);
 
@@ -138,7 +138,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 		delta = ktime_to_ns(kt);
 		err = ops->adjtime(ops, delta);
 	} else if (tx->modes & ADJ_FREQUENCY) {
-		s32 ppb = scaled_ppm_to_ppb(tx->freq);
+		long ppb = scaled_ppm_to_ppb(tx->freq);
 		if (ppb > ops->max_adj || ppb < -ops->max_adj)
 			return -ERANGE;
 		if (ops->adjfine)
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 0d47fd33b228..51d7f1b8b32a 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -235,7 +235,7 @@ extern int ptp_clock_index(struct ptp_clock *ptp);
  * @ppm:    Parts per million, but with a 16 bit binary fractional field
  */
 
-extern s32 scaled_ppm_to_ppb(long ppm);
+extern long scaled_ppm_to_ppb(long ppm);
 
 /**
  * ptp_find_pin() - obtain the pin index of a given auxiliary function
-- 
2.31.1

