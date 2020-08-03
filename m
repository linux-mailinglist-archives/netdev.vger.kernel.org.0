Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C883E23ADC3
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 21:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgHCTtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 15:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbgHCTtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 15:49:32 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27596C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 12:49:32 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id c16so19519603ejx.12
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 12:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jgwyR9nDQLXkF0Y0c5Qvzx5CD7t+6mnBGVVhqC0Q7N8=;
        b=f3CtAcPmXjjT9EOIk4KHfzQaEfoqGPv2GhVoJDgiimXZ3Ekczg88gGfnpBwegVKb/E
         BQMbpemktyl/n3SW7ptgpT9SbaY7PLliUwBzzG7/sRpLiZivjB5eIo9bomq6Xu14Kl4L
         oyLEMCIUQPM2+j2pwsDCM+LKuVquqBM3Ch0kdfluxlId1JGH91w8Ec9lDghfq8IcKwrx
         KL55jQKPMqZXqFJ2YW7h9SEJ04xv+So8FncnnKflCJWEAPwYNkCy6VYHY1mmU6PAW1D/
         wVz1nSUL86ZlgFpEZDMGbbiHW+Prr1k4V48mA1oixJyLDf3qFQrtr8POU1Z8fPWVooBp
         PicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jgwyR9nDQLXkF0Y0c5Qvzx5CD7t+6mnBGVVhqC0Q7N8=;
        b=C555+UusXSOpZHLn6vRpFyVF++fj+7ncIqVyWtOn3vVSzMWdtf9Fonb7gCnXYvpqxS
         kjgcPJ1XI8chj9KQnXNSRrKv6UA7G3OEeVxK+NGaJKBI7Qjm2/QWR/3tm/Hmr9RNcjTI
         EWyFRayNEuk+12ZRsW7jQcpSgqkYVIpMvjBFaeGGmC1d2bFagID6H36mvBPp1Ki+Z2Wz
         cUASHs0HPt2wUQ+ClXwq2YScIpPyF38SdeuyUyeJm8EoCAJXAth3NI0u4T6k0qdyJTZ1
         SSp21ECrIHD9rfPmoaCl/uf28NZEkvyWpWiudf49y2MbjTPhDRdIsdnPTNGR3vhiWXum
         Kerw==
X-Gm-Message-State: AOAM531vtiqkgbluq+0bVZstnUT32nSw/ZzIupdbxBYpfDWFCkmRv5sN
        ZMyAOuyPy4wSCFAW29FQQs4=
X-Google-Smtp-Source: ABdhPJxO851HxiDyMZCfa4qcOzBvegOTy8MY2AYzc0h39Aht6/icP/xosixDbUeoTgIZg/yX54FudQ==
X-Received: by 2002:a17:906:cc4d:: with SMTP id mm13mr17650589ejb.191.1596484170827;
        Mon, 03 Aug 2020 12:49:30 -0700 (PDT)
Received: from localhost.localdomain ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id gl20sm16897584ejb.86.2020.08.03.12.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 12:49:30 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com
Subject: [PATCH net-next] ptp: only allow phase values lower than 1 period
Date:   Mon,  3 Aug 2020 22:49:21 +0300
Message-Id: <20200803194921.603151-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The way we define the phase (the difference between the time of the
signal's rising edge, and the closest integer multiple of the period),
it doesn't make sense to have a phase value larger than 1 period.

So deny these settings coming from the user.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/ptp/ptp_chardev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index e0e6f85966e1..02fcd5e8b998 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -218,6 +218,19 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 					break;
 				}
 			}
+			if (perout->flags & PTP_PEROUT_PHASE) {
+				/*
+				 * The phase should be specified modulo the
+				 * period, therefore anything larger than 1
+				 * period is invalid.
+				 */
+				if (perout->phase.sec > perout->period.sec ||
+				    (perout->phase.sec == perout->period.sec &&
+				     perout->phase.nsec > perout->period.nsec)) {
+					err = -ERANGE;
+					break;
+				}
+			}
 		} else if (cmd == PTP_PEROUT_REQUEST) {
 			req.perout.flags &= PTP_PEROUT_V1_VALID_FLAGS;
 			req.perout.rsv[0] = 0;
-- 
2.25.1

