Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39815269A8
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383446AbiEMS4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383442AbiEMS4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:56:02 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716686B7DD
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:55:58 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id l11so8274280pgt.13
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d/E96Ds0GUwoQ5W7o3zVaOAL/f9+dTNzBDNkL2TLe2c=;
        b=MI/RKOccQaX92yRkITDRiLQyOz+EI3d1YM9m3/Soc6bGTGzljFGlCOm+c0nROnSDLj
         ak31jouH9B6tJPR9w3FKxfty6KQiPT/Ac3eY1WHEZ5FBFmoX5wb+mWcccXM9SFxCaECX
         A5rxf/rUACRtZ5dpwvQbd8KbAsMJEdnZLv+ZgTt8e2rw+jhfzHjBjnRxQDdxtnkmcy4b
         ssxgp2K39Z7Hav/Rw7bKWosUdTRVTA/XwZFZVdB4CrUiHk53RvxIS5SFFw/ClCW408Z0
         kTecF6CS1EARnyq6aGG/HPCTLK7mrfBRPtG6YrgmRI8r0TQMXEBr5ZMtnbLrg2BaHLBF
         wo+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d/E96Ds0GUwoQ5W7o3zVaOAL/f9+dTNzBDNkL2TLe2c=;
        b=q7Q6+W7duyq+CkzYaXrCvH4NUOLzE41k6Ogu4lIg8ns/7l395CJyekM2GVbQR2hUAB
         c0SBkUVOEJP4W0Fh2C+6u3S6SZmBRKKNUJeXKd/OdzXxL9fE7Bi3YzL1KgGh+JjKB0ZY
         5VUZyboQ9A3ckeR3MylpSyN1TpSngToMIi55SyRTM+0V//CbUFXMY3NEPALuj+i5KxFL
         Pl2hYiSBx5Z0iAC5bHWxC35xNW1rkiWJQwqmtU2qmewFwghCy+1ZktSPMxIjNY8389pX
         CSLOfxIRoHTXXCaLQhom6c+TdtniBd7zk3usDyJBJDUZmH15VR9E6RwTqBKo2aw9e/gF
         UcaQ==
X-Gm-Message-State: AOAM533E4vkZYSr25WZYEfCO5B3Y7MOgsHXuQY7EGV0ch4zqZD1R0wwh
        vDjIkWBGz8AfCMuYSJytCtY=
X-Google-Smtp-Source: ABdhPJzUrVPw2GCOF96IPPkNkvUxOx0TyTsRADaFknYJTGZhvMFKhApR5rTkXFw4vosR4JMG529Ovg==
X-Received: by 2002:a05:6a02:287:b0:3c6:b341:e3ba with SMTP id bk7-20020a056a02028700b003c6b341e3bamr4968555pgb.271.1652468158519;
        Fri, 13 May 2022 11:55:58 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b0015e8d4eb2absm2159537pli.245.2022.05.13.11.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:55:58 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 03/10] tcp: sk->sk_bound_dev_if once in inet_request_bound_dev_if()
Date:   Fri, 13 May 2022 11:55:43 -0700
Message-Id: <20220513185550.844558-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513185550.844558-1-eric.dumazet@gmail.com>
References: <20220513185550.844558-1-eric.dumazet@gmail.com>
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

inet_request_bound_dev_if() reads sk->sk_bound_dev_if twice
while listener socket is not locked.

Another cpu could change this field under us.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_sock.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 234d70ae5f4cbdc3b2caaf10df81495439a101a5..c1b5dcd6597c622dfea3d4a646f97c87acb7ea32 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -116,14 +116,15 @@ static inline u32 inet_request_mark(const struct sock *sk, struct sk_buff *skb)
 static inline int inet_request_bound_dev_if(const struct sock *sk,
 					    struct sk_buff *skb)
 {
+	int bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	struct net *net = sock_net(sk);
 
-	if (!sk->sk_bound_dev_if && net->ipv4.sysctl_tcp_l3mdev_accept)
+	if (!bound_dev_if && net->ipv4.sysctl_tcp_l3mdev_accept)
 		return l3mdev_master_ifindex_by_index(net, skb->skb_iif);
 #endif
 
-	return sk->sk_bound_dev_if;
+	return bound_dev_if;
 }
 
 static inline int inet_sk_bound_l3mdev(const struct sock *sk)
-- 
2.36.0.550.gb090851708-goog

