Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AB0207E0C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389299AbgFXVCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388763AbgFXVCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 17:02:40 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66D6C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 14:02:40 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d10so1622239pls.5
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 14:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=k1xn8QBzwKYXTOcuZ83n7JM+2qG9Cvc7uFDnGgIr3p4=;
        b=aqGAsvWXmNL3ZlvD/tcQSiYyJLHq4Or8yBId+44ceqnrSWmrYT9VQlcqtNfsBsUn0Z
         1ES7RFHavoZzLpFBZCzKpFQwwMlvnIN8NnoFlLWLhjjfpAlcBfvDmA4y9vF//weepQ/b
         LDyBxqRJHav1ZyMzJJ0Wf8tVlSRS+RA+J6JoY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=k1xn8QBzwKYXTOcuZ83n7JM+2qG9Cvc7uFDnGgIr3p4=;
        b=o4DRNFwPhZZVLoRjbxfWkM2ferA+UHe5fl/PIja6OMfLku7j/UKdcSYqe2R6BgfXwv
         1ihGdzvoYX+xjmjXUzlIiLMUFog3dLj1OHA8nq8bYw8IMRvX9FOTO5AMC23tk4mCvX51
         FeLCHsbQu9LIkRnyB4/Vp8EithjiuKiWTerB9kZ5kJLwS5xq9is+yEch1+Vzx4FfJaAv
         dCiC7SJcxdeVZw9Aa+GCJmw0+csBA2b0m81yuc55qyA99Utt6cc438X0mMviEtr2XfJR
         H242pqxuyPmRiEQqSoXjromH0aT0hnH/GMzTDquCVCliLP+DAmb2m6lH0bflG9N7g2U2
         igSQ==
X-Gm-Message-State: AOAM532jChWKCG8ODCUvoMxhJgPWZPmzVRiDoMFXcbvcVzsyM2/87eWx
        nWUh7uHxvvxqFkvnGMIRB/WXiw==
X-Google-Smtp-Source: ABdhPJxqXhmkQ+kAL7W2hl8hImkHwBv4Lh2lIAftjQDjfTWG0wS67XAvVMhiz3cBlUB5MHYmDuocXQ==
X-Received: by 2002:a17:90a:fe83:: with SMTP id co3mr29345971pjb.204.1593032560370;
        Wed, 24 Jun 2020 14:02:40 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id j2sm3107778pjy.1.2020.06.24.14.02.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jun 2020 14:02:39 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        julien@cumulusnetworks.com
Subject: [PATCH net] vxlan: fix last fdb index during dump of fdb with nhid 
Date:   Wed, 24 Jun 2020 14:02:36 -0700
Message-Id: <1593032556-40360-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This patch fixes last saved fdb index in fdb dump handler when
handling fdb's with nhid.

Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 drivers/net/vxlan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index e8085ab..89d85dc 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1380,6 +1380,8 @@ static int vxlan_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			struct vxlan_rdst *rd;
 
 			if (rcu_access_pointer(f->nh)) {
+				if (*idx < cb->args[2])
+					goto skip_nh;
 				err = vxlan_fdb_info(skb, vxlan, f,
 						     NETLINK_CB(cb->skb).portid,
 						     cb->nlh->nlmsg_seq,
@@ -1387,6 +1389,8 @@ static int vxlan_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 						     NLM_F_MULTI, NULL);
 				if (err < 0)
 					goto out;
+skip_nh:
+				*idx += 1;
 				continue;
 			}
 
-- 
2.1.4

