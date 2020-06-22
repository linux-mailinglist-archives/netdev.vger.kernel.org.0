Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5FA203331
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgFVJVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgFVJVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:21:35 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DE3C061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:21:34 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id i3so18463695ljg.3
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=R9FLDfsyypApvleCpjp113KOQ+iZgPcYjwUlmrkJIMM=;
        b=ziifFybMVKl4ymdH0KTFoYqBWUVvKAjL2fNW8QyllqPIhQOOuadKDQoLlw6OzGfsjx
         MRRmpKNCdGIAxU8UZJ2FLtHuHu2w3SNVqaSGDQhEl5G4Z64+UK7FzxshK8dBLIu9SY4M
         pkJjJ7xyYlUo6XX1L75FhEkb+3GyyPlMYO/J9r0lkddwhRw27nGd9ce9u0go9sfdsq94
         6J8u6cdBA/YLiVEbsSzWbxULJFWSpPxS/BVvhHNYAyiRGckIt/2Xz2uumx6NXfS/hoZV
         2nd+7y4pTc0XQ9HqI20SxMWxvKxNnNedi9fGalfNatwfHTaMG7dDjwVm7/L/lloF+mTs
         fPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=R9FLDfsyypApvleCpjp113KOQ+iZgPcYjwUlmrkJIMM=;
        b=UDe/9cy2frAC6PnKhacCkCz08Gx6wgGZ89viNRrBw3S0TWcLM28zlOCcNOb6GC7QD0
         BB4ln9EWZIQTaKofFDZnJ6frtqjo/gAgpo+AC5e4+hF2FnDlzG2NYBm8q7xUslcQXDcS
         r0AGZ8ytpZisAtx2Lj0XXJS8cu1QBiVC5wOLxcoYD1fkAGPJ3IEcErKIPYYbfwC4uMnr
         z5QA2SKZAPnp46SBMbZmVnGQ2OmkNowkV0UnAYrQ3bwnN4PaY0J8IHYimND+jdNJ8G5t
         uZVYpf55ktKvg0RlRjkan+uJWh6NuRUlO0sYUak9K9GtZJBlpcrCwPc56IFzZENaYT6G
         MDfA==
X-Gm-Message-State: AOAM531J4weYso8xXrDlRkBmzzwzvgfHq+IdkFOKoUplH2msjOa1lOoO
        LoHhNtld/ILqANkwFKU25jWUNotL6UwuCQ==
X-Google-Smtp-Source: ABdhPJz4PTpfzEdxbi+bc06khRqr+P5gjJQxl/bW4aNu383doZ+WYSaQeDQOFSnp984moSyrz6EX4A==
X-Received: by 2002:a2e:581a:: with SMTP id m26mr8223979ljb.0.1592817693160;
        Mon, 22 Jun 2020 02:21:33 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id w17sm3048028ljj.108.2020.06.22.02.21.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jun 2020 02:21:32 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v10 0/3] xen networking: add XDP support to xen-netfront
Date:   Mon, 22 Jun 2020 12:21:09 +0300
Message-Id: <1592817672-2053-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch adds a new extra type to enable proper synchronization
between an RX request/response pair.
The second patch implements BFP interface for xen-netfront.
The third patch enables extra space for XDP processing.

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
 drivers/net/xen-netback/xenbus.c    |  32 ++++
 drivers/net/xen-netfront.c          | 332 ++++++++++++++++++++++++++++++++++--
 include/xen/interface/io/netif.h    |  18 +-
 8 files changed, 399 insertions(+), 12 deletions(-)

-- 
1.8.3.1

