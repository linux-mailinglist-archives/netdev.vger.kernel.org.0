Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDCD6B19E
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388237AbfGPWL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:11:29 -0400
Received: from mx.paulo.ac ([212.47.230.6]:38830 "EHLO mx.paulo.ac"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbfGPWL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 18:11:29 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jul 2019 18:11:28 EDT
From:   "Paulo Alcantara (SUSE)" <paulo@paulo.ac>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paulo.ac; s=dkim;
        t=1563314708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ictppub2W6BvEyEBopdH3SZbJ5aGmAVfnP2JIdC5ziw=;
        b=RRK9oiUyWgvvZ/IptYF9PLQ1xizKsYLrwKwdM/sLiJ4LwBHd8XofxhGldej303oKtXQQfe
        k8KBbOd7blWlT7ev+0JFnmuIPc2NCVh+2YqSjvGYzJ1qZjulFlwCHa4W9mbjNTpPrbacQg
        FH/hyTm+f935hk/0BrGf3jt8tGxIcqfL7FJxurplRQBjDE9E40G+Oy8jz81+Ylhs1nP8SK
        l52OjYtJ6OCWYDbmg7yjWkE1q6w3kUU2DQjLXE3L3VcRw0G+0nS8To0SSKU7NVojW4DFW1
        HXAM1aAspoZg0OGq6Mj9udcjc1mkQIsyOT5bJc3jpzo27lZ3/bE3p4ITSWaMdA==
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc:     "Paulo Alcantara (SUSE)" <paulo@paulo.ac>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH 3/3] ipconfig: Handle CONFIG_CIFS_ROOT option
Date:   Tue, 16 Jul 2019 19:04:52 -0300
Message-Id: <20190716220452.3382-3-paulo@paulo.ac>
In-Reply-To: <20190716220452.3382-1-paulo@paulo.ac>
References: <20190716220452.3382-1-paulo@paulo.ac>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=paulo.ac;
        s=dkim; t=1563314708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ictppub2W6BvEyEBopdH3SZbJ5aGmAVfnP2JIdC5ziw=;
        b=bLKUuVJo6GT8idBQcj0ehE0y7QFPEkaxkOZ0kwllhiWtA7HnpAo6lhnfnIcsPHf9TCbrAj
        eDtQ3NuIYaKC/+nGDEjqy0T26HuGz/9dbFhkZfh09aswnTe/kxG5C5KwEDVoZsUjFqAMFb
        K2Jtpq5NBFn6uda5ipXFtrA2+LJHbK6U5rnfjdeAbzW5pWoVJdL9zfENlkhbdexDNqL5h+
        Q+N7TGVouFj2LvXed/7yxAzGtwhTMM4y68ZM0vG/fc7F20DYgDbL2Gl3dcZP72jA8hl5O8
        MIsqaa4PuyCZ+zfvXIUvQlNrivQxH8wHqUz2vojcM51dKgxtZaHtCLYzf5ZDOA==
ARC-Seal: i=1; s=dkim; d=paulo.ac; t=1563314708; a=rsa-sha256; cv=none;
        b=Hd94DInN7pquLG+VckLfeKAMelmvmcLpX9PDLQ3GvfpZmvF5CesyE37/jRjVhp+Z0oc40p
        Fj75WuMwybyNgTVmnXil68dC7naIkejRtge+yaeg7WeGbbkraPbOsh0YT3myBsQIdfz/Wj
        kLpOPj6CWf9Fhypsv/cl3rCjWzXY+JGTEZau2fDKxq1OvKl0yvqCNUIKgp6YxXdCboewIu
        zMaMxBvsYiDztIV8J7fzpLUdYBPjBpAZdAl7uQG2vQ3yTqBky92T+bDKOrK9Enc/iFkzED
        67ehmAvO2elJPA++R9Hbty8hBGa6J2W8d99nPqI28oJboQSzIXqL6Up6nBv9Mw==
ARC-Authentication-Results: i=1;
        mx.paulo.ac;
        auth=pass smtp.auth=paulo smtp.mailfrom=paulo@paulo.ac
Authentication-Results: mx.paulo.ac;
        auth=pass smtp.auth=paulo smtp.mailfrom=paulo@paulo.ac
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
Signed-off-by: Paulo Alcantara (SUSE) <paulo@paulo.ac>
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
2.22.0

