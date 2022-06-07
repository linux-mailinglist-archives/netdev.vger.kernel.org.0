Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3455404A0
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345507AbiFGRSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345504AbiFGRR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:17:59 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5DE74DC5
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:17:56 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 187so16068639pfu.9
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=57cyzJoBPE7FvApVXx2h64j/hlX4+tffn7QLQfhu8gE=;
        b=kJGzch64mvLQOnlCNITM6GUuQRrL0SxXbvTx+fLHOdB3rEDv1Mrn082kRx3FOvDFg+
         gUbaVQCLRVkXQVQbi5hRqxMIkflL8itvSyFD2hosUiEBwdQsbTd/4b4d4lYLAwMSjVOV
         PHpAOhE63SXeVGtLJjZGAUOG0T0hyCcvNNalM5kaS3ZBncURDi942uW8gAITKNf+xRX2
         B3HkFu8G3hrvaunW7Gw9gDDvfxGDvzYJcVfyezFkWM1wAk57Q67BY+KXBAcQdI3qerWG
         3J0i/AQvlqrW4tGLi8U0NeAbosd5C6RYJZWI8FZ4Pz4axjxX+jIkhhkEpqUXPZHTVKj9
         0asw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=57cyzJoBPE7FvApVXx2h64j/hlX4+tffn7QLQfhu8gE=;
        b=VrNxmug84MtbnJ/1aPEns+6L2Np60ENgzFGqXz7siiOkywDamCm0tVs/DrP4al/BL2
         Lz1Gnv+TihvGg8t9sgc2ILXm/lNu2uVuC4SRwo3yRsk7wlivB+uoQXiPTnzOInZPVFR9
         JekdZL8HwaIy30B5EbSvebjivVdnkSMsoLSe+wK8PVFtH6tfW80tmOCNj0QHbe604zRZ
         7EUgnPcRr936Al27sQz/y5EpyuUI0VUrfkldITc8az5za7qwfg4RpGO5w/0XEPQaF+nH
         PW7Uh2iFRn/68NnJiXkJZk20XpmtPaGSD7R7dBNm2eYhSLsw8RDzcltr+eE9/LWOBQJp
         kxYg==
X-Gm-Message-State: AOAM530yEAqwuhOAZl7N2bCIpYqZRDJ4hkQFalOx/NNTxL1K8IvxBiVI
        GyWe9fifiXhYR4HoLzgIl4ogK7KYkzE=
X-Google-Smtp-Source: ABdhPJxzIZfN5DeDanoJurkdVMap8nE6NfDYu0RbLDJiBOIY2WB8ulxkeVBbNSIkzsZacxUnpLaexw==
X-Received: by 2002:a63:5711:0:b0:3fd:b97e:3c0c with SMTP id l17-20020a635711000000b003fdb97e3c0cmr10241989pgb.570.1654622276063;
        Tue, 07 Jun 2022 10:17:56 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id d4-20020a621d04000000b0051b930b7bbesm13001616pfd.135.2022.06.07.10.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 10:17:55 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 8/8] net: add napi_get_frags_check() helper
Date:   Tue,  7 Jun 2022 10:17:32 -0700
Message-Id: <20220607171732.21191-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220607171732.21191-1-eric.dumazet@gmail.com>
References: <20220607171732.21191-1-eric.dumazet@gmail.com>
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

This is a follow up of commit 3226b158e67c
("net: avoid 32 x truesize under-estimation for tiny skbs")

When/if we increase MAX_SKB_FRAGS, we better make sure
the old bug will not come back.

Adding a check in napi_get_frags() would be costly,
even if using DEBUG_NET_WARN_ON_ONCE().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 27ad09ad80a4550097ce4d113719a558b5e2a811..4ce9b2563a116066d85bae7a862e38fb160ef0e2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6351,6 +6351,23 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
 }
 EXPORT_SYMBOL(dev_set_threaded);
 
+/* Double check that napi_get_frags() allocates skbs with
+ * skb->head being backed by slab, not a page fragment.
+ * This is to make sure bug fixed in 3226b158e67c
+ * ("net: avoid 32 x truesize under-estimation for tiny skbs")
+ * does not accidentally come back.
+ */
+static void napi_get_frags_check(struct napi_struct *napi)
+{
+	struct sk_buff *skb;
+
+	local_bh_disable();
+	skb = napi_get_frags(napi);
+	WARN_ON_ONCE(skb && skb->head_frag);
+	napi_free_frags(napi);
+	local_bh_enable();
+}
+
 void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 			   int (*poll)(struct napi_struct *, int), int weight)
 {
@@ -6378,6 +6395,7 @@ void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 	set_bit(NAPI_STATE_NPSVC, &napi->state);
 	list_add_rcu(&napi->dev_list, &dev->napi_list);
 	napi_hash_add(napi);
+	napi_get_frags_check(napi);
 	/* Create kthread for this napi if dev->threaded is set.
 	 * Clear dev->threaded if kthread creation failed so that
 	 * threaded mode will not be enabled in napi_enable().
-- 
2.36.1.255.ge46751e96f-goog

