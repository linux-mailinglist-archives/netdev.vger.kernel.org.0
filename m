Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778ED1C643B
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 00:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgEEW7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 18:59:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59378 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729398AbgEEW7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 18:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588719559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k/AbVdWQcv/op6lCc5GakXsqxzuoe2d/8WuuTJkt0n0=;
        b=N7SRONBa6uTbEhlAxQpPvQxYBFI9zjXr4KdyX1H9rfV9MWA9Xby++kOpa9nKJBTs5GDGG8
        hwYK8I3i/TyKjCTloOG4BTsbbaekeFqopAzd5SiA8ShlliN1/rFaK/GWceOpZJumRC5BPW
        9UCgpGbFcqv3Syfe8ZWYM7ElIohgSHk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-JcohxBfON6aRQKLc6rqUlQ-1; Tue, 05 May 2020 18:59:18 -0400
X-MC-Unique: JcohxBfON6aRQKLc6rqUlQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 518B9835B8C;
        Tue,  5 May 2020 22:59:16 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 135CE5D9DA;
        Tue,  5 May 2020 22:59:14 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [RFC PATCH net-next v2 2/3] ixgbe_ipsec: become aware of when running as a bonding slave
Date:   Tue,  5 May 2020 18:58:37 -0400
Message-Id: <20200505225838.59505-3-jarod@redhat.com>
In-Reply-To: <20200505225838.59505-1-jarod@redhat.com>
References: <20200504145943.8841-1-jarod@redhat.com>
 <20200505225838.59505-1-jarod@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Slave devices in a bond doing hardware encryption also need to be aware
that they're slaves, so we operate on the slave instead of the bonding
master to do the actual hardware encryption offload bits.

CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: netdev@vger.kernel.org
CC: intel-wired-lan@lists.osuosl.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    | 39 +++++++++++++++----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net=
/ethernet/intel/ixgbe/ixgbe_ipsec.c
index 113f6087c7c9..26b0a58a064d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -432,6 +432,9 @@ static int ixgbe_ipsec_parse_proto_keys(struct xfrm_s=
tate *xs,
 	char *alg_name =3D NULL;
 	int key_len;
=20
+	if (xs->xso.slave_dev)
+		dev =3D xs->xso.slave_dev;
+
 	if (!xs->aead) {
 		netdev_err(dev, "Unsupported IPsec algorithm\n");
 		return -EINVAL;
@@ -478,8 +481,8 @@ static int ixgbe_ipsec_parse_proto_keys(struct xfrm_s=
tate *xs,
 static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_state *xs)
 {
 	struct net_device *dev =3D xs->xso.dev;
-	struct ixgbe_adapter *adapter =3D netdev_priv(dev);
-	struct ixgbe_hw *hw =3D &adapter->hw;
+	struct ixgbe_adapter *adapter;
+	struct ixgbe_hw *hw;
 	u32 mfval, manc, reg;
 	int num_filters =3D 4;
 	bool manc_ipv4;
@@ -497,6 +500,12 @@ static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_sta=
te *xs)
 #define BMCIP_V6                 0x3
 #define BMCIP_MASK               0x3
=20
+	if (xs->xso.slave_dev)
+		dev =3D xs->xso.slave_dev;
+
+	adapter =3D netdev_priv(dev);
+	hw =3D &adapter->hw;
+
 	manc =3D IXGBE_READ_REG(hw, IXGBE_MANC);
 	manc_ipv4 =3D !!(manc & MANC_EN_IPV4_FILTER);
 	mfval =3D IXGBE_READ_REG(hw, IXGBE_MFVAL);
@@ -561,14 +570,21 @@ static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_st=
ate *xs)
 static int ixgbe_ipsec_add_sa(struct xfrm_state *xs)
 {
 	struct net_device *dev =3D xs->xso.dev;
-	struct ixgbe_adapter *adapter =3D netdev_priv(dev);
-	struct ixgbe_ipsec *ipsec =3D adapter->ipsec;
-	struct ixgbe_hw *hw =3D &adapter->hw;
+	struct ixgbe_adapter *adapter;
+	struct ixgbe_ipsec *ipsec;
+	struct ixgbe_hw *hw;
 	int checked, match, first;
 	u16 sa_idx;
 	int ret;
 	int i;
=20
+	if (xs->xso.slave_dev)
+		dev =3D xs->xso.slave_dev;
+
+	adapter =3D netdev_priv(dev);
+	ipsec =3D adapter->ipsec;
+	hw =3D &adapter->hw;
+
 	if (xs->id.proto !=3D IPPROTO_ESP && xs->id.proto !=3D IPPROTO_AH) {
 		netdev_err(dev, "Unsupported protocol 0x%04x for ipsec offload\n",
 			   xs->id.proto);
@@ -746,12 +762,19 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs=
)
 static void ixgbe_ipsec_del_sa(struct xfrm_state *xs)
 {
 	struct net_device *dev =3D xs->xso.dev;
-	struct ixgbe_adapter *adapter =3D netdev_priv(dev);
-	struct ixgbe_ipsec *ipsec =3D adapter->ipsec;
-	struct ixgbe_hw *hw =3D &adapter->hw;
+	struct ixgbe_adapter *adapter;
+	struct ixgbe_ipsec *ipsec;
+	struct ixgbe_hw *hw;
 	u32 zerobuf[4] =3D {0, 0, 0, 0};
 	u16 sa_idx;
=20
+	if (xs->xso.slave_dev)
+		dev =3D xs->xso.slave_dev;
+
+	adapter =3D netdev_priv(dev);
+	ipsec =3D adapter->ipsec;
+	hw =3D &adapter->hw;
+
 	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
 		struct rx_sa *rsa;
 		u8 ipi;
--=20
2.20.1

