Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFA220B069
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgFZL1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbgFZL1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:27:34 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6F3C08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:27:33 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id q19so9955759lji.2
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=pUX3zvaBx27vOVWQV7CmOe6IWAKhMqNw8tlSpjLkTPA=;
        b=cs4nyCicYkhVwuTdA9YLy44vpgHlrXblBadSdvfurWfxmZPM/ls1J57fwwRcWxqYYj
         ERUKu4rCXfN6UYOemp2H1XUZJLKQOaT2hl3aASVngIyq9fBureB2csFcieGcXt5V0N1t
         uTLeOtcpNTsAZhVe94y830wlRy/SDZ6eHMN79slQB6JRwKLcXLMEVMB7o0dLEkaAEdsr
         7ufwK/hdfuzpAyn14wmYIde3cb/ddBgMJpKWg3YpWIDMbkw+bwAT+J9R0gP0Ikuwd7fh
         9ItPqi2y14a6GT/NxxZqsxZxC3bLnIUci4JJMBB8sOpuwm+A8eHfNrj3R/+pPDx455s4
         0Gqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pUX3zvaBx27vOVWQV7CmOe6IWAKhMqNw8tlSpjLkTPA=;
        b=N3KhxsEdSJuCDVS9afzNCZ3PmHGB2l5Ruz/DVoZeYLuYJwyTZwWN9cGKi75/bXbCNR
         cp48iEpRqvalSnNZoeQ3NCRTD9EvhBgbn0455On5r+X7rx13zqTyjIjhu2+k+NmnGC9H
         0GStQ4nyd1jyg2k5MZdv9ScRQ5bNHhU1ziKYwaQe1FkegahAOIlNCCXZXh9yBVf2cUz9
         pQEsICo0aUrGjT/q2eCCbgglUIY1rWoOHD57IzA6N4MCJO3M2xKutdDswx/lU/iIQKrc
         /GJLhV/BYFEYRQcPslMreG7TQ78HbTaDfAUFEFZd98IO5NncqiY0V9ieNRhfyBzqORhm
         I1Dw==
X-Gm-Message-State: AOAM531rxV5OFge0Aq/7EYxtiso/6hO0G/PHJ7P7jDmn+k/hwYhELiEo
        sppvqDO8ecf4Qbu3p+ovhpvUNzatV9qXww==
X-Google-Smtp-Source: ABdhPJwbhoSbJZsfIfvJ61UC7mriVImm9T7DUfDCCWM8W2iO9gVKVhOo0QxpSSDRYV99LfNtyU8DYQ==
X-Received: by 2002:a2e:6f14:: with SMTP id k20mr108145ljc.224.1593170851514;
        Fri, 26 Jun 2020 04:27:31 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id j4sm4476893lfb.94.2020.06.26.04.27.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 04:27:31 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v12 0/3] xen networking: add XDP support to xen-netfront  
Date:   Fri, 26 Jun 2020 14:27:03 +0300
Message-Id: <1593170826-1600-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch adds a new extra type to enable proper synchronization
between an RX request/response pair.
The second patch implements BFP interface for xen-netfront.
The third patch enables extra space for XDP processing.

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

