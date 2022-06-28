Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02ED55EE50
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbiF1Tyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiF1Tu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:56 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F5BB7F8;
        Tue, 28 Jun 2022 12:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445788; x=1687981788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rckiSPr5+wxzNkTahHMP+SEYFlLnWpiNQnrV9iaYFnc=;
  b=lpXUJAnR4zJFDkwxGVUdkIWl5zcBMBVkQjxXEJprOvwskiwgvW3bJS04
   IImA/5Qsa3vjofiWXzTW6IKuHyXGKC/MAhyde+lWWnDyIZ9rFKYQHV7Jj
   uR9dZjxcTxf1oC8fqGwawDVuqafWN4OlRrE1e7sEE/HQamZEimRKh7KBx
   qUrbyJmBsEc+/4jNftMav/Fu10nwNp/L2dZWp/Iaxdl0N4t+f+aq8EJ1e
   9mBrgdQA48LUcTtS6bNIFIAIr8MwzOaTFMVQLvxSSGMPNzUfwmGLCEOa0
   60ouWlvUOTJkmirwIHOL9JAU3kHxZwQrO4/jNkaJlv+bg9nhCaVxgLunI
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="281869598"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="281869598"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="767288113"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2022 12:49:26 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9N022013;
        Tue, 28 Jun 2022 20:49:24 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 23/52] net, skbuff: constify the @skb argument of skb_hwtstamps()
Date:   Tue, 28 Jun 2022 21:47:43 +0200
Message-Id: <20220628194812.1453059-24-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The @skb argument only dereferences the &skb_shared_info pointer,
so it doesn't need a writable pointer. Constify it to be able to
pass const pointers to the code which uses this function and give
the compilers a little more room for optimization.
As an example, constify the @skb argument of tpacket_get_timestamp()
and __packet_set_timestamp() of the AF_PACKET core code. There are
lot more places in the kernel where the similar micro-opts can be
done in the future.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/skbuff.h | 3 ++-
 net/packet/af_packet.c | 8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 1c308511acbb..0a95f753c1d9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1617,7 +1617,8 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 /* Internal */
 #define skb_shinfo(SKB)	((struct skb_shared_info *)(skb_end_pointer(SKB)))
 
-static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *skb)
+static inline struct skb_shared_hwtstamps *
+skb_hwtstamps(const struct sk_buff *skb)
 {
 	return &skb_shinfo(skb)->hwtstamps;
 }
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d08c4728523b..20eac049e69e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -449,10 +449,10 @@ static int __packet_get_status(const struct packet_sock *po, void *frame)
 	}
 }
 
-static __u32 tpacket_get_timestamp(struct sk_buff *skb, struct timespec64 *ts,
-				   unsigned int flags)
+static __u32 tpacket_get_timestamp(const struct sk_buff *skb,
+				   struct timespec64 *ts, unsigned int flags)
 {
-	struct skb_shared_hwtstamps *shhwtstamps = skb_hwtstamps(skb);
+	const struct skb_shared_hwtstamps *shhwtstamps = skb_hwtstamps(skb);
 
 	if (shhwtstamps &&
 	    (flags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
@@ -467,7 +467,7 @@ static __u32 tpacket_get_timestamp(struct sk_buff *skb, struct timespec64 *ts,
 }
 
 static __u32 __packet_set_timestamp(struct packet_sock *po, void *frame,
-				    struct sk_buff *skb)
+				    const struct sk_buff *skb)
 {
 	union tpacket_uhdr h;
 	struct timespec64 ts;
-- 
2.36.1

