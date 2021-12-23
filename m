Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4CE47E985
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 23:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350463AbhLWW12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 17:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350617AbhLWW0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 17:26:19 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA33C0698E5
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 14:24:50 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id s16-20020a17090a881000b001b179d3fbf3so4222730pjn.4
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 14:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tpM3RVmbzhTcEvjWc4fMD4AvByCzQpfmOFOfWA2dO5w=;
        b=lbzsQAeJwfFPTpQIFSZ1MrmCtu4BiWzo+HbzIzAr4CMKoTU4V+FgpsOFoZNlSv445X
         x43bfVsCaf6IPMXwRKslXA/K7ZwZxMs20HAMHgUNHAZ3wa5SGs3RwpZ0Ppzqubs4FMzP
         9IdkkgKZimkjcDAOtuVt42NqJkpAam0F8GICdftiOUwpoXk8qZM4datGhKIswddxmUYM
         UPhsJLqYPnggXt8m9GINyBVv0Y6gY/fbujQeU2fnvrw7bCb9AMTKRdRa27qDIXHGJ78R
         N9SxnnksecuATXHC9UsaTgsKtTxCpguW8b8uhl5iUWGtWUeS0mYTmmiHQEKAPObX3On/
         fc6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tpM3RVmbzhTcEvjWc4fMD4AvByCzQpfmOFOfWA2dO5w=;
        b=O4iJrtjErp25A96KeuwayBb2IfEGQZv5N2OBMkykULXYM2dgQrcHrwProUGrs5GwfZ
         e/zqAAa8q+svy90pGwNQ4TUpWO4RHJy8VJBwn156+a3GjYZ3nFQTxE0rYwnJ776it7RX
         P4mNe3mAeyMJbyIHaPEn00awX81ElRJLFOFWEL7g62/UHF/DwmFRTR4pE5tdxu5VzbQa
         +ULOLX7FOUjbwTuFDbIkWaRNu3hyUYA1iWuyXNverBm6sX0Hs0eNv7wlQtgBebxXgqk/
         h6aX6PS8yzbG9amduEqlOjGQgqUsZ2HnPlm22/kJZGScMrZxpD1AQns2h8juecTU+jQh
         Ed/g==
X-Gm-Message-State: AOAM5330ov0iljpVRG+mXbn0Pw7tzGGe4iJ/+k/A6NbeN5AfWF4LCB7u
        VU0VjoTZ3dsWtfqmbo/o9B8vKifOr66WYkf1gugnsYdLhrJzai10Fh3ClOGnLy9zSh4MEjw36XE
        hUzbfN5bk2yr0Q8CT4y4w2bCm7ZfIfd7wvO2m7AJdMGmVeA6Ijs0BABuPwG0OSDjBDgSzpQ==
X-Google-Smtp-Source: ABdhPJxsS5wWX7pV/cdP7ayYnMUh4iNIflXFepEu7BO8GNisYcVAeNnHEuW+ASkaAcgmwRutapxV4r5u7e60ZEg=
X-Received: from coco0920.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5738])
 (user=lixiaoyan job=sendgmr) by 2002:a17:90a:c203:: with SMTP id
 e3mr739963pjt.0.1640298289369; Thu, 23 Dec 2021 14:24:49 -0800 (PST)
Date:   Thu, 23 Dec 2021 22:24:41 +0000
In-Reply-To: <20211223222441.2975883-1-lixiaoyan@google.com>
Message-Id: <20211223222441.2975883-2-lixiaoyan@google.com>
Mime-Version: 1.0
References: <20211223222441.2975883-1-lixiaoyan@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH net 2/2] selftests: Calculate udpgso segment count without
 header adjustment
From:   Coco Li <lixiaoyan@google.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Coco Li <lixiaoyan@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The below referenced commit correctly updated the computation of number
of segments (gso_size) by using only the gso payload size and
removing the header lengths.

With this change the regression test started failing. Update
the tests to match this new behavior.

Both IPv4 and IPv6 tests are updated, as a separate patch in this series
will update udp_v6_send_skb to match this change in udp_send_skb.

Fixes: 158390e45612 ("udp: using datalen to cap max gso segments")
Signed-off-by: Coco Li <lixiaoyan@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/udpgso.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso.c b/tools/testing/selftests/net/udpgso.c
index c66da6ffd6d8..7badaf215de2 100644
--- a/tools/testing/selftests/net/udpgso.c
+++ b/tools/testing/selftests/net/udpgso.c
@@ -156,13 +156,13 @@ struct testcase testcases_v4[] = {
 	},
 	{
 		/* send max number of min sized segments */
-		.tlen = UDP_MAX_SEGMENTS - CONST_HDRLEN_V4,
+		.tlen = UDP_MAX_SEGMENTS,
 		.gso_len = 1,
-		.r_num_mss = UDP_MAX_SEGMENTS - CONST_HDRLEN_V4,
+		.r_num_mss = UDP_MAX_SEGMENTS,
 	},
 	{
 		/* send max number + 1 of min sized segments: fail */
-		.tlen = UDP_MAX_SEGMENTS - CONST_HDRLEN_V4 + 1,
+		.tlen = UDP_MAX_SEGMENTS + 1,
 		.gso_len = 1,
 		.tfail = true,
 	},
@@ -259,13 +259,13 @@ struct testcase testcases_v6[] = {
 	},
 	{
 		/* send max number of min sized segments */
-		.tlen = UDP_MAX_SEGMENTS - CONST_HDRLEN_V6,
+		.tlen = UDP_MAX_SEGMENTS,
 		.gso_len = 1,
-		.r_num_mss = UDP_MAX_SEGMENTS - CONST_HDRLEN_V6,
+		.r_num_mss = UDP_MAX_SEGMENTS,
 	},
 	{
 		/* send max number + 1 of min sized segments: fail */
-		.tlen = UDP_MAX_SEGMENTS - CONST_HDRLEN_V6 + 1,
+		.tlen = UDP_MAX_SEGMENTS + 1,
 		.gso_len = 1,
 		.tfail = true,
 	},
-- 
2.34.1.448.ga2b2bfdf31-goog

