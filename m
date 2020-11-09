Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831132ABE06
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgKIN7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730991AbgKIN7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:59:35 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8CEC0613CF;
        Mon,  9 Nov 2020 05:59:34 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id q5so5268384pfk.6;
        Mon, 09 Nov 2020 05:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZQzJKKt4uzjrRFSl3mDjwbikP5PjZvNDeMBTReKioBA=;
        b=CNrSrMzhRAe8BycT/VihxX80QHsZ4eBZO6O5ghk9vJGd/crz9MNtICGaJTJlBCg5eB
         Pp0vvKcGbpZJ4aOnvy3nnVgTivcS1LaNl5PX4iZwMY2eTBWXk7DF0feqiNakmsT3+awl
         sa5hZqiovdiOUtpHghtbW3fIk7fvVgJKvewBxrAMkwhEMHUIotkLPc2U2C1KAeMzf4MK
         2U3kIilP9bUch+cZQn3nBR0SpD+1kNeue8jIn79cQZ1Ij1hw5mlp4JffskDt++x+ksvZ
         qGkEoaVDsbLXG/WtWuq97JKKIrhjnthaA8HGZwam/+2Huxn9oiLWa2kwQNG9wNiyVQnG
         yllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZQzJKKt4uzjrRFSl3mDjwbikP5PjZvNDeMBTReKioBA=;
        b=rymq3o6DmW5SgcfwO4eK4n4bLrD1mosZcDWYm2zsZx7BJgBGEaXEBsBbkLNWAxEaeL
         HjTjY5nA7KRgALzpIvPwvguJSICeAUiu8vrt3ZmVl+2JMz+7/SgeHvZ1GTcQYUso2kbh
         xG7hRYRuiIE+SDL7ZWhvMnBg/WpZbu81sBSSlISRHEIuZZ3RxoMAWK2EOvl7DBG+KwMC
         MQ/F7JTe6GrO+ZlT85Zw5QXO7cj0sUTVHF/LKDR7P752//kcuuzWekHU7V70xNAiUyBC
         IzJUL2Tha1KtJhTWgXWr7NzMMRWwDMdpTgTQ226jMyOx1DN2RCyvNf7KBS8iD42nAzOL
         MSwQ==
X-Gm-Message-State: AOAM533hRJ9kU7usUTV32+N85sjJzJBjlZ9Ps20iokumfcVp/86b0wlV
        IDmWL7STBFvzYd620XxOht0=
X-Google-Smtp-Source: ABdhPJylyjr2UPg4t6JoPmDdRHSuS8ldb+M9pROgcq0fb84tA3vx1LoXJFP5TYx73cDshNyuibHiLw==
X-Received: by 2002:a62:d114:0:b029:18a:e114:1eb4 with SMTP id z20-20020a62d1140000b029018ae1141eb4mr14387707pfg.41.1604930373913;
        Mon, 09 Nov 2020 05:59:33 -0800 (PST)
Received: from localhost ([209.9.72.213])
        by smtp.gmail.com with ESMTPSA id f4sm5800397pjp.3.2020.11.09.05.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 05:59:32 -0800 (PST)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [MPTCP][PATCH net 1/2] mptcp: fix static checker warnings in mptcp_pm_add_timer
Date:   Mon,  9 Nov 2020 21:59:21 +0800
Message-Id: <ccf004469e02fb5bd7ec822414b9a98b0015f4a3.1604930005.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1604930005.git.geliangtang@gmail.com>
References: <cover.1604930005.git.geliangtang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following Smatch complaint:

     net/mptcp/pm_netlink.c:213 mptcp_pm_add_timer()
     warn: variable dereferenced before check 'msk' (see line 208)

 net/mptcp/pm_netlink.c
    207          struct mptcp_sock *msk = entry->sock;
    208          struct sock *sk = (struct sock *)msk;
    209          struct net *net = sock_net(sk);
                                           ^^
 "msk" dereferenced here.

    210
    211          pr_debug("msk=%p", msk);
    212
    213          if (!msk)
                    ^^^^
 Too late.

    214                  return;
    215

Fixes: 93f323b9cccc ("mptcp: add a new sysctl add_addr_timeout")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/mptcp/pm_netlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 6180a8b39a3f..03f2c28f11f5 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -206,7 +206,6 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 	struct mptcp_pm_add_entry *entry = from_timer(entry, timer, add_timer);
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
-	struct net *net = sock_net(sk);
 
 	pr_debug("msk=%p", msk);
 
@@ -235,7 +234,7 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 
 	if (entry->retrans_times < ADD_ADDR_RETRANS_MAX)
 		sk_reset_timer(sk, timer,
-			       jiffies + mptcp_get_add_addr_timeout(net));
+			       jiffies + mptcp_get_add_addr_timeout(sock_net(sk)));
 
 	spin_unlock_bh(&msk->pm.lock);
 
-- 
2.26.2

