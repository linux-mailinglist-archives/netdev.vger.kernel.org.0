Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAE1414F08
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbhIVR2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:28:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236866AbhIVR2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632331627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N8nuT0dVHQfNFFHpAtAf7gLVW6Ovil5Qtijg6ZCY4K0=;
        b=TvVUjvSPatlThQAOAhukGuCi+CSfsnAsO0ZNPKo1s3MVd7a/ntDdgfLMLr6sPl1qS+jgXG
        Vd/JuzPR/WEd9YzSdR136dfKnYl5G79iH5k8Myv92gxic82y3T2wL8C9DoKEi7PvY5davF
        Mg6Y/lflcJua84KLhwWF0FaFQ6jSTxg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-UmL-LV2AOoygY5GXQ8y7Hw-1; Wed, 22 Sep 2021 13:27:04 -0400
X-MC-Unique: UmL-LV2AOoygY5GXQ8y7Hw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BECC19251A3;
        Wed, 22 Sep 2021 17:27:03 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADC071972D;
        Wed, 22 Sep 2021 17:27:01 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.linux.dev
Subject: [PATCH net-next 3/4] tcp: make tcp_build_frag() static
Date:   Wed, 22 Sep 2021 19:26:42 +0200
Message-Id: <5e04e52a27a272a19d23162ea20ef62fd91c94b4.1632318035.git.pabeni@redhat.com>
In-Reply-To: <cover.1632318035.git.pabeni@redhat.com>
References: <cover.1632318035.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the previous patch the mentioned helper is
used only inside its compilation unit: let's make
it static.

RFC -> v1:
 - preserve the tcp_build_frag() helper (Eric)

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/tcp.h | 2 --
 net/ipv4/tcp.c    | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4a96f6e0f6f8..673c3b01e287 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -330,8 +330,6 @@ int tcp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
 		 int flags);
 int tcp_sendpage_locked(struct sock *sk, struct page *page, int offset,
 			size_t size, int flags);
-struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
-			       struct page *page, int offset, size_t *size);
 ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 		 size_t size, int flags);
 int tcp_send_mss(struct sock *sk, int *size_goal, int flags);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c592454625e1..29cb7bf9dc1c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -963,8 +963,8 @@ void tcp_remove_empty_skb(struct sock *sk, struct sk_buff *skb)
 	}
 }
 
-struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
-			       struct page *page, int offset, size_t *size)
+static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
+				      struct page *page, int offset, size_t *size)
 {
 	struct sk_buff *skb = tcp_write_queue_tail(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
-- 
2.26.3

