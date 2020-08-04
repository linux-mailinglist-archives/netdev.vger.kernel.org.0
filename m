Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013FC23B7E1
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 11:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHDJiG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Aug 2020 05:38:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24317 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725832AbgHDJiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 05:38:06 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-qqoVngGqM1az5WGxut45VA-1; Tue, 04 Aug 2020 05:38:01 -0400
X-MC-Unique: qqoVngGqM1az5WGxut45VA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51E2518FF662;
        Tue,  4 Aug 2020 09:38:00 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB145709F5;
        Tue,  4 Aug 2020 09:37:58 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>,
        Xiumei Mu <xmu@redhat.com>
Subject: [PATCH ipsec] xfrmi: drop ignore_df check before updating pmtu
Date:   Tue,  4 Aug 2020 11:37:29 +0200
Message-Id: <70e7c2a65afed5de117dbc16082def459bd39d93.1596531053.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm interfaces currently test for !skb->ignore_df when deciding
whether to update the pmtu on the skb's dst. Because of this, no pmtu
exception is created when we do something like:

    ping -s 1438 <dest>

By dropping this check, the pmtu exception will be created and the
next ping attempt will work.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index b615729812e5..ade2eba863b3 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -292,7 +292,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	}
 
 	mtu = dst_mtu(dst);
-	if (!skb->ignore_df && skb->len > mtu) {
+	if (skb->len > mtu) {
 		skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 		if (skb->protocol == htons(ETH_P_IPV6)) {
-- 
2.27.0

