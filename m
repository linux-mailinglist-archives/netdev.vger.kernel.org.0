Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1218B2E7569
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 01:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgL3Ath (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 19:49:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgL3Ath (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Dec 2020 19:49:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEC01207CF;
        Wed, 30 Dec 2020 00:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609289337;
        bh=NHtm5frSNwZAThwPuhJZZehqWWd7Ojo398ySi0sf/9s=;
        h=From:To:Cc:Subject:Date:From;
        b=Jbzq5Sq69rBxP8bUpEpBaztrFZem6mq6QV8yRvSvRTt5MIWdZy9d26TR05ci9uSXh
         FLC4FKtP4bT1TSXNG26X+UMD+Twb14SG0kSlI271poppxLai52tWKr6OFxxE2w4NVT
         ObRitsMH1M6pv0fqoZTpxHIN/kY3Vk9+Bb28eL1zSOg7hEkRKBnuAPexyz4qNMY55I
         mgHxns6TQxfgZNryhnkCRJDeT7Wly1IwfZ7VHjqKkRP4Us7p6ltq6QBamo5frkHd3x
         iAbFnbC+5w4kuAN0oR5VD0AckvCsGm8BZK0QMNfttybe3kPvE51/0rEqQcZ7yAryTx
         +GPAbHBIoxY+g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     kgraul@linux.ibm.com, guvenc@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+f4708c391121cfc58396@syzkaller.appspotmail.com
Subject: [PATCH net] smc: fix out of bound access in smc_nl_get_sys_info()
Date:   Tue, 29 Dec 2020 16:48:41 -0800
Message-Id: <20201230004841.1472141-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smc_clc_get_hostname() sets the host pointer to a buffer
which is not NULL-terminated (see smc_clc_init()).

Reported-by: syzbot+f4708c391121cfc58396@syzkaller.appspotmail.com
Fixes: 099b990bd11a ("net/smc: Add support for obtaining system information")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/smc/smc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 59342b519e34..8d866b4ed8f6 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -246,7 +246,8 @@ int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
 		goto errattr;
 	smc_clc_get_hostname(&host);
 	if (host) {
-		snprintf(hostname, sizeof(hostname), "%s", host);
+		memcpy(hostname, host, SMC_MAX_HOSTNAME_LEN);
+		hostname[SMC_MAX_HOSTNAME_LEN] = 0;
 		if (nla_put_string(skb, SMC_NLA_SYS_LOCAL_HOST, hostname))
 			goto errattr;
 	}
-- 
2.26.2

