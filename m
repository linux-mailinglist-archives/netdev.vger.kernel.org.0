Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86241B6B23
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgDXCMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgDXCMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:12:07 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60A1F21582;
        Fri, 24 Apr 2020 02:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587694327;
        bh=e9BGy27aTGDn3WUXlWptwuXPzEO4VCFTHKkNzzNEHYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WAkqKIZP19k05VCW8EHvk3Ab/jFQddMK5W9TsjbgO2PQ+FC9ZDDgjh5q5VnfmrsXO
         cUkEvAfBDry538jfzs7m38yUI564fYAq98U6VKLUk+wGbPuTqyp5DdljE4Fao2vbFa
         ReqTCP/9EsjJix//oZE22NnN3RKEobrJSD/S4Q98=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v2 bpf-next 12/17] libbpf: Refactor get_xdp_info
Date:   Thu, 23 Apr 2020 20:11:43 -0600
Message-Id: <20200424021148.83015-13-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200424021148.83015-1-dsahern@kernel.org>
References: <20200424021148.83015-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Move parsing of IFLA_XDP attribute to a helper that can be reused
for the new IFLA_XDP_EGRESS attribute.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 tools/lib/bpf/netlink.c | 43 +++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 0b709fd10bba..90ced689e53b 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -238,51 +238,60 @@ static int __dump_link_nlmsg(struct nlmsghdr *nlh,
 	return dump_link_nlmsg(cookie, ifi, tb);
 }
 
-static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
+static int process_xdp_attr(struct nlattr *tb, struct xdp_link_info *info)
 {
 	struct nlattr *xdp_tb[IFLA_XDP_MAX + 1];
-	struct xdp_id_md *xdp_id = cookie;
-	struct ifinfomsg *ifinfo = msg;
 	int ret;
 
-	if (xdp_id->ifindex && xdp_id->ifindex != ifinfo->ifi_index)
-		return 0;
-
-	if (!tb[IFLA_XDP])
-		return 0;
-
-	ret = libbpf_nla_parse_nested(xdp_tb, IFLA_XDP_MAX, tb[IFLA_XDP], NULL);
+	ret = libbpf_nla_parse_nested(xdp_tb, IFLA_XDP_MAX, tb, NULL);
 	if (ret)
 		return ret;
 
 	if (!xdp_tb[IFLA_XDP_ATTACHED])
 		return 0;
 
-	xdp_id->info.attach_mode = libbpf_nla_getattr_u8(
-		xdp_tb[IFLA_XDP_ATTACHED]);
+	info->attach_mode = libbpf_nla_getattr_u8(xdp_tb[IFLA_XDP_ATTACHED]);
 
-	if (xdp_id->info.attach_mode == XDP_ATTACHED_NONE)
+	if (info->attach_mode == XDP_ATTACHED_NONE)
 		return 0;
 
 	if (xdp_tb[IFLA_XDP_PROG_ID])
-		xdp_id->info.prog_id = libbpf_nla_getattr_u32(
+		info->prog_id = libbpf_nla_getattr_u32(
 			xdp_tb[IFLA_XDP_PROG_ID]);
 
 	if (xdp_tb[IFLA_XDP_SKB_PROG_ID])
-		xdp_id->info.skb_prog_id = libbpf_nla_getattr_u32(
+		info->skb_prog_id = libbpf_nla_getattr_u32(
 			xdp_tb[IFLA_XDP_SKB_PROG_ID]);
 
 	if (xdp_tb[IFLA_XDP_DRV_PROG_ID])
-		xdp_id->info.drv_prog_id = libbpf_nla_getattr_u32(
+		info->drv_prog_id = libbpf_nla_getattr_u32(
 			xdp_tb[IFLA_XDP_DRV_PROG_ID]);
 
 	if (xdp_tb[IFLA_XDP_HW_PROG_ID])
-		xdp_id->info.hw_prog_id = libbpf_nla_getattr_u32(
+		info->hw_prog_id = libbpf_nla_getattr_u32(
 			xdp_tb[IFLA_XDP_HW_PROG_ID]);
 
 	return 0;
 }
 
+static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
+{
+	struct xdp_id_md *xdp_id = cookie;
+	struct ifinfomsg *ifinfo = msg;
+	int ret;
+
+	if (xdp_id->ifindex && xdp_id->ifindex != ifinfo->ifi_index)
+		return 0;
+
+	if (tb[IFLA_XDP]) {
+		ret = process_xdp_attr(tb[IFLA_XDP], &xdp_id->info);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 			  size_t info_size, __u32 flags)
 {
-- 
2.21.1 (Apple Git-122.3)

