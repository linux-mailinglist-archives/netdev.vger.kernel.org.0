Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E043F3942
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 09:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhHUHPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 03:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhHUHP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 03:15:29 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE9BC061575;
        Sat, 21 Aug 2021 00:14:50 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id t42so8038441pfg.12;
        Sat, 21 Aug 2021 00:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G2F9LcG3CzlqOOitDkVcplNgqWD9v/P1osOYyggjlHo=;
        b=Lp5PGR4UvGg/Nv5nQangIEIvKsSc/VPWdnj781TfUlHSLh48xqOgo9vRwByC8fBELE
         1R/126BE98KvaRoi6Zjn4ZSfx6si6J1zDxDPAiruX+3th/T0altsH2g8zBCKaNAe6Isl
         HFCttqw+QJaprRpWzE6MK5t6rmyqIoR1yz1ogNswgONpHbTsz2UBd8k0neh2F/xOl76C
         eRzy/xq697131P5sUZjMhslwXtI+hEHJJi2hQbm3gVloTAQfTA42TVBlE66wTA83pqeX
         jJ1rBlTxEqgCD0C8zE43vLvetdBFuaqpeT5X+LFpij+g4UJMaruza4ewHt7Z1a0KTP7s
         6G9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G2F9LcG3CzlqOOitDkVcplNgqWD9v/P1osOYyggjlHo=;
        b=LjORUc6YrZPL8ud9TBVvTy32IT/fTIho8SxDWxhOGa+/amsWHChpcCJxZlcEkK7jOf
         xYuEiZiX93OkYIp9gg35ULnllyb7Ev9czWIP1Q8zJlMJxJwhNYdgu6nvV59Xu3E1GuXR
         L3NFU4QXBVUTosdRen+U0E4Gc7ZLbANvhQoaw59PyGSGXtoKE1XOvMjoXiy3ccuf4+jt
         VHyX08207jaZ3Zz4LtW1Isq04BX40M120YXXNyvYXa1D4jO2KO85kyiepn0CD6D4wkko
         iYJw3a4Xtsp4txXtBT9ceRz2sWi6qy8oDGHTaOExQDP0nbsnh7rLoPdDyLSF2DXZV4q/
         +bLA==
X-Gm-Message-State: AOAM533x/lzr5FAzBU56BybM91OOtIcEwg4j2ERlICzvYhbBO6GBep4E
        BGYQifv0nMNobKabriCHmTg=
X-Google-Smtp-Source: ABdhPJwpBRh3emBs6A3HeggDiou5daSspA79nMlz5XXQ25O0I3OvTdZFhhS0OG56Zf179R0XfC60aw==
X-Received: by 2002:a63:d104:: with SMTP id k4mr22021585pgg.196.1629530090472;
        Sat, 21 Aug 2021 00:14:50 -0700 (PDT)
Received: from fedora.. ([2405:201:6008:6ce2:9fb0:9db:90a4:39e2])
        by smtp.googlemail.com with ESMTPSA id c7sm6901973pjc.31.2021.08.21.00.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 00:14:50 -0700 (PDT)
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pshelar@nicira.com,
        willemdebruijn.kernel@gmail.com
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Subject: [PATCH 2/2 net] ip6_gre: add validation for csum_start
Date:   Sat, 21 Aug 2021 12:44:25 +0530
Message-Id: <20210821071425.512834-2-chouhan.shreyansh630@gmail.com>
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

This patch deals with ipv6 code.

Fixes: Fixes: b05229f44228 ("gre6: Cleanup GREv6 transmit path, call common
GRE functions")
Reported-by: syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
---
 net/ipv6/ip6_gre.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index bc224f917bbd..7a5e90e09363 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -629,6 +629,8 @@ static int gre_rcv(struct sk_buff *skb)
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
+	if (csum && skb_checksum_start(skb) < skb->data)
+		return -EINVAL;
 	return iptunnel_handle_offloads(skb,
 					csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
-- 
2.31.1

