Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AF41B1CC6
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgDUD1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgDUD1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 23:27:52 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCD5C061A0E;
        Mon, 20 Apr 2020 20:27:51 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id k22so4833975eds.6;
        Mon, 20 Apr 2020 20:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fTnFtlLIjQ4ctTNxrYfruz6kYD2EM/yEpfWSdk9GMA0=;
        b=VbTon4J/UoWS/hBDxZt0Hdw07OQZzRffPSlAK8XZWwHbDhpWL+G6AAuSXly287FpJD
         DmvZOKcLYeMx9c2iNHKtR/zSWtiyQb9nJRFxp69Q+18U+vupaniQH3OVAma8jamGWZ05
         gCNbrp3lsZTV/8ELT0dx8qLjmmSn5dJPtrG3BB/LuB+PpQ21jxDgWVRniQyP4Fw/wa/V
         IyV5al2MF3A7Py33xwj6GteS0VEr5vEBfY766Z/YcHJ7Tq7G+41UOi/Sn9rZzA0aFDSo
         895aQBVqBneIIXNex6MZY8Om8D28ZdcqLfnk76f7FkgVGNfbiJLfgctLgunnSKR6i80b
         EYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fTnFtlLIjQ4ctTNxrYfruz6kYD2EM/yEpfWSdk9GMA0=;
        b=meOboO9bUfhQM+5/r/AudVc4U6kYWVqk8uPmBFij/aZq9/3NmvywaEqfYn46W9di9o
         ghbDzzjEXHYseUmMnsLsdkKsgvVxcLcrde6kOwsf7N8Qc2g4U+NdwzWnhrDV56xAlZCt
         JX/rDXAgnPB+ve8amd0uhvZJ8FRXDYEtzOSwdgNzr79Qroqm0I5j4pKFwAGxS7v6hDhh
         uIUjrD6KEY65JtGCA8tmxM+A4xAxKtiL8Id+XfOmjljD0cxV30Vacb2mll9bXGikbGVn
         YKyFIC12n1XEqGgSdFyObCvfdPWhY5EHYx83bcvLO0i2bmtSSvkZz42iWrx3NAWf3Ao9
         Mwvw==
X-Gm-Message-State: AGi0PuYKzlJjlHLGY7cPds5RjOB0lUWttN7cr4xdUnzhuPXELHTM9WKW
        dJDmalPedtKmo0UUrOYX9LmNouaH
X-Google-Smtp-Source: APiQypIYi3y7Wh5qcpYEcvjWC0bma98ysy4nV2i7LcuvuGH+/tvCTEsrNxpR4NZaIPIMq5iSHDhQHQ==
X-Received: by 2002:aa7:cd01:: with SMTP id b1mr7053880edw.163.1587439670080;
        Mon, 20 Apr 2020 20:27:50 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9sm216836edl.67.2020.04.20.20.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 20:27:49 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org (open list), davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net v2 0/5] net: dsa: b53: Various ARL fixes
Date:   Mon, 20 Apr 2020 20:26:50 -0700
Message-Id: <20200421032655.5537-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Andrew, Vivien, Jakub,

This patch series fixes a number of short comings in the existing b53
driver ARL management logic in particular:

- we were not looking up the {MAC,VID} tuples against their VID, despite
  having VLANs enabled

- the MDB entries (multicast) would lose their validity as soon as a
  single port in the vector would leave the entry

- the ARL was currently under utilized because we would always place new
  entries in bin index #1, instead of using all possible bins available,
  thus reducing the ARL effective size by 50% or 75% depending on the
  switch generation

- it was possible to overwrite the ARL entries because no proper space
  verification was done

This patch series addresses all of these issues.

Changes in v2:
- added a new patch to correctly flip invidual VLAN learning vs. shared
  VLAN learning depending on the global VLAN state

- added Andrew's R-b tags for patches which did not change

- corrected some verbosity and minor issues in patch #4 to match caller
  expectations, also avoid a variable length DECLARE_BITMAP() call

Florian Fainelli (5):
  net: dsa: b53: Lookup VID in ARL searches when VLAN is enabled
  net: dsa: b53: Fix valid setting for MDB entries
  net: dsa: b53: Fix ARL register definitions
  net: dsa: b53: Rework ARL bin logic
  net: dsa: b53: b53_arl_rw_op() needs to select IVL or SVL

 drivers/net/dsa/b53/b53_common.c | 38 +++++++++++++++++++++++++++-----
 drivers/net/dsa/b53/b53_regs.h   |  8 +++++--
 2 files changed, 39 insertions(+), 7 deletions(-)

-- 
2.17.1

