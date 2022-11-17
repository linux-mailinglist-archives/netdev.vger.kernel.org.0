Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23ADE62E9AB
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 00:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbiKQXe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 18:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240364AbiKQXef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 18:34:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F9F11A29
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 15:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668728011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b2HvmDX/IJJJ4wRxPJ3at/92WdoJBS7sOkXuEqx5reg=;
        b=Q/QnNStxeBkcggNvDo5JLmCyD0RdVbogRr4P4JyTofLxO3w8DomX/VY0nVkQ/i458CFqCU
        kor/jpTkRYjvlOUGxELpKUNSl116f/PIIdzJ3kZofkWVROLc1lCOSRKyKapC26D6LTbgTs
        7KkIg55H/WVAD1/Gv8mF2nlJ+sMpqE4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-LLt5qyG4NE-c2iGpE-CEHQ-1; Thu, 17 Nov 2022 18:33:26 -0500
X-MC-Unique: LLt5qyG4NE-c2iGpE-CEHQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D42BC1C0518B;
        Thu, 17 Nov 2022 23:33:25 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05F97C1912A;
        Thu, 17 Nov 2022 23:33:24 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Heng Qi <henqqi@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, bpf@vger.kernel.org
Subject: [PATCH net-next 2/2] veth: fix double napi enable
Date:   Fri, 18 Nov 2022 00:33:11 +0100
Message-Id: <b90034c61b939d18cd7a201c547fb7ddffc91231.1668727939.git.pabeni@redhat.com>
In-Reply-To: <cover.1668727939.git.pabeni@redhat.com>
References: <cover.1668727939.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While investigating a related issue I stumbled upon another
oops, reproducible as the follow:

ip link add type veth
ip link set dev veth0 xdp object <obj>
ip link set dev veth0 up
ip link set dev veth1 up

The first link up command will enable the napi instances on
veth1 and the second link up common will try again the same
operation, causing the oops.

This change addresses the issue explicitly checking the peer
is up before enabling its napi instances.

Fixes: 2e0de6366ac1 ("veth: Avoid drop packets when xdp_redirect performs")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/veth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 1384134f7100..d541183e0c66 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1343,7 +1343,8 @@ static int veth_open(struct net_device *dev)
 		if (err)
 			return err;
 		/* refer to the logic in veth_xdp_set() */
-		if (!rtnl_dereference(peer_rq->napi)) {
+		if (!rtnl_dereference(peer_rq->napi) &&
+		    (peer->flags & IFF_UP)) {
 			err = veth_napi_enable(peer);
 			if (err)
 				return err;
-- 
2.38.1

