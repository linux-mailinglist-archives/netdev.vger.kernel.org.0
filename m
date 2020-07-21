Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B3D2286EC
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729928AbgGUROc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729967AbgGUROa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:14:30 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5A4C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:14:30 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 8so1311560pjj.1
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pgr//2Gl3ConxyqhV6XXXYy3K5XiDD+Ctk7wmLRZp8c=;
        b=KrAhm5GnJxR7mepvd9Za6VxWswfW2xIdYsOCa9FRbq6hrhwAv+D0uT719orIVfQt8/
         IIIiUNPGggs8ydKd4pjJfhs3bsCQ5KoAvRR6g86pIerAvd2sOSFpIOgP6g4laXjT7Art
         sVnlPbUniyH2WciAq0sp3DU/wCG9mRFTSOd8TDxEm1FsVxU1w6YrXc+1wTqEXSf+Jys+
         hJhEybVSO6bwKVTj1p/7iBdX+oy+LKUHG0jY1TR7WCWp5bRXEGh2S61/NGkueZKXwuF4
         VFM7IBPW4SW+NCakROeErtVFtZ4iva1hg5uLo1ZeU5ZyqVOJ7xD0m/TyN0LzhwpbTK2X
         PbXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pgr//2Gl3ConxyqhV6XXXYy3K5XiDD+Ctk7wmLRZp8c=;
        b=ZSOUxWl6XqGMuhpHsiLjSGrBdqAhHwYtjzRv9V7E4ts1iAzg2edDVTqeKE3ix51fSm
         IO+40fvI+ozcpgDgSsae/1ujfdJ9F5TqAvs9JCVQPQqd3GjuYEynM5nzCB5zaUEN0Ykw
         LK4XD0A6ISyfzVP6lPkk1j6/442Oty3u+8pN4IH0IdF88Co5Mfobog3kg5AyAV65Z4Yr
         2SOcRGKMDC/mSqnKUm3EQQnuvJ9M3mEH2dQSCPHTDfkgoYwL+ybyGU3TlivsccGbG21v
         MxMJ/sCMNHK5ppr9Ff/8ciZyyJfQcGLm69H3oYB+RLPa7ETS2yiVMwDU8T2AC6rBMKyc
         xyyA==
X-Gm-Message-State: AOAM533s16sWgtwzLxtpVs7rsztWISNdhrGuyNSvxv8oRcQ1YxYj8VxQ
        ExpWVbMhUCXofjUKStwwhJ0=
X-Google-Smtp-Source: ABdhPJwr9wotWrz2UFXhnMo82PX/sYh6axM1o1fqwXEMuZNVETcqzPG57QbmeRRKdO0bYZgcIEyJKw==
X-Received: by 2002:a17:90a:800b:: with SMTP id b11mr5868874pjn.105.1595351670052;
        Tue, 21 Jul 2020 10:14:30 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id z20sm2982305pjr.43.2020.07.21.10.14.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:14:29 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     sgoutham@marvell.com, sbhatta@marvell.com
Subject: [PATCH net 3/3] octeontx2-pf: Unregister netdev at driver remove
Date:   Tue, 21 Jul 2020 22:44:08 +0530
Message-Id: <1595351648-10794-4-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595351648-10794-1-git-send-email-sundeep.lkml@gmail.com>
References: <1595351648-10794-1-git-send-email-sundeep.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

unregister_netdev is missing in the VF driver
remove function. Hence add it.

Fixes: 3184fb5ba96e ("octeontx2-vf: Virtual function driver support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index c1c263d..92a3db6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -618,6 +618,7 @@ static void otx2vf_remove(struct pci_dev *pdev)
 	vf = netdev_priv(netdev);
 
 	cancel_work_sync(&vf->reset_task);
+	unregister_netdev(netdev);
 	otx2vf_disable_mbox_intr(vf);
 
 	otx2_detach_resources(&vf->mbox);
-- 
2.7.4

