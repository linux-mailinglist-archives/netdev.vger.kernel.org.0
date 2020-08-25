Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DBD251858
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 14:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgHYMNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 08:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729099AbgHYMNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 08:13:35 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BEFC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 05:13:35 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id g6so1156450pjl.0
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 05:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XuxqHGQ3CPqGXcwMhMILx0aNLZlOO1GMGBPgCSiECEs=;
        b=UvTWeaHQtStiN79sTMs+3rHqHro6a6lQnSe+yyenE8NHNypMLfrVuXueaK8/ZzQUh2
         HlFwFzUy62FjtXx+GElRdSX8TyOczMA2wot2ZnkTTR4FUGmJ+YPiUjkScRbqyU/cvIea
         e2pYlJ826Z1DqVJibsm2HxUfF59XrbA7KU/GtWo++p1Iu82vdnJdTM2fNwLVqRdIfz5O
         njhFO0+DOzy0IlUyqJL2xvX+o3TPGeaAisWuFJgJgNh06nOXHnLhRe6a959VVPZi+eoT
         DPJFwjtd5AyuUxjoWXZJLZ0VBtqZJG09AIM2ZPh9DwK3kfnJPDOhxDL4NPT0Ou2nfpuT
         r7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XuxqHGQ3CPqGXcwMhMILx0aNLZlOO1GMGBPgCSiECEs=;
        b=GpgToL/9v+0GYyTfy4Kt4mWpExj1LNzJ42NhvINW9JBf+YCseBCEVIPdCSBm9gtQaj
         yoChqso8lNhbz5WYLflBZs0xuHVg6Cr08Hjeo50He3MogEgEL47XNm6TeSlx8F/8slAY
         fb17vZrhjdhMEltE/HmqvlPJrh3nOo27Rv6o8/1hwws12ZRS+4CJGoy/EHs0CCXHf6tI
         4VKSMPgG+00kuNJfzDcc+ELU4C0rd/WJA/Isl8s8/4RWjqDvxb8YXpV0wkH6l1CZVQ//
         MmZoZqb6IBfLEc1C36CU7Nk3Ugkp/N1LUHEL3HhJyaPsNWDIA3WK7eTPnZ7jCHxRs1kG
         QQVA==
X-Gm-Message-State: AOAM531+xq6+g0/R6Lbr4B/wfLiFKr5aStAXdI1Fs4Q5GluTSqVk9ucq
        PIeacRoMXspi8VlthAPKz12DNOzLy/o4SA==
X-Google-Smtp-Source: ABdhPJzoJlGialpuIMs6wGfzHlOWLfeLjMr+RfJoU9YCBkWmwd+sg+whnf+9fvmz0K58PSmYws/fEA==
X-Received: by 2002:a17:90a:19c8:: with SMTP id 8mr1254401pjj.152.1598357614616;
        Tue, 25 Aug 2020 05:13:34 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id d5sm2700031pjw.18.2020.08.25.05.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 05:13:33 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
Subject: [PATCH net v2 0/3] Avoid premature Rx buffer reuse for XDP_REDIRECT
Date:   Tue, 25 Aug 2020 14:13:20 +0200
Message-Id: <20200825121323.20239-1-bjorn.topel@gmail.com>
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

v1->v2: Removed page count function into get Rx buffer function, and
        changed scope of automatic variable. (Maciej)


Björn Töpel (3):
  i40e: avoid premature Rx buffer reuse
  ixgbe: avoid premature Rx buffer reuse
  ice: avoid premature Rx buffer reuse

 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 24 ++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 27 ++++++++++++-------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24 ++++++++++++-----
 3 files changed, 52 insertions(+), 23 deletions(-)


base-commit: 99408c422d336db32bfab5cbebc10038a70cf7d2
-- 
2.25.1

