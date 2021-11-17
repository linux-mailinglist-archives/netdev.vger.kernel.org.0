Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E993454C6B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239607AbhKQRud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:50:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239610AbhKQRua (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 12:50:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 909BC613A1;
        Wed, 17 Nov 2021 17:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637171251;
        bh=XFFMxUrqwRb2v11yxY243XM/pACM4Jk8OYVGG9bIM/0=;
        h=From:To:Cc:Subject:Date:From;
        b=TabQQbZZy7VLUqAkBuYvD1vu3E29JZsRPPjFRnsWtYKJT4h8l5PNMrhEpOCwTKwvY
         1YeITfaH4NPZavxkddGCa9mbs+JB5ueIWIeiVUxSdGVTpwpuNinOK4qZ4EvbX1mNX1
         x+WPXIlGaHKj3+ZaW2gI6kw2qNG/DY/Fyv7gRSV3DXSFqt3Ph4GY0N8RG3gughQl1k
         3Y8agxvjkpbS6t8v4KwVVfQaCgRnVcjdzIfGiIFsc1JSw6c6Skc9sz2M8skKgsq0Yd
         TpC1OQHns++S8CFh3C9nGUfil0OMzZAs7EnJhD3mUfsN3NWNv22SfgaO7LoNPYP6ZR
         YAvD7PNJB4PUQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, eric.dumazet@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 0/2] explicit netdev refs
Date:   Wed, 17 Nov 2021 09:47:21 -0800
Message-Id: <20211117174723.2305681-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot keeps accumulating netdev ref leak errors. These are notoriously
hard to debug. We can't do much about all the old code at this point,
this set tries to provide an API for the new code to use.

It basically adds a explicitly reference counted pointer (there's probably
a better name for this). It's a structure which wraps the netdev pointer
and helps us doing sanity checking.

There isn't much that's netdev-specific here, but we probably still want
to keep our own wrappers even if the main struct gets generalized, so
that we can keep the helpers typed.

Sending as an RFC because vlan refcounting has a bug which needs to be
fixed first [1]. Explicit refs catch it and spew warnings appropriately.

[1] https://lore.kernel.org/all/87k0h9bb9x.fsf@nvidia.com/

Jakub Kicinski (2):
  net: add netdev_refs debug
  vlan: use new netdev_refs infra

 MAINTAINERS                                  |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c |   3 +-
 include/linux/if_vlan.h                      |  11 +-
 include/linux/netdev_refs.h                  | 104 +++++++++++++++++++
 lib/Kconfig.debug                            |   7 ++
 net/8021q/vlan.c                             |  13 +--
 net/8021q/vlan_core.c                        |   4 +-
 net/8021q/vlan_dev.c                         |  63 +++++------
 net/8021q/vlan_gvrp.c                        |   5 +-
 net/8021q/vlan_mvrp.c                        |   5 +-
 net/8021q/vlan_netlink.c                     |   4 +-
 net/8021q/vlanproc.c                         |   6 +-
 net/core/dev.c                               |   8 ++
 13 files changed, 186 insertions(+), 48 deletions(-)
 create mode 100644 include/linux/netdev_refs.h

-- 
2.31.1

