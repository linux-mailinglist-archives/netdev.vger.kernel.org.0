Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756904C85B9
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbiCAIAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiCAIAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 03:00:03 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601CB8090B;
        Mon, 28 Feb 2022 23:59:20 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id o23so13742755pgk.13;
        Mon, 28 Feb 2022 23:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3aKejJw1nR/er0PaT33ysU9JAPbiP/BO+fmavRczddA=;
        b=MkwrLGU+BDmEg5akmiJV5iuAGXoVQex9eAJamjRI5yPEwQz5ZBphS8rWxnJoh6r2qk
         GITpdBUCOCJKhpDPKvimmGQSnQYAGyWqE3P/+tlqY8/Lu4X9F1UCmP0Z1BSnNx23hj2H
         UtRYDHpyz0wyS3HBEihDOvYCmXO68ii5OY2AqwLcziJx5hhINrQq37iUPti6770WqH72
         1+XtxGGGSMNbhBmEy4L8XvJ2nezmqom4+TByy//BriSjcIkpn9hXnEZncRbOhKFatyZi
         G1bY7lVc2k/YjXTfPPTknwvPMtj6AurwobswVDg4xT3ibtE/DX12Ms7BPAu681KRpKyf
         EYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3aKejJw1nR/er0PaT33ysU9JAPbiP/BO+fmavRczddA=;
        b=aPg/ZZYJR+aafrSCj9GTFsiWmVBC9lZeRteTOUge7H5yjZg/qY/U83R2hP6vJVEnhG
         VaGU/Ebpy1i4VpfHuq+l+UJHbtIYKn3nkHVKADwG6uBj/xn8dal4yRmTS6ggJLJXAVsC
         wWlD82ip0nDyw+Iu4a/Q55KghEDLTAnMbXu1yqFNpwqu+tUKD3uOsCdkYV3ZP3iX/BJR
         L1UiV24ITHpSfhp64JBX7OSvUvXmvs9azPwb1MZkKqyXNjl/8c2dCsdYfV1Qy2LPAZCJ
         N5JiUWyQilm7zKdwEqqKXtDMKS9ItMaFmohq63CCCfo6A2MiT+DCatPdZGtsMNPE6+Qe
         0+pg==
X-Gm-Message-State: AOAM533FoX659XT/MV9im14G8t47+b3HRA/HHdghZwunrd72QnzubHBw
        nmfIyqHP1doVToyeEmofq9U=
X-Google-Smtp-Source: ABdhPJzsmChq0SMT6w+a5llB+evOvw/vtlrBOBuie32yTHIMn9w2PHQgwGyq50KU4/df9sG257/q1g==
X-Received: by 2002:a05:6a00:124f:b0:4c0:6242:c14e with SMTP id u15-20020a056a00124f00b004c06242c14emr25860679pfi.83.1646121559737;
        Mon, 28 Feb 2022 23:59:19 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id o12-20020a17090aac0c00b001b9e5286c90sm1662745pjq.0.2022.02.28.23.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 23:59:19 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     arnd@arndb.de, jakobkoschel@gmail.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, jannh@google.com,
        linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH 5/6] net/core: remove iterator use outside the loop
Date:   Tue,  1 Mar 2022 15:58:38 +0800
Message-Id: <20220301075839.4156-6-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
References: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Demonstrations for:
 - list_for_each_entry_safe_reverse_inside

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 net/core/gro.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index a11b286d1..4d4f1f2fb 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -286,9 +286,8 @@ static void __napi_gro_flush_chain(struct napi_struct *napi, u32 index,
 				   bool flush_old)
 {
 	struct list_head *head = &napi->gro_hash[index].list;
-	struct sk_buff *skb, *p;
 
-	list_for_each_entry_safe_reverse(skb, p, head, list) {
+	list_for_each_entry_safe_reverse_inside(skb, p, struct sk_buff, head, list) {
 		if (flush_old && NAPI_GRO_CB(skb)->age == jiffies)
 			return;
 		skb_list_del_init(skb);
-- 
2.17.1

