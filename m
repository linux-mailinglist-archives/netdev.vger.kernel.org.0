Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B2B3FF8D9
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 04:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344533AbhICC2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 22:28:21 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:41082 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233254AbhICC2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 22:28:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Un3RzCT_1630636038;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Un3RzCT_1630636038)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Sep 2021 10:27:19 +0800
Subject: [PATCH] net: remove the unnecessary check in cipso_v4_doi_free
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
To:     Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c6864908-d093-1705-76ce-94d6af85e092@linux.alibaba.com>
Message-ID: <53f6b3fe-dde3-c35a-5ee1-ff480936b356@linux.alibaba.com>
Date:   Fri, 3 Sep 2021 10:27:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c6864908-d093-1705-76ce-94d6af85e092@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 733c99ee8be9 ("net: fix NULL pointer reference in
cipso_v4_doi_free") was merged by a mistake, this patch try
to cleanup the mess.

And we already have the commit e842cb60e8ac ("net: fix NULL
pointer reference in cipso_v4_doi_free") which fixed the root
cause of the issue mentioned in it's description.

Suggested-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
---
 net/ipv4/cipso_ipv4.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 7fbd0b5..099259f 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -465,16 +465,14 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def)
 	if (!doi_def)
 		return;

-	if (doi_def->map.std) {
-		switch (doi_def->type) {
-		case CIPSO_V4_MAP_TRANS:
-			kfree(doi_def->map.std->lvl.cipso);
-			kfree(doi_def->map.std->lvl.local);
-			kfree(doi_def->map.std->cat.cipso);
-			kfree(doi_def->map.std->cat.local);
-			kfree(doi_def->map.std);
-			break;
-		}
+	switch (doi_def->type) {
+	case CIPSO_V4_MAP_TRANS:
+		kfree(doi_def->map.std->lvl.cipso);
+		kfree(doi_def->map.std->lvl.local);
+		kfree(doi_def->map.std->cat.cipso);
+		kfree(doi_def->map.std->cat.local);
+		kfree(doi_def->map.std);
+		break;
 	}
 	kfree(doi_def);
 }
-- 
1.8.3.1

