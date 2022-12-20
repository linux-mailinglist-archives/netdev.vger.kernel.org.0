Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D518652863
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 22:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiLTV2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 16:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234053AbiLTV2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 16:28:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AD61EAEB
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 13:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671571644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CjIdiy7qWudpHRQwlyIrGgwMBBb8yFPp0r6JrGVeizM=;
        b=eHO7xQW+tIXxeo/WKOcOa2MLwxqmu4Ek0xAQ7lr4o6nLeZsYu1joAG7uKRHzLuj3/H/yv7
        VzxhARwLJGvjpv302ys3GfSErC3SRpZPYpwnATHyichwj1j5PXXeqs0uVRv/TnzIF1EswA
        puyXf8IDB8rTJba04KPisqX7pRKhEYY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-TVK56jxcNsCi8i3ey1DOLA-1; Tue, 20 Dec 2022 16:27:20 -0500
X-MC-Unique: TVK56jxcNsCi8i3ey1DOLA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B0D3858F0E;
        Tue, 20 Dec 2022 21:27:18 +0000 (UTC)
Received: from RHTPC1VM0NT.lan (unknown [10.22.32.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9387D492B00;
        Tue, 20 Dec 2022 21:27:17 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, dev@openvswitch.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        wangchuanlei <wangchuanlei@inspur.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: openvswitch: release vport resources on failure
Date:   Tue, 20 Dec 2022 16:27:17 -0500
Message-Id: <20221220212717.526780-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent commit introducing upcall packet accounting failed to properly
release the vport object when the per-cpu stats struct couldn't be
allocated.  This can cause dangling pointers to dp objects long after
they've been released.

Cc: Eelco Chaudron <echaudro@redhat.com>
Cc: wangchuanlei <wangchuanlei@inspur.com>
Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall packets")
Reported-by: syzbot+8f4e2dcfcb3209ac35f9@syzkaller.appspotmail.com
Signed-off-by: Aaron Conole <aconole@redhat.com>
---
 net/openvswitch/datapath.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 932bcf766d63..6774baf9e212 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1854,7 +1854,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
 	if (!vport->upcall_stats) {
 		err = -ENOMEM;
-		goto err_destroy_portids;
+		goto err_destroy_vport;
 	}
 
 	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
@@ -1869,6 +1869,8 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_notify(&dp_datapath_genl_family, reply, info);
 	return 0;
 
+err_destroy_vport:
+	ovs_dp_detach_port(vport);
 err_destroy_portids:
 	kfree(rcu_dereference_raw(dp->upcall_portids));
 err_unlock_and_destroy_meters:
@@ -2316,7 +2318,7 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
 	if (!vport->upcall_stats) {
 		err = -ENOMEM;
-		goto exit_unlock_free;
+		goto exit_unlock_free_vport;
 	}
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
@@ -2336,6 +2338,8 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_notify(&dp_vport_genl_family, reply, info);
 	return 0;
 
+exit_unlock_free_vport:
+	ovs_dp_detach_port(vport);
 exit_unlock_free:
 	ovs_unlock();
 	kfree_skb(reply);
-- 
2.31.1

