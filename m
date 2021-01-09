Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E322EFD31
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 03:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbhAICvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 21:51:04 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:37279 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbhAICvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 21:51:04 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id BF5EC1802;
        Fri,  8 Jan 2021 21:50:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 08 Jan 2021 21:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mYovwe9oInWI5Fw2i
        cHkOgVtg7KrK8HUXyZ0QtWyLmg=; b=M93hzpellZeiGh5oLdGQszd332c6S/cBU
        4KozUjTBIFh7nrbtDDVX2pstjzXZGPereg4NbRMXOZSYpph/LHlcPNqZ6sNHVJuH
        eFBaQKmulGHa2PacANjKp9cx2+DSOS8wOxfzKo+rXMRJSG+agK55nbqJge8s0JJs
        cMFnE6+PYQDokvR7Na82zbjfyQsz/TkDwZXgLxpFpNTfaDYhQm4ma6m7WOepX6VU
        kBa2B6uWLv9YzaW+HLDZK0f7FiS2JiIpHbse58FTeZGoUTMdQgULcShpGIUzRdKQ
        WglxicgfIibtmY95kkw5d1hpYKZvor01hftoKmBjyJQF7JmGpokGw==
X-ME-Sender: <xms:6Bn5XxjlWeCXpkDgs__gHYt1xkR9-1Oy8xlk_e6wJvOvoQ48A6e-ng>
    <xme:6Bn5X2A3MJSCZw3OiKwMs6A60va0-V5zJwJSSIYxNk-qCe5mUzhWOdh8SWCE43y1v
    RQp-ReKkL2OgaCNog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeghedgudegjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeevhhgrrhhlihgvucfuohhmvghrvhhilhhlvgcuoegthhgrrhhl
    ihgvsegthhgrrhhlihgvrdgsiieqnecuggftrfgrthhtvghrnhepleefffegveefffduke
    dvgffgteevkefftedutedvhfelieehieefheefffetkedunecukfhppedvtddvrdduheef
    rddvvddtrdejudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegthhgrrhhlihgvsegthhgrrhhlihgvrdgsii
X-ME-Proxy: <xmx:6Bn5XxEsKK6fYACQrRfYalMWVrTAu05px7WLUezRVKAVgCAJE9XDrA>
    <xmx:6Bn5X2R1QeF5ARuTkCC9yJRSn35Sg16fEgm6P9Wxwmn330r8oySGUA>
    <xmx:6Bn5X-yXyuQRwkBbX_K439KOSpbDP6C83gpuFO7O7YQ1Jh5dOR0tnw>
    <xmx:6Rn5Xy8lnZ3_dPnWo1NnAUvthJC4a13kZEujALG6fsBvsuSOm-xvdw>
Received: from charlie-arch.home.charlie.bz (202-153-220-71.ca99dc.mel.static.aussiebb.net [202.153.220.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6F9AC24005B;
        Fri,  8 Jan 2021 21:50:14 -0500 (EST)
From:   Charlie Somerville <charlie@charlie.bz>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com
Cc:     netdev@vger.kernel.org, Charlie Somerville <charlie@charlie.bz>
Subject: [PATCH net-next 0/2] Introduce XDP_FLAGS_NO_TX flag
Date:   Sat,  9 Jan 2021 13:49:48 +1100
Message-Id: <20210109024950.4043819-1-charlie@charlie.bz>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces a new flag XDP_FLAGS_NO_TX which prevents
the allocation of additional send queues for XDP programs.

Included in this patch series is an implementation of XDP_FLAGS_NO_TX
for the virtio_net driver. This flag is intended to be advisory - not
all drivers must implement support for it.

Many virtualised environments only provide enough virtio_net send queues
for the number of processors allocated to the VM:

# nproc
8
# ethtool --show-channels ens3
Channel parameters for ens3:
Pre-set maximums:
RX:     0
TX:     0
Other:      0
Combined:   8

In this configuration XDP is unusable because the virtio_net driver
always tries to allocate an extra send queue for each processor - even
if the XDP the program never uses the XDP_TX functionality.

While XDP_TX is still unavailable in these environments, this new flag
expands the set of XDP programs that can be used.

This is my first contribution to the kernel, so apologies if I've sent
this to the wrong list. I have tried to cc relevant maintainers but
it's possible I may have missed some people. I'm looking forward to
receiving feedback on this change.

Charlie Somerville (2):
  xdp: Add XDP_FLAGS_NO_TX flag
  virtio_net: Implement XDP_FLAGS_NO_TX support

 drivers/net/virtio_net.c     | 17 +++++++++++++----
 include/uapi/linux/if_link.h |  5 ++++-
 2 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.30.0

