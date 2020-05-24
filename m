Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458911E0172
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 20:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387966AbgEXS1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 14:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387823AbgEXS1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 14:27:14 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7248EC061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 11:27:13 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x11so5664432plv.9
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 11:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lybw8ZjwZhFEDmV0r5VRTJrCEAstta1fj3BSbz4j6Ig=;
        b=fjahGKmEUA3EYoF+L417nV1woyErTOYkCKjzYXLp7zuWVXLsLzDaMRbNZu3ADr1naa
         cz21pCAYE18l03V376PozVA7grbCjvnIpA9XjwZ3OIkbWHsTI91wwKDvjk5NLfBUrC9y
         UPUwDLm9SW7HDKYPf8e0khISGDEs5KBMJK6qjU+ipbzId40wVkoWhQHj8tojj5MqBIOf
         Orj1S1nnIvG0HJjYd6ruazvIbcYX0drTGyCGzZtlWUkgcchOm7kZhOv/ipn3Fa7OIeQj
         xDUuM5aLu2mYvCkYm1DtsMjlTFnZHuSBok4guyp/8RYGsfKbPLcF8V/b6u+PAzkpwC7d
         +awQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lybw8ZjwZhFEDmV0r5VRTJrCEAstta1fj3BSbz4j6Ig=;
        b=WP1av8EF7Pg6ykApdtiL4jxH6T8tYp7xkVtMqnydTN0hBQSiDSPXPKKlRmhnwyK8zb
         h4iaG/hHHyCNqYX9kW8v//Rh95o/kUKYxrSVqGervRrZJ3EbQT1LDvKENTgXahbP7oP1
         ak7rywTFO8xMlpu7Mih3TVk/m0POEzKoI6HgAk4mWS+3Dl2wRT/XDax+4QYrN6t7YkLZ
         IzxOMMAggFxpcFBTb2eo26+HwiLQRhos+IAu6lFqUcsD4u5o1vOGMEmE8ZodOU8/bZ0j
         yWfOyV75YvLJZhn6zH2gwQjEPZtaDTKNsYuQLu+ddW6yJwaUfD4ZTeipFoN4VGX8dotT
         brIw==
X-Gm-Message-State: AOAM532jebJV0cjZEIW5Dj6KzgZ6QHAEcwXr3lgB2pz0VHKkUYPnXkej
        zff8rpM8GbTJvhvPpZqjeamywZl5cNU=
X-Google-Smtp-Source: ABdhPJwz78P72UL1APVZnbsv7GgG0EBMmjAOGZbxeyzxKlNYOqQDz5ByzlViBjjwFIcihVQdEYw5Tw==
X-Received: by 2002:a17:902:8e87:: with SMTP id bg7mr24275032plb.91.1590344832821;
        Sun, 24 May 2020 11:27:12 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id p8sm10352990pgm.73.2020.05.24.11.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 11:27:12 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH net-next V2] Let the ADJ_OFFSET interface respect the ADJ_NANO flag for PHC devices.
Date:   Sun, 24 May 2020 11:27:10 -0700
Message-Id: <20200524182710.576-1-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 184ecc9eb260d5a3bcdddc5bebd18f285ac004e9 ("ptp: Add adjphase
function to support phase offset control.") the PTP Hardware Clock
interface expanded to support the ADJ_OFFSET offset mode.  However,
the implementation did not respect the traditional yet pedantic
distinction between units of microseconds and nanoseconds signaled by
the ADJ_NANO flag.  This patch fixes the issue by adding logic to
handle that flag.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_clock.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index fc984a8828fb..03a246e60fd9 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -147,8 +147,14 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 			err = ops->adjfreq(ops, ppb);
 		ptp->dialed_frequency = tx->freq;
 	} else if (tx->modes & ADJ_OFFSET) {
-		if (ops->adjphase)
-			err = ops->adjphase(ops, tx->offset);
+		if (ops->adjphase) {
+			s32 offset = tx->offset;
+
+			if (!(tx->modes & ADJ_NANO))
+				offset *= NSEC_PER_USEC;
+
+			err = ops->adjphase(ops, offset);
+		}
 	} else if (tx->modes == 0) {
 		tx->freq = ptp->dialed_frequency;
 		err = 0;
-- 
2.20.1

