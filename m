Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD25E55DC43
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243928AbiF1D6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 23:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244478AbiF1D6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 23:58:20 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FAD95A1;
        Mon, 27 Jun 2022 20:58:19 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id a10so11663292ioe.9;
        Mon, 27 Jun 2022 20:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jmHwHyMemtrkLL/Ho14MQJD4oF13zKiGls/mbHEGZ/A=;
        b=Ys9ejwslxKfAl6KrhxRasFxmfZspGRXnOXH97MNL7tcKXbCHMGeg2tso78BGALtpFN
         fXrlcfvc8CxRcjwtHfncqttY09/64ZVBOw2XgPf4Nf9GJ4HC92QcRGgmokASDCNZK4tL
         uw8JsHKqk4sWI14y+BI66khrrIeYezgOHIZFKfPkTTZoQoejh4DWsXOj846wZfuKg4id
         i/N/DJ8abukKuX/DlPBThpLA/2DVsSR0t5fycDcAltVQWu/LvgXstjrcQ0aWXi1feu7s
         NozC2nj0VQsw2tIaZjMmvBhPtMbb1OE2LTEQ6UAyIXbqAYH8CQsTPSJKf753ptkcXkil
         /H4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jmHwHyMemtrkLL/Ho14MQJD4oF13zKiGls/mbHEGZ/A=;
        b=Yd5md6GL45hPrIM3RVFuVs92T4CxNQzDM0ZdDRuaciJuIwGV0fBH0irJNYMhdkhRF7
         vcVph5YPhIfn3qnPZtQV8aoKPtHkA6vBf+B0b3sfFtZvjBeVTDfEzauNpMSsbLHLxZ45
         dxR+pOsdDbEiJECsUyH9HBDsXrP5ZQalcCMPqpYWY6hPklyrKa72I4JeS9Vs/+jpz812
         16PAXgpcoHRDtk2a8HuxkLKVDPQT/dcfgVsx4PaxoYt7tvjl9RAIazIZ9v+omieFZdcC
         zLjgRa6udWM+baYybDFgJFUpEDQZEFgFkeuL//KUJ9qURnm0B15kNMBtloItKISc1B9r
         TMKA==
X-Gm-Message-State: AJIora/fvHPiEFfG+ym16cmme4ljewEWtsbIfRqiPD4d/q67FVT47ePh
        lvQHMj5JJnGHkjZT1wTjtPQ=
X-Google-Smtp-Source: AGRyM1v6Iq6UjHpb6P7ohmyDbFaW9tZG0uUdo+N9ibxMPR0lqPf2UuDSgGGORgmGdmBuCCHxnr3eOg==
X-Received: by 2002:a05:6638:2616:b0:331:fff5:764f with SMTP id m22-20020a056638261600b00331fff5764fmr10238516jat.267.1656388698520;
        Mon, 27 Jun 2022 20:58:18 -0700 (PDT)
Received: from john.lan ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id bt6-20020a056638430600b0033c9beb0e19sm2073471jab.22.2022.06.27.20.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 20:58:18 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jakub@cloudflare.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH bpf-next] bpf: sockmap calling sleepable function in teardown path
Date:   Mon, 27 Jun 2022 20:58:03 -0700
Message-Id: <20220628035803.317876-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
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

syzbot reproduced the BUG,

 BUG: sleeping function called from invalid context at kernel/workqueue.c:3010

with the following stack trace fragment

 start_flush_work kernel/workqueue.c:3010 [inline]
 __flush_work+0x109/0xb10 kernel/workqueue.c:3074
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3162
 sk_psock_stop+0x4cb/0x630 net/core/skmsg.c:802
 sock_map_destroy+0x333/0x760 net/core/sock_map.c:1581
 inet_csk_destroy_sock+0x196/0x440 net/ipv4/inet_connection_sock.c:1130
 __tcp_close+0xd5b/0x12b0 net/ipv4/tcp.c:2897
 tcp_close+0x29/0xc0 net/ipv4/tcp.c:2909

introduced by d8616ee2affc. Do a quick trace of the code path and the
bug is obvious,

   inet_csk_destroy_sock(sk)
     sk_prot->destroy(sk);      <--- sock_map_destroy
        sk_psock_stop(, true);   <--- true so cancel workqueue
          cancel_work_sync()     <--- splat, because *_bh_disable()

We can not call cancel_work_sync() from inside destroy path. So mark the
sk_psock_stop call to skip this cancel_work_sync(). This will avoid
the BUG, but means we may run sk_psock_backlog after or during the
destroy op. We zapped the ingress_skb queue in sk_psock_stop (safe to
do with local_bh_disable) so its empty and the sk_psock_backlog work item
will not find any pkts to process here. However, because we are
not going to wait for it or clear its ->state its possible it
kicks off or is already running. This should be 'safe' up until
pssock drops its refcnt to psock->sk. The sock_put() that drops this
reference is only done at psock destroy time from sk_psock_destroy().
This is done through workqueue wihen sk_psock_drop() is called on
psock refnt reaches 0. And importantly sk_psock_destroy() does a
cancel_work_sync(). So trivial fix works.

I've had hit or miss luck reproducing this caught it once or twice with
the provided reproducer when running with many runners. However, syzkaller
is very good at reproducing so relying on syzkaller to verify fix.

Suggested-by: Hillf Danton <hdanton@sina.com>
Reported-by: Reported-by: syzbot+140186ceba0c496183bc@syzkaller.appspotmail.com
Fixes: d8616ee2affc ("bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 9f08ccfaf6da..028813dfecb0 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1578,7 +1578,7 @@ void sock_map_destroy(struct sock *sk)
 	saved_destroy = psock->saved_destroy;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, true);
+	sk_psock_stop(psock, false);
 	sk_psock_put(sk, psock);
 	saved_destroy(sk);
 }
-- 
2.33.0

