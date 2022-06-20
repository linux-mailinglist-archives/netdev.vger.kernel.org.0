Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4CB551461
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbiFTJbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235299AbiFTJaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:30:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48B013D3B
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 02:30:21 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id p5so3904891pjt.2
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 02:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zGmsLG1EhHd57vYE9m4SvDpXIDM8p0BXYc5ItP6rbgk=;
        b=I5sBnQN7uFgL0KM43kNulieug9dy7a3rz7UwnDdWsO/+FLdOjG5Yx4V8lLrPa/H1tJ
         IBwLK7Bzy5DVNlJX0uf4crkLN0RjsKGxynMawjm4eKLqdTu5WQyG6Cq22PnrOOcTSb0B
         K2DKBY9wVDB13ZkPerygEl4WnpVFt38CPolOWmMJgUDKxmTwU7HdUETK9v+6rd7aTpng
         B7u8qEcsMn7gRzPvUH2Km3GGdo5Q4DDGUj5C2+dIv6Dh6lH6g94I6lICLsK7XjoUCr8a
         LpycEWRazXM/uV9wX+grs79K5Egu6enPY5+rt9QeQC/ILHjdx0+XJFs0/ODwI2nD3aUl
         MlRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zGmsLG1EhHd57vYE9m4SvDpXIDM8p0BXYc5ItP6rbgk=;
        b=VBlMgiTiabSwQHkk30YieSybV68dSCgZD8k8a59rf9OaW3dxDXuIbk1w0Bvz6u1+gE
         p09YoEfSwW/hRXHTgXE5/h5LQi9bzJrSiAoVzF0VPcvZd+i25EOJ3cj3s4MV8NjrG5Ts
         MoamzK96JOcdWNdBIcFCe5vRxNZ28+p1whIZ5gIdqdnPwaBxnMXQs+fgXSbwBk9ih1M4
         UuRAQBnX88Q/b2vbZ7KkbCzUYBCpM8mIsJ30Eyg21C5fP8RJFZGAlsasp9MVinKLO5tE
         JwDkxd7azOq3Nl7A9KT93JtfaHn5izjQE7t4dI4xu1S+fkL5U6T03C+CGgJjwY3w2RLl
         Hsmg==
X-Gm-Message-State: AJIora/eXjCdmCeP5OcDQvmNtJm+sH4ZcfEUhinJpwOYT5sYvUJl1EFp
        azg/ysTTxTbKozCMdKMCmjfgUSTGZcQ=
X-Google-Smtp-Source: AGRyM1votABSBD6GV7ybxSfINYM2nnM7ZkQXY5eITPP5+4Y5Pu0B2GzpSYlMvF/YSUCNkN5INgT+9g==
X-Received: by 2002:a17:903:110e:b0:167:8847:5d9d with SMTP id n14-20020a170903110e00b0016788475d9dmr22802650plh.3.1655717421371;
        Mon, 20 Jun 2022 02:30:21 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:394d:a9d5:3c7b:868e])
        by smtp.gmail.com with ESMTPSA id k21-20020a170902761500b0015e8d4eb2d1sm8143930pll.283.2022.06.20.02.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 02:30:21 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: warn if mac header was not set
Date:   Mon, 20 Jun 2022 02:30:17 -0700
Message-Id: <20220620093017.3366713-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Make sure skb_mac_header(), skb_mac_offset() and skb_mac_header_len() uses
are not fooled if the mac header has not been set.

These checks are enabled if CONFIG_DEBUG_NET=y

This commit will likely expose existing bugs in linux networking stacks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 82edf0359ab32d0d7cd583676b38d569ce0b24cc..cd4a8268894acce4bde16dc0fedb7eb13706f515 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2763,8 +2763,14 @@ static inline void skb_set_network_header(struct sk_buff *skb, const int offset)
 	skb->network_header += offset;
 }
 
+static inline int skb_mac_header_was_set(const struct sk_buff *skb)
+{
+	return skb->mac_header != (typeof(skb->mac_header))~0U;
+}
+
 static inline unsigned char *skb_mac_header(const struct sk_buff *skb)
 {
+	DEBUG_NET_WARN_ON_ONCE(!skb_mac_header_was_set(skb));
 	return skb->head + skb->mac_header;
 }
 
@@ -2775,14 +2781,10 @@ static inline int skb_mac_offset(const struct sk_buff *skb)
 
 static inline u32 skb_mac_header_len(const struct sk_buff *skb)
 {
+	DEBUG_NET_WARN_ON_ONCE(!skb_mac_header_was_set(skb));
 	return skb->network_header - skb->mac_header;
 }
 
-static inline int skb_mac_header_was_set(const struct sk_buff *skb)
-{
-	return skb->mac_header != (typeof(skb->mac_header))~0U;
-}
-
 static inline void skb_unset_mac_header(struct sk_buff *skb)
 {
 	skb->mac_header = (typeof(skb->mac_header))~0U;
-- 
2.36.1.476.g0c4daa206d-goog

