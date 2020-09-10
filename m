Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A7B264BC8
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgIJRto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbgIJRtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:49:16 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8746CC061573;
        Thu, 10 Sep 2020 10:49:16 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id t20so5521463qtr.8;
        Thu, 10 Sep 2020 10:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=466BP3gTqbYzho2Xtm74KeHTUl+MUpLWLJk7QtAP2ns=;
        b=RNK6sGRSmvXu6TgFnuA0d/SF3aqKQ3/5gA4cb0ywADDTEMkeb9DUMz+B+rgKBcWwlz
         IvUR6yVuE9dBTegmje/RutMzo5eXfULJzi7cJjjBpq6rNBdZ78ugR3Y5YJTpgW3VtrLJ
         gCxDR99e4JJ0da2DshXzz+nmwqtFv55Hmfl2UhAJM3fwTwYENZcQliolNimqeHL3mvAp
         vp+c0TOPjEvPVO9sg6qnSBP28M9DDeWxEUjNKQa2mOjTkdJaJQmPSvosRoMEhJN8Jf0Z
         lRdluq+wksEYT79Tld0arwL0Whb/rMv4ddm9ISSrxJrMgKISkg39OztFCdUuHJ7YQc49
         ZnGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=466BP3gTqbYzho2Xtm74KeHTUl+MUpLWLJk7QtAP2ns=;
        b=JT2bn6I3WkO+gBrmQKggT5stDp6iHgtg9DzQfJxNadCKcsFcikjaeqN281WFWgJlMB
         gkd9N0E4dBWF+hLXNECQA92/Lk2yBeVW6uHqSm6pMS7w0XFiKEkveUrYFJSuMKFGRQOE
         BzT0mr3WIlmF0JwyzBBRabmhxHXM6dMpekWbEtddSTe/Ikdqprz0bPAh5vVhm1J44vpK
         G0Gb/erbYht6zNJAF6S/vFD3OnCKQGDz1azXcFQreJU44fbqpHaeOEOHbh/vxCzQJJwX
         WygzGjHwmgylYYUJlkyos5LixfG80dU5w9F1WYlvQGJCOo9Tm2pbjco1vpWUsY14PZ1F
         Odxg==
X-Gm-Message-State: AOAM531OHcdAk8knwCnqBM2dzQlFuRZzIDjbhX+1zZX83vn6dl/V+xyj
        rJwKbJ0O4C6IOVktrJe5aYU=
X-Google-Smtp-Source: ABdhPJyJGWyNq7dGbZouBNuXr4iWetgbF5nqvZvcOj/ywxAuuFcc2AuLXD0MOwbAYwbzwYPGfZkc4g==
X-Received: by 2002:ac8:ecb:: with SMTP id w11mr8828228qti.373.1599760155606;
        Thu, 10 Sep 2020 10:49:15 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id r48sm7927350qtb.26.2020.09.10.10.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 10:49:14 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH net-next] net: mvpp2: Initialize link in mvpp2_isr_handle_{xlg,gmac_internal}
Date:   Thu, 10 Sep 2020 10:48:27 -0700
Message-Id: <20200910174826.511423-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns (trimmed for brevity):

drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3073:7: warning:
variable 'link' is used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]
                if (val & MVPP22_XLG_STATUS_LINK_UP)
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3075:31: note:
uninitialized use occurs here
                mvpp2_isr_handle_link(port, link);
                                            ^~~~
...
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3090:8: warning:
variable 'link' is used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]
                        if (val & MVPP2_GMAC_STATUS0_LINK_UP)
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3092:32: note:
uninitialized use occurs here
                        mvpp2_isr_handle_link(port, link);
                                                    ^~~~

Initialize link to false like it was before the refactoring that
happened around link status so that a valid valid is always passed into
mvpp2_isr_handle_link.

Fixes: 36cfd3a6e52b ("net: mvpp2: restructure "link status" interrupt handling")
Link: https://github.com/ClangBuiltLinux/linux/issues/1151
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 7d86940747d1..0d5ee96f89b4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3064,7 +3064,7 @@ static void mvpp2_isr_handle_link(struct mvpp2_port *port, bool link)
 
 static void mvpp2_isr_handle_xlg(struct mvpp2_port *port)
 {
-	bool link;
+	bool link = false;
 	u32 val;
 
 	val = readl(port->base + MVPP22_XLG_INT_STAT);
@@ -3078,7 +3078,7 @@ static void mvpp2_isr_handle_xlg(struct mvpp2_port *port)
 
 static void mvpp2_isr_handle_gmac_internal(struct mvpp2_port *port)
 {
-	bool link;
+	bool link = false;
 	u32 val;
 
 	if (phy_interface_mode_is_rgmii(port->phy_interface) ||

base-commit: 4f6a5caf187ff5807cd5b4ea5678982c249bd964
-- 
2.28.0

