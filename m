Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F29497EC6
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbiAXMNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239089AbiAXMNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:13:25 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D30C061401;
        Mon, 24 Jan 2022 04:13:25 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id k25so20688894ejp.5;
        Mon, 24 Jan 2022 04:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dkmS0Cn+xGZLK+jdSmt5kOascj8B8GCiGD14/T3W7CI=;
        b=Jn2gQo/sZiThDwe6QiDeV/ipD9qFip061xo54DT9eIGHoVjoFj7u/zUDatw4Uimdc3
         L0X7bp0IzS+ykLWgINYRaYytyjMjvaADIVGUW/gmmYqIXgWERQqRr9UA5/s4kiccfViA
         64/G8S69MYDIyuOreb3PXUOn7Y0G+3cfGWksTGBH1vvwQdTnzGvOT9cl/hU1e37q0gV0
         +YCB39P/YXvRrAXgT40As+zY1yzGwr95I5DMdVydd00XaqQz6+yQn0TZEKhfETyOSXIx
         JekioAo9TmNccHZ4oBb2VBaWvmBHmgSFacnQYlf5R6+MqqvB/pK7+JpImtvVi7u7aUUS
         pO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dkmS0Cn+xGZLK+jdSmt5kOascj8B8GCiGD14/T3W7CI=;
        b=17amLhuIICt+fiLSAHJ1J+A+es+pw2vIORwG5VVNo8mlcj4AqqiKOg0sPPKL3C/Fu8
         qAwwqfeSLT0Msd55Of85HL8zg5qFvGE6/GHXVfLg0HC8ElaxMgR132KAZY8Puwzf0tbe
         8k9McJn4BxOdQ65WNv64kpYRig/p9fEMozkMwopNYuLxR7kR1/piM3uqcdXLLlwBBj59
         WvKP0qN7Fp5KXP1cIA855IJSnMZ6X5i0vY0cr6QLKTQ5qDBEyApw1prTZ9uOd1G5ApGH
         41yhEID6jR2FRn9Y07rFB+/yMkbZzzlw35spzDtKujCYli0ac435o6+axqxzkpqRU+ia
         3dPA==
X-Gm-Message-State: AOAM532kKN7r8a2FlnOzAaLuHYdBgDn6zpl31Uocp8a5pRPI0QIS7T0W
        9Do4i0FYYADsrjOow2g90jY=
X-Google-Smtp-Source: ABdhPJwSimQ4lZgpgFM6SvZWYAqt7FPM+qknb6Uyet7AXHIdsOHYXExjVZk8Lr7gtdymbeDX//qHnw==
X-Received: by 2002:a17:907:868b:: with SMTP id qa11mr3694518ejc.585.1643026403869;
        Mon, 24 Jan 2022 04:13:23 -0800 (PST)
Received: from ponky.lan ([2a04:241e:502:a09c:a21f:7a9f:9158:4a40])
        by smtp.gmail.com with ESMTPSA id b16sm4847517eja.211.2022.01.24.04.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:13:23 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
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
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 02/20] docs: Add user documentation for tcp_authopt
Date:   Mon, 24 Jan 2022 14:12:48 +0200
Message-Id: <067cf4a231834baa1fb0e7c51842a6b5571bcbcd.1643026076.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
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
 Documentation/networking/tcp_authopt.rst | 51 ++++++++++++++++++++++++
 2 files changed, 52 insertions(+)
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
index 000000000000..72adb7a891ce
--- /dev/null
+++ b/Documentation/networking/tcp_authopt.rst
@@ -0,0 +1,51 @@
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
+Individual keys can be added to or removed through an TCP socket by using
+TCP_AUTHOPT_KEY setsockopt and a struct tcp_authopt_key. There is no
+support for reading back keys and updates always replace the old key. These
+structures represent "Master Key Tuples (MKTs)" as described by the RFC.
+
+Per-socket options can set or read using the TCP_AUTHOPT sockopt and a struct
+tcp_authopt. This is optional: doing setsockopt TCP_AUTHOPT_KEY is sufficient to
+enable the feature.
+
+Configuration associated with TCP Authentication is global for each network
+namespace, this means that all sockets for which TCP_AUTHOPT is enabled will
+be affected by the same set of keys.
+
+Manipulating keys requires ``CAP_NET_ADMIN``.
+
+Key binding
+-----------
+
+Keys can be bound to remote addresses in a way that is somewhat similar to
+``TCP_MD5SIG``. By default a key matches all connections but matching criteria can
+be specified as fields inside struct tcp_authopt_key together with matching
+flags in tcp_authopt_key.flags. The sort of these "matching criteria" can
+expand over time by increasing the size of `struct tcp_authopt_key` and adding
+new flags.
+
+ * Address binding is optional, by default keys match all addresses
+ * Local address is ignored, matching is done by remote address
+ * Ports are ignored
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

