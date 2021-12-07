Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680B746AFD5
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351756AbhLGBfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351679AbhLGBem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:42 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CD7C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:31:13 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so992757pjj.0
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tFp3iCnBAeqbp2p9+t6Hx+bNUCDIXLv2nivTrYVAbTY=;
        b=ihzBWGfF68dd+iFvYKzUnaPPwCWl2nosR/jldU2BXnkMDLQifdn33ty67cBPeaFVF3
         p6VJuXnPuDaHVy2Vd9GRiIiHgxUnVlTXqn5bXQAidW46waMSb5tJE1eWz5ISsp6TAHeO
         lWAJQoPknmaA/uYzizIYxRTmzmWEk6WS4mLMYTkqay1JM5SIKLa8hgn6PrRaTpmJjowj
         /SsOAWaCX2sWLzbPI71Ht5yfgd74G9RSvlyaeloPXr31v4DYcwWRFD/mhLz+uHMI2yAi
         c7J1HsT/jB3FILcQF3j1C2IMLXqJTk4luuD/3VjsbtUIoiDczwrTDZgLilyp1EPDDDZi
         Kj/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tFp3iCnBAeqbp2p9+t6Hx+bNUCDIXLv2nivTrYVAbTY=;
        b=rRkVl2nOYnZkUhcB4aoEFaxF0KW0AY5iUXbuaNipyJ3GqyAP37zLWDnUYEG2v5XJiB
         UxjRHPjDKYYFdhy9H7HFqD7CpsUdLu0Cj4nrsEBmv1CQKWof/7rCpWOZbaA/Gb3oWF4T
         sR+i2EPciSJDrLtYM+mu60E1BdlFY5DJfecKACqe5uaZBikaWiwiIMUE2t8T15Ov3fLr
         WxiCTZosNXeL/mx2cjzEpkDfyNs0VUivch2qymmFHr2+Qcxtliy69h84+HEJNOKv+FGo
         Rx5yprIcx8ISjlhlO9DU59URsR1rneiqzUnx3QDwZtVfMaGcolnEfrRNnEmZhoUYql84
         bl8Q==
X-Gm-Message-State: AOAM532kUV3PaKGKPKsoc4JQ+mWVpi/C2LY+QjmjSZu8PYBlhkUVmJcb
        00KIK9T85w3PWlpO5fI5woo=
X-Google-Smtp-Source: ABdhPJwvL1C5DecBSByU8PSJu4ctRb1ikHLkuIk+7kHR50TAi5a8cd7c6TmcVA0PohbOH6IfflNSxQ==
X-Received: by 2002:a17:90b:4b0e:: with SMTP id lx14mr2842643pjb.160.1638840672987;
        Mon, 06 Dec 2021 17:31:12 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:31:12 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 08/13] llc: add net device refcount tracker
Date:   Mon,  6 Dec 2021 17:30:34 -0800
Message-Id: <20211207013039.1868645-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/llc_conn.h | 1 +
 net/llc/af_llc.c       | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/llc_conn.h b/include/net/llc_conn.h
index ea985aa7a6c5e64b6802c2399ad47db23fdbd9bf..2c1ea3414640523a3efc20ad626ae9896a418d1b 100644
--- a/include/net/llc_conn.h
+++ b/include/net/llc_conn.h
@@ -38,6 +38,7 @@ struct llc_sock {
 	struct llc_addr	    laddr;		/* lsap/mac pair */
 	struct llc_addr	    daddr;		/* dsap/mac pair */
 	struct net_device   *dev;		/* device to send to remote */
+	netdevice_tracker   dev_tracker;
 	u32		    copied_seq;		/* head of yet unread data */
 	u8		    retry_count;	/* number of retries */
 	u8		    ack_must_be_send;
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 3086f4a6ae683f1119d4813648bf9fd9ba215436..26c00ebf4fbae4d7dc1c27d180385470fa252be0 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -224,7 +224,7 @@ static int llc_ui_release(struct socket *sock)
 	} else {
 		release_sock(sk);
 	}
-	dev_put(llc->dev);
+	dev_put_track(llc->dev, &llc->dev_tracker);
 	sock_put(sk);
 	llc_sk_free(sk);
 out:
@@ -295,6 +295,7 @@ static int llc_ui_autobind(struct socket *sock, struct sockaddr_llc *addr)
 		llc->dev = dev_getfirstbyhwtype(&init_net, addr->sllc_arphrd);
 	if (!llc->dev)
 		goto out;
+	netdev_tracker_alloc(llc->dev, &llc->dev_tracker, GFP_KERNEL);
 	rc = -EUSERS;
 	llc->laddr.lsap = llc_ui_autoport();
 	if (!llc->laddr.lsap)
@@ -362,7 +363,7 @@ static int llc_ui_bind(struct socket *sock, struct sockaddr *uaddr, int addrlen)
 	} else
 		llc->dev = dev_getbyhwaddr_rcu(&init_net, addr->sllc_arphrd,
 					   addr->sllc_mac);
-	dev_hold(llc->dev);
+	dev_hold_track(llc->dev, &llc->dev_tracker, GFP_ATOMIC);
 	rcu_read_unlock();
 	if (!llc->dev)
 		goto out;
-- 
2.34.1.400.ga245620fadb-goog

