Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32B964D331
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiLNXVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLNXVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:21:03 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C12279
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:21:02 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id b6-20020a17090acc0600b0021a1a90a3e0so4727623pju.0
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mrPwVim4lxf8gn0+1ipqGx0TxDKuJ3J9+9eguqRThD8=;
        b=DsqJN0rigBMWtAXYlvtBpKuld4XB+qDegJnzXmEutZJgGhDQveVUDC0O3bpiS740Qx
         xL47gJKmKEOaRW4EDNLKHGCMiWs9r0Ow57+64+sAlkfFohzb39x4QEEA4wxNoFSBr+Q7
         hURRtwh5vQ44Y8h15RAH+VvDq+CSYB0bl8Yq0OIH1VbTEWPOnEa4YRECYk1ndOZVF1r1
         lu3fISoqtCiVUuuJhxx3J2/9NYxvESBBPkMT0ZZzjbikC2oUj+5wTnL0+bKWcFGO3jDu
         xxsCoZkAYOixD43dWewi04cQlY5IiLhG3Fu1bOTFPYFmmhydWbGo9pCBNwoB8gBJUjq9
         nY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mrPwVim4lxf8gn0+1ipqGx0TxDKuJ3J9+9eguqRThD8=;
        b=y9r48hPYgG2ZWDG4ktNkG/HNhemQlxwYRRcaqPEqom7ASUivt4OvUv6zYCkqITC79P
         31zzz8fPmfRLMAl8hSlezW4U3XTRFXjaXNuz0wjzSosj9vyEQmZv8EZ52QbQ3SRuLH2u
         EXqavrDqllalgs/E8f+KnWjFsPHwam+7qYpGzYGG/UvuebaOqYE1cMCu6WEGYH0vffxU
         edmvqLBig35+ooxep8Y+AJvZvdgUsdtpE3F0k61JL8NR9ysMyvYJGwheHt5C1eC8r4rM
         S5OLAJ5qXDf+W75j50G+2sOJ4j/Oc9BfY7cRsfBFwjMzkgzJJM1FC3Bg/R04zUw2h1/S
         nnmQ==
X-Gm-Message-State: ANoB5plgWECLHZG2TbflIS8h1xKxJsdT3+elwDW7tNUxoiKP5w3ute79
        D0KZuUoxZ6G6rMh5HTnm+kY0IG/ohA==
X-Google-Smtp-Source: AA0mqf77Tlu11PHIJPSDwbVx0f4cpuTrax+NFzwRK5Ry+fPEZAI/BiHBtIQcmJbh/4lwcCEzDkcVEJysGA==
X-Received: from decot.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5fa2])
 (user=decot job=sendgmr) by 2002:a17:902:b282:b0:189:91f3:bfe2 with SMTP id
 u2-20020a170902b28200b0018991f3bfe2mr51458709plr.34.1671060062139; Wed, 14
 Dec 2022 15:21:02 -0800 (PST)
Date:   Wed, 14 Dec 2022 15:20:59 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221214232059.760233-1-decot+git@google.com>
Subject: [PATCH net-next v2 1/1] net: neigh: persist proxy config across link flaps
From:   David Decotigny <decot+git@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        David Decotigny <ddecotig@google.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Decotigny <ddecotig@google.com>

Without this patch, the 'ip neigh add proxy' config is lost when the
cable or peer disappear, ie. when the link goes down while staying
admin up. When the link comes back, the config is never recovered.

This patch makes sure that such an nd proxy config survives a switch
or cable issue.

Signed-off-by: David Decotigny <ddecotig@google.com>


---
v1: initial revision
v2: same as v1, except rebased on top of latest net-next, and includes "net-next" in the description

 net/core/neighbour.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index f00a79fc301b..f4b65bbbdc32 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -426,7 +426,10 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
 {
 	write_lock_bh(&tbl->lock);
 	neigh_flush_dev(tbl, dev, skip_perm);
-	pneigh_ifdown_and_unlock(tbl, dev);
+	if (skip_perm)
+		write_unlock_bh(&tbl->lock);
+	else
+		pneigh_ifdown_and_unlock(tbl, dev);
 	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL,
 			   tbl->family);
 	if (skb_queue_empty_lockless(&tbl->proxy_queue))
-- 
2.39.0.rc1.256.g54fd8350bd-goog

