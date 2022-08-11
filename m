Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D88658F81F
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 09:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbiHKHKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 03:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiHKHJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 03:09:59 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1009E8FD56
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 00:09:56 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id c17so24390656lfb.3
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 00:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=h0orVpEglwSLXEru9jgQKJmaJuYt4bdggifYEzNhZY8=;
        b=NIEgCrpkDI6uU390UEePXPalFUUMsb1cnp8DLahBexXKLR89luySmscmQch+99pUXt
         GZ/3HvPI83kGVqru2Sw0BrbYYxp9t01Jaq14K6E+zYlmHhmNYokYPb+Z3LFoHLT7RPnE
         kBY6m4opOtuNsM3MHFJdaAagHX9Bh9j+XNc6JTXlalZ8FvgFOOeZPGkX2a3VO4KA5Cdr
         ApYV5BcZGm65wYWzD/CRTPeFHuPy/Y5cyAfIi7lD/Gp0SGpszbWj5WTCYoAqTY5HWeb/
         9VgmKLZvBQWUADQfclRPikP33Sp/Ul3LlJ0B3ub71kbWP8/7pxABOC/CnVAIznBDivqf
         6E/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=h0orVpEglwSLXEru9jgQKJmaJuYt4bdggifYEzNhZY8=;
        b=p3K5g5DrIn5YI9/xNxwz3d0QEMRyy8O6X+zUH6/MzpCMI4cMT+W9lQeSywj9MmIn8/
         sR8PrdF2zRwG1ZWbZfByVMGzS+F69kRqXPy4s4WivwqUPA2fyWKA/rB46hDl8G9eAGxH
         MljRI/c8p6wiXqZcMM0t38S5S37OCoLk6BS5Awm3pwVAeXDk7OdD8/fMcxuLcym1CeGd
         ZW4BryI6XEbyvpNSMrJVHROdVoN2Hc6GQyle6xNnMDAYFOA8JdWQFYl0EA96QS5hJE6W
         k9rdkzswApVb4IwH9X0wdxyYc8pI3MUK5DlX8s3WniXRBasqIXKL3o+lKUhxKSVnCf6x
         90zA==
X-Gm-Message-State: ACgBeo308Q8osIX2ES7W6a7sVyimr4Wy/9o1Bwhep7D//4nvQwxAWQ3L
        ZoRzWi1GAu+neTP6mXiIrzT8v6HO6RVF/CWh
X-Google-Smtp-Source: AA6agR7sZcaSMiGRFX50EvQLYJN0KQ0+WKaB70S2o80qXAT7w8iz+i+7hMvlLZWALYuETUWT6NizXw==
X-Received: by 2002:ac2:4e15:0:b0:48b:7a5f:923c with SMTP id e21-20020ac24e15000000b0048b7a5f923cmr9002070lfr.134.1660201794767;
        Thu, 11 Aug 2022 00:09:54 -0700 (PDT)
Received: from saproj-Latitude-5501.yandex.net ([2a02:6b8:0:40c:f682:a160:7363:c1c9])
        by smtp.gmail.com with ESMTPSA id bi20-20020a05651c231400b0025e739cd9a7sm673100ljb.101.2022.08.11.00.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 00:09:54 -0700 (PDT)
From:   Sergei Antonov <saproj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sergei Antonov <saproj@gmail.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH] net: dsa: mv88e6060: prevent crash on an unused port
Date:   Thu, 11 Aug 2022 10:09:39 +0300
Message-Id: <20220811070939.1717146-1-saproj@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the port isn't a CPU port nor a user port, 'cpu_dp'
is a null pointer and a crash happened on dereferencing
it in mv88e6060_setup_port():

[    9.575872] Unable to handle kernel NULL pointer dereference at virtual address 00000014
...
[    9.942216]  mv88e6060_setup from dsa_register_switch+0x814/0xe84
[    9.948616]  dsa_register_switch from mdio_probe+0x2c/0x54
[    9.954433]  mdio_probe from really_probe.part.0+0x98/0x2a0
[    9.960375]  really_probe.part.0 from driver_probe_device+0x30/0x10c
[    9.967029]  driver_probe_device from __device_attach_driver+0xb8/0x13c
[    9.973946]  __device_attach_driver from bus_for_each_drv+0x90/0xe0
[    9.980509]  bus_for_each_drv from __device_attach+0x110/0x184
[    9.986632]  __device_attach from bus_probe_device+0x8c/0x94
[    9.992577]  bus_probe_device from deferred_probe_work_func+0x78/0xa8
[    9.999311]  deferred_probe_work_func from process_one_work+0x290/0x73c
[   10.006292]  process_one_work from worker_thread+0x30/0x4b8
[   10.012155]  worker_thread from kthread+0xd4/0x10c
[   10.017238]  kthread from ret_from_fork+0x14/0x3c

Fixes: 0abfd494deef ("net: dsa: use dedicated CPU port")
CC: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: Florian Fainelli <f.fainelli@gmail.com>
CC: David S. Miller <davem@davemloft.net>
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/mv88e6060.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/mv88e6060.c b/drivers/net/dsa/mv88e6060.c
index a4c6eb9a52d0..83dca9179aa0 100644
--- a/drivers/net/dsa/mv88e6060.c
+++ b/drivers/net/dsa/mv88e6060.c
@@ -118,6 +118,9 @@ static int mv88e6060_setup_port(struct mv88e6060_priv *priv, int p)
 	int addr = REG_PORT(p);
 	int ret;
 
+	if (dsa_is_unused_port(priv->ds, p))
+		return 0;
+
 	/* Do not force flow control, disable Ingress and Egress
 	 * Header tagging, disable VLAN tunneling, and set the port
 	 * state to Forwarding.  Additionally, if this is the CPU
-- 
2.32.0

