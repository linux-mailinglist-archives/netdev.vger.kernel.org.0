Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A5C251E3C
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgHYR1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgHYR1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:27:51 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F59C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:27:51 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q93so1140373pjq.0
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R96er/PUVvfadsqAyZv+jNgEaJpcty4Nzo7grHpCEwo=;
        b=apeSbu/SUCX4n2tlsVngUvy9gGtEQOK9BDjzH4FDbB2y1L2RKRDtTeXhbaFatRa4lk
         k0zgA3E75zj1asMXPBXfD34AMSrQTUqEm+eipH/W/zscyEfppmLasI2KnQh9TlvKisGm
         e5a96y6rtGooDV1nW2wgVx5wJ5mwkQNvz7nkTQeD6k1ZMcAKiADm10/Goqn5sUmNNKQE
         n1bby2NcH/HUOQnnz4gOjtounHXOTQs2K5C9z+QryO/HaLjhDv9GLL0us6ztfWbfFKtm
         RIm1NQ6iIplIIIo31Ikjs+vUh4gme6BvffX1zhXifU+Xzc0/cIeVN9GI1T06VxK0Lke3
         Evpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R96er/PUVvfadsqAyZv+jNgEaJpcty4Nzo7grHpCEwo=;
        b=TNJ1hW3y6jixq9MWyvwSt8lA0fmlbFHGbD/uqQII95FqwJ+La+8crJS8rV0r0o0JSZ
         pgqosbaUdqf8BTWRXZHeM7K+4wr2MqwOOGMtkfDSodpQl38/WVNgRPLW6Bkg/6F8k0x8
         sPaTKyjwlLWv3rnIs6xetA3ZXdirkeM+lq0J7R41RsvHzYVXjQKjdMPX6LJxkRze1zOS
         BrxbU+mVUzIPvnRPvwQJG56bcJtFlj0exHbrVRdN7hTPuZDv5qXriDTkHsREbe2zerck
         0BSqJvGNiMr7Ao7wEAKyw1UntbizpANz7Bm4qxhFNxHXQ/OHWxw4RL/UkRhOgtsCTZPD
         pASA==
X-Gm-Message-State: AOAM53292c5iztJ6mIiEqEME2aGsjzTYBE6Rq3jMRyV4Mur1c+Y9Kp1L
        kBMP6lWaD+o1LAixLL4Xmp8=
X-Google-Smtp-Source: ABdhPJxQtVm46T/KQ/dnkbqg0kkC84ILQee1EL+5QmQ6iMdHInpMtTQZ2saxctC7G0GXeiNNNYlVlQ==
X-Received: by 2002:a17:90b:c97:: with SMTP id o23mr2514529pjz.216.1598376470570;
        Tue, 25 Aug 2020 10:27:50 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([134.134.137.77])
        by smtp.gmail.com with ESMTPSA id n72sm11685763pfd.93.2020.08.25.10.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 10:27:49 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
Subject: [PATCH net v3 0/3] Avoid premature Rx buffer reuse for XDP_REDIRECT
Date:   Tue, 25 Aug 2020 19:27:33 +0200
Message-Id: <20200825172736.27318-1-bjorn.topel@gmail.com>
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

v2->v3: Fixed kdoc for i40e/ice. (Jakub)
v1->v2: Removed page count function into get Rx buffer function, and
        changed scope of automatic variable. (Maciej)


Björn Töpel (3):
  i40e: avoid premature Rx buffer reuse
  ixgbe: avoid premature Rx buffer reuse
  ice: avoid premature Rx buffer reuse

 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 27 ++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 30 +++++++++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24 ++++++++++-----
 3 files changed, 58 insertions(+), 23 deletions(-)


base-commit: 99408c422d336db32bfab5cbebc10038a70cf7d2
-- 
2.25.1

