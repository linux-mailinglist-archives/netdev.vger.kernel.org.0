Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9A9257703
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 11:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgHaJ6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 05:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbgHaJ6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 05:58:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598867892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=R58xCRXQfXzBTUDEpS95OebrkIKRzjZX1lvDe83aII4=;
        b=DZLCS+ZksPTzpKJ+qDPIEfksZdMJsNu0nqfKppnHiAtqMWh4OvBDDCsRPaTtcAT/qMRDPb
        Tmyn/owQcVdVzMxzgyfTXHMttnHC+tP0uc2fHa3y5JA0Yv3ZxhJPkENRsWMZmENjORYczM
        h8ODy2klvd+/XHsGcJl6K1h6ihg8SWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-blXjjQqnMQC81kqiP8wavw-1; Mon, 31 Aug 2020 05:58:06 -0400
X-MC-Unique: blXjjQqnMQC81kqiP8wavw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEB9F8030A4;
        Mon, 31 Aug 2020 09:58:04 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-114-213.ams2.redhat.com [10.36.114.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 500FF5C22A;
        Mon, 31 Aug 2020 09:58:03 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org
Subject: [PATCH net-next] net: openvswitch: fixes crash if nf_conncount_init() fails
Date:   Mon, 31 Aug 2020 11:57:57 +0200
Message-Id: <159886787741.29248.5272329110875821435.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If nf_conncount_init fails currently the dispatched work is not canceled,
causing problems when the timer fires. This change fixes this by not
scheduling the work until all initialization is successful.

Fixes: a65878d6f00b ("net: openvswitch: fixes potential deadlock in dp cleanup code")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 net/openvswitch/datapath.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 6e47ef7ef036..78941822119f 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2476,13 +2476,19 @@ static int __init dp_register_genl(void)
 static int __net_init ovs_init_net(struct net *net)
 {
 	struct ovs_net *ovs_net = net_generic(net, ovs_net_id);
+	int err;
 
 	INIT_LIST_HEAD(&ovs_net->dps);
 	INIT_WORK(&ovs_net->dp_notify_work, ovs_dp_notify_wq);
 	INIT_DELAYED_WORK(&ovs_net->masks_rebalance, ovs_dp_masks_rebalance);
+
+	err = ovs_ct_init(net);
+	if (err)
+		return err;
+
 	schedule_delayed_work(&ovs_net->masks_rebalance,
 			      msecs_to_jiffies(DP_MASKS_REBALANCE_INTERVAL));
-	return ovs_ct_init(net);
+	return 0;
 }
 
 static void __net_exit list_vports_from_net(struct net *net, struct net *dnet,

