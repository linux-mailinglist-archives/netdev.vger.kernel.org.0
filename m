Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609BA6BC320
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCPBKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjCPBK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:10:29 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2378A233F1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:27 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5446a91c40cso661977b3.18
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678929027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uHDNryMAqYcj8poU5IjHoLGguf7E3hhbVNI3wG6mgZE=;
        b=JX0gGU4pMjlmYYpGwRfQI0j0oQyiKOHv45RzkpkflrCst++OGcr7Ho/IAi9AmmJ4GZ
         qRaTuGK/JbYXxkBjljICMSilqV8ps1VMHAG8IXlL4U/1RKXSa7Go4jn2CgS0rgUx7N3G
         4rOWS7Tq1KXGFxvwOC7g46JT5VzAzCEDLimphxzqiahrXcZcnDmAk/xkxPzIFucMXR+5
         YCLiqZ85TLHrwKhT1E8vGdgVUCGcry/1CwbG5LOal5DNvz9d8o91iaiYyr/RyVSX3KeX
         QGQrqa8GdPcg20OXQ5KhYGy7l9TW0gGIHNTD2/J2GgOvXzRwUg8J3isN4VqGPFDbv+Nn
         DMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678929027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uHDNryMAqYcj8poU5IjHoLGguf7E3hhbVNI3wG6mgZE=;
        b=cL6uFARc2uiA7TxO8GZ5jAXNxwEw73iPueOkIUxeDsvf8mKu1oRJs2HyAawACeHPoq
         d5KeNs6cvCwKqmeLfuo5Pr53FxU78T0pfzOO3XurPkGLBtuhC9+qB0Eg1KB7315cNLE6
         c4NG6u8mjd9eXpIZHHSpGLKpYX294jtArLvqxdQQJ4mhrs8/JaqTkk5o9d6JfqmcE2ku
         b6lCi4o10/qjxIYVTjIPNXAI3O3vbIA7AuiKpbg/udJfx4rJjVAnG3z0mwqfTspRwHiL
         OJOeBrJB2ZnNSSB8Kwr74dgjJqORSrg+TlJH54EaZ1R6eS+CVJYx9MuPagy0zCiMtGWN
         dMOg==
X-Gm-Message-State: AO0yUKVDJlVLetWnBzjQvODppgGNYRzGr0/FDjTYauyhd7/8Gt76CTYq
        FLKT9GFAA8JJg68xbLLjPR5G1Thy03CgCA==
X-Google-Smtp-Source: AK7set8Hs0j3MQC+qUNhzqnYj3xhX+rclaCEt9vmm4M9Q0ErkzvbWOOGfuaPoA0pnhH9Iblwc3DydEHMN5BPRw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:251:b0:9f1:6c48:f95f with SMTP
 id k17-20020a056902025100b009f16c48f95fmr14704452ybs.5.1678929027053; Wed, 15
 Mar 2023 18:10:27 -0700 (PDT)
Date:   Thu, 16 Mar 2023 01:10:09 +0000
In-Reply-To: <20230316011014.992179-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316011014.992179-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316011014.992179-5-edumazet@google.com>
Subject: [PATCH net-next 4/9] net/packet: annotate accesses to po->tp_tstamp
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
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

tp_tstamp is read locklessly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 9 +++++----
 net/packet/diag.c      | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ecd9fc27e360cc85be35de568e6ebcb2dbbd9d39..a27a811fa2b0d0b267cf42d5b411503587e2dccb 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -474,7 +474,7 @@ static __u32 __packet_set_timestamp(struct packet_sock *po, void *frame,
 	struct timespec64 ts;
 	__u32 ts_status;
 
-	if (!(ts_status = tpacket_get_timestamp(skb, &ts, po->tp_tstamp)))
+	if (!(ts_status = tpacket_get_timestamp(skb, &ts, READ_ONCE(po->tp_tstamp))))
 		return 0;
 
 	h.raw = frame;
@@ -2403,7 +2403,8 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	 * closer to the time of capture.
 	 */
 	ts_status = tpacket_get_timestamp(skb, &ts,
-					  po->tp_tstamp | SOF_TIMESTAMPING_SOFTWARE);
+					  READ_ONCE(po->tp_tstamp) |
+					  SOF_TIMESTAMPING_SOFTWARE);
 	if (!ts_status)
 		ktime_get_real_ts64(&ts);
 
@@ -3945,7 +3946,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		if (copy_from_sockptr(&val, optval, sizeof(val)))
 			return -EFAULT;
 
-		po->tp_tstamp = val;
+		WRITE_ONCE(po->tp_tstamp, val);
 		return 0;
 	}
 	case PACKET_FANOUT:
@@ -4097,7 +4098,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 		val = po->tp_loss;
 		break;
 	case PACKET_TIMESTAMP:
-		val = po->tp_tstamp;
+		val = READ_ONCE(po->tp_tstamp);
 		break;
 	case PACKET_FANOUT:
 		val = (po->fanout ?
diff --git a/net/packet/diag.c b/net/packet/diag.c
index d704c7bf51b2073f792ff35c1f46fba251dd4761..0abca32e2f878b419814709afb8d1d5b282d0597 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -18,7 +18,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
 	pinfo.pdi_version = po->tp_version;
 	pinfo.pdi_reserve = po->tp_reserve;
 	pinfo.pdi_copy_thresh = po->copy_thresh;
-	pinfo.pdi_tstamp = po->tp_tstamp;
+	pinfo.pdi_tstamp = READ_ONCE(po->tp_tstamp);
 
 	pinfo.pdi_flags = 0;
 	if (po->running)
-- 
2.40.0.rc2.332.ga46443480c-goog

