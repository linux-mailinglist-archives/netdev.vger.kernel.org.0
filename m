Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882D35135E4
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347895AbiD1OCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347872AbiD1OCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:02:06 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2CEB53C5;
        Thu, 28 Apr 2022 06:58:51 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id g6so9777133ejw.1;
        Thu, 28 Apr 2022 06:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6yhw3vAgS0ezr9ZZJU/0JZnt1IXk8RP1bpIj/xq+Zmg=;
        b=IJzn+Uub+BcVnQ8kpFx9x6zDXCNb2uL51LOFJY46LL2K/41dGUfoZfG2Iuj0iHJ76X
         zjIDVLaPeCQsLFVU7bbCBrPapS3yowUVs1Dv1PeBoOq5rYDl/1AiG+bQ0mhR9/Bb7F5N
         8RNJ/ZIp3oIzgarYAMdpIG4RgAuWdjvOIAWPfkY6TAp43zuoWwq5BG6FuSMHNhsd19nC
         4X2A3vWUSb5CUtU7JZilTw+2tRErDDrEOGToAIIEX1t4sN4xUR6A3qmjlxsTURHN422/
         w48rbL2DepvkVilSt0fDbcIiM+MjcVcNZpFChoWuceYss+VrZh6/mwh3CKtdf4jnj+7A
         xc4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6yhw3vAgS0ezr9ZZJU/0JZnt1IXk8RP1bpIj/xq+Zmg=;
        b=5uqu9VfpwZuMFco6AtBJNkkkZ/1y4zaBpvHZyiCoCkybIVVJvul1ZTHOqkU0Tn1vpT
         Ds/DekZdNCobPFe5CQlzannRb6uQiPftrs1NVdPaepfDaf4921E4CmJjXUar5zShYYPR
         aevO/bYA2eOnLeUtRQOUVzQK+vUc6k9mn9YhC9utaChW+DLeBG7qQWMo1B57Q7bBw1ao
         uKd6z9h62rjaR7ncryHixrojWfTEP3daWgrVuTdjVxCIqq47v/Zo9QfWd4SYjGTBGJ0h
         ZC+8mOa01z813ixXKoICj8G4SY4lh+a/t3n1LpkFd6VRJgA5RHs8odg/SFW4FvxYPiNM
         cPFg==
X-Gm-Message-State: AOAM532QZYY7pTvIGW83vzsCJvjlTA04w07MN8KPzR2afOPF9p1jGiQk
        QKCKIvh2PgmLVFoyMlKb70fAg5+iCos=
X-Google-Smtp-Source: ABdhPJz7Vh6WP6wbUIx82ccznHAN7Kq+d4typKfpOEjsy3QobDistd5qOS540Z3dajUQDOUa/TYcHA==
X-Received: by 2002:a17:907:9621:b0:6d7:355d:6da5 with SMTP id gb33-20020a170907962100b006d7355d6da5mr31343828ejc.195.1651154329631;
        Thu, 28 Apr 2022 06:58:49 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm1652568edr.76.2022.04.28.06.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:58:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 net-next 03/11] udp/ipv6: move pending section of udpv6_sendmsg
Date:   Thu, 28 Apr 2022 14:57:58 +0100
Message-Id: <4087b9a2cb175bca7c10404e33e8ba6c8de2ff1a.1651153920.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651153920.git.asml.silence@gmail.com>
References: <cover.1651153920.git.asml.silence@gmail.com>
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

Move up->pending section of udpv6_sendmsg() to the beginning of the
function. Even though it require some code duplication for sin6 parsing,
it clearly localises the pending handling in one place, removes an extra
if and more importantly will prepare the code for further patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 67 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 705eea080f5e..d6aedd4dab25 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1317,6 +1317,44 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
 
+	/* Rough check on arithmetic overflow,
+	   better check is made in ip6_append_data().
+	   */
+	if (unlikely(len > INT_MAX - sizeof(struct udphdr)))
+		return -EMSGSIZE;
+
+	/* There are pending frames. */
+	if (up->pending) {
+		if (up->pending == AF_INET)
+			return udp_sendmsg(sk, msg, len);
+
+		/* Do a quick destination sanity check before corking. */
+		if (sin6) {
+			if (msg->msg_namelen < offsetof(struct sockaddr, sa_data))
+				return -EINVAL;
+			if (sin6->sin6_family == AF_INET6) {
+				if (msg->msg_namelen < SIN6_LEN_RFC2133)
+					return -EINVAL;
+				if (ipv6_addr_any(&sin6->sin6_addr) &&
+				    ipv6_addr_v4mapped(&np->saddr))
+					return -EINVAL;
+			} else if (sin6->sin6_family != AF_UNSPEC) {
+				return -EINVAL;
+			}
+		}
+
+		/* The socket lock must be held while it's corked. */
+		lock_sock(sk);
+		if (unlikely(up->pending != AF_INET6)) {
+			/* Just now it was seen corked, userspace is buggy */
+			err = up->pending ? -EAFNOSUPPORT : -EINVAL;
+			release_sock(sk);
+			return err;
+		}
+		dst = NULL;
+		goto do_append_data;
+	}
+
 	/* destination address check */
 	if (sin6) {
 		if (addr_len < offsetof(struct sockaddr, sa_data))
@@ -1342,12 +1380,11 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		default:
 			return -EINVAL;
 		}
-	} else if (!up->pending) {
+	} else {
 		if (sk->sk_state != TCP_ESTABLISHED)
 			return -EDESTADDRREQ;
 		daddr = &sk->sk_v6_daddr;
-	} else
-		daddr = NULL;
+	}
 
 	if (daddr) {
 		if (ipv6_addr_v4mapped(daddr)) {
@@ -1364,30 +1401,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		}
 	}
 
-	/* Rough check on arithmetic overflow,
-	   better check is made in ip6_append_data().
-	   */
-	if (len > INT_MAX - sizeof(struct udphdr))
-		return -EMSGSIZE;
-
-	if (up->pending) {
-		if (up->pending == AF_INET)
-			return udp_sendmsg(sk, msg, len);
-		/*
-		 * There are pending frames.
-		 * The socket lock must be held while it's corked.
-		 */
-		lock_sock(sk);
-		if (likely(up->pending)) {
-			if (unlikely(up->pending != AF_INET6)) {
-				release_sock(sk);
-				return -EAFNOSUPPORT;
-			}
-			dst = NULL;
-			goto do_append_data;
-		}
-		release_sock(sk);
-	}
 	ulen += sizeof(struct udphdr);
 
 	memset(fl6, 0, sizeof(*fl6));
-- 
2.36.0

