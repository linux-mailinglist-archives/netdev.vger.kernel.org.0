Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7FC6D183
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 18:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbfGRQIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 12:08:32 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:2110 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbfGRQIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 12:08:32 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9]) by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee85d309938b31-a1ec6; Fri, 19 Jul 2019 00:07:23 +0800 (CST)
X-RM-TRANSID: 2ee85d309938b31-a1ec6
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee55d30993a255-0e1ea;
        Fri, 19 Jul 2019 00:07:23 +0800 (CST)
X-RM-TRANSID: 2ee55d30993a255-0e1ea
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH] openvswitch: Fix a possible memory leak on dst_cache
Date:   Fri, 19 Jul 2019 00:07:08 +0800
Message-Id: <1563466028-2531-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dst_cache should be destroyed when fail to add flow actions.

Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
 net/openvswitch/flow_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index d7559c6..1fd1cdd 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2608,6 +2608,7 @@ static int validate_and_copy_set_tun(const struct nlattr *attr,
 			 sizeof(*ovs_tun), log);
 	if (IS_ERR(a)) {
 		dst_release((struct dst_entry *)tun_dst);
+		dst_cache_destroy(&tun_dst->u.tun_info.dst_cache);
 		return PTR_ERR(a);
 	}
 
-- 
1.8.3.1



