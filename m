Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91606444AC3
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 23:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhKCWUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 18:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhKCWUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 18:20:46 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F0DC061714;
        Wed,  3 Nov 2021 15:18:09 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id ee33so14641338edb.8;
        Wed, 03 Nov 2021 15:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6qQFV7RXtddF0nmlPt11j5xt+H9zmuBSYEfn1/N592w=;
        b=V0Htz9cA5KHeehKruq/rPjj9QxBinjLOodBq4SRNfn4hlSJMQvbcm+1edQM6U4CkS7
         m0e7ZCLiGD5YBh5IZbrw/m5qsbRM7Uopf5OOuhg8JbZgE5bkmSJaCtSFMa01ygQ0il2J
         aoKTLxuEteQ2sXCbfxn3yvkOLXmb0j6/4YA8uPIswAinoFONeaZuepODccqHWodNkW3+
         W0k6hBpN8yxk6C2R9dtQcvaoMNKbyH9iAvexqFfrLesBKhlRyQni9n2uZkZoIbwvBUl7
         FAJMy03p0RtBzvucl6jQET9CY0qoRkhvOBZuGvjHJzyYtaTs1FEUZ+qxPXNzxRnxGqbf
         jQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6qQFV7RXtddF0nmlPt11j5xt+H9zmuBSYEfn1/N592w=;
        b=5mXplALFI4uBudpVxDnH2OEIRwh3nji4vetrMf4pnUSCtAYB/eS+E/npiQnYP9byQp
         QY17nicvmiN8Ya67TKeqQEVFwyfvBEnlGLb0L5e2DbJMhBeGBRI9g3lQr09Hy6OV4JcT
         suC9d+DGIuAW9cEoLE3K8V4zOav3ZeyQL2E/sVI6osqTuB6wtEuiqyckBjyastw752yT
         KMoDRwAu8/keRDWPjmkuK42eqn94AwNSNliLAiOahh1Ck4gF96Et0/7B/bgdK1nLcnT8
         /RifRJCn7NKeBBw97tDHhxnJOcORtaseKLqB/QDFFtof9uChULmZB/umfqre552svdq0
         TMvQ==
X-Gm-Message-State: AOAM531hD5BQnpvlWTTQGzbkAS9kOmbTfUiqGWFp89JdsezdIvL3W+Ds
        1p5Hesc708S8g3zqakRvWS0=
X-Google-Smtp-Source: ABdhPJyqJWdwBMj6EHJ5vK5Q9Uai7ptMBRKb4VzrebE6Wsie+VsjHCTKuCpWG/IopEwaHbZc4yIx9A==
X-Received: by 2002:a17:906:57c2:: with SMTP id u2mr5826978ejr.8.1635977887802;
        Wed, 03 Nov 2021 15:18:07 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:501:3800:dd98:1fb5:16b3:cb28])
        by smtp.gmail.com with ESMTPSA id ak17sm1717265ejc.10.2021.11.03.15.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 15:18:07 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Enke Chen <enchen@paloaltonetworks.com>,
        Wei Wang <weiwan@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tcp: Use BIT() for OPTION_* constants
Date:   Thu,  4 Nov 2021 00:17:51 +0200
Message-Id: <cde3385c115ddf64fe14725f57d88a2a089f23e1.1635977622.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extending these flags using the existing (1 << x) pattern triggers
complaints from checkpatch. Instead of ignoring checkpatch modify the
existing values to use BIT(x) style in a separate commit.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>

---
This was split away from a longer series implementing RFC5925
Authentication Option for TCP.

Link: https://lore.kernel.org/netdev/dc9dca0006fa1b586da44dcd54e29eb4300fe773.1635784253.git.cdleonard@gmail.com/

 net/ipv4/tcp_output.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6867e5db3e35..96f16386f50e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -406,17 +406,17 @@ static void tcp_init_nondata_skb(struct sk_buff *skb, u32 seq, u8 flags)
 static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 {
 	return tp->snd_una != tp->snd_up;
 }
 
-#define OPTION_SACK_ADVERTISE	(1 << 0)
-#define OPTION_TS		(1 << 1)
-#define OPTION_MD5		(1 << 2)
-#define OPTION_WSCALE		(1 << 3)
-#define OPTION_FAST_OPEN_COOKIE	(1 << 8)
-#define OPTION_SMC		(1 << 9)
-#define OPTION_MPTCP		(1 << 10)
+#define OPTION_SACK_ADVERTISE	BIT(0)
+#define OPTION_TS		BIT(1)
+#define OPTION_MD5		BIT(2)
+#define OPTION_WSCALE		BIT(3)
+#define OPTION_FAST_OPEN_COOKIE	BIT(8)
+#define OPTION_SMC		BIT(9)
+#define OPTION_MPTCP		BIT(10)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
 {
 #if IS_ENABLED(CONFIG_SMC)
 	if (static_branch_unlikely(&tcp_have_smc)) {

base-commit: d4a07dc5ac34528f292a4f328cf3c65aba312e1b
-- 
2.25.1

