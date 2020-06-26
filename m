Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B897020AFD2
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 12:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgFZKez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 06:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgFZKez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 06:34:55 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAE2C08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 03:34:54 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id t25so5218868lji.12
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 03:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=9XVEvWCqFVl7kL5TXtoYr/HOMQyU/Q7VZb7NMoqdRW8=;
        b=0mGF7m6E1dXJwkfGgts0wptnTShihIo3BUByaZYqBpL4T/wpBCHNe85z8Vi2aJPHUV
         986BpB/zMRAv+ojYiPoBk6pnpvePCyJSV0Rwq3iLr9/dm9+opMCWX8smYJhA59M8qPk4
         6fmqtzJIObXdsIgWG0AlhdhfvQyIvzuF+eHVHtV0L4PA20l3thKW7Tb0vXerUUjFZH/A
         Ram4hCsyJNZT/FjwNvT1ZjT6Lkd85dXI5RJp3FO2tpPl+wo9wwUz1WslgcnfLJJcPOTK
         tV6ci9BUTI2kEAgSdiQjTRd3cCAu4x8EfKcDB8bN099peKixJSkGgHFKXA2/wRjYaCZK
         lCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9XVEvWCqFVl7kL5TXtoYr/HOMQyU/Q7VZb7NMoqdRW8=;
        b=iJHfMHtOAVFUaz24buwP/mY91xz8NGG6eU/Ayo5ST82cG7+wmpUuLpnClzWew9ldYt
         xO10V5mIK/+JhpkaV+L0wpkscXbdUhfJIBoydmVS4Dl/5I3nARt6Daspz+bsbqngyr/m
         WwC+bruoGkjz83rx09lGdLzXJY7cbUxfSvROqEfTtoBdb3VKNJ5KAEDLfWoiTXAQFiVg
         aReoWj+ODyGrhJXowEaYvs9o2yYVWcMUBPKqFsCWNy6KwJ4Hwg26hVrp83S1bDtbS4Ya
         cFT9PFLWsnaL5EXqjGC2rPlhPff/rcltpkr3QwNpSOeSqemsDv+nWAg8C3ebMeVuk3Ot
         UbTw==
X-Gm-Message-State: AOAM533zbnxokD1FiyoINLJ1ltxMepS6ymEY8+8ozSAWXzNcguRWODiz
        byBlZ/e0SEc3t27iewAPzUhNzD/nGcfYZw==
X-Google-Smtp-Source: ABdhPJx7ciapwYhNMY1M5OPk5Tg8A057TAF/Og33Vg+cPkdpaNsqeCucQlx+j53lrHJlY7n9G88f/A==
X-Received: by 2002:a2e:7611:: with SMTP id r17mr1153995ljc.233.1593167692560;
        Fri, 26 Jun 2020 03:34:52 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id l1sm166124ljc.65.2020.06.26.03.34.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 03:34:52 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v11 0/3] xen networking: add XDP support to xen-netfront
Date:   Fri, 26 Jun 2020 13:34:31 +0300
Message-Id: <1593167674-1065-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch adds a new extra type to enable proper synchronization
between an RX request/response pair.
The second patch implements BFP interface for xen-netfront.
The third patch enables extra space for XDP processing.

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

