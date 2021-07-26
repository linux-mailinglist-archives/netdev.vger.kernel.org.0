Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B455C3D6A38
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 01:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhGZWt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 18:49:56 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3350 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233707AbhGZWtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 18:49:55 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16QNHk5s015555;
        Mon, 26 Jul 2021 23:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=4zAQoXb0cViuQyWT4ENIPKY53APJdMlLm3HEKlcjRCg=;
 b=XOJ8Q/OqSjPkGJ5GNIc4poe6b0h5dClTj4kn4WllOZAA7tbwRpnBPQAPf3GWtS4zmFSR
 qgqhOhTXU0PmSg/YUJtUVDuYY9fJWq2jOXQgH5GSf9w6iRZuyN33PaEsfZzIiD8qaV7+
 YB0tAUQJT73yvUgk8MQhXCy0CGNQdoYOIZQlMXQlAS7ylrwtF0JwG0r2J2/mIgk2nQ9H
 AyF23jBuxEtbdS/ugKByvJhIJFZFlEakkOOR3HU4vr0GWbEVySZLnAyisnWf1at2vqus
 OJ3mOmLnYJWTS3I16YGkSzGswt9u9KLq1NII/1V8vc3bipYhALvumWntXBD5zCvhaAMZ NQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=4zAQoXb0cViuQyWT4ENIPKY53APJdMlLm3HEKlcjRCg=;
 b=PeISs21IzVWIAYR65UeCWAXg6IcjxeUHcWAU7SXKlQKQ3S4x+NSmmqzfqCFEKSrhlMyw
 IW9q/pU3pUgVRMD22wkSoANLWiwwKfzpvdsJoPq1WTZUA3zpU4u4tHSnU5hxS1Ot7aII
 QAMagrCpbU5cpCNpB71za4ZOV71ACj4PCpLDomlVYHtd3H8G33reDo2wuhKE076D3brv
 jROmnGClz0iLc6A9N4j3xf5N+pXgLIYqMGL3UlPq1aGWW5kW6BVXzvlDOmCNYMmjyxLb
 9JPg05pF19KuOFjDSG6Q+42qKz8dLGqCiKb9x3EZ7i3piMTgqHCv+nwx2V2EybXtYFPd vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2356gc7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 23:29:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16QLafMj135461;
        Mon, 26 Jul 2021 23:29:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3a234uawpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 23:29:04 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 16QNT3OW057951;
        Mon, 26 Jul 2021 23:29:03 GMT
Received: from manjaro.in.oracle.com (dhcp-10-166-172-209.vpn.oracle.com [10.166.172.209])
        by userp3020.oracle.com with ESMTP id 3a234uawn2-1;
        Mon, 26 Jul 2021 23:29:03 +0000
From:   Harshvardhan Jha <harshvardhan.jha@oracle.com>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshvardhan Jha <harshvardhan.jha@oracle.com>
Subject: [PATCH] net: xfrm: Fix end of loop tests for list_for_each_entry
Date:   Tue, 27 Jul 2021 04:58:52 +0530
Message-Id: <20210726232852.216392-1-harshvardhan.jha@oracle.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: gp-yp8Z9haS0r6HO05wsiRd3API3v573
X-Proofpoint-GUID: gp-yp8Z9haS0r6HO05wsiRd3API3v573
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The list_for_each_entry() iterator, "pos" in this code, can never be
NULL so the warning will never be printed.

Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
---
From static analysis.  Not tested.
---
 net/xfrm/xfrm_ipcomp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index 2e8afe078d61..cb40ff0ff28d 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -241,7 +241,7 @@ static void ipcomp_free_tfms(struct crypto_comp * __percpu *tfms)
 			break;
 	}
 
-	WARN_ON(!pos);
+	WARN_ON(list_entry_is_head(pos, &ipcomp_tfms_list, list));
 
 	if (--pos->users)
 		return;
-- 
2.32.0

