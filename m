Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E716515988
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 03:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379526AbiD3BSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 21:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237041AbiD3BSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 21:18:51 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E2B4D62E
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 18:15:27 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id h12so8493637plf.12
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 18:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9XJdvhBXd3aLoG9Te/VyMOcNa2DL4qyFc+bqCOIoF0g=;
        b=LooyucWEmI1VcfttRrepN9sgYGcx4BH2ZZGhXw5Iqz+qcy2EZ2cgm6NT4arEKQKSdQ
         /rBF0BWCC+w5wzpOYnRBSdfiUorfW48r0oP8pO/C/n4KFpDJqLlTeIJQguV44sJUIvi2
         7mcsxQX3LWf7Q9hnT9drRCVJJ8Bd0CVaCuPt/pMzr+lxuylP9T64GMDaEBSZXvGz2W5p
         p9qsVo4NkEZYmADuheez24IfOYx+UafDWqxgIMs6ViSz8a8Zjw6YJkJJu4XYnMZGAXX4
         hFJmka7XGD5UMAiKmreR6Wc9Pcj13bxuPRvk+1s2nHRme5ZfCZeMBK/xWuI5WygwDoLm
         Gedw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9XJdvhBXd3aLoG9Te/VyMOcNa2DL4qyFc+bqCOIoF0g=;
        b=ktX3ZplzJQTVMP7KuIUGJ2aFUg2q7T273YfHdLnUCxIqiPqLT0fxfCGEJyTqLgwwN5
         w1RBnFzMa8a+lc2QkSLybpl/656tO6Bmykg8qkSHFvH4lMN0gd46q30sUE4WAtlgewI6
         4l376MBJWlJc7wbpCiJprJ1WcvjkVx8+Px9nJAs3e0GF89m3v+tAFNeEAm6mbF5LLh0O
         sW33FeZ71O/0x4nvq/vmiZzrCtVRIA2U/kSePivbDuMfxWk2YCEHxoht7tNTu2K+wkoE
         bDrSSHDru/K/5QRl6m+XpXWf3XHQpIdoFGP9ac9RaN/fVMQ6YbbysSXju0OgRhJAbB+V
         V6Lg==
X-Gm-Message-State: AOAM531tZZH6WvIuZ2TbKKfjE4r+TEBWKG49OsZW++FCUdgBgvayB+9T
        MhcgkE7Juwjx3/0VD2ksG8k=
X-Google-Smtp-Source: ABdhPJxEhpU0G92yVv93+lRFf4KPt2qjA6poUZvSjX+RK78EnXNZyXl8+5AAOZxy0jpJbS2oJXrY5w==
X-Received: by 2002:a17:903:187:b0:15e:7b27:e150 with SMTP id z7-20020a170903018700b0015e7b27e150mr1902428plg.172.1651281327173;
        Fri, 29 Apr 2022 18:15:27 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:133:25fd:b54a:4099])
        by smtp.gmail.com with ESMTPSA id d12-20020a170902654c00b0015e8d4eb24dsm215970pln.151.2022.04.29.18.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 18:15:26 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] tcp: drop skb dst in tcp_rcv_established()
Date:   Fri, 29 Apr 2022 18:15:23 -0700
Message-Id: <20220430011523.3004693-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
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

From: Eric Dumazet <edumazet@google.com>

In commit f84af32cbca7 ("net: ip_queue_rcv_skb() helper")
I dropped the skb dst in tcp_data_queue().

This only dealt with so-called TCP input slow path.

When fast path is taken, tcp_rcv_established() calls
tcp_queue_rcv() while skb still has a dst.

This was mostly fine, because most dsts at this point
are not refcounted (thanks to early demux)

However, TCP packets sent over loopback have refcounted dst.

Then commit 68822bdf76f1 ("net: generalize skb freeing
deferral to per-cpu lists") came and had the effect
of delaying skb freeing for an arbitrary time.

If during this time the involved netns is dismantled, cleanup_net()
frees the struct net with embedded net->ipv6.ip6_dst_ops.

Then when eventually dst_destroy_rcu() is called,
if (dst->ops->destroy) ... triggers an use-after-free.

It is not clear if ip6_route_net_exit() lacks a rcu_barrier()
as syzbot reported similar issues before the blamed commit.

( https://groups.google.com/g/syzkaller-bugs/c/CofzW4eeA9A/m/009WjumTAAAJ )

Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cc3de8dc57970c97316ad1591cac0ca5f1a24c47..97cfcd85f84e6f873c3e60c388e6c27628451a7d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5928,6 +5928,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPHPHITS);
 
 			/* Bulk data transfer: receiver */
+			skb_dst_drop(skb);
 			__skb_pull(skb, tcp_header_len);
 			eaten = tcp_queue_rcv(sk, skb, &fragstolen);
 
-- 
2.36.0.464.gb9c8b46e94-goog

