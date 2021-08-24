Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18BE3F6B12
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbhHXVgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbhHXVgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:13 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D3DC061757;
        Tue, 24 Aug 2021 14:35:28 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id cn28so33786087edb.6;
        Tue, 24 Aug 2021 14:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xTuLF9iVakUmuqWJrh4h5lRJip3NOmzubsD/v0KQcZA=;
        b=IbGb84Vf3jUC/6sd/tRmu9UcbJkKEYuPPOu6P89qtGLt4Epu+INvN6YTzFhsTpwIi/
         0w4BCAKRNlMJwP8mm9THiqEWrppUt0R61ztw41NMAPbo+OaChpP/RoUlbIQ86eFBNXp7
         UClRh4bE26d7pZsLv4udca7hS/HDbgi/ZIt4H6sV/PMGslcPS8gikTMrIL3FxcnBGuHP
         Wa/IZHpuWY+OOyk40VdDt50iaJLqmi5EOT3sHIbS0omX6B4bTuKUhWms77D76Wz1D967
         a6AJPc6b40fop8hDaZqckGXiRLAXiqV8ggYOfs5fPgREY76vlgL8y6jJP0JVjli4abB/
         ryQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xTuLF9iVakUmuqWJrh4h5lRJip3NOmzubsD/v0KQcZA=;
        b=MGXSTQSC8HYBa4Sw58vVqZUNfCs6l+aP0l8bN7AgKyFMF2WicDc45Zdwk35wwtW0s5
         aLf2Xbq2l4/BmTDH8CeXXux5uwb7yD4jElNYcm7tQH+f/vhsRVEqW5UgdGnRP93j+FqD
         xkrfuoq701j+ydFxVVArTZnWOEMhGGAsulzf0KkulaDNReYk8rwY8nt38N4uh+12NyhV
         qn7g4TbUX9bHIOUNZwoOOcVhXIXg9WdSCrib/EQgcoUs6gNx15PlZGnKSOHJ/dg8qihJ
         x3bEsT8qbhGzQXeX8v4zCgOUmeQ7RF8PcMrE4HzpOw/XpeiL0wdQvxgfkB7wY7ZCXSis
         dLdQ==
X-Gm-Message-State: AOAM532+EOfVF7TbS5Bq0GjBTsvi0igT8zewlXOHcIahYedaPSPzp09V
        sd8WTmRdm/svKC4RyI5NXKs=
X-Google-Smtp-Source: ABdhPJx1B+kOpypq/kfq97T6r5WpEEZpLoGspvgrdtgu6NkvJz79Iu7GOJB1iX2x+uM87DNFMVk/JQ==
X-Received: by 2002:a05:6402:358a:: with SMTP id y10mr268464edc.140.1629840927034;
        Tue, 24 Aug 2021 14:35:27 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:26 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFCv3 02/15] docs: Add user documentation for tcp_authopt
Date:   Wed, 25 Aug 2021 00:34:35 +0300
Message-Id: <139c26ca2ba28100619dbd536fc7940286d78295.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .rst documentation contains a brief description of the user
interface and includes kernel-doc generated from uapi header.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/index.rst       |  1 +
 Documentation/networking/tcp_authopt.rst | 44 ++++++++++++++++++++++++
 2 files changed, 45 insertions(+)
 create mode 100644 Documentation/networking/tcp_authopt.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 58bc8cd367c6..f5c324a060d8 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -100,10 +100,11 @@ Contents:
    strparser
    switchdev
    sysfs-tagging
    tc-actions-env-rules
    tcp-thin
+   tcp_authopt
    team
    timestamping
    tipc
    tproxy
    tuntap
diff --git a/Documentation/networking/tcp_authopt.rst b/Documentation/networking/tcp_authopt.rst
new file mode 100644
index 000000000000..484f66f41ad5
--- /dev/null
+++ b/Documentation/networking/tcp_authopt.rst
@@ -0,0 +1,44 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+TCP Authentication Option
+=========================
+
+The TCP Authentication option specified by RFC5925 replaces the TCP MD5
+Signature option. It similar in goals but not compatible in either wire formats
+or ABI.
+
+Interface
+=========
+
+Individual keys can be added to or removed from a TCP socket by using
+TCP_AUTHOPT_KEY setsockopt and a ``struct tcp_authopt_key``. There is no
+support for reading back keys and updates always replace the old key. These
+structures represent "Master Key Tuples (MKTs)" as described by the RFC.
+
+Per-socket options can set or read using the TCP_AUTHOPT sockopt and a ``struct
+tcp_authopt``. This is optional: doing setsockopt TCP_AUTHOPT_KEY is
+sufficient to enable the feature.
+
+Configuration associated with TCP Authentication is indepedently attached to
+each TCP socket. After listen and accept the newly returned socket gets an
+independent copy of relevant settings from the listen socket.
+
+Key binding
+-----------
+
+Keys can be bound to remote addresses in a way that is similar to TCP_MD5.
+
+ * The full address must match (/32 or /128)
+ * Ports are ignored
+ * Address binding is optional, by default keys match all addresses
+
+RFC5925 requires that key ids do not overlap when tcp identifiers (addr/port)
+overlap. This is not enforced by linux, configuring ambiguous keys will result
+in packet drops and lost connections.
+
+ABI Reference
+=============
+
+.. kernel-doc:: include/uapi/linux/tcp.h
+   :identifiers: tcp_authopt tcp_authopt_flag tcp_authopt_key tcp_authopt_key_flag tcp_authopt_alg
-- 
2.25.1

