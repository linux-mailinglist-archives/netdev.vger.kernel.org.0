Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165853BE8A4
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 15:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhGGNQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 09:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbhGGNQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 09:16:34 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449AEC06175F;
        Wed,  7 Jul 2021 06:13:53 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id u25so2602994ljj.11;
        Wed, 07 Jul 2021 06:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h25gHlOngZgr86BE+CbM0uJNam8WoUfeVATamHxArOw=;
        b=RXO8ymGzxfsEu2ttOuCke4ohRTFXlQktxVetUEhdx57MFwf10ngGBTlPxdiFhb0UPA
         d85N0+HjCqAtlB0gyYnX9x3LgBuuCgBQ5eUmHpQccGDD/mtjP7PJylSCjRKwloD4qmkq
         dXccUP8RutEDTXrcbFGnVYugRklUFengVt4OycsGn7ajbWLD6i4CGd5IVAylnrJBvyU5
         hBScKyc/y1syBXpAZzEB7L1g25kcpcesreYJ9eZwLu+rZd7XUnR5KgE7mLVSX6QZsvLN
         mQXAMekNo5pezEPncekDFxQ4VFNJZXg5ny+r2EWWZbb4vpVQM6o13ai69fP6eoLHaman
         zKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h25gHlOngZgr86BE+CbM0uJNam8WoUfeVATamHxArOw=;
        b=BeiCrMYK2fvhmi6G8UGzlqJHTHN/CrYxBLPL0JQD46T/0KUno54P1Faqj4Cz6sQd3/
         Pzvd4+F1aS0kWRnrNaKUJUqeYYOB/bKsI1SJ1dVO+sHFVlTN0cCxIcQbKgJ5g561vGaG
         4hmcKkYaGtGxsctgaCSWvGHeks+tbv8fWeo5edqQyWd0Igsbk9ERfABpBUoNh8DOQJ79
         Nx5PAmSDGvF9CvBBIr0GaWiT1v30dcu5O/KVGBit4K19OnL8+l1t4K1Kht5h27xGrkb1
         PbR/epJ1IGjqwvxiyIDf4YuTOKEHd64b0vBEbumXf5qPiDtH6qQaGnIERmRDHHDms2iH
         ED/w==
X-Gm-Message-State: AOAM531aDomzKjVjNbuoslbm5V5VfHamUHRxgfsWlTR/L/t+MPPlvfgh
        zzOtxq2EN8zqv8bMJQw48DdX35rQCXbNHHCE1Q==
X-Google-Smtp-Source: ABdhPJzC/+0kPktq84jrmOss4dX9lnay2HQ5PHuUtkFZew4yP9+HtEs4QL/0WJNnnChbVBT46ecUeA==
X-Received: by 2002:a2e:b804:: with SMTP id u4mr2728465ljo.312.1625663631378;
        Wed, 07 Jul 2021 06:13:51 -0700 (PDT)
Received: from localhost.localdomain ([89.42.43.188])
        by smtp.gmail.com with ESMTPSA id u9sm1423571lfm.127.2021.07.07.06.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:13:50 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>, toke@redhat.com
Subject: [PATCH bpf-next v3 5/5] net: core: Allow netdev_lower_get_next_private_rcu in bh context
Date:   Wed,  7 Jul 2021 11:25:51 +0000
Message-Id: <20210707112551.9782-6-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707112551.9782-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210707112551.9782-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the XDP bonding slave lookup to work in the NAPI poll context
in which the redudant rcu_read_lock() has been removed we have to
follow the same approach as in [1] and modify the WARN_ON to also
check rcu_read_lock_bh_held().

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=694cea395fded425008e93cd90cfdf7a451674af

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 05aac85b2bbc..27f95aeddc59 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7569,7 +7569,7 @@ void *netdev_lower_get_next_private_rcu(struct net_device *dev,
 {
 	struct netdev_adjacent *lower;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
 
 	lower = list_entry_rcu((*iter)->next, struct netdev_adjacent, list);
 
-- 
2.27.0

