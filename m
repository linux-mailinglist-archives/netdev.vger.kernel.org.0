Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3724D49F0A5
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 02:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345095AbiA1Bnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 20:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345127AbiA1Bnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 20:43:40 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC87FC061747
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 17:43:39 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id u15so7982585wrt.3
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 17:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HPxukaaI+vBZceFwqPaqWSmknWB3EkzjOCzqNJeXZ6Y=;
        b=MbuglyhJzGr5zJbIDXKc1BRjn3+qunjZnSYcTrv9Y93j/BhlkTmeMI9YN/xuwQluMO
         VFSAhXFpENEXV8xKXKKrhCgsDt6ftUgtrjnTjQvmGQF59bmZWfhX31I7JPL9MM0uU/MP
         ncHf5Hb/wgD7HKpM3FbEmCtqLYNUcUqpuJdGgeh51wP3umNBfITNpSI98FgOGsX+z5GR
         McRsCzkVlCTPhX9o2q6WkHwAWfoIKJkoBtjEjQge3Duo4a16aIvfcoCymTbfrbOn++g0
         efGKbnRNJkC7PcVDpVzufyMC1vvFJtrJoWLXxqcyZPPsqex9e47UCIDsz8mCBF/Tgucp
         hokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HPxukaaI+vBZceFwqPaqWSmknWB3EkzjOCzqNJeXZ6Y=;
        b=HL8W1wLKX6NH4VoXRtddkovzAU5B7Y9sPWKrTnMAPCVlmGv9RXbvuGlsEXoMy6blzx
         0xLF9oWXXusNKH8sm0wNT3AASPwgE3oABHyFNeV2P7er30UM4su7MBzEolysIxVewFF/
         gT6lMg0PDZcHmYdd9UH35zlT8F3upSsF0n2s0j54HO5YHXdr9rB+KT1/X1XqWayJ7pPP
         TGue+0b0Vi/sYOnQYKY11tZRB1c9YzOo/wfaSzZ4wOr1KJEigKnnGMNKqk98ttbmLhD/
         OgTVTmOkAwWv+CNr+WLsjxdSG6MNDaPjHpEbUaxCBaKrt5GWyzzKdC9jlRKhnioHjoK4
         RJdA==
X-Gm-Message-State: AOAM532HaJjMD7gxf4jlTv2bXBSmBU217tliMMaaHEwVY0pGTU1W2iNA
        ON3P5PHmZUqmhBnLETZSrsORAw==
X-Google-Smtp-Source: ABdhPJx4aLp51dgoa/rTPnzaY8XZzRPLihFZM2WxONP9GdXAXygo9Fr2IIFDjQWSLbuDb3/2MB9JfA==
X-Received: by 2002:a05:6000:1884:: with SMTP id a4mr5074731wri.165.1643334218107;
        Thu, 27 Jan 2022 17:43:38 -0800 (PST)
Received: from localhost ([2a02:168:96c5:1:55ed:514f:6ad7:5bcc])
        by smtp.gmail.com with ESMTPSA id 14sm4428247wrz.100.2022.01.27.17.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 17:43:37 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jann Horn <jannh@google.com>
Subject: [PATCH net] net: dev: Detect dev_hold() after netdev_wait_allrefs()
Date:   Fri, 28 Jan 2022 02:43:03 +0100
Message-Id: <20220128014303.2334568-1-jannh@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've run into a bug where dev_hold() was being called after
netdev_wait_allrefs(). But at that point, the device is already going
away, and dev_hold() can't stop that anymore.

To make such problems easier to diagnose in the future:

 - For CONFIG_PCPU_DEV_REFCNT builds: Recheck in free_netdev() whether
   the net refcount has been elevated. If this is detected, WARN() and
   leak the object (to prevent worse consequences from a
   use-after-free).
 - For builds without CONFIG_PCPU_DEV_REFCNT: Set the refcount to zero.
   This signals to the generic refcount infrastructure that any attempt
   to increment the refcount later is a bug.

Signed-off-by: Jann Horn <jannh@google.com>
---
 net/core/dev.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1baab07820f6..f7916c0d226d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9949,8 +9949,18 @@ void netdev_run_todo(void)
=20
 		netdev_wait_allrefs(dev);
=20
+		/* Drop the netdev refcount (which should be 1 at this point)
+		 * to zero. If we're using the generic refcount code, this will
+		 * tell it that any dev_hold() after this point is a bug.
+		 */
+#ifdef CONFIG_PCPU_DEV_REFCNT
+		this_cpu_dec(*dev->pcpu_refcnt);
+		BUG_ON(netdev_refcnt_read(dev) !=3D 0);
+#else
+		BUG_ON(!refcount_dec_and_test(&dev->dev_refcnt));
+#endif
+
 		/* paranoia */
-		BUG_ON(netdev_refcnt_read(dev) !=3D 1);
 		BUG_ON(!list_empty(&dev->ptype_all));
 		BUG_ON(!list_empty(&dev->ptype_specific));
 		WARN_ON(rcu_access_pointer(dev->ip_ptr));
@@ -10293,6 +10303,12 @@ void free_netdev(struct net_device *dev)
 	free_percpu(dev->xdp_bulkq);
 	dev->xdp_bulkq =3D NULL;
=20
+	/* Recheck in case someone called dev_hold() between
+	 * netdev_wait_allrefs() and here.
+	 */
+	if (WARN_ON(netdev_refcnt_read(dev) !=3D 0))
+		return; /* leak memory, otherwise we might get UAF */
+
 	/*  Compatibility with error handling in drivers */
 	if (dev->reg_state =3D=3D NETREG_UNINITIALIZED) {
 		netdev_freemem(dev);

base-commit: 23a46422c56144939c091c76cf389aa863ce9c18
--=20
2.35.0.rc0.227.g00780c9af4-goog

