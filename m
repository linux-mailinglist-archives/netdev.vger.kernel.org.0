Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E419A413767
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbhIUQVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbhIUQU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:20:28 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24315C0617A6;
        Tue, 21 Sep 2021 09:17:37 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r5so6713311edi.10;
        Tue, 21 Sep 2021 09:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xTuLF9iVakUmuqWJrh4h5lRJip3NOmzubsD/v0KQcZA=;
        b=e0CCTRMaMb+VXQZXecEdK9+PhRe3VtV+vCqsNgTYclTyKxUhRRPNPBCfdTE40toYE4
         MtWBgGOvzFhmzaQTXCZesW1lB0PH6umPLwMDX5pKguPrAj6LKSTTtuaTOIhd2be0cT5X
         O7b2oPQNqlrNioGotBCjRHi7AJlcY6lYn05696BgO/hGtmdC6Dz9QRa8pK7DG/x4rpFK
         qTlko9ydhAFvv6/DfC/Ksh6KxsT+TuM7t22lv/CXByYdRimlen/bIbvySy4mYFB82oe7
         3ulHd3YaaPEppuCmJWOX8s1g45lJqeS+nB2K0kHQXKu59SpGVmj/Y6Vn6c3adUsX31De
         HxnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xTuLF9iVakUmuqWJrh4h5lRJip3NOmzubsD/v0KQcZA=;
        b=IkugwuK7oGhVLA5/otOGcphf5qBAhNSOIlLpzQVLtVOWW/VwRryjSgcaGt9qwrTogQ
         t/ZZc0BIxXyT04BmXcYES9l9YqWXaBqx6z+q8hO7e7RN+TZrvyGeeNJWefbo+/+tbroQ
         zPcoBAAxTw1EgIehiizZPvT8V8lEB391Yt8wssWeGjC137LNWEYUxYLslsAMdcE21hI3
         TK0CekcWGvB3hTLbNodlqKiBtFmrvXbJC1jxwZk0KL5+SAhWADWqGxSD0pnu3J4YNW4M
         Hr4hGOHa3oDJ4Y6+8yhKZb5loxZ2w1P1Wej+dR+mCcyx8vWRBmFTCF8L1UEqKSP19a6L
         a0jQ==
X-Gm-Message-State: AOAM531gncG6k+cmQUdGq/jJa+WCc9niAhmSNyPN8E72jP2Up7/6Wefz
        q05ExydJc8o5GG26rDa9OBg=
X-Google-Smtp-Source: ABdhPJwJYuiadhExn43H/ihIAbnx+o9isYCWpMew1MkoLwXAA691Zx36NuCbSr00LuDerdAvoJLzKg==
X-Received: by 2002:a17:906:1749:: with SMTP id d9mr34603473eje.178.1632240918719;
        Tue, 21 Sep 2021 09:15:18 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:18 -0700 (PDT)
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
Subject: [PATCH 02/19] docs: Add user documentation for tcp_authopt
Date:   Tue, 21 Sep 2021 19:14:45 +0300
Message-Id: <1362c88efa09c7710aff0f4516174e4160d3267a.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
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

