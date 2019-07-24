Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4196772B80
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 11:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfGXJfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 05:35:18 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34485 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfGXJfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 05:35:17 -0400
Received: by mail-pf1-f195.google.com with SMTP id b13so20660086pfo.1;
        Wed, 24 Jul 2019 02:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RMdZENf34klfFRm97gWv/3oVVvhtQ9/kvSp7CedAKBE=;
        b=hppg7Ef34MOf6m4sm9VwXNec86F5mOQj2J2ss65F/jwkHw1pHv46tX/7cRHxTcegZk
         He5INWuFp85pPh/IeqYSthdegR8CcNpzxUHKlED5wUrxRaY6WKB2lIrcEWIWNWEZFU+W
         aRHjmeBQs0OPRO0NNXUZ4VyozflJG+s/Is0LUAKNLIFNC0K3eArSmbOmrD8EbN/+E7PT
         daN2iMZTg241BeBbeFB/ZnPRoYxpkcQyK5JCvR6JN1uKnNwjf1TupjJmi4ei6QkFz/sp
         2+j66A6ZcOd4sv6TWIp3yq0e0tb2nLDp9tcQUILa4cUigxC6wETRf5ytN5gNpWqLFmSv
         sFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RMdZENf34klfFRm97gWv/3oVVvhtQ9/kvSp7CedAKBE=;
        b=DicaIhDt4voCC/7zIWOU10q2J091l/+oYQPlTl0E5CF41oWZwsdRW+b2OLp0fbMpuJ
         jUIo3GkVUZE5yA8iJOe5918ZbKolOv4RrapOm+0sPFUCFt2EMcVrbVaqlVOWqYYZBGXE
         pVJm/Sdf0RcQ2WabsUOabalVNHiEWy2FlLTvr2jNNXnkamktgxHMrmhLjSRDpFvcUM5G
         FMiuATfAoxj/UX7l1ROOFImjep6cXylBTBbPsMpnlfd8OqxyNSLovmo0nhmOwH7bMK4p
         4NLWuNnOTskiWWMybEGzkfmOrngXPzjOSclsE4UJnffRLgea+kBlLlxaEiZ1m/PpJsgm
         ACtQ==
X-Gm-Message-State: APjAAAUPRFYk8oRGK+ytM60AyIt1YnmT+ZsY4VkN9d0TFLH6F6SJD+EU
        jAOGw6IAyWYMdGzTRV5rvO0=
X-Google-Smtp-Source: APXvYqxKZ4RHMHG+5q6pFR8zpsFxDWmUYA2anIVvMagFONXq3/Mn8XIDqlF0Q/oyuHHQkumb6EeQrg==
X-Received: by 2002:a62:ac11:: with SMTP id v17mr10407107pfe.236.1563960917124;
        Wed, 24 Jul 2019 02:35:17 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id 14sm44191863pfy.40.2019.07.24.02.35.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 02:35:16 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: key: af_key: Fix possible null-pointer dereferences in pfkey_send_policy_notify()
Date:   Wed, 24 Jul 2019 17:35:09 +0800
Message-Id: <20190724093509.1676-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In pfkey_send_policy_notify(), there is an if statement on line 3081 to
check whether xp is NULL:
    if (xp && xp->type != XFRM_POLICY_TYPE_MAIN)

When xp is NULL, it is used by key_notify_policy() on line 3090:
    key_notify_policy(xp, ...)
        pfkey_xfrm_policy2msg_prep(xp) -- line 2211
            pfkey_xfrm_policy2msg_size(xp) -- line 2046
                for (i=0; i<xp->xfrm_nr; i++) -- line 2026
                t = xp->xfrm_vec + i; -- line 2027
    key_notify_policy(xp, ...)
        xp_net(xp) -- line 2231
            return read_pnet(&xp->xp_net); -- line 534

Thus, possible null-pointer dereferences may occur.

To fix these bugs, xp is checked before calling key_notify_policy().

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/key/af_key.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index b67ed3a8486c..ced54144d5fd 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3087,6 +3087,8 @@ static int pfkey_send_policy_notify(struct xfrm_policy *xp, int dir, const struc
 	case XFRM_MSG_DELPOLICY:
 	case XFRM_MSG_NEWPOLICY:
 	case XFRM_MSG_UPDPOLICY:
+		if (!xp)
+			break;
 		return key_notify_policy(xp, dir, c);
 	case XFRM_MSG_FLUSHPOLICY:
 		if (c->data.type != XFRM_POLICY_TYPE_MAIN)
-- 
2.17.0

