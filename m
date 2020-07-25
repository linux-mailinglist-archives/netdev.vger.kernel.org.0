Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B01922D4FD
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 06:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgGYEoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 00:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGYEoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 00:44:15 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5BDC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 21:44:15 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p1so5619777pls.4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 21:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RqYpy0rf+o52vw2Zo+dDTqXAZHzBcEsbNQifU/XR6KU=;
        b=NsyK+yVLCAUi+lFtcuHGdaMa3bBzMyrOJq9OVKlHM9XI+wqnxQLp2ufP7bjy43nqw3
         H6kqhfkhsYNf2NgHfjlnrIVsD9CTfSw6I7N4jE8lb6n0bnYptZ9w6KGzb5Ul2rdbCKAb
         JJWhjJg38VjO6WGfk7yScTqCD66Ad8JDe81VVR9Cq6CGF3BBgk3pogsQkZ4Tas+HTQdl
         Z64bvifi04TeyG6niKMe//VLhef8OTCkUWlETID8lyWwx35xYtrHhDZ9bECtrBPpDm20
         OGbeH3yCVVkoOk6hwWfPefQ062wueo/GP3hwW6XH32pJLCU1jJJT5gTE+zNonhsEyOhA
         pXqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RqYpy0rf+o52vw2Zo+dDTqXAZHzBcEsbNQifU/XR6KU=;
        b=A+aW/N8sHffE6aZCMjLTJbPqCQxBFzXwOha5RcLWXaI/gn/oGvRi3qs5eksgCJEaOj
         ue5yqno7WqONxiwNXIJAfaOEnPkFw/e7kk9NhGm/5+EAME6Q8+5ljR51q10IGHeVa994
         nAgkCbHM5LA5+TYSIL/zcuogqlrCLMnEVFv/I3rjt5SJaZhmd0RnUXvtV3PZH0K6pE9n
         xkHHNe0RKVmoocOUVS0EtsJ+2cHSYtKCEZjMFX0jvVq830HGN+ilDcZwwKsF9fIGKO8U
         uXobCT8Sebkm+yjCYNSlQ3hmKNIPXVZ5Xtd3EI89pTgjyaPLu5j28G/B7YWFkSjL27iV
         m4nQ==
X-Gm-Message-State: AOAM532Q4RbOeGol8Q19OArBbkM3UEwAFi66LoFue0OF2C202sHBoyan
        TqgM5ypwteq3jiJOUGzNYRQ=
X-Google-Smtp-Source: ABdhPJwt5rH574OyUKnMFR8tiDuO1FDy1c0ehYmcuIOqeIgFWco5YU5TACZfRhKy9kHKWf7XiTKLLw==
X-Received: by 2002:a17:90b:3114:: with SMTP id gc20mr8383010pjb.233.1595652255058;
        Fri, 24 Jul 2020 21:44:15 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id e18sm7906618pff.37.2020.07.24.21.44.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2020 21:44:14 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     sgoutham@marvell.com, sbhatta@marvell.com
Subject: [PATCH net v2 2/3] octeontx2-pf: cancel reset_task work
Date:   Sat, 25 Jul 2020 10:13:53 +0530
Message-Id: <1595652234-29834-3-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595652234-29834-1-git-send-email-sundeep.lkml@gmail.com>
References: <1595652234-29834-1-git-send-email-sundeep.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

During driver exit cancel the queued
reset_task work in VF driver.

Fixes: 3184fb5ba96e ("octeontx2-vf: Virtual function driver support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---

v2 changes:
	None

 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index f422751..c1c263d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -617,6 +617,7 @@ static void otx2vf_remove(struct pci_dev *pdev)
 
 	vf = netdev_priv(netdev);
 
+	cancel_work_sync(&vf->reset_task);
 	otx2vf_disable_mbox_intr(vf);
 
 	otx2_detach_resources(&vf->mbox);
-- 
2.7.4

