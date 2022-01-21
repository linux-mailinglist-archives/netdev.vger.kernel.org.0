Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1F7495880
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiAUDQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiAUDQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:16:14 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F8DC061574;
        Thu, 20 Jan 2022 19:16:14 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id d10-20020a17090a498a00b001b33bc40d01so5208089pjh.1;
        Thu, 20 Jan 2022 19:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qTWPgy4C4f7UzSODMqHX14vkvQj4GpRA6whe421B97A=;
        b=PSHXzJx+8QfHQGwM//vKlk5vUHTIkRZ7hfe7g5kIEgxmaNvEdYSRwfXTxVGvCNVqle
         RcyPkJ94e7woYYXMRskxLwe2oheXsTK+t9QCcLKV8H2W4tk9ulIdKVJbUO0H9wQGyJSq
         oBa02NZEgrymvL/U3xb8aMa109zaB4TGcGPuh0dApOqHmmXOYmjMyO0EsAN0lOLdKE79
         2/7mhL2fOU//SDu+k5WR86On3ghlKCCwv0Z2VkDKR6KdqxTydRw+XcxUdBV3zt7xds9K
         2rCxQY+tku+nkCzqer3w7f/wFAkUINkuuDLXacJyqyBWdqzEmJZrYSPUoHcpj4tU4JsE
         IgQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qTWPgy4C4f7UzSODMqHX14vkvQj4GpRA6whe421B97A=;
        b=iMxroYfLyNN8qzOSqbvWhEf+qPoLsLhOpZpmVcmdKM5qMeFAKSVf680BTaO30xSm+c
         hVCf1wRyC/8xKwCD1FhmNL+7nIAznpY16rxYZzlbHvwFL5dXLqWKUFBit+2f6BZ4ru8z
         aXGSdbH8bz9DDNez4gl91f3pEUv19n+sharPDP5q9sYfgCdX6SGn3i6iAnOgv9lj/t9l
         R1V+Y4tNuQLsW4ZQsmYf2kNgr81K/EsfqvTq1ayaRjPX2XC5+j0XAbL8DYda/bBSTKfC
         KgXXPqns0/7GFyF+KSIuauoZjOe+Y1Rr7Nsh1lzwghyczh10pPlsbGTjOeLyqQ01PdWb
         9SXQ==
X-Gm-Message-State: AOAM5335eGrImC0Ne6r4lxsBE33gFoGUDWdgn0tqSMGYLNmzh/0palW1
        YZeo3y+gbk1Ffo7IOUBhMMc=
X-Google-Smtp-Source: ABdhPJxIElvGZr3G2fpTrQn0lJY2VQerYVqR5sD6rW9y89cUce7Fp+x9yz4+MqRB34oeMLs1s5rS5Q==
X-Received: by 2002:a17:902:dacf:b0:14b:2081:1c20 with SMTP id q15-20020a170902dacf00b0014b20811c20mr155152plx.13.1642734973709;
        Thu, 20 Jan 2022 19:16:13 -0800 (PST)
Received: from localhost.localdomain ([106.11.30.62])
        by smtp.gmail.com with ESMTPSA id t2sm4954821pfj.170.2022.01.20.19.16.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jan 2022 19:16:13 -0800 (PST)
From:   ycaibb <ycaibb@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, ycaibb@gmail.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] inet: missing lock releases in udp.c
Date:   Fri, 21 Jan 2022 11:15:53 +0800
Message-Id: <20220121031553.5342-1-ycaibb@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ryan Cai <ycaibb@gmail.com>

In method udp_get_first, the lock hslot->lock is not released when afinfo->family == AF_UNSPEC || sk->sk_family == afinfo->family is true. This patch fixes the problem by adding the unlock statement.

Signed-off-by: Ryan Cai <ycaibb@gmail.com>
---
 net/ipv4/udp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 23b05e28490b..f7d573ecaafb 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2967,6 +2967,7 @@ static struct sock *udp_get_first(struct seq_file *seq, int start)
 				continue;
 			if (afinfo->family == AF_UNSPEC ||
 			    sk->sk_family == afinfo->family)
+				spin_unlock_bh(&hslot->lock);
 				goto found;
 		}
 		spin_unlock_bh(&hslot->lock);
-- 
2.33.0

