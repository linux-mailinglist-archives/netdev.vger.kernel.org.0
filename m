Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967DD44D46B
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhKKJzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:55:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230021AbhKKJzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:55:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636624348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1J4Hkczg07QVsxkpKTn8eFrg+rb32UJpeCz7ZqKG7hE=;
        b=F//wLZDGYYe6k9tknkUgbf80JBGYM1qoctGhkgMZkRCbOQA+u71AYpZ+YycQu6E2A/MyGo
        UtBqT+D4wZRslGTqFqrUjjSUL6KfjPGL1SFtV1I7DHpTHsiJdzT7+KDcD6yBJJz/guARIC
        9T1VmcKV48lDd5vRLvFpIZ+EgARL1kg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-9VYL3L-7Ohukq6X2m_AhFw-1; Thu, 11 Nov 2021 04:52:27 -0500
X-MC-Unique: 9VYL3L-7Ohukq6X2m_AhFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EE881023F4E
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 09:52:26 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.40.195.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B01365D6D7
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 09:52:25 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2] mptcp: fix JSON output when dumping endpoints by id
Date:   Thu, 11 Nov 2021 10:52:13 +0100
Message-Id: <474b741a13ba1058dd991c4f68f68b99610dda2b.1636623282.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iproute ignores '-j' command line argument when dumping endpoints by id:

 [dcaratti@dcaratti iproute2]$ ./ip/ip -j mptcp endpoint show
 [{"address":"1.2.3.4","id":42,"signal":true,"backup":true}]
 [dcaratti@dcaratti iproute2]$ ./ip/ip -j mptcp endpoint show id 42
 1.2.3.4 id 42 signal backup

fix mptcp_addr_show() to use the proper JSON helpers.

Fixes: 7e0767cd862b ("add support for mptcp netlink interface")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 ip/ipmptcp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index 0f5b6e2d08ba..857004446aa3 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -305,7 +305,11 @@ static int mptcp_addr_show(int argc, char **argv)
 	if (rtnl_talk(&genl_rth, &req.n, &answer) < 0)
 		return -2;
 
-	return print_mptcp_addr(answer, stdout);
+	new_json_obj(json);
+	ret = print_mptcp_addr(answer, stdout);
+	delete_json_obj();
+	fflush(stdout);
+	return ret;
 }
 
 static int mptcp_addr_flush(int argc, char **argv)
-- 
2.31.1

