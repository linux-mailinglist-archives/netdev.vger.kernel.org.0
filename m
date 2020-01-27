Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3FD14A145
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgA0J5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:06 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36267 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0J5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:05 -0500
Received: by mail-pj1-f66.google.com with SMTP id gv17so2903768pjb.1
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HDJehLxTt54CeUJRFPv2azzI91Oqm3K+fQ7d34Qz9l8=;
        b=G54T9nqTfVF3JXwtjAmhdRafyu4+ie7Giy1FTmzyG2T60D5+IDo6L+z59fMUdn75ll
         ODYWTHJrBcZlqaGqfSOBPOMYD0Dbb0EcQjmWMTHWUCKC/0HrRnXtJ8cf8nq4HuA9F4Ed
         ia2kDgzaw46dS3vvd3nsC407deIiLCB9xzCnw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HDJehLxTt54CeUJRFPv2azzI91Oqm3K+fQ7d34Qz9l8=;
        b=K9aLyYAce9LWSoVb8x7G6Z5oZn8NVCRHovmkdVCWaECEFI2/4yJqyxcQ+oZzbQEd2j
         PC760/IcO99zyibJ2uGaNScvawQy3DWnDEy8zRK8idQwSPw8jRiME0hUmzHPjUVoCL2W
         bJDqhfQBxD/7PkzEc6qjZ6ZxmHIxbsdQyLN3hzqHPhChxdDMwG2DzoWrxZgM0ijuVF/J
         e6mkv1zhek0hlqLkw4H4io5MSRWWD7CgawO7l76wvglH6wX1BYZ53SzpZP5L0YBm5Nbe
         hjr4iaf2Kz0bTfw0ZGqsbwRhPznEIkpVgaLTxxLWPbgVTXA7EkdvZSZFhUwLlihFP5gL
         wXcg==
X-Gm-Message-State: APjAAAXsLNye7PCclJagJM1YPT8vIZGupIxWQ/DvAnnsIzmpffBYsXRL
        yJcf/gFDQyYXmeRHqFI/dCUJUqEZC2I=
X-Google-Smtp-Source: APXvYqxqxXv6MnrppmtKBIwp5K8U+Ix1yeE21zGMZAwl8QCkirD7HPYQS4o0Fvqx6+bVbtsPf1CDlg==
X-Received: by 2002:a17:90a:fb41:: with SMTP id iq1mr1485120pjb.89.1580119025131;
        Mon, 27 Jan 2020 01:57:05 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:04 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 04/15] bnxt_en: Support UDP RSS hashing on 575XX chips.
Date:   Mon, 27 Jan 2020 04:56:16 -0500
Message-Id: <1580118987-30052-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
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

