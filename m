Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A67D35949F
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 07:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbhDIFeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 01:34:03 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:50694 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhDIFeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 01:34:03 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 91D18E02AE0;
        Fri,  9 Apr 2021 13:33:48 +0800 (CST)
From:   wenxu@ucloud.cn
To:     saeed@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH] net/mlx5e: fix ingress_ifindex check in mlx5e_flower_parse_meta
Date:   Fri,  9 Apr 2021 13:33:48 +0800
Message-Id: <1617946428-10944-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZTkpCHktLGhpMQx8YVkpNSkxCT01PSUNNQ05VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OjY6FTo5Oj09C0kRDzwOPhAZ
        SzIKCQpVSlVKTUpMQk9NT0lDQ01NVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpMTko3Bg++
X-HM-Tid: 0a78b51f44d420bdkuqy91d18e02ae0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the nft_offload there is the mate flow_dissector with no
ingress_ifindex but with ingress_iftype that only be used
in the software. So if the mask of ingress_ifindex in meta is
0, this meta check should be bypass.

Fixes: 6d65bc64e232 ("net/mlx5e: Add mlx5e_flower_parse_meta support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index df2a0af..d675107d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1895,6 +1895,9 @@ static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
 		return 0;
 
 	flow_rule_match_meta(rule, &match);
+	if (!match.mask->ingress_ifindex)
+		return 0;
+
 	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
 		return -EOPNOTSUPP;
-- 
1.8.3.1

