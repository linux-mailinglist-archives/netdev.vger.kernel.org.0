Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C699A300A2A
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 18:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbhAVR3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 12:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbhAVPt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:49:26 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AD3C06121E;
        Fri, 22 Jan 2021 07:47:48 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id p13so7050627ljg.2;
        Fri, 22 Jan 2021 07:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ej/vX1nAudOHlcsj/wkk0E6CPzhd1z5jtaipD1+YZts=;
        b=AkAM03jGtCitne0blJcZVBymlpzWFXoPm31Mzrx2LCCOc5n1MrQHXG6IQFknELgqZM
         twu9eQUgCZi8VZmUx/Sc5BJQhdFLvYcZtJFI2lTYNY+jM3GyxSgZzI/YrNz4nQ4baypd
         3SwjSRZ6l6egctCX1GJBa3xW7JYseHYKqSAPnoNJQNmSWLdRYQtlXm8Y5+tePhTM5wnW
         Z6RtDo6NK8Dse50BigHXzARqBEdeSZmZY/SWaAKFx4X2LhfRZNJPrigFG6NeDBbqk6dj
         Bdq55JYx8h6MrjyGlucerPn6yr/rKWAMuGbU1Z9AXMrNdAMa2jADp+uZqroK1Z+fcTDF
         8AJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ej/vX1nAudOHlcsj/wkk0E6CPzhd1z5jtaipD1+YZts=;
        b=TyWfagGXMb5USWZv/7buRAGjIvbpaAkoj+pBeFtnusVLF8X2Q9Ck+R5tI4yvttk7Fk
         5GxAhHY6eiVx3wie9skoTzPTHSg/UhJg1dTyTsQg2QYBJo3BlUg6I7Oc2dp1tBPhUBAy
         Zpe9QDneEHC/Lp2kjQPwyJoF7u6+duW0wwyDtb31PgkWKaBD8T373xCZUuFR7dhiPFbB
         SS+LMkB0rl2SEcRzcoysBqFFeZbbEv/jGarS86yuzanO6uIq/4QystkCSJKgQ6i2uNT3
         IZOvlfWyYTNnomZxnD7nkl74DjXe8r3Ujwt/8mTLcyxGcu2LsBW4gl97hByldxp0x4gr
         TtEA==
X-Gm-Message-State: AOAM533+W9a5H7VVhKiVKvv/ett/ZsaKHpFjEOQWfajJ7gvkP0TWYlV1
        Pxbv+xBYGObBiR3Ob+jd9KIFW2NTHO9HeA==
X-Google-Smtp-Source: ABdhPJwZNvLfQapELB95eEZieSnJ04GovHOPWXWo1/ZOFCFs+Gp+KvulRs0xlP0jKDHSh1QDyIZ0SQ==
X-Received: by 2002:a2e:959a:: with SMTP id w26mr564631ljh.113.1611330467334;
        Fri, 22 Jan 2021 07:47:47 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:46 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 12/12] selftests/bpf: avoid useless void *-casts
Date:   Fri, 22 Jan 2021 16:47:25 +0100
Message-Id: <20210122154725.22140-13-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122154725.22140-1-bjorn.topel@gmail.com>
References: <20210122154725.22140-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

There is no need to cast to void * when the argument is void *. Avoid
cluttering of code.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index a64e2a929e70..99ea6cf069e6 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -416,7 +416,7 @@ static int validate_interfaces(void)
 				exit_with_error(errno);
 
 			targs->idx = i;
-			if (pthread_create(&ns_thread, NULL, nsswitchthread, (void *)targs))
+			if (pthread_create(&ns_thread, NULL, nsswitchthread, targs))
 				exit_with_error(errno);
 
 			pthread_join(ns_thread, NULL);
@@ -923,12 +923,12 @@ static void testapp_validate(void)
 
 	/*Spawn RX thread */
 	if (!opt_bidi || (opt_bidi && !bidi_pass)) {
-		if (pthread_create(&t0, &attr, worker_testapp_validate, (void *)ifdict[1]))
+		if (pthread_create(&t0, &attr, worker_testapp_validate, ifdict[1]))
 			exit_with_error(errno);
 	} else if (opt_bidi && bidi_pass) {
 		/*switch Tx/Rx vectors */
 		ifdict[0]->fv.vector = rx;
-		if (pthread_create(&t0, &attr, worker_testapp_validate, (void *)ifdict[0]))
+		if (pthread_create(&t0, &attr, worker_testapp_validate, ifdict[0]))
 			exit_with_error(errno);
 	}
 
@@ -943,12 +943,12 @@ static void testapp_validate(void)
 
 	/*Spawn TX thread */
 	if (!opt_bidi || (opt_bidi && !bidi_pass)) {
-		if (pthread_create(&t1, &attr, worker_testapp_validate, (void *)ifdict[0]))
+		if (pthread_create(&t1, &attr, worker_testapp_validate, ifdict[0]))
 			exit_with_error(errno);
 	} else if (opt_bidi && bidi_pass) {
 		/*switch Tx/Rx vectors */
 		ifdict[1]->fv.vector = tx;
-		if (pthread_create(&t1, &attr, worker_testapp_validate, (void *)ifdict[1]))
+		if (pthread_create(&t1, &attr, worker_testapp_validate, ifdict[1]))
 			exit_with_error(errno);
 	}
 
-- 
2.27.0

