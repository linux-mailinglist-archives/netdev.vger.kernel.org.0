Return-Path: <netdev+bounces-8445-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5D272415C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 321F71C20F43
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D0916406;
	Tue,  6 Jun 2023 11:56:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE90D15ACE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:56:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232DDE47
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686052604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AVi2jOX5sx0HcyFFKbxiEGxS7O0tlDZzrMIDcTAF4AY=;
	b=PATzA7mioTfNDWB1oOouqWpq8dCy/iNc18o5EYSnodQRrr7fNwx91eLw3iaPXV8GGPMwYI
	D5yz+iV5gF49gsjvzNZCwPxEYiAKTOxQKQ31l4o4G6mDyvBtl0q3AkVSj/8H9+l3j2V6hg
	RWUzqjVRgjv+iNdlCrrQT6Q1Adop1JA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-ZxC7fLJ9MmGaLY3ILVqhxQ-1; Tue, 06 Jun 2023 07:56:40 -0400
X-MC-Unique: ZxC7fLJ9MmGaLY3ILVqhxQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75D611C04189;
	Tue,  6 Jun 2023 11:56:40 +0000 (UTC)
Received: from ebuild.redhat.com (unknown [10.39.195.16])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DB710C1603B;
	Tue,  6 Jun 2023 11:56:38 +0000 (UTC)
From: Eelco Chaudron <echaudro@redhat.com>
To: netdev@vger.kernel.org
Cc: pshelar@ovn.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	dev@openvswitch.org,
	aconole@redhat.com,
	simon.horman@corigine.com
Subject: [PATCH net v2] net: openvswitch: fix upcall counter access before allocation
Date: Tue,  6 Jun 2023 13:56:35 +0200
Message-Id: <168605257118.1677939.2593213990325886393.stgit@ebuild>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently, the per cpu upcall counters are allocated after the vport is
created and inserted into the system. This could lead to the datapath
accessing the counters before they are allocated resulting in a kernel
Oops.

Here is an example:

  PID: 59693    TASK: ffff0005f4f51500  CPU: 0    COMMAND: "ovs-vswitchd"
   #0 [ffff80000a39b5b0] __switch_to at ffffb70f0629f2f4
   #1 [ffff80000a39b5d0] __schedule at ffffb70f0629f5cc
   #2 [ffff80000a39b650] preempt_schedule_common at ffffb70f0629fa60
   #3 [ffff80000a39b670] dynamic_might_resched at ffffb70f0629fb58
   #4 [ffff80000a39b680] mutex_lock_killable at ffffb70f062a1388
   #5 [ffff80000a39b6a0] pcpu_alloc at ffffb70f0594460c
   #6 [ffff80000a39b750] __alloc_percpu_gfp at ffffb70f05944e68
   #7 [ffff80000a39b760] ovs_vport_cmd_new at ffffb70ee6961b90 [openvswitch]
   ...

  PID: 58682    TASK: ffff0005b2f0bf00  CPU: 0    COMMAND: "kworker/0:3"
   #0 [ffff80000a5d2f40] machine_kexec at ffffb70f056a0758
   #1 [ffff80000a5d2f70] __crash_kexec at ffffb70f057e2994
   #2 [ffff80000a5d3100] crash_kexec at ffffb70f057e2ad8
   #3 [ffff80000a5d3120] die at ffffb70f0628234c
   #4 [ffff80000a5d31e0] die_kernel_fault at ffffb70f062828a8
   #5 [ffff80000a5d3210] __do_kernel_fault at ffffb70f056a31f4
   #6 [ffff80000a5d3240] do_bad_area at ffffb70f056a32a4
   #7 [ffff80000a5d3260] do_translation_fault at ffffb70f062a9710
   #8 [ffff80000a5d3270] do_mem_abort at ffffb70f056a2f74
   #9 [ffff80000a5d32a0] el1_abort at ffffb70f06297dac
  #10 [ffff80000a5d32d0] el1h_64_sync_handler at ffffb70f06299b24
  #11 [ffff80000a5d3410] el1h_64_sync at ffffb70f056812dc
  #12 [ffff80000a5d3430] ovs_dp_upcall at ffffb70ee6963c84 [openvswitch]
  #13 [ffff80000a5d3470] ovs_dp_process_packet at ffffb70ee6963fdc [openvswitch]
  #14 [ffff80000a5d34f0] ovs_vport_receive at ffffb70ee6972c78 [openvswitch]
  #15 [ffff80000a5d36f0] netdev_port_receive at ffffb70ee6973948 [openvswitch]
  #16 [ffff80000a5d3720] netdev_frame_hook at ffffb70ee6973a28 [openvswitch]
  #17 [ffff80000a5d3730] __netif_receive_skb_core.constprop.0 at ffffb70f06079f90

We moved the per cpu upcall counter allocation to the existing vport
alloc and free functions to solve this.

Fixes: 95637d91fefd ("net: openvswitch: release vport resources on failure")
Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall packets")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---

v2: - Cleaned up error handling as Simon suggested.

 net/openvswitch/datapath.c |   19 -------------------
 net/openvswitch/vport.c    |   18 ++++++++++++++++--
 2 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index fcee6012293b..58f530f60172 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -236,9 +236,6 @@ void ovs_dp_detach_port(struct vport *p)
 	/* First drop references to device. */
 	hlist_del_rcu(&p->dp_hash_node);
 
-	/* Free percpu memory */
-	free_percpu(p->upcall_stats);
-
 	/* Then destroy it. */
 	ovs_vport_del(p);
 }
@@ -1858,12 +1855,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 		goto err_destroy_portids;
 	}
 
-	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
-	if (!vport->upcall_stats) {
-		err = -ENOMEM;
-		goto err_destroy_vport;
-	}
-
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
 				   info->snd_seq, 0, OVS_DP_CMD_NEW);
 	BUG_ON(err < 0);
@@ -1876,8 +1867,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_notify(&dp_datapath_genl_family, reply, info);
 	return 0;
 
-err_destroy_vport:
-	ovs_dp_detach_port(vport);
 err_destroy_portids:
 	kfree(rcu_dereference_raw(dp->upcall_portids));
 err_unlock_and_destroy_meters:
@@ -2322,12 +2311,6 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 		goto exit_unlock_free;
 	}
 
-	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
-	if (!vport->upcall_stats) {
-		err = -ENOMEM;
-		goto exit_unlock_free_vport;
-	}
-
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
 				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
@@ -2345,8 +2328,6 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_notify(&dp_vport_genl_family, reply, info);
 	return 0;
 
-exit_unlock_free_vport:
-	ovs_dp_detach_port(vport);
 exit_unlock_free:
 	ovs_unlock();
 	kfree_skb(reply);
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 7e0f5c45b512..972ae01a70f7 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -124,6 +124,7 @@ struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *ops,
 {
 	struct vport *vport;
 	size_t alloc_size;
+	int err;
 
 	alloc_size = sizeof(struct vport);
 	if (priv_size) {
@@ -135,17 +136,29 @@ struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *ops,
 	if (!vport)
 		return ERR_PTR(-ENOMEM);
 
+	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
+	if (!vport->upcall_stats) {
+		err = -ENOMEM;
+		goto err_kfree_vport;
+	}
+
 	vport->dp = parms->dp;
 	vport->port_no = parms->port_no;
 	vport->ops = ops;
 	INIT_HLIST_NODE(&vport->dp_hash_node);
 
 	if (ovs_vport_set_upcall_portids(vport, parms->upcall_portids)) {
-		kfree(vport);
-		return ERR_PTR(-EINVAL);
+		err = -EINVAL;
+		goto err_free_percpu;
 	}
 
 	return vport;
+
+err_free_percpu:
+	free_percpu(vport->upcall_stats);
+err_kfree_vport:
+	kfree(vport);
+	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(ovs_vport_alloc);
 
@@ -165,6 +178,7 @@ void ovs_vport_free(struct vport *vport)
 	 * it is safe to use raw dereference.
 	 */
 	kfree(rcu_dereference_raw(vport->upcall_portids));
+	free_percpu(vport->upcall_stats);
 	kfree(vport);
 }
 EXPORT_SYMBOL_GPL(ovs_vport_free);


