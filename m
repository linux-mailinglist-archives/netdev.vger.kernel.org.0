Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0101B48A3
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgDVPaK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Apr 2020 11:30:10 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58191 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDVPaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:30:09 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-72c2-2A3N0qvyEWiOqCh4g-1; Wed, 22 Apr 2020 11:30:03 -0400
X-MC-Unique: 72c2-2A3N0qvyEWiOqCh4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B1AC801E53;
        Wed, 22 Apr 2020 15:30:02 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D46751000079;
        Wed, 22 Apr 2020 15:30:00 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Girish Moodalbail <girish.moodalbail@oracle.com>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 2/2] geneve: use the correct nlattr array in NL_SET_ERR_MSG_ATTR
Date:   Wed, 22 Apr 2020 17:29:51 +0200
Message-Id: <ba68c6eafb5bf763d9b2188d750867753b900d43.1587568231.git.sd@queasysnail.net>
In-Reply-To: <cover.1587568231.git.sd@queasysnail.net>
References: <cover.1587568231.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IFLA_GENEVE_* attributes are in the data array, which is correctly
used when fetching the value, but not when setting the extended
ack. Because IFLA_GENEVE_MAX < IFLA_MAX, we avoid out of bounds
array accesses, but we don't provide a pointer to the invalid
attribute to userspace.

Fixes: a025fb5f49ad ("geneve: Allow configuration of DF behaviour")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/geneve.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 09f279c0182b..6b461be1820b 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1207,7 +1207,7 @@ static int geneve_validate(struct nlattr *tb[], struct nlattr *data[],
 		enum ifla_geneve_df df = nla_get_u8(data[IFLA_GENEVE_DF]);
 
 		if (df < 0 || df > GENEVE_DF_MAX) {
-			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_GENEVE_DF],
+			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_GENEVE_DF],
 					    "Invalid DF attribute");
 			return -EINVAL;
 		}
-- 
2.26.1

