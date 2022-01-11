Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B48048B081
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 16:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239990AbiAKPLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 10:11:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231876AbiAKPLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 10:11:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641913862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ACG22Ukf9xYb+1D615AFQrmyGemNLEx+9B+DT3tB8nM=;
        b=LN++eZQc/O/f3bcb0Iyw505jkp7eooU2Wb/SMhu2wNe65xHZg8cyZl7mXWPr3z50EGML9d
        3tctejsaIzkl5sQDo2T6t6lPFb1Df1seMWGCvh7TPlWqg9Thmi1Apj0Fuofm02sfJWNIsF
        q4SsZhrKDn2507EXFF3R3d38ECvsH2E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-fx9cWIMdOiS0mHMsT61-gw-1; Tue, 11 Jan 2022 10:10:58 -0500
X-MC-Unique: fx9cWIMdOiS0mHMsT61-gw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B5B385EE98;
        Tue, 11 Jan 2022 15:10:55 +0000 (UTC)
Received: from queeg.tpb.lab.eng.brq.redhat.com (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 876A4105C896;
        Tue, 11 Jan 2022 15:10:54 +0000 (UTC)
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH net] net: fix sock_timestamping_bind_phc() to release device
Date:   Tue, 11 Jan 2022 16:10:53 +0100
Message-Id: <20220111151053.4112161-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't forget to release the device in sock_timestamping_bind_phc() after
it was used to get the vclock indices.

Fixes: d463126e23f1 ("net: sock: extend SO_TIMESTAMPING for PHC binding")
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
---
 net/core/sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index e21485ab285d..f32ec08a0c37 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -844,6 +844,8 @@ static int sock_timestamping_bind_phc(struct sock *sk, int phc_index)
 	}
 
 	num = ethtool_get_phc_vclocks(dev, &vclock_index);
+	dev_put(dev);
+
 	for (i = 0; i < num; i++) {
 		if (*(vclock_index + i) == phc_index) {
 			match = true;
-- 
2.33.1

