Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E3326207C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgIHUMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:12:20 -0400
Received: from correo.us.es ([193.147.175.20]:33108 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730150AbgIHPLS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 11:11:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A0E7E1F0D07
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:09:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 944F7DA791
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:09:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 91773DA730; Tue,  8 Sep 2020 17:09:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6AD0BDA730;
        Tue,  8 Sep 2020 17:09:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Sep 2020 17:09:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4026A4301DE0;
        Tue,  8 Sep 2020 17:09:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 4/5] netfilter: conntrack: nf_conncount_init is failing with IPv6 disabled
Date:   Tue,  8 Sep 2020 17:09:46 +0200
Message-Id: <20200908150947.12623-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200908150947.12623-1-pablo@netfilter.org>
References: <20200908150947.12623-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

The openvswitch module fails initialization when used in a kernel
without IPv6 enabled. nf_conncount_init() fails because the ct code
unconditionally tries to initialize the netns IPv6 related bit,
regardless of the build option. The change below ignores the IPv6
part if not enabled.

Note that the corresponding _put() function already has this IPv6
configuration check.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 95f79980348c..47e9319d2cf3 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -565,6 +565,7 @@ static int nf_ct_netns_inet_get(struct net *net)
 	int err;
 
 	err = nf_ct_netns_do_get(net, NFPROTO_IPV4);
+#if IS_ENABLED(CONFIG_IPV6)
 	if (err < 0)
 		goto err1;
 	err = nf_ct_netns_do_get(net, NFPROTO_IPV6);
@@ -575,6 +576,7 @@ static int nf_ct_netns_inet_get(struct net *net)
 err2:
 	nf_ct_netns_put(net, NFPROTO_IPV4);
 err1:
+#endif
 	return err;
 }
 
-- 
2.20.1

