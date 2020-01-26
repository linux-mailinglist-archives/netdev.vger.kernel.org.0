Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6D11499B3
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgAZJDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:35 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39243 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgAZJDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:34 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so2624537plp.6
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HDJehLxTt54CeUJRFPv2azzI91Oqm3K+fQ7d34Qz9l8=;
        b=VCm+ewMNI+P0aucvPHKnvkdoOs4WeW4uMxgS5y01ssZq79tvCplPuImiHJ3yojl91l
         vqp34TA369lrrMUMniRDVXrHbH+SNdEYR0/xu8pO+1ABXmUz7+Z4JqbbsFDNhk2WX6g3
         lu6fFSxAvnMOa51v6Ad4Q6qjGLBtU6LzyqNVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HDJehLxTt54CeUJRFPv2azzI91Oqm3K+fQ7d34Qz9l8=;
        b=FhBsw5ktvXJ+Skar+l03o43+vKRQIzDdWU1qTiZ1o+kJ4CSZPI0fHOCbQlBMtIuQ4d
         GHJNp9vfDRcurCh4tGizJ+kGA61+kH5bFp3uWBQLSr2E2HFtmuqtnLNHFRB9K4qKcnKk
         A1XnKto1f1c23O4YvLA3yuwiqwmAnn6L9qlH/5KxFnnz/BjGRVT3yydL+XZMfw6tvVZe
         usjp3yOPy2XflstYcv0nM407P6/3Beh7q08xQrWed5VISHq8/NetBHBWP+fgDWHizAzF
         1K3JyVMGg/qGpUmYOzK3tZ9hLB6f3rlmMHImXYUttQ7BAhjwswW6cFecbsSbtd2lM8dk
         ofkQ==
X-Gm-Message-State: APjAAAVcbAQKVtj/k+/TbrdZ03OWyxz1zv5k5g5sG98rECHQ267KbXXv
        IFW1uh1+Fb4I/HSUZKPxekv5+PeF4HM=
X-Google-Smtp-Source: APXvYqywa7SP8h2aKP7WQ+2O9s4NAvl0ewiZuqh8ndXGdWed6Pi3uGfQCQJLZHlt0TUynifjCXScng==
X-Received: by 2002:a17:90a:db48:: with SMTP id u8mr8546008pjx.54.1580029413830;
        Sun, 26 Jan 2020 01:03:33 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:33 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 05/16] bnxt_en: Support UDP RSS hashing on 575XX chips.
Date:   Sun, 26 Jan 2020 04:02:59 -0500
Message-Id: <1580029390-32760-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

575XX (P5) chips have the same UDP RSS hashing capability as P4 chips,
so we can enable it on P5 chips.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6c0c926..fb4a65f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10568,7 +10568,7 @@ static void bnxt_set_dflt_rss_hash_type(struct bnxt *bp)
 			   VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV4 |
 			   VNIC_RSS_CFG_REQ_HASH_TYPE_IPV6 |
 			   VNIC_RSS_CFG_REQ_HASH_TYPE_TCP_IPV6;
-	if (BNXT_CHIP_P4(bp) && bp->hwrm_spec_code >= 0x10501) {
+	if (BNXT_CHIP_P4_PLUS(bp) && bp->hwrm_spec_code >= 0x10501) {
 		bp->flags |= BNXT_FLAG_UDP_RSS_CAP;
 		bp->rss_hash_cfg |= VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV4 |
 				    VNIC_RSS_CFG_REQ_HASH_TYPE_UDP_IPV6;
-- 
2.5.1

