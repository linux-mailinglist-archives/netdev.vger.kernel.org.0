Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC9D21595B
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgGFO0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729140AbgGFO0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 10:26:40 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40491C061755;
        Mon,  6 Jul 2020 07:26:40 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h19so45627677ljg.13;
        Mon, 06 Jul 2020 07:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DBAdXo4SGfFpJlyGQs4ExbH0QX63pXE/JFKfuUgo/Kk=;
        b=ri9Inqz1Y1M6gML7IsqOb2sLY7CKx9MLwk/fF2WPFu/1kXQUZ6rO8H7LPC1q47oyfL
         OdnyHe93GsragA0HLj3aCDjIGv/OMC4EOUvqO4UL2mc59pNUiE1PQC/TUd6WPLCMkw/q
         I3dRrczBEi5m2IxKnGpjoHXfv82QIULP/0ZmGrmHuP7ynsHpdcFtAkLePgXnJ7xDKlnF
         pKS4FXRkyyHI5XLW/olHDQAKwGVaOzQ9JydV5yJOZGHHnnEwIpmhZ+Ft6coZMlPcRsNW
         cEKXg18d338cdtuNEOM1JKsWmkO+f2Hox4eQUp37J25A7kjIynCDo7bUhoO7FuDBPkFy
         oCTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DBAdXo4SGfFpJlyGQs4ExbH0QX63pXE/JFKfuUgo/Kk=;
        b=i6PqRTg4Lc+hQXVOPM1CKTMoCopM5bx16D7mQYbuw4iNBgHAnTryQ2Oqu3GwbGah3G
         MYbV3lnGhAt7Mqp85SB55exBf3w3gLlcJgN+H2TxeyKRlvFsQE+2mFzO3o1qzyfcAfR+
         HyDdwxYEWA851O/VUaLymSUXeCnGNM4xcmDJrhbhju7WrSasdls9yL1SCvpKmN3nQL+/
         bi9vVGkuzY74TeM8XU8ckgo0xPKmWxIrxOqNHmEvbyFpBNuwlridPfEComuiMLOBBcl7
         GLGdmxOvbFju15XF0HCUJnOtppHeD6B93064/ZhREuBXeT1OXwrsjeU2Chsy9l3XdBrv
         518g==
X-Gm-Message-State: AOAM533vCq8T9AIucBhnXCiNmO8Zkv+5jlTLLkxzb4q1dXYhVtASXYuD
        xJ0hgme3OCQ+2lOp1w90K8z4db5y
X-Google-Smtp-Source: ABdhPJyhHxGXn9kjFs0AA2boCiuEKpzQMWG/qld0dm3BXycDGqIUoTTq39h4VBPASffRTQFdKqAUMQ==
X-Received: by 2002:a2e:5cc6:: with SMTP id q189mr17292207ljb.251.1594045598483;
        Mon, 06 Jul 2020 07:26:38 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id m14sm11744638lfp.18.2020.07.06.07.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 07:26:37 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Organov <sorganov@gmail.com>
Subject: [PATCH  0/5] net: fec: fix external PTP PHY support
Date:   Mon,  6 Jul 2020 17:26:11 +0300
Message-Id: <20200706142616.25192-1-sorganov@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a collection of otherwise independent fixes that got developed
out of attempt to use DP83640 PTP PHY connected to built-in fec1 (that
has its own PTP support) of the iMX 6SX micro-controller.

The first patch in the series is actual fix for appeared problems,
while the rest are small style or behavior improvements made during
development of the fix.

NOTE: the patches are developed and tested on 4.9.146, and rebased on
top of recent 'master', where, besides visual inspection, I only
tested that they do compile.

NOTE: for more background, please refer here:

https://lore.kernel.org/netdev/87r1uqtybr.fsf@osv.gnss.ru/

Sergey Organov (5):
  net: fec: properly support external PTP PHY for hardware time stamping
  net: fec: enable to use PPS feature without time stamping
  net: fec: initialize clock with 0 rather than current kernel time
  net: fec: get rid of redundant code in fec_ptp_set()
  net: fec: replace snprintf() with strlcpy() in fec_ptp_init()

 drivers/net/ethernet/freescale/fec.h      |  1 +
 drivers/net/ethernet/freescale/fec_main.c | 19 +++++++++++++++----
 drivers/net/ethernet/freescale/fec_ptp.c  | 24 ++++++++++++++----------
 3 files changed, 30 insertions(+), 14 deletions(-)

-- 
2.10.0.1.g57b01a3

