Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3641001D7
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 10:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfKRJzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 04:55:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47483 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726464AbfKRJzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 04:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574070909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WOGZL/jFzYko1lWw0mWE4IxrAOZ2FdbaifwrkkJol20=;
        b=buH339u6i6aYx2KH+OyzCQVi6SQknIrnsQhu73gN0cKQJ6XD76s/9OC0wI2PNV69RVppRU
        qPsJ91ZnyIOYWdQU2RAuKsEXjD7ipqcHZ/XQysJH4/IxvLdAYuIPICNHx5LvNMNk6vAaob
        f8Skd6NEFB7/BEZlPZQeRZdNdrIk0bM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-kVhGREHjPZ2a47PYWh4WdQ-1; Mon, 18 Nov 2019 04:55:06 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35F401802CE0;
        Mon, 18 Nov 2019 09:55:05 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-117-86.ams2.redhat.com [10.36.117.86])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CEB695E246;
        Mon, 18 Nov 2019 09:55:04 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 36BA2A80706; Mon, 18 Nov 2019 10:55:03 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com,
        David Miller <davem@davemloft.net>
Subject: [PATCH net-next] r8169: disable TSO on a single version of RTL8168c to fix performance
Date:   Mon, 18 Nov 2019 10:55:03 +0100
Message-Id: <20191118095503.25611-1-vinschen@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: kVhGREHjPZ2a47PYWh4WdQ-1
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
@@ -6952,8 +6952,12 @@ static int rtl_init_one(struct pci_dev *pdev, const =
struct pci_device_id *ent)
 =09=09dev->gso_max_segs =3D RTL_GSO_MAX_SEGS_V1;
 =09}
=20
-=09/* RTL8168e-vl has a HW issue with TSO */
-=09if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_34) {
+=09/*
+=09 * RTL8168e-vl and one RTL8168c variant are known to have a
+=09 * HW issue with TSO.
+=09 */
+=09if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_34 ||
+=09    tp->mac_version =3D=3D RTL_GIGA_MAC_VER_22) {
 =09=09dev->vlan_features &=3D ~(NETIF_F_ALL_TSO | NETIF_F_SG);
 =09=09dev->hw_features &=3D ~(NETIF_F_ALL_TSO | NETIF_F_SG);
 =09=09dev->features &=3D ~(NETIF_F_ALL_TSO | NETIF_F_SG);
--=20
2.20.1

