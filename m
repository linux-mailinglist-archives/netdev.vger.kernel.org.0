Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341F9101F7D
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 10:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKSJJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 04:09:47 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59346 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725306AbfKSJJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 04:09:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574154585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qCbiJsyft8Uzb7RHSqVgxkyIbBx/LXqDr8Z1MoENKE4=;
        b=VLd8B5gXqq/RRh5gjoG382SJSRsjvahytLyQPJ5r8Hd6c00PXqJPNw47vC2veQrez6N6W6
        IaaXE21WW64RAaYpbvdPS0pKSIfwjY1G2xa762oEsdpdojr9PsVVZSQ8Naq+lhxE3zhKge
        Gq/tsnsEdLcZ23gZPPkXZibAklFeZzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-oewk__JROCuws-2rAD-Slw-1; Tue, 19 Nov 2019 04:09:42 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B3EE106B2AF;
        Tue, 19 Nov 2019 09:09:41 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-117-86.ams2.redhat.com [10.36.117.86])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F0A65DA60;
        Tue, 19 Nov 2019 09:09:41 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id B2486A80A4E; Tue, 19 Nov 2019 10:09:39 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com,
        David Miller <davem@davemloft.net>
Subject: [PATCH net] r8169: disable TSO on a single version of RTL8168c to fix performance
Date:   Tue, 19 Nov 2019 10:09:39 +0100
Message-Id: <20191119090939.29169-1-vinschen@redhat.com>
In-Reply-To: <44352432-e6ad-3e3c-4fea-9ad59f7c4ae9@gmail.com>
References: <44352432-e6ad-3e3c-4fea-9ad59f7c4ae9@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: oewk__JROCuws-2rAD-Slw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During performance testing, I found that one of my r8169 NICs suffered
a major performance loss, a 8168c model.

Running netperf's TCP_STREAM test didn't return the expected
throughput of > 900 Mb/s, but rather only about 22 Mb/s.  Strange
enough, running the TCP_MAERTS and UDP_STREAM tests all returned with
throughput > 900 Mb/s, as did TCP_STREAM with the other r8169 NICs I can
test (either one of 8169s, 8168e, 8168f).

Bisecting turned up commit 93681cd7d94f83903cb3f0f95433d10c28a7e9a5,
"r8169: enable HW csum and TSO" as the culprit.

I added my 8168c version, RTL_GIGA_MAC_VER_22, to the code
special-casing the 8168evl as per the patch below.  This fixed the
performance problem for me.

Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethern=
et/realtek/r8169_main.c
index d8fcdb9db8d1..1de11ac05bd6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6952,8 +6952,11 @@ static int rtl_init_one(struct pci_dev *pdev, const =
struct pci_device_id *ent)
 =09=09dev->gso_max_segs =3D RTL_GSO_MAX_SEGS_V1;
 =09}
=20
-=09/* RTL8168e-vl has a HW issue with TSO */
-=09if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_34) {
+=09/* RTL8168e-vl and one RTL8168c variant are known to have a
+=09 * HW issue with TSO.
+=09 */
+=09if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_34 ||
+=09    tp->mac_version =3D=3D RTL_GIGA_MAC_VER_22) {
 =09=09dev->vlan_features &=3D ~(NETIF_F_ALL_TSO | NETIF_F_SG);
 =09=09dev->hw_features &=3D ~(NETIF_F_ALL_TSO | NETIF_F_SG);
 =09=09dev->features &=3D ~(NETIF_F_ALL_TSO | NETIF_F_SG);
--=20
2.20.1

