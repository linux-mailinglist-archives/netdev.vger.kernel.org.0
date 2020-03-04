Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8B6179503
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388230AbgCDQYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:24:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:42266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729906AbgCDQYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 11:24:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 491F7B4C4;
        Wed,  4 Mar 2020 16:24:10 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id EB08DE037F; Wed,  4 Mar 2020 17:24:09 +0100 (CET)
Message-Id: <7096f67e03509800c4e7011a93f4911c5cba5a67.1583337972.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583337972.git.mkubecek@suse.cz>
References: <cover.1583337972.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 3/5] tun: drop useless debugging statements
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Wed,  4 Mar 2020 17:24:09 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the tun_debug() statements only inform us about entering
a function which can be easily achieved with ftrace or kprobe. As
tun_debug() is no-op unless TUN_DEBUG is set which requires editing the
source and recompiling, setting up ftrace or kprobe is easier. Drop these
debug statements.

Also drop the tun_debug() statement informing about SIOCSIFHWADDR ioctl.
We can monitor these through rtnetlink and it makes little sense to log
address changes through ioctl but not changes through rtnetlink. Moreover,
this tun_debug() is called even if the actual address change fails which
makes it even less useful.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/tun.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 59290ef07497..15ae2050ab5b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -473,8 +473,6 @@ static void tun_flow_cleanup(struct timer_list *t)
 	unsigned long count = 0;
 	int i;
 
-	tun_debug(KERN_INFO, tun, "tun_flow_cleanup\n");
-
 	spin_lock(&tun->lock);
 	for (i = 0; i < TUN_NUM_FLOW_ENTRIES; i++) {
 		struct tun_flow_entry *e;
@@ -1420,8 +1418,6 @@ static __poll_t tun_chr_poll(struct file *file, poll_table *wait)
 
 	sk = tfile->socket.sk;
 
-	tun_debug(KERN_INFO, tun, "tun_chr_poll\n");
-
 	poll_wait(file, sk_sleep(sk), wait);
 
 	if (!ptr_ring_empty(&tfile->tx_ring))
@@ -2192,8 +2188,6 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
 	ssize_t ret;
 	int err;
 
-	tun_debug(KERN_INFO, tun, "tun_do_read\n");
-
 	if (!iov_iter_count(to)) {
 		tun_ptr_free(ptr);
 		return 0;
@@ -2838,8 +2832,6 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 	netif_carrier_on(tun->dev);
 
-	tun_debug(KERN_INFO, tun, "tun_set_iff\n");
-
 	/* Make sure persistent devices do not get stuck in
 	 * xoff state.
 	 */
@@ -2870,8 +2862,6 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 static void tun_get_iff(struct tun_struct *tun, struct ifreq *ifr)
 {
-	tun_debug(KERN_INFO, tun, "tun_get_iff\n");
-
 	strcpy(ifr->ifr_name, tun->dev->name);
 
 	ifr->ifr_flags = tun_flags(tun);
@@ -3206,9 +3196,6 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 
 	case SIOCSIFHWADDR:
 		/* Set hw address */
-		tun_debug(KERN_DEBUG, tun, "set hw address: %pM\n",
-			  ifr.ifr_hwaddr.sa_data);
-
 		ret = dev_set_mac_address(tun->dev, &ifr.ifr_hwaddr, NULL);
 		break;
 
-- 
2.25.1

