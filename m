Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0366034CDAD
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 12:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhC2KKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 06:10:38 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38349 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232573AbhC2KKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 06:10:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 747F05C0093;
        Mon, 29 Mar 2021 06:10:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 06:10:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QMdcON+77YuNwW32B
        1jQJlsQfIwGub5hN+3xLcX7rfw=; b=bldbcj51zVDj9i44vIubJUd8dvh2jQj71
        qWSS26BtjDd8sepEOv4W5k0cKctp1wkyu2qEyYbAoJ3WzD98kOht76BQVYYJ69N5
        zAdLeKTsuCF8YW2nBT0JYPv6aeIRklDDnpyMlJjJ7zMr/H6tfoIXYDHWGxdXzY90
        9muVk79x9bTbzPsc5i2wyFYSmQ9NJ3566vTjvZOW+0Q0G+NO/K47IjyqUKDBQRqz
        xwpqN0tPbdikRLmrY3v4KhM3sya0jmnLmceDG1yzzTfEaZdVV42ByUKs1xZ+03b5
        6YMnGFn5PljQv6vsU7jcVgYfSiVdcllq/WuwHeeH6hq/jXXt1SB7A==
X-ME-Sender: <xms:j6dhYLtSaYjo1sa2FXbHW37ZvyM0fpn6RKR48TZkHwuFB2eEXT6_7A>
    <xme:j6dhYMdXhmvN1__ou44q-zOHtRgL3M8JxfWmHx33frEqbzdOuBIagnunZskCL3N-y
    on-c0qrI32Znw8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrgeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:j6dhYOyB5O-ep2oHORSI6pKFDVJsiCCV8ijWn35nHkMZe3LEyc7Yiw>
    <xmx:j6dhYKPFeCO_wnY8Kr94arIMUWuNjGvXZaXUVbh-4D4P9azmaifFHQ>
    <xmx:j6dhYL9chGRF3dt0lh7jWGRAVKYv0U55lv-hr-gPf4oCBeodWdf06w>
    <xmx:j6dhYNKiEPAFWRe3ihNi4Sc0uQlOtAo58JoA-6I4v05trlqQgf49ow>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E4A5240054;
        Mon, 29 Mar 2021 06:10:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/6] mlxsw: Two sampling fixes
Date:   Mon, 29 Mar 2021 13:09:42 +0300
Message-Id: <20210329100948.355486-1-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset fixes two bugs in recent sampling submissions.

The first fix, in patch #3, prevents matchall rules with sample action
to be added in front of flower rules on egress. Patches #1-#2 are
preparations meant at avoiding similar bugs in the future. Patch #4 is a
selftest.

The second fix, in patch #5, prevents sampling from being enabled on a
port if already enabled. Patch #6 is a selftest.

Ido Schimmel (6):
  mlxsw: spectrum_matchall: Perform protocol check earlier
  mlxsw: spectrum_matchall: Convert if statements to a switch statement
  mlxsw: spectrum_matchall: Perform priority checks earlier
  selftests: mlxsw: Test matchall failure with protocol match
  mlxsw: spectrum: Veto sampling if already enabled on port
  selftests: mlxsw: Test vetoing of double sampling

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  5 ++
 .../mellanox/mlxsw/spectrum_matchall.c        | 46 ++++++++++---------
 .../drivers/net/mlxsw/tc_restrictions.sh      | 17 +++++++
 .../selftests/drivers/net/mlxsw/tc_sample.sh  | 30 ++++++++++++
 4 files changed, 76 insertions(+), 22 deletions(-)

-- 
2.30.2

