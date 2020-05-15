Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80BE1D5A5A
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgEOTtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:49:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgEOTtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 15:49:09 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA137207D0;
        Fri, 15 May 2020 19:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589572149;
        bh=h9QDG3/okL5d4UBary0bQF5r0+VjrI9uAFF/qDfaHgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aW0VGf5NcFdSXJ76OFwlwnq3pLXIfh5Zleec6gnSOrsCmTl/h/VFijPTLNVfK/V7z
         6SBRo4DhVvIZIu9jkwu7m5ujhb68xnyzCMIU7VhYlVzK/+5L8+v7FhGVNRlqb67d4+
         E0awJ+csMYgj2S/LMmjAt3/XqFVFN6RDmQrcdqTg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        simon.horman@netronome.com, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/3] ethtool: don't call set_channels in drivers if config didn't change
Date:   Fri, 15 May 2020 12:49:02 -0700
Message-Id: <20200515194902.3103469-4-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515194902.3103469-1-kuba@kernel.org>
References: <20200515194902.3103469-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't call drivers if nothing changed. Netlink code already
contains this logic.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index a574d60111fa..eeb1137a3f23 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1669,6 +1669,12 @@ static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
 
 	dev->ethtool_ops->get_channels(dev, &curr);
 
+	if (channels.rx_count == curr.rx_count &&
+	    channels.tx_count == curr.tx_count &&
+	    channels.combined_count == curr.combined_count &&
+	    channels.other_count == curr.other_count)
+		return 0;
+
 	/* ensure new counts are within the maximums */
 	if (channels.rx_count > curr.max_rx ||
 	    channels.tx_count > curr.max_tx ||
-- 
2.25.4

