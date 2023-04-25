Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2826EE39E
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 16:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbjDYOHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 10:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjDYOHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 10:07:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FEE35A1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 07:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682431574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ky4or7cbHu9y2lAhkNJDV4gPS/WcEX9x/ObLAA4vgOA=;
        b=R5c3Azb5vSchlv1rKhwEdwvq6QZ1ryqSpV84GoZDRx0hLVVylvbKcHrBO2LTGscER3vPhV
        OEqgZ6qzHkmFLA5GkrVkHs0W1Z3fXBoWu/0W0J74jR2K19xIudt3E5jKMtGAT5pY9kBntx
        mDjgulxBoqUg2oFxQX/SHat8mt3QtJA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-bVPvqCw8PY-I2o_YWzJQCQ-1; Tue, 25 Apr 2023 10:06:09 -0400
X-MC-Unique: bVPvqCw8PY-I2o_YWzJQCQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C573884EC5;
        Tue, 25 Apr 2023 14:06:08 +0000 (UTC)
Received: from p1.luc.cera.cz.com (unknown [10.45.226.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07EB840C2064;
        Tue, 25 Apr 2023 14:06:05 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paul Blakey <paulb@nvidia.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net/sched: flower: Fix wrong handle assignment during filter change
Date:   Tue, 25 Apr 2023 16:06:04 +0200
Message-Id: <20230425140604.169881-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 08a0063df3ae ("net/sched: flower: Move filter handle initialization
earlier") moved filter handle initialization but an assignment of
the handle to fnew->handle is done regardless of fold value. This is wrong
because if fold != NULL (so fold->handle == handle) no new handle is
allocated and passed handle is assigned to fnew->handle. Then if any
subsequent action in fl_change() fails then the handle value is
removed from IDR that is incorrect as we will have still valid old filter
instance with handle that is not present in IDR.
Fix this issue by moving the assignment so it is done only when passed
fold == NULL.

Prior the patch:
[root@machine tc-testing]# ./tdc.py -d enp1s0f0np0 -e 14be
Test 14be: Concurrently replace same range of 100k flower filters from 10 tc instances
exit: 123
exit: 0
RTNETLINK answers: Invalid argument
We have an error talking to the kernel
Command failed tmp/replace_6:1885


All test results:

1..1
not ok 1 14be - Concurrently replace same range of 100k flower filters from 10 tc instances
        Command exited with 123, expected 0
RTNETLINK answers: Invalid argument
We have an error talking to the kernel
Command failed tmp/replace_6:1885

After the patch:
[root@machine tc-testing]# ./tdc.py -d enp1s0f0np0 -e 14be
Test 14be: Concurrently replace same range of 100k flower filters from 10 tc instances

All test results:

1..1
ok 1 14be - Concurrently replace same range of 100k flower filters from 10 tc instances

Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 net/sched/cls_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 475fe222a855..fa6c2bb0b626 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2231,8 +2231,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 			kfree(fnew);
 			goto errout_tb;
 		}
+		fnew->handle = handle;
 	}
-	fnew->handle = handle;
 
 	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
 			       !tc_skip_hw(fnew->flags));
-- 
2.39.1

