Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47C82A8F96
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 07:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgKFGoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 01:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgKFGoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 01:44:02 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C51C0613CF;
        Thu,  5 Nov 2020 22:44:02 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z3so401334pfb.10;
        Thu, 05 Nov 2020 22:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wzNWXW0+IF3N8GCMYR4RSS5kyM9XGdTa6wteuIyEpFc=;
        b=fpNfc75Qq9D/2zSeopStW1hEOtt3LP8/mI29ZBSrkIT3LawBeusAG6S29xoazcRJYr
         Uv22dHKvDpYBCLWrQWtoL/JAUFRbnNs0qto2N2fWuVs8Ma7klPY3mbW4P9Cd17oI/s0q
         0ShJDNLJpbNgCwFCqLiZ8pYd28goI3isFcgzJwRH/IsPJdMWcQUgLooLsXHVSZ0SDO9p
         d9znbFeX11g5P4TeOt8vtvs8ViB54CS37y9ikAhea+dYLrrfsaVGRto0YcP95SpzNYqZ
         aMTg19QiAPX6W4NSN/yymUmFpfNv8gaDai8skMyLBnOiH9tzixLFgD23IaM9RmcG+Z1e
         XttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wzNWXW0+IF3N8GCMYR4RSS5kyM9XGdTa6wteuIyEpFc=;
        b=E9CiqXrMEJyW939k89AXmZ942DIHFTs3CrcCMoYO8Eaaez9QaySKSyvM8TCBVOX46t
         0QpufzBhlJLg2cYpcHbrAjNruy5W8VmijJVg/T2bNyYUHNVumRR+0B5EKGC9Ubo5c0+Q
         WovV2rS5fDF/bznJ91Km/j6vnaz9VzxXFJK5SNwFNehyxlbO4G2z8rpiZjxOBSn2T2hO
         rBIeGWF7lVxo5ZlBl67eUMscIxZ5a4ihAUx3BWv/0hyy7kDmooccxk3HM14i3nnGqY+G
         4Euf2p3dtpA3ss3DU5C3L0kOHYsb9pY5LUQJh9gUz8jNf8orrjzRCe5gW6ttSZR6AU5a
         Eweg==
X-Gm-Message-State: AOAM533zJ46TAA9EXqj/39m1fe4Yx7UXRuxLTqt/dQRO/bewGV45XyYv
        bHgqJjg7aRt7+nJbyqPYwC0=
X-Google-Smtp-Source: ABdhPJwl6RftUneC3jTR45Lmb40ePwhG7xrSJOhyvInKxUCRK5zQhfJorobMZhssxJz2EJxjirGmuw==
X-Received: by 2002:a17:90b:942:: with SMTP id dw2mr876358pjb.14.1604645042465;
        Thu, 05 Nov 2020 22:44:02 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id g1sm837820pjt.40.2020.11.05.22.44.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2020 22:44:01 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH] net: udp: remove redundant initialization in udp_gro_complete
Date:   Fri,  6 Nov 2020 01:42:39 -0500
Message-Id: <1604644960-48378-3-git-send-email-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn>
References: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The initialization for 'err' with '-ENOSYS' is redundant and
can be removed, as it is updated soon and not used.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/ipv4/udp_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index b8b1fde..65860f8 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -554,7 +554,7 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
 {
 	__be16 newlen = htons(skb->len - nhoff);
 	struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
-	int err = -ENOSYS;
+	int err;
 	struct sock *sk;
 
 	uh->len = newlen;
-- 
2.7.4

