Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7A446DCE6
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhLHUX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhLHUX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 15:23:56 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303A8C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 12:20:24 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so5197713pjb.2
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 12:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bSlN0VoxW2zOv60Cein83XEMqcG9Rks9lTwMREiY4NY=;
        b=kn3WfZPNTlzykR4ULY8Ad/zRCxgFtzCrdzZzZJ05nP3V2FA+kKLo/lePl6ox8qdi5Z
         yo7DSLED5a6z+yuTGOULawcdhdDSDfDFwAg22ZjuY/6NKr4LNUle8llzCpRa0jeH3eU0
         1bO/awySgs0wLhKG6TCFcFJtXB9YTeY9I3ClTvfKZd0/Qi1KLFso12xlhOGRxPT2eSv+
         ApeAEkKYyTAxKQGTdJhWLeKLJPSfRH80idMf4eJ7p9wfZgYZX65TcxN1Nfmgy0J5AfmA
         Du2Tvvzdi+mJqS7+c4sHMLgQTEwAdhVH+sJUtfrpdJUXEOs+Q8p+btNrVAydUoQ65rGG
         XmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bSlN0VoxW2zOv60Cein83XEMqcG9Rks9lTwMREiY4NY=;
        b=IWfL/q3UU2cqOuPNlwl2vc1oLUM8kTUEN+5z4ExCaewF3THODZd+Ao9y3fqvdjTC41
         qFtonHUGogV1U/Drsy/adjSOfL+QY5UbN5qqlzH0t3op1Eh1R1vnTLbqsuL+hEGiSl1P
         SQc8VRjkmVAzb9IfRz1xp4dw0kbbMJxD+Yc0sWgVO4x5uC5F5kyyZPwNypdDkbpAWA6q
         Cy3J1SD/30o1eO7aop9QOJJXP7h8nKsqXPIYi9eW5uOiTEW3bcThLq5h9gmNVet9dyuF
         tIUGJLGZMDlDr0dS5wzFnopgdZLODwhUpjmeWGhSlUdno4niCMTETiRV5Eve7HUBbydA
         96hA==
X-Gm-Message-State: AOAM530WoNg239EbomGeQNFf8BKnsQ4HJfhKSdB+Sm9TdKLlyy0oKRtn
        t65bDhvQNUu/WjRndSupEHY=
X-Google-Smtp-Source: ABdhPJylHU2lpaN1OFqu5oq/0EE/bQTe+0jxRK6FLJdugZ2CYcjb0EBfq+9I3LkGputgMWxUg2Y9jQ==
X-Received: by 2002:a17:90b:4d85:: with SMTP id oj5mr9886297pjb.188.1638994823775;
        Wed, 08 Dec 2021 12:20:23 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:903c:510c:9a29:125b])
        by smtp.gmail.com with ESMTPSA id r21sm4139613pfh.128.2021.12.08.12.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 12:20:23 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net] xfrm: fix a small bug in frm_sa_len()
Date:   Wed,  8 Dec 2021 12:20:19 -0800
Message-Id: <20211208202019.3423010-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

copy_user_offload() will actually push a struct struct xfrm_user_offload,
which is different than (struct xfrm_state *)->xso
(struct xfrm_state_offload)

Fixes: d77e38e612a01 ("xfrm: Add an IPsec hardware offloading API")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 7c36cc1f3d79c2df16a35077031b74bd2dce730a..0a2d2bae28316f4a43cec96c3e698b42f6b6864b 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3058,7 +3058,7 @@ static inline unsigned int xfrm_sa_len(struct xfrm_state *x)
 	if (x->props.extra_flags)
 		l += nla_total_size(sizeof(x->props.extra_flags));
 	if (x->xso.dev)
-		 l += nla_total_size(sizeof(x->xso));
+		 l += nla_total_size(sizeof(struct xfrm_user_offload));
 	if (x->props.smark.v | x->props.smark.m) {
 		l += nla_total_size(sizeof(x->props.smark.v));
 		l += nla_total_size(sizeof(x->props.smark.m));
-- 
2.34.1.400.ga245620fadb-goog

