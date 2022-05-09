Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D43520789
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiEIW03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiEIW0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:26:07 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C958F16D48A
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:22:11 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so524084pjb.1
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GYpPq4J8axpzp/fW72f0SY/pW+RvbiYhaWPc3DAnPYg=;
        b=XKRF0gBr6RxPYqW/sQg1YLqz3mj2KPqtYf2PPXanPYHXm4hts49rzMpI/VyHQYV7an
         BQRYiFyzTlNVQyfrbSdKWWT4h7pflL46F5xZY5gndB5ZJYFOfaIFeOoQ6oV4aQCT9mFB
         fwKiU7CAQ9kuoTRI3FIvEcUMokn+1aa1yOSS2/Cn4dtZ3ufzPeoLQAwRYMOTEr83pFDU
         NnF+VAxR2qSDe95KW6kF8oT74WcxWt4zcM1Pe0b6aq+6zZmgFYkNIbcUZ2TiRuPTDXRI
         eRY8CKg/h0o6EHpSrVSdkQJqEcPa5Lgj4FJbs84le7UDG7lbxipZdCfk/5UiMW/VLIGJ
         r2Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GYpPq4J8axpzp/fW72f0SY/pW+RvbiYhaWPc3DAnPYg=;
        b=Bd5gXU0ZyF9AiG0LBZ2w6sBOpTaEYcS5tZO+0UlBSEal7HMRS2r0nbhcU4Kc1LYgfo
         SQB8R4bBV7ojsUg92S/XOMquyjHkdbeXsTgmSstT7o8lked0JRChyvGQoPIYo236/Kz0
         ECPoB3t2YRlpC0vfoUzg09IAAL1Wia6db2XNaWx4+59KKZgxBdS/Z8c1otHWGQOZF4ye
         KXq+bbkLpncnua3t8+KvZ4pBFYx7CAEKX2IvKmSDJMJ80MfTjChcMVw0VV1RTHPf5I83
         QE8i1/M50r+r1gjuqF0oo6XEx+vHIpyJbPUJ8Pl47arVUJxIblH5PmDvtqjdxLZFWiN/
         0Btg==
X-Gm-Message-State: AOAM530nS2Z1Q1cqzQ9P+fR29B66d+S36iGSwiyR/PN7lXsauaR9LFSe
        f/XPn83xI8FaZGyu20NY8sw=
X-Google-Smtp-Source: ABdhPJxhUV/WPY+0v0GmgkeFwsv0itm+frv9sjQODLxnENSauZfpVtEkipwFVYSBaDBAPRvJQTgWYA==
X-Received: by 2002:a17:90b:380e:b0:1dc:d421:904a with SMTP id mq14-20020a17090b380e00b001dcd421904amr20631422pjb.152.1652134931347;
        Mon, 09 May 2022 15:22:11 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:22:10 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5 net-next 10/13] net: loopback: enable BIG TCP packets
Date:   Mon,  9 May 2022 15:21:46 -0700
Message-Id: <20220509222149.1763877-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509222149.1763877-1-eric.dumazet@gmail.com>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
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

Set the driver limit to GSO_MAX_SIZE (512 KB).

This allows the admin/user to set a GSO limit up to this value.

Tested:

ip link set dev lo gso_max_size 200000
netperf -H ::1 -t TCP_RR -l 100 -- -r 80000,80000 &

tcpdump shows :

18:28:42.962116 IP6 ::1 > ::1: HBH 40051 > 63780: Flags [P.], seq 3626480001:3626560001, ack 3626560001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 80000
18:28:42.962138 IP6 ::1.63780 > ::1.40051: Flags [.], ack 3626560001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 0
18:28:42.962152 IP6 ::1 > ::1: HBH 63780 > 40051: Flags [P.], seq 3626560001:3626640001, ack 3626560001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 80000
18:28:42.962157 IP6 ::1.40051 > ::1.63780: Flags [.], ack 3626640001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 0
18:28:42.962180 IP6 ::1 > ::1: HBH 40051 > 63780: Flags [P.], seq 3626560001:3626640001, ack 3626640001, win 17743, options [nop,nop,TS val 3771179265 ecr 3771179265], length 80000
18:28:42.962214 IP6 ::1.63780 > ::1.40051: Flags [.], ack 3626640001, win 17743, options [nop,nop,TS val 3771179266 ecr 3771179265], length 0
18:28:42.962228 IP6 ::1 > ::1: HBH 63780 > 40051: Flags [P.], seq 3626640001:3626720001, ack 3626640001, win 17743, options [nop,nop,TS val 3771179266 ecr 3771179265], length 80000
18:28:42.962233 IP6 ::1.40051 > ::1.63780: Flags [.], ack 3626720001, win 17743, options [nop,nop,TS val 3771179266 ecr 3771179266], length 0

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/loopback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 720394c0639b20a2fd6262e4ee9d5813c02802f1..14e8d04cb4347cb7b9171d576156fb8e8ecebbe3 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -191,6 +191,8 @@ static void gen_lo_setup(struct net_device *dev,
 	dev->netdev_ops		= dev_ops;
 	dev->needs_free_netdev	= true;
 	dev->priv_destructor	= dev_destructor;
+
+	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 }
 
 /* The loopback device is special. There is only one instance
-- 
2.36.0.512.ge40c2bad7a-goog

