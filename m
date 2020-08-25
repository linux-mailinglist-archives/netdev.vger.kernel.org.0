Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F9E251520
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgHYJQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbgHYJQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:16:48 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7171DC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 02:16:47 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y206so6822902pfb.10
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 02:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sTy5ZLdsTNmabWU2DWRr860vlaqppGQ9l3PUT3pKZKg=;
        b=KWGP12qr/5CWzdzEVxVy3mStxfchbvmRqdHhp35wzrencHPvPVx415IgC0Zb1CgX9U
         gmDC/XYid3kywQMqJv8Rj9Iwn2akiYZmmgUouDL3veDgQVQM8Rxwjv6sEzAwUt4kxUVg
         tjCqnY++qQBwWT8jA0lz0+/oJcqrrd+Qw8QcBFdqlAqes2I0/HkRMt3ZARzVYXIg6yv/
         iuHAZ8HRdYa4A5PUKuwxeUfGiOICHTBaqm7uLkdYYS0Dvp0gSdGU2gB5RUOIFarW6//Y
         l5lRTwcJoXpiOQHHVd/VpKAo2bLllQES7yBxOgdr/wHzgD+aXXbkTIC2SAnz8Au6+2BB
         ujAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sTy5ZLdsTNmabWU2DWRr860vlaqppGQ9l3PUT3pKZKg=;
        b=ICX7ggQ3HSQefVh+g2U8XFXasozttkn3hV261YoQtmJ0yqlcv6ryI4U4OXdyabABXA
         5D9PmCrTKCyaFuBmnPjs9tRDx3XMPPZj76FKNVkhqCZnxo4uEqITK2+nF3OWOdiM0Rmc
         lFHiO254H+r6+j7moV4qINOzy+cR5N2Zs1m+6Ax5QC+YETQq8aBKgO0tsq2l14GiCCD6
         eC7Ujd4oDkc1YHJpS5dbdb3c8j44/KzVZz0U/sm9Q0TWH9RkiTIR5idPfMJtJPh18mDR
         ScEfaNPtrVMBN2F+BgaEsZuZYGteK+SSXY72uefSjl0gZAgde5cHKJdCudQIqM8Tx6nS
         NBSA==
X-Gm-Message-State: AOAM5339htfWHjnHm4BShWXA6spn/q2yVrHpZGC8FlfZNEU78mBXXa/8
        dBvN9Dn0OfzR+TrZPSP8EBg=
X-Google-Smtp-Source: ABdhPJwSi+EnfmwXMOGq6kOtMIcMso1m5VQPIMrQfrb5c9rSI5wqTO26owbfeoIUi7fgHgZxycf8xw==
X-Received: by 2002:aa7:925a:: with SMTP id 26mr3591281pfp.6.1598347006883;
        Tue, 25 Aug 2020 02:16:46 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id 2sm2121857pjg.32.2020.08.25.02.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 02:16:46 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
Subject: [PATCH net 0/3] Avoid premature Rx buffer reuse for XDP_REDIRECT
Date:   Tue, 25 Aug 2020 11:16:26 +0200
Message-Id: <20200825091629.12949-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intel NICs have a recycle mechanism. The main idea is that a page is
split into two parts. One part is owned by the driver, one part might
be owned by someone else, such as the stack.

The page recycle code, incorrectly, relied on that a page fragment
could not be freed inside xdp_do_redirect(), e.g. a redirect to a
devmap where the ndo_xdp_xmit() implementation would transmit and free
the frame, or xskmap where the frame would be copied to userspace and
freed.

This assumption leads to that page fragments that are used by the
stack/XDP redirect can be reused and overwritten.

To avoid this, store the page count prior invoking
xdp_do_redirect(). The affected drivers are ixgbe, ice, and i40e.

An example how things might go wrong:

t0: Page is allocated, and put on the Rx ring
              +---------------
used by NIC ->| upper buffer
(rx_buffer)   +---------------
              | lower buffer
              +---------------
  page count  == USHRT_MAX
  rx_buffer->pagecnt_bias == USHRT_MAX

t1: Buffer is received, and passed to the stack (e.g.)
              +---------------
              | upper buff (skb)
              +---------------
used by NIC ->| lower buffer
(rx_buffer)   +---------------
  page count  == USHRT_MAX
  rx_buffer->pagecnt_bias == USHRT_MAX - 1

t2: Buffer is received, and redirected
              +---------------
              | upper buff (skb)
              +---------------
used by NIC ->| lower buffer
(rx_buffer)   +---------------

Now, prior calling xdp_do_redirect():
  page count  == USHRT_MAX
  rx_buffer->pagecnt_bias == USHRT_MAX - 2

This means that buffer *cannot* be flipped/reused, because the skb is
still using it.

The problem arises when xdp_do_redirect() actually frees the
segment. Then we get:
  page count  == USHRT_MAX - 1
  rx_buffer->pagecnt_bias == USHRT_MAX - 2

From a recycle perspective, the buffer can be flipped and reused,
which means that the skb data area is passed to the Rx HW ring!

To work around this, the page count is stored prior calling
xdp_do_redirect().

Note that this is not optimal, since the NIC could actually reuse the
"lower buffer" again. However, then we need to track whether
XDP_REDIRECT consumed the buffer or not. This scenario is very rare,
and tracking consumtion status would introduce more complexity.

A big thanks to Li RongQing from Baidu for having patience with me
understanding that there was a bug. I would have given up much
earlier! :-)


Cheers,
Björn

Björn Töpel (3):
  i40e: avoid premature Rx buffer reuse
  ixgbe: avoid premature Rx buffer reuse
  ice: avoid premature Rx buffer reuse

 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 28 ++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 31 +++++++++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 28 ++++++++++++-----
 3 files changed, 64 insertions(+), 23 deletions(-)


base-commit: 99408c422d336db32bfab5cbebc10038a70cf7d2
-- 
2.25.1

