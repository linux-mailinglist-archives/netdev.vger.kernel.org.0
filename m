Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8BE2D9AFF
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437983AbgLNP3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731884AbgLNP2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 10:28:55 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF107C0613D3;
        Mon, 14 Dec 2020 07:28:14 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id p21so4983337pjv.0;
        Mon, 14 Dec 2020 07:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JntfCgfYG2ldn/Xx3xyW83K/+qr92LgPi/s946Gzg78=;
        b=gK2kGOlYc1N2gmkqBk1OZG6XQj+oAW13oM2gPC9CirJXABj4LRTniv6V9LoHDUeMgM
         iKTNSmD2RwP0IgTizmtv0sS9aXEUnUapqa56QCKHxvTZNaAX9qn74PwHbGV03ZyTilTi
         GnqYOdXq3CD9n03W1A/edjXWn6/RTVOQCS3iftGzgWVTcjshsetaGXoryOb38+E65Pyj
         wxTIpZKa2OCdmhekBebGkcx2Wq3yUg1xyTPe+dQQfF2XPN74LKA82BilKCVSJ6qPw+m1
         +zMP0HMgqT/vitMmeknrt0D6kwJdTt/Wnr6uLG5Oyf7Yabg9/SxvwK85wyhvQen5qP+r
         pMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JntfCgfYG2ldn/Xx3xyW83K/+qr92LgPi/s946Gzg78=;
        b=NjoZUYTyTT7EX7aMFpJwC5X/pTWeOBMt7JONXndPkGFT/LL8K9opCQVz8Z+Iv1TC0T
         8nz1TlOrEILq3Ea4h1bW+jTHpv3GY37F3ZL6GWBGcxoKLqVqeJ8z3wUlpUgS9tE6RNQi
         fLHIeSBoTevmMPs3NeXc4kCg9OpyL+//BcUyFh4BARF5AZtolVBvQXDW6Lr9jXgbZdfr
         RVonpsVG1Ryn/wHnqZXoAJKFwJv9S5epbU0OSokx+230WsK/ZDcgjYVwOgWgGUA18fIk
         vqD8YkRvh0alYbx1riOn/90t6K9LbeRsQPhRzgPPjo+U1UNkfmTj6m3UaA9pQ0bzymYy
         HVKA==
X-Gm-Message-State: AOAM533ikBFILIv26DR8OSmah1HPsmn6XJAQexEuLQ3WerJ1wxM4ekFr
        1MPXW8EwTd9MxK2PR6YN3Lo=
X-Google-Smtp-Source: ABdhPJwa+tDqbW08yiVxRo57kDGW3jVvAc3hxhABF085PkRZO4ejjO7ontSyJIIcgXe+aJX0+TQAag==
X-Received: by 2002:a17:90b:11d7:: with SMTP id gv23mr25935280pjb.2.1607959694494;
        Mon, 14 Dec 2020 07:28:14 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id 5sm20036027pgm.57.2020.12.14.07.28.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Dec 2020 07:28:13 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>, bpf@vger.kernel.org,
        A.Zema@falconvsystems.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf 0/2] xsk: fix two bugs in the SKB Tx path
Date:   Mon, 14 Dec 2020 16:27:55 +0100
Message-Id: <20201214152757.7632-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set contains two bug fixes to the Tx SKB path. Details can
be found in the individual commit messages. Special thanks to Xuan
Zhuo for spotting both of them.

Thanks: Magnus

Magnus Karlsson (2):
  xsk: fix race in SKB mode transmit with shared cq
  xsk: rollback reservation at NETDEV_TX_BUSY

 include/net/xdp_sock.h      |  4 ----
 include/net/xsk_buff_pool.h |  5 +++++
 net/xdp/xsk.c               | 12 +++++++++---
 net/xdp/xsk_buff_pool.c     |  1 +
 net/xdp/xsk_queue.h         |  5 +++++
 5 files changed, 20 insertions(+), 7 deletions(-)


base-commit: d9838b1d39283c1200c13f9076474c7624b8ec34
--
2.29.0
