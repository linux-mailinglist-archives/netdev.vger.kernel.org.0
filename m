Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A6F3F3941
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 09:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhHUHPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 03:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhHUHPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 03:15:21 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EFBC061575;
        Sat, 21 Aug 2021 00:14:42 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so8854315pjb.0;
        Sat, 21 Aug 2021 00:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d64sHr5B5Q8l4jh+HMlfEo+7I1B8zRJJdtRpfTb8yTE=;
        b=OxgELvsvTZVoJqFsJ0aQI36b1FlaOxfZDaPPcGK25dxmRlIbbyfX8IODEWa9zdMzUs
         gjy0I9lSD9AKjmYD8Nh/RAqiuDGZ7L5/9EQnzbPWYGskritjL2JXMT4XlZQuz5QIb0Zk
         //4q6Sdm21dUiztHiNP35NgxnolaRRBQFIC2ruYWZeCIKj3EA+35ce27qRFiTEdGinqr
         AWv6UG95GHB59kvQYu/mWoYknBT9T9JrSbkHEiYTgaQgmLxirc2elpT8tbsqyK5QuxNc
         cjwCDm1sVULtm9T+6Pl9+c7f8yuXj6qI72gGn+ySOrBs+GnanhwdM9hws2B2KYTdxm1I
         vgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d64sHr5B5Q8l4jh+HMlfEo+7I1B8zRJJdtRpfTb8yTE=;
        b=ZNlNwMkS6u/ggCupNQnTE9TTlrmWusUjlLN+eMgzeXGcbtTX8RQQoWWLHQegO4FFv8
         S+MtSYKOPprTPZsRdsj/muLsA0BKXT2pr0TxBwCO7jH8GjpukyoqO2aNJs3XoZTrPXpJ
         Ykc0/lDjLor1yG647KjHh2jCqLp8EIHPg+7NPs6SSQapJim8vizoS450pHWXBQ5jw0J7
         IXDtmJSVNNyh9C8JlHmjxiCNHuso8KGV0kTAkxsAgKPsi6Zx3inl4r6w0EUNMwAZJ63j
         gkZKtuosVfFTEr7hctT0TWXpKhDJT/OgKurcwKikSlJKEaQe1GSsAXdgQGs52RfWRIv0
         UaQQ==
X-Gm-Message-State: AOAM531WaQzowFNsC2P24PnhlEGB7tkM8EVEDOUXGHXa1pVirpuOT3tV
        4b26cwL96JdVfGEopYP+UEQ=
X-Google-Smtp-Source: ABdhPJxumDzpnaUtwpVrde/2JIooqvWXtjXYqslScKiNGDjI7R0DlJKzBTJXWe6sS8OD/PXWjIMePw==
X-Received: by 2002:a17:902:c10a:b0:12d:97e1:f035 with SMTP id 10-20020a170902c10a00b0012d97e1f035mr19775570pli.52.1629530082300;
        Sat, 21 Aug 2021 00:14:42 -0700 (PDT)
Received: from fedora.. ([2405:201:6008:6ce2:9fb0:9db:90a4:39e2])
        by smtp.googlemail.com with ESMTPSA id c7sm6901973pjc.31.2021.08.21.00.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 00:14:41 -0700 (PDT)
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pshelar@nicira.com,
        willemdebruijn.kernel@gmail.com
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Subject: [PATCH 1/2 net] ip_gre: add validation for csum_start
Date:   Sat, 21 Aug 2021 12:44:24 +0530
Message-Id: <20210821071425.512834-1-chouhan.shreyansh630@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210819100447.00201b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210819100447.00201b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validate csum_start in gre_handle_offloads before we call _gre_xmit so
that we do not crash later when the csum_start value is used in the
lco_csum function call.

This patch deals with ipv4 code.

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Reported-by: syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
---
 net/ipv4/ip_gre.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 12dca0c85f3c..95419b7adf5c 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -473,6 +473,8 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
+	if (csum && skb_checksum_start(skb) < skb->data)
+		return -EINVAL;
 	return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
 
-- 
2.31.1

