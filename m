Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6104282F0
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 20:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhJJS0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 14:26:52 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46038 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbhJJS0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 14:26:51 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 98DD220020;
        Sun, 10 Oct 2021 18:24:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B2CAA139E0;
        Sun, 10 Oct 2021 18:24:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HgSPH/EvY2FELwAAMHmgww
        (envelope-from <dave@stgolabs.net>); Sun, 10 Oct 2021 18:24:49 +0000
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH] netfilter: ebtables: allocate chainstack on CPU local nodes
Date:   Sun, 10 Oct 2021 11:24:39 -0700
Message-Id: <20211010182439.11036-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keep the per-CPU memory allocated for chainstacks local.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 net/bridge/netfilter/ebtables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 83d1798dfbb4..ba045f35114d 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -926,7 +926,9 @@ static int translate_table(struct net *net, const char *name,
 			return -ENOMEM;
 		for_each_possible_cpu(i) {
 			newinfo->chainstack[i] =
-			  vmalloc(array_size(udc_cnt, sizeof(*(newinfo->chainstack[0]))));
+			  vmalloc_node(array_size(udc_cnt,
+					  sizeof(*(newinfo->chainstack[0]))),
+				       cpu_to_node(i));
 			if (!newinfo->chainstack[i]) {
 				while (i)
 					vfree(newinfo->chainstack[--i]);
-- 
2.26.2

