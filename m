Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4679B4C8641
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 09:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbiCAITP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbiCAITO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 03:19:14 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418E611A10;
        Tue,  1 Mar 2022 00:18:34 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id bt3so9299655qtb.0;
        Tue, 01 Mar 2022 00:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IurrTkx6DCr4ulIznm4VdKXJFaHnNtzg1HfInKM99Es=;
        b=RdKHfPZSb0l9CM4WDiZIUSrO3kj+w7FMPxcBoiSZv3Iu8JJw48grUEm5aeE4V4UBYh
         SD0lrtG6hJIOBQFII5hnmnmFUqpeYD/QARF5xgeLmytrp4or6ZGaeztwcVZ35Qs5UpNP
         M2CRiGYVVVhWJP2Zz3tLNT/0KpKhg02zSQtuy7g2KL9MDCsfITO0LRzsiKXS5v2oYigX
         jYngmjIwOJ/mxOHToffx1UPitgcyhn2vs1COaAakaxSojPq7WodKGix5XXW5jZBULcL/
         DWTZtSRO4BSiPXBt+Gzw/xrLLIWNG2rl+crGNc1TSxSDFThllCuIUMIZrx1gk5OSrAFr
         YfFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IurrTkx6DCr4ulIznm4VdKXJFaHnNtzg1HfInKM99Es=;
        b=1pS5KkZpsZmMQuT6Cescdfe3UaR9Pc+IvkXIgQyPN96JkxTPpPiC2xBTGojefwV9gJ
         O7TsYzrbEeVXkftboVVTBILhI4zezB9164V1hOspTx5RwG1b0M1UUtZZVFcKpS2FEde8
         NoQze1TF4dfAyblAC2/DR78b+Xgknzc6wDBZM/c53X7jWN5+SvdzGp2BafLPqoIvvJx5
         gjclOiOB+nQvGOzIXnDoWZucR7ITfMx70L3et9tKC3HG4NIf9LsPb3bjzBGc3ZtssYV2
         A210rM6xAlKvvWU1sG7DhrrbswKWDZkDEGvq0XEMgRF0K7Jc+odugjKTi9ZhG46JMC1M
         opOA==
X-Gm-Message-State: AOAM532KsDkloofW7K/g9jCkN6ujGHwk22QAtglUddzK83cDUXzvryr2
        wsBpJWlI6acW67p1l5fYsxc=
X-Google-Smtp-Source: ABdhPJzmePecP4wTNT1Yp38PAlSvaEYvpH/frASEeLMA5EmRDor4vO2MdS8CijBsh6exq5Snu11qVg==
X-Received: by 2002:ac8:7d44:0:b0:2de:4d14:b6b9 with SMTP id h4-20020ac87d44000000b002de4d14b6b9mr19022794qtb.505.1646122713255;
        Tue, 01 Mar 2022 00:18:33 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 3-20020ac85703000000b002dcea434fa4sm8713557qtw.18.2022.03.01.00.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 00:18:32 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net/netfilter: use memset avoid infoleaks
Date:   Tue,  1 Mar 2022 08:18:24 +0000
Message-Id: <20220301081824.2053310-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>

Use memset to initialize structs to preventing infoleaks
in __bpf_mt_check_bytecode

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 net/netfilter/xt_bpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/xt_bpf.c b/net/netfilter/xt_bpf.c
index 849ac552a154..5750a68a2a3f 100644
--- a/net/netfilter/xt_bpf.c
+++ b/net/netfilter/xt_bpf.c
@@ -29,6 +29,7 @@ static int __bpf_mt_check_bytecode(struct sock_filter *insns, __u16 len,
 	if (len > XT_BPF_MAX_NUM_INSTR)
 		return -EINVAL;
 
+	memset(&program, 0x0, sizeof(program));
 	program.len = len;
 	program.filter = insns;
 
-- 
2.25.1

