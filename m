Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F307DB7E32
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 17:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391274AbfISPbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 11:31:17 -0400
Received: from mx.cjr.nz ([51.158.111.142]:37448 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391255AbfISPbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 11:31:16 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 616EC810F3;
        Thu, 19 Sep 2019 15:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1568906486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=35pe9kkxdC7EjCrreNNnD39E8uLZQzbEg7Hs3HWa184=;
        b=cOJRl1mYDRbcAWsieqLPyrwnn1ZcKgG6d5fS52/HuBgJd0VRUQXW6bYEEOAlCQuHfBKirN
        DMK7n5lIQDe3t5EW5Zi+kDzqYKGwU67S5vOUhldnMRs7x3YmSDcsx2godYA3nR/DKxiQ1B
        m6OmbRih+3OzjdgGR+RlK2PPv59NdGUmiQhYNgwRBHcsUGdLwrBkqr2DalzXGwl9egdGvC
        M3ZwfiPlUO1KcCFptYQ/0wDLKVLchnDu2AJLO6AvTQ4hFIowHGs4Sm6D3NG0Fz5Bcpr1e9
        Bxb/t6aC+kEvL2Z0Pb6l7TxzJktjrOE7JxwKQ0nwVED1o3rCigDxjHKYQZBIig==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v2 3/3] ipconfig: Handle CONFIG_CIFS_ROOT option
Date:   Thu, 19 Sep 2019 12:21:16 -0300
Message-Id: <20190919152116.27076-3-pc@cjr.nz>
In-Reply-To: <20190919152116.27076-1-pc@cjr.nz>
References: <20190716220452.3382-1-paulo@paulo.ac>
 <20190919152116.27076-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz;
        s=dkim; t=1568906486; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=35pe9kkxdC7EjCrreNNnD39E8uLZQzbEg7Hs3HWa184=;
        b=ZUFwe3MHtU4uhVteniaWRxAZy5z6wahxyYYQpAdDmcw2cIQFVFjg7uS1UrsA7VJt7EJ+Xd
        d0sjpVt6ITnPuIvOMLX8CBU28eoD/Qdlw+z8TDvoKgAGt4sSQ60U4pCHzko1r2R1J/8q8x
        SjbSBjwUoYF+sbw88BZzCnxtk9XTkIqA0C/15rrx97/r/At10yWslDJpfa7kFtB1R9iKaE
        eLSTO9DHyykbYzr5W/tdufn1wQL/R1zRflqvnlIKlsXYYrAO34ck7va33bzTuNdIdoAYHg
        /Mmp0qwvtm6SRGHBx5cG8g2r+61OxNaIDhkp2Kt4ZyC5A+hm6uBJscAxneQs7g==
ARC-Seal: i=1; s=dkim; d=cjr.nz; t=1568906486; a=rsa-sha256; cv=none;
        b=TFv/T5Cvp+8RF2T+Ji1+0Y89OEIJVpfDIoKkCPzAny1cjLt0TLtFfSg6yP0xZXe7jNp+P2
        rLOHUXGGJv17o60IPze9azS/vlQLgHyOXwPGCWhqqIs4PpXQo1rW2oUarnmheQPMngdHlv
        qoMybQyKdEI5eSTvdOkwl+eiNOnIRACfClreP3c7beKBzk7X+U4ShjiHJQctVCf5Jb52Pp
        uZxWXJ2ZYQbtXeITTiHoH9J6AwOcLjYCAkS7xb96mtI2WovGeSRfEFs+IfCvMgQRwb/BWk
        WASoVRQ4UyxaZ8YUR6cCsbd4uZkLAN6yfiWiS6JAYJj8k4ZeRp4ovFOHTrhoIA==
ARC-Authentication-Results: i=1;
        mx.cjr.nz;
        auth=pass smtp.auth=pc smtp.mailfrom=pc@cjr.nz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The experimental root file system support in cifs.ko relies on
ipconfig to set up the network stack and then accessing the SMB share
that contains the rootfs files.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 net/ipv4/ipconfig.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 9bcca08efec9..32e20b758b68 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1483,10 +1483,10 @@ static int __init ip_auto_config(void)
 	 * missing values.
 	 */
 	if (ic_myaddr == NONE ||
-#ifdef CONFIG_ROOT_NFS
+#if defined(CONFIG_ROOT_NFS) || defined(CONFIG_CIFS_ROOT)
 	    (root_server_addr == NONE &&
 	     ic_servaddr == NONE &&
-	     ROOT_DEV == Root_NFS) ||
+	     (ROOT_DEV == Root_NFS || ROOT_DEV == Root_CIFS)) ||
 #endif
 	    ic_first_dev->next) {
 #ifdef IPCONFIG_DYNAMIC
@@ -1513,6 +1513,12 @@ static int __init ip_auto_config(void)
 				goto try_try_again;
 			}
 #endif
+#ifdef CONFIG_CIFS_ROOT
+			if (ROOT_DEV == Root_CIFS) {
+				pr_err("IP-Config: Retrying forever (CIFS root)...\n");
+				goto try_try_again;
+			}
+#endif
 
 			if (--retries) {
 				pr_err("IP-Config: Reopening network devices...\n");
-- 
2.23.0

