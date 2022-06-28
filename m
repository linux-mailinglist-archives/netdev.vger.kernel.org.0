Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81FB355ED3D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiF1TBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234292AbiF1TA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:26 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD66A1834A;
        Tue, 28 Jun 2022 12:00:08 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ay16so27701169ejb.6;
        Tue, 28 Jun 2022 12:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/eliap5e56eSK1XJIKpFjzJdFDnEAAzOxoC0xRFCg9s=;
        b=ng4a/WkkirDrg9xLd+5D0FaZK/PEUwa33PoIhHvBn2h1I8ghHCvnimUGG1oOJZUR4l
         xetU9D0YQTf+cVE+EtsawtUwI4CV5EZRmNc6A4qTr7w1XshqqHtt1lpSJ6v+W1AnyuvJ
         wrGeb0o1+AvtKS06LvUXGS+IHTigEZMUs3di5eZm0/8mPNjAUpAoP0ljXkxvRWX5Yr3u
         pz7Qn5AWkkHDLBblr/lRPKobznku2l5hYyFWsd893Wuxiv9L5VAGzOzZkzziJ3PFaE9Q
         yhXtWwy23hNTr3i5zj9i/qQPc8U7X4Z2hc48KVmbuHF4QJ1Wh0cASOony3t3Przt5F4O
         QGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/eliap5e56eSK1XJIKpFjzJdFDnEAAzOxoC0xRFCg9s=;
        b=rNIY019Uo5631Ua869nPLgr8gtWD8Xomk6tUDjryYfNuUs/x+HNgGSwRw5W9wb1Gm8
         fYwYL8iemygGQ0HYNfuR0xYe7FNS6D9ZN2FAEy24koaNqZWGdv+hFIYcJ7dLOL46SrDq
         5OX1iUpq+tHlptwrF1owdICxNUgoDZZvDqoAB6SoRv/aVd/Q7dNrfHOg8Oq35R54DsJX
         9hL6wgNfJ7CgwcAeHreNkZ4VPXJ2wGksP8R55q3zXb0beDzW9rd4+YX+esOroFQQQSfQ
         83DmqxWzpcqrdrFaah23e4a2ln/auW6HiHRI57rbHOW9zoHs13dutKnm80qY5Phl+u7a
         dKIA==
X-Gm-Message-State: AJIora8LXD2d4ZGYaogJtW/ta223PbiL6pKYKOWIebFDhTJMqYd4LSl6
        Bsj0D6imHxWTDb7X3J0HRmiXFreH2pDRyQ==
X-Google-Smtp-Source: AGRyM1ubd9IfdC3EMIb/uwZNW9iUepQ2Li08wZlSCpq5YyIseEz2RCZKI13ZzMvXzuq46t9Rr+V7rg==
X-Received: by 2002:a17:907:6ea3:b0:726:ca39:5d98 with SMTP id sh35-20020a1709076ea300b00726ca395d98mr5385796ejc.400.1656442808005;
        Tue, 28 Jun 2022 12:00:08 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 13/29] net: let callers provide extra ubuf_info refs
Date:   Tue, 28 Jun 2022 19:56:35 +0100
Message-Id: <c08a379e615cd9d9fd7a606438cee90a4aece0b6.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
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

Subsystems providing external ubufs to the net layer, i.e. ->msg_ubuf,
might have a better way to refcount it. For instance, io_uring can
ammortise ref allocation.

Add a way to pass one extra ref to ->msg_ubuf into the network stack by
setting struct msghdr::msg_ubuf_ref bit. Whoever consumes the ref should
clear the flat. If not consumed, it's the responsibility of the caller
to put it. Make __ip{,6}_append_data() to use it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/socket.h | 1 +
 net/ipv4/ip_output.c   | 3 +++
 net/ipv6/ip6_output.c  | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index ba84ee614d5a..ae869dee82de 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -72,6 +72,7 @@ struct msghdr {
 	 * to be non-NULL.
 	 */
 	bool		msg_managed_data : 1;
+	bool		msg_ubuf_ref : 1;
 	unsigned int	msg_flags;	/* flags on received message */
 	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
 	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 3fd1bf675598..d73ec0a73bd2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1032,6 +1032,9 @@ static int __ip_append_data(struct sock *sk,
 				paged = true;
 				zc = true;
 				uarg = msg->msg_ubuf;
+				/* we might've been given a free ref */
+				extra_uref = msg->msg_ubuf_ref;
+				msg->msg_ubuf_ref = false;
 			}
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f4138ce6eda3..90bbaab21dbc 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1557,6 +1557,9 @@ static int __ip6_append_data(struct sock *sk,
 				paged = true;
 				zc = true;
 				uarg = msg->msg_ubuf;
+				/* we might've been given a free ref */
+				extra_uref = msg->msg_ubuf_ref;
+				msg->msg_ubuf_ref = false;
 			}
 		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
 			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
-- 
2.36.1

