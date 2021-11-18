Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809B8456436
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbhKRUds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbhKRUdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 15:33:47 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D5EC061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:30:47 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so6790717pjb.4
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w84daomfe6hfopN5Cs7jpNoKXOg+qjUqDxAnOKxUhcE=;
        b=Ly8shi92M6kpZ+Y3K3Dpu8E4rmTJJtgNCVmADnJzldvJmGZLYnzElXh5eKgXNkVV0s
         TvolnEDNiV9fBotXo8nx4+bvODp5C3Rva2uXpiTGxGpgVeaKQ9XfQiSBxLKn75xH20nW
         JPMgihoNd6N0uOs+cHx1sbLth6tICIBlARQMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w84daomfe6hfopN5Cs7jpNoKXOg+qjUqDxAnOKxUhcE=;
        b=pv8vsgi5fr4fz2bhMPtnNIO+c3nClJI1p39gNTiT3FL7TgxYoKKqcIXfGWbkj2pWwc
         tUlxDLX9pZKHAu8rrnhoE1Gi4vBQZfaalAXjzZRzzkHQK/7fsLdvH/fzxU7j7mSfDBWR
         vVB2Ag43XBianO23tAIAz/EsjMvuHPPiLHFvJatlVcz2guvXfGYYlixaEA5RWGJjLT1Y
         VKvRS9f9o670MOAuMT2MH8SaiWbx6vbFKCoSzBK4ROKGyw1qE1vDbHL1pmWXPkaiCYsG
         q8g4ZAGGAyVeF1FHuuyYZkdWh63ngcDr1V+aXt4WgTsNKmSlMo8OQugGMod2QCm4KbgL
         4TMw==
X-Gm-Message-State: AOAM533ZwffUGz8RU0F4Z11pEbTABh2NxfTNtSU9f9DA2fv1V3QUrK3e
        nnPuLUE//nPu7h7TEWleY91WPw==
X-Google-Smtp-Source: ABdhPJx2vAcS9/vY0mIWPnR5A57X4N8eHJFkUERChCQt0fnmyy5WCrJGY65CwE4cJVY3oWg9qDM8mA==
X-Received: by 2002:a17:90a:ba13:: with SMTP id s19mr13660401pjr.62.1637267446667;
        Thu, 18 Nov 2021 12:30:46 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p17sm376544pgj.93.2021.11.18.12.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 12:30:46 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-hippi@sunsite.dk, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] net: 802: Use memset_startat() to clear struct fields
Date:   Thu, 18 Nov 2021 12:30:45 -0800
Message-Id: <20211118203045.1286717-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=999; h=from:subject; bh=AlW+JDFW6jqRIzJL4RY1vWRN1xRCOE2m/xf4mW3pemc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlrf0AJMzHn+ibkUThsPkOuaX46Vd7l22wLWDrvnO zAAgm2eJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZa39AAKCRCJcvTf3G3AJv1REA Ccbf7X4b7/zgOqLpYWunpw0I38jf/46bwqqgrY3DjCySlzix+Qv6cIe1e3/ZNUafVa4z/gh+SFXbxR Z8f+7PhQ/VwE4yuE28B6ydcEhT3BuDkfH2oSW/qqjAs+7vHTz1jhk0Vrg6nFMX82rhZnktPUS+jjK+ m/lNO/BlAf3LZ26rXSxZWudpP7sEjNB0n7k2z1YXcJtjNNvEWHX7gnd06aINSk00ti2XjtWBn3S2wV OiB3NMNTuPzRZwe2J92gEDIy7oHshYVLGvaHST240knjikt/XaiMdx7CN7LQh4buZaVycQnBxkwsHd AeTtcH1FrrpjmlMEeghcI8HFXNLvCDxC75bH60ySkpvGLtXZTmWyw9u/4BE6JCcX4rcMsy6cLZFlE8 x4pKsyTJXlsRPJkwugT80OXYkSh+mtplP7esK7S2Jfd1tZgCdQn+Bqgd0m5pHxG6bh4NQvPu0US1S9 TXw+vMdAVoSSi910PghJV/aseod9n0wEjk2EqpwjdDeVcfMDXaKTKj1jTzWcc+AA9LHCMrr9KUyy48 kHMjWwdI+nkFDIxiEuVjcfQtVPGhA3ModVCDTe5Oz2J5ACcT6VK8GqhdW/P12LazHCAlAzzTEU4chN XnJ/PM3rTL1xNYE1bWFt9wTWCVMLytchhjeozTnWGTLS1Ws14CxQHcHIDWXg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_startat() so memset() doesn't get confused about writing
beyond the destination member that is intended to be the starting point
of zeroing through the end of the struct.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/802/hippi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/802/hippi.c b/net/802/hippi.c
index 887e73d520e4..1997b7dd265e 100644
--- a/net/802/hippi.c
+++ b/net/802/hippi.c
@@ -65,7 +65,7 @@ static int hippi_header(struct sk_buff *skb, struct net_device *dev,
 	hip->le.src_addr_type	= 2;	/* 12 bit SC address */
 
 	memcpy(hip->le.src_switch_addr, dev->dev_addr + 3, 3);
-	memset(&hip->le.reserved, 0, 16);
+	memset_startat(&hip->le, 0, reserved);
 
 	hip->snap.dsap		= HIPPI_EXTENDED_SAP;
 	hip->snap.ssap		= HIPPI_EXTENDED_SAP;
-- 
2.30.2

