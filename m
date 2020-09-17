Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A3D26E11B
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 18:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgIQQto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 12:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728656AbgIQQsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 12:48:11 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D52C061756;
        Thu, 17 Sep 2020 09:47:54 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c8so3235198edv.5;
        Thu, 17 Sep 2020 09:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bjmlDZzFg35X0DNxptcCpMN+z9MdjCxJVOYy64jaQEQ=;
        b=Y95eehdgKSLFEYq8ifcRAAWI3NKEAPumdd9PDqmOR4LgVlGG+Sw54F9iet69AlOHta
         T2oi8iFDLIYm8H9fFUAPvHkKR7Kz3eZKwjzyzop1sC7tvo6KbNp2EIoljn12KAfvdnsP
         BfMME7x3zthf77oIae3x/+lzsxClbzuEM9KX05voLeaRNZyAILjd9QUaCZc96wAc9rvp
         zYRgoHTkRAXVSTtxjxoJLAKv7Pq8Rb2b/DCcNL5V15yA3do+9RcpBwf2RXfnX0QOHJFw
         aPUP6nCIPdbR4ppIKSIc4gcVQPXG4o+WnTw8RefDsltuYJkAe82OA1U+ZHTA7ZPNDNfx
         OnqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bjmlDZzFg35X0DNxptcCpMN+z9MdjCxJVOYy64jaQEQ=;
        b=LtLTacrSebjMK8B75xETutjDusgiSwgWx9AaMuKTqWoLe10Xe+KO4WauKIYZ7Tckjg
         nHiMiNizsuH1O9y24yCPT+t5vEVrQOYY/6/MDHeaIbL9dWzVpdRDzABDhHGPqA1ufEnA
         sd+fWK6Layek1p9XY/4HlZtk3L64+QfYk3R5Rp54FeA9ZspWT4K9vEoXdI6PBWGF+YR6
         C7mYhXG6JcsGk+PqL9aEBTws/5GNh4MvXEOUMmHaqiZ/BOdCTrB8SGYvxx7mTiD26Z5p
         TbW6HRnK5NedxcZhaXceYQydawPmwQ4+iDqxD9Jt+5wDx+DQBYSxT0tX7fXcWNAg4MP5
         gZPg==
X-Gm-Message-State: AOAM533e2at3sLWsZ+5LO2TrAs6cPr6EyZym+CMmVsvlxrdK3fvKF8w6
        B72hWzzvqCmNTATiw34GmHI=
X-Google-Smtp-Source: ABdhPJynXcS11917/M/uXNidmod+eIDTLUJ1CkTRZs/oIy5YujVKRxCArPxaDbEFQKjgNSFJPg3amA==
X-Received: by 2002:a50:a693:: with SMTP id e19mr33219556edc.205.1600361273370;
        Thu, 17 Sep 2020 09:47:53 -0700 (PDT)
Received: from localhost.localdomain ([85.153.229.188])
        by smtp.gmail.com with ESMTPSA id s30sm191004edc.8.2020.09.17.09.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 09:47:52 -0700 (PDT)
From:   Necip Fazil Yildiran <fazilyildiran@gmail.com>
To:     davem@davemloft.net
Cc:     david.lebrun@uclouvain.be, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul@pgazz.com, jeho@cs.utexas.edu,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>
Subject: [PATCH] net: ipv6: fix kconfig dependency warning for IPV6_SEG6_HMAC
Date:   Thu, 17 Sep 2020 19:46:43 +0300
Message-Id: <20200917164642.158458-1-fazilyildiran@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When IPV6_SEG6_HMAC is enabled and CRYPTO is disabled, it results in the
following Kbuild warning:

WARNING: unmet direct dependencies detected for CRYPTO_HMAC
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - IPV6_SEG6_HMAC [=y] && NET [=y] && INET [=y] && IPV6 [=y]

WARNING: unmet direct dependencies detected for CRYPTO_SHA1
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - IPV6_SEG6_HMAC [=y] && NET [=y] && INET [=y] && IPV6 [=y]

WARNING: unmet direct dependencies detected for CRYPTO_SHA256
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - IPV6_SEG6_HMAC [=y] && NET [=y] && INET [=y] && IPV6 [=y]

The reason is that IPV6_SEG6_HMAC selects CRYPTO_HMAC, CRYPTO_SHA1, and
CRYPTO_SHA256 without depending on or selecting CRYPTO while those configs
are subordinate to CRYPTO.

Honor the kconfig menu hierarchy to remove kconfig dependency warnings.

Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
---
 net/ipv6/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 76bff79d6fed..747f56e0c636 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -303,6 +303,7 @@ config IPV6_SEG6_LWTUNNEL
 config IPV6_SEG6_HMAC
 	bool "IPv6: Segment Routing HMAC support"
 	depends on IPV6
+	select CRYPTO
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
-- 
2.25.1

