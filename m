Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578411BD944
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgD2KPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgD2KP3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 06:15:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA352073E;
        Wed, 29 Apr 2020 10:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588155328;
        bh=ht/RoPskfTVr50a64BfSKdDc9vFE86ERaFW3HHWbVdA=;
        h=Date:From:To:Cc:Subject:From;
        b=qjOWnsNWeBaR8nYC/F3eomgVHNfVcaZKrMfLqp3Hwj1U2lw3UBXNJHbzyaRLF6+ru
         Xm3ZIZEXoU2g3imzWKnY3Efv30demididNCxRwGFhvYtlYDSvJylUYeXptloGDL9MX
         yeiUUPvuVdpYGQc0y8ZNHu54kLnN6HmeuOYSP/lI=
Date:   Wed, 29 Apr 2020 12:15:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: no need to check return value of debugfs_create
 functions
Message-ID: <20200429101526.GA2094124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

In doing this, make brcmf_debugfs_add_entry() return void as no one was
even paying attention to the return value.

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafał Miłecki" <rafal@milecki.pl>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/debug.c |  9 +++------
 .../net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 12 +++++-------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
index 120515fe8250..eecf8a38d94a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
@@ -47,13 +47,10 @@ struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr)
 	return drvr->wiphy->debugfsdir;
 }
 
-int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
+void brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 			    int (*read_fn)(struct seq_file *seq, void *data))
 {
-	struct dentry *e;
-
 	WARN(!drvr->wiphy->debugfsdir, "wiphy not (yet) registered\n");
-	e = debugfs_create_devm_seqfile(drvr->bus_if->dev, fn,
-					drvr->wiphy->debugfsdir, read_fn);
-	return PTR_ERR_OR_ZERO(e);
+	debugfs_create_devm_seqfile(drvr->bus_if->dev, fn,
+				    drvr->wiphy->debugfsdir, read_fn);
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 9b221b509ade..4146faeed344 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -116,8 +116,8 @@ struct brcmf_bus;
 struct brcmf_pub;
 #ifdef DEBUG
 struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr);
-int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
-			    int (*read_fn)(struct seq_file *seq, void *data));
+void brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
+			     int (*read_fn)(struct seq_file *seq, void *data));
 int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
 			       size_t len);
 #else
@@ -126,11 +126,9 @@ static inline struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr)
 	return ERR_PTR(-ENOENT);
 }
 static inline
-int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
-			    int (*read_fn)(struct seq_file *seq, void *data))
-{
-	return 0;
-}
+void brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
+			     int (*read_fn)(struct seq_file *seq, void *data))
+{ }
 static inline
 int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
 			       size_t len)
-- 
2.26.2

