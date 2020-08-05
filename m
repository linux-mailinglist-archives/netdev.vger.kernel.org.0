Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6079D23C7F5
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 10:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgHEIkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 04:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgHEIkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 04:40:51 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDBDC06174A
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 01:40:50 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id r19so11869565qvw.11
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 01:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RO8Jio3kq7Y+G+U7LkU9VvaOjqKK/4XtVqPcCt1tiTg=;
        b=RPXIFf1SZCQzz5ocZgecGMJtOqIj6xworncIb9v4a6oEkdMYU128eXckvmkXZat23v
         6iOV1r5J0l8BUc4HUq19fjSU2USiJfZMD9wRQewFxE5SqVv0e0mnwoHjQf366tlPcZW+
         1LtbZrtYOT8ZswmZV8gyXqtRt8DHqvd8cH64jfhKaCidCPyJ88GdToXH9VoS+uu5Pjxa
         G/rd89ezpJgmTEU71wu6Lvzoa+IMgK+Mg1IkYY3P2HKXT5GUH62wt7qZGOXXx8MVEmme
         Hr23QR/RU8/pRfJ2mu0aQs7zOjAbO/YJROzKgYtfIgPSRAo0KYOLEm/SSxSXsyTpc1eW
         vAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RO8Jio3kq7Y+G+U7LkU9VvaOjqKK/4XtVqPcCt1tiTg=;
        b=ABsxNmOGdDvbe14ZNdua6MqcuYom14Tr021GlbkaYtIbalE8VkuD/4Lg0IOilZcb05
         Rt2KArHMzPnfRiZd7lVcvsF1Fdj2OCTgMmmIxy/caNGjVeejT/mezCH0DHTUN/65u7UO
         YaucnqDtAi6jXYAgCWR9wcX67ar9wB7Vp+5uZgQj1HQ4RqxxiuQCPuMh0QU9bDwZm5kX
         yNElmQAwnItF4f+xvUVMP3lDmFNO14J8Ta1hiUhHNaf3da9n2MYDwDXg5ItV3evGx6E8
         toSIfNgjl+X+IRuYTzC6Wwzl3TgPt7NV8v70hU2uHyffO/hVkYAUkkdoakLPyJr+8H50
         wpXw==
X-Gm-Message-State: AOAM530gC7T1UesABUTAvNBu5kpbVaK6EdMC46sUjcZSXxvKgmlYRDhE
        1Vs7+NR8mp8DdnTtImbqh3knB61SSPs=
X-Google-Smtp-Source: ABdhPJylYBQDT39tth/PlV54xQ1Kh6hflTXP5FB1I2D36ytnizHGRFIQtvjbcOEEiICXpVmM4Gh3Cg==
X-Received: by 2002:a0c:9c03:: with SMTP id v3mr2540764qve.34.1596616848201;
        Wed, 05 Aug 2020 01:40:48 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id 71sm1073513qkk.125.2020.08.05.01.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 01:40:47 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, eric.dumazet@gmail.com,
        Willem de Bruijn <willemb@google.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH net] selftests/net: relax cpu affinity requirement in msg_zerocopy test
Date:   Wed,  5 Aug 2020 04:40:45 -0400
Message-Id: <20200805084045.1549492-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

The msg_zerocopy test pins the sender and receiver threads to separate
cores to reduce variance between runs.

But it hardcodes the cores and skips core 0, so it fails on machines
with the selected cores offline, or simply fewer cores.

The test mainly gives code coverage in automated runs. The throughput
of zerocopy ('-z') and non-zerocopy runs is logged for manual
inspection.

Continue even when sched_setaffinity fails. Just log to warn anyone
interpreting the data.

Fixes: 07b65c5b31ce ("test: add msg_zerocopy test")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/msg_zerocopy.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/msg_zerocopy.c b/tools/testing/selftests/net/msg_zerocopy.c
index 4b02933cab8a..bdc03a2097e8 100644
--- a/tools/testing/selftests/net/msg_zerocopy.c
+++ b/tools/testing/selftests/net/msg_zerocopy.c
@@ -125,9 +125,8 @@ static int do_setcpu(int cpu)
 	CPU_ZERO(&mask);
 	CPU_SET(cpu, &mask);
 	if (sched_setaffinity(0, sizeof(mask), &mask))
-		error(1, 0, "setaffinity %d", cpu);
-
-	if (cfg_verbose)
+		fprintf(stderr, "cpu: unable to pin, may increase variance.\n");
+	else if (cfg_verbose)
 		fprintf(stderr, "cpu: %u\n", cpu);
 
 	return 0;
-- 
2.28.0.236.gb10cc79966-goog

