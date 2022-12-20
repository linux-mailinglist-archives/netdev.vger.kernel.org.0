Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C42651927
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 03:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLTCtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 21:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLTCs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 21:48:59 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1730B1275B
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 18:48:58 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id y3so5751209ilq.0
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 18:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=frWLw2ZkVObcc07j9dtQMFLxjnvLrXU3PwzZGX4Mo7w=;
        b=eduU04r8hf3vvnHc0OMdNDtR057TK+Snzk8vQVcuXrsnOT88upRHhU9h+0XUMlna8a
         gUf4xd7jISw24azRqDOgbn3C38HFfLvqW/W+MqKYRsbWzlfhFY4LCwsuWU86Ek02VpmP
         lQCTtUQ128C8+W5PdwtcECwTcDBM42bnqb0RiKyV1qCgx6e7AMbgFw1RfGTtyWU7sTmD
         ZCmhq6FggXO8KcVAt4QeON0+KXKfFCn2lVsKbntLz3MyFlb7UI1zCEMvzEagSmAV2x3o
         x6UpeRgDSrU+4hJDnqANPAkpLGMoPKl0tNYn/TKlaS7lOG+0gxMpXZDY8S+iY7ujStgZ
         fU0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=frWLw2ZkVObcc07j9dtQMFLxjnvLrXU3PwzZGX4Mo7w=;
        b=vfejVBDj5GiUC4FQDy3v9lRXp19us+u22H6bJNPlh0PBZJ4xHcJ4UIc5gYW+Ryfg4x
         xuPXwHy3ijLP4hlXtyAXWkOFDe7kyLWqogrcFpILq4GwI5gpuWGlKX+lK79wOejWNQzl
         1ikFyIZlmFZqk751FnDP174aWtcd0ukvgOEL5iEm/0sHXNkM6x6bh7u5jqgpTzZYqsDj
         xEhGKaw0UO3XVgMRIbzcKqAFpSf61xxqrFLAh4f0rTcwOCluLzaCOw4fjjyqLFffpzja
         d6Oj3ROL31u7css1MG+A3NER0jJNCXAKFLFEV2OnBVKh18q+Xv/nXFPdB71brxO6VXd4
         pwvg==
X-Gm-Message-State: ANoB5pmWQxkJ/EFSpoUS5ffzh6ys6ipuy2bzFAUafc0SsPzDUhttLK/H
        oTnFUeGfXWU5Su9KxWOpSNd9vw==
X-Google-Smtp-Source: AA0mqf7BWvvYPtstOR7XHomWWQoZlWrLYrQ2ES1K/rZlfQTN2lBkBV1cd6n+hJYADCwJYr1fNSjZeQ==
X-Received: by 2002:a92:cac9:0:b0:302:bd25:c1a3 with SMTP id m9-20020a92cac9000000b00302bd25c1a3mr18694114ilq.21.1671504537395;
        Mon, 19 Dec 2022 18:48:57 -0800 (PST)
Received: from dev-jgu.dev.purestorage.com ([208.88.159.128])
        by smtp.googlemail.com with ESMTPSA id l17-20020a92d951000000b00305e3da5f7dsm3427582ilq.85.2022.12.19.18.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 18:48:56 -0800 (PST)
From:   Joy Gu <jgu@purestorage.com>
To:     bridge@lists.linux-foundation.org
Cc:     roopa@nvidia.com, razor@blackwall.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        joern@purestorage.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joy Gu <jgu@purestorage.com>
Subject: [PATCH] net: bridge: mcast: read ngrec once in igmp3/mld2 report
Date:   Mon, 19 Dec 2022 18:48:07 -0800
Message-Id: <20221220024807.36502-1-jgu@purestorage.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In br_ip4_multicast_igmp3_report() and br_ip6_multicast_mld2_report(),
"ih" or "mld2r" is a pointer into the skb header. It's dereferenced to
get "num", which is used in the for-loop condition that follows.

Compilers are free to not spend a register on "num" and dereference that
pointer every time "num" would be used, i.e. every loop iteration. Which
would be a bug if pskb_may_pull() (called by ip_mc_may_pull() or
ipv6_mc_may_pull() in the loop body) were to change pointers pointing
into the skb header, e.g. by freeing "skb->head".

We can avoid this by using READ_ONCE().

Suggested-by: Joern Engel <joern@purestorage.com>
Signed-off-by: Joy Gu <jgu@purestorage.com>
---
 net/bridge/br_multicast.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 48170bd3785e..2ac4b099e00d 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2624,11 +2624,11 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge_mcast *brmctx,
 	bool changed = false;
 	int err = 0;
 	u16 nsrcs;
 
 	ih = igmpv3_report_hdr(skb);
-	num = ntohs(ih->ngrec);
+	num = ntohs(READ_ONCE(ih->ngrec));
 	len = skb_transport_offset(skb) + sizeof(*ih);
 
 	for (i = 0; i < num; i++) {
 		len += sizeof(*grec);
 		if (!ip_mc_may_pull(skb, len))
@@ -2750,11 +2750,11 @@ static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
 
 	if (!ipv6_mc_may_pull(skb, sizeof(*mld2r)))
 		return -EINVAL;
 
 	mld2r = (struct mld2_report *)icmp6_hdr(skb);
-	num = ntohs(mld2r->mld2r_ngrec);
+	num = ntohs(READ_ONCE(mld2r->mld2r_ngrec));
 	len = skb_transport_offset(skb) + sizeof(*mld2r);
 
 	for (i = 0; i < num; i++) {
 		__be16 *_nsrcs, __nsrcs;
 		u16 nsrcs;
-- 
2.39.0

