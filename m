Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B94699A0A
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjBPQaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjBPQ3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:29:37 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE04F59B67
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:28 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4cddba76f55so25709907b3.23
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=283l3a/tUE8xbNSPHcrnWcsNHJnpHUea+yLRapuNfEM=;
        b=PyCPnTAR5CmphaiVVFWOwcnYbIMmbItu3Q/svukxp5eOxeISF29P7ISVbvxBRfqZMd
         Po9Va66UDWxst8/WzGYqaKP3Tv/mmZeDRC0d5L3fs0iNOxyGzDSCtOql6HSEps0GGTdM
         DB2EThIcOcgf8lJvykTyc2lGF6urYP6uoNJa0VNpp2Sk1OjRClYdJLiZSVdprBI4zH4b
         izzU8/2BON2ZN3JLgCBXLLuQLf0kX+VLAHKEcQIFsR6jwnaHJhBUm24uYEXOMBAw/3FE
         bCroO2xIwUZn6yh/3VZEr4oIlM9XmmEddX9BX+BlLYcOepMEcWPTme9Z3w7yc9Qom0oW
         G6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=283l3a/tUE8xbNSPHcrnWcsNHJnpHUea+yLRapuNfEM=;
        b=aWiwplVAwy52shE0wyMdK5QGSx5azg2016O9ovpBzz6gXclvg8EhhziW7ZoHOe73Rj
         MprbRo3Cv+3IUNhfSOF9BvCyPEGgPy2myyML0VqhPy+p95ulSjTF5vjbUuGUNkhf27z1
         +uXFqe2TxeMP09CvUEl0BUYQ68Ko7D8KpA//b91hrzd1GsstmiVNzH+2Teew7+y2KOmK
         NW889NkjqOeTtuECEefa+CIkGZ5wnQdKNHSo4G36aLkUVJUzeNCDLhd39UN+Gj5snnc4
         EbJKCs+Wx9iVMI4BUXeQflINTz0m+1mRgGn8JH4DNXXSgVV9iKd0ntym4LdxiVssVwtl
         N/5Q==
X-Gm-Message-State: AO0yUKUm482hyPFR61wszqJrvW9NX3WGrEjKJNfLX85QG7bMwiWyT+hi
        FX/+C3y3+Ua1r9IzZRreFAF9O06PVC5jXA==
X-Google-Smtp-Source: AK7set/bcXHFABRESwvoLYebxeoBrl1oEzgmxH6Ox+JplRk5Bz3AAUNEx3+wVpxH8D5rlv4uxS3xTQix6JjBfg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:8811:0:b0:914:fc5e:bbec with SMTP id
 c17-20020a258811000000b00914fc5ebbecmr6ybl.13.1676564967464; Thu, 16 Feb 2023
 08:29:27 -0800 (PST)
Date:   Thu, 16 Feb 2023 16:28:42 +0000
In-Reply-To: <20230216162842.1633734-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230216162842.1633734-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216162842.1633734-9-edumazet@google.com>
Subject: [PATCH net-next 8/8] ipv6: icmp6: add drop reason support to icmpv6_echo_reply()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change icmpv6_echo_reply() to return a drop reason.

For the moment, return NOT_SPECIFIED or SKB_CONSUMED.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/icmp.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index f32bc98155bfb027dd3328eefd4a26a1d067c013..1f53f2a74480c0b8433204b567e7f98ad1216ad6 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -705,7 +705,7 @@ int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
 }
 EXPORT_SYMBOL(ip6_err_gen_icmpv6_unreach);
 
-static void icmpv6_echo_reply(struct sk_buff *skb)
+static enum skb_drop_reason icmpv6_echo_reply(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
 	struct sock *sk;
@@ -719,18 +719,19 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	struct dst_entry *dst;
 	struct ipcm6_cookie ipc6;
 	u32 mark = IP6_REPLY_MARK(net, skb->mark);
+	SKB_DR(reason);
 	bool acast;
 	u8 type;
 
 	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
 	    net->ipv6.sysctl.icmpv6_echo_ignore_multicast)
-		return;
+		return reason;
 
 	saddr = &ipv6_hdr(skb)->daddr;
 
 	acast = ipv6_anycast_destination(skb_dst(skb), saddr);
 	if (acast && net->ipv6.sysctl.icmpv6_echo_ignore_anycast)
-		return;
+		return reason;
 
 	if (!ipv6_unicast_destination(skb) &&
 	    !(net->ipv6.sysctl.anycast_src_echo_reply && acast))
@@ -804,6 +805,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	} else {
 		icmpv6_push_pending_frames(sk, &fl6, &tmp_hdr,
 					   skb->len + sizeof(struct icmp6hdr));
+		reason = SKB_CONSUMED;
 	}
 out_dst_release:
 	dst_release(dst);
@@ -811,6 +813,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	icmpv6_xmit_unlock(sk);
 out_bh_enable:
 	local_bh_enable();
+	return reason;
 }
 
 enum skb_drop_reason icmpv6_notify(struct sk_buff *skb, u8 type,
@@ -929,12 +932,12 @@ static int icmpv6_rcv(struct sk_buff *skb)
 	switch (type) {
 	case ICMPV6_ECHO_REQUEST:
 		if (!net->ipv6.sysctl.icmpv6_echo_ignore_all)
-			icmpv6_echo_reply(skb);
+			reason = icmpv6_echo_reply(skb);
 		break;
 	case ICMPV6_EXT_ECHO_REQUEST:
 		if (!net->ipv6.sysctl.icmpv6_echo_ignore_all &&
 		    READ_ONCE(net->ipv4.sysctl_icmp_echo_enable_probe))
-			icmpv6_echo_reply(skb);
+			reason = icmpv6_echo_reply(skb);
 		break;
 
 	case ICMPV6_ECHO_REPLY:
-- 
2.39.1.581.gbfd45094c4-goog

