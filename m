Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79343057DE
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314407AbhAZXHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:07:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390923AbhAZSnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 13:43:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A194222228;
        Tue, 26 Jan 2021 18:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611686544;
        bh=Hv7tsC8dZLw6fnrXrYNWnEN9C0yyCuMi1XBPJXKs7FU=;
        h=From:To:Cc:Subject:Date:From;
        b=u5b0tpyzEUKnTamPV7lwi7RyuVsplCDauqtqiPvT5FNDg0OlYqiuOD8CMWG4yAbkh
         EUu8qzqcvl6ovz5nG5KhCy6rtvEzOwlGzSZcuI3Gho4E+pGQhzwFPRX43wj1C0KaVJ
         bJAd3b1fOVrvvJXj8dfZ1imL2HUGELmbODWmBnEjfJadEvsOYymrCvqCWch+hpGBam
         5+srLJxnpaXCE7cpEMPxNhZVwGGA23Do49PeNlhTnDA3rhGhzY90xnJBrVdezhiA8k
         yQK1IhABimYTtrAde7e33XgAArcVZTVtQUpIA/OQIxSRXqHHgjIhaLWwAGKAVTTWeV
         VpLo80RQWaF7w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, toshiaki.makita1@gmail.com,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com
Subject: [PATCH bpf-next 0/3] veth: add skb bulking allocation for XDP_PASS
Date:   Tue, 26 Jan 2021 19:41:58 +0100
Message-Id: <cover.1611685778.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce bulking skb allocation for XDP_PASS verdict in veth driver.
The proposed approach has been tested in the following scenario:

eth (ixgbe) --> XDP_REDIRECT --> veth0 --> (remote-ns) veth1 --> XDP_PASS

XDP_REDIRECT: xdp_redirect_map bpf sample
XDP_PASS: xdp_rxq_info bpf sample

traffic generator: pkt_gen sending udp traffic on a remote device

bpf-next master: ~3.64Mpps
bpf-next + skb bulking allocation: ~3.75Mpps

Lorenzo Bianconi (3):
  net: veth: introduce bulking for XDP_PASS
  net: xdp: move XDP_BATCH_SIZE in common header
  net: veth: alloc skb in bulk for ndo_xdp_xmit

 drivers/net/veth.c  | 101 ++++++++++++++++++++++++++++++++------------
 include/net/xdp.h   |   2 +
 kernel/bpf/cpumap.c |  13 +++---
 net/core/xdp.c      |  11 +++++
 4 files changed, 92 insertions(+), 35 deletions(-)

-- 
2.29.2

