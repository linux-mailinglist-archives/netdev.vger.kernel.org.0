Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36D82D785C
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406416AbgLKO6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 09:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406270AbgLKO6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 09:58:06 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6BAC0613CF;
        Fri, 11 Dec 2020 06:57:26 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id t18so4720097plo.0;
        Fri, 11 Dec 2020 06:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=em3A8Nk5NANt9qY2CmZu+QBzc0KhlKLYPaDCn5zjKkg=;
        b=V3Lkv+YY2A3P68sn1Q5ogUsPDc2gLjspi25MWWecVaHNaeRrM839vnaY0n13na7eif
         +lneKVV7mjKxwGvg1+WaspqvzEnuZKGz1uyG5Di1nezMbfNF5N4DCurMKtag308aGcRU
         VRI0javscWSV2DcHwaAMspU6+0YEtN0C6t+gkSZHtfRab5K9W2QgxTG+6QIa/uXj+lbS
         lYTlySuk/JxlPcw332mAne67vbmpf4cHinRMYgIV5uNPDFKU6Ve6QVwOLibV6E8DF/aM
         GNWvV/38tujPdPrCVjNSrXEiIs5sULyoW7ngTfGiprRdthagDmAJWypdNMu8YeJbBH2z
         UY4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=em3A8Nk5NANt9qY2CmZu+QBzc0KhlKLYPaDCn5zjKkg=;
        b=F5mHlqNQ0YMHUcWPLOxiWBy4UmJctoOkDeu+icAYgvF2o+yqwT2w5McwkjslL6RxPF
         V0eXEExh0GSr7FnQxXDauR6gXwjFnSMgJiRS7lLyIZB9/ijrOwRueQw/I6xJou8Ilyl/
         65Hn4DNOKRsccyWV+g163Am4GqaYlbFv597qjf4dG3i7qeFgjh9XYBYPPD3aX6pGqBoL
         7GU+GCnxZ4KGpWr2KhObc2GlC0LPoiizoPZxhCXXtPHnBDG5+Jspa2gri91MScGq8ipa
         XPKFqSzZWpQyakuYtS1VavsJQicuXBCywfugo47wzRvl39jV4pHWJcrRTB8WZEjNkEt5
         movg==
X-Gm-Message-State: AOAM533gp+cP4eeRWHZXUOb8fvw9oTcPJIWR7i/ClHET+LXEGw17mx83
        Rab1e+ahQ8wAfqY5aGGAbbE=
X-Google-Smtp-Source: ABdhPJxjg3pIx/LnT0LvpNBF2pBEJoV7ksCRTR0KJ2foHrMJcnVmNEStJfX4fTzFBvoQMop0m6ZSfg==
X-Received: by 2002:a17:90b:388:: with SMTP id ga8mr13725684pjb.108.1607698646153;
        Fri, 11 Dec 2020 06:57:26 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id k23sm10583085pfk.50.2020.12.11.06.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:57:24 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, maciej.fijalkowski@intel.com
Subject: [PATCH net 0/2] i40e/ice AF_XDP ZC fixes
Date:   Fri, 11 Dec 2020 15:57:10 +0100
Message-Id: <20201211145712.72957-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series address two crashes in the AF_XDP zero-copy mode for ice
and i40e. More details in each individual the commit message.


Thanks,
Björn

Björn Töpel (2):
  ice, xsk: clear the status bits for the next_to_use descriptor
  i40e, xsk: clear the status bits for the next_to_use descriptor

 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 5 ++++-
 drivers/net/ethernet/intel/ice/ice_xsk.c   | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


base-commit: d9838b1d39283c1200c13f9076474c7624b8ec34
-- 
2.27.0

