Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEE169597C
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 07:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjBNGyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 01:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjBNGyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 01:54:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C391C7C5
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 22:53:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2166561448
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C681C433D2;
        Tue, 14 Feb 2023 06:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676357638;
        bh=nHIfrtRsFtC9qxNHaabupSCXjVgeyszCDSKGO84F/Bg=;
        h=From:To:Cc:Subject:Date:From;
        b=DezikfyWQR7Rm3MUOf1XGBevxJs/Qu2RDz0nBeP4dRhKzAU754lb0Rf0QZGZjyglt
         /WWfh11Ou/mB+N5D7TF23rKKzaeoNJvCsVFPEn3Nkhi/01muRtGulfMvCTRl+6HdCL
         ru9SXnDGS3ug2rrlyCE7HCU2So4uCssia3NA68/0evoCV4LUeQmi5H4vsUeG6FdDhA
         DOPnTR36BWTKmHCVFuTco7Q7q1NLAJM4jaE65aHg8UvDypJTL06IDOYQoDxTJMEtsn
         l2oCywU98KyZmthHqZMuEwWXSk68B3g9KrvwUCrCERxYJc++tGsAEMBKMYOHsBBgQc
         A4NYxxfH3R1vg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        lianhui tang <bluetlh@gmail.com>, kuniyu@amazon.co.jp,
        gongruiqi1@huawei.com, rshearma@brocade.com
Subject: [PATCH net] net: mpls: fix stale pointer if allocation fails during device rename
Date:   Mon, 13 Feb 2023 22:53:55 -0800
Message-Id: <20230214065355.358890-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lianhui reports that when MPLS fails to register the sysctl table
under new location (during device rename) the old pointers won't
get overwritten and may be freed again (double free).

Handle this gracefully. The best option would be unregistering
the MPLS from the device completely on failure, but unfortunately
mpls_ifdown() can fail. So failing fully is also unreliable.

Another option is to register the new table first then only
remove old one if the new one succeeds. That requires more
code, changes order of notifications and two tables may be
visible at the same time.

sysctl point is not used in the rest of the code - set to NULL
on failures and skip unregister if already NULL.

Reported-by: lianhui tang <bluetlh@gmail.com>
Fixes: 0fae3bf018d9 ("mpls: handle device renames for per-device sysctls")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: kuniyu@amazon.co.jp
CC: gongruiqi1@huawei.com
CC: rshearma@brocade.com
---
 net/mpls/af_mpls.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 35b5f806fdda..dc5165d3eec4 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1428,6 +1428,7 @@ static int mpls_dev_sysctl_register(struct net_device *dev,
 free:
 	kfree(table);
 out:
+	mdev->sysctl = NULL;
 	return -ENOBUFS;
 }
 
@@ -1437,6 +1438,9 @@ static void mpls_dev_sysctl_unregister(struct net_device *dev,
 	struct net *net = dev_net(dev);
 	struct ctl_table *table;
 
+	if (!mdev->sysctl)
+		return;
+
 	table = mdev->sysctl->ctl_table_arg;
 	unregister_net_sysctl_table(mdev->sysctl);
 	kfree(table);
-- 
2.39.1

