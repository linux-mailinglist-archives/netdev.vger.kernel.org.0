Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9DD683434
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjAaRqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjAaRqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:46:10 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026B54212
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:46:05 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id n6so12554069edo.9
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XbAWFwXbBy+KQqySv5cyasj4rmJeuEKmdXJrUasQvjQ=;
        b=WI0zZvv7UtakDtMck7VlbJBzx7evB9X5E1B1nrKfhUEbZexmM8EpolZpCf+tCF8FYH
         KcLl0BHdwO3HQzJbDU2znwAotgMqvg6BDdncvojNM2jfmF9M9SoFYX5zJbwIh9aU2urg
         YoPow/wSM0MQeLGhIdAgPnr8gYFAPoBC3MIQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XbAWFwXbBy+KQqySv5cyasj4rmJeuEKmdXJrUasQvjQ=;
        b=JkR+2qyfoYof1TtU9XC9VVlmb9sLK7DiCNfs20AK3FdW/pyWs7WN7OECNrldLCWp4L
         k6kDHy4tn6iXCVa3V4ZuTtemn8ley71ficLDUnosW3woBFLDHORAzTlhlrJDay9sf/lQ
         Ojl67RFTzY67r0icgIHoA7Hr8HgohcDN+B0TSTfYOtvcWEoKb6l5FBeQ4Tzw41coH7aV
         bd+0BTvTB+V8R8iJ3dorEV8efFu6R3hZYCVHhsH7VoxaiA11HyiK8jcIz6Lc8eqeFnSB
         4lWZ84iTUNZAZ6YriW0mbDMUMFNQeukJs/1ViEYlrzexRxzZqWOb5GJ6hfoPdUILxZ9U
         Fd+w==
X-Gm-Message-State: AO0yUKVQhJs4H/qz8nWMY3bHpVgvrN8hjmB6J5+Xvd0iyKOmUKxCEoqG
        4w7Ddm1IznuYPLzjgdbpFvqJ6RtSQLRUR/QD
X-Google-Smtp-Source: AK7set+73ZTSK71b2aXzEfwNqvxc7ynn7w3zn5YbXhC9L8p0RLiOC5XagYp+zkXHy83zaJya2qydew==
X-Received: by 2002:a05:6402:5307:b0:4a2:112c:ca11 with SMTP id eo7-20020a056402530700b004a2112cca11mr4571363edb.31.1675187163188;
        Tue, 31 Jan 2023 09:46:03 -0800 (PST)
Received: from cloudflare.com (79.191.53.204.ipv4.supernova.orange.pl. [79.191.53.204])
        by smtp.gmail.com with ESMTPSA id dn10-20020a05640222ea00b00482b3d0e1absm8609683edb.87.2023.01.31.09.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 09:46:02 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel-team@cloudflare.com
Subject: [PATCH net] udp: Pass 2 bytes of data with UDP_GRO cmsg to user-space
Date:   Tue, 31 Jan 2023 18:46:01 +0100
Message-Id: <20230131174601.203127-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While UDP_GRO cmsg interface lacks documentation, the selftests added in
commit 3327a9c46352 ("selftests: add functionals test for UDP GRO") suggest
that the user-space should allocate CMSG_SPACE for an u16 value and
interpret the returned bytes as such:

static int recv_msg(int fd, char *buf, int len, int *gso_size)
{
	char control[CMSG_SPACE(sizeof(uint16_t))] = {0};
	...
			if (cmsg->cmsg_level == SOL_UDP
			    && cmsg->cmsg_type == UDP_GRO) {
				gsosizeptr = (uint16_t *) CMSG_DATA(cmsg);
				*gso_size = *gsosizeptr;
				break;
			}
	...
}

Today user-space will receive 4 bytes of data with an UDP_GRO cmsg, because
the kernel packs an int into the cmsg data, as we can confirm with strace:

  recvmsg(8, {msg_name=...,
              msg_iov=[{iov_base="\0\0..."..., iov_len=96000}],
              msg_iovlen=1,
              msg_control=[{cmsg_len=20,         <-- sizeof(cmsghdr) + 4
                            cmsg_level=SOL_UDP,
                            cmsg_type=0x68}],    <-- UDP_GRO
                            msg_controllen=24,
                            msg_flags=0}, 0) = 11200

This means that either UDP_GRO selftests are broken on big endian, or this
is a programming error. Assume the latter and pass only the needed 2 bytes
of data with the cmsg.

Fixing it like that has an added advantage that the cmsg becomes compatible
with what is expected by UDP_SEGMENT cmsg. It becomes possible to reuse the
cmsg when GSO packets are received on one socket and sent out of another.

Fixes: bcd1665e3569 ("udp: add support for UDP_GRO cmsg")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/udp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index a2892e151644..44bb8d699248 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -125,7 +125,7 @@ static inline bool udp_get_no_check6_rx(struct sock *sk)
 static inline void udp_cmsg_recv(struct msghdr *msg, struct sock *sk,
 				 struct sk_buff *skb)
 {
-	int gso_size;
+	__u16 gso_size;
 
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
 		gso_size = skb_shinfo(skb)->gso_size;
-- 
2.39.1

