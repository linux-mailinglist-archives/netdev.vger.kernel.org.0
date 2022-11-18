Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9093162FF86
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 22:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiKRVpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 16:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiKRVpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 16:45:09 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C4668297
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 13:45:08 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id h24so4007306qta.9
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 13:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E08daWDO5uBC8QYCnS2v+9gsgcE9y3M5Ew9Umckq1DY=;
        b=GIkgP7tyhmZjvKxF2hAQeiwCrIgrgW0tRv09VLIwpiG8jTOrKWyMpDw08UlkZ/qNbn
         /1kHv2D5rbTgPgjmE/TwuckkA7N7ukFSr36Zk1tWaImzjT0Cp9syKyJFimHUVzpF8vXJ
         bHTI6Ia4UxM6cIdgh3PL/uft5ZB0auef2dunQlvCw8KGV48vBYBjGyGscOUorz3G538K
         Q257J0GFwoZR6xzQ2v/uxfAOO8NgSdfgPTjq5b015A7IIk+GWV6E2V/7rYC8CY6Hrgqv
         /q6Wt3T/nVB/ec/nlFChUBtcsBlV4FU4IrM/FSZdfD38+eRx2khwSUSNAOdcCt7RzesM
         Y1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E08daWDO5uBC8QYCnS2v+9gsgcE9y3M5Ew9Umckq1DY=;
        b=hXzoRcpA8A04Sqrw7jyCdKtjKQ29FN2VrLimEMBYn8y+9VeOGeNqhLsIyGX9HhOIpg
         GHCS5KlP509BA/7ubyvValcLL01XaiXhFOKdWF2xgW0pZ7wScD0pv3fnnqTbqKdumFCN
         nPyFG83I9WwARwq61xGARKMsE+s1mXJlqoevwFkdmhDceHGd4/Ym0+dXHtOTyMcayb36
         Tvd7Y/ncoZywhrEjWMIC836AW49IfCorsFja/kzRhf4Y8OGMLKm2ZdO6OIyBC4xSfXUU
         pz8zB6EVlFTsfJwrEaTF8MF0Jb8E8oPNxMEq1drMsWWfAnm7ki1hulSpntnY2UU+LRR9
         pePA==
X-Gm-Message-State: ANoB5pnZZNJfECYJJ9lacDFlQim2JEjCh02tK0UqCVdfYrqnMJtTXckL
        0cEAmPcHIgjf7665kNnXObxWzAnF9EHeKQ==
X-Google-Smtp-Source: AA0mqf6BsUtLEoHNTIajW7m3zJG8mgx0zjtM1HaXH09zy+OC2iR9F8AEQ9MZNWsCUih8QgSADrF0Ow==
X-Received: by 2002:ac8:4d99:0:b0:3a5:5334:b3f7 with SMTP id a25-20020ac84d99000000b003a55334b3f7mr8433105qtw.584.1668807907422;
        Fri, 18 Nov 2022 13:45:07 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bi41-20020a05620a31a900b006f956766f76sm3232917qkb.1.2022.11.18.13.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 13:45:07 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH net 2/2] tipc: add an extra conn_get in tipc_conn_alloc
Date:   Fri, 18 Nov 2022 16:45:01 -0500
Message-Id: <4e6c7e150d7268df5a166bbe19e14770bb70253d.1668807842.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668807842.git.lucien.xin@gmail.com>
References: <cover.1668807842.git.lucien.xin@gmail.com>
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

One extra conn_get() is needed in tipc_conn_alloc(), as after
tipc_conn_alloc() is called, tipc_conn_close() may free this
con before deferencing it in tipc_topsrv_accept():

   tipc_conn_alloc();
   newsk = newsock->sk;
                                 <---- tipc_conn_close();
   write_lock_bh(&sk->sk_callback_lock);
   newsk->sk_data_ready = tipc_conn_data_ready;

Then an uaf issue can be triggered:

  BUG: KASAN: use-after-free in tipc_topsrv_accept+0x1e7/0x370 [tipc]
  Call Trace:
   <TASK>
   dump_stack_lvl+0x33/0x46
   print_report+0x178/0x4b0
   kasan_report+0x8c/0x100
   kasan_check_range+0x179/0x1e0
   tipc_topsrv_accept+0x1e7/0x370 [tipc]
   process_one_work+0x6a3/0x1030
   worker_thread+0x8a/0xdf0

This patch fixes it by holding it in tipc_conn_alloc(), then after
all accessing in tipc_topsrv_accept() releasing it. Note when does
this in tipc_topsrv_kern_subscr(), as tipc_conn_rcv_sub() returns
0 or -1 only, we don't need to check for "> 0".

Fixes: c5fa7b3cf3cb ("tipc: introduce new TIPC server infrastructure")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/topsrv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index b0f9aa521670..e3b427a70398 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -206,6 +206,7 @@ static struct tipc_conn *tipc_conn_alloc(struct tipc_topsrv *s, struct socket *s
 	set_bit(CF_CONNECTED, &con->flags);
 	con->server = s;
 	con->sock = sock;
+	conn_get(con);
 	spin_unlock_bh(&s->idr_lock);
 
 	return con;
@@ -484,6 +485,7 @@ static void tipc_topsrv_accept(struct work_struct *work)
 
 		/* Wake up receive process in case of 'SYN+' message */
 		newsk->sk_data_ready(newsk);
+		conn_put(con);
 	}
 }
 
@@ -583,10 +585,11 @@ bool tipc_topsrv_kern_subscr(struct net *net, u32 port, u32 type, u32 lower,
 
 	*conid = con->conid;
 	rc = tipc_conn_rcv_sub(tipc_topsrv(net), con, &sub);
-	if (rc >= 0)
-		return true;
+	if (rc)
+		conn_put(con);
+
 	conn_put(con);
-	return false;
+	return !rc;
 }
 
 void tipc_topsrv_kern_unsubscr(struct net *net, int conid)
-- 
2.31.1

