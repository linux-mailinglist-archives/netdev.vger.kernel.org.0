Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC03230849
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 13:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgG1LDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 07:03:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:34648 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbgG1LDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 07:03:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 95866AF8A;
        Tue, 28 Jul 2020 11:03:22 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 7E2406073D; Tue, 28 Jul 2020 13:03:11 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool] ioctl: do not pass transceiver value back to kernel
To:     netdev@vger.kernel.org
Cc:     Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Message-Id: <20200728110311.7E2406073D@lion.mk-sys.cz>
Date:   Tue, 28 Jul 2020 13:03:11 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While we want to report transceiver value in "ethtool <dev>" output, we
must not return nonzero value provided in ETHTOOL_GLINKSETTINGS reply back
to kernel in ETHTOOL_SLINKSETTINGS request.

Fixes: 8bb9a04002a3 ("ethtool.c: Report transceiver correctly")
Reported-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index d37c223dcc04..1b99ac91dcbf 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -2906,6 +2906,8 @@ static int do_sset(struct cmd_context *ctx)
 		struct ethtool_link_usettings *link_usettings;
 
 		link_usettings = do_ioctl_glinksettings(ctx);
+		memset(&link_usettings->deprecated, 0,
+		       sizeof(link_usettings->deprecated));
 		if (link_usettings == NULL)
 			link_usettings = do_ioctl_gset(ctx);
 		if (link_usettings == NULL) {
-- 
2.27.0

