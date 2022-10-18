Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D9B602033
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 03:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiJRBJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 21:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiJRBJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 21:09:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5F28C46D
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 18:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666055352; x=1697591352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=xjj0YkAW4F3nyvpdguvfI3XQo+FdMI46/713tRluJBM=;
  b=KtzZHz0M3+N7GuanMBZPzYiyhYD6prsrgUq7N2eh6+1DSDK3+2FAOcDd
   L4KWQBGoL9WC2+doL/VqXFhimAzHbJbUPqsxpY/mMPUvwXBbwXLt4u7Bp
   Kwhpvlyq6jFIyNJyAx6ZL+QXVS/3UEtrPMEArXNeCNlJboOrPB2tgD9ii
   z3FBlNev+NwUDBRLCa7I55sf2EGK9jaCeY9+NImeXs8W0uaPgQ76PsZ9U
   MOB/lVdwFthjF75cx/r8OLsqzr5G0g259l4yN7sj1uk/N6SmccYFzUVJG
   QSP9TSd6SBWGSvVXo4j+sFieXHoV4WG61sUIqDAQAu/QG9UHvAlS0c3Cg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="392264182"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="392264182"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 18:09:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="717704414"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="717704414"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Oct 2022 18:09:08 -0700
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, aravindhan.gunasekaran@intel.com,
        richardcochran@gmail.com, gal@nvidia.com, saeed@kernel.org,
        leon@kernel.org, michael.chan@broadcom.com, andy@greyhouse.net,
        muhammad.husaini.zulkifli@intel.com, vinicius.gomes@intel.com
Subject: [PATCH v2 2/5] net-timestamp: Increase the size of tsflags
Date:   Tue, 18 Oct 2022 09:07:30 +0800
Message-Id: <20221018010733.4765-3-muhammad.husaini.zulkifli@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 08038a385ef2..ad5a3d44ad25 100644
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
@@ -1892,7 +1892,7 @@ void sk_send_sigurg(struct sock *sk);
 struct sockcm_cookie {
 	u64 transmit_time;
 	u32 mark;
-	u16 tsflags;
+	u32 tsflags;
 };
 
 static inline void sockcm_init(struct sockcm_cookie *sockc,
@@ -2723,7 +2723,7 @@ static inline void sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
 		sock_write_timestamp(sk, 0);
 }
 
-void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags);
+void __sock_tx_timestamp(__u32 tsflags, __u8 *tx_flags);
 
 /**
  * _sock_tx_timestamp - checks whether the outgoing packet is to be time stamped
@@ -2734,7 +2734,7 @@ void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags);
  *
  * Note: callers should take care of initial ``*tx_flags`` value (usually 0)
  */
-static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
+static inline void _sock_tx_timestamp(struct sock *sk, __u32 tsflags,
 				      __u8 *tx_flags, __u32 *tskey)
 {
 	if (unlikely(tsflags)) {
@@ -2747,13 +2747,13 @@ static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
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
index 00da9ce3dba0..ab5d8973e719 100644
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

