Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0819427633F
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIWVkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgIWVkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 17:40:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB4EC0613CE;
        Wed, 23 Sep 2020 14:40:49 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id e4so422033pln.10;
        Wed, 23 Sep 2020 14:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hMa7iWioNvh1PzKiBMuORzjgkAqwIcN0uxe+Tkx3Z2I=;
        b=L7ZmBGqsBdH9k8ajlsZrbGpp7V4C2uIzTot1LTiWRvrj2/wMUvLwR71KfXia96Zg8f
         osbcm34W5cy6f/tDWQFDaGsHWIGzheH6FAE7g+0+vJftVTu+DrNP7nt5Ony8aQX5HeYE
         yaatA+x224bT/RxsELpiI0wzadT/QWVfv5B0MKKJ73T6agDB+8SVhjdCk5jczn3+y7rW
         tA/4Zle3/WDOesWDFMmqKYIX4f97rI+HmeHfq6fSNUPpvaV4aJwd+Wn37b0LXs43qdvx
         VjGJjxe9F9yMgEsjcZSKDKfNBEgPxMqdcrrLlp0zneBDh3eOuETNxdBqmsDxrcIU3Q9K
         m/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hMa7iWioNvh1PzKiBMuORzjgkAqwIcN0uxe+Tkx3Z2I=;
        b=qsVozmP01ZWmB5gIiPrpig2y7xe3pC+5Y/xBCLOOnPwQY6DCfGUCdIfpBvGHC8Y9LL
         ww3win68sYamj4K3zOFp5vNFNokLV1Q1Z1MvzQ9kQNXRE/C6Q46Zq0iL+WtdMITQNjcr
         Rc3A12eS/eVDbsZkEl2wEzfEo8SENkVB2g+9EzLp4BQX05gQN3uuNXhUoJyKnr2jH1kR
         nh+Kja3dbqSHTyWz+QgdOtvn1s/5fCl6gKOgiNoMlJcD9iZeSzDHcA3AQzm6r2t+2xC3
         CY8sfGBVjwR7ZKZwzkn0CopA2XRYFpFmDgA6CMcQTnaEsuHdJiruQJTVItwfBEfV77+F
         uqqg==
X-Gm-Message-State: AOAM5300K7qkN3czfN80KEZpRjaRaLPN81ElkzLUA3BQhfAyINOaOdC0
        r4vUlSTLV5zJl9WKeIq/WrgHygzZgMmiCQ==
X-Google-Smtp-Source: ABdhPJxWXOQaVrCReEaLk04FupRVH16fmU02IDxl22A3bpueXyLc4sDA50Soti/iWv2EWpl0kGEfsw==
X-Received: by 2002:a17:902:9a8d:b029:d2:4ef:a1fb with SMTP id w13-20020a1709029a8db02900d204efa1fbmr1726064plp.4.1600897248429;
        Wed, 23 Sep 2020 14:40:48 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a9sm379242pjm.40.2020.09.23.14.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 14:40:47 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        vladimir.oltean@nxp.com, olteanv@gmail.com, nikolay@nvidia.com
Subject: [PATCH net-next v3 0/2] net: dsa: b53: Configure VLANs while not filtering
Date:   Wed, 23 Sep 2020 14:40:36 -0700
Message-Id: <20200923214038.3671566-1-f.fainelli@gmail.com>
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

Changes in v3:

- added Vladimir's Acked-by tag to patch #2
- removed unnecessary if_vlan.h inclusion in patch #2
- reworded commit message to be accurate with the code changes

Changes in v2:

- moved the call to dsa_untag_bridge_pvid() into net/dsa/tag_brcm.c
  since we have a single user for now

Florian Fainelli (1):
  net: dsa: b53: Configure VLANs while not filtering

Vladimir Oltean (1):
  net: dsa: untag the bridge pvid from rx skbs

 drivers/net/dsa/b53/b53_common.c | 19 +--------
 drivers/net/dsa/b53/b53_priv.h   |  1 -
 net/dsa/dsa_priv.h               | 66 ++++++++++++++++++++++++++++++++
 net/dsa/tag_brcm.c               | 15 +++++++-
 4 files changed, 81 insertions(+), 20 deletions(-)

-- 
2.25.1

