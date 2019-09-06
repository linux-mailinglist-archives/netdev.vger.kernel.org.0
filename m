Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8BDAB16F
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 05:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbfIFD4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 23:56:48 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33022 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbfIFD4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 23:56:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so3419558pfl.0
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 20:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dzEH4Zb0fJYwz0b88XFn8r3UjqR1olItZ+8aDNoOL4s=;
        b=GyH7DI2ySiywRZL4cHKjUI642bH1KGe7uof4phberedrynJ+gDdKl8KAfBehy4Kesf
         VKnfwYQSL6NZQQn0pDI/NhA6jj8ACwC3hVZKzNTD29D38lmmN8gNT1Wyt+sa0TODdyfX
         xJHXbc3D034rJr4hjWzU4b91RPy/TURLLhty8EvxuRam4m6gCuvWLMfC1fgmKMfVnJxN
         7GZ5Vf9JP5Jxm82td8YMLmG9sIltz1U4GE9+TlGQ29Bd9XURARSfvSWLzY3+eIlh/dqA
         wFVcep5j2DUFBkSCUuZRkLYuAgbVDGXmK9kcD4m6w9R9bfp9TqfFEgaepXMD9OGNKzvc
         tLSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dzEH4Zb0fJYwz0b88XFn8r3UjqR1olItZ+8aDNoOL4s=;
        b=ty584YWIV++393pmePa6sFDqD9Co0XBQz/FOHlxrsvtsSwyi7pZtBm1wVuPYF7MZrA
         p8kYHNlnxZc43E6TGTsS4JzE3hwArFqZ1GPIJ1c6kFbz2CkiHZJJiY0igLmmHUsWsAYX
         9VRp1QUQ7osvYQhmzxFsw23zDwSmbm/QFsdSTzqlBy765rqmfjPHzVTlScamo1ySZRkC
         TtQiYmP7PVz8Wx4wxTtol2Gi1IQVwBST0wW3IIS2APDRAkB3/TPhpo1rauFp2sc8zEy9
         zPvVXNBnq720Y4JHod8Iz7cN8OEoSaUbV22qhv9sDYYDT6vDkfHLv4YKfGQvTCte2oa4
         /2yg==
X-Gm-Message-State: APjAAAU0AfkswgQOVJTavtSggrZxxE1AJF74AEUKqXTK+qz+iy26/BDn
        rG/8zZ5+s1nFzftmsJ2qRZA=
X-Google-Smtp-Source: APXvYqzfVxcWqwzCcf1IS7ES8/SpQhAwP2bf1xCqesJIdWEmaO22IBI2zqkSYYTbJ4PrQJDKARcqsg==
X-Received: by 2002:a62:aa0e:: with SMTP id e14mr8452393pff.182.1567742207532;
        Thu, 05 Sep 2019 20:56:47 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id d10sm4486428pfh.8.2019.09.05.20.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 20:56:46 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH] net-ipv6: addrconf_f6i_alloc - fix non-null pointer check to !IS_ERR()
Date:   Thu,  5 Sep 2019 20:56:37 -0700
Message-Id: <20190906035637.47097-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
In-Reply-To: <CANP3RGcbEP2N-CDQ6N649k0-cV4AhQeWqF-niz7EMPFOFpkU1w@mail.gmail.com>
References: <CANP3RGcbEP2N-CDQ6N649k0-cV4AhQeWqF-niz7EMPFOFpkU1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Fixes a stupid bug I recently introduced...
ip6_route_info_create() returns an ERR_PTR(err) and not a NULL on error.

Fixes: d55a2e374a94 ("net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128 local route (and others)'")
Cc: David Ahern <dsahern@gmail.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 003562dd3395..2fb2b913214c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4383,7 +4383,7 @@ struct fib6_info *addrconf_f6i_alloc(struct net *net,
 	}
 
 	f6i = ip6_route_info_create(&cfg, gfp_flags, NULL);
-	if (f6i)
+	if (!IS_ERR(f6i))
 		f6i->dst_nocount = true;
 	return f6i;
 }
-- 
2.23.0.187.g17f5b7556c-goog

