Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7B13FF3BF
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347198AbhIBTFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbhIBTFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 15:05:02 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2ABC061575;
        Thu,  2 Sep 2021 12:04:03 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id k13so6571451lfv.2;
        Thu, 02 Sep 2021 12:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NOyqDeyc/FwMKkG6ZTdjkTsk1ZboIqPE5R0kzD5kwqM=;
        b=Wwead7MONGzVYiH+1uLhcRMd7BwybKn1cdhzq4Pl34GASkjRKqV67XAex8C+WPOTMm
         zUdNdf1z0NpfpRlh15x2YkOocSs51EWV+GPxl1WU05lH9D+Diwxv109pRCOPWqEghrBx
         Fv+jjYQYUF/f2QMbE0syyyrDNZgfh1gfM7EHhZbFnOzFWlR2E0+wwcB73yPvPqnTQ+2J
         afAfOySZvRUBaKZDUs0M0v//Y2anWO38yaI829vAH6nlYI9c08aZLXRQpRYzKC31aflS
         yUkKkdxDA4Pk1OY+pKaIkeDUXEz0Wk0xInmhYBwlUxhkXr3PGmOX0fFdEe0rIrnouB8Y
         X09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NOyqDeyc/FwMKkG6ZTdjkTsk1ZboIqPE5R0kzD5kwqM=;
        b=KlsK0Gpc0MIDs3612YoLPh0Mfkll4KCKJrIoSl90klDLTr0tCbQiMKJy1j732kLbC9
         /foPTJxW1epK6B1dH1FJIQ/abv+P+O/qOZotIZ0bStegLGzuoUY7Zjgt0AUtC3vTxoNf
         1+aUiKHcLbaFr59bM5Vs1OviCyjxRLOyYfqiJVFnlGy1mTB3j4a+A1HYkS368Mex+CXi
         K+yAj4dihkeIHoRR7+kLPt/B2yut8TkAaPum3pEVPuaS5SUDUfGFq6WspeXhtpQeCjyE
         ro70mAf34o9tVWW445/F/GflYCGsp41zXnozXM6UqEbQFqainnRNrc9GM8W6+cmWZLBM
         yhPA==
X-Gm-Message-State: AOAM531e9Wea5icF21Ce1+vaO7t2JVcZnFR8rt+XzyppP82yo9LYrfwn
        XTcl61vNJeVoNuiFRSnZ7Ls=
X-Google-Smtp-Source: ABdhPJw/YbLepWf9qyfLzSGXAvN/DAATPR8KdpZEpodx0YkdPgPh8kveLkNywl+dFVQa2WVBHp7b+A==
X-Received: by 2002:a05:6512:39c6:: with SMTP id k6mr2058369lfu.379.1630609442112;
        Thu, 02 Sep 2021 12:04:02 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.70])
        by smtp.gmail.com with ESMTPSA id f7sm336443ljp.90.2021.09.02.12.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:04:01 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com
Subject: [PATCH] net: xfrm: fix shift-out-of-bounds in xfrm_get_default
Date:   Thu,  2 Sep 2021 22:04:00 +0300
Message-Id: <20210902190400.5257-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot hit shift-out-of-bounds in xfrm_get_default. The problem was in
missing validation check for user data.

up->dirmask comes from user-space, so we need to check if this value
is less than XFRM_USERPOLICY_DIRMASK_MAX to avoid shift-out-of-bounds bugs.

Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
Reported-and-tested-by: syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/xfrm/xfrm_user.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index b7b986520dc7..e4cf48c71315 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2005,6 +2005,11 @@ static int xfrm_get_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EMSGSIZE;
 	}
 
+	if (up->dirmask >= XFRM_USERPOLICY_DIRMASK_MAX) {
+		kfree_skb(r_skb);
+		return -EINVAL;
+	}
+
 	r_up = nlmsg_data(r_nlh);
 
 	r_up->action = ((net->xfrm.policy_default & (1 << up->dirmask)) >> up->dirmask);
-- 
2.33.0

