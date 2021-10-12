Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D092A42A7B2
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbhJLO4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237248AbhJLO4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 10:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A90B66103D;
        Tue, 12 Oct 2021 14:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634050481;
        bh=YBN6RkazjI/A/jEKqMXs55ZrA2u1mne9BEW4vboZ0WY=;
        h=From:To:Cc:Subject:Date:From;
        b=UdyDUnCCuP3RKyKXHWogRuNnraAHRlAhNJw6xt93/DWlD11sxkhSlgudjSjLxbWWW
         fXBvDb/k54XBlCLspqp7Dn8DS2v87agY7ZEzsJR9hzNVjc44Cpx8gOvwDCDw0Q28zK
         HVqv7e/WxwhLESrquc+lWUUKOMqNQ/p1Fh9/MdBilItBXLYYbGSPFL5X4tezyayUwr
         N3KMY3Sif0237NvT9xNCsRH7WLCDAKP19K+OZZtWhYd14SAMFTYpUNC3kSc+JI1ji2
         vQ0lJVWuk1cALKv7g1k5zwpWpbSrKEC74EfFnsiHkCCwz9jnxY7gRCC3VulWKi/WXj
         6sPVTRDQHj6Gg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, horms@verge.net.au,
        ja@ssi.bg, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH net] netfilter: ipvs: make global sysctl readonly in non-init netns
Date:   Tue, 12 Oct 2021 16:54:37 +0200
Message-Id: <20211012145437.754391-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because the data pointer of net/ipv4/vs/debug_level is not updated per
netns, it must be marked as read-only in non-init netns.

Fixes: c6d2d445d8de ("IPVS: netns, final patch enabling network name space.")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c25097092a06..29ec3ef63edc 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -4090,6 +4090,11 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	tbl[idx++].data = &ipvs->sysctl_conn_reuse_mode;
 	tbl[idx++].data = &ipvs->sysctl_schedule_icmp;
 	tbl[idx++].data = &ipvs->sysctl_ignore_tunneled;
+#ifdef CONFIG_IP_VS_DEBUG
+	/* Global sysctls must be ro in non-init netns */
+	if (!net_eq(net, &init_net))
+		tbl[idx++].mode = 0444;
+#endif
 
 	ipvs->sysctl_hdr = register_net_sysctl(net, "net/ipv4/vs", tbl);
 	if (ipvs->sysctl_hdr == NULL) {
-- 
2.31.1

