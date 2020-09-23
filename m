Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224F3274F6E
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 05:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgIWDMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 23:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIWDMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 23:12:01 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB055C061755;
        Tue, 22 Sep 2020 20:12:01 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d19so6099928pld.0;
        Tue, 22 Sep 2020 20:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/2ZgtPG1P/+XP2UNIOgD2YCw0VR4m0gAL+RLZGXeU4g=;
        b=NBF+oorj+4Vxw8rGjtV6ihCGUmQyPVToBTfLc+RNk8MkW0LyoYkFpvHekJ+XU0AHhv
         gErS9PsVvcA7+1gxi4bkZSOWQC6eIkJwM/KYGW+srkRdAXtgkOze5LxWvTqj/aTOo8bi
         XBPW23qvzL5SJG+vBAXR47qF4h4r2h4tRVHTHMY/rOsBV5f4Ql92mQ76UNfN77WmSV3E
         1f4z6TlH05IfsWM2Gu0WkhN7zgOUCQHsjnIbXdj8PG1DRjieYagNgucn8/oSge5OlsFC
         doI7LbPx1kXI/oq8cp2yR5qvMwmJEreGr8PcTmux/nGuY07DB/zSPu95n2dF4Dunoant
         Rg/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/2ZgtPG1P/+XP2UNIOgD2YCw0VR4m0gAL+RLZGXeU4g=;
        b=eyetvBprtyx3NXMWdhUv0NSzyWJZ0TlSm8Wk+9AAJLdenmDqNZkHs+65wAip6nvkm6
         UdbHZgqjQeQUky7GwR0H3iHpVIJGk4FMAkp8zme1Du59G0hUoezNNgeJYClK3eq9OxNb
         i4+l6cFwa/+DsWCMvhpxQE/yI0psop0zeHFfYUubS/3LpaOxsagWuRPz9Z4ehn2SzONP
         jQTMmN+MJXmeXGSswuIjcJ56cSlGGqok6sxX9vjj7/igw+N/xsmTL+TusIAYimoIlbDk
         sCAJG9OF3S2bqPajM7G5aPamX+i17pIeYJO9w+4tbqMo6vXT5fblt4tuvcwUx++pLWDk
         MrBw==
X-Gm-Message-State: AOAM532J7kBMsVmJB4KtWqg450D75ZQUtgprN/OcHQfaP5b1sY5bjctY
        Jl6QkUspZ5Hd4t+OmTV4ZqHSL3aepVFzug==
X-Google-Smtp-Source: ABdhPJxC+P1nUzqbCPHZZLqiO+uL1BOWV909dQ/CbSQTUOhm7gu/kPG6Jj9+BczhH32c2Lj6JNQvGg==
X-Received: by 2002:a17:90b:707:: with SMTP id s7mr6482322pjz.25.1600830720794;
        Tue, 22 Sep 2020 20:12:00 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x185sm16520351pfc.188.2020.09.22.20.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 20:11:59 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        vladimir.oltean@nxp.com, olteanv@gmail.com, nikolay@nvidia.com
Subject: [PATCH net-next 0/2] net: dsa: b53: Configure VLANs while not filtering
Date:   Tue, 22 Sep 2020 20:11:53 -0700
Message-Id: <20200923031155.2832348-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

These two patches allow the b53 driver which always configures its CPU
port as egress tagged to behave correctly with VLANs being always
configured whenever a port is added to a bridge.

Vladimir provides a patch that aligns the bridge with vlan_filtering=0
receive path to behave the same as vlan_filtering=1. Per discussion with
Nikolay, this behavior is deemed to be too DSA specific to be done in
the bridge proper.

This is a preliminary series for Vladimir to make
configure_vlan_while_filtering the default behavior for all DSA drivers
in the future.

Thanks!

Florian Fainelli (1):
  net: dsa: b53: Configure VLANs while not filtering

Vladimir Oltean (1):
  net: dsa: untag the bridge pvid from rx skbs

 drivers/net/dsa/b53/b53_common.c | 20 ++--------
 drivers/net/dsa/b53/b53_priv.h   |  1 -
 include/net/dsa.h                |  8 ++++
 net/dsa/dsa.c                    |  9 +++++
 net/dsa/dsa_priv.h               | 66 ++++++++++++++++++++++++++++++++
 5 files changed, 86 insertions(+), 18 deletions(-)

-- 
2.25.1

