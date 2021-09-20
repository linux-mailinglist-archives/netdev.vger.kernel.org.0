Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BF0411855
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhITPgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231953AbhITPgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 11:36:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9FF560F58;
        Mon, 20 Sep 2021 15:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632152097;
        bh=m96GjiApW4p/KxA61hjTobtxuW+MVptKA8i0ZuexASg=;
        h=From:To:Cc:Subject:Date:From;
        b=TDSQlhEroh4a2XiVC1gaXP0aR1mYssZAewrXs98Mx3jzEPslBI6FbBleb0l3KfpSk
         NP946HTLQPa05uOG05waAuuyDWmIdAjSPB0meGD1CwFrWW204q1RpLySsMJovz8b9e
         SrC4k1JUSKdqnaMWevrfqPwvhXW1yfon5tkADSzFx9B4vsUHpokxxQqPZCZnhivknq
         p4yWU5fqU5uGfnGRKo+RVSqpg8o5MTsEoO80CmO5aqeeehFLXaaHVvo/yztyJczrOO
         UpTcQqjRzOAENbQ8S3Rxvg4b/awgOSeRTEP1OMdop9VS7UEXO18vSmn/kX8TmDEbQ/
         KihasuvfWuQrA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pshelar@ovn.org,
        dsahern@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, ltomasbo@redhat.com, echaudro@redhat.com
Subject: [PATCH net-next] openvswitch: allow linking a VRF to an OVS bridge
Date:   Mon, 20 Sep 2021 17:34:54 +0200
Message-Id: <20210920153454.433252-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VRF devices are prevented from being added to upper devices since commit
1017e0987117 ("vrf: prevent adding upper devices") as they set the
IFF_NO_RX_HANDLER flag. However attaching a VRF to an OVS bridge is a
valid use case[1].

Allow a VRF device to be attached to an OVS bridge by having an OVS
specific tweak. This approach allows not to change a valid logic
elsewhere and the IFF_NO_RX_HANDLER limitation still applies for non-OVS
upper devices, even after a VRF was unlinked from an OVS bridge.

(Patch not sent as a fix as the commit introducing the limitation is not
recent).

[1] https://ltomasbo.wordpress.com/2021/06/25/openstack-networking-with-evpn/

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---

Hi all,

I thought about other ways to fix this but did not want to add yet
another flag, nor to add specific logic outside of net/openvswitch/. A
custom netdev_rx_handler_register having priv_flags as a parameter could
also have been added, but again that seemed a bit invasive.

There might be questions about the setup in which a VRF is linked to an
OVS bridge; I cc'ed Luis Tomás who wrote the article.

Thanks,
Antoine

 net/openvswitch/vport-netdev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/openvswitch/vport-netdev.c b/net/openvswitch/vport-netdev.c
index 8e1a88f13622..e76b2477d384 100644
--- a/net/openvswitch/vport-netdev.c
+++ b/net/openvswitch/vport-netdev.c
@@ -75,6 +75,7 @@ static struct net_device *get_dpdev(const struct datapath *dp)
 
 struct vport *ovs_netdev_link(struct vport *vport, const char *name)
 {
+	unsigned int saved_flags;
 	int err;
 
 	vport->dev = dev_get_by_name(ovs_dp_get_net(vport->dp), name);
@@ -98,8 +99,17 @@ struct vport *ovs_netdev_link(struct vport *vport, const char *name)
 	if (err)
 		goto error_unlock;
 
+	/* While IFF_NO_RX_HANDLER is rightly set for l3 masters (VRF) as they
+	 * don't work with upper devices, they can be attached to OVS bridges.
+	 */
+	saved_flags = vport->dev->priv_flags;
+	if (netif_is_l3_master(vport->dev))
+		vport->dev->priv_flags &= ~IFF_NO_RX_HANDLER;
+
 	err = netdev_rx_handler_register(vport->dev, netdev_frame_hook,
 					 vport);
+	vport->dev->priv_flags = saved_flags;
+
 	if (err)
 		goto error_master_upper_dev_unlink;
 
-- 
2.31.1

