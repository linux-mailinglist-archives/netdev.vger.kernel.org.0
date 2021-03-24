Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD0F34844E
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbhCXWBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbhCXWBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 18:01:42 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80415C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:01:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so76010pjv.1
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5pc8ZaBCHr7eL+V5L6+s6agRPyl9R4Zce4bi5Bo8SAw=;
        b=rSEI+UBtezOx4ydqUpuJ1B4xxGLFtwpudIRv6K7jC2oFN5tIukErq2FN58oIvGAPTC
         N7pPzlXh0ftKNPcLqoxUmTYilDXSVnYqgkHqbuwJC5RDGpbJckXuNVXZk+s5FfMNLbNF
         EtQ1TW1uuVV+1YnYqelkwjKXZvxB1tEWyMfwLEtAl8Wub0T/a/romcs+MPuJpGX/Dt52
         rmQOKoAHg+sGADeJuxCOFOssjpb7wKUpG3snd0vuKJD8+4OBCnezjEjQO1nIeNUOks/r
         BgdCK88227fARuuKm08GFmKRDcF/+xE7Bzi1mRB9K14ZsGheb1eL6mjh/bIdvmb6wNmr
         P6lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5pc8ZaBCHr7eL+V5L6+s6agRPyl9R4Zce4bi5Bo8SAw=;
        b=h64/VRhDL0nzZslD/IRmNoUEQstd3kU5NeTT3rVrbAmvXfgxM88BMHtdfPbF1f+vDY
         gqMwqTl5eRXnqug2HMirV5iyQbKv+asGkB53KAGoxntznZVb++T9c3MxRhJFlQ0L0moc
         7RGL72DLp0hNhf3dMrGl+0mx1qzgGKYFHaLbeKIqmSY94Ec2rPpPfG4vP8mVVTxozR+P
         r0Wi+rYBpebJCTILLPurn3d4Tnv7BmJhm8GgPxAYNnXiRJvcTXyvoFWTVom6fnyyNZdV
         Au4npfiExiy400q40p9kU0jLVXxjvwcwuAKmsWC3uSjLl0bTca6gGXj8utpvErmLM+0J
         c1ng==
X-Gm-Message-State: AOAM532WaAHMHyZY/bP/tApPHShYPaphLHGJgmZk/+8SrrvBr2ZehlcN
        dzht165OdkbmCLKmZu9NsDc=
X-Google-Smtp-Source: ABdhPJycTxcJogxBUmlUyMxOLLjvL2xbRGRINbdW0+I8C9ln4FoPeg8lpW0aKmqWKswQsDOmPcko6g==
X-Received: by 2002:a17:90a:c981:: with SMTP id w1mr5713488pjt.176.1616623302153;
        Wed, 24 Mar 2021 15:01:42 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c4c8:29f1:3d1:8904])
        by smtp.gmail.com with ESMTPSA id s19sm3532068pfh.168.2021.03.24.15.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 15:01:41 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] tcp_metrics: tcpm_hash_bucket is strictly local
Date:   Wed, 24 Mar 2021 15:01:38 -0700
Message-Id: <20210324220138.3280384-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

After commit 098a697b497e ("tcp_metrics: Use a single hash table
for all network namespaces."), tcpm_hash_bucket is local to
net/ipv4/tcp_metrics.c

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 70a2a085dd1aecc0b4cbbe9d2f678bb53bd84051..9e3cb2722b804bc6618632128185c311e5210146 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -11,7 +11,6 @@
 #include <linux/rcupdate.h>
 #include <linux/siphash.h>
 
-struct tcpm_hash_bucket;
 struct ctl_table_header;
 struct ipv4_devconf;
 struct fib_rules_ops;
-- 
2.31.0.291.g576ba9dcdaf-goog

