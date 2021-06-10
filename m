Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2253A2993
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 12:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhFJKrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 06:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhFJKrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 06:47:43 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B131C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 03:45:47 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id he7so23968465ejc.13
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 03:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bwD7tLjIytzsF2Noid/CFwwwO+Xsa64mcNBZBhtUbeE=;
        b=f6CFykudWQOYyA9KqsAlp9KI46ZYLC6Te9Lw8jeyUv2CGnWxNth+pu/KdJPKoSaPRA
         nU+Sq8Sx8yAobNjY5IfBFG2SUU7jkZv54h495lhbPIKLI2tRwLNMmmcyRPJ/25r+yiy0
         KVsHgKrQ7Y/+GngOh0zc9CeGW89PQ0CemtWZRHsIYAjblQUUCkKvOsOUtMBwtP6CxWEY
         gM84BsOouAVSW1UsM9yen6iIdktkfTGyUkBKxSDxHSsqmxCrnrBqVKZl4XJKFkOmOMWr
         t4eGr2rnbjWUHc4dxznWvLvX79w2ql4W+tBNm0GOVxexxrdipxsU7CXrzrgJ1FNS5p0Z
         4Xuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bwD7tLjIytzsF2Noid/CFwwwO+Xsa64mcNBZBhtUbeE=;
        b=G3zYVCttUQmaR09+OGQsvAsttas7HqD8HnjzR/PClZypc/bM3ytOHPZ5YenKZApeSz
         NkrpLX5c3RY5vJLA6ZL8NQvZsY6xDJ2cwN+w6XV38qLmIikMRBH/XWjvF5wdnSxPCIjD
         370Pc5MNzWFr8zco1OTlYVekzWjGx/fba2VA1aSjW6pdmrnvpaiS5SavJpC+NeHYV0/g
         49VICuxqQPDktXRRL1XA8EVXo0IpIQQ6wCcEhCz8GHCEL48queaokkLyandbxaxK8LAx
         WJ4dPD70kjXHNRjXTFUaPgXrMSyX3NvTR83CBYeLSlWQBePC+ukO7hDtIC67g4iXOVAo
         pEbg==
X-Gm-Message-State: AOAM5330iOTmbDyyrzeRBwFJ0Ihy12751SaNH9m91mRTwJkDD5WR4OR1
        vvzE8ep4UlGit7nrDKOUeKSLux1K+zWbJ1wsaJE=
X-Google-Smtp-Source: ABdhPJwd2vywjLqUORTSRomxouvP1kM/orHcJXtkR3DS9pPFXeu7RBhwRxD3TElw6ccJIRP8NiIuTw==
X-Received: by 2002:a17:906:d1d2:: with SMTP id bs18mr3971919ejb.56.1623321945610;
        Thu, 10 Jun 2021 03:45:45 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id y1sm866526ejl.7.2021.06.10.03.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 03:45:45 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 0/2] net: bridge: vlan tunnel egress path fixes
Date:   Thu, 10 Jun 2021 13:45:35 +0300
Message-Id: <20210610104537.119538-1-razor@blackwall.org>
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
11538d039ac6 ("bridge: vlan dst_metadata hooks in ingress and egress paths")

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

