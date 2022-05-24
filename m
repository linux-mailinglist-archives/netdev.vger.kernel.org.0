Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4825D5323FA
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 09:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbiEXHYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 03:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbiEXHYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 03:24:10 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E78C6B000;
        Tue, 24 May 2022 00:24:09 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id cs3-20020a17090af50300b001e0808b5838so451516pjb.1;
        Tue, 24 May 2022 00:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nTcFKLkDBA6jRYy2mtPleJQoONMBj7ZRRLXH8hC/tfk=;
        b=pFZa7KuJ+sTtMBfFwlkVBYyzcAEhfhS0txQVvRmdQcd9tk6UZeVZjUGz0rSi0XCyIb
         rPM42nafFRczXUCdWmkeQgZff9+vAPGmQ0aOKeOWOK6GyN4WryFfroJvRA9TvDux91zK
         dEV+VY5gakPcM3DGTNEpKt0YGksbTdEgHHiW5DXjuh0ov6cB465Hr866SEVK6MurMQpH
         kELDCpgEavi7QLL/Yk8wg2qtHY5w6v83UKRefsKwVarXCghhm4XjEyYs2wQIQagoGTcW
         KZ0DVA9XFFblBdM9rnEW+vqcY/XMW3jZQGShecMMlP6SEshPTZyMXKTDpm87Qqiq8SEY
         x57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nTcFKLkDBA6jRYy2mtPleJQoONMBj7ZRRLXH8hC/tfk=;
        b=T+WvqfHVbeyUNzTmbTnk5d+Ylbu11fCVMSCrI0HH3feP8xgwuPPWrpEZ0yWIF/ZqTq
         i1PcE73cCziUyPBuOOMiud9RoaBWOZQRjmly+Qha5OxJLFZG410+VpDyGppjo59wFyvV
         RBRNU9RsH14KzLaOu84YpkWeQ39jQGZjrtrobzrXawfWIZ2KMP/sdnG9CjKSD1f+s8HN
         oXi/XZTFryBpZwpzJXeFG6bEXxQu9C5opcnsW4+4wF4KKAwN8tYAAVKf9HlcePnET03U
         AWH/TQ+Or0FBIqq3w32oX5qN21ZlxWYNkKhkLAn8Uu5aQuZagRjU9aJaL8nMb4hFpoa8
         s0VQ==
X-Gm-Message-State: AOAM5328bkbugwM1FiM7Vrok+6sgun493ClJIn68TDiwDDxp89GpaYLn
        BtFRFjt60Tt2qhnyVaGoNBY=
X-Google-Smtp-Source: ABdhPJxXWdxPWkpixsfSskmk7+SHYfuFb213e3tNOIwjWlUNNgUvkHFQRZvkiv1EruxvlImiYSIdjg==
X-Received: by 2002:a17:90b:224a:b0:1e0:f91:3a3f with SMTP id hk10-20020a17090b224a00b001e00f913a3fmr3235681pjb.62.1653377049099;
        Tue, 24 May 2022 00:24:09 -0700 (PDT)
Received: from localhost.localdomain ([103.167.134.51])
        by smtp.gmail.com with ESMTPSA id t12-20020a170902e84c00b0015e8d4eb244sm5997064plg.142.2022.05.24.00.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 00:24:08 -0700 (PDT)
From:   Genjian Zhang <zhanggenjian123@gmail.com>
X-Google-Original-From: Genjian Zhang <zhanggenjian@kylinos.cn>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huhai@kylinos.cn, zhanggenjian123@gmail.com
Subject: [PATCH] net: ipv4: Avoid bounds check warning
Date:   Tue, 24 May 2022 15:23:26 +0800
Message-Id: <20220524072326.3484768-1-zhanggenjian@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: huhai <huhai@kylinos.cn>

Fix the following build warning when CONFIG_IPV6 is not set:

In function ‘fortify_memcpy_chk’,
    inlined from ‘tcp_md5_do_add’ at net/ipv4/tcp_ipv4.c:1211:2:
./include/linux/fortify-string.h:328:4: error: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  328 |    __write_overflow_field(p_size_field, size);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: huhai <huhai@kylinos.cn>
---
 net/ipv4/tcp_ipv4.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 457f5b5d5d4a..ed03b8c48443 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1207,9 +1207,14 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	key->prefixlen = prefixlen;
 	key->l3index = l3index;
 	key->flags = flags;
+#if IS_ENABLED(CONFIG_IPV6)
 	memcpy(&key->addr, addr,
 	       (family == AF_INET6) ? sizeof(struct in6_addr) :
 				      sizeof(struct in_addr));
+#else
+	memcpy(&key->addr, addr, sizeof(struct in_addr));
+#endif
+
 	hlist_add_head_rcu(&key->node, &md5sig->head);
 	return 0;
 }
-- 
2.27.0

