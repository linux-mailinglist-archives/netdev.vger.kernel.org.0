Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48945AC9B1
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 07:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiIEFE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 01:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiIEFEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 01:04:25 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DACC10;
        Sun,  4 Sep 2022 22:04:23 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 78so7119322pgb.13;
        Sun, 04 Sep 2022 22:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=5DQUMFXxfA32a7aUWkNHYF5YjobVzHhpLj7ZM8/Qyc4=;
        b=U5LX8GJPY8K55tWotkGyIbYRSUEpT0P9JtF7vMlWWJfOv1qnio5NozJioiBOnwhKoZ
         lIrTCXS4Y5RmdWN3aTzrvb4Evgb8pnvaNuUPLsHVCvNlSAkf1PAnKfBIE7b83KymfqUQ
         MqXs4DE/O3NOhZNAwN0YP8CrnUHoGMGpQbQmFGjV08M5s/LEfq1cCTatHtBFzJkj/brg
         0mmi0RKi9/HYygc8T0AeQ4NybMZ7A+VQH+nSh3m6Gc3S2xDz/yRm6q4ukDGRZ9Dfwlye
         KqRbUsJbhEeXW9Gvmt9st21wlnKypVNiz7WXiuuYChZhBeng0z3VQi+WzkcPHuTNuLil
         6l6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=5DQUMFXxfA32a7aUWkNHYF5YjobVzHhpLj7ZM8/Qyc4=;
        b=XiBIROrwmYcv8H30XpD7yMhfRDoT5C64c3vnTzt+F7Lal/L8skfjxqSvYvtD/Pxe47
         r5BviulonyqiBL5uHyi7ZJAg/Zkw0o7eGQbfbVotmbJQivjWyeJJq4AVhaXGjnvxs6xZ
         cHECxZtQb6deRk9N5XawXgWxLrn7x7VioRDWTpiRq2ZS1aLvVngacp66i+wgx9qymSS1
         cP7C47IE3n3aTx+JFHsBXCAZy/BFEi8METJ6mUqoiCGO4EdqOOXzHXLxgvWAuVbaHGGE
         A395+6lgWBjTLXz3f/zESa7T2U5woxjhS2et6Nf16rsWmKxyGW4GUvWVgu9iIC6hikas
         Mv9w==
X-Gm-Message-State: ACgBeo1zNdKBPIWdNORufFVD/+HPQV+4F5ot3eovxl/PizfjhdZkaMuC
        Nr8ykiF4c2+zq6OuHqPO9JQ=
X-Google-Smtp-Source: AA6agR6pvn1FU7kFUm/ufBbt+Cn5QuJED8ghP52KyOItCepMBytmJz/qgxEs2mm4NQfZdAiychTKcw==
X-Received: by 2002:a63:2582:0:b0:42b:aacc:807f with SMTP id l124-20020a632582000000b0042baacc807fmr34221015pgl.120.1662354262610;
        Sun, 04 Sep 2022 22:04:22 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.23])
        by smtp.gmail.com with ESMTPSA id x3-20020a17090a46c300b001fd7e56da4csm9423901pjg.39.2022.09.04.22.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Sep 2022 22:04:22 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     mathew.j.martineau@linux.intel.com
Cc:     matthieu.baerts@tessares.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net] net: mptcp: fix unreleased socket in accept queue
Date:   Mon,  5 Sep 2022 13:04:00 +0800
Message-Id: <20220905050400.1136241-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.37.2
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

From: Menglong Dong <imagedong@tencent.com>

The mptcp socket and its subflow sockets in accept queue can't be
released after the process exit.

While the release of a mptcp socket in listening state, the
corresponding tcp socket will be released too. Meanwhile, the tcp
socket in the unaccept queue will be released too. However, only init
subflow is in the unaccept queue, and the joined subflow is not in the
unaccept queue, which makes the joined subflow won't be released, and
therefore the corresponding unaccepted mptcp socket will not be released
to.

This can be reproduced easily with following steps:

1. create 2 namespace and veth:
   $ ip netns add mptcp-client
   $ ip netns add mptcp-server
   $ sysctl -w net.ipv4.conf.all.rp_filter=0
   $ ip netns exec mptcp-client sysctl -w net.mptcp.enabled=1
   $ ip netns exec mptcp-server sysctl -w net.mptcp.enabled=1
   $ ip link add red-client netns mptcp-client type veth peer red-server \
     netns mptcp-server
   $ ip -n mptcp-server address add 10.0.0.1/24 dev red-server
   $ ip -n mptcp-server address add 192.168.0.1/24 dev red-server
   $ ip -n mptcp-client address add 10.0.0.2/24 dev red-client
   $ ip -n mptcp-client address add 192.168.0.2/24 dev red-client
   $ ip -n mptcp-server link set red-server up
   $ ip -n mptcp-client link set red-client up

2. configure the endpoint and limit for client and server:
   $ ip -n mptcp-server mptcp endpoint flush
   $ ip -n mptcp-server mptcp limits set subflow 2 add_addr_accepted 2
   $ ip -n mptcp-client mptcp endpoint flush
   $ ip -n mptcp-client mptcp limits set subflow 2 add_addr_accepted 2
   $ ip -n mptcp-client mptcp endpoint add 192.168.0.2 dev red-client id \
     1 subflow

3. listen and accept on a port, such as 9999. The nc command we used
   here is modified, which makes it uses mptcp protocol by default.
   And the default backlog is 1:
   ip netns exec mptcp-server nc -l -k -p 9999

4. open another *two* terminal and connect to the server with the
   following command:
   $ ip netns exec mptcp-client nc 10.0.0.1 9999
   input something after connect, to triger the connection of the second
   subflow

5. exit all the nc command, and check the tcp socket in server namespace.
   And you will find that there is one tcp socket in CLOSE_WAIT state
   and can't release forever.

There are some solutions that I thought:

1. release all unaccepted mptcp socket with mptcp_close() while the
   listening tcp socket release in mptcp_subflow_queue_clean(). This is
   what we do in this commit.
2. release the mptcp socket with mptcp_close() in subflow_ulp_release().
3. etc

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/mptcp/subflow.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index c7d49fb6e7bd..e39dff5d5d84 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1770,6 +1770,10 @@ void mptcp_subflow_queue_clean(struct sock *listener_ssk)
 		msk->first = NULL;
 		msk->dl_next = NULL;
 		unlock_sock_fast(sk, slow);
+
+		/*  */
+		sock_hold(sk);
+		sk->sk_prot->close(sk);
 	}
 
 	/* we are still under the listener msk socket lock */
-- 
2.37.2

