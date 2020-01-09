Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D28F213579F
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 12:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgAILIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 06:08:15 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24121 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728635AbgAILIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 06:08:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578568094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YrHYOyRs6hoyDkOjYUzoqFP4GilVsBwh6oetNdV0tBI=;
        b=fADj1EBZxCPXgB0E8T+zFOdkJtx5g0eukVZv1jh22BY2PDnUDFrc2mfIzUbVEOU5e1wT6B
        4zqk2dp6GJTkSwHV64C+vD/yYNiUuS6Tn5WWYInaUyMTqwrXwRzwqk1GADcIha0lLQyulv
        iZMasok89MSRVuivbiQILBVd2U3n03g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-nroMf2vpPCGV7xPo08JRmQ-1; Thu, 09 Jan 2020 06:08:10 -0500
X-MC-Unique: nroMf2vpPCGV7xPo08JRmQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C84DF801E6C;
        Thu,  9 Jan 2020 11:08:09 +0000 (UTC)
Received: from wlan-180-229.mxp.redhat.com (wlan-180-229.mxp.redhat.com [10.32.180.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E42111001B28;
        Thu,  9 Jan 2020 11:08:08 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next] net/mlx5e: allow TSO on VXLAN over VLAN topologies
Date:   Thu,  9 Jan 2020 12:07:59 +0100
Message-Id: <c1f4cc6214c28ce9a39147db9f3b66927dbae612.1578567988.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

since mlx5 hardware can segment correctly TSO packets on VXLAN over VLAN
topologies, CPU usage can improve significantly if we enable tunnel
offloads in dev->vlan_features, like it was done in the past with other
NIC drivers (e.g. mlx4, be2net and ixgbe).

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
index 78737fd42616..87267c18ff8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4878,6 +4878,8 @@ static void mlx5e_build_nic_netdev(struct net_devic=
e *netdev)
 		netdev->hw_enc_features |=3D NETIF_F_GSO_UDP_TUNNEL |
 					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		netdev->gso_partial_features =3D NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->vlan_features |=3D NETIF_F_GSO_UDP_TUNNEL |
+					 NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
=20
 	if (mlx5e_tunnel_proto_supported(mdev, IPPROTO_GRE)) {
--=20
2.24.1

