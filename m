Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0B35A0183
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 20:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239751AbiHXSoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 14:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239576AbiHXSoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 14:44:03 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE3A7AC00;
        Wed, 24 Aug 2022 11:44:03 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r69so15778422pgr.2;
        Wed, 24 Aug 2022 11:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc;
        bh=MtArap2h1wuySunkx0PMUJrqLgN2u8SwHRvsTVAQHMU=;
        b=Rhuj1nS/2uNhVZivF7nq1soq2Ak51csOMzopdsQ4HpEqiBdmG+N+w3ZAiAzTWxYuNZ
         PwYQp24mAf9GTYmg/YcFkrif4QEywAAwvYdpPvszznOr/RHLqoc8mZAuTF4lwF8OvGKl
         zEadEXwp0dvRGttuOxh6WITnLjtkCOHfnp3Smo+ehFmOVGzwTaPoXQQcNrCc8pXLxeB6
         7Ski5uT9lytCLjMajRd434WGviZNgM1dSWn0b3K7oz2+desNA2biRTToJXjc4L+ImP55
         p+9oZP+ZAH0Skb4UBWtKIQmkNwGoIK1etkejuI4ODq9qchlDgFH62bmtcSpzZZ+FvCYx
         tDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc;
        bh=MtArap2h1wuySunkx0PMUJrqLgN2u8SwHRvsTVAQHMU=;
        b=hj4rgHZvmdqSd+rY7hvuW6wLkxnlDOC+Yrnesik8YmycRs5O9k5h6nYdsnC92kGlL+
         rvSWznn8rtn5JCzkZK3pDSGbBEG6IRbmbQNMGe9qtZWuP0PoB8sLTOoxaPt79xN1cTXa
         fKN9cPSkXLgqOQlgMXA9i4P5T6pyhMAVFoQtG6bjn5FONuhSqIDkVQ+ckBwmwSRl9Ffi
         YSKVIadiphmIO/3AzrW2GN7Qc9l4evV8VSvrv9TW1CbArzcxpGuQAaA/R6Br+Hlblayo
         igF7k4FeeHKOJG2/Xo6B9wM8YVEXulGlLTWxWyjZrmbSRtCMqBk+6FcFx/sbc+OmEUhV
         cgoQ==
X-Gm-Message-State: ACgBeo2m3bhXey1F9BEVA3KyplHv1PiNGDxAZG+PoiquIKO+NWHnz9Er
        mveYmVzO9TomB79nm54m5jk=
X-Google-Smtp-Source: AA6agR7iDEMeq/u8DNkEGn/TPaD1pwf0mGbrVe7SLyuvCrnl2u2ohqRGTn+5RY0h9aOgjVDom30ZdQ==
X-Received: by 2002:a65:490e:0:b0:41c:5b91:e845 with SMTP id p14-20020a65490e000000b0041c5b91e845mr231935pgs.436.1661366642518;
        Wed, 24 Aug 2022 11:44:02 -0700 (PDT)
Received: from localhost (fwdproxy-prn-118.fbsv.net. [2a03:2880:ff:76::face:b00c])
        by smtp.gmail.com with ESMTPSA id b6-20020a170902650600b0017128185043sm12739508plk.191.2022.08.24.11.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 11:44:02 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [net-next] Fix reinitialization of TEST_PROGS in net self tests.
Date:   Wed, 24 Aug 2022 11:43:51 -0700
Message-Id: <20220824184351.3759862-1-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <Adel Abouchaev <adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix reinitialization of TEST_PROGS in net self tests.

Signed-off-by: Adel Abouchaev <adel.abushaev@gmail.com>
---
 tools/testing/selftests/net/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 11a288b67e2f..4a5978eab848 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -42,7 +42,7 @@ TEST_PROGS += arp_ndisc_evict_nocarrier.sh
 TEST_PROGS += ndisc_unsolicited_na_test.sh
 TEST_PROGS += arp_ndisc_untracked_subnets.sh
 TEST_PROGS += stress_reuseport_listen.sh
-TEST_PROGS := l2_tos_ttl_inherit.sh
+TEST_PROGS += l2_tos_ttl_inherit.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
-- 
2.30.2

