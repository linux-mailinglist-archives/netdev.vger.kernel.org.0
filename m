Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A2A4E794B
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 17:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377007AbiCYQwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 12:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356491AbiCYQwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 12:52:01 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1305BC12DA
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 09:50:27 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t13so5650808pgn.8
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 09:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2uDH1A9SwpIBpZFTTBKz6ZWmvOxaTuFLYgAMD/BhjP8=;
        b=aWSZUrxyBDDLvNSP/wSwIdSY4h7cZLE1n+nkrnvb2/HX8kjuig6/wELI7jHsF6R52V
         6oNUBKP7Zu1ZdmXJN71Vi4OAwr5KC7cZshqW6ftFp9YRQsHu2IGeOAXW7+S7SarFNCzQ
         cfkDcAfCpabSUCwMfxRX/b37NqhFmbMu7SxlDKnxzidty2FJq6WbciEPu7NYu0kmJ854
         xMPy8KD2IJ78LOWrvUb9sz/vHKC+pCYR15j3LQLzsBsqlxoNGiUfyXLgziSEND3xQfBA
         nXtkJIhQ8aDhtw4RWW0sK5CIhGZxGa5+GGnZ5c1FzB5DfquJMwIQLmh9kdWyiwekIBMg
         IWEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2uDH1A9SwpIBpZFTTBKz6ZWmvOxaTuFLYgAMD/BhjP8=;
        b=djAdSU2x4K25m9kO/guDnYSHvS2z952EfvrhG/FjWc8CIEtmKi4z9zXbTP0gx1t3b4
         y8fTH2c5TKmUIPwlMlGH53TSsKAyVr4ICrD4m+5wfqvdXnsBdOdxz9vpZTYz2NGfX4kb
         vF/h8ZYfmsPu+v+wUpPoI10zTLUHsO1y2ctVwKGe1Qp5w7erZsBX2gPiD3QiyPY5gfED
         On+N9AxdKpX+qstCpQTbdx7j0nDguX96vUXiRXulR7u5VLhgEsuwcf7YWlzI8fNVJx8O
         c1w7rFyZF5zhkmAFTc5MDID9vaSPG6x+6k06IwsVD4A2ZQ8EnopsU2SZA8zlIUrOlTLs
         ExYQ==
X-Gm-Message-State: AOAM532EXt6r/PKFngs0xacG8mWD3bl3GvUgJRKPNGCTUaon2QP+rQfR
        KXQXq4k2ZNhgovcLjHN9kPE=
X-Google-Smtp-Source: ABdhPJyJ5erkpZdscEaXTjoRuMQOfW+/JpgqHFqZ/F4S8Wjojd3GW1buCWBCDfJBJwrth5wal3wzug==
X-Received: by 2002:a63:9858:0:b0:398:ae5:4d3f with SMTP id l24-20020a639858000000b003980ae54d3fmr369464pgo.295.1648227026565;
        Fri, 25 Mar 2022 09:50:26 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3df1:3ed5:ad16:dfd6])
        by smtp.gmail.com with ESMTPSA id y3-20020a056a00190300b004fa2411bb92sm7534895pfi.93.2022.03.25.09.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 09:50:25 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: [PATCH net] net/smc: fix a memory leak in smc_sysctl_net_exit()
Date:   Fri, 25 Mar 2022 09:50:21 -0700
Message-Id: <20220325165021.570708-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
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

Recently added smc_sysctl_net_exit() forgot to free
the memory allocated from smc_sysctl_net_init()
for non initial network namespace.

Fixes: 462791bbfa35 ("net/smc: add sysctl interface for SMC")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Tony Lu <tonylu@linux.alibaba.com>
Cc: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/smc_sysctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
index bae19419e7553222d74c2ae178fd5a2b6116679b..cf3ab1334c009a1a0539b2c228c4503ae391d89b 100644
--- a/net/smc/smc_sysctl.c
+++ b/net/smc/smc_sysctl.c
@@ -61,5 +61,10 @@ int __net_init smc_sysctl_net_init(struct net *net)
 
 void __net_exit smc_sysctl_net_exit(struct net *net)
 {
+	struct ctl_table *table;
+
+	table = net->smc.smc_hdr->ctl_table_arg;
 	unregister_net_sysctl_table(net->smc.smc_hdr);
+	if (!net_eq(net, &init_net))
+		kfree(table);
 }
-- 
2.35.1.1021.g381101b075-goog

