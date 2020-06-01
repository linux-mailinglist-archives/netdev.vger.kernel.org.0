Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CC21EA277
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 13:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgFALMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 07:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgFALML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 07:12:11 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563A7C061A0E;
        Mon,  1 Jun 2020 04:12:11 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l1so6105591ede.11;
        Mon, 01 Jun 2020 04:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=czTuxz2CoTD0fHv9cb/RIUM0+nflo6a9HHpNnue05Fg=;
        b=QPgCYOdW18MdnNvpGvIIqghpVZt0hwClQx6lTBAY1h1dTlbx7kJzCnRlXPGQVeyrFt
         VA3i1DGARrsHLL37y8Ap5Cc7UfBlT+VVKOd6eg2mjpSOSd4jeuSWWB2Abn9838dbhZ0r
         bEraHOxVj0yanqSDO/2IWh93JQRpxGIT0s0Nzk/mD2TfLaplOfTHA5KMMi1unhGbKtWC
         k8U/+JM51LrpC5j3t03A0yYP9qlGml1XX+Qe3/Idm4qNV8VI3oy1XkCE+2621Ip3IMBx
         3l/8Z7V/xBTXs2Xb3ZxJudvlA7LZX2hC8n+/+2tPuDorJCK1b/fpMdZwB5EkCoRsdduf
         +xjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=czTuxz2CoTD0fHv9cb/RIUM0+nflo6a9HHpNnue05Fg=;
        b=hdJNY5TMmL5DCLLZ6i8p5juneQ8ERXSnmBISQUdWovw7FyweRbGn4xHZpkV8sBI42A
         gl99qCXj30E6mFwMtBZAhiy9nVXGjFn5h+pd/oANocl24VqgPONeLf/gTGJHdpxKw8Gu
         piy6qH4YXzw/dwnQI3fjnTi4VU/PF71WmI/lfUcWjkk29VUzPla439oUGvfbfT7q57V9
         PKi0iSekzKSFWstK+PUj6/+v/UUxFDjHyv1YhFlNXgRy1b8njcMjLKctmNXQbaVwWe2A
         b0muHvzptzta85ciy01OitMUz+XX0pgUCQyghXyVkx4IKoR46JsSWwE0Dnj4XvbohqyB
         HT3g==
X-Gm-Message-State: AOAM5331Nq4aJpIYHhBTLe3Cc8PjMrFX7Z6xGjGiAmXMs2P+WcLCpY7S
        Im6IDpX4WXnajgVDEJrAvp4=
X-Google-Smtp-Source: ABdhPJx8nJJQm81YEZpmsWNF28u/VBUFA9tk5tgTNRmrEi/WfOhCo400cNlidSnNiRBjvYuOS3fGeg==
X-Received: by 2002:a50:ee18:: with SMTP id g24mr14329517eds.370.1591009930136;
        Mon, 01 Jun 2020 04:12:10 -0700 (PDT)
Received: from X1000-Arch.fritz.box ([2001:171b:2272:c620:bc2a:b7:554a:5740])
        by smtp.gmail.com with ESMTPSA id 13sm14504017ejh.65.2020.06.01.04.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 04:12:09 -0700 (PDT)
From:   patrickeigensatz@gmail.com
X-Google-Original-From: patrick.eigensatz@gmail.com
To:     David Ahern <dsahern@kernel.org>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Patrick Eigensatz <patrickeigensatz@gmail.com>,
        Coverity <scan-admin@coverity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ipv4: nexthop: Fix deadcode issue by performing a proper NULL check
Date:   Mon,  1 Jun 2020 13:12:01 +0200
Message-Id: <20200601111201.64124-1-patrick.eigensatz@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrick Eigensatz <patrickeigensatz@gmail.com>

After allocating the spare nexthop group it should be tested for kzalloc()
returning NULL, instead the already used nexthop group (which cannot be
NULL at this point) had been tested so far.

Additionally, if kzalloc() fails, return ERR_PTR(-ENOMEM) instead of NULL.

Coverity-id: 1463885
Reported-by: Coverity <scan-admin@coverity.com>
Signed-off-by: Patrick Eigensatz <patrickeigensatz@gmail.com>
---
 net/ipv4/nexthop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 563f71bcb2d7..cb9412cd5e4b 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1118,10 +1118,10 @@ static struct nexthop *nexthop_create_group(struct net *net,
 
 	/* spare group used for removals */
 	nhg->spare = nexthop_grp_alloc(num_nh);
-	if (!nhg) {
+	if (!nhg->spare) {
 		kfree(nhg);
 		kfree(nh);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	nhg->spare->spare = nhg;
 
-- 
2.26.2

