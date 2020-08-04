Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AEF23C243
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 01:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgHDXnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 19:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgHDXnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 19:43:24 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E218C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 16:43:24 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id q4so27921065edv.13
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 16:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+EBwEPPyMcuPR3M/VDK4+BeWyJSbXob+3EH1ij9zjSo=;
        b=XrFUFGiA2pG6py7FiFbryKlx00XgcFu2VECSqmvDWJ0N8n+LP0NyRzQfZN/B44IPO4
         QhsVbV2zO039kwUDV8X0iBWEqrbXrrxHkZeCuZDroU7DIDPp41Ucw798F61Sjtah7JYy
         xaChSSWo8JL23Tcln9q+8bYp7roaL1r+bFwuYcO5Kqdhy5+2gM8Luyz3O719itf05YYf
         4JB0CE60fFKUt9RT4pzKdNal0zxSsWHfb/iM0lLl5EmtQOZ2ZdCuib3Ocf9uEulHXRLi
         cFSdwJwoeHw7YFKnOoUpHJbWpE5p6DIdFoBtih9+oxJlbplQ6fGv4Q2ljC1MSZSmi1Ic
         Hv3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+EBwEPPyMcuPR3M/VDK4+BeWyJSbXob+3EH1ij9zjSo=;
        b=iEax5f4z/zSv/l9lXCX926kSwLjcoHPlfez+J8/9Iwcc8PNvNmXzMNFDaf/U9RD8KE
         kkzRmDlTaqGT8fU6W3RVhZbFd5DFTQqGGStJ/oGez/JozuYsqu/PevD6gpIdWKF2J4e5
         CsZ0QKsMhGAJghuFvHJskJ6byQc7Mp/MU2nxkFkbZxc4O1rkVgbwX5KWtj298udYtphr
         ZHn63umEYXg+7VdA9KRzco7YEoRBBrNAW/K4OAbkiLAPm9JWYlyvVwFLyc1lXZDcKUFz
         q2xWaIWenxCeO1vZWsHa0MN4rfqO8Gpip3AU+0gXiBHJOF5Gk34jGslkgcfh7jOJr3Ff
         qqyw==
X-Gm-Message-State: AOAM5321jlAauw7QEdE1c4FMMNkZCmo+G9Q6/51r7AIGLxNQvMg4TxjI
        5VF8FPVSkPPCwuCt6kKrEX6RJpsD
X-Google-Smtp-Source: ABdhPJwr9CcvTdGxE8ICjocomE/0cRtM8LAX/0xNgvvDwGbrDxywD5OwwvWRkcRztyKmzfrrHjxjfA==
X-Received: by 2002:aa7:db44:: with SMTP id n4mr353169edt.158.1596584603331;
        Tue, 04 Aug 2020 16:43:23 -0700 (PDT)
Received: from localhost.localdomain ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id d11sm274020edm.87.2020.08.04.16.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 16:43:22 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, jacob.e.keller@intel.com
Subject: [PATCH v2 net-next] ptp: only allow phase values lower than 1 period
Date:   Wed,  5 Aug 2020 02:43:08 +0300
Message-Id: <20200804234308.1303022-1-olteanv@gmail.com>
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
Changes in v2:
Be sure to also deny the case where the period is equal to the phase.
This represents a 360 degree offset, which is equivalent to a phase of
zero, so it should be rejected on the grounds of having a modulo
equivalent as well.

 drivers/ptp/ptp_chardev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index e0e6f85966e1..ee48eb61b49c 100644
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

