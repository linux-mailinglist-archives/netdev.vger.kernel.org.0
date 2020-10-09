Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD32288208
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 08:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbgJIGTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 02:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJIGTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 02:19:19 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB94C0613D2;
        Thu,  8 Oct 2020 23:19:19 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 34so6328273pgo.13;
        Thu, 08 Oct 2020 23:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Nq3cSxz6lVgzyeUcG7Sy4vf1e14uTjN/gxUK21iGIYo=;
        b=OvJ/73+7PmjljH2aMwadqM1c/sdnMKaVliq71VfSTPbP1beGF/BlGr/WU2FUm6Kfnp
         O21jfLysAQfkey46EUTJiEXln78hIKfeqH5o0fYs5lcDEfItPrHsfH9mZjr8T+NiwztZ
         ctomrD5xrcVKaNWFYIEfnevn8xnUKlKchcaYmD698FWH5WV02I6fzRvY/LYuow5lPKoK
         MakOyJUlYiy47a8i/WLalTU9jMKx2n5EwkLWccse0F2pWvX42jQDxQ8pbOB2+zYHFM+F
         kEuqYzytEG38WRycmhW1gTp7MNleaP7PfwAGdCibRvbq7/i1Zpa1c8gs0Rq5nviVCPjN
         5VsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Nq3cSxz6lVgzyeUcG7Sy4vf1e14uTjN/gxUK21iGIYo=;
        b=I/5SIRHFH15hO7K3o9jVviAr52onlCXz3aywbaffmQ+l/jVfq4+v5mDrh6FjF3ogNj
         tYlcbrPfN0SKMn2r7JPlCGOj+9BBZAIOZEluFu1rghbg8q04FKPaA84cdxURTikogVvu
         kTVG+ruOho/jgZUpbh9dNHfbgNZtJOramWq9MsNAok8rA3C+6aNSvVJV/FWjAxFXY3KT
         m3w/LRx9ANqBmxSnfMwEwn/QrUp6he7mpXS3CSWM3TaKON8JnBwbakIZrfJdvp6KBOAI
         SdPiGvD9mluRvvU5LXuosZ7k5RPa2ksweB1JhPDTHJ8ssFr657ccieNQ7ljofqW0Lwao
         8eLQ==
X-Gm-Message-State: AOAM5313bcPJpdgsBNIgxJIF3sLMWY/cBMVJ6CyIARsSE2Z2m4jlZzEW
        fJp4mBGa3SU+12sPOoxbeTWHHNM5J3yp
X-Google-Smtp-Source: ABdhPJzcR4eBTVJ1VWWOdC5oyxQVPECyPPZXummcpip00+A5fCJB8KdmmHWQU47wZSkjwpOzM89yYA==
X-Received: by 2002:a17:90b:1496:: with SMTP id js22mr2927362pjb.20.1602224359072;
        Thu, 08 Oct 2020 23:19:19 -0700 (PDT)
Received: from localhost.localdomain ([47.242.140.181])
        by smtp.gmail.com with ESMTPSA id x30sm1131179pge.59.2020.10.08.23.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 23:19:18 -0700 (PDT)
From:   Pujin Shi <shipujin.t@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pujin Shi <shipujin.t@gmail.com>
Subject: [PATCH] net: intel: ice: Use uintptr_t for casting data
Date:   Fri,  9 Oct 2020 14:18:27 +0800
Message-Id: <20201009061827.1279-1-shipujin.t@gmail.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up a compiler error on 64bit architectures where pointers.

In file included from drivers/net/ethernet/intel/ice/ice_flex_pipe.c:6:0:
drivers/net/ethernet/intel/ice/ice_flex_pipe.c: In function 'ice_free_flow_profs':
drivers/net/ethernet/intel/ice/ice_flow.h:197:33: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
 #define ICE_FLOW_ENTRY_HNDL(e) ((u64)e)
                                 ^
drivers/net/ethernet/intel/ice/ice_flex_pipe.c:2882:9: note: in expansion of macro 'ICE_FLOW_ENTRY_HNDL'
         ICE_FLOW_ENTRY_HNDL(e));
         ^
In file included from drivers/net/ethernet/intel/ice/ice_flow.c:5:0:
drivers/net/ethernet/intel/ice/ice_flow.c: In function 'ice_flow_add_entry':
drivers/net/ethernet/intel/ice/ice_flow.h:197:33: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
 #define ICE_FLOW_ENTRY_HNDL(e) ((u64)e)
                                 ^
drivers/net/ethernet/intel/ice/ice_flow.c:946:13: note: in expansion of macro 'ICE_FLOW_ENTRY_HNDL'
  *entry_h = ICE_FLOW_ENTRY_HNDL(e);
             ^

2 warnings generated

Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
---
 drivers/net/ethernet/intel/ice/ice_flow.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 3913da2116d2..b9a5c208e484 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -194,7 +194,7 @@ struct ice_flow_entry {
 	u16 entry_sz;
 };
 
-#define ICE_FLOW_ENTRY_HNDL(e)	((u64)e)
+#define ICE_FLOW_ENTRY_HNDL(e)	((uintptr_t)e)
 #define ICE_FLOW_ENTRY_PTR(h)	((struct ice_flow_entry *)(h))
 
 struct ice_flow_prof {
-- 
2.18.1

