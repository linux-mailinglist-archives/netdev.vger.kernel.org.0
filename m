Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2664AD20
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730751AbfFRVOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:14:45 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41938 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbfFRVOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:14:45 -0400
Received: by mail-pg1-f195.google.com with SMTP id 83so8338608pgg.8
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 14:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FS2xe3EqWjVa2osnhJcZdNg83PN4WkVvVWlHL7l/qqk=;
        b=Y+YmXflRcgQfURiuGJArsK6o25FGeuUUOwK3W1AuGqsrOnUiyasENIxuR4JhNsKkED
         4mCaNhDAap9VjNHruD4pZhaK1UdTznr8A/O1td3EepAB4lLWkN/jhwn6QbokpmvkAYMe
         eFwVw/QB1uhc/MjklhcZpgppWojGGLihJy92c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FS2xe3EqWjVa2osnhJcZdNg83PN4WkVvVWlHL7l/qqk=;
        b=ujAee3bVzX+V6XMcIKxQ40jIxp66TTfwHp5pl0N1GzaEY/Bemsx4jnfofWYuPKJZyt
         FbXkI9wH4BpX+S6xs+pw8yG7RYDO7zlbl/b1ppn3752zd7XpFc4Qx6jUmxMDUUC8Ieff
         cTkMZD+bhS+vfqROvb+rDvZBZvU7QSjFkD1x2rD0zGizwO8xTc85U58L0v4RzotJhfIa
         hzovjNk0ujrhLR2cssKTvZoxVSnTYKJvt8mXVWu2q0ZmqB0HtrQPv2nbQrxm7N+VPQTG
         IPWqUsHgQAEr/BUIVEzxKTBZgAP1MfVLUBQdgnXcABctJvCF3is/XzvC1D/HGyuZ4ZwG
         84Mw==
X-Gm-Message-State: APjAAAV3NIcDYH1IZFp8j5FC5kPtikPj93fgQ+kHPuF6YJzUfYj1546N
        saTkNhCQI0e0h3gO0gmjHeN3oQ==
X-Google-Smtp-Source: APXvYqyf9L4vnVsrhqP4UkUwW/isWrJmFSn/+x+Z9ZC4m0lvANqoqpOnMKhw7IbwN4Gl6KS1bXKNmA==
X-Received: by 2002:a17:90a:7146:: with SMTP id g6mr7275143pjs.45.1560892484762;
        Tue, 18 Jun 2019 14:14:44 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id c10sm3168946pjq.14.2019.06.18.14.14.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 14:14:44 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexander Duyck <alexander.h.duyck@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] net/ipv4: fib_trie: Avoid cryptic ternary expressions
Date:   Tue, 18 Jun 2019 14:14:40 -0700
Message-Id: <20190618211440.54179-1-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

empty_child_inc/dec() use the ternary operator for conditional
operations. The conditions involve the post/pre in/decrement
operator and the operation is only performed when the condition
is *not* true. This is hard to parse for humans, use a regular
'if' construct instead and perform the in/decrement separately.

This also fixes two warnings that are emitted about the value
of the ternary expression being unused, when building the kernel
with clang + "kbuild: Remove unnecessary -Wno-unused-value"
(https://lore.kernel.org/patchwork/patch/1089869/):

CC      net/ipv4/fib_trie.o
net/ipv4/fib_trie.c:351:2: error: expression result unused [-Werror,-Wunused-value]
        ++tn_info(n)->empty_children ? : ++tn_info(n)->full_children;

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
I have no good understanding of the fib_trie code, but the
disentangled code looks wrong, and it should be equivalent to the
cryptic version, unless I messed it up. In empty_child_inc()
'full_children' is only incremented when 'empty_children' is -1. I
suspect a bug in the cryptic code, but am surprised why it hasn't
blown up yet. Or is it intended behavior that is just
super-counterintuitive?

For now I'm leaving it at disentangling the cryptic expressions,
if there is a bug we can discuss what action to take.
---
 net/ipv4/fib_trie.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 868c74771fa9..cf7788e336b7 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -338,12 +338,18 @@ static struct tnode *tnode_alloc(int bits)
 
 static inline void empty_child_inc(struct key_vector *n)
 {
-	++tn_info(n)->empty_children ? : ++tn_info(n)->full_children;
+	tn_info(n)->empty_children++;
+
+	if (!tn_info(n)->empty_children)
+		tn_info(n)->full_children++;
 }
 
 static inline void empty_child_dec(struct key_vector *n)
 {
-	tn_info(n)->empty_children-- ? : tn_info(n)->full_children--;
+	if (!tn_info(n)->empty_children)
+		tn_info(n)->full_children--;
+
+	tn_info(n)->empty_children--;
 }
 
 static struct key_vector *leaf_new(t_key key, struct fib_alias *fa)
-- 
2.22.0.410.gd8fdbe21b5-goog

