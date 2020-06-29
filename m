Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC94020E20A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733117AbgF2VCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731181AbgF2TMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:12:53 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99941C08EB2B
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:34:59 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q90so6826639pjh.3
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C1PIbvf/F3pEJD8SJioHJm7gGXKJLRSVJjjUJ3WEdiI=;
        b=OfFhTog40k5OsM9Hi9LnyG3SE0pp4HdK1CWoHrxZniAU+e7la1Lf9tqBcmSYzOz5Tg
         4Azzid4HVE1TUlsHWZ6n1bKa8VKNDN7PrkuI94ld4+hvcdT8k9ZwYVEFxVCDFV9acQo2
         RqUWG13V3r4XDjBlSHeP2xNS7asw5Pgw8647U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C1PIbvf/F3pEJD8SJioHJm7gGXKJLRSVJjjUJ3WEdiI=;
        b=jkRwgNe2joZ9tACZwBpFlfQt8wf71SwIRjRBsgaa6a7nH7LH8fa8o4sXH0a0YI3Qcf
         5e7COJ8FLbMlwABHS69bBAbhKdjdMp+MsSZMjjOWF3+IkylnV7eT/Y3L0MBy6BY6sXxH
         TfALzkG6VW8aHoFs2chfym0xudKc++sQWBzKep5Ic95r2Vd47p4U4VdzKHczYxBn1VUx
         99rWntFiHB8tSib8/ggZl5TtZs5pJnH6vf03aTEjY1Zekyx7AkYqC9LIiA+P04w31VHt
         qmHDdEmSKkrqQQmavtD/quXbuEfop/MAtTX/eK/Gxp6kon0RitQIr2AhAlM9dJ1hwon6
         6zJA==
X-Gm-Message-State: AOAM530ALylbQfCEqCx+CtTr05W2Y3MC76ikscanJ/ILwti2E1N2aImD
        nBcL9Lmjt6jC8tl7rOYLmIkbKA==
X-Google-Smtp-Source: ABdhPJzqIgGEYcpH01O/2ggmb1uHrKpWjQJwtP7pEQgXcaMZCn1NIRnDh/rFJetfzFjolwrJacN3hw==
X-Received: by 2002:a17:902:b60c:: with SMTP id b12mr11519801pls.96.1593412498873;
        Sun, 28 Jun 2020 23:34:58 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i125sm28058416pgd.21.2020.06.28.23.34.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jun 2020 23:34:58 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 5/8] bnxt_en: Return correct RSS indirection table entries to ethtool -x.
Date:   Mon, 29 Jun 2020 02:34:21 -0400
Message-Id: <1593412464-503-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have the logical indirection table, we can return these
proper logical indices directly to ethtool -x instead of the physical
IDs.

Reported-by: Jakub Kicinski <kicinski@fb.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 6b88143..46f3978 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1275,6 +1275,12 @@ static int bnxt_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 
 static u32 bnxt_get_rxfh_indir_size(struct net_device *dev)
 {
+	struct bnxt *bp = netdev_priv(dev);
+
+	if (bp->flags & BNXT_FLAG_CHIP_P5) {
+		return (bp->rx_nr_rings + BNXT_RSS_TABLE_ENTRIES_P5 - 1) &
+		       ~(BNXT_RSS_TABLE_ENTRIES_P5 - 1);
+	}
 	return HW_HASH_INDEX_SIZE;
 }
 
@@ -1288,7 +1294,7 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_vnic_info *vnic;
-	int i = 0;
+	u32 i, tbl_size;
 
 	if (hfunc)
 		*hfunc = ETH_RSS_HASH_TOP;
@@ -1297,9 +1303,10 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 		return 0;
 
 	vnic = &bp->vnic_info[0];
-	if (indir && vnic->rss_table) {
-		for (i = 0; i < HW_HASH_INDEX_SIZE; i++)
-			indir[i] = le16_to_cpu(vnic->rss_table[i]);
+	if (indir && bp->rss_indir_tbl) {
+		tbl_size = bnxt_get_rxfh_indir_size(dev);
+		for (i = 0; i < tbl_size; i++)
+			indir[i] = bp->rss_indir_tbl[i];
 	}
 
 	if (key && vnic->rss_hash_key)
-- 
1.8.3.1

