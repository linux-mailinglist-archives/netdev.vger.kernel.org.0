Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13D02AFCFF
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgKLBcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbgKLAki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 19:40:38 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D732BC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 16:40:36 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id h6so2676353pgk.4
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 16:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3P8EmAqtg5xwwjMd3ZN6EYRBAIOuxWsNBKu5J84nJKU=;
        b=cMkcs2KYO2kdqIIJc7OD9eAYiCdUppDaQ8Acznv/d17ikxEsvz4Oa0pPnNgI1bpXD2
         2h3p5Ufn4hBDJQlou1CWNUjdFjtwhEEaBxKVDgBrdfKrvKMnhFz+Pd7fc7r6Jr6xq/lo
         0cLNzI5sfcyhfwXcY2djWIkgcwVKNEODZC3vSAACmTj2xyKNBjerbcC9ZWtBGoNw0643
         cF2N7gvEJ2Z5Xrg4jXgu4dfFE9i7PJYU1vvfCSTvxH+sWYarouvKgcJmByGGK2x35EiG
         kLXeliNl0KlmH+d7t52FzlHIaAcZ81TOCuNboPKFlF7VkDCBP7C9uQaeO/SrV9ennbcF
         Ky4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=3P8EmAqtg5xwwjMd3ZN6EYRBAIOuxWsNBKu5J84nJKU=;
        b=KfmRbX7sbtZyvda7c/u7HJeje9eq9YICaSZCppdA/3p9P9elA+3ip36z713q8bsJaO
         P0wtBckw8o1LKGI3NLLcSYs9qPe9wR+tTAMCt10hAezS3O23r12PAuSDpkoPWcaByhLW
         amIjwdlzQ4+HeoBvsK1g/7ruMkaukDDe45UEC4gFaG+CfVZLuYPcAOPr2SwoCdig5Ro1
         kNRs7buy0ksmo5Exo/UPEqqd27SfQpfarvESG+o0/8DaHwbC1LHjL3iQz+WarVWburLV
         P6ooJzzvvSQAmSkQ6DVwb8KRzo55J3IqPqucuYhaUf35FbjNxpuFoWJ0m1vg5A9OeQWB
         dYsA==
X-Gm-Message-State: AOAM533TWBpVnlJaTUe8lwqkIDYKeutMZL0OO4Kc5bV3zFlDXCeecL5V
        8e9pjBBrae4x+syyG95WXfJU7lc57YJC4Q==
X-Google-Smtp-Source: ABdhPJxvcGVK2TciT3z0KY0JWSnNN8lYG0yWzS0s6p+ZPIAdYsYagFkHsT1RgQo20GrHLpSVqvckXw==
X-Received: by 2002:aa7:8ed0:0:b029:18a:e177:7bce with SMTP id b16-20020aa78ed00000b029018ae1777bcemr152607pfr.0.1605141636257;
        Wed, 11 Nov 2020 16:40:36 -0800 (PST)
Received: from localhost.localdomain ([45.124.203.14])
        by smtp.gmail.com with ESMTPSA id 23sm3848394pfx.210.2020.11.11.16.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 16:40:35 -0800 (PST)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org
Subject: [PATCH] net/ncsi: Fix re-registering ncsi device
Date:   Thu, 12 Nov 2020 11:10:21 +1030
Message-Id: <20201112004021.834673-1-joel@jms.id.au>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a user unbinds and re-binds a ncsi aware driver, the kernel will
attempt to register the netlink interface at runtime. The structure is
marked __ro_after_init so this fails at this point.

 Unable to handle kernel paging request at virtual address 80bb588c
 pgd = 0ff284bb
 [80bb588c] *pgd=80a1941e(bad)
 Internal error: Oops: 80d [#1] SMP ARM
 Modules linked in:
 CPU: 0 PID: 128 Comm: sh Not tainted 5.8.14-00191-g79e816b77665 #223
 Hardware name: Generic DT based system
 PC is at genl_register_family+0x1d4/0x648
 LR is at 0xfe46ffff
 pc : [<807f575c>]    lr : [<fe46ffff>]    psr: 20000013
 sp : b52c9d10  ip : bcc125d4  fp : b52c9d5c
 r10: 8090fedc  r9 : 80bb57a8  r8 : 80bb5894
 r7 : 00000013  r6 : 00000000  r5 : 00000018  r4 : 80bb588c
 r3 : 00000000  r2 : 00000000  r1 : bcc124c0  r0 : 00000018
 Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
 Control: 10c5387d  Table: b4dcc06a  DAC: 00000051
 Process sh (pid: 128, stack limit = 0xe54c9aea)

 Backtrace:
 [<807f5588>] (genl_register_family) from [<80913720>] (ncsi_init_netlink+0x20/0x48)
  r10:8090fedc r9:80e6c590 r8:b4db4800 r7:00000000 r6:b52dc478 r5:b4db4800
  r4:b52dc000
 [<80913700>] (ncsi_init_netlink) from [<8090f128>] (ncsi_register_dev+0x1d8/0x238)
  r5:b52dc444 r4:b52dc000
 [<8090ef50>] (ncsi_register_dev) from [<8064f43c>] (ftgmac100_probe+0x6e0/0x838)
  r10:00000004 r9:80a5d898 r8:bd141410 r7:bd140900 r6:bd7f2c84 r5:b4dbdb88
  r4:b4db4800
 [<8064ed5c>] (ftgmac100_probe) from [<805d4d90>] (platform_drv_probe+0x58/0xa8)
  r9:80e527cc r8:00000000 r7:80eb4bcc r6:80e527cc r5:bd141410 r4:00000000

Signed-off-by: Joel Stanley <joel@jms.id.au>
---
 net/ncsi/ncsi-netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
index adddc7707aa4..1641ecbb5b1f 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -756,7 +756,7 @@ static const struct genl_small_ops ncsi_ops[] = {
 	},
 };
 
-static struct genl_family ncsi_genl_family __ro_after_init = {
+static struct genl_family ncsi_genl_family = {
 	.name = "NCSI",
 	.version = 0,
 	.maxattr = NCSI_ATTR_MAX,
-- 
2.28.0

