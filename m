Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8261639242B
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhE0BN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbhE0BNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 21:13:47 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CBFC061763;
        Wed, 26 May 2021 18:12:13 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y15so2337333pfn.13;
        Wed, 26 May 2021 18:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+UdaHYvUCGtywdH+/61KW/Rjo4BNhU+1cStUbcIix1E=;
        b=kD4Do19z16/q1oiDME+Vuoow8TzXyDZU5BVoU3UaBkQe/Dcm+BoKrk/T8MBbMwAFMp
         zv0ftz/mQTaXKkkozQRMfK0xwdaBGOBxuCVWdZCsPwP7TAsNgvdSoYDV6fHu+7UO86hd
         9Emhq/aPKaDcKJTvLPx8G66Hc4rtHNi0n1yo2d25pRL8G655q9RcBxPEj4KtSxo5g90P
         RQhuXQmiqGjgdNVbL4tA29R5BFolGp+EaaL1r7673rZk16VuVtPS9Bo+iR6EFwEVniDv
         HDjL9Vy/EFpLaI2migF02XfGgvACLdq0hIZ52ueFnP8iNrZ1emcAVn/4ie2rOV6vlMSl
         uSeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+UdaHYvUCGtywdH+/61KW/Rjo4BNhU+1cStUbcIix1E=;
        b=sTAEiDuSuyd0KlYkoLEtjRVb1Vpvh5/OR0jRERd4yq6m9tRCnvVslv5KsHYfhIAoxH
         1BUSPqPVcfQMoprsY47N2b7hrQThU7sGQQnni05Mt/rt+ogRA2v7PJUsjJN4YYz1EYjh
         t52MTyWEH8SgxtZAH/QaBCibIYyu+Ib/17bgm45iqu5W7KW9jjUaR0IhrUM0Gs0lFupV
         siFbt1q+WvSklIW9TztBVhuQhu88sCYo4KOEB3aVnVJxNLqqreJuY8soHxFFhgHNpDF2
         cLccch44AQl6lYGg56Y7tKiWcv+YrzoZ+yfcMFnrsMufwBBguA1AuoT+JMvo/fFNczDA
         NkzA==
X-Gm-Message-State: AOAM530ONFAjQmZdhd9ogpMm3DEDU9bwkePby9jfe+myI2JCe4KeMc40
        ElB1pD6sC7Xq9KVrp9bSNRDGEYlVTqzf4Q==
X-Google-Smtp-Source: ABdhPJzlPukRMKAsb0fmOEqnLPFoiN4FEcfoWfESkl7T6CaDip4jgmN7uZgQOhhjFgLo6eDEh94h4w==
X-Received: by 2002:a62:bd07:0:b029:2df:2c0a:d5e9 with SMTP id a7-20020a62bd070000b02902df2c0ad5e9mr1217056pff.7.1622077933408;
        Wed, 26 May 2021 18:12:13 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:991:63cd:5e03:9e3a])
        by smtp.gmail.com with ESMTPSA id n21sm360282pfu.99.2021.05.26.18.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 18:12:13 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v3 4/8] skmsg: clear skb redirect pointer before dropping it
Date:   Wed, 26 May 2021 18:11:51 -0700
Message-Id: <20210527011155.10097-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
References: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

When we drop skb inside sk_psock_skb_redirect(), we have to clear
its skb->_sk_redir pointer too, otherwise kfree_skb() would
misinterpret it as a valid skb->_skb_refdst and dst_release()
would eventually complain.

Fixes: e3526bb92a20 ("skmsg: Move sk_redir from TCP_SKB_CB to skb")
Reported-by: Jiang Wang <jiang.wang@bytedance.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index f9a81b314e4c..4334720e2a04 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -843,12 +843,14 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	 * a socket that is in this state so we drop the skb.
 	 */
 	if (!psock_other || sock_flag(sk_other, SOCK_DEAD)) {
+		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
 		return;
 	}
 	spin_lock_bh(&psock_other->ingress_lock);
 	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
 		spin_unlock_bh(&psock_other->ingress_lock);
+		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
 		return;
 	}
-- 
2.25.1

