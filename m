Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C070606824
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiJTSWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiJTSWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:22:45 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5901E8B88
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666290164; x=1697826164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=myVE57plMi7MY/0zZrHGgR4FmIhk65U1CkbMCyaiT6c=;
  b=FzY38VuLZJ2c8bweyS5IKtE8iigJOfC7mjTR1EC8UkJCcS07YL05vin/
   OY1/OWw6coEQnlRl5yqy3Nw9Tj1KJ0Qvhx+pFKaQNV2Ctwc+1pjChWLJd
   dc/9u4ErXpWffab378Bgy/J5VUXC3vc48MlgmMSqG9OsUewlbNGAP9U0x
   f/6L+xh8NJ+xJhIb0aO4nAxlqD++oCIqlgV2a2g8AwqwsodAK1qeqTzTl
   Lt61ULqoatWtgg8PNCabODJhzTLdFWWzw6dYUIzFeD+TK5V1cDl5BX6jI
   m4t8WzD8rArVfbpqPS0UiSlRExZvloYAtw1LAwaU4mhzm04Z/AIJFekug
   g==;
X-IronPort-AV: E=Sophos;i="5.95,199,1661788800"; 
   d="scan'208";a="326465854"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 02:22:43 +0800
IronPort-SDR: UlqqGgtx4U50N/2NrN4nE99RsKQTP/fJlgsCc+3xHBKkTpZTsviff7Mm3J4s40oTmtBfk8sUj6
 FYLmWJGgkjMKng4SGbYX6CBTGGkoxLdPpmYM8XLqTU+jxqQg+NPQ3eqPHk9pYIe6bPLl0larMc
 sb5Zp7uURgifkxJUfPeOa8EdP+IWgbe2+pISe/Pe8nrbeRSkJIOkmNsKIQYWd1S0WC9CZ9ViLN
 Mym7euKSFM+c1f8itlT/+Vi0poQi1UhVORAAoAQGc0vGqKhI8a1re6WvPiqKn8FJ6pZjxu2Qqr
 4XB8ktxI5C4024GbXeSearL5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 10:36:33 -0700
IronPort-SDR: 2/CacmSCVEAcI0/ob7miCmGzMx/TzlqJ3VwrOO4gVyq4YTWfwjr5v6WUJuEiOIN3klLZT+GgMn
 UH6FBH3SlakKELh5rTszLcFJzvlB0dud94V/F9PRKCtfFXxKK2mQaDWdZ+5J5OZNPrwhIZ0h1h
 E1JjFQk0nkHMH3dJ7YoGYKxRg090mYt3OCs7MdaquIJyZ+xG1nvx5rZicZhks8ZOVa3b9dEp5W
 mryNpv2xR+MFGJnp498b12Ov+15hINUQNKrEEOXPsI/Gc48qu5/5sN2C5sSD+w/iyh/xVg/dfk
 qIQ=
WDCIronportException: Internal
Received: from ros-3.k2.wdc.com ([10.203.225.83])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Oct 2022 11:22:43 -0700
From:   Kamaljit Singh <kamaljit.singh1@wdc.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Niklas.Cassel@wdc.com,
        Damien.LeMoal@wdc.com, kamaljit.singh1@wdc.com
Subject: [PATCH v1 1/2] tcp: Fix for stale host ACK when tgt window shrunk
Date:   Thu, 20 Oct 2022 11:22:41 -0700
Message-Id: <20221020182242.503107-2-kamaljit.singh1@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221020182242.503107-1-kamaljit.singh1@wdc.com>
References: <20221020182242.503107-1-kamaljit.singh1@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under certain congestion conditions, an NVMe/TCP target may be configured
to shrink the TCP window in an effort to slow the sender down prior to
issuing a more drastic L2 pause or PFC indication.  Although the TCP
standard discourages implementations from shrinking the TCP window, it also
states that TCP implementations must be robust to this occurring. The
current Linux TCP layer (in conjunction with the NVMe/TCP host driver) has
an issue when the TCP window is shrunk by a target, which causes ACK frames
to be transmitted with a “stale” SEQ_NUM or for data frames to be
retransmitted by the host. It has been observed that processing of these
“stale” ACKs or data retransmissions impacts NVMe/TCP Write IOPs
performance.

Network traffic analysis revealed that SEQ-NUM being used by the host to
ACK the frame that resized the TCP window had an older SEQ-NUM and not a
value corresponding to the next SEQ-NUM expected on that connection.

In such a case, the kernel was using the seq number calculated by
tcp_wnd_end() as per the code segment below. Since, in this case
tp->snd_wnd=0, tcp_wnd_end(tp) returns tp->snd_una, which is incorrect for
the scenario.  The correct seq number that needs to be returned is
tp->snd_nxt. This fix seems to have fixed the stale SEQ-NUM issue along
with its performance impact.

  1271 static inline u32 tcp_wnd_end(const struct tcp_sock *tp)
  1272 {
  1273   return tp->snd_una + tp->snd_wnd;
  1274 }

Signed-off-by: Kamaljit Singh <kamaljit.singh1@wdc.com>
---
 net/ipv4/tcp_output.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 11aa0ab10bba..322e061edb72 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -100,6 +100,9 @@ static inline __u32 tcp_acceptable_seq(const struct sock *sk)
 	    (tp->rx_opt.wscale_ok &&
 	     ((tp->snd_nxt - tcp_wnd_end(tp)) < (1 << tp->rx_opt.rcv_wscale))))
 		return tp->snd_nxt;
+	else if (!tp->snd_wnd && !sock_flag(sk, SOCK_DEAD) &&
+		 !((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)))
+		return tp->snd_nxt;
 	else
 		return tcp_wnd_end(tp);
 }
-- 
2.25.1

