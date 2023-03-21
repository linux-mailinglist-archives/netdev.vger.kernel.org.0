Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923896C28FD
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 05:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjCUEG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 00:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjCUEGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 00:06:22 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902093D917
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 21:02:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5417f156cb9so142329667b3.8
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 21:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679371282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/0Ft4zFnJkZ9gZAvcWK/9SuwLlGSimspNR8F5QwRisk=;
        b=lQdJTRoEeBS9w4662oIkHqMFDV3FVX+is3E09bE64471VXhhpouYXA4vpSMkaXwKD+
         JIxFzGOFGBacjYmzrqzalOB94mQAAL69hyhgF0RmFOzRDnphV2qHvfgKvH0gPWNajMfo
         pHIW9MGk3uYupygjix/nevvT+plu8Jcs67+rlUrCO9TGhpOYsHCmLFyzRGbvafhMq57t
         5ZB9Qabqk4ksTtyUf5iHppgOaCRfUWUyy7ModNO+//Ho+PfdGfE5iyVGc6EEw78rvrL6
         tdC7LfcTFDIShi9AH13Ufxo86wHvjBTsDVd/lCaEpJy46py8H5LL7y2ZnJud2T/+EtHh
         1j2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679371282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/0Ft4zFnJkZ9gZAvcWK/9SuwLlGSimspNR8F5QwRisk=;
        b=xYyvDtrFIB5ZIjq+Nu94EfrH+LMCIgYAxl0iYsHir/8z3kTw/b7A8D4YzWkJWDhj9u
         8j/mpm0jRtCBGFH/+bR90ymkFD61B1uaCxJ4BZDdqJG/O8It9qW1DcYBfK1qdkFkaeab
         KA/vNURCPO7Gk+Cy64v5SpjRZ6eyMNP3sqiaA/tgXl8q6ylkoZpYBDBI2YST3Cs3d1CQ
         Nc/VMszqla3Tbpfd/2osYpUMX6Cluvk0A8m15EDS70K3YReWy1Yg6PnTsSBc6CznLBJH
         89JvZ4JkEowiZmYnHw5c4ZYadOtTtfvx7I44QcIV9RWYg7NPa0LI2HXEwieHVD2XxE+r
         Lk+Q==
X-Gm-Message-State: AAQBX9fhVbOLVXasXYFhK/K305tJ/NFf3126ami6LdOfq+M0cP87n2QY
        6WUkA3AKye1orQ8jTFTd7H+g8Y2/R3ktiA==
X-Google-Smtp-Source: AKy350Z4Nqm7IIxcN6HMm3vsn24yysJvI2mvV7FVxwHrERQV9UKl6WY438YLMVNkRJLESxPNY53e73GyVWUnGg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:a945:0:b0:541:8285:b25 with SMTP id
 g66-20020a81a945000000b0054182850b25mr236092ywh.10.1679371282340; Mon, 20 Mar
 2023 21:01:22 -0700 (PDT)
Date:   Tue, 21 Mar 2023 04:01:15 +0000
In-Reply-To: <20230321040115.787497-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230321040115.787497-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321040115.787497-4-edumazet@google.com>
Subject: [PATCH net-next 3/3] net: remove rcu_dereference_bh_rtnl()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
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

This helper is no longer used in the tree.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/rtnetlink.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 92ad75549e9cdbabb78cd9c6cc7e4c2356cf850a..f0c87baaf6c05d400137248b8b1b4a61f9854c1b 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -61,16 +61,6 @@ static inline bool lockdep_rtnl_is_held(void)
 #define rcu_dereference_rtnl(p)					\
 	rcu_dereference_check(p, lockdep_rtnl_is_held())
 
-/**
- * rcu_dereference_bh_rtnl - rcu_dereference_bh with debug checking
- * @p: The pointer to read, prior to dereference
- *
- * Do an rcu_dereference_bh(p), but check caller either holds rcu_read_lock_bh()
- * or RTNL. Note : Please prefer rtnl_dereference() or rcu_dereference_bh()
- */
-#define rcu_dereference_bh_rtnl(p)				\
-	rcu_dereference_bh_check(p, lockdep_rtnl_is_held())
-
 /**
  * rtnl_dereference - fetch RCU pointer when updates are prevented by RTNL
  * @p: The pointer to read, prior to dereferencing
-- 
2.40.0.rc2.332.ga46443480c-goog

