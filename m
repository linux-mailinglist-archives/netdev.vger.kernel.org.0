Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B01188AA8
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 12:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfHJKSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 06:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbfHJKSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 06:18:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E94E120B7C;
        Sat, 10 Aug 2019 10:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565432301;
        bh=I0RZLkp1YWdBHzfdokh+5YKBKnlBGlgiB6XeKkEvTdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwa7kTXApyMysdriSDVjaCiqFWwKF6Fovl/kYqpOWKcIV/9nonptbZxWnf6qtgCDU
         rTcS/Zn1+kmCQzdhylJtdEcCYKGhKYoG7mPA1V6hAm0mz3Gp4Dtdf5slk5+kShwfXE
         FGS0Xib6RL+SorTRJ2vj4sZI6nBgoRE1efjTxJtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Edwin Peer <edwin.peer@netronome.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH v3 08/17] nfp: no need to check return value of debugfs_create functions
Date:   Sat, 10 Aug 2019 12:17:23 +0200
Message-Id: <20190810101732.26612-9-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190810101732.26612-1-gregkh@linuxfoundation.org>
References: <20190810101732.26612-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Edwin Peer <edwin.peer@netronome.com>
Cc: Yangtao Li <tiny.windzz@gmail.com>
Cc: Simon Horman <simon.horman@netronome.com>
Cc: oss-drivers@netronome.com
Cc: netdev@vger.kernel.org
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../ethernet/netronome/nfp/nfp_net_debugfs.c    | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
index ab7f2498e1c4..553c708694e8 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
@@ -159,19 +159,13 @@ void nfp_net_debugfs_vnic_add(struct nfp_net *nn, struct dentry *ddir)
 	else
 		strcpy(name, "ctrl-vnic");
 	nn->debugfs_dir = debugfs_create_dir(name, ddir);
-	if (IS_ERR_OR_NULL(nn->debugfs_dir))
-		return;
 
 	/* Create queue debugging sub-tree */
 	queues = debugfs_create_dir("queue", nn->debugfs_dir);
-	if (IS_ERR_OR_NULL(queues))
-		return;
 
 	rx = debugfs_create_dir("rx", queues);
 	tx = debugfs_create_dir("tx", queues);
 	xdp = debugfs_create_dir("xdp", queues);
-	if (IS_ERR_OR_NULL(rx) || IS_ERR_OR_NULL(tx) || IS_ERR_OR_NULL(xdp))
-		return;
 
 	for (i = 0; i < min(nn->max_rx_rings, nn->max_r_vecs); i++) {
 		sprintf(name, "%d", i);
@@ -190,16 +184,7 @@ void nfp_net_debugfs_vnic_add(struct nfp_net *nn, struct dentry *ddir)
 
 struct dentry *nfp_net_debugfs_device_add(struct pci_dev *pdev)
 {
-	struct dentry *dev_dir;
-
-	if (IS_ERR_OR_NULL(nfp_dir))
-		return NULL;
-
-	dev_dir = debugfs_create_dir(pci_name(pdev), nfp_dir);
-	if (IS_ERR_OR_NULL(dev_dir))
-		return NULL;
-
-	return dev_dir;
+	return debugfs_create_dir(pci_name(pdev), nfp_dir);
 }
 
 void nfp_net_debugfs_dir_clean(struct dentry **dir)
-- 
2.22.0

