Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E17207086
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388100AbgFXJ6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387647AbgFXJ6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:58:10 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A1AC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 02:58:10 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id m26so937131lfo.13
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 02:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2HfquG4v+qdKSSfgNiWDolP2UK6Uw4jh+8+xqXuTJq0=;
        b=RG1xv8ecbx1fHPythOvgyVi/IGbrmQ3lWgYz7eORIXYnGsNP6rC5LDO5K+/BD2bpfp
         M7/tmgoe6/YEghXY6pnR8n1I1/7cUg/atsUKYpJzZW3PjBi047DZH8smqKCzmFTdjLKM
         Yea/KjrmR0mRJFrjfUfKjlbn8fd7D+MKKgIL6cAOXOvgRGwqlEuOfRF0d9AA3HDMHnzW
         BqoIJx5Ct9490bnAomhsR6gTcmeKRcVB5Tkyt+ebT4Zd24+HOtDx/YN9M3uIwi5j5PbC
         i2W0oWL4LXso1zBDsasHU5WX6j1MNuxkcOuHq7zcFZ7f9NfW5BnII9VBVOteSceaWCWD
         xaIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2HfquG4v+qdKSSfgNiWDolP2UK6Uw4jh+8+xqXuTJq0=;
        b=oCLzV9jZf6aqQhlzv3ljPYGOVXvlpAb4VOwdJoDM1ZHvGfu7tlU6e2Rw8YxD/8E4Eb
         +MmNVrM2FtFqG/xLWTif5XzvOKKBIdpmE/zaVH7Pm2hHvnh7PAsTmTzS2/jULC7LIyo1
         Yz7sSTBndv4CywabH6ZNikkRp6ymxiK8lt6guozoqvvJ2OhFYuDH2Ly/j8hhPf9cLuh6
         kHsFtty6vGXMr87RJ3w9tWBIij3uQTuxW5iBaIXMcJ7gvFrZ9X6sJlaC7rUiyly2Qewa
         kXaPnLYoSa1+WZwrNttaL4PR0xuoCvvdiC9iofV/PDIFYrp+GSEKNF/WCTP6qjGm+y3B
         EAcw==
X-Gm-Message-State: AOAM530VuNUl944g6CXlRw3NJ0sdTNAHDwP/CyHoMEE/0kAoz9PjWixS
        fcG14mhJwcffU3iny3unqPiA3YzPxQmSZQ==
X-Google-Smtp-Source: ABdhPJzFC8l5SFf/d4YLByv8jUZhG9fcNc/BO7CJKpe3lqp9RiJvvXr5rXhHPvA0mg22V6n98DWCzg==
X-Received: by 2002:a05:6512:10d3:: with SMTP id k19mr15437094lfg.78.1592992688510;
        Wed, 24 Jun 2020 02:58:08 -0700 (PDT)
Received: from localhost.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id q11sm4989934lfe.34.2020.06.24.02.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 02:58:07 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <denis.kirjanov@suse.com>
To:     netdev@vger.kernel.org
Cc:     ncardwell@google.com, edumazet@google.com, ycheng@google.com,
        Richard.Scheffenegger@netapp.com, ietf@bobbriscoe.net
Subject: [PATCH v2] tcp: don't ignore ECN CWR on pure ACK
Date:   Wed, 24 Jun 2020 12:57:48 +0300
Message-Id: <20200624095748.8246-1-denis.kirjanov@suse.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is a problem with the CWR flag set in an incoming ACK segment
and it leads to the situation when the ECE flag is latched forever

the following packetdrill script shows what happens:

// Stack receives incoming segments with CE set
+0.1 <[ect0]  . 11001:12001(1000) ack 1001 win 65535
+0.0 <[ce]    . 12001:13001(1000) ack 1001 win 65535
+0.0 <[ect0] P. 13001:14001(1000) ack 1001 win 65535

// Stack repsonds with ECN ECHO
+0.0 >[noecn]  . 1001:1001(0) ack 12001
+0.0 >[noecn] E. 1001:1001(0) ack 13001
+0.0 >[noecn] E. 1001:1001(0) ack 14001

// Write a packet
+0.1 write(3, ..., 1000) = 1000
+0.0 >[ect0] PE. 1001:2001(1000) ack 14001

// Pure ACK received
+0.01 <[noecn] W. 14001:14001(0) ack 2001 win 65535

// Since CWR was sent, this packet should NOT have ECE set

+0.1 write(3, ..., 1000) = 1000
+0.0 >[ect0]  P. 2001:3001(1000) ack 14001
// but Linux will still keep ECE latched here, with packetdrill
// flagging a missing ECE flag, expecting
// >[ect0] PE. 2001:3001(1000) ack 14001
// in the script

In the situation above we will continue to send ECN ECHO packets
and trigger the peer to reduce the congestion window. To avoid that
we can check CWR on pure ACKs received.

v2:
- Adjusted the comment
- move CWR check before checking for unacknowledged packets

Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
---
 net/ipv4/tcp_input.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 12fda8f27b08..f1936c0cb684 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3665,6 +3665,15 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		tcp_in_ack_event(sk, ack_ev_flags);
 	}
 
+	/* This is a deviation from RFC3168 since it states that:
+	 * "When the TCP data sender is ready to set the CWR bit after reducing
+	 * the congestion window, it SHOULD set the CWR bit only on the first
+	 * new data packet that it transmits."
+	 * We accept CWR on pure ACKs to be more robust
+	 * with widely-deployed TCP implementations that do this.
+	 */
+	tcp_ecn_accept_cwr(sk, skb);
+
 	/* We passed data and got it acked, remove any soft error
 	 * log. Something worked...
 	 */
@@ -4800,8 +4809,6 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 	skb_dst_drop(skb);
 	__skb_pull(skb, tcp_hdr(skb)->doff * 4);
 
-	tcp_ecn_accept_cwr(sk, skb);
-
 	tp->rx_opt.dsack = 0;
 
 	/*  Queue data for delivery to the user.
-- 
2.27.0

