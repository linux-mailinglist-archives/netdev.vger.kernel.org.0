Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4404652256B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 22:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiEJU1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 16:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiEJU1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 16:27:48 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3F71A830;
        Tue, 10 May 2022 13:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YZxChS9o5Wo4/jqgk+/OkB7b4K/AQ5LajGIkh2b6wG0=; b=TUqErr/SLHfftPF8xuuZ41edGc
        sv5aoLny7nmEg5bGgqeEjNPe/c5sG29/o1OXhJNVb2gMLlYICbK1oiFOtDPxdN7JjJFTELK94aARr
        +NiCqwCRYdPsZ93j/szkbyjdnL/6rFextUVQ3yhcGwY0qQTUeBdHFxrxO0yEp8i6mk6o=;
Received: from p200300daa70ef200adfdb724d8b39c56.dip0.t-ipconnect.de ([2003:da:a70e:f200:adfd:b724:d8b3:9c56] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1noWSO-00067p-5j; Tue, 10 May 2022 22:27:44 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, pablo@netfilter.org,
        Jo-Philipp Wich <jo@mein.io>
Subject: [RFC] netfilter: nf_tables: ignore errors on flowtable device hw offload setup
Date:   Tue, 10 May 2022 22:27:39 +0200
Message-Id: <20220510202739.67068-1-nbd@nbd.name>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In many cases, it's not easily possible for user space to know, which
devices properly support hardware offload. Even if a device supports hardware
flow offload, it is not guaranteed that it will actually be able to handle
the flows for which hardware offload is requested.

Ignoring errors on the FLOW_BLOCK_BIND makes it a lot easier to set up
configurations that use hardware offload where possible and gracefully
fall back to software offload for everything else.

Cc: Jo-Philipp Wich <jo@mein.io>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/netfilter/nf_tables_api.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 16c3a39689f4..9d4528f0aa12 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7323,11 +7323,9 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			}
 		}
 
-		err = flowtable->data.type->setup(&flowtable->data,
-						  hook->ops.dev,
-						  FLOW_BLOCK_BIND);
-		if (err < 0)
-			goto err_unregister_net_hooks;
+		flowtable->data.type->setup(&flowtable->data,
+					    hook->ops.dev,
+					    FLOW_BLOCK_BIND);
 
 		err = nf_register_net_hook(net, &hook->ops);
 		if (err < 0) {
-- 
2.36.1

