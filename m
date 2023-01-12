Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F672666B4A
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 07:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbjALGyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 01:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjALGyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 01:54:06 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F3CD13D;
        Wed, 11 Jan 2023 22:54:04 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so22580621pjk.3;
        Wed, 11 Jan 2023 22:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rdz+onrEHU9FBrqLBH6wXhqeAdLAMrM4NAoEI+V47uE=;
        b=WvQu12u2g5+fD2+GNou8Zv9qAwGwtgg+S/CLHLBOtBAg4QNM4bu1PTnuQiNBdm/8dS
         8rK+YYIWOWIm6A/1iZ9ouvHSe7ciPS3g6hvJD8S8q6YuoYBpZxh2g1GcS8S9vPgU28lw
         aoH7Vpsi8rs4IO4zIvr0qpkAojkF+8MwQQ+721FyB1l1LYkX0PIjHymtpZj4vezQHmXb
         EW05fraWhiszukPhZQaioAoF9GEvRkB5bVjMUGQcfKrvt3+oAErXc+8rRCcPXxUDB5Kk
         k9JU6UovODAE8WX+2dm+Y/YCISPVg86U9ForBrg2dCBDn7RCaJnpWYK7tExWmq2veVAI
         cVcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rdz+onrEHU9FBrqLBH6wXhqeAdLAMrM4NAoEI+V47uE=;
        b=NCqs30pjbQts66Mnyz4OGy4aLgMoSImQLOXqPGrrhs/IU48eRH1LoUzAlaH2aeiSkb
         Giv/I07ej7KAOEkkbxydYT/Vb3aaypk2vLB6JwupST0fm4z+T+dXt53wAmsPr2pj9hLW
         FdCdaKiNHuj6tIQwu/vPGHWSx5yXveG7eEcui5WoEyXJvybEqzj64Utaq30SSi5mUXY3
         6xn/k9JMwAgyJEcHKLi03c1Vo/Cfor+croEYokuYSNeE+jnYQBXiHdI/IbRASxJZeFVW
         iyzpV+DpVdJYVq05Q5gPlGTB5/a9tyWiLYliNYE8+CYSEPVfuh8YHEFqbB2MPsCAprN6
         PUnQ==
X-Gm-Message-State: AFqh2krij8FdoH2QcML89z9trb/kWdHEG96rbBN5HKzH+aGEl86c27vR
        jDV9L9FNNdQzVJo1cRDDJa8=
X-Google-Smtp-Source: AMrXdXv9JZyi5OV4ts5zLqLkIxP665VjGbIGvkxkdmKW+Hqe77pbhiq+6awQFhW/tyhb7bhi4rNChA==
X-Received: by 2002:a05:6a20:13a6:b0:af:9c75:6699 with SMTP id w38-20020a056a2013a600b000af9c756699mr121823718pzh.1.1673506444154;
        Wed, 11 Jan 2023 22:54:04 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id qe9-20020a17090b4f8900b001df264610c4sm7920881pjb.0.2023.01.11.22.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 22:54:03 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org--cc, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net] tcp: avoid the lookup process failing to get sk in ehash table
Date:   Thu, 12 Jan 2023 14:53:36 +0800
Message-Id: <20230112065336.41034-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
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

From: Jason Xing <kernelxing@tencent.com>

While one cpu is working on looking up the right socket from ehash
table, another cpu is done deleting the request socket and is about
to add (or is adding) the big socket from the table. It means that
we could miss both of them, even though it has little chance.

Let me draw a call trace map of the server side.
   CPU 0                           CPU 1
   -----                           -----
tcp_v4_rcv()                  syn_recv_sock()
                            inet_ehash_insert()
                            -> sk_nulls_del_node_init_rcu(osk)
__inet_lookup_established()
                            -> __sk_nulls_add_node_rcu(sk, list)

Notice that the CPU 0 is receiving the data after the final ack
during 3-way shakehands and CPU 1 is still handling the final ack.

Why could this be a real problem?
This case is happening only when the final ack and the first data
receiving by different CPUs. Then the server receiving data with
ACK flag tries to search one proper established socket from ehash
table, but apparently it fails as my map shows above. After that,
the server fetches a listener socket and then sends a RST because
it finds a ACK flag in the skb (data), which obeys RST definition
in RFC 793.

Many thanks to Eric for great help from beginning to end.

Fixes: 5e0724d027f0 ("tcp/dccp: fix hashdance race for passive sessions")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 net/ipv4/inet_hashtables.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 24a38b56fab9..18f88cb4efcb 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -650,7 +650,16 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	spin_lock(lock);
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
+		if (sk_hashed(osk))
+			/* Before deleting the node, we insert a new one to make
+			 * sure that the look-up=sk process would not miss either
+			 * of them and that at least one node would exist in ehash
+			 * table all the time. Otherwise there's a tiny chance
+			 * that lookup process could find nothing in ehash table.
+			 */
+			__sk_nulls_add_node_rcu(sk, list);
 		ret = sk_nulls_del_node_init_rcu(osk);
+		goto unlock;
 	} else if (found_dup_sk) {
 		*found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
 		if (*found_dup_sk)
@@ -660,6 +669,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	if (ret)
 		__sk_nulls_add_node_rcu(sk, list);
 
+unlock:
 	spin_unlock(lock);
 
 	return ret;
-- 
2.37.3

