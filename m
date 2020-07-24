Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B1622CF47
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 22:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgGXUOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 16:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgGXUOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 16:14:32 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A31C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 13:14:32 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mn17so5974434pjb.4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 13:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6OvgDG82ceAHlWrqNRtZ1r2siGWTPfqikykIZRtebeQ=;
        b=fi7AD+Byp1HyOu/SvIsk6oU2pFyod5nB1Qst6kLOyFoDAiCxSA2d9bWOG0eveHddrA
         DUTTuGEtW0FkSA1hVmNxD6CCDDn6np2kSTrxkhdNvJ3EnqFsEZSpCLo9yk+RNAWgF+cv
         1GYLbcRftAuvYzvLIZBd0HGVjrrXDYugl76TLcHogJtBJd7sny6u/lE/HQclc39IpIO1
         5LMWAq388WFTKUFSxfwNcXX9FM+kmRv//UV2HA81xKm+lJd9aE/dKlymphAeqgnm6OCZ
         +iP1zNwISLuDLUu/su3/GjwP6s0b6X9n9vGMaO6PaGXQpx6xgHCjzlOZFaXJcj/VgWLb
         w56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6OvgDG82ceAHlWrqNRtZ1r2siGWTPfqikykIZRtebeQ=;
        b=SEAd6tKrFdr+AcTZV2yon9Rqx9wv0riGffi4tBpjnQ5q5DpJmqAnk7kx138paDXczo
         Uyqc7WEqzujALk3x4ahtm+A0FKmlCKnmDmQCLQjQDB7BtCQuC2de0EcP9oxxcawW2vmJ
         QT6BTICsnHVHyYX4EFOuo66nazSbcLg/3NecaPnsj6NFBBHQf5lLcnDRSUKumr/+fBB6
         ydFwNERFA0fr5jCf1Pt+hmYMdIcKOm/24M/2nbydSSf5bq+QiVPg52inUIt8pR4aXRvW
         4xwgA+C+u5xOQUuF6CvlYKl7IVOTs2nZ4VkN4108MoeWSNiDeJUo+S8kSKK22yWsJwaE
         lCUw==
X-Gm-Message-State: AOAM533V6BrEID+2VMLAGER7PweWgoYNGELNFy0nPRL6NkQxxA6XWNdF
        e9600c9dZ6Hx86bEFhL217vkmlQgEGg=
X-Google-Smtp-Source: ABdhPJz1Qnthr9236O54FNastr08sb1lsMCcAcJoCjq5PVlpen2KREYXtd6+ooFXEoeO0hw5t/hHiw==
X-Received: by 2002:a17:90b:1806:: with SMTP id lw6mr6937156pjb.236.1595621671403;
        Fri, 24 Jul 2020 13:14:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id ci23sm6496539pjb.29.2020.07.24.13.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 13:14:30 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org, amritha.nambiar@intel.com
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH net-next 1/3] sock: Definition and general functions for dev_and_queue structure
Date:   Fri, 24 Jul 2020 13:14:10 -0700
Message-Id: <20200724201412.599398-2-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200724201412.599398-1-tom@herbertland.com>
References: <20200724201412.599398-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add struct dev_and_queue which holds and ifindex and queue pair. Add
generic functions to set, get, and clear the pair in a structure.
---
 include/net/sock.h | 56 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 62e18fc8ac9f..b4919e603648 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -106,6 +106,16 @@ typedef struct {
 #endif
 } socket_lock_t;
 
+struct dev_and_queue {
+	union {
+		struct {
+			int ifindex;
+			u16 queue;
+		};
+		u64 val64;
+	};
+};
+
 struct sock;
 struct proto;
 struct net;
@@ -1788,6 +1798,50 @@ static inline int sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 	return __sk_receive_skb(sk, skb, nested, 1, true);
 }
 
+#define NO_QUEUE_MAPPING	USHRT_MAX
+
+static inline void __dev_and_queue_get(const struct dev_and_queue *idandq,
+				       int *ifindex, int *queue)
+{
+	struct dev_and_queue dandq;
+
+	dandq.val64 = idandq->val64;
+
+	if (dandq.ifindex >= 0 && dandq.queue != NO_QUEUE_MAPPING) {
+		*ifindex = dandq.ifindex;
+		*queue = dandq.queue;
+		return;
+	}
+
+	*ifindex = -1;
+	*queue = -1;
+}
+
+static inline void __dev_and_queue_set(struct dev_and_queue *odandq,
+				       struct net_device *dev, int queue)
+{
+	struct dev_and_queue dandq;
+
+	/* queue_mapping accept only upto a 16-bit value */
+	if (WARN_ON_ONCE((unsigned short)queue >= USHRT_MAX))
+		return;
+
+	dandq.ifindex = dev->ifindex;
+	dandq.queue = queue;
+
+	odandq->val64 = dandq.val64;
+}
+
+static inline void __dev_and_queue_clear(struct dev_and_queue *odandq)
+{
+	struct dev_and_queue dandq;
+
+	dandq.ifindex = -1;
+	dandq.queue = NO_QUEUE_MAPPING;
+
+	odandq->val64 = dandq.val64;
+}
+
 static inline void sk_tx_queue_set(struct sock *sk, int tx_queue)
 {
 	/* sk_tx_queue_mapping accept only upto a 16-bit value */
@@ -1796,8 +1850,6 @@ static inline void sk_tx_queue_set(struct sock *sk, int tx_queue)
 	sk->sk_tx_queue_mapping = tx_queue;
 }
 
-#define NO_QUEUE_MAPPING	USHRT_MAX
-
 static inline void sk_tx_queue_clear(struct sock *sk)
 {
 	sk->sk_tx_queue_mapping = NO_QUEUE_MAPPING;
-- 
2.25.1

