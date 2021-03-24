Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FEC347B07
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbhCXOpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:45:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:2051 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236115AbhCXOoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 10:44:54 -0400
IronPort-SDR: 4aTwv4cOjWo/gWVVwjT3GY0JA2Jdbr4MNjnmZ3/MhJChFsm0ruuQipd3qFvvK0E87cwcWxb/0k
 FpSpQNmNqQtg==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="177834544"
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="177834544"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 07:44:53 -0700
IronPort-SDR: VqEXriFJELnQHGfVhrVX6LmbZ772bw+318tdkoElJrkNyul8GHHSkx9AY4IWIEU2+XUzgmWTec
 bLOSJvKLuTCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="608127963"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2021 07:44:52 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf 0/3] AF_XDP Socket Creation Fixes
Date:   Wed, 24 Mar 2021 14:13:34 +0000
Message-Id: <20210324141337.29269-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some issues around socket creation for AF_XDP.

Patch 1 fixes a potential NULL pointer dereference in
xsk_socket__create_shared.

Patch 2 ensures that the umem passed to xsk_socket__create(_shared)
remains unchanged in event of failure.

Patch 3 makes it possible for xsk_socket__create(_shared) to
succeed even if the rx and tx XDP rings have already been set up, by
ignoring the return value of the XDP_RX_RING/XDP_TX_RING setsockopt.
This removes a limitation which existed whereby a user could not retry
socket creation after a previous failed attempt.

It was chosen to solve the problem by ignoring the return values in
libbpf instead of modifying the setsockopt handling code in the kernel
in order to make it possible for the solution to be available across
all kernels, provided a new enough libbpf is available.

This series applies on commit 87d77e59d1ebc31850697341ab15ca013004b81b

Ciara Loftus (3):
  libbpf: ensure umem pointer is non-NULL before dereferencing
  libbpf: restore umem state after socket create failure
  libbpf: ignore return values of setsockopt for XDP rings.

 tools/lib/bpf/xsk.c | 66 +++++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 29 deletions(-)

-- 
2.17.1

