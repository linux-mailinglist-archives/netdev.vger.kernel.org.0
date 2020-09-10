Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C4826450A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 13:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgIJLF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 07:05:29 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:40315 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730551AbgIJLCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 07:02:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id AE2F9580388;
        Thu, 10 Sep 2020 07:02:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 10 Sep 2020 07:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vPLRzzr0yNunKpuYM
        ODCuR1yI/uoCVoSZZXD6UDiNE0=; b=mp+niz7GAYDVngeC6/z4mbEiQC+Qh90jG
        qFb4b7S5Gb8VLS/ZE3EpMbn+SMhuC0iTdy2QcxP9SItjkvph2J4zgLJCwuxTsySQ
        e8NVB9AWQpgkNTXlxoaNQ0q+UmJfUI8b7W91mVXX1XgOSwyO+YpPUEyTfMdytxvE
        7gRGikS1IgJO81JewpagkPs4cFjqVJKlZ+oyfHlPno2tC6ToPTRaE0QYbGxYW0vB
        h8WXvPPvodKuLcgwBn0RE/FR1k3WspOvtcIjKC4E31lCL9ILmhJWRrFueRZ5k/6W
        /M8QL+ZUM9Abl3asHyCbkHaciEtAFMKMZYismwyLn9H7tpdT/rhsg==
X-ME-Sender: <xms:sAdaX717BjTUft2Z3-fgHmrgnADCj6DtJlblNd_jdvUsTcaDBoIg9Q>
    <xme:sAdaX6GZIDr_wCFS3sRE3Tl0Qu5z0ZSxGuYlT0umE7ljQpR4Zebw-7RN9kVupmuON
    7yvSr7JX6B_Cs0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehjedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrfeeirddufedunecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:sAdaX75ntD9PErwTCM5i7zgVFXdjvKD7fHZC2b7sYCojdxAACGrHjQ>
    <xmx:sAdaXw1MEOEANkCjWdNoALqugDoB7OterIM3z2pDupQ9UZuNnIie7A>
    <xmx:sAdaX-HTgxaF-V3QnHih7qJp7ccnLTJa81BtEykEkDtkAvcb-7qjeQ>
    <xmx:sQdaX8a7ZA9IXG7bl5hWVes2-rXQ0tcVEzlWtSRjUpROygfMLdkMyA>
Received: from shredder.mtl.com (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 456523064692;
        Thu, 10 Sep 2020 07:02:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        nikolay@nvidia.com, roopa@nvidia.com,
        vasundhara-v.volam@broadcom.com, jtoppins@redhat.com,
        michael.chan@broadcom.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/2] net: Fix bridge enslavement failure
Date:   Thu, 10 Sep 2020 14:01:25 +0300
Message-Id: <20200910110127.3113683-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 fixes an issue in which an upper netdev cannot be enslaved to a
bridge when it has multiple netdevs with different parent identifiers
beneath it.

Patch #2 adds a test case using two netdevsim instances.

Ido Schimmel (2):
  net: Fix bridge enslavement failure
  selftests: rtnetlink: Test bridge enslavement with different parent
    IDs

 net/core/dev.c                           |  2 +-
 tools/testing/selftests/net/rtnetlink.sh | 47 ++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

-- 
2.26.2

