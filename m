Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18CD47E58C
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349031AbhLWPko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349013AbhLWPkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:40:42 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79ABC061757;
        Thu, 23 Dec 2021 07:40:41 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id o6so22972532edc.4;
        Thu, 23 Dec 2021 07:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dkmS0Cn+xGZLK+jdSmt5kOascj8B8GCiGD14/T3W7CI=;
        b=T9lR1BqjJlLABep1NTKOI6UKfJb9U+22sWOMnYNzIdJM5fRvvnC1GNrrb0pw0RzFgz
         yjgz+o4y8jEl2p6hgEJgarlhrVB9wJT1XZq32PdiRuBRXaF1MoJDI8s33ddtUb7FqzUG
         7vlJsXevJ3whHk+UWV1sf5s9NJPqh54AmDdK7uqL3uRrcIwpgGS3cTCE36fg58yyP0pV
         VK0aSNsqeWctt15JrI7UTTv0PtvlGZDP2dgokjq3mDP2N6iDzjFfyvalomZV6bzTfCUA
         2juXiqh5U+h4eBOXP7XS3vvOMCQJ0E9xBf8+GIZXg0wPyMKLjRucKnPdyW/zJNlDT1Cs
         +0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dkmS0Cn+xGZLK+jdSmt5kOascj8B8GCiGD14/T3W7CI=;
        b=elZP4w2Paa/inXVG2JiN5QhEG3FfBgmlXsUpdphQm31XJjQ2/6PMTbkECVBAd7SKB6
         9LosS2CSFbne87hW20D7Ibwh5AFF3P9UaHC7nhw7lSDwBTesz6T+Om38AuyCSeevAxIS
         eliZTwCwg8Oo9D4dg4d9mmmi7Idbza1ToPkNaeZ9kMi5vb8Dkp5Zp/lApHSGoNYdZIcL
         P7ogUEYvyK6PenbBqEc/21xZ5FQo8LN4QyVdWpvJ/76BiXtNre7W7QWsfAuR4XQy5z0d
         m1VXf2VCvKQS7Quehwvo7BAOX2IgmJ3yklQKdgegh3vgqQ9TLZCD6A8UZTYSFaJJbRhe
         n+tg==
X-Gm-Message-State: AOAM530qs7fkbNXoobQHc2aFkJRcIAy8tMYuyPHm5sA03sYxK1T7W3J6
        B7noSXFPKcL27RlEn3yOh5Y=
X-Google-Smtp-Source: ABdhPJx+PaQa0e19Kafpqo5KgHmsytvqhKFXKZIMk4610aJntPYi1bjuNgzeKI1ey547amYqbqOo9Q==
X-Received: by 2002:a17:906:5208:: with SMTP id g8mr2312261ejm.634.1640274040511;
        Thu, 23 Dec 2021 07:40:40 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:7c02:dfc6:b554:ab10])
        by smtp.gmail.com with ESMTPSA id bx6sm2088617edb.78.2021.12.23.07.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:40:39 -0800 (PST)
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
Subject: [PATCH v4 02/19] docs: Add user documentation for tcp_authopt
Date:   Thu, 23 Dec 2021 17:39:57 +0200
Message-Id: <68b9a766f7ea045f0ea56f27d7523abb41daab37.1640273966.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1640273966.git.cdleonard@gmail.com>
References: <cover.1640273966.git.cdleonard@gmail.com>
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

