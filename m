Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812EA580B13
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237635AbiGZGPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiGZGPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:15:45 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F1865B5;
        Mon, 25 Jul 2022 23:15:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w5so4081089edd.13;
        Mon, 25 Jul 2022 23:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6LjuhIC/pbHS+8spopbsWARAYbdtibeJdvNxgS2b0Q0=;
        b=Jp9L4FYfu0jGtLqSJdzfPszfj6sXWOJy4TQKGDvQ0MVSe4g2GNyhdZMpkLtL511E8m
         +A/BYrgaZ3PElIlZxCHxZQkR2txyCTHzkqlTez3tTY8e29FEOn7mzGAuiFDoT00TIMyr
         K9Fv8BlzXWSoyPciq1r9IWfsJnCxBwAE7njUMKOTmCHArhaKtestUGKqqYrO4UVeliGo
         9RS9RZSY22NS7amBO38IkqJ5Zi+iUCIOAAWG2oGo3bkcWjZ9JoefVFvVIO+/J1g8Jzs1
         Qztm2gDebiruEX/vocGPVEmHZH/KujGclS9DotrIA6fbH8zhx0IC6QjDmPHJgcqFT3tx
         J0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6LjuhIC/pbHS+8spopbsWARAYbdtibeJdvNxgS2b0Q0=;
        b=T8U8KAFShiDxP+W9H29fa57NT4dTCU9vJjCPsbwBUoEn3fEQK+o4/xVA3kZGrkXZ6R
         QhBvN7HCQfXkZ9+lqfeoyc+uh49ucO4CgAcdoH3dM7L5mzQagK1GoRmS4xyimg0AvKZe
         EmDiZ5N7IP7L3yCdv0ycBRH6tR1+B9lg7ZWTFncLq6+wMD4HSGy3WbtD+Fh1xE38V1mm
         PbXp2KuqjGnV1xS2TLBekJgSlZ1osOAdxDygMUkDnIS6cVBH1yvSBrbc7MG+5csBr7Um
         cSOgqW6BuJxeZuRmi+WJ2BaARUiz7sQvabOEEJo4+wj/hjxGuDnM9p1lEk4cEoOEoTvz
         AtUA==
X-Gm-Message-State: AJIora8pWwsf3wd6lgeliFYYoiRiqtmAOD7PmiQeVKBA0d5tnLLSdPJr
        BNP23InhFZPQS+3rY0Ud2vA=
X-Google-Smtp-Source: AGRyM1s2UwviHVLfzln0uqOiNKPx4OSUra1aQ5CHf7qDs1n8tRQkm1Z/Q96hvDxabamB2tBJgWUzVw==
X-Received: by 2002:aa7:c403:0:b0:43b:d0a3:95f with SMTP id j3-20020aa7c403000000b0043bd0a3095fmr16224245edq.74.1658816143705;
        Mon, 25 Jul 2022 23:15:43 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:15:43 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
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
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 03/26] docs: Add user documentation for tcp_authopt
Date:   Tue, 26 Jul 2022 09:15:05 +0300
Message-Id: <b63d44843da4cbdc1010f4bcf7b4a674bdad1073.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1658815925.git.cdleonard@gmail.com>
References: <cover.1658815925.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 03b215bddde8..294b87137cd2 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -103,10 +103,11 @@ Contents:
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

