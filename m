Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCB15EC3B8
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbiI0NIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiI0NIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:08:12 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E58A181CD5
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 06:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664284090; x=1695820090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Kog0xSd26qPd6cwbA++KQY6QqoIoX9anF6dCmsdaD68=;
  b=NPqDRT+rxddGhf0DcPs5flCYOGEBFHBavvVjF8g2NnHc/OcjBRwKmK2M
   KiLbX6Ja+YISBj9pzD6CR8U0Nbe6lsZIw/VeZv9Wr9If0drBd/PcBv3sZ
   xoPOSJn05EzoQmvZs7GWrpiLNvL+yLDbTNTk8cUXlECscCvFekuKPS7h0
   UfvKockqen1E1RIxxaHRNHPXvjFZsIzQxs79OE0JQT9R9v96sdWE/nxJH
   N1ad8CIE1j7J/pqXedUugzPruW2XjOtiNbbBy+NcvWb+f4qhrQvWaTYC1
   EnzTEUVyXN2kF10HIoP6BzkAZwnm87L/DJfoisjIThv+a9AKQhmyl0Rpz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="363148203"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="363148203"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 06:08:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="689984913"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="689984913"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by fmsmga004.fm.intel.com with ESMTP; 27 Sep 2022 06:07:58 -0700
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, muhammad.husaini.zulkifli@intel.com,
        vinicius.gomes@intel.com, aravindhan.gunasekaran@intel.com,
        noor.azura.ahmad.tarmizi@intel.com
Subject: [PATCH v1 2/4] net-timestamp: Increase the size of tsflags
Date:   Tue, 27 Sep 2022 21:06:54 +0800
Message-Id: <20220927130656.32567-3-muhammad.husaini.zulkifli@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increase the size of tsflags to support more SOF_TIMESTAMPING flags.
Current flag size can only support up to 16 flags only.

Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
---
 include/net/sock.h | 12 ++++++------
 net/socket.c       |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 96a31026e35d..6be4d768d7dd 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -503,7 +503,7 @@ struct sock {
 #if BITS_PER_LONG==32
 	seqlock_t		sk_stamp_seq;
 #endif
-	u16			sk_tsflags;
+	u32			sk_tsflags;
 	u8			sk_shutdown;
 	atomic_t		sk_tskey;
 	atomic_t		sk_zckey;
@@ -1897,7 +1897,7 @@ void sk_send_sigurg(struct sock *sk);
 struct sockcm_cookie {
 	u64 transmit_time;
 	u32 mark;
-	u16 tsflags;
+	u32 tsflags;
 };
 
 static inline void sockcm_init(struct sockcm_cookie *sockc,
@@ -2728,7 +2728,7 @@ static inline void sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
 		sock_write_timestamp(sk, 0);
 }
 
-void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags);
+void __sock_tx_timestamp(__u32 tsflags, __u8 *tx_flags);
 
 /**
  * _sock_tx_timestamp - checks whether the outgoing packet is to be time stamped
@@ -2739,7 +2739,7 @@ void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags);
  *
  * Note: callers should take care of initial ``*tx_flags`` value (usually 0)
  */
-static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
+static inline void _sock_tx_timestamp(struct sock *sk, __u32 tsflags,
 				      __u8 *tx_flags, __u32 *tskey)
 {
 	if (unlikely(tsflags)) {
@@ -2752,13 +2752,13 @@ static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
 		*tx_flags |= SKBTX_WIFI_STATUS;
 }
 
-static inline void sock_tx_timestamp(struct sock *sk, __u16 tsflags,
+static inline void sock_tx_timestamp(struct sock *sk, __u32 tsflags,
 				     __u8 *tx_flags)
 {
 	_sock_tx_timestamp(sk, tsflags, tx_flags, NULL);
 }
 
-static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u16 tsflags)
+static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u32 tsflags)
 {
 	_sock_tx_timestamp(skb->sk, tsflags, &skb_shinfo(skb)->tx_flags,
 			   &skb_shinfo(skb)->tskey);
diff --git a/net/socket.c b/net/socket.c
index 7378375d3a5b..34ddb5d6889e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -679,7 +679,7 @@ void sock_release(struct socket *sock)
 }
 EXPORT_SYMBOL(sock_release);
 
-void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags)
+void __sock_tx_timestamp(__u32 tsflags, __u8 *tx_flags)
 {
 	u8 flags = *tx_flags;
 
-- 
2.17.1

