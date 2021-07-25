Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23613D4F53
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 19:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhGYRO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 13:14:26 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18390 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhGYROZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 13:14:25 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16PHpjim003642;
        Sun, 25 Jul 2021 17:54:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=4zAQoXb0cViuQyWT4ENIPKY53APJdMlLm3HEKlcjRCg=;
 b=TR6lQNLcvEm01Og88pPjny6vU45kqGk6Fqst+LRO4yN1Zy/1trBL5sNFoPptHgu2tYGm
 iuWWEot9MlRCbk0aHVkDC8dmrvzHIoggmUV3T+nbL7ECQnGVR0+Tg1a/3KOj5n1AQIUt
 Jlvo8OZv5TuvujOy7nXBCA+1JMMrTFLbrP7RJLrLN0vEd/mnPPWhpdVoiwLoLNtP0/iv
 c2ouqFd17+x5CA0L36Rr2u6icM2NrpHZsoSuoF84/mIQm7JPOR9+QqPJn7RUWOmIiqIW
 ZLROAG/eYT9JroOxFYGls9BYHCW39G+MF3Xl6f6w4ytdujg/ggqJ/Pwp5uGWvMp/42TK 1A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=4zAQoXb0cViuQyWT4ENIPKY53APJdMlLm3HEKlcjRCg=;
 b=WSMm7ML8wNMe9eCE1dbsTTdZ5VxH7cunzRuVSBw0Tvuo6orPeeb3P5yilr9KcEzZZh1Q
 reDiYT5HTMYy+p3o7ZcZhATJ+ey0SGwzd/ZeQwi/9KcxcoMdoXQ0K39q/tktnA4yxFmp
 L9pKIJBIwrz7noghDwBISQgnaPnagiX2souXDTNbX63sVW1Q5f3QMU8jKNqKZ6Z2cr9O
 gR0vdxP9jsP4JsvSvgmQXEJT+aJ96GX4T2uEM7Q8of6mWgrW8BB/YCJUv0mtXwlmbBTN
 JH48rdip8qvGO9qVkeJJBx+3belE22me1za505mHNdA03j2fMC+W3sGRsNl3Q7bnx8Zb Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a0afrsm37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Jul 2021 17:54:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16PHokFH074395;
        Sun, 25 Jul 2021 17:54:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3a07yu0yan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Jul 2021 17:54:11 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 16PHsBoN083551;
        Sun, 25 Jul 2021 17:54:11 GMT
Received: from manjaro.in.oracle.com (dhcp-10-191-232-135.vpn.oracle.com [10.191.232.135])
        by userp3030.oracle.com with ESMTP id 3a07yu0y9c-1;
        Sun, 25 Jul 2021 17:54:11 +0000
From:   Harshvardhan Jha <harshvardhan.jha@oracle.com>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshvardhan Jha <harshvardhan.jha@oracle.com>
Subject: [PATCH net] net: xfrm: Fix end of loop tests for list_for_each_entry
Date:   Sun, 25 Jul 2021 23:23:55 +0530
Message-Id: <20210725175354.59137-1-harshvardhan.jha@oracle.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: A2iDw3I_1rCjdIFjzvIBqp_h0-rS11eQ
X-Proofpoint-GUID: A2iDw3I_1rCjdIFjzvIBqp_h0-rS11eQ
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

