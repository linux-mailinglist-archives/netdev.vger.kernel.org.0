Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF88849D251
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244379AbiAZTLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244354AbiAZTLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE67C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:11:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92586B81FC2
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0350CC340E9;
        Wed, 26 Jan 2022 19:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224274;
        bh=8CdKbEpjMYGTkDqmnVCSEGMh+yOM3oRmEQnabgvpLnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkn9QT4fMFbjvs9D9qUe5bfClej/eSAwhf2geQM3nLODMXMRvS7woK2+bpovErSnS
         5NxOlYgSPSwSwe4OStHAeDgZxRoYM9BiUL40Y/TyGgDdzYzMlkrlpf7ub14nGU95Z4
         C4atzhLC7bCxcaeHRAhfwfUPd83z84dpa5bEZmV7qSj9aotH3vnWRDypcflPEXvMzF
         amgepwXrK7XeUiRkzCx//VLtxMtwtHXtOZNZaX97QlCXLy+kokMupxRFifL1sm0CV6
         TiV3lUPqXlZ+CGqFdfMMpZyY2Pp7qUH207X9QfW/Qg2ivWskEjRjUdndQmWdI2ebuv
         43RHx+lrgAhlQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        krzysztof.kozlowski@canonical.com, wengjianfeng@yulong.com
Subject: [PATCH net-next 02/15] nfc: use *_set_vendor_cmds() helpers
Date:   Wed, 26 Jan 2022 11:10:56 -0800
Message-Id: <20220126191109.2822706-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NCI and HCI wrappers for nfc_set_vendor_cmds() exist,
use them. We could also remove the helpers.
It's a coin toss.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: krzysztof.kozlowski@canonical.com
CC: wengjianfeng@yulong.com
---
 drivers/nfc/st-nci/vendor_cmds.c   | 2 +-
 drivers/nfc/st21nfca/vendor_cmds.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/st-nci/vendor_cmds.c b/drivers/nfc/st-nci/vendor_cmds.c
index 30d2912d1a05..6335d7afca24 100644
--- a/drivers/nfc/st-nci/vendor_cmds.c
+++ b/drivers/nfc/st-nci/vendor_cmds.c
@@ -456,7 +456,7 @@ static const struct nfc_vendor_cmd st_nci_vendor_cmds[] = {
 
 int st_nci_vendor_cmds_init(struct nci_dev *ndev)
 {
-	return nfc_set_vendor_cmds(ndev->nfc_dev, st_nci_vendor_cmds,
+	return nci_set_vendor_cmds(ndev, st_nci_vendor_cmds,
 				   sizeof(st_nci_vendor_cmds));
 }
 EXPORT_SYMBOL(st_nci_vendor_cmds_init);
diff --git a/drivers/nfc/st21nfca/vendor_cmds.c b/drivers/nfc/st21nfca/vendor_cmds.c
index 74882866dbaf..bfa418d4c6b0 100644
--- a/drivers/nfc/st21nfca/vendor_cmds.c
+++ b/drivers/nfc/st21nfca/vendor_cmds.c
@@ -358,7 +358,7 @@ int st21nfca_vendor_cmds_init(struct nfc_hci_dev *hdev)
 	struct st21nfca_hci_info *info = nfc_hci_get_clientdata(hdev);
 
 	init_completion(&info->vendor_info.req_completion);
-	return nfc_set_vendor_cmds(hdev->ndev, st21nfca_vendor_cmds,
-				   sizeof(st21nfca_vendor_cmds));
+	return nfc_hci_set_vendor_cmds(hdev, st21nfca_vendor_cmds,
+				       sizeof(st21nfca_vendor_cmds));
 }
 EXPORT_SYMBOL(st21nfca_vendor_cmds_init);
-- 
2.34.1

