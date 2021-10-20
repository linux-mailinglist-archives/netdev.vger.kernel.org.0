Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A04A435451
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 22:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhJTUIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 16:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbhJTUIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 16:08:43 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB98BC06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 13:06:28 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id i1so4138741qtr.6
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 13:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YXiamRP6zqFfoufsBd4Dh6EhHaWo2yLBQehSvdfmcg4=;
        b=ENY8j02E8hZBjzNTindM6vlMzFkGUcgfMAgs/FvSpui/SQYe8ByvfVdFvfbjOReS5M
         M/mX/NbXD1S/Nb2hpYjkj+wczPbGIz98fqs0CDIkRuvRX7qxQcIILaw0vNQDGJVeOvF/
         EdLQbXen6V7/aXApevel5Hhzo34Ni8kPpYHYqO9aXJ09HXzmcF7Yrgj9Ye3KKkIlmz+d
         uKW7lzv4N1rJpP4w5uTFr82CfG4JX4TW7lz576fs30WX/Wsxin90um276nkBoB8vPmN0
         wIVAwAU7CV6L2DUnbf535jk9ouOZsUJI8aPRPlWXjyrhRC3O3lKvUgv97/zTBzszlpwF
         j6WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YXiamRP6zqFfoufsBd4Dh6EhHaWo2yLBQehSvdfmcg4=;
        b=6DNRnWUYtgrnSuSNnb83H5GoBvO/dMoC4AAVltQtvRW8mSEBgkMZaWBk0wbr8aJTv0
         nuTvLIvrsI+ld+M9pY5N3Y9diX9enEOQ2UOs27U8dEJqzn3n7Us1mV6MarsbIMUWm0pV
         15UZBAaHwZ4zUsBdUWgfqj0ABMjGORqDVV1j06tNIQBg04PzprmcItzPXcElywtHcP2T
         +w0YDij0FxfYzDLGi2r8DcZko2KbOl5RnzQ+GInGXRLOXJn8/AkR+C9uW1YeNXTB/YMt
         KX4bS4d9iC4NnyGGCVI3vrSm703/gpClanxBTSrjEr6W7SywDIByBxvHn0lGmxX6QK+T
         avIg==
X-Gm-Message-State: AOAM531EWzYzi58gwGQozLxfl40qaJZF/+vCIqSs8CwF7LvBQw7JNvYy
        IYz6XNeBQ+wUKwnrfdNOPUL3NI9+Eg==
X-Google-Smtp-Source: ABdhPJy5npMY/BQ888OC5gr0JX/z+Ib7W8fWouUf+/DoWkL7OTUrxr15h8cBVr1yvAM/po1mdWH8og==
X-Received: by 2002:ac8:7d83:: with SMTP id c3mr1393468qtd.383.1634760387495;
        Wed, 20 Oct 2021 13:06:27 -0700 (PDT)
Received: from ssuryadesk.lan ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id i13sm1373749qtp.87.2021.10.20.13.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 13:06:27 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     a@unstable.cc, kuba@kernel.org, davem@davemloft.net,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net-next] gre/sit: Don't generate link-local addr if addr_gen_mode is IN6_ADDR_GEN_MODE_NONE
Date:   Wed, 20 Oct 2021 16:06:18 -0400
Message-Id: <20211020200618.467342-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When addr_gen_mode is set to IN6_ADDR_GEN_MODE_NONE, the link-local addr
should not be generated. But it isn't the case for GRE (as well as GRE6)
and SIT tunnels. Make it so that tunnels consider the addr_gen_mode,
especially for IN6_ADDR_GEN_MODE_NONE.

Do this in add_v4_addrs() to cover both GRE and SIT only if the addr
scope is link.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 net/ipv6/addrconf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index d4fae16deec4..9e1463a2acae 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3110,6 +3110,9 @@ static void add_v4_addrs(struct inet6_dev *idev)
 	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr + offset, 4);
 
 	if (idev->dev->flags&IFF_POINTOPOINT) {
+		if (idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_NONE)
+			return;
+
 		addr.s6_addr32[0] = htonl(0xfe800000);
 		scope = IFA_LINK;
 		plen = 64;
-- 
2.25.1

