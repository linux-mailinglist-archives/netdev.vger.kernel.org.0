Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453D11E3B26
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 10:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgE0IAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 04:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbgE0IAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 04:00:31 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969D2C061A0F;
        Wed, 27 May 2020 01:00:31 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q24so1173751pjd.1;
        Wed, 27 May 2020 01:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dfrIIAJU41ZKt+X45ZinqHgh7bx7zJkQ64xHPADTvf0=;
        b=BaXhb5mJnK0NjrPZhuUxxXz89orbu+Wkv61EJ6GEYRQugVl7LNxBOfeHji3+zD7RHa
         0EHTmmMwHicTjIx4pLJKUJ60xs9na8tvx4I8bZwbY32tavaODIaWccL7+Qn19pUpmuVe
         VMFh3ndArJ2WtfBEPYvwnSVPDp+GhHBlH05dgzip7BzTAPFlPwKvQ3hfCgAfy6Zu/Oum
         0ktwJbdBSnbl8LkGswMFnWfiCDqqquh5TSgSMLD3EwHpLwxhuJrv18ibRTSum3KSTu2i
         z0rCWoalSGqdtuZKKS0Z7o3hEjsTPVSWcRfFs9Qj7iIsB1EQUnJnnZIaJC8LrfxH9zf3
         8/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dfrIIAJU41ZKt+X45ZinqHgh7bx7zJkQ64xHPADTvf0=;
        b=CRmmiSDrJC/OO7uWIaUakqebbo3PzDvaBZCODuXjcfjdlHd6jIB2dc695+1PIvLW4J
         xGGn29v1BBlNMCKmONKtlmAC54IbM8pHhjow1T8cqIF61ZeC8d8At//r8x0bHsZdsdbd
         /G/A1yVJROaIE+ZOT17ttvRtZ9+uwwvWfkgVaCC2ygsmrX3r/CskXNXXzsogATqRCiJR
         YXkItQr/n85GW85Cdgjp77In+OinpiwtMsfnJW7BWSEhLuP3ineqDovRr8OBb1scMQN/
         yyyx1D5tOxn+7g39dQzHQFg889Up9ECPsEg9XdUn0UEXGGUvKC6gAmcruC1QuFH0Ap8G
         G5pA==
X-Gm-Message-State: AOAM532hCerVHsVEm9Nca4rlarfwEt1u0f0qEP45/DfOqtEtDKZV++Yd
        kBeFZzNURQ0mdZdf5Xd/yaU=
X-Google-Smtp-Source: ABdhPJyTaS//jEU45/EluPP6BSlEDDe80kP/OQ7JvaKH2Ti00Y0GGog5m2XXJ6sSFY1agVB9EVrWLw==
X-Received: by 2002:a17:902:d90c:: with SMTP id c12mr4730110plz.113.1590566430970;
        Wed, 27 May 2020 01:00:30 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id z16sm1439038pfq.125.2020.05.27.01.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 01:00:30 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH net-next] nexthop: Fix type of event_type in call_nexthop_notifiers
Date:   Wed, 27 May 2020 01:00:20 -0700
Message-Id: <20200527080019.3489332-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.27.0.rc0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

net/ipv4/nexthop.c:841:30: warning: implicit conversion from enumeration
type 'enum nexthop_event_type' to different enumeration type 'enum
fib_event_type' [-Wenum-conversion]
        call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
        ~~~~~~~~~~~~~~~~~~~~~~      ^~~~~~~~~~~~~~~~~
1 warning generated.

Use the right type for event_type so that clang does not warn.

Fixes: 8590ceedb701 ("nexthop: add support for notifiers")
Link: https://github.com/ClangBuiltLinux/linux/issues/1038
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 143011f9b580..ec1282858cb7 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -37,7 +37,7 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
 };
 
 static int call_nexthop_notifiers(struct net *net,
-				  enum fib_event_type event_type,
+				  enum nexthop_event_type event_type,
 				  struct nexthop *nh)
 {
 	int err;

base-commit: dc0f3ed1973f101508957b59e529e03da1349e09
-- 
2.27.0.rc0

