Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C2641DD40
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 17:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245663AbhI3PVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 11:21:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245617AbhI3PVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 11:21:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633015181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+5+u6ZvBHS0L9a3SN/PDZ2qEIz0CiXjQSggz4/0Z7Ic=;
        b=Vb5XQep0R1HXWNgKin5tzBv9yrauUByx+WN8qJx3tY7jtw4oXZRAApt4oxecQunCqwEaUv
        nphuo07J6ZE8IpGdhUAw97c2ZO7gxpt0FS5THknAGU5KimtzwoYv+xEUZyvLo0xhrepv6N
        xDpldFymnuz1cCT4C3HU2ohPxRCMF3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-MqcfVoCtNM-FfKSor13Pnw-1; Thu, 30 Sep 2021 11:19:38 -0400
X-MC-Unique: MqcfVoCtNM-FfKSor13Pnw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF92B8145E7;
        Thu, 30 Sep 2021 15:19:36 +0000 (UTC)
Received: from dcaratti.station (unknown [10.40.193.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5377B5D6D5;
        Thu, 30 Sep 2021 15:19:35 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     aclaudi@redhat.com, pabeni@redhat.com,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     mptcp@lists.linux.dev, netdev@vger.kernel.org
Subject: [PATCH iproute2] mptcp: unbreak JSON endpoint list
Date:   Thu, 30 Sep 2021 17:19:25 +0200
Message-Id: <b526544bc745535f72c76752bbd850df5a0ac2e4.1633004460.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the following command:

 # ip -j mptcp endpoint show

prints a JSON array that misses the terminating bracket. Fix this calling
delete_json_obj() to balance the call to new_json_obj().

Fixes: 7e0767cd862b ("add support for mptcp netlink interface")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 ip/ipmptcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index bc12418bd39c..25d7d6784f89 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -262,7 +262,7 @@ static int mptcp_addr_dump(void)
 		return -2;
 	}
 
-	close_json_object();
+	delete_json_obj();
 	fflush(stdout);
 	return 0;
 }
-- 
2.31.1

