Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327F75BB4CD
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 01:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiIPXqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 19:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiIPXqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 19:46:11 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1619EB9595
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 16:46:10 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-349cf83cfc7so76108107b3.5
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 16:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date;
        bh=GO0jN+Z0673O66mqqI4GMmYzrpchW4f/N0CMeqqypuw=;
        b=iCI+mjWdsf2HT/LfAvecWGLouCJmg8BtDYecZfjxH6yerNOv7lDhfV1j1dP34T7UaR
         K3rjxaX0sGcAU5pqw9OaYXDHHTeNreL0FF78fIFHy69XO7z2iegpC/qcz80wrHVGUqy0
         qB+lpkg4gJD8rZSdFt1EWiNlSEVn0S6tBPjX4XPxq2AAT/wgRisi5AbEK/Zj/Ud+5eSz
         FIXKsgnAXcebk4RiNEbeTSd9kL8mqmxQ87cSz5XQz+vyIZVSYTY5HG5Jptr64lo0KesZ
         tH1lfpNcXILtwTvPInrBax4T1nO6qJLkTbV77tww1u3Qb0u7Nkig3ZcQwkH54Xerdhmh
         U/mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date;
        bh=GO0jN+Z0673O66mqqI4GMmYzrpchW4f/N0CMeqqypuw=;
        b=uve3geAZMWx5EiA3syBsWO8KSYdbC+PN4WeL7pkvIXLPa5AEzerB0gO45YKFFrYdMd
         g9StP61AJyv3iVkH3jy+qoUBePlSbIRzYsrBGab6ABm2yZnHff2cvpdIL1Pte0PyhJV7
         NkFHA+dQDLC8FhkPrbaTrhq/24tAciFTsNOFaVSxb4o9MraR/paCME6pPBjch/+T6RW3
         WxkgHRMViqKNW9cylqZXb79Qb6RC/ZA5b0lKs/AYbEnPG6Hu2toHRIwkpcoV7MwZFxw3
         NEd0PW0UZpdgf7Vy9DNCYJMg++1NRZjJ+O4LTxMIt9eS9T8jeZ0scWVCCMiWpQ6RvK0b
         yYBw==
X-Gm-Message-State: ACrzQf01vqWXQpIo9gBCGpYrNZgSG3m8G+NOdmPLJSjFUpGJeX2gXmFi
        dnrK3eJ3EuEZ7UeK0XcMeyLEVXsiOQ==
X-Google-Smtp-Source: AMsMyM7fipnazvgrkciOEXlhnQfBCbxmnQG9Ledvy2oyKT85yTeKQEu7RUrrbcJRGNpvFBI2pj5jJGpIpw==
X-Received: from prohr-desktop.mtv.corp.google.com ([2620:15c:211:200:1dda:ee83:4f58:e5b7])
 (user=prohr job=sendgmr) by 2002:a05:6902:2d0:b0:694:d257:4c4b with SMTP id
 w16-20020a05690202d000b00694d2574c4bmr6284081ybh.316.1663371969388; Fri, 16
 Sep 2022 16:46:09 -0700 (PDT)
Date:   Fri, 16 Sep 2022 16:45:52 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220916234552.3388360-1-prohr@google.com>
Subject: [PATCH] tun: support not enabling carrier in TUNSETIFF
From:   Patrick Rohr <prohr@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Patrick Rohr <prohr@google.com>,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds support for not enabling carrier during TUNSETIFF
interface creation by specifying the IFF_NO_CARRIER flag.

Our tests make heavy use of tun interfaces. In some scenarios, the test
process creates the interface but another process brings it up after the
interface is discovered via netlink notification. In that case, it is
not possible to create a tun/tap interface with carrier off without it
racing against the bring up. Immediately setting carrier off via
TUNSETCARRIER is still too late.

Since ifr_flags is only a short, the value for IFF_DETACH_QUEUE is
reused for IFF_NO_CARRIER. IFF_DETACH_QUEUE has currently no meaning in
TUNSETIFF.

Signed-off-by: Patrick Rohr <prohr@google.com>
Cc: Maciej =C5=BBenczykowski <maze@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Jason Wang <jasowang@redhat.com>
---
 drivers/net/tun.c           | 15 ++++++++++++---
 include/uapi/linux/if_tun.h |  2 ++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 259b2b84b2b3..502f56095650 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2709,6 +2709,12 @@ static int tun_set_iff(struct net *net, struct file =
*file, struct ifreq *ifr)
 	struct net_device *dev;
 	int err;
=20
+	/* Do not save the IFF_NO_CARRIER flag as it uses the same value as
+	 * IFF_DETACH_QUEUE.
+	 */
+	bool no_carrier =3D ifr->ifr_flags & IFF_NO_CARRIER;
+	ifr->ifr_flags &=3D ~IFF_NO_CARRIER;
+
 	if (tfile->detached)
 		return -EINVAL;
=20
@@ -2828,7 +2834,10 @@ static int tun_set_iff(struct net *net, struct file =
*file, struct ifreq *ifr)
 		rcu_assign_pointer(tfile->tun, tun);
 	}
=20
-	netif_carrier_on(tun->dev);
+	if (no_carrier)
+		netif_carrier_off(tun->dev);
+	else
+		netif_carrier_on(tun->dev);
=20
 	/* Make sure persistent devices do not get stuck in
 	 * xoff state.
@@ -3056,8 +3065,8 @@ static long __tun_chr_ioctl(struct file *file, unsign=
ed int cmd,
 		 * This is needed because we never checked for invalid flags on
 		 * TUNSETIFF.
 		 */
-		return put_user(IFF_TUN | IFF_TAP | TUN_FEATURES,
-				(unsigned int __user*)argp);
+		return put_user(IFF_TUN | IFF_TAP | IFF_NO_CARRIER |
+				TUN_FEATURES, (unsigned int __user*)argp);
 	} else if (cmd =3D=3D TUNSETQUEUE) {
 		return tun_set_queue(file, &ifr);
 	} else if (cmd =3D=3D SIOCGSKNS) {
diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index 2ec07de1d73b..12dde91957a5 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -75,6 +75,8 @@
 #define IFF_MULTI_QUEUE 0x0100
 #define IFF_ATTACH_QUEUE 0x0200
 #define IFF_DETACH_QUEUE 0x0400
+/* Used in TUNSETIFF to bring up tun/tap without carrier */
+#define IFF_NO_CARRIER IFF_DETACH_QUEUE
 /* read-only flag */
 #define IFF_PERSIST	0x0800
 #define IFF_NOFILTER	0x1000
--=20
2.37.3.968.ga6b4b080e4-goog

