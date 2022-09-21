Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB5B5DEA8D
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiIUSRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 14:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiIUSRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 14:17:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9749DB76
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:17:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j6-20020a17090a694600b00200bba67dadso6760415pjm.5
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=TAOzDmWaXjDpu92ymep39C8byZVXNxedraAUyHMuThs=;
        b=apk0zui4MAGUBSTv1fhPbpyZv7Z2x0KUrQNmRlQJmmFnS3N3u46zk/2YIezFEWsY3c
         LU/MzqZGB0+Y5uQm9lZgggaS9Y0NrBWDoGK5CMFutgJfHSsksdcidnqUW5+O7yiEexDw
         iRlnRrgDCSOFedVVRjry4FoWKw2eokrFr8C3NBmEvkI3Hmr9o1rxa5LFmwCzDKQEp488
         H6h7BySc72tiTOSvuE3dm68lH5oGkOZmUOD4sPc/TQa29iBePkH+kozbyy5Tsk6AK/9Q
         9PcW80Avx3TsHUxdQa36cuEGud458b3kJg2+QALsElCaw+JObpdT4vDaa1tZs/2rZp8s
         LVxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=TAOzDmWaXjDpu92ymep39C8byZVXNxedraAUyHMuThs=;
        b=8FNHp77RmCEFh026t6DgMc6sz9ATsRE27YThHM5g+Tfa7V2Fg3lN8LlL3+84LN/Ugz
         pQyg+pLN/6oDXdbFSFYY/2DileUdYyJSTetr7ntatvI6xO11aki5UAI0FF4V2hVOhf6p
         UsTQTCd36iKV2Opa+ft5ZdDmCR2Lxr+hJXXTfFZqEJpVXFFmhFftg9tC8E4T6IgJFqOp
         V7HZ0AFyJkQy03VhL+15m1EDX55B2NCJQCkOP2BVfRtTwLLJO0BRBLEd6DZu3m4uJSsX
         k5ywSVgCr4KVLz3xaJwTU6BnHd84FiJnNNWUZ3HRH1XORMa7bNtBsVmssGmjHdd2a+UZ
         Y8XA==
X-Gm-Message-State: ACrzQf33Th814Is/dwvrJ+4tR0p6GL6hN4zdRcsDPMKrVa335Z/t31dz
        YG1Vq5XowzVB49sljisZnKaR5U+3I/ah5A==
X-Google-Smtp-Source: AMsMyM4S4YNCw6zPTkAqbxccqJ1jgzwiyYoIFn2HVIVbA+4G9I0wHjG+8/mlraqJPV4C+EY/QYbkxQ==
X-Received: by 2002:a17:902:d18c:b0:178:292b:a89f with SMTP id m12-20020a170902d18c00b00178292ba89fmr6110031plb.85.1663784241698;
        Wed, 21 Sep 2022 11:17:21 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id px13-20020a17090b270d00b001fbb6d73da5sm2205510pjb.21.2022.09.21.11.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 11:17:21 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH net-next v3] ethtool: tunnels: check the return value of nla_nest_start()
Date:   Wed, 21 Sep 2022 11:17:16 -0700
Message-Id: <20220921181716.1629541-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Check the return value of nla_nest_start(). When starting the entry
level nested attributes, if the tailroom of socket buffer is
insufficient to store the attribute header and payload, the return value
will be NULL. It will cause null pointer dereference when entry is used
in nla_nest_end().

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 net/ethtool/tunnels.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index efde33536687..67fb414ca859 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -136,6 +136,8 @@ ethnl_tunnel_info_fill_reply(const struct ethnl_req_info *req_base,
 			goto err_cancel_table;
 
 		entry = nla_nest_start(skb, ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY);
+		if (!entry)
+			goto err_cancel_entry;
 
 		if (nla_put_be16(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,
 				 htons(IANA_VXLAN_UDP_PORT)) ||
-- 
2.25.1

