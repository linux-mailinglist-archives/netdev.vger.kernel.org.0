Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E184D51A9
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245533AbiCJSqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 13:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236161AbiCJSqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 13:46:10 -0500
X-Greylist: delayed 547 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Mar 2022 10:45:07 PST
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CF116E7D3;
        Thu, 10 Mar 2022 10:45:07 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C9AFE3EB76;
        Thu, 10 Mar 2022 19:35:50 +0100 (CET)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Johannes Berg <johannes.berg@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Remi Pommarel <repk@triplefau.lt>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Matthias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <ll@simonwunderlich.de>
Subject: [PATCH net] mac80211: fix potential double free on mesh join
Date:   Thu, 10 Mar 2022 19:35:13 +0100
Message-Id: <20220310183513.28589-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <ll@simonwunderlich.de>

While commit 6a01afcf8468 ("mac80211: mesh: Free ie data when leaving
mesh") fixed a memory leak on mesh leave / teardown it introduced a
potential memory corruption caused by a double free when rejoining the
mesh:

  ieee80211_leave_mesh()
  -> kfree(sdata->u.mesh.ie);
  ...
  ieee80211_join_mesh()
  -> copy_mesh_setup()
     -> old_ie = ifmsh->ie;
     -> kfree(old_ie);

This double free / kernel panics can be reproduced by using wpa_supplicant
with an encrypted mesh (if set up without encryption via "iw" then
ifmsh->ie is always NULL, which avoids this issue). And then calling:

  $ iw dev mesh0 mesh leave
  $ iw dev mesh0 mesh join my-mesh

Note that typically these commands are not used / working when using
wpa_supplicant. And it seems that wpa_supplicant or wpa_cli are going
through a NETDEV_DOWN/NETDEV_UP cycle between a mesh leave and mesh join
where the NETDEV_UP resets the mesh.ie to NULL via a memcpy of
default_mesh_setup in cfg80211_netdev_notifier_call, which then avoids
the memory corruption, too.

The issue was first observed in an application which was not using
wpa_supplicant but "Senf" instead, which implements its own calls to
nl80211.

Fixing the issue by removing the kfree()'ing of the mesh IE in the mesh
join function and leaving it solely up to the mesh leave to free the
mesh IE.

Link: https://gitlab.fit.fraunhofer.de/wiback/senf
Fixes: 6a01afcf8468 ("mac80211: mesh: Free ie data when leaving mesh")
Reported-by: Matthias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
---
 net/mac80211/cfg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 87a208089caf..58ff57dc669c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2148,14 +2148,12 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 		const struct mesh_setup *setup)
 {
 	u8 *new_ie;
-	const u8 *old_ie;
 	struct ieee80211_sub_if_data *sdata = container_of(ifmsh,
 					struct ieee80211_sub_if_data, u.mesh);
 	int i;
 
 	/* allocate information elements */
 	new_ie = NULL;
-	old_ie = ifmsh->ie;
 
 	if (setup->ie_len) {
 		new_ie = kmemdup(setup->ie, setup->ie_len,
@@ -2165,7 +2163,6 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	}
 	ifmsh->ie_len = setup->ie_len;
 	ifmsh->ie = new_ie;
-	kfree(old_ie);
 
 	/* now copy the rest of the setup parameters */
 	ifmsh->mesh_id_len = setup->mesh_id_len;
-- 
2.34.1

