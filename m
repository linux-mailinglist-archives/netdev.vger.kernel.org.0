Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAB516AFC2
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgBXSzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:55:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53955 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726664AbgBXSzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:55:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582570552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qmy+/DcMDdUSTfHqKJLRQ4XAfLyXoIHclUXkSdOie50=;
        b=HCxuLk21+tot5ASdVtdeoRKbQIchR//rrTsGIlRVD6dObSHYoXaeX7/ZGvam8Kvso3LF2G
        4ioaPVzBX+drhgFrVWH+6yI9RS4TsrrYvrFtJP6l74/qrsnA7evycc4GMvmpCsw/IHMFYp
        wlZpTIbYEGJfqOqDX7ixjVTWl+hElws=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-D_22_-vgNnGHYgmVLjR77Q-1; Mon, 24 Feb 2020 13:55:50 -0500
X-MC-Unique: D_22_-vgNnGHYgmVLjR77Q-1
Received: by mail-wr1-f71.google.com with SMTP id o9so6034989wrw.14
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 10:55:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qmy+/DcMDdUSTfHqKJLRQ4XAfLyXoIHclUXkSdOie50=;
        b=nbYSeg+L1Ax+7x7+t+WyRko6ATfJku9yJkHuz9CMjQdwJpXAydXuI7c8RnY46kQknG
         9chXwta5xfQb7sERml/KwoLH6lC834CzZCq/DvuyNqNMxUM9ISyJFSoxcw/8FUdfzPSi
         74uRZ9IOFeH1R3L4UEbwud7BQsRub/cGd70mSImnH0dLdYxj8Iwf/Iz1GRXtuAFmV2GG
         WXiV9ykqFRSZ5VlRDqAhoZ35l+3pc7WrMUPGXghLFpWFZnNuQePKtySH+h6X5WZKnDeh
         M9LWBy2jS4N4Gijnw2j/LCXRufwatzeJT3LYlnN+WUfQCWzR5Ch3Fqb7KgMfsJ1FmR4m
         mgvQ==
X-Gm-Message-State: APjAAAUrTzaesi5Jp2aySSjWRVdmFwu1Yd/ipb71t2teauRo5zIQemsy
        p58WcK834OH731fe5sE8Bb+/Ksqd7HxDtXj/DQFSjmJkZNchRpmiizjQOV68Cc1FyQ5zdZdTfK8
        wXLNukappjs+nT/29
X-Received: by 2002:a1c:f712:: with SMTP id v18mr231891wmh.155.1582570547365;
        Mon, 24 Feb 2020 10:55:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqzLfrB7CCT2bx+Wtk4qiWRW9LrVB55nuO7bRVFcYHNgHZmNeHEgXbVGS3DRcBeETJNyhQeCjg==
X-Received: by 2002:a1c:f712:: with SMTP id v18mr231880wmh.155.1582570547171;
        Mon, 24 Feb 2020 10:55:47 -0800 (PST)
Received: from raver.teknoraver.net (net-47-53-225-50.cust.vodafonedsl.it. [47.53.225.50])
        by smtp.gmail.com with ESMTPSA id c15sm19949531wrt.1.2020.02.24.10.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 10:55:46 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH nf] netfilter: ensure rcu_read_lock() in ipv4_find_option()
Date:   Mon, 24 Feb 2020 19:55:29 +0100
Message-Id: <20200224185529.50530-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As in commit c543cb4a5f07 ("ipv4: ensure rcu_read_lock() in ipv4_link_failure()")
and commit 3e72dfdf8227 ("ipv4: ensure rcu_read_lock() in cipso_v4_error()"),
__ip_options_compile() must be called under rcu protection.

Fixes: dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/netfilter/nft_exthdr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a5e8469859e3..752264b3043a 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -77,6 +77,7 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 	bool found = false;
 	__be32 info;
 	int optlen;
+	int ret;
 
 	iph = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 	if (!iph)
@@ -95,7 +96,11 @@ static int ipv4_find_option(struct net *net, struct sk_buff *skb,
 		return -EBADMSG;
 	opt->optlen = optlen;
 
-	if (__ip_options_compile(net, opt, NULL, &info))
+	rcu_read_lock();
+	ret = __ip_options_compile(net, opt, NULL, &info);
+	rcu_read_unlock();
+
+	if (ret)
 		return -EBADMSG;
 
 	switch (target) {
-- 
2.24.1

