Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891D42DE368
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 14:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgLRNqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 08:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgLRNqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 08:46:24 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD79C0617A7;
        Fri, 18 Dec 2020 05:45:44 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id c12so1555681pfo.10;
        Fri, 18 Dec 2020 05:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tfEG5+93hdirKem4pujisx1ka8zWI8Yjrbd+CvFVRyc=;
        b=GKgBRDnqMb23hOq8VGHpSLoqvGzWTJx6qRYL/RzEKEax+j/6lx1plZS20MNfXRuBOd
         oY8H4m3/iM8o5JpSF2j+u/isrWe0BBAcpqwGOXq8IndwMkkVSOwPAWTC2BhB7qXVUDnZ
         w31qhCr2c9/MKu9YkeRDvrlR4vruYQCR07UMvlfkNsODyBKELyoDa/f5AGMyzHzErcJn
         sowMF6kzLN1tdHHCmm012ufVzcRv2U86m45gWN74x5UblJqKjU44rrtzGNPNRcPFC9y4
         NoMkznVUnlrddnU4FEbfc8qk3ybsGDI8fc9PHgYrDpIp3n8c+DYGkIuiRMEWBg7u9ZbN
         mMmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tfEG5+93hdirKem4pujisx1ka8zWI8Yjrbd+CvFVRyc=;
        b=ft6HBJf0yCvTj0hPb1cBIWyEJKr5tfBg4xjaKJt4It/Tl5G6eE2S0lJzJt0+45gB2F
         YjF4d346BjA85HWjF/2a4y2Gb2ihujxClZXjddhQMXB/mtNkSaz1BX4mJs1DJViZ4tW1
         fHT0dxc9kmWUUfEAu+rTrAlxGd8EPaoxsWASXL6Wdgllfqz9FuicQ0agBabvWAa9uR2M
         kqthnO/93PBxzqr8cbGNTEVg3+Xq8xQmYDdqlC558GHxyuhTsvbT8lOdLoVTIXZqdsDW
         EbcXEbxnD3IsDnxgMGyCWVFSjMyzQiYwkLdcG9ownaia/z7sqrh0ZDm2aF/eaqkjYbZM
         w+nw==
X-Gm-Message-State: AOAM5311p5sBVgFhAgCOzG8sCoQ3z40BHR3s+Xj5TLk0sRzmTVAEcM+u
        yuQ0dxq/CKN+bcVyQoAWUQk=
X-Google-Smtp-Source: ABdhPJxLK+CNLybCetelhwAtztMSyHlBtifNPqn8L/0NfGMxssMZEGsra7ePaBWkGKdKEbjE6WrR4A==
X-Received: by 2002:a63:f84d:: with SMTP id v13mr4158059pgj.234.1608299144177;
        Fri, 18 Dec 2020 05:45:44 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id r185sm9075906pfc.53.2020.12.18.05.45.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Dec 2020 05:45:43 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>, bpf@vger.kernel.org,
        A.Zema@falconvsystems.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf v2 0/2] xsk: fix two bugs in the SKB Tx path
Date:   Fri, 18 Dec 2020 14:45:23 +0100
Message-Id: <20201218134525.13119-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set contains two bug fixes to the Tx SKB path. Details can
be found in the individual commit messages. Special thanks to Xuan
Zhuo for spotting both of them.

v1 -> v2:
* Rebase

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


base-commit: 8bee683384087a6275c9183a483435225f7bb209
--
2.29.0
