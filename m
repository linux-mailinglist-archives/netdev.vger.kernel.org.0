Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AC8553C18
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 22:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355693AbiFUUyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 16:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354919AbiFUUwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 16:52:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25E402FE5C
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 13:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655844539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1ZiU/FWNuW0DHUEQT+r8cgWumVWHOL8vQv6l7HeOPfE=;
        b=I3QkpANbXT1EyxGz4hk6gBNo8iP/IpjlGuKHEsaDXDYuFGOI5PhJNKgmJI+RhZms24Yo5J
        CBWV458P3ilH6JTyjTcl/TQXWVHjKjNktqZEldXx/htyDpFLinpDOCcJvxya03k2Prxc4L
        MiGubxnQCi1ydfg2xaNj+Pipa5BQrOs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-XJPZIo6ZPpiTmRO4u21yww-1; Tue, 21 Jun 2022 16:48:54 -0400
X-MC-Unique: XJPZIo6ZPpiTmRO4u21yww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3168D80A0AD;
        Tue, 21 Jun 2022 20:48:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.22.12.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A15F640CF8E2;
        Tue, 21 Jun 2022 20:48:52 +0000 (UTC)
From:   Rosemarie O'Riorden <roriorden@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yi-Hung Wei <yihung.wei@gmail.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, i.maximets@ovn.org,
        aconole@redhat.com
Subject: [PATCH net] net: openvswitch: fix parsing of nw_proto for IPv6 fragments
Date:   Tue, 21 Jun 2022 16:48:45 -0400
Message-Id: <20220621204845.9721-1-roriorden@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a packet enters the OVS datapath and does not match any existing
flows installed in the kernel flow cache, the packet will be sent to
userspace to be parsed, and a new flow will be created. The kernel and
OVS rely on each other to parse packet fields in the same way so that
packets will be handled properly.

As per the design document linked below, OVS expects all later IPv6
fragments to have nw_proto=44 in the flow key, so they can be correctly
matched on OpenFlow rules. OpenFlow controllers create pipelines based
on this design.

This behavior was changed by the commit in the Fixes tag so that
nw_proto equals the next_header field of the last extension header.
However, there is no counterpart for this change in OVS userspace,
meaning that this field is parsed differently between OVS and the
kernel. This is a problem because OVS creates actions based on what is
parsed in userspace, but the kernel-provided flow key is used as a match
criteria, as described in Documentation/networking/openvswitch.rst. This
leads to issues such as packets incorrectly matching on a flow and thus
the wrong list of actions being applied to the packet. Such changes in
packet parsing cannot be implemented without breaking the userspace.

The offending commit is partially reverted to restore the expected
behavior.

The change technically made sense and there is a good reason that it was
implemented, but it does not comply with the original design of OVS.
If in the future someone wants to implement such a change, then it must
be user-configurable and disabled by default to preserve backwards
compatibility with existing OVS versions.

Cc: stable@vger.kernel.org
Fixes: fa642f08839b ("openvswitch: Derive IP protocol number for IPv6 later frags")
Link: https://docs.openvswitch.org/en/latest/topics/design/#fragments
Signed-off-by: Rosemarie O'Riorden <roriorden@redhat.com>
---
 net/openvswitch/flow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 372bf54a0ca9..e20d1a973417 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -407,7 +407,7 @@ static int parse_ipv6hdr(struct sk_buff *skb, struct sw_flow_key *key)
 	if (flags & IP6_FH_F_FRAG) {
 		if (frag_off) {
 			key->ip.frag = OVS_FRAG_TYPE_LATER;
-			key->ip.proto = nexthdr;
+			key->ip.proto = NEXTHDR_FRAGMENT;
 			return 0;
 		}
 		key->ip.frag = OVS_FRAG_TYPE_FIRST;
-- 
2.35.3

