Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449E22789C1
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgIYNiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728199AbgIYNiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:38:18 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA9FC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 06:38:18 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s2so2240815pgm.18
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 06:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=r6zxPoO8s4vp/GQ7ZW0Vfpf26+eUWyXTtmEyUGfU0KI=;
        b=Y367UzXd51GZk3Wybutz4RPJu9dc2eL9ItGl45GSQBPwJ7OLTCxltKtwMHQkHp+q5T
         XKTIN4xuCbu7LC4GpP2/gEAmGKRwESsrkrYWgfy9jckj6bQ44D+osCcLzVEeOhgPVt1T
         9wDRq+n4cSs7dEZrw4eTS89s62Q8teplmh6jmu4tj/5Xq9vFqEP41StugbcCGraCNbCx
         qYV3BDmPhMuxsyCmPr/cALCAncqV2o2CPRpmAubB7GTM38LjGG3zy350DpdGjLvXgVIn
         8fNbFLLTqzqInV0w+x6Laaas0RxbIbF4GqvZJgYLutUwgAijcJ6TsRVAi88RfWxlhlU1
         k5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=r6zxPoO8s4vp/GQ7ZW0Vfpf26+eUWyXTtmEyUGfU0KI=;
        b=C3C0vg95ecxmbCsZK9gUKGPp/vW91/WSp99g3HHbU7ispySxERJOzLasWY4CsFVnjf
         YBTVSDNXxBF3Q+WCPa9kTdUaKQ348qXX2k66TqBeJcO55Zrv117xW0FTV2SvH6StHI40
         KvmRTy7UVa7hynnnE2O8ZhcJHZkSq3E1El7omnEbpqTXcLZB2exR497djuMNTkP80xnl
         k/0HtavnkHPpyRaQ6NzfavEoaNLdzTvZq1clfnlbBhJrXn4ZZ7iiNt3uguOOSyOtFs7/
         luRtHrSO+eBlsm6+t20HLRA8/UWF7jsy2v5LNuZ8HklzpdhPODgPgLCruD63MSbc38NH
         8nBQ==
X-Gm-Message-State: AOAM530363I06DPNRhb4Wt3QrV8kxS9fspeC3OZ1XKCVmbSDWv/cvQhp
        /fOVOF2MujKnqjamElIhL03pOe5xG9qL9w==
X-Google-Smtp-Source: ABdhPJyYPRoSyFJtqovjbetAnXuoqw7xXdeprn3DAzonXNo+qC97/DXBfF9Op0daWrz00skU/8ljqJ7IvbKvBw==
Sender: "edumazet via sendgmr" <edumazet@edumazet1.svl.corp.google.com>
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a17:902:a509:b029:d0:cb2d:f26e with SMTP
 id s9-20020a170902a509b02900d0cb2df26emr4443930plq.7.1601041098210; Fri, 25
 Sep 2020 06:38:18 -0700 (PDT)
Date:   Fri, 25 Sep 2020 06:38:08 -0700
In-Reply-To: <20200925133808.1242950-1-edumazet@google.com>
Message-Id: <20200925133808.1242950-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200925133808.1242950-1-edumazet@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net 2/2] team: set dev->needed_headroom in team_setup_by_port()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices set needed_headroom. If we ignore it, we might
end up crashing in various skb_push() for example in ipgre_header()
since some layers assume enough headroom has been reserved.

Fixes: 1d76efe1577b ("team: add support for non-ethernet devices")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/team/team.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8c1e02752ff61f8752df7b435ced4ef376dbe682..69dfb1a49cc8532004f80c30359b7ab36e9630b8 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2112,6 +2112,7 @@ static void team_setup_by_port(struct net_device *dev,
 	dev->header_ops	= port_dev->header_ops;
 	dev->type = port_dev->type;
 	dev->hard_header_len = port_dev->hard_header_len;
+	dev->needed_headroom = port_dev->needed_headroom;
 	dev->addr_len = port_dev->addr_len;
 	dev->mtu = port_dev->mtu;
 	memcpy(dev->broadcast, port_dev->broadcast, port_dev->addr_len);
-- 
2.28.0.681.g6f77f65b4e-goog

