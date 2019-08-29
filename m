Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1BFFA216E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 18:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbfH2Qvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 12:51:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54951 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbfH2Qvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 12:51:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id k2so3019151wmj.4;
        Thu, 29 Aug 2019 09:51:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R7bQjRL07IuVsHCtVeRWC7Ozbw5wqGaVAOPZV3WXpeY=;
        b=H26Dsc71O5Ve/OWoye0L/8NyxvJKumkUvMSCymGEha1PnFP69RgehYppLxtnbD1SIp
         iBPQQuH6PCj9Ja6MPhcl1Dyh8uc0qjtsK3kODhfggfgnpb6y6XqgynkmJbHmUtbg+k/t
         t8E2rZQVDYA6bC9021rP3kJutev+J71c7y364GXcP3kaFXc35pXVpJQqXjKD1JnUO/nG
         JflEJmGqWLPLKHAGH0WAH5QHMt/MyvRXQTuo1/thFpAADSMPz4mtp3UVyNkZpR/Vl1JE
         riMhLrdzaqACHtLejND/H5FejP9e+/eq/SYZMD39FpgPPjDjPEOctKIf1AMNGZxee9Tf
         JU/w==
X-Gm-Message-State: APjAAAUWLl3yyAcPOsrXeoBkrGs1XBr2aq1in37ARZtVC8V6mMXKg0Fw
        YIzGhXvTgpMhlLV5RFg8/rgmbsRlApA=
X-Google-Smtp-Source: APXvYqzTmh2+e2leEekpXmNMpY4aP3o8KTvYfQbZV2OZbD3uqcbnn3dsLHg/snrcTlKH8UIZSfw2HA==
X-Received: by 2002:a1c:7a14:: with SMTP id v20mr13537744wmc.75.1567097503479;
        Thu, 29 Aug 2019 09:51:43 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id o14sm8340770wrg.64.2019.08.29.09.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 09:51:43 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-kernel@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH v3 10/11] udp: Remove unlikely() from IS_ERR*() condition
Date:   Thu, 29 Aug 2019 19:50:24 +0300
Message-Id: <20190829165025.15750-10-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190829165025.15750-1-efremov@linux.com>
References: <20190829165025.15750-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"unlikely(IS_ERR_OR_NULL(x))" is excessive. IS_ERR_OR_NULL() already uses
unlikely() internally.

Signed-off-by: Denis Efremov <efremov@linux.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org
---
 include/net/udp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 79d141d2103b..bad74f780831 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -480,7 +480,7 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	 * CB fragment
 	 */
 	segs = __skb_gso_segment(skb, features, false);
-	if (unlikely(IS_ERR_OR_NULL(segs))) {
+	if (IS_ERR_OR_NULL(segs)) {
 		int segs_nr = skb_shinfo(skb)->gso_segs;
 
 		atomic_add(segs_nr, &sk->sk_drops);
-- 
2.21.0

