Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2B03F8135
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 05:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbhHZDnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 23:43:33 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:17988 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231720AbhHZDnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 23:43:32 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Um0c2GM_1629949362;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Um0c2GM_1629949362)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 26 Aug 2021 11:42:43 +0800
To:     Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: [PATCH] net: fix NULL pointer reference in cipso_v4_doi_free
Message-ID: <c6864908-d093-1705-76ce-94d6af85e092@linux.alibaba.com>
Date:   Thu, 26 Aug 2021 11:42:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In netlbl_cipsov4_add_std() when 'doi_def->map.std' alloc
failed, we sometime observe panic:

  BUG: kernel NULL pointer dereference, address:
  ...
  RIP: 0010:cipso_v4_doi_free+0x3a/0x80
  ...
  Call Trace:
   netlbl_cipsov4_add_std+0xf4/0x8c0
   netlbl_cipsov4_add+0x13f/0x1b0
   genl_family_rcv_msg_doit.isra.15+0x132/0x170
   genl_rcv_msg+0x125/0x240

This is because in cipso_v4_doi_free() there is no check
on 'doi_def->map.std' when 'doi_def->type' equal 1, which
is possibe, since netlbl_cipsov4_add_std() haven't initialize
it before alloc 'doi_def->map.std'.

This patch just add the check to prevent panic happen for similar
cases.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
---

 net/ipv4/cipso_ipv4.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 099259f..7fbd0b5 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -465,14 +465,16 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def)
 	if (!doi_def)
 		return;

-	switch (doi_def->type) {
-	case CIPSO_V4_MAP_TRANS:
-		kfree(doi_def->map.std->lvl.cipso);
-		kfree(doi_def->map.std->lvl.local);
-		kfree(doi_def->map.std->cat.cipso);
-		kfree(doi_def->map.std->cat.local);
-		kfree(doi_def->map.std);
-		break;
+	if (doi_def->map.std) {
+		switch (doi_def->type) {
+		case CIPSO_V4_MAP_TRANS:
+			kfree(doi_def->map.std->lvl.cipso);
+			kfree(doi_def->map.std->lvl.local);
+			kfree(doi_def->map.std->cat.cipso);
+			kfree(doi_def->map.std->cat.local);
+			kfree(doi_def->map.std);
+			break;
+		}
 	}
 	kfree(doi_def);
 }
-- 
1.8.3.1

