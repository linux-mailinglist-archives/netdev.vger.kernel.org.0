Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FCD21172E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgGBA2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:28:16 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:47378 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbgGBA1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:27:48 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 87EAD891B0;
        Thu,  2 Jul 2020 12:27:47 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1593649667;
        bh=1hGb1RxRhBMGgjCYb9g+byDx9YMhV5xl7DB9Z5xqZRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Bqm1wtf9YrY11HE8ovfd5zFjCs7cnm1RqRS5SDwk9Hfao2foBe+itXXzCvOkYkcT2
         m93iMrPyh3GSM9qXFWwU6eoSbBoCWivbgl3M3tIiVITptyXTqkcpvHZV1dXBqxLch2
         dVm625Q+1tAcFq0lRsP2z90g7352jiTlnnGny+wsAvwnitVCqTM5tqYYOtAPF2Bplb
         gjpSfgaxUJqe4ah5WkFmdhJQqTdDbRogLXxcRhLwgdxjG5jul/D59daN6xtXkCMM6r
         NjSFgsx7XkzxGO+T9yFn2/dvGr6O1f4POZrcZZCPc9vb9pYZZJgkkyn4FrsF5T0q63
         dRWw0NI01xuOw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5efd2a030000>; Thu, 02 Jul 2020 12:27:47 +1200
Received: from mattb-dl.ws.atlnz.lc (mattb-dl.ws.atlnz.lc [10.33.25.34])
        by smtp (Postfix) with ESMTP id BB5A013EDDC;
        Thu,  2 Jul 2020 12:27:45 +1200 (NZST)
Received: by mattb-dl.ws.atlnz.lc (Postfix, from userid 1672)
        id 452094A02A3; Thu,  2 Jul 2020 12:27:47 +1200 (NZST)
From:   Matt Bennett <matt.bennett@alliedtelesis.co.nz>
To:     netdev@vger.kernel.org
Cc:     zbr@ioremap.net, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org,
        Matt Bennett <matt.bennett@alliedtelesis.co.nz>
Subject: [PATCH 3/5] connector: Ensure callback entry is released
Date:   Thu,  2 Jul 2020 12:26:33 +1200
Message-Id: <20200702002635.8169-4-matt.bennett@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the entry itself appears to be being leaked.

Signed-off-by: Matt Bennett <matt.bennett@alliedtelesis.co.nz>
---
 drivers/connector/cn_queue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 49295052ba8b..a82ceeb37f26 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -132,8 +132,10 @@ void cn_queue_free_dev(struct cn_queue_dev *dev)
 	struct cn_callback_entry *cbq, *n;
=20
 	spin_lock_bh(&dev->queue_lock);
-	list_for_each_entry_safe(cbq, n, &dev->queue_list, callback_entry)
+	list_for_each_entry_safe(cbq, n, &dev->queue_list, callback_entry) {
 		list_del(&cbq->callback_entry);
+		cn_queue_release_callback(cbq);
+	}
 	spin_unlock_bh(&dev->queue_lock);
=20
 	while (atomic_read(&dev->refcnt)) {
--=20
2.27.0

