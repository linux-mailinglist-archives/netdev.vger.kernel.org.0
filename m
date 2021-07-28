Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21253DD706
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhHBNYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbhHBNYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:24:44 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B1FC061760;
        Mon,  2 Aug 2021 06:24:33 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id p5so21500689wro.7;
        Mon, 02 Aug 2021 06:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/VR/vKX055HZSyE/wrwbw/eNm20ZGgtQqDWeVZoQCRc=;
        b=u/b4OebwaM1r7VeTE0ac+jv4ib93/8NYYOEBbQqo1XiXBmpzhdBek7sGtqGG3Q45K6
         McStV18Jj2MHAOk9gUgc09CKXrW79XY5mm2oWBMraKdyHCxFXqTCxhlW7D0qWEwSLGOH
         3EeNlXNaL74ujLorhXjSRTOVugUR4zVsyLQIpRCDalbmi1LHU9Imsfp/WULZTNbsIk9q
         +58zW8g5g4ouSlueLTuxRbw615QyJHJOPzQbty67ITKbinG+SAXWgR+0mrtdMV8aE7mX
         OMdnLnque7ixqr2YuyAqAkdxaiAvOgpbvXLqljjPyRN/RahwYMelY5IwQxh6Wfft/v+T
         3Lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/VR/vKX055HZSyE/wrwbw/eNm20ZGgtQqDWeVZoQCRc=;
        b=BdQIIbbSIx9inwKUVlHWTTYIHEaDVZSl9tnvl8vtGjtEv/ZqU5530lotCoUQA/2h6w
         w6oiDhEV0x/G1djmbKCCLc/fPnVxxVQKhrvzxeuixAfk662BwUUruyKHOQjLFLhNaRFQ
         jnZFf6Of5NENDYcTi7CHtzqm8Kg7jtQJK6I9ivQ4d/QZ+7fZlIiKUS+gHAP+RTBCbumG
         i5vG3CW8rarr1aVlaAsz07y7xr4eO7jHQTcKC3pDP54Er75Nm0aXiJUsQQnjLCLwm0t5
         tTVpn329i0wEXvw5bwIqJb6ug/ncvpA2HUxEkPlUqeMySBFYxTXv22HUk5dyuYcXkC77
         EYjA==
X-Gm-Message-State: AOAM531KleiZBgwXuGGN8FAxwTPp8m7kiQQs5KDeYy3v3LlC0D3+FqJS
        SuU0KL+ABRHrCh6UgkJdqptdOgr2pupAeTI=
X-Google-Smtp-Source: ABdhPJwlQ+qAbrjHEPXsB3loj0obOGa2gjzOCl2BU36WT0vsQIxlhXmSKcY8yfRFrvFxqpuZWRzOmQ==
X-Received: by 2002:adf:f24f:: with SMTP id b15mr17349339wrp.22.1627910672025;
        Mon, 02 Aug 2021 06:24:32 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id o28sm11731404wra.71.2021.08.02.06.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:24:31 -0700 (PDT)
From:   joamaki@gmail.com
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v4 5/6] net: core: Allow netdev_lower_get_next_private_rcu in bh context
Date:   Wed, 28 Jul 2021 23:43:49 +0000
Message-Id: <20210728234350.28796-6-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210728234350.28796-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210728234350.28796-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jussi Maki <joamaki@gmail.com>

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
index 99cb14242164..9cdb551db5dd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7588,7 +7588,7 @@ void *netdev_lower_get_next_private_rcu(struct net_device *dev,
 {
 	struct netdev_adjacent *lower;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
 
 	lower = list_entry_rcu((*iter)->next, struct netdev_adjacent, list);
 
-- 
2.17.1

