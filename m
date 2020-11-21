Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5778D2BBCBF
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgKUDnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 22:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgKUDnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 22:43:31 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5B7C0613CF;
        Fri, 20 Nov 2020 19:43:30 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id j15so7574091oih.4;
        Fri, 20 Nov 2020 19:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y6px9tXuF4Qgiy8xXoUBm2WM7J/cNcGPuCYetBct2LI=;
        b=sSybWjvwjuHeA6Epva/SygtwaCF3Sc4tQBSZYgSVt9DnrhYDSAIbluz2Se8MErK1Rb
         zzj/MOqZvcMwxVFWUX7taHPyDhsPGTj1j8l+ZwLoSncjtrfRvl3K3c7ByUUeI3jUBF+F
         9gt1HsmEygPM2SVCtYc9A9mNKwfivbj5/nOYMCz4H355X924BXBb4yflEoE6zmUhJ/8y
         f213eDE9mxbT3u8lsnPEnYS6mSYNMQOj8NPbZs4qsA+4xzaLg8YRNPj8pxogwli3fT/d
         ivm0mzcc2LlGcHXhVf2jiS7Sc7Pd44jfpM1sfAd1hDemFYtNxSPJYfNglYnqdfJkoNrr
         8H/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y6px9tXuF4Qgiy8xXoUBm2WM7J/cNcGPuCYetBct2LI=;
        b=Ml6nKcGHnGg0U9orb/8Y0mm6kG8iwxBhflB3GFc/coDr8FBBypRKB/mDHEkQ+6xXDN
         1g6o+tb12/QwZ9lp5/+0JoAGE0kycdTmq91KqqZSBNVfUYVG7SF7kpM5IzfDpj4rQdIt
         z+I3D0Ufr/1SrSBZwxzDKamnKmzr7EnCE/zheM5isR45CDyVjMuyNvKN1krBqx4imluQ
         C13wNZLUTkccrekVc/iGtqWBbBST6KMH21WecQj6dtga3aqK6K5Vi4RTJm/W2OF4id/+
         wdHScwIJadH27IBmljVlE1aVEgSAUmdt+5O8RItm8O0F5jhdlJWxRyx1SSMaPMrSQZL5
         HfNw==
X-Gm-Message-State: AOAM530TJFxf4+7JSiAonWHV2HDGRSoIIfBo6XgM4ayg/WM0DWNiHHGG
        gbXvp8spZnEbZ8KGP7wgvbVm3LSOrZBi1w==
X-Google-Smtp-Source: ABdhPJyLARdT6fIZbi0FUO/sHDWLPrPIxxj3KJqnv7rGqm8tRcARwx75jmemC7w7ZC6Gn1a105aZqw==
X-Received: by 2002:aca:4849:: with SMTP id v70mr8953990oia.103.1605930209314;
        Fri, 20 Nov 2020 19:43:29 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c0bb:f8c1:a62c:f78b])
        by smtp.gmail.com with ESMTPSA id k63sm2832685oif.12.2020.11.20.19.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 19:43:28 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>, liuzx@knownsec.com,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree@solarflare.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [Patch stable] netfilter: clear skb->next in NF_HOOK_LIST()
Date:   Fri, 20 Nov 2020 19:43:17 -0800
Message-Id: <20201121034317.577081-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

NF_HOOK_LIST() uses list_del() to remove skb from the linked list,
however, it is not sufficient as skb->next still points to other
skb. We should just call skb_list_del_init() to clear skb->next,
like the rest places which using skb list.

This has been fixed in upstream by commit ca58fbe06c54
("netfilter: add and use nf_hook_slow_list()").

Fixes: 9f17dbf04ddf ("netfilter: fix use-after-free in NF_HOOK_LIST")
Reported-by: liuzx@knownsec.com
Tested-by: liuzx@knownsec.com
Cc: Florian Westphal <fw@strlen.de>
Cc: Edward Cree <ecree@solarflare.com>
Cc: stable@vger.kernel.org # between 4.19 and 5.4
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/netfilter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 77ebb61faf48..4c0e6539effd 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -316,7 +316,7 @@ NF_HOOK_LIST(uint8_t pf, unsigned int hook, struct net *net, struct sock *sk,
 
 	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
-		list_del(&skb->list);
+		skb_list_del_init(skb);
 		if (nf_hook(pf, hook, net, sk, skb, in, out, okfn) == 1)
 			list_add_tail(&skb->list, &sublist);
 	}
-- 
2.25.1

