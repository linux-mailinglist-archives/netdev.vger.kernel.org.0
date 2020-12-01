Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97FD2C9B28
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 10:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbgLAJFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 04:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388191AbgLAJDz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 04:03:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E40A21D7F;
        Tue,  1 Dec 2020 09:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813395;
        bh=ZfyxbyXJNsR7Ox478lYb9kMLqF/gdHTamP66YJE3i8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMLSTeo/UY4hf6kWMcGnfEXNHPpFO6VLtAnY7M934w28oX+BdsadMly5EeyCOLq6j
         65LyEH3LPPPfpTUo7STqhsox2xRVXA9OlPEMjdaam5FXYUC8mIkWtDEAhGJyiiN/lq
         0hNc+UbyLbiESzINkxL/Z0/oRv9Ar6T+UtdAhhjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liuzx@knownsec.com,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree@solarflare.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [PATCH 5.4 04/98] netfilter: clear skb->next in NF_HOOK_LIST()
Date:   Tue,  1 Dec 2020 09:52:41 +0100
Message-Id: <20201201084653.262544594@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/netfilter.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -316,7 +316,7 @@ NF_HOOK_LIST(uint8_t pf, unsigned int ho
 
 	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
-		list_del(&skb->list);
+		skb_list_del_init(skb);
 		if (nf_hook(pf, hook, net, sk, skb, in, out, okfn) == 1)
 			list_add_tail(&skb->list, &sublist);
 	}


