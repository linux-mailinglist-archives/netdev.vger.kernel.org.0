Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC563BC11A
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 17:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhGEPlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 11:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbhGEPlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 11:41:47 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17123C061767
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 08:39:07 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h4so18620885pgp.5
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 08:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4/o8vlqLZEYYy4rqyhVYly8UdixL87ijlGfpCwKp2EM=;
        b=Hi1CYnKaJD8B+s1p70zwuRhqyGMqkxTj02hYcpGZ8AUaVA3OeUxSzpu3Q3ODUsEKyT
         bTtilIy+9e1MeC/xB3CwvSy+isDwK1LN+FSlukpUUawJ9/h8vnD4PX22iIh4815c2wE8
         dzvLA8g6SnwQ16Yw4XvjgciUKw5Ds+Efa09UAepBZzxFSyUplFat9e0j4zMdCP6Q1ojH
         oZVl/PA5UJSWDsfGTQfABms9lTSwNQwm33skw8nBsCMrPY8sCEIoYhReUsC0c+zv3F02
         XI3raKQBEmr0f+H60tOpkdYLRaWWeDsCQqUmXU7FJqSN2MeF+wwpQ98GOdiM1vUIlaJ5
         weoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4/o8vlqLZEYYy4rqyhVYly8UdixL87ijlGfpCwKp2EM=;
        b=m1CdOX4b1E7RiT3Wo5IieO3lOMqym3VToxscLy77RGAPtM7Otq+KLm8pBoIGw5GKuq
         HVhYocAxgFOB7jWfhqjFv42l8avPmh5/Ug6higEpk6MpL5C7tgSTEZAWIzifeIAPN5BF
         cNo0faOogw43gOzrvi1NuKB8FZWiKT2j/VrPXU42NW79VwHiqXRlf+H5z7V4Q8tbpkdn
         2M6VuRMB4SCJ0xjiVXGuLDoP0w0ia6WjuOLpu2eZ9oZgD+dh4zal7Wkjez+7EJXsP/H6
         mR2d895xSwM5HM8Mqjcp+glleWS7p5YcthsxnIEWNllLndTMNT5m+v1NLWD+uItg3AB7
         FL8g==
X-Gm-Message-State: AOAM531yAbukrsY+GjFHOYxi4IEDtuMEs3hpnLSKc8jwNypm6ox+kZDG
        Ph0RDWcizfvjnWMZFSqi2Ak=
X-Google-Smtp-Source: ABdhPJxljA3EFgn011+V+dR3d8tS6FvrSWEV3mImCpX2tf4EaXQUMOuBx6QHATtpflJ0KsivCX/OTg==
X-Received: by 2002:a63:4c19:: with SMTP id z25mr16231805pga.160.1625499546611;
        Mon, 05 Jul 2021 08:39:06 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id k10sm9310353pfp.63.2021.07.05.08.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 08:39:06 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        intel-wired-lan@lists.osuosl.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 9/9] bonding: fix incorrect return value of bond_ipsec_offload_ok()
Date:   Mon,  5 Jul 2021 15:38:14 +0000
Message-Id: <20210705153814.11453-10-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210705153814.11453-1-ap420073@gmail.com>
References: <20210705153814.11453-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bond_ipsec_offload_ok() is called to check whether the interface supports
ipsec offload or not.
bonding interface support ipsec offload only in active-backup mode.
So, if a bond interface is not in active-backup mode, it should return
false but it returns true.

Fixes: a3b658cfb664 ("bonding: allow xfrm offload setup post-module-load")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - newly added

 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a9cb06959320..3bc6266ede0e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -581,7 +581,7 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 	real_dev = curr_active->dev;
 
 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
-		err = true;
+		err = false;
 		goto out;
 	}
 
-- 
2.17.1

