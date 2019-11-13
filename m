Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD688FB91C
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKMTsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:48:05 -0500
Received: from smtp.uniroma2.it ([160.80.6.16]:57695 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbfKMTsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 14:48:05 -0500
X-Greylist: delayed 1019 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Nov 2019 14:47:58 EST
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id xADJTiml023525
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Nov 2019 20:30:27 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Lebrun <dav.lebrun@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next, 1/3] seg6: verify srh pointer in get_srh()
Date:   Wed, 13 Nov 2019 20:29:10 +0100
Message-Id: <20191113192912.17546-2-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113192912.17546-1-andrea.mayer@uniroma2.it>
References: <20191113192912.17546-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pskb_may_pull may change pointers in header. For this reason, it is
mandatory to reload any pointer that points into skb header.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 9d4f75e0d33a..e187dec2eed1 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -75,12 +75,16 @@ static struct ipv6_sr_hdr *get_srh(struct sk_buff *skb)
 		return NULL;
 
 	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
-
 	len = (srh->hdrlen + 1) << 3;
 
 	if (!pskb_may_pull(skb, srhoff + len))
 		return NULL;
 
+	/* note that pskb_may_pull may change pointers in header;
+	 * for this reason it is necessary to reload them when needed.
+	 */
+	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
+
 	if (!seg6_validate_srh(srh, len))
 		return NULL;
 
-- 
2.20.1

