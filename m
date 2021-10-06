Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19EA4236CA
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 05:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhJFEAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 00:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhJFEA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 00:00:26 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328FCC061753
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 20:57:56 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id g14so1227271pfm.1
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 20:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UK80SyfLd6llwFc7jco+SVF0N09vq3Pw351kA9XVKCU=;
        b=Gxzp1rmBw3e5S7S06NE2wYw+b2dQtI1fY/mAToXuDEpEwX+U/7y9f5opRKDvxWok7J
         SfUmx2cfybRG2nf+7LKyhbOIKkZXH6VLA0E7jx7W8nOh+f/N4SThaHYG+GMhmOyHddzj
         XLQiEO32yRuvdtC54WaqPeP968I4OFVaOY7qYR1eyMKEqq7h4UBjHd7J1ZaOAuD9ljI6
         HkgZMxcfZyi1XeVyn1yKFCXq8A5pv7yrdrodgGLRvM3j/p4UZdtl8JPT33Jdj4xYAdAL
         xgB8bcuzvccRgJRDGXvSykYQnxZqwfbJZO/zCaSAfaaJHSm48pGN8fgOTXNTmINKyOfK
         ynUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UK80SyfLd6llwFc7jco+SVF0N09vq3Pw351kA9XVKCU=;
        b=hrDcKozbXL5PNzu3FN4KRfzWaw3BN9LTJo9WJdTynORCWpcbXqsPc72JGUTFxUCpnz
         9oPjfjt5DMoAK7rwxGdzFj7Hxl+Yfzxi1NHnEraVGl2zQATocFyfB6gulxynlU1bV5Er
         TBTcGeQoPubW+xxIXY2bM6iU/3VIRcdnPyYhMfAOLomAlA3lva61PtemFkJx3bGPXnWN
         brDt4+80nOnjBWlXM5AkuVbZ8DkyPFpq43IIRM7F590pZE6Immut/4jqNvy7j+TpN0WW
         2aWbgdaM+GE8HbIoDDh+XbMuQ7BUKNL2LKqOXjMvHgVVAV1yK+TqeG7zHnwIs27BIdzp
         S1JA==
X-Gm-Message-State: AOAM531bdfywZGZ8Wu+cKomPdopz71GrSgEOPWSdOxf5It+qhx+xGPhv
        O+16SLxLip1GL+R8Fyp5u/0=
X-Google-Smtp-Source: ABdhPJyCc0vAsmREZd3hR1OCTe3HEHRgCA/UG5g2ECxW+DsNtrjqZ4a6CPJfwP50kk32YmRD+6E1Kw==
X-Received: by 2002:a65:5bcf:: with SMTP id o15mr18552109pgr.379.1633492675626;
        Tue, 05 Oct 2021 20:57:55 -0700 (PDT)
Received: from localhost.localdomain ([218.155.72.34])
        by smtp.gmail.com with ESMTPSA id i24sm3327812pjl.8.2021.10.05.20.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 20:57:55 -0700 (PDT)
From:   Gyeongun Kang <kyeongun15@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org
Subject: [PATCH net-next] gtp: use skb_dst_update_pmtu_no_confirm() instead of direct call
Date:   Wed,  6 Oct 2021 03:57:39 +0000
Message-Id: <20211006035739.5377-1-kyeongun15@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_dst_update_pmtu_no_confirm() is a just wrapper function of
->update_pmtu(). So, it doesn't change logic

Signed-off-by: Gyeongun Kang <kyeongun15@gmail.com>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 30e0a10595a1..24e5c54d06c1 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -539,7 +539,7 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 		mtu = dst_mtu(&rt->dst);
 	}
 
-	rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu, false);
+	skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 	if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
 	    mtu < ntohs(iph->tot_len)) {
-- 
2.25.1

