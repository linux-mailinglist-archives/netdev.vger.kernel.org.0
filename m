Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAFA21B6BA
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGJNmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:42:19 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54729 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726896AbgGJNmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:42:18 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 690615C00E4;
        Fri, 10 Jul 2020 09:42:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:42:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=NZVc2jYrpO+Z6+o5i
        BrmG1cdb/LQ+8fCCNj7gY7MCqA=; b=ivrC0mXdmi/NOD1VI3YjS3Q4aMug3tYad
        1gPtOZStYxYCGUgtI3SjYT4OEZnEhHKHaGdIfZfFPdCXPbPipKkUJVnCeDx9WB3G
        BAliMLwVQmx455y2mnLWqiloc5QiwX7rjWlyVM3jd3cWuY1Qw9ydmyxKyUHLN++2
        ZGM71qDYD5FnmqjkEzEZ5LYtsNkEHr250ZaoPEI36CpfqzFWrOKQ9IpTq0cRAiV0
        cdTqwBlfnGHCwbwihvy/V78jKIJOOyalnnMuxbt9frcavcxgv/5HIDpAtMIxJOIl
        GC8IIcxN3A5du6y1eSm7Ox+QrKxxBTZcNFQi6wKUENeel2IVBGCXg==
X-ME-Sender: <xms:OHAIX4JzhU5hRLwV4xHKcNaz2YxPSi3sArd9nrs_NWsNFhnQYnRVbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepuddtledrieeirdduledrudeffeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:OHAIX4IWZ9QO49QwuDLNDFzJGngVWG3wJ_QeZJ7HlGR1VEQ_U5L5pg>
    <xmx:OHAIX4u5VYHcPwvNqP3qiiXRSWHCyMYJJ9ot6cq13s4b2u7ymPfCPg>
    <xmx:OHAIX1ZOOvEGH44I2tminZaiVM5OtP643hND19pWdZrTFsl0qP_tFA>
    <xmx:OXAIX2yO8CZp4EoSxBxYUr9uSTpkyDHcwKiKr7VHJu-rTCZJxbrNzw>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B1C63280063;
        Fri, 10 Jul 2020 09:42:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/2] mlxsw: Various fixes
Date:   Fri, 10 Jul 2020 16:41:37 +0300
Message-Id: <20200710134139.599811-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Fix two issues found by syzkaller.

Patch #1 removes inappropriate usage of WARN_ON() following memory
allocation failure. Constantly triggered when syzkaller injects faults.

Patch #2 fixes a use-after-free that can be triggered by 'devlink dev
info' following a failed devlink reload.

Ido Schimmel (2):
  mlxsw: spectrum_router: Remove inappropriate usage of WARN_ON()
  mlxsw: pci: Fix use-after-free in case of failed devlink reload

 drivers/net/ethernet/mellanox/mlxsw/pci.c     | 54 +++++++++++++------
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  2 +-
 2 files changed, 39 insertions(+), 17 deletions(-)

-- 
2.26.2

