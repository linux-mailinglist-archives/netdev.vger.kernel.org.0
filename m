Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10032591DE
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgIAO5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:57:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35062 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726984AbgIAO4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 10:56:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598972169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tts+/n5fKKguC6dslwzbBF2QsvaeACvyC/FAJiUkX/Y=;
        b=Xj6fGPAPIFADFo4R7vkoH1m34/BwHQLmS/k9ZDLqnG1liNpxgNbS5LsGAlogrtsfc873hx
        xvDLtEidtqyEU7I43LFsOksaY/nvtF0vpgzBnReG/elwKWWe50eIfwJ0A16MC9/H/YXn8V
        96hEQTzmR8nKyOtnVJEHUqOE0xdU884=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-6kQZE2SHM-WTqAlMoPBT_Q-1; Tue, 01 Sep 2020 10:56:07 -0400
X-MC-Unique: 6kQZE2SHM-WTqAlMoPBT_Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D78BF10ABDAB
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:56:06 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-114-213.ams2.redhat.com [10.36.114.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61DEF5D9CC
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:56:06 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net-net] netfilter: conntrack: nf_conncount_init is failing with IPv6 disabled
Date:   Tue,  1 Sep 2020 16:56:02 +0200
Message-Id: <159897212470.60236.5737844268627410321.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The openvswitch module fails initialization when used in a kernel
without IPv6 enabled. nf_conncount_init() fails because the ct code
unconditionally tries to initialize the netns IPv6 related bit,
regardless of the build option. The change below ignores the IPv6
part if not enabled.

Note that the corresponding _put() function already has this IPv6
configuration check.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 net/netfilter/nf_conntrack_proto.c |    2 ++
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
 

