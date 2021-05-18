Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB7B3881E0
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 23:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352454AbhERVKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 17:10:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352364AbhERVKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 17:10:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621372160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=prvD609VA1uqqbSC01aL2lSdSeHhEcopBWufKRbRPx8=;
        b=OL7wZ2+wY7TBPSzsra4mqe/TzLRwLe+MKEVGFGE1Ji3JUOTSTs2V4Q6BxtKdzMjDJ4yQ9o
        e0UEHaIgkCt/AWrBD6YHqRXC2iEWyq+8NWD+z8jt6iLDTub/4eQMvft1/8huuxejtJnhBu
        t0V5ynpowYTCk2cEeo1P7KmhKlBAqsc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-Be5p2DJaNYep39DMoDgl_g-1; Tue, 18 May 2021 17:09:18 -0400
X-MC-Unique: Be5p2DJaNYep39DMoDgl_g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89E288015DB;
        Tue, 18 May 2021 21:09:16 +0000 (UTC)
Received: from f33vm.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 554A95C1A1;
        Tue, 18 May 2021 21:09:15 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH 4/4] bond_alb: put all slaves into promisc
Date:   Tue, 18 May 2021 17:08:49 -0400
Message-Id: <20210518210849.1673577-5-jarod@redhat.com>
In-Reply-To: <20210518210849.1673577-1-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ALB mode bonding can receive on all slaves, so it would seem to make sense
that they're all in promisc, unlike other modes that have a primary
interface and can only receive on that interface.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index d71e398642fb..93f57ff1c552 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -644,9 +644,10 @@ static int bond_check_dev_link(struct bonding *bond,
 static int bond_set_promiscuity(struct bonding *bond, int inc)
 {
 	struct list_head *iter;
-	int err = 0;
+	int mode, err = 0;
 
-	if (bond_uses_primary(bond)) {
+	mode = BOND_MODE(bond);
+	if (mode == BOND_MODE_ACTIVEBACKUP || mode == BOND_MODE_TLB) {
 		struct slave *curr_active = rtnl_dereference(bond->curr_active_slave);
 
 		if (curr_active)
-- 
2.30.2

