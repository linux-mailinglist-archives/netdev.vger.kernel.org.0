Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D913A2B03
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 14:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhFJMHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 08:07:18 -0400
Received: from mail-ej1-f44.google.com ([209.85.218.44]:46039 "EHLO
        mail-ej1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhFJMHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 08:07:14 -0400
Received: by mail-ej1-f44.google.com with SMTP id k7so43701864ejv.12
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 05:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=maUiGF2VHEUc5VH+pzNTaQe1wbHTLgvuD4shjy/n6kA=;
        b=B7oqlCKzvxSAB8tfvXE1A68qgl3c6c+nPkxYs8oW80EflWI6Oz19i2Jf2qWczzl0IU
         ufuhBiQRZIpGdTvrCBzsqA6ncmOzOfGe2mlePgX2k7tlAkkaW3ngVQ1yLQgOWRZm+7OL
         f7QiraeHc5enY8EeEwYLeq3Aju+Z7HBRu2PBg9d15OR+IoVtVRDfqsxlK/WwKqElP7V8
         AZv0M+zxt9NN69TKe0K0nJtVqtn6iS5/03SALVjeodX3p7xqwd11oz/7iJ+OzVtDrFP8
         mNfI4wDiSouOzQ8UW1JWoNTqOQz9zFnWR4w2G3Lr9wHb8hF7xhp4c7cwBpN4bN2KUcsR
         wktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=maUiGF2VHEUc5VH+pzNTaQe1wbHTLgvuD4shjy/n6kA=;
        b=oNzWq1OdhZwXUQu4kLMyY0xzS5z6C1D+i6VufldURAV5XOvKRPSsdgVcYBjkQpuxuv
         D2cnmb6yhmUEv7gtV7oyNlwwXB1hol325+hMVsvlA7b2AGfclU5ECSds/Lw6EXUT1RwM
         tTyJ5O92L34pvpiLnfiE/qyW1fVsyKKHcswGVWaKP2rRhIfCkudNMDlKgVSE9Fko9sMp
         H4NAURIvWhQl/q6hojyXTdZjXIzw9/9fUSTAhu2ImNBL+sdPVp+XeDVeehQLF6OWR7NZ
         FRAdMNBpcnUQ2ZVxvpWXfqyJycXQpWxoyBw6cH0Sc05FeT/jw1Um2VRkSJtF89x8ht77
         iOYw==
X-Gm-Message-State: AOAM5304A5pb/XYjH5bqBnLL1Nz1jR9zi9+S8dKKN8wN3Ufhw41as+/S
        uHa+5rUrXAasFz8EhevcBtaWmR9vqrhWR8FrYLg=
X-Google-Smtp-Source: ABdhPJwCUv1yaNxmTAbtpPYz6hpIUXSZeL7gMlXzzWvEpgYYZjVvaKyXPVYKufzWFAkvrrfs9Or1XQ==
X-Received: by 2002:a17:907:2165:: with SMTP id rl5mr4077046ejb.98.1623326656755;
        Thu, 10 Jun 2021 05:04:16 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e18sm967193ejh.64.2021.06.10.05.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 05:04:16 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 0/2 v2] net: bridge: vlan tunnel egress path fixes
Date:   Thu, 10 Jun 2021 15:04:09 +0300
Message-Id: <20210610120411.128339-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
These two fixes take care of tunnel_dst problems in the vlan tunnel egress
path. Patch 01 fixes a null ptr deref due to the lockless use of tunnel_dst
pointer without checking it first, and patch 02 fixes a use-after-free
issue due to wrong dst refcounting (dst_clone() -> dst_hold_safe()).

Both fix the same commit and should be queued for stable backports:
Fixes: 11538d039ac6 ("bridge: vlan dst_metadata hooks in ingress and egress paths")

v2: no changes, added stable list to CC

Thanks,
 Nik

Nikolay Aleksandrov (2):
  net: bridge: fix vlan tunnel dst null pointer dereference
  net: bridge: fix vlan tunnel dst refcnt when egressing

 net/bridge/br_private.h     |  4 ++--
 net/bridge/br_vlan_tunnel.c | 38 +++++++++++++++++++++++--------------
 2 files changed, 26 insertions(+), 16 deletions(-)

-- 
2.31.1

