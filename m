Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F65D1EA451
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 14:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgFAM7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 08:59:31 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33121 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgFAM7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 08:59:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B7AA95C00ED;
        Mon,  1 Jun 2020 08:59:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Jun 2020 08:59:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=E3/24F62NlPLS0BZI
        KB9PKwWbUkHMjMffQEINIidQHQ=; b=h99Te+LTYj1fbOkSZ9lHj1daH8EbqhQo8
        GoNJTebbOCgOQRQJk5CgvW2dZiclE2QA49BYWUSXYP0H92LkxfODq94vp053YwYC
        OQbxWAyjhrdmwtlPS0NTVI7zmS3dOwfT9ZUydlfzUB9He2kfybLj/cC1NIj+/9O6
        3gO6Ekr6cBMjfy4drsMvjJHeMD4Xvsxi9gGwmzA4tqa+96aSbqYfS5jdwXPijtY2
        cqo4RFH+XJGufRNZdVkk3GcYsQAD/IrroEvUu9tjxF5KwVhdRufq19p2So+sNDc2
        z5GBFesqcqxa4ZYI9ASvAzLaBDsGrlkbHSq7j4D3FPjLsOfjLg/9Q==
X-ME-Sender: <xms:sPvUXieK7K90UX0cZZk80uXgxvCoOyZML6oXARroqgAL64rSZ5kk9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudejiedrvdegrddutdejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:sPvUXsP4v-FS-rBpR0ghwEU-CAbwjHFtiCXpvY4Zc8CwWS2HK5Lx4w>
    <xmx:sPvUXjh1YP0A5vU9RBPcdDLfNmVAd9cOWekg05Z_JwVuOg-L0XzMhg>
    <xmx:sPvUXv-k5W8bq4BTQaFJgZGfDsfZdl36tej83l7ajYWyV5Y419bIrQ>
    <xmx:sfvUXgU2Y9q6SgJE8utFiGNVxCtZmDWzrULQZJNt16d7DsOokZyQJA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E84DB3280059;
        Mon,  1 Jun 2020 08:59:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, dlstevens@us.ibm.com,
        allas@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/2] Fix infinite loop in bridge and vxlan modules
Date:   Mon,  1 Jun 2020 15:58:53 +0300
Message-Id: <20200601125855.1751343-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When suppressing invalid IPv6 Neighbour Solicitation messages, it is
possible for the bridge and vxlan modules to get stuck in an infinite
loop. See the individual changelogs for detailed explanation of the
problem and solution.

The bug was originally reported against the bridge module, but after
auditing the code base I found that the buggy code was copied from the
vxlan module. This patch set fixes both modules. Could not find more
instances of the problem.

Please consider both patches for stable releases.

Ido Schimmel (2):
  bridge: Avoid infinite loop when suppressing NS messages with invalid
    options
  vxlan: Avoid infinite loop when suppressing NS messages with invalid
    options

 drivers/net/vxlan.c          | 4 ++++
 net/bridge/br_arp_nd_proxy.c | 4 ++++
 2 files changed, 8 insertions(+)

-- 
2.26.2

