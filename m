Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FD72EC541
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 21:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbhAFUlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 15:41:21 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:31570 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbhAFUlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 15:41:20 -0500
Date:   Wed, 06 Jan 2021 20:40:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1609965638; bh=VeALibfQe4iazgZFIJD/vfdV5BE9bJBaSBq4Sr4e3Ss=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=NZDOUYJFmgCYadtfcfwenuX+FyotOLU7RXjXD7lCNsEilqrCWaGBL2HlF2Tz8V6Fo
         GKi+nVoQ+pmGnJcRcdnRcawVZlzJTecaJWD4fj31o1BKfymN/Zsm3z/F6WHMHjoSpb
         XFlZF2fvpmnjei6G0CSMUsCe6ZlIydaITvVSg9lChWxZCZ5+t+wy+YLHVXTprefgF6
         d2ydKsQMpesC77Z5k7SfAmpKY7eBik7jQXaCyBruiL/LFE4wbtYvK1uU+qcSXBErC2
         DlbPpAoek0MH2jNaF86lBXcUxUz+Zr2K4pOch9VsN6drXVAWwXU6JN+OgCDxl61Thq
         M8XBUHEgrlgRA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next] net: sysctl: cleanup net_sysctl_init()
Message-ID: <20210106204014.34730-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'net_header' is not used outside of this function, so can be moved
from BSS onto the stack.
Declarations of one-element arrays are discouraged, and there's no
need to store 'empty' in BSS. Simply allocate it from heap at init.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/sysctl_net.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index d14dab8b6774..4cf81800a907 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -92,27 +92,34 @@ static struct pernet_operations sysctl_pernet_ops =3D {
 =09.exit =3D sysctl_net_exit,
 };
=20
-static struct ctl_table_header *net_header;
 __init int net_sysctl_init(void)
 {
-=09static struct ctl_table empty[1];
+=09struct ctl_table_header *net_header;
+=09struct ctl_table *empty;
 =09int ret =3D -ENOMEM;
+
 =09/* Avoid limitations in the sysctl implementation by
 =09 * registering "/proc/sys/net" as an empty directory not in a
 =09 * network namespace.
 =09 */
+
+=09empty =3D kzalloc(sizeof(*empty), GFP_KERNEL);
+=09if (!empty)
+=09=09return ret;
+
 =09net_header =3D register_sysctl("net", empty);
 =09if (!net_header)
-=09=09goto out;
+=09=09goto err_free;
+
 =09ret =3D register_pernet_subsys(&sysctl_pernet_ops);
-=09if (ret)
-=09=09goto out1;
-out:
-=09return ret;
-out1:
+=09if (!ret)
+=09=09return 0;
+
 =09unregister_sysctl_table(net_header);
-=09net_header =3D NULL;
-=09goto out;
+err_free:
+=09kfree(empty);
+
+=09return ret;
 }
=20
 struct ctl_table_header *register_net_sysctl(struct net *net,
--=20
2.30.0


