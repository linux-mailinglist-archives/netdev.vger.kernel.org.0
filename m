Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9FA20B0B7
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgFZLlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgFZLlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:41:24 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49161C08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:41:24 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id c11so4976587lfh.8
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=GlnsjuDVkSrOs3yKRu049A/EIb4ZUf1nGPv/1TwOotg=;
        b=03tA0d1L13Q2e0HYloOeE/N8x1L7D+7kIYqE+a9HALw8Q7kLidMtDaHxjbi3SzsMur
         1OdRqFsJictn9Wy83NbZOTS4W3oFYHnTV50pnYJXA73erEE+ayQLSJ6JKs0LI3xbV7JL
         VEfw0Gxlf/bm4eFe8DM56CXLSc0Z4mj5dJ7EYHWvX1qi2dS04ElLjpI6S/zASU4oi7Lr
         sllPqOwPOrscZNNeWZx6QsN98MaLFDrrM+vJXohpCf8Lf6V67WFLfpJpko73X1mK4lly
         edVs3xp5Ebxph9cm1AVEAe0Z+zmwDYkur5ky8Q85jaPoYoE0u67Ji3ehc7/pAXQJeumM
         j5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GlnsjuDVkSrOs3yKRu049A/EIb4ZUf1nGPv/1TwOotg=;
        b=okkGsics5XsTTQSqeR2c2PV1HJilH5fNfBlrFOGyQsnikfkD+/o+H5x4Rd7TAqkUH/
         64u5l58YXx6kHGv5PCIftBSQwiBACitqu653zZQwFHOdYC4FSyuueVLQ3asYiYc8Uyy/
         0rLaVV4cX9pl2XGMiCqXfoDGWHIw4wKVRWiV9vJ3pWqmJ4H3zn0gOB7skg50h+7FzO69
         a0ACQhp6i5a3aIvIeY9XJ1javIcpa3+Kpl2xz9TSOX9KvbZyf+RaL4E2h8wedc83xIqr
         F6EOGDpY42ZL3QunGITsHDTzZfwFonBngaM08a169JL0nJF/KwBSl1CKPO3G2URqj5Pq
         53Vg==
X-Gm-Message-State: AOAM530w6dHBapzNWHYhIAxUzA5cJ+ONcdeiFLdXxob3KJjRVdvNmHa0
        ljyFY9kqcDUHyQy3IB6SuJtocxqVov9TqA==
X-Google-Smtp-Source: ABdhPJz6yo/LLvMsm9HnDZeZiYm7z1436wE5otUQYda+X6G5KxEzipSWviPdK09DBVhvmKaUDalv0g==
X-Received: by 2002:a05:6512:110e:: with SMTP id l14mr1522506lfg.25.1593171682667;
        Fri, 26 Jun 2020 04:41:22 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id v22sm5464237ljg.12.2020.06.26.04.41.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 04:41:22 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v13 0/3] xen networking: add XDP support to xen-netfront
Date:   Fri, 26 Jun 2020 14:40:36 +0300
Message-Id: <1593171639-8136-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch adds a new extra type to enable proper synchronization
between an RX request/response pair.
The second patch implements BFP interface for xen-netfront.
The third patch enables extra space for XDP processing.

v13:
- fixed compilation due to previous rename

v12:
- xen-netback: rename netfront_xdp_headroom to xdp_headroom

v11:
- add the new headroom constant to netif.h
- xenbus_scanf check
- lock a bulk of puckets in xennet_xdp_xmit()

v10:
- add a new xen_netif_extra_info type to enable proper synchronization
 between an RX request/response pair.
- order local variable declarations

v9:
- assign an xdp program before switching to Reconfiguring
- minor cleanups
- address checkpatch issues

v8:
- add PAGE_POOL config dependency
- keep the state of XDP processing in netfront_xdp_enabled
- fixed allocator type in xdp_rxq_info_reg_mem_model()
- minor cleanups in xen-netback

v7:
- use page_pool_dev_alloc_pages() on page allocation
- remove the leftover break statement from netback_changed

v6:
- added the missing SOB line
- fixed subject

v5:
- split netfront/netback changes
- added a sync point between backend/frontend on switching to XDP
- added pagepool API

v4:
- added verbose patch descriprion
- don't expose the XDP headroom offset to the domU guest
- add a modparam to netback to toggle XDP offset
- don't process jumbo frames for now

v3:
- added XDP_TX support (tested with xdping echoserver)
- added XDP_REDIRECT support (tested with modified xdp_redirect_kern)
- moved xdp negotiation to xen-netback

v2:
- avoid data copying while passing to XDP
- tell xen-netback that we need the headroom space

Denis Kirjanov (3):
  xen: netif.h: add a new extra type for XDP
  xen networking: add basic XDP support for xen-netfront
  xen networking: add XDP offset adjustment to xen-netback

 drivers/net/Kconfig                 |   1 +
 drivers/net/xen-netback/common.h    |   4 +
 drivers/net/xen-netback/interface.c |   2 +
 drivers/net/xen-netback/netback.c   |   7 +
 drivers/net/xen-netback/rx.c        |  15 +-
 drivers/net/xen-netback/xenbus.c    |  34 ++++
 drivers/net/xen-netfront.c          | 337 ++++++++++++++++++++++++++++++++++--
 include/xen/interface/io/netif.h    |  20 ++-
 8 files changed, 408 insertions(+), 12 deletions(-)

-- 
1.8.3.1

