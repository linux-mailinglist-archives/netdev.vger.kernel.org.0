Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4BD57D884
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 11:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbfHAJYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 05:24:37 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35052 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbfHAJYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 05:24:36 -0400
Received: by mail-ed1-f68.google.com with SMTP id w20so68466107edd.2
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 02:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=uJNkOd++pppj92RNQe5KBNkfejV/glRIA4r/SLzP8s4=;
        b=g4r85uAclV6cDzf5fvORykZhJ6uZOPZUY6zG01G626U9tjGOe08GLOKdpNff/h4gEp
         8O8NCTC4rt72KsFOgQ/e3dy1wq/S5mudwl1fWXWup9hhJ+66fTugEAWMz0H3EZ3yptZL
         eIaPIvX2kVj/IXq+ywEabvQ02GS5IxZrq/3DsD6IPtlMWsqyc8KsvyZI9noVSk9qx1HF
         VysN3xSzQIPGRHjlXxp4JKpT6Leph6Kq0Y5JKaGKCKhtjLW7FqmgqkllBIco4JG0DErR
         brNBAoryHStxMHT14nBdLdywE8uNASk4riqklYGtgOk4TH06G3ruuC68lV8gP3ddyzdF
         Y9yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uJNkOd++pppj92RNQe5KBNkfejV/glRIA4r/SLzP8s4=;
        b=WcegDekGuxCnxPFek30sbaujEufxM04bY+t41HZDNQ3shX95cXnRjadOd7UqWh/8UJ
         m244qqKMTgW6L6QEdu1bJ7/k5ZGiADjjJfV2yEJsMAOE5EvuZH+0Hg6OGPlDvvO+hKtq
         frwpPlbVZ6d7Q9/IcdSiSzBhN/WUhl72rB8ihXUpdwJXoZePGlIwt2MC2O2ZAiqqkMU3
         6U2CORTML6P626V86AYygjDyn+zmTtE+JguSgTH/A6F390NbudMnf5GlLb9aXtysn641
         GitMGBj/zhZiNSCDWaMY8Ty17uO13F6raUmCWr49mOk/qzL7E3pMXP8FEX5aUOyKym14
         j1Cw==
X-Gm-Message-State: APjAAAWNz7x8oQV/dsfBR6Ah9gd3CRVVUx6HSXRqAjy6Pqkr1rKeEqKY
        gw9TQkUgKI2PNczjmknOObw=
X-Google-Smtp-Source: APXvYqzGl0IWvEhiBwg9Iq1A/QYB49PWn4ghmag1VSZ67z3eyNPoAG3yjCj3a+K6rqJkJWB6M8Oseg==
X-Received: by 2002:a17:906:684e:: with SMTP id a14mr100128691ejs.156.1564651475318;
        Thu, 01 Aug 2019 02:24:35 -0700 (PDT)
Received: from tegmen.arch.suse.de (charybdis-ext.suse.de. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id w14sm17856075eda.69.2019.08.01.02.24.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 02:24:34 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com
Cc:     netdev@vger.kernel.org, Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH v2 net-next] be2net: disable bh with spin_lock in be_process_mcc
Date:   Thu,  1 Aug 2019 11:24:20 +0200
Message-Id: <20190801092420.34502-1-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

be_process_mcc() is invoked in 3 different places and
always with BHs disabled except the be_poll function
but since it's invoked from softirq with BHs
disabled it won't hurt.

v1->v2: added explanation to the patch

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 4 ++--
 drivers/net/ethernet/emulex/benet/be_main.c | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index ef5d61d57597..9365218f4d3b 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -550,7 +550,7 @@ int be_process_mcc(struct be_adapter *adapter)
 	int num = 0, status = 0;
 	struct be_mcc_obj *mcc_obj = &adapter->mcc_obj;
 
-	spin_lock(&adapter->mcc_cq_lock);
+	spin_lock_bh(&adapter->mcc_cq_lock);
 
 	while ((compl = be_mcc_compl_get(adapter))) {
 		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
@@ -566,7 +566,7 @@ int be_process_mcc(struct be_adapter *adapter)
 	if (num)
 		be_cq_notify(adapter, mcc_obj->cq.id, mcc_obj->rearm_cq, num);
 
-	spin_unlock(&adapter->mcc_cq_lock);
+	spin_unlock_bh(&adapter->mcc_cq_lock);
 	return status;
 }
 
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 2edb86ec9fe9..4d8e40ac66d2 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5630,9 +5630,7 @@ static void be_worker(struct work_struct *work)
 	 * mcc completions
 	 */
 	if (!netif_running(adapter->netdev)) {
-		local_bh_disable();
 		be_process_mcc(adapter);
-		local_bh_enable();
 		goto reschedule;
 	}
 
-- 
2.12.3

