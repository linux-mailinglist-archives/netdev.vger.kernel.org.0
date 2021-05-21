Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768B538C809
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbhEUN35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:29:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235428AbhEUN3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:29:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621603695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qwvdXWfkvGdDNbwDsLlh0GW23kpfk2LfAOvdZQXaciI=;
        b=Cp16oTrI855tfTrodzGTDrvOEmsKsVh6dT4McfhuQYCkM+L4knb1dHxHmbxNfpnHLpJihz
        4iCxv4gen6pVYhps34FcX2xzGESmTBv2T315j2lle1agV2gvB5Bf8ICvPrtTcepXWnuZ0O
        7M9HI3UR9veYmPjtDQMWDFc3vj9Q8YY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-F32ZlwWJM9a79KpVuHpCEA-1; Fri, 21 May 2021 09:28:14 -0400
X-MC-Unique: F32ZlwWJM9a79KpVuHpCEA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F08B66414C;
        Fri, 21 May 2021 13:28:12 +0000 (UTC)
Received: from f33vm.wilsonet.com.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9E91100AE43;
        Fri, 21 May 2021 13:28:11 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 4/4] bonding/balance-alb: put all slaves into promisc
Date:   Fri, 21 May 2021 09:27:56 -0400
Message-Id: <20210521132756.1811620-5-jarod@redhat.com>
In-Reply-To: <20210521132756.1811620-1-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com>
 <20210521132756.1811620-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike most other modes with a primary interface, ALB mode bonding can
receive on all slaves. That includes traffic destined for a non-local MAC
behind a bridge on top of the bond. Such traffic gets dropped if the
interface isn't in promiscuous mode. Therefore, it would seem to make
sense to put all slaves into promisc.

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
index 32785e9d0295..6d95f9e46059 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -647,9 +647,10 @@ static int bond_check_dev_link(struct bonding *bond,
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

