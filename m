Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3678A470955
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 19:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245593AbhLJSyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 13:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238591AbhLJSyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 13:54:18 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBCCC061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 10:50:43 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id gu12so8802585qvb.6
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 10:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jvt0hW8j62Yafyq4p5GRxEQBCjarrXPWPoRmQXorS+c=;
        b=EwJytH2Ez4PgXJCUl0six7eM5Je65NyotNZj1chqNHgX9HJHlTqAlpUCB6UV0jbC8P
         Q1P5nlZN077ek3moluRmp/Wl1pfnlsB89n7zjck+bLD/qKypuXp/nox6Qr+ly+fSIWQE
         U4jeLATUpQoY6+wpl1CXzvyhlG9W87jMxXUWyUM8vXuB49+GAFT/5yT+tMNEVZPjURJa
         8En6cVQQzhuN2HoJfi4ZZ1fg92A2DxM1tT29Sub9YPi0F+DUU7JCueyWzDRJkEm55b6Z
         C9b07tr2m72h4BmBRgflMrZxwtHuQGCsCA+WNxjxf/jwpzSWmJeUHWRyzcV51E29hIPW
         e52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jvt0hW8j62Yafyq4p5GRxEQBCjarrXPWPoRmQXorS+c=;
        b=Jt6bwPNJVKIccaoPY/ZV29afAr6m+Tuquw1I8SHE0Q0sjZafAzvmh9AXaxAJ5sqgFr
         kiDS7Z/PUv5X84pkMM1LEqNvg0juhJekIdggeGH7O/xz9jCqVF5viWJvWK9QL927utwy
         I/jTh2B4YGpk9Z6cg+E5q+aB46SuEbfGxznOLSEjGS+7hO9EbroqCJJL/lPrazI/DRqj
         S6ZSse6Oz6GeOtNSNiUK5wLBsi1N1A35pSb1IJBo4tAwM+Ayg3TsznXcT+ZA/gy581u3
         n4931928dnhy83/2PqT1wdt3R71QUydgdqpuZE97So+jmzTq4rt3go1y6wM3RnnbYgkU
         4JNg==
X-Gm-Message-State: AOAM530984d97MCVFPpktiQhgqaQTkQ/h+Q6l5qvt5CABGwLZ1mZ58vr
        yCo8M15OgPG2HR7BFj7K+bjQ94xVKNGQYQ==
X-Google-Smtp-Source: ABdhPJz1g7TJou6QMRZvYYK0/v/f4miOFVthDjCVEmETPZ0zFxoSIABy2On70QIlXoT0hzpsTc9kfg==
X-Received: by 2002:a05:6214:230a:: with SMTP id gc10mr26691237qvb.115.1639162242564;
        Fri, 10 Dec 2021 10:50:42 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bl8sm1694648qkb.38.2021.12.10.10.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 10:50:41 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        Hoang Huu Le <hoang.h.le@dektech.com.au>,
        davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net-next] tipc: discard MSG_CRYPTO msgs when key_exchange_enabled is not set
Date:   Fri, 10 Dec 2021 13:50:40 -0500
Message-Id: <30b1e3d5fb5d00c4200837107d26f445fd3a958f.1639162240.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When key_exchange is disabled, there is no reason to accept MSG_CRYPTO
msgs if it doesn't send MSG_CRYPTO msgs.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/link.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 09ae8448f394..8d9e09f48f4c 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1298,7 +1298,8 @@ static bool tipc_data_input(struct tipc_link *l, struct sk_buff *skb,
 		return false;
 #ifdef CONFIG_TIPC_CRYPTO
 	case MSG_CRYPTO:
-		if (TIPC_SKB_CB(skb)->decrypted) {
+		if (sysctl_tipc_key_exchange_enabled &&
+		    TIPC_SKB_CB(skb)->decrypted) {
 			tipc_crypto_msg_rcv(l->net, skb);
 			return true;
 		}
-- 
2.27.0

