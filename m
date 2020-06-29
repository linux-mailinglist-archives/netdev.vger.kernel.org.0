Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B036920E18F
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387399AbgF2U5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731258AbgF2TNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:06 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7B9C08EB26
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:34:46 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p3so7849350pgh.3
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=h7yXtV39KyW85wq2ZECCNMKIw9vW1awYTqT5eHSvP2s=;
        b=TpNKL/r4ncu4aE+jFlC/thHtfsZUPy86bjJ9++Uo3LIZ46lFDQa6Wz4rGoNIJrwAPa
         +KcxUkq5+rSJZca+Dp4rQX7ELBXy87XvnbT52dv9R0G2z6/cb1h/rAnWCj3wL4VL6Ngp
         7nmCjPP0cHDWylx4snYBcxr5EY2AXft66dfi0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=h7yXtV39KyW85wq2ZECCNMKIw9vW1awYTqT5eHSvP2s=;
        b=WOhjEHbWugu9lJfS2Fslhz+T1a5ZKt1RJQln72uH1go4e5YWdruhx2GHH2jwa6GdVB
         mKF/sKqP3JcUTzuh+/iMPwbQbg5B3fztLPSgu+VxMbrHf4UGwkoWvTtCUZ1VcvPZvCRc
         J3HcJ5OA2e5/2C/nObvB946uNNSXOZvz1BWzTBCY/pPPdhYX4nn5xHjM9zD3+vDco+TQ
         ciFOTV9r9sR2p5w3jHCGXHWthmrut+qrCRAYcxVhXqwFhdq3Y55Qa3z3OWtwoJCmL06m
         umnPS1t+mlnO5682UebGv8sWRVfJgm+3Ax6rQGAafqKQTbf2TGb0XSTbP4G9c/HhUPNJ
         MHxQ==
X-Gm-Message-State: AOAM531G3PNuby7m+lUABVtQ00FsmPW6faHL80+pFOsbNAAYIiF7I7JO
        WuUYnJ2UhT1M+aoO0CqKuUsyNA==
X-Google-Smtp-Source: ABdhPJyiCFIh8otQ9yqJWrv9zv7x934JKuKp0LezLi/7EFJg1WYgtLtNC0zEjvlASykKciepFlLCfA==
X-Received: by 2002:a63:7a56:: with SMTP id j22mr8737473pgn.194.1593412485383;
        Sun, 28 Jun 2020 23:34:45 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i125sm28058416pgd.21.2020.06.28.23.34.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jun 2020 23:34:44 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 0/8] bnxt_en: Driver update for net-next.
Date:   Mon, 29 Jun 2020 02:34:16 -0400
Message-Id: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements ethtool -X to setup user-defined RSS indirection
table.  The new infrastructure also allows the proper logical ring index
to be used to populate the RSS indirection when queried by ethtool -x.
Prior to these patches, we were incorrectly populating the output of
ethtool -x with internal ring IDs which would make no sense to the user.

The last 2 patches add some cleanups to the VLAN acceleration logic
and check the firmware capabilities before allowing VLAN acceleration
offloads.

Edwin Peer (2):
  bnxt_en: clean up VLAN feature bit handling
  bnxt_en: allow firmware to disable VLAN offloads

Michael Chan (6):
  bnxt_en: Set up the chip specific RSS table size.
  bnxt_en: Add logical RSS indirection table structure.
  bnxt_en: Add helper function to return the number of RSS contexts.
  bnxt_en: Fill HW RSS table from the RSS logical indirection table.
  bnxt_en: Return correct RSS indirection table entries to ethtool -x.
  bnxt_en: Implement ethtool -X to set indirection table.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 223 +++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  20 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  49 ++++-
 3 files changed, 224 insertions(+), 68 deletions(-)

-- 
1.8.3.1

