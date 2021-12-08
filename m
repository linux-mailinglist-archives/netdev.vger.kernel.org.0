Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAAAB46DC85
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239880AbhLHT6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:58:25 -0500
Received: from smtp.uniroma2.it ([160.80.6.16]:41949 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhLHT6Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 14:58:25 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 1B8JsPFF030920
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 8 Dec 2021 20:54:25 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yohei Kanemaru <yohei.kanemaru@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net] seg6: fix the iif in the IPv6 socket control block
Date:   Wed,  8 Dec 2021 20:54:09 +0100
Message-Id: <20211208195409.12169-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an IPv4 packet is received, the ip_rcv_core(...) sets the receiving
interface index into the IPv4 socket control block (v5.16-rc4,
net/ipv4/ip_input.c line 510):

    IPCB(skb)->iif = skb->skb_iif;

If that IPv4 packet is meant to be encapsulated in an outer IPv6+SRH
header, the seg6_do_srh_encap(...) performs the required encapsulation.
In this case, the seg6_do_srh_encap function clears the IPv6 socket control
block (v5.16-rc4 net/ipv6/seg6_iptunnel.c line 163):

    memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));

The memset(...) was introduced in commit ef489749aae5 ("ipv6: sr: clear
IP6CB(skb) on SRH ip4ip6 encapsulation") a long time ago (2019-01-29).

Since the IPv6 socket control block and the IPv4 socket control block share
the same memory area (skb->cb), the receiving interface index info is lost
(IP6CB(skb)->iif is set to zero).

As a side effect, that condition triggers a NULL pointer dereference if
commit 0857d6f8c759 ("ipv6: When forwarding count rx stats on the orig
netdev") is applied.

To fix that issue, we set the IP6CB(skb)->iif with the index of the
receiving interface once again.

Fixes: ef489749aae5 ("ipv6: sr: clear IP6CB(skb) on SRH ip4ip6 encapsulation")
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_iptunnel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 3adc5d9211ad..d64855010948 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -161,6 +161,14 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 		hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));
 
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+
+		/* the control block has been erased, so we have to set the
+		 * iif once again.
+		 * We read the receiving interface index directly from the
+		 * skb->skb_iif as it is done in the IPv4 receiving path (i.e.:
+		 * ip_rcv_core(...)).
+		 */
+		IP6CB(skb)->iif = skb->skb_iif;
 	}
 
 	hdr->nexthdr = NEXTHDR_ROUTING;
-- 
2.20.1

