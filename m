Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE032B5705
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgKQCo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgKQCo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:44:59 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270B5C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:44:59 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 131so5556374pfb.9
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pd1zYh5RVEYnJOC3MzDRHf+Tit96UpAzZR80A62Org0=;
        b=s8XjI2sgOKo6I1uz6WseYIzvxucVKoM6YRCyA+rwvik58NoPFASiEKhP3Y+1LtDwOG
         QEEBcconBE633m0S3ixwFdI6K+R+xcQprjIg2epB/TyUGRdzBIziJUg2A76L8iSeAhxM
         MByk1bR4XXD/JYSgQ7suxIcnaW+uk+Bv9z8W/RoY+e+4iQC+3+Ji0Ab7T6FuDi/ZKfhA
         1pikUBh1DDtCHGvssJvIx4wAjeO114HFGFlk9ZTV9MH0Xuz5ciSs64QgO2J3ULSAsmPy
         qO+/W5OxxTA2TmtEQrBd/nM3Ifc/ChuCFZcPdehaeK54HOZOwVFjY2J7wxYg77Xx156A
         1VlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Pd1zYh5RVEYnJOC3MzDRHf+Tit96UpAzZR80A62Org0=;
        b=IzELqLgSAPTFWeHT3k7TYUyjJxLk8jyY5rDdXJJAAeSMQMHrB3Egg9gCkz/CzjKl9p
         elvJ6rTq/ZU2Vd0ajLQRqAI6ClAe0noaeLfVoyax0UuDD8EYvfDOfuikQzpqm6hoEsVE
         u/Pzz3mMDjlsdM1OhXHAqWF7YbYNuCvRvVXuUyFvDVtM44hKFetiJYXrIEvcSoLf9CIv
         amlnQlnFi/DOXrEqqIYkLIFEjyC8V16MSjrxjsXuiq+jaQ4P2n1OzBKD5ic62/P557hV
         KIdcCUn3Q3RLlhfpCLqWlX7YUvkuYBWzqoNqltqH/qheA8KS+KEPzE8cvcigtG5ZEoeF
         C+Fg==
X-Gm-Message-State: AOAM533705vb3Oer0T6L1RqNrN+4fResII5nbS+CNEzPqZF2pjQLh7xv
        p0krQVZVa1ha9A0PaqmO+1hrscpXUs6RWQ==
X-Google-Smtp-Source: ABdhPJw84zw9RV+OfJT0eSRiAWJYWBolg1Dajj7i8HkY6Ipn/sZJEsW/9JqOacizDFOJE+T8b6uvaQ==
X-Received: by 2002:a63:5b4a:: with SMTP id l10mr1733193pgm.259.1605581098638;
        Mon, 16 Nov 2020 18:44:58 -0800 (PST)
Received: from localhost.localdomain ([45.124.203.19])
        by smtp.gmail.com with ESMTPSA id e8sm855820pjr.30.2020.11.16.18.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 18:44:57 -0800 (PST)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     Jakub Kicinski <kuba@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Ivan Mikhaylov <i.mikhaylov@yadro.com>, netdev@vger.kernel.org
Subject: [PATCH net v3] net: ftgmac100: Fix crash when removing driver
Date:   Tue, 17 Nov 2020 13:14:48 +1030
Message-Id: <20201117024448.1170761-1-joel@jms.id.au>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When removing the driver we would hit BUG_ON(!list_empty(&dev->ptype_specific))
in net/core/dev.c due to still having the NC-SI packet handler
registered.

 # echo 1e660000.ethernet > /sys/bus/platform/drivers/ftgmac100/unbind
  ------------[ cut here ]------------
  kernel BUG at net/core/dev.c:10254!
  Internal error: Oops - BUG: 0 [#1] SMP ARM
  CPU: 0 PID: 115 Comm: sh Not tainted 5.10.0-rc3-next-20201111-00007-g02e0365710c4 #46
  Hardware name: Generic DT based system
  PC is at netdev_run_todo+0x314/0x394
  LR is at cpumask_next+0x20/0x24
  pc : [<806f5830>]    lr : [<80863cb0>]    psr: 80000153
  sp : 855bbd58  ip : 00000001  fp : 855bbdac
  r10: 80c03d00  r9 : 80c06228  r8 : 81158c54
  r7 : 00000000  r6 : 80c05dec  r5 : 80c05d18  r4 : 813b9280
  r3 : 813b9054  r2 : 8122c470  r1 : 00000002  r0 : 00000002
  Flags: Nzcv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment none
  Control: 00c5387d  Table: 85514008  DAC: 00000051
  Process sh (pid: 115, stack limit = 0x7cb5703d)
 ...
  Backtrace:
  [<806f551c>] (netdev_run_todo) from [<80707eec>] (rtnl_unlock+0x18/0x1c)
   r10:00000051 r9:854ed710 r8:81158c54 r7:80c76bb0 r6:81158c10 r5:8115b410
   r4:813b9000
  [<80707ed4>] (rtnl_unlock) from [<806f5db8>] (unregister_netdev+0x2c/0x30)
  [<806f5d8c>] (unregister_netdev) from [<805a8180>] (ftgmac100_remove+0x20/0xa8)
   r5:8115b410 r4:813b9000
  [<805a8160>] (ftgmac100_remove) from [<805355e4>] (platform_drv_remove+0x34/0x4c)

Fixes: bd466c3fb5a4 ("net/faraday: Support NCSI mode")
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
v3: Apply to net so it can go in as a fix
v2: Also unregister in _probe
---
 drivers/net/ethernet/faraday/ftgmac100.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 00024dd41147..80fb1f537bb3 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1907,6 +1907,8 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	clk_disable_unprepare(priv->rclk);
 	clk_disable_unprepare(priv->clk);
 err_ncsi_dev:
+	if (priv->ndev)
+		ncsi_unregister_dev(priv->ndev);
 	ftgmac100_destroy_mdio(netdev);
 err_setup_mdio:
 	iounmap(priv->base);
@@ -1926,6 +1928,8 @@ static int ftgmac100_remove(struct platform_device *pdev)
 	netdev = platform_get_drvdata(pdev);
 	priv = netdev_priv(netdev);
 
+	if (priv->ndev)
+		ncsi_unregister_dev(priv->ndev);
 	unregister_netdev(netdev);
 
 	clk_disable_unprepare(priv->rclk);
-- 
2.29.2

