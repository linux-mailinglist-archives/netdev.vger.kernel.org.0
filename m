Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC979A1FF
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 23:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390274AbfHVVPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 17:15:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46216 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390231AbfHVVPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 17:15:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so6684172wru.13;
        Thu, 22 Aug 2019 14:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HPPqPWkNsX2zIZkcp2fxF4eaN/KGop5jbrLhh+yilBU=;
        b=ZGhish2AOhYKSO7ScnFNPLsvysA/Gn9ttIusTALCvk7ny3jbb8EfBkkR+w8llK6YZj
         kL0HpZ5ipo+5wACm4qkX0j80O33Od7ZHousGzPsOEbJZjp3ieq1IoEr3AYfAHNTAmFFs
         1Zlm67Eh3IwuTy+QAOZbEZZPXpVwzUsyFWyHxSddQ+mK/VZQIM260DYBr5FFhcAJYl61
         DmEYOpL6sDP8AXrHKnFqle+vDk+Hvr8F/Cz5R2jWqiuo1B2A0QJsIxEfuaR/x2JczJV/
         FOJ0y8LdGb6SVBuKjs0kNse2v8/T+ApIHc86b4/ltRGPP51dMEdOvuW0qjjvIMgK+CO4
         lFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HPPqPWkNsX2zIZkcp2fxF4eaN/KGop5jbrLhh+yilBU=;
        b=eT2TBIlOHtKKJuxARx//RYbM/L3DAJfiP4rNDe4eVDA1hBSRbBjVOAcF51IfpKDz62
         NvOV1LARrn/Ju+0cRhRizSPzvXUL+5qUeG3pqLdyd0gTZ6Ifzlpze6mzygefsrAlhGqJ
         uolUmMwrg1utms2U2DkN3mSqyHGDVKEY+HyORoZ3Y6sINtHx4ECGTBYDJmTcDlueV19X
         rp2u8dLQmRMKSI3LdkL+5CikpLiOCAKVlpAN99Ul/3MbNKhl0YRI/v4F/ECKCKbx8TIh
         20GMtMrY1ZM69Cb37Zgu4v/rYfuH6PlblTL1igCFaDo6UvE0b7+w/uz5EM9JYxUdgFUa
         MB5g==
X-Gm-Message-State: APjAAAVhlDr5JCl6v3k4BiNHQWBfPNEOGLWy73mrThqupLOENThUO4+y
        wFqJqm9EnfWpoZsxOXU33qY=
X-Google-Smtp-Source: APXvYqyzVg3G23tzkTO2cy5UNABw5Px3NfCU//hSFDMcjYN2qvJp+7frSCzrxUZQxnVZ1qkX+3DWqg==
X-Received: by 2002:a5d:62c1:: with SMTP id o1mr935622wrv.293.1566508549118;
        Thu, 22 Aug 2019 14:15:49 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id g197sm578488wme.30.2019.08.22.14.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 14:15:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 0/5] Poll mode for NXP DSPI driver
Date:   Fri, 23 Aug 2019 00:15:09 +0300
Message-Id: <20190822211514.19288-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series makes the EOQ and TCFQ operating modes of spi-fsl-dspi work
when no platform IRQ is defined in the DT.

The NXP LS1021A-TSN board needs this setting for performance reasons,
and I am adding the corresponding DTS patch to this series to avoid
runtime errors that may occur if the DTS and the driver patches part
ways and get included through separate trees.

The series also contains a bug fix for the shared IRQ of the DSPI
driver. I am going to respin a version of it as a separate patch for
inclusion in stable trees, independent of this patchset.

Vladimir Oltean (5):
  spi: spi-fsl-dspi: Reduce indentation level in dspi_interrupt
  spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not ours
  spi: spi-fsl-dspi: Remove impossible to reach error check
  spi: spi-fsl-dspi: Use poll mode in case the platform IRQ is missing
  ARM: dts: ls1021a-tsn: Use the DSPI controller in poll mode

 arch/arm/boot/dts/ls1021a-tsn.dts |   1 +
 drivers/spi/spi-fsl-dspi.c        | 128 ++++++++++++++++++------------
 2 files changed, 78 insertions(+), 51 deletions(-)

-- 
2.17.1

