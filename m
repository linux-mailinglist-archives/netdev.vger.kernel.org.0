Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBD76E9B2B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 20:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjDTSAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 14:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjDTSAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 14:00:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981F4199F
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682013597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sYEObKgK9ZsZ163F+qEC5kfelVhULo1SPruXGXXCNIM=;
        b=T0nWMYWVclMxGY9d6nQNOmDGPLnIF0Y4TdwC6vyY8N4c/ulPSIl7DwwA/xAK8stC0HHSDr
        U/iT3MK5eZsL7lzTeMWdjpOR1qqYqt20C/skV2hggjK4YZi9KBwLbCQ0vED8iP/UTIyHuQ
        IdB0Qsg8YAeQuJ8QnhieCpMO6sIClzQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-ea5QQMH0NwaenUbQ9iTEtg-1; Thu, 20 Apr 2023 13:59:56 -0400
X-MC-Unique: ea5QQMH0NwaenUbQ9iTEtg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B227296A605;
        Thu, 20 Apr 2023 17:59:55 +0000 (UTC)
Received: from p1.luc.cera.cz (unknown [10.45.226.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A6241410F1C;
        Thu, 20 Apr 2023 17:59:53 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net/sched: cls_api: Initialize miss_cookie_node when action miss is not used
Date:   Thu, 20 Apr 2023 19:59:52 +0200
Message-Id: <20230420175952.1114302-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function tcf_exts_init_ex() sets exts->miss_cookie_node ptr only
when use_action_miss is true so it assumes in other case that
the field is set to NULL by the caller. If not then the field
contains garbage and subsequent tcf_exts_destroy() call results
in a crash.
Initialize .miss_cookie_node pointer to NULL when use_action_miss
parameter is false to avoid this potential scenario.

Fixes: 80cd22c35c90 ("net/sched: cls_api: Support hardware miss to tc action")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 net/sched/cls_api.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 35785a36c80298..8bc5b9d6a2916e 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3224,8 +3224,12 @@ int tcf_exts_init_ex(struct tcf_exts *exts, struct net *net, int action,
 	exts->action = action;
 	exts->police = police;
 
-	if (!use_action_miss)
+	if (!use_action_miss) {
+#ifdef CONFIG_NET_CLS_ACT
+		exts->miss_cookie_node = NULL;
+#endif
 		return 0;
+	}
 
 	err = tcf_exts_miss_cookie_base_alloc(exts, tp, handle);
 	if (err)
-- 
2.39.2

