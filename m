Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A0A207C40
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 21:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406232AbgFXTdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 15:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406228AbgFXTdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 15:33:42 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4086C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 12:33:42 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id 35so1486906ple.0
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 12:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ftSu/kOZWKw5jgyw0bCh+wT9G0qkimTu6dypG9o4s48=;
        b=uraWG1pREtYTcNJupFi7/7cc65utqbIFZfZamVgQ3Yb4OFU18ZRVUfKpgNMPnvSnTr
         cHouO6+mWo4iDAMr6l6dfORoa7nSOk+mRbdOzqot8eWnXEOj29BcMkraJax1XT1qH0P4
         fa+OxXD96EOn7zAh7jDGyOf6TXcUdVuXOGP5vf/6LbDJO0jUBsWRPIoNDef45pZTSZdS
         hGkBN38wDvxsfeHbTZhmjBRYca3+5qo7Z3kSpZiWcXvcBRv/HL/mCZGF/ksUvT404uJv
         jS28Wk5aOdJYP54+14yONYdDej94sMaYogW7zSDGf3pI6O/sf6NSqndX9XuzWFYS4bqb
         /4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ftSu/kOZWKw5jgyw0bCh+wT9G0qkimTu6dypG9o4s48=;
        b=e3VmQtJ4J2S1nqeA+V92fUMpf+kdKCR67GbcDzK+kYGzpbcyHTxo6gTalEgvuQ7thl
         +r6XihR5WruThdNMmF7Cwl13aNPFIdmSTBB+OHFTa/FqW8YjGACiOjLLkJFmz7F4lMEw
         +hfvhiTfxnC9DNZrFK4/ejVwIZS3QUm52dik7kYBQLaVaGkXK3Z6RyULiJD/ZTaVknk8
         0WxxRhq2q1VZOQefAYqdqP15DFRxxWgCmj6+lxNqtA0STusqSr6m88O4z+czxlcGa+30
         Rliylke+Nir3ThD1BG/lkm+9QrBzc422z31VGDAAsAQoTfE2HCi/5l8Kvdgj9hG7G9Q5
         u+Wg==
X-Gm-Message-State: AOAM530epnWCCnvdfprvTVIwHKDSgNLL7w7yOFpQUOE38HE8MGnBjl6C
        JgA9fp7t/W5he81gBGDDsxs=
X-Google-Smtp-Source: ABdhPJzq0EaJ8R2yMGYqc7GfyK0Zk/xFPXmXd1cn8s6HfDqzGYpCfzEUbARQR+DJNdsOAziWYpOWYg==
X-Received: by 2002:a17:90a:22ab:: with SMTP id s40mr802241pjc.27.1593027222104;
        Wed, 24 Jun 2020 12:33:42 -0700 (PDT)
Received: from oort.localdomain (c-73-240-194-254.hsd1.or.comcast.net. [73.240.194.254])
        by smtp.gmail.com with ESMTPSA id m9sm20625419pfo.200.2020.06.24.12.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 12:33:41 -0700 (PDT)
From:   Briana Oursler <briana.oursler@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Briana Oursler <briana.oursler@gmail.com>
Subject: [PATCH net] tc-testing: avoid action cookies with odd length.
Date:   Wed, 24 Jun 2020 12:29:14 -0700
Message-Id: <20200624192913.2802-1-briana.oursler@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update odd length cookie hexstrings in csum.json, tunnel_key.json and
bpf.json to be even length to comply with check enforced in commit
0149dabf2a1b ("tc: m_actions: check cookie hexstring len") in iproute2.

Signed-off-by: Briana Oursler <briana.oursler@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
---
 .../testing/selftests/tc-testing/tc-tests/actions/bpf.json  | 4 ++--
 .../testing/selftests/tc-testing/tc-tests/actions/csum.json | 4 ++--
 .../selftests/tc-testing/tc-tests/actions/tunnel_key.json   | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json b/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
index 47a3082b6661..503982b8f295 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/bpf.json
@@ -260,10 +260,10 @@
                 255
             ]
         ],
-        "cmdUnderTest": "$TC action add action bpf bytecode '4,40 0 0 12,21 0 1 2054,6 0 0 262144,6 0 0 0' index 4294967296 cookie 12345",
+        "cmdUnderTest": "$TC action add action bpf bytecode '4,40 0 0 12,21 0 1 2054,6 0 0 262144,6 0 0 0' index 4294967296 cookie 123456",
         "expExitCode": "255",
         "verifyCmd": "$TC action ls action bpf",
-        "matchPattern": "action order [0-9]*: bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0' default-action pipe.*cookie 12345",
+        "matchPattern": "action order [0-9]*: bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0' default-action pipe.*cookie 123456",
         "matchCount": "0",
         "teardown": [
             "$TC action flush action bpf"
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/csum.json b/tools/testing/selftests/tc-testing/tc-tests/actions/csum.json
index 88ec134872e4..072febf25f55 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/csum.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/csum.json
@@ -469,7 +469,7 @@
                 255
             ]
         ],
-        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action csum tcp continue index \\$i cookie aaabbbcccdddeee \\\"; args=\"\\$args\\$cmd\"; done && $TC actions add \\$args\"",
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action csum tcp continue index \\$i cookie 123456789abcde \\\"; args=\"\\$args\\$cmd\"; done && $TC actions add \\$args\"",
         "expExitCode": "0",
         "verifyCmd": "$TC actions ls action csum",
         "matchPattern": "^[ \t]+index [0-9]* ref",
@@ -492,7 +492,7 @@
                 1,
                 255
             ],
-            "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action csum tcp continue index \\$i cookie aaabbbcccdddeee \\\"; args=\"\\$args\\$cmd\"; done && $TC actions add \\$args\""
+            "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action csum tcp continue index \\$i cookie 123456789abcde \\\"; args=\"\\$args\\$cmd\"; done && $TC actions add \\$args\""
         ],
         "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action csum index \\$i \\\"; args=\"\\$args\\$cmd\"; done && $TC actions del \\$args\"",
         "expExitCode": "0",
diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
index 7357c58fa2dc..d06346968bcb 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
@@ -818,12 +818,12 @@
                 1,
                 255
             ],
-            "$TC actions add action tunnel_key set src_ip 10.10.10.1 dst_ip 20.20.20.2 dst_port 3128 nocsum id 1 index 1 cookie aabbccddeeff112233445566778800a"
+            "$TC actions add action tunnel_key set src_ip 10.10.10.1 dst_ip 20.20.20.2 dst_port 3128 nocsum id 1 index 1 cookie 123456"
         ],
-        "cmdUnderTest": "$TC actions replace action tunnel_key set src_ip 11.11.11.1 dst_ip 21.21.21.2 dst_port 3129 id 11 csum reclassify index 1 cookie a1b1c1d1",
+        "cmdUnderTest": "$TC actions replace action tunnel_key set src_ip 11.11.11.1 dst_ip 21.21.21.2 dst_port 3129 id 11 csum reclassify index 1 cookie 123456",
         "expExitCode": "0",
         "verifyCmd": "$TC actions get action tunnel_key index 1",
-        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 11.11.11.1.*dst_ip 21.21.21.2.*key_id 11.*dst_port 3129.*csum reclassify.*index 1.*cookie a1b1c1d1",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 11.11.11.1.*dst_ip 21.21.21.2.*key_id 11.*dst_port 3129.*csum reclassify.*index 1.*cookie 123456",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action tunnel_key"
-- 
2.27.0

