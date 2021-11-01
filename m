Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214A04412AD
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 05:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhKAEJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 00:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhKAEJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 00:09:06 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A171C061714;
        Sun, 31 Oct 2021 21:06:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y1so10712622plk.10;
        Sun, 31 Oct 2021 21:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1n2x0oKAPYz3pWFJUDMqbyMzMmahNoyv8knA3ovY2+0=;
        b=ENhldhyeUbonWGisZV/5SMaNyLDMmOSngXjmCQxIlcMZeCgmhQJ+0Zq5DdHG/LYM80
         PvpQxKpmB6jCFwp3+pEnuRrTGi69UwdxjewuCeZXSjtdbcUQBHJuEZcwGfsxYBfFSlc6
         CT5Efm+IcnaX3gekiGlSn8sifrmYmWeumK0XwCzb5hEVpGrjYPWmdBHL7Zlvh+yjSQOV
         YMxFbMpuMIveVlE0mPbRcs86wCQVmffIIOa+Zx6urhzlAQ4C5VjDlas94e1ZK0Ad4lxK
         zQrtvufpTwb8yoR4U29GH/7vip/thpZlsxZEEiXhEjIEq+81Ot9byUhUGy/oofObxP2c
         5czA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1n2x0oKAPYz3pWFJUDMqbyMzMmahNoyv8knA3ovY2+0=;
        b=WXcL0xtfh+paCOf6wi9tlxywfZqSY98vOUvaZ5nccIrJt1FhpuyrTC91+3AYpqgsxg
         ZIwXxCLum4Z4UnVZG+ga7TyoQAlAstIwvyV2SBAmPMH8nWBbN3DSjoLgd43IHbTVYpk+
         JDcu124GqxI+SVs4rjYwF7OhwTKpgS3I8z9FCA0IHwOB8SnA0tw8nsh91JCpOYdcc5Jo
         gEd50cM80DHzaCWbeX5sG6qWJHXt4JLYVX24w+dFKa3ELDkQUupDbiFvHSWBHbqz3z/P
         g8RKYZHKRqkCR3j8X0CtQaOUrEnHndBfOAjpRvOvss99tUcHUg9mvDjQ5t4YPoDxLGGw
         c92Q==
X-Gm-Message-State: AOAM532y5kUtby/KZw3IrwYMI1eQW9RWgWH/XcnX1rdz4IPxHAyuIkqa
        KWcvldnZsRtJq9wmPeKxjE5QgppFYxU=
X-Google-Smtp-Source: ABdhPJxR20u0UVX1wC91AY0JtGlMHI3FhLqCI31K7gBzGQlwW5MEB91Ym7dLKNQfA8C/gMFj0mVzyA==
X-Received: by 2002:a17:90b:3b88:: with SMTP id pc8mr26387139pjb.93.1635739593496;
        Sun, 31 Oct 2021 21:06:33 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v13sm11132231pgt.7.2021.10.31.21.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 21:06:33 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 3/5] kselftests/net: add missed SRv6 tests
Date:   Mon,  1 Nov 2021 12:06:07 +0800
Message-Id: <20211101040609.127729-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101040609.127729-1-liuhangbin@gmail.com>
References: <20211101040609.127729-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the SRv6 tests are
missing as they are not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 03a0b567a03d ("selftests: seg6: add selftest for SRv6 End.DT46 Behavior")
Fixes: 2195444e09b4 ("selftests: add selftest for the SRv6 End.DT4 behavior")
Fixes: 2bc035538e16 ("selftests: add selftest for the SRv6 End.DT6 (VRF) behavior")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 63ee01c1437b..8a6264da5276 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -28,6 +28,9 @@ TEST_PROGS += veth.sh
 TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
 TEST_PROGS += gre_gso.sh
+TEST_PROGS += srv6_end_dt46_l3vpn_test.sh
+TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
+TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
-- 
2.31.1

