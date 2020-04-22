Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239CA1B48A2
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgDVPaH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Apr 2020 11:30:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21901 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDVPaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:30:06 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-lnkXrw4PPRuNd-DRamNMRQ-1; Wed, 22 Apr 2020 11:30:01 -0400
X-MC-Unique: lnkXrw4PPRuNd-DRamNMRQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 748121934102;
        Wed, 22 Apr 2020 15:30:00 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA618100164D;
        Wed, 22 Apr 2020 15:29:58 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Girish Moodalbail <girish.moodalbail@oracle.com>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 1/2] vxlan: use the correct nlattr array in NL_SET_ERR_MSG_ATTR
Date:   Wed, 22 Apr 2020 17:29:50 +0200
Message-Id: <ff880b3e1d14717ccc31594afb10ddd4dde7feae.1587568231.git.sd@queasysnail.net>
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

IFLA_VXLAN_* attributes are in the data array, which is correctly
used when fetching the value, but not when setting the extended
ack. Because IFLA_VXLAN_MAX < IFLA_MAX, we avoid out of bounds
array accesses, but we don't provide a pointer to the invalid
attribute to userspace.

Fixes: 653ef6a3e4af ("vxlan: change vxlan_[config_]validate() to use netlink_ext_ack for error reporting")
Fixes: b4d3069783bc ("vxlan: Allow configuration of DF behaviour")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/vxlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 45308b3350cf..a5b415fed11e 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3144,7 +3144,7 @@ static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
 		u32 id = nla_get_u32(data[IFLA_VXLAN_ID]);
 
 		if (id >= VXLAN_N_VID) {
-			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_ID],
+			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_VXLAN_ID],
 					    "VXLAN ID must be lower than 16777216");
 			return -ERANGE;
 		}
@@ -3155,7 +3155,7 @@ static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
 			= nla_data(data[IFLA_VXLAN_PORT_RANGE]);
 
 		if (ntohs(p->high) < ntohs(p->low)) {
-			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_PORT_RANGE],
+			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_VXLAN_PORT_RANGE],
 					    "Invalid source port range");
 			return -EINVAL;
 		}
@@ -3165,7 +3165,7 @@ static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
 		enum ifla_vxlan_df df = nla_get_u8(data[IFLA_VXLAN_DF]);
 
 		if (df < 0 || df > VXLAN_DF_MAX) {
-			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_DF],
+			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_VXLAN_DF],
 					    "Invalid DF attribute");
 			return -EINVAL;
 		}
-- 
2.26.1

