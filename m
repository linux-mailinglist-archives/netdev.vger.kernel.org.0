Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6965067E7CC
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbjA0OJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbjA0OJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:09:54 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4701130B30
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 06:09:53 -0800 (PST)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2CA643FFEF
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1674828588;
        bh=ThPASxkQPa8akyDheX0+gKydQu/0488KOg7wyMg90UM=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=A3QTJRhCu6V7dxExDLzkAD+S/aoDzP70aLcf0GDkhFfPqXSDV89v4NAYu262nhgeh
         5vujegkaBHXN+TXamI5fJOKq/XYZ3SpTcabynobJO6BpZ/OuoZ8G6KLwl7orXtQME1
         8YLvetRleBFXSxsuk7aTy+W4jsTiUo2LJL+X5q3I1Kp2bhGF58N7LJb3wQiybr0ddB
         EUxcom0U1YARG9EbS05MHssEAHms7Zl0SGaXHVA+ptJn791hNZIGHJ436zwAcFEXHH
         aSJfD+24eevlShHyYGkZLPX8hhddfRxbLTQMA6Ww+5qywMcb2e07O0sN5F7y5FjoCj
         TIOy092BevO+w==
Received: by mail-wm1-f72.google.com with SMTP id r15-20020a05600c35cf00b003d9a14517b2so4726754wmq.2
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 06:09:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ThPASxkQPa8akyDheX0+gKydQu/0488KOg7wyMg90UM=;
        b=uhaBgmLxueT2N2zhsPs7kX8oHH05B8L93TwJJguKhr6tsNRyUK3kTt/tGG9fVb3gDj
         3oImEKdP4/G/aF7cKGh9K+kBKXaVCMvXtJ75QFUDJ2QnZbJEAfHKoo1Cp3Khio+fbYr/
         VyOGOuaTB8RQQLwfscKZqSMSMKSyBCI+NXcn66GQ+Qb9XHQSGoqqACeC8rpGQehuMHXC
         fMX536fFIAKkAeBavcS3vGTGm2lSWiY4vBCx2/WYd0k1afxrQBvVbu29qq+vPtY3u9e7
         MpL3z67SlWOI3J4wE9bTEapmyymLFRuE/UPpxscg4HEcAsKf0dezNbzl2n7Fz9joCd1D
         bczw==
X-Gm-Message-State: AFqh2krQcRuDBmu5ZVOraGvI9+vDnkxh6yKOUtmdL+uHRd44VhYQ3v8O
        WR67BqKYUUPG40zJQdFwT0bx8carsG5H6sEfQ8Wk5KnUDrdAMqR0ZUHwXxS8lj9+daaTnT9P9Qu
        6a2XbynlRf6RO5GKwwegy8k/MpdYUyonPPQ==
X-Received: by 2002:a05:600c:354a:b0:3da:1f6a:7b36 with SMTP id i10-20020a05600c354a00b003da1f6a7b36mr40128692wmq.0.1674828587947;
        Fri, 27 Jan 2023 06:09:47 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs7b7lhU/Xr193ycZjTx4N8Y9Ik+fcCC7Uk9va/piM6WqgeOvJzsU8QQFjACQP4jx7hH+udxQ==
X-Received: by 2002:a05:600c:354a:b0:3da:1f6a:7b36 with SMTP id i10-20020a05600c354a00b003da1f6a7b36mr40128673wmq.0.1674828587759;
        Fri, 27 Jan 2023 06:09:47 -0800 (PST)
Received: from qwirkle.internal ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id f21-20020a5d58f5000000b00236883f2f5csm4105833wrd.94.2023.01.27.06.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 06:09:47 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Andrei Gherzan <andrei.gherzan@canonical.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v3 1/3] selftests: net: .gitignore the scratch directory of bpf
Date:   Fri, 27 Jan 2023 14:09:42 +0000
Message-Id: <20230127140944.265135-1-andrei.gherzan@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The net/bpf Makefile uses a similar build infrastructure to BPF[1] while
building libbpf as a dependency of nat6to4. This change adds a .gitignore
entry for SCRATCH_DIR where libbpf and its headers end up built/installed.

[1] Introduced in commit 837a3d66d698 ("selftests: net: Add
cross-compilation support for BPF programs")

Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
---
 tools/testing/selftests/net/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index a6911cae368c..0d07dd13c973 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -40,6 +40,7 @@ test_unix_oob
 timestamping
 tls
 toeplitz
+/tools
 tun
 txring_overwrite
 txtimestamp
-- 
2.34.1

