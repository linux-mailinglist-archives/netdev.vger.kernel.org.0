Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6E222D4FE
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 06:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGYEoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 00:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGYEoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 00:44:18 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E144CC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 21:44:17 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b9so5614047plx.6
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 21:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=151wG1KiRrgfbCuP+xOkQaYADS7oKRPDfnAtfObVL5w=;
        b=DkaYnjC988sd5rmEo5XAs/cjj6XTwBNwBxmKsVa6pUNOPUwdm1SrUlKYnxd+4pX9u2
         oG5bjcQHM5qxMvAOoFH4CqMLvBYqR7CQwqnYjo5IEyA+61WJSRk8GjS/iywPgWzas+Hb
         Zf8NpbOHkgkMHTJNT6H6PKLadit/CfTGjdkEESS1Cin+DAlEq19niSUqdsUi8jgigExE
         fi9fMXTCAUGaVDeQ5zYefrILQcQFojj3eLr00N3xpObNPjMUqoCtIpj5GG1XNySYZ9gS
         gP3uvcF+/ZrZ4BoMqVwe6e2iCNo/CCF89CcCU5tElFjfe17r3OlFl1BhkXHLzFYKTJ+8
         eMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=151wG1KiRrgfbCuP+xOkQaYADS7oKRPDfnAtfObVL5w=;
        b=gghTPvf7DRXdyPxV+vFvVqHTeeyUvRbGPQNOseulXzX6OHsnRwIQAfzQ3h6RDgza4m
         neCljVDUuV/LmkzDI48AWpm3twJtb38j4hvhT73PjtTYLvzyfuKVMbYOoHkm86FNOjlc
         yfZ4g3UNxv8NeNYDusIkicJLMcHzpRdc/cBphhyVVFIOwYIw1ofj1jBL3F6r6D+Ax7ez
         W5d09PzpCfZf8J1Jc5sPoR/wJpNBTY+H7QLDxjbjNhwMe/n38HcyalijrjWcVuWACusC
         /652P++fzPWxiLe/8T9t2ixAkVvIx4gGAfG8+zTspiJKFU81RUqpl/tEwtMe62/mQ+Gg
         TyIA==
X-Gm-Message-State: AOAM531yMPrnA8tSB8+6MRnRGvvMoEs3PHiWDD5OYJKEcLJ7hxR6aLKG
        WyXEAX5BkYPSIj+Tyhue3I4=
X-Google-Smtp-Source: ABdhPJw6b73LxoMliCMrBZVsKAOpyzTOT6cHOhBW7hDXq3wB1sxRIImoLy0qFwMXPLpvCXjR0ZBWmg==
X-Received: by 2002:a17:902:7005:: with SMTP id y5mr10210195plk.342.1595652257509;
        Fri, 24 Jul 2020 21:44:17 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id e18sm7906618pff.37.2020.07.24.21.44.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2020 21:44:16 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     sgoutham@marvell.com, sbhatta@marvell.com
Subject: [PATCH net v2 3/3] octeontx2-pf: Unregister netdev at driver remove
Date:   Sat, 25 Jul 2020 10:13:54 +0530
Message-Id: <1595652234-29834-4-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595652234-29834-1-git-send-email-sundeep.lkml@gmail.com>
References: <1595652234-29834-1-git-send-email-sundeep.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Added unregister_netdev in the driver remove
function. Generally unregister_netdev is called
after disabling all the device interrupts but here
it is called before disabling device mailbox
interrupts. The reason behind this is VF needs
mailbox interrupt to communicate with its PF to
clean up its resources during otx2_stop.
otx2_stop disables packet I/O and queue interrupts
first and by using mailbox interrupt communicates
to PF to free VF resources. Hence this patch
calls unregister_device just before
disabling mailbox interrupts.

Fixes: 3184fb5ba96e ("octeontx2-vf: Virtual function driver support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---

v2 changes:
	Modified commit description

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

