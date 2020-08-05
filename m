Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1EB23C27D
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 02:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgHEALJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 20:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbgHEAKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 20:10:55 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1197C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 17:10:54 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id m19so3889893ejd.8
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 17:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j7rZ8p2GZencu66yJG5+DPYHbpAJFdMc1YXaPhGLtD4=;
        b=g2BBDhGP/tZONhoKuuLJV8rmwkysjkzpfpkrQEqc2b+Ufu6tl3dv3g38JWffogU2vx
         7iLGakJkm34B4QXqnSVmY35lhMz55cmbmBk7t4mM44siwmMdaaKepERpY2hKqmfLXCWR
         JtZRpmjJvZygkcCqHHeCTaJ0FqBx1jUV4v3E+zRZbXXommqQ6oh+qXx12DdDtyzkB2Bp
         9IdVih/ox3jSfAlI7m2aFara7IgMUuzzfyakTiOowjAuLVxDOiABihH/n6KcLOTBabxR
         EA8w+OoH5xn4cdDJHv1I13UKbrB6hz/QCyC14LEV8zfs+JjYpyZoI2QteIo/3YFd2HUq
         QcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j7rZ8p2GZencu66yJG5+DPYHbpAJFdMc1YXaPhGLtD4=;
        b=CvUuIZqcvddDddtgQ3gbMIWjvronGlUKmlyuzpAZBQWM6wzmSo8l6gHvLc5M+rBUna
         eIJIptruutv95yCwVc7FQJ4x6fgbOkW3VPreH3AwHm2z4wZE8PzCv4KYr/5JbFmERpc4
         xsnuaEqT0LgY444W+qC4LzQbeANlt28RTaLVdwapK0DTLlA/Cw9hRUJgULqQZgxA15Gu
         P7bn6QZML9BjCnMUHlgRX1sQdlmYdeyptzb5tLuY+oUYfblWyz3IIN+T7XrdhFRCeUfZ
         8gFOBX6DWBP2YR0kBtuYhQxHlcIRr68SLaVfF/eQVJfXGo2WGc+zXUvcGgTPTd3PX+7F
         LJMA==
X-Gm-Message-State: AOAM530a7h77KiUb843bvEKhWrttLhsHwhaN2GzfHcBuqoDu34Ox3AOM
        sNwoahbNeIEIHRo6ZWaHCahEgDrq
X-Google-Smtp-Source: ABdhPJw1VCJ8VSSkl9eJXsigwIuYvxtO2FMQqKuiBadKtwYSUKNPHBjQ/bSr7QY/7nguveqIwSi2BA==
X-Received: by 2002:a17:906:444e:: with SMTP id i14mr635191ejp.418.1596586253556;
        Tue, 04 Aug 2020 17:10:53 -0700 (PDT)
Received: from localhost.localdomain ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id s2sm329203ejd.17.2020.08.04.17.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 17:10:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com
Subject: [PATCH v3 net-next] ptp: only allow phase values lower than 1 period
Date:   Wed,  5 Aug 2020 03:10:47 +0300
Message-Id: <20200805001047.1372299-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The way we define the phase (the difference between the time of the
signal's rising edge, and the closest integer multiple of the period),
it doesn't make sense to have a phase value equal or larger than 1
period.

So deny these settings coming from the user.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:
Adjust the comments to cover the equality case.

Changes in v2:
Be sure to also deny the case where the period is equal to the phase.
This represents a 360 degree offset, which is equivalent to a phase of
zero, so it should be rejected on the grounds of having a modulo
equivalent as well.

 drivers/ptp/ptp_chardev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index e0e6f85966e1..af3bc65c4595 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -218,6 +218,19 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 					break;
 				}
 			}
+			if (perout->flags & PTP_PEROUT_PHASE) {
+				/*
+				 * The phase should be specified modulo the
+				 * period, therefore anything equal or larger
+				 * than 1 period is invalid.
+				 */
+				if (perout->phase.sec > perout->period.sec ||
+				    (perout->phase.sec == perout->period.sec &&
+				     perout->phase.nsec >= perout->period.nsec)) {
+					err = -ERANGE;
+					break;
+				}
+			}
 		} else if (cmd == PTP_PEROUT_REQUEST) {
 			req.perout.flags &= PTP_PEROUT_V1_VALID_FLAGS;
 			req.perout.rsv[0] = 0;
-- 
2.25.1

