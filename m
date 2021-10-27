Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D5943CFB6
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243303AbhJ0RcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243302AbhJ0RcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 13:32:04 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74000C061220;
        Wed, 27 Oct 2021 10:29:38 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a26so3339135pfr.11;
        Wed, 27 Oct 2021 10:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j40i/oCuZ+1rQnHaCzvorYVDYCLy6jFivrWqUoKPoe0=;
        b=L7IJFqH3yGUH1nGbQuvDjSN/Ogpu1tl1ga5eSHW+9H9QlhT0ClptqzgGWh/XU/Ked6
         WlO07/L+cIP8rN9L+lgT6E7/HdNUropHrGkGCKumo5EJlOJILnnYOQKYROWjE6nM37Yx
         qZGTVUrewB3pvu1L//BjbwS5RjCQ8/ZPRfR3fvSLWrwJPVPuPnf2coqPWk29X+l54eD4
         KiGbHGNh604Gic7iu41s+HihkESkjpGx6gi166PH/0zwjn2PF5bCFu3eQQSIu75y7x9T
         UqvGRB9WPqpiGVo61G8wp/9LLbzrWKGMR+hFmsjKkAM2OaeO10nfrkeqect5SzT5bWJ8
         JmRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j40i/oCuZ+1rQnHaCzvorYVDYCLy6jFivrWqUoKPoe0=;
        b=QKnIRwcduaA8RSWsk2wL02pdH5amTC8geLEQ4aKV5ZLaWwVydjqTaAg65mfd+eFV/l
         T7uAbxTmcC7bHxSHejlZUG+fpmHkFREASqEaw94lRX96sN3zTYtWrFOmB726bt37khXB
         9Cp2LrydyTG8OHKtKU8+cRSIOtPngU9OulxazPm8a+wnGUCkCIClylw+bllMDISAuYmp
         nTJPvqSJxIQUW5Y/BdpmhQQt2LjlZVR+bXPdY+b4UqRAXlTkeSBLhGh9E+AcKhQ6Com2
         QCB7ZpI09aphRFuYPrhrr2U7nmLbgL0rK1ek3LqekN+8CGTOXd+lngUe18r5RZ7dArU2
         /Reg==
X-Gm-Message-State: AOAM530MoCUwIxQ0sMHVnysdMJZ1XIjBIuxejIwUlEFWYhWz6kEogk5z
        31VmF6+ylUck1IJLAypBeD8=
X-Google-Smtp-Source: ABdhPJynHJ1xIpnL8GLuMHoKCw5ZV77knl+cmxDorg8QA3litHg5RAzLEN8PX3TKcU/cw4gTKtX4+Q==
X-Received: by 2002:a65:6a0f:: with SMTP id m15mr25290047pgu.298.1635355778018;
        Wed, 27 Oct 2021 10:29:38 -0700 (PDT)
Received: from localhost.localdomain (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id oc12sm341362pjb.17.2021.10.27.10.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 10:29:37 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     johannes@sipsolutions.ne, davem@davemloft.net, kuba@kernel.org
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+bbf402b783eeb6d908db@syzkaller.appspotmail.com
Subject: [PATCH] net:wireless: call cfg80211_stop_ap when switch from P2P_GO type
Date:   Thu, 28 Oct 2021 01:29:32 +0800
Message-Id: <20211027172932.774040-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the userspace tools switch from NL80211_IFTYPE_P2P_GO to
NL80211_IFTYPE_ADHOC via send_msg(NL80211_CMD_SET_INTERFACE), it
does not call the cleanup cfg80211_stop_ap(), this leads to the
initialization of in-use data. For example, this path re-init the
sdata->assigned_chanctx_list while it is still an element of 
assigned_vifs list, and makes that linked list corrupt.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+bbf402b783eeb6d908db@syzkaller.appspotmail.com
---
 net/wireless/util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 18dba3d7c638..4fdf0877092d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1044,6 +1044,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 
 		switch (otype) {
 		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_P2P_GO:
 			cfg80211_stop_ap(rdev, dev, true);
 			break;
 		case NL80211_IFTYPE_ADHOC:
-- 
2.25.1

