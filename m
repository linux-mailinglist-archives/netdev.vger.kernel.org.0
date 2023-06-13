Return-Path: <netdev+bounces-10368-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E07E772E2A5
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A576B281232
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3355231EFD;
	Tue, 13 Jun 2023 12:16:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DDD3C25
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:16:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC25E5
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686658579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x8Lx4CZ5JkvZXj2FnosCsfWTRe7EkuTyWCnNqOWAfBA=;
	b=VmvH0LRS89OGt4LFqdGNaDhs2LUQ4xse2j8+Ze89ZXQ+N4pN5bQwKytIkttmeoG7AvIwcl
	JVVPVDYARzrQov+H+AWvL+Tad1Q4gZAjEJGc8twtO0OQv/0J+DxBjIL1oZ3BKeR4v/pJvV
	Z1WQaQyUbgrVi13EWk5LLvVDvaHy8AQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-699EPON0PX-PcHtYs6wIVg-1; Tue, 13 Jun 2023 08:16:15 -0400
X-MC-Unique: 699EPON0PX-PcHtYs6wIVg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEA25185A791;
	Tue, 13 Jun 2023 12:16:14 +0000 (UTC)
Received: from p1.luc.cera.cz (unknown [10.43.2.89])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 787251410F01;
	Tue, 13 Jun 2023 12:16:13 +0000 (UTC)
From: Ivan Vecera <ivecera@redhat.com>
To: netdev@vger.kernel.org
Cc: Ma Yuying <yuma@redhat.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/2] i40e: Wait for pending VF reset in VF set callbacks
Date: Tue, 13 Jun 2023 14:16:10 +0200
Message-Id: <20230613121610.137654-2-ivecera@redhat.com>
In-Reply-To: <20230613121610.137654-1-ivecera@redhat.com>
References: <20230613121610.137654-1-ivecera@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Commit 028daf80117376 ("i40e: Fix attach VF to VM issue") fixed
a race between i40e_ndo_set_vf_mac() and i40e_reset_vf() during
an attachment of VF device to VM. This issue is not related to
setting MAC address only but also VLAN assignment to particular
VF because the newer libvirt sets configured MAC address as well
as an optional VLAN. The same behavior is also for i40e's
.ndo_set_vf_rate and .ndo_set_vf_spoofchk where the callbacks
just check if the VF was initialized but not wait for the finish
of pending reset.

Reproducer:
[root@host ~]# virsh attach-interface guest hostdev --managed 0000:02:02.0 --mac 52:54:00:b4:aa:bb
error: Failed to attach interface
error: Cannot set interface MAC/vlanid to 52:54:00:b4:aa:bb/0 for ifname enp2s0f0 vf 0: Resource temporarily unavailable

Fix this issue by using i40e_check_vf_init_timeout() helper to check
whether a reset of particular VF was finished in i40e's
.ndo_set_vf_vlan, .ndo_set_vf_rate and .ndo_set_vf_spoofchk callbacks.

Tested-by: Ma Yuying <yuma@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 .../net/ethernet/intel/i40e/i40e_virtchnl_pf.c   | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index b84b6b675fa7..4741ba14ab27 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -4466,13 +4466,11 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 	}
 
 	vf = &pf->vf[vf_id];
-	vsi = pf->vsi[vf->lan_vsi_idx];
-	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
-		dev_err(&pf->pdev->dev, "VF %d still in reset. Try again.\n",
-			vf_id);
+	if (!i40e_check_vf_init_timeout(vf)) {
 		ret = -EAGAIN;
 		goto error_pvid;
 	}
+	vsi = pf->vsi[vf->lan_vsi_idx];
 
 	if (le16_to_cpu(vsi->info.pvid) == vlanprio)
 		/* duplicate request, so just return success */
@@ -4616,13 +4614,11 @@ int i40e_ndo_set_vf_bw(struct net_device *netdev, int vf_id, int min_tx_rate,
 	}
 
 	vf = &pf->vf[vf_id];
-	vsi = pf->vsi[vf->lan_vsi_idx];
-	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
-		dev_err(&pf->pdev->dev, "VF %d still in reset. Try again.\n",
-			vf_id);
+	if (!i40e_check_vf_init_timeout(vf)) {
 		ret = -EAGAIN;
 		goto error;
 	}
+	vsi = pf->vsi[vf->lan_vsi_idx];
 
 	ret = i40e_set_bw_limit(vsi, vsi->seid, max_tx_rate);
 	if (ret)
@@ -4789,9 +4785,7 @@ int i40e_ndo_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool enable)
 	}
 
 	vf = &(pf->vf[vf_id]);
-	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
-		dev_err(&pf->pdev->dev, "VF %d still in reset. Try again.\n",
-			vf_id);
+	if (!i40e_check_vf_init_timeout(vf)) {
 		ret = -EAGAIN;
 		goto out;
 	}
-- 
2.39.3


