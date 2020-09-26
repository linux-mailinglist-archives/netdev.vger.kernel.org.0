Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAF227960F
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 03:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbgIZB4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 21:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728967AbgIZB4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 21:56:11 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94638207EA;
        Sat, 26 Sep 2020 01:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085370;
        bh=/7dKaQ/3t+Qus+HqEp7+3oCtQSXdPT+CQrPdJO/2+os=;
        h=From:To:Cc:Subject:Date:From;
        b=fvRSfJlurR4wlXtHXoNcMSNN1SgAiZtKVd7Shsh23jInwzwh5NmxPGWXhDvCnL066
         OF5bjUMP43gGkCEkxDFXQw7klrTLsJDG8hlkirGPysGlg9bZXVf6qU+STKwQCt9eSZ
         kyEaOejJIjlunFhz/tbvM7MMVMJ1aqhpUe3HkvRk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, fabf@skynet.be,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] Revert "vxlan: move encapsulation warning"
Date:   Fri, 25 Sep 2020 18:56:04 -0700
Message-Id: <20200926015604.3363358-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 546c044c9651e81a16833806feff6b369bb5de33.

Nothing prevents user from sending frames to "external" VxLAN devices.
In fact kernel itself may generate icmp chatter.

This is fine, such frames should be dropped.

The point of the "missing encapsulation" warning was that
frames with missing encap should not make it into vxlan_xmit_one().
And vxlan_xmit() drops them cleanly, so let it just do that.

Without this revert the warning is triggered by the udp_tunnel_nic.sh
test, but the minimal repro is:

$ ip link add vxlan0 type vxlan \
     	      	     group 239.1.1.1 \
		     dev lo \
		     dstport 1234 \
		     external
$ ip li set dev vxlan0 up

[  419.165981] vxlan0: Missing encapsulation instructions
[  419.166551] WARNING: CPU: 0 PID: 1041 at drivers/net/vxlan.c:2889 vxlan_xmit+0x15c0/0x1fc0 [vxlan]

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/vxlan.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index fa21d62aa79c..be3bf233a809 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2651,6 +2651,11 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM6_TX);
 		label = vxlan->cfg.label;
 	} else {
+		if (!info) {
+			WARN_ONCE(1, "%s: Missing encapsulation instructions\n",
+				  dev->name);
+			goto drop;
+		}
 		remote_ip.sa.sa_family = ip_tunnel_info_af(info);
 		if (remote_ip.sa.sa_family == AF_INET) {
 			remote_ip.sin.sin_addr.s_addr = info->key.u.ipv4.dst;
@@ -2885,10 +2890,6 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 		    info->mode & IP_TUNNEL_INFO_TX) {
 			vni = tunnel_id_to_key32(info->key.tun_id);
 		} else {
-			if (!info)
-				WARN_ONCE(1, "%s: Missing encapsulation instructions\n",
-					  dev->name);
-
 			if (info && info->mode & IP_TUNNEL_INFO_TX)
 				vxlan_xmit_one(skb, dev, vni, NULL, false);
 			else
-- 
2.26.2

