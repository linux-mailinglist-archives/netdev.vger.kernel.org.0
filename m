Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C43B2EB8
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 08:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfIOGs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 02:48:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53003 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbfIOGs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 02:48:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 96EA6214CE;
        Sun, 15 Sep 2019 02:48:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 15 Sep 2019 02:48:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=PyFjIh2IIbLO8u6I/
        MQ8+eSUic8PpGKxnYzWgduQg7U=; b=hnYIyqYfe2QfGuFqwPlnmFaOZW9eQBuVt
        rFrZ9QPpadWlLUzNLcedmA4wKoqPhSRFrjhaR35DbcQ/OBwegEahw2cTiR2IHvlL
        21B3qfcGfAGdxRHCxAoHMOmJmzzrjmB4J/jJ+lKGpsEV0jugLZvvIpAI4xQxbPBL
        o45sLha+khAFBkHbB+Bt7gbOz/xD00syhGLVhVFylVDRp2EPJw7jcZpJAXJfjV0y
        IjksMa6dFEQc+o5BqYGmpVgxxU9fZ/wwHT334md6BJUjU7RaXs2QWq4sQgszSt7f
        pYqxbZTMnPqnYbWTrrr2FeOJgfMGr/9fYKWl9pAFtfvp2fMNL/6SQ==
X-ME-Sender: <xms:ud59XWn2Stk3WBKF7yYEuk3dFpKQKILQk_hIoogfF4dQzbQmVXhdCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:ud59XW12jgbzwrm7JtEwBbVdRJJ8nMsZJFCHthya2TtCunRv9fSA3g>
    <xmx:ud59XRYRTTtjRa9Yw_3YLaVhenl39WlXB_BTEAvDpUZBt_zNmBHZcw>
    <xmx:ud59XY6R2NQTEoFgti3ZO1K2Xw2lFuDK8S7RD9p4LpdgWTgI_7J9FQ>
    <xmx:ut59XWOHiQNQk8j45MLJXlD97jUk5tfQAk03XTxJ1uAK9cX9aI45HQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0F50680060;
        Sun, 15 Sep 2019 02:48:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, nhorman@tuxdriver.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/2] drop_monitor: Better sanitize notified packets
Date:   Sun, 15 Sep 2019 09:46:34 +0300
Message-Id: <20190915064636.6884-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When working in 'packet' mode, drop monitor generates a notification
with a potentially truncated payload of the dropped packet. The payload
is copied from the MAC header, but I forgot to check that the MAC header
was set, so do it now.

Patch #1 sets the offsets to the various protocol layers in netdevsim,
so that it will continue to work after the MAC header check is added to
drop monitor in patch #2.

Ido Schimmel (2):
  netdevsim: Set offsets to various protocol layers
  drop_monitor: Better sanitize notified packets

 drivers/net/netdevsim/dev.c | 3 +++
 net/core/drop_monitor.c     | 6 ++++++
 2 files changed, 9 insertions(+)

-- 
2.21.0

