Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9402462FEDD
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 21:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiKRUba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 15:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiKRUbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 15:31:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C02E635F
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668803429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XNX9PG9IctWJjJf9clHPMrPEcd0dTkPsQmVfvpSx6A4=;
        b=B4bGdWw6bmbbkkreQcLVS7jvLAXJ7UyaYnp/0UvcVEj0/lI4OBDKg1nngbN8dyqYsf/K55
        Rnam13QgjgrHw3vymtG5XytoJdB8VJQ2+rg6jzlAzUArgVVjOhH8zDe/eJEZ3u4jc0xZxR
        U39K6ENsKAmyNVkNxxtWpZVLpD4oHAg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-vQiax6awNCK70oeC74Zx4Q-1; Fri, 18 Nov 2022 15:30:26 -0500
X-MC-Unique: vQiax6awNCK70oeC74Zx4Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E0C7185A794;
        Fri, 18 Nov 2022 20:30:25 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.10.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB4F4492B04;
        Fri, 18 Nov 2022 20:30:24 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] bonding: fix link recovery in mode 2 when updelay is nonzero
Date:   Fri, 18 Nov 2022 15:30:13 -0500
Message-Id: <cb89b92af89973ee049a696c362b4a2abfdd9b82.1668800711.git.jtoppins@redhat.com>
In-Reply-To: <cover.1668800711.git.jtoppins@redhat.com>
References: <cover.1668800711.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this change when a bond in mode 2 lost link, all of its slaves
lost link, the bonding device would never recover even after the
expiration of updelay. This change removes the updelay when the bond
currently has no usable links. Conforming to bonding.txt section 13.1
paragraph 4.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---
 drivers/net/bonding/bond_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 1cd4e71916f8..6c4348245d1f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2529,7 +2529,16 @@ static int bond_miimon_inspect(struct bonding *bond)
 	struct slave *slave;
 	bool ignore_updelay;
 
-	ignore_updelay = !rcu_dereference(bond->curr_active_slave);
+	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP) {
+		ignore_updelay = !rcu_dereference(bond->curr_active_slave);
+	} else {
+		struct bond_up_slave *usable_slaves;
+
+		usable_slaves = rcu_dereference(bond->usable_slaves);
+
+		if (usable_slaves && usable_slaves->count == 0)
+			ignore_updelay = true;
+	}
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
-- 
2.31.1

