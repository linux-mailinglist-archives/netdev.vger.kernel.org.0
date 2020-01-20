Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEA5B142485
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 08:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgATHxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 02:53:45 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45393 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgATHxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 02:53:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E06E121A92;
        Mon, 20 Jan 2020 02:53:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 20 Jan 2020 02:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rLea/MninzjzcRv6K
        2cEb/BOKahnlAmiBT6PNutm1hE=; b=GCgAwViIlubDraphfxqiaJNWB0752QEx1
        Rl5DHxzsqT1GTxYSL/hmM0tEoQWGC1klLcVEyQtLLF4kQeKxCaA4HMpqYYm4l3JD
        5+4clUA0xuoOmdBHfukeduIxBbbd1HX/MvmKXjUjEoyE9Dj+wOhunwWLgWVJaEDm
        M8nImMThhAqny+zMw0Q7WdkNfAMcsBTaZYjg1V1hV60h2pbuOsHJqOK5FgxPPMrl
        DDRBgclx8ztZRRwetrklTqr0Me48pr9zwva47C2ZIju7z89XjUXOltEpyBYUAIRM
        6cROGkJO0VXaTLAUITZawqKJsUAQBmB4IvdVyyvNoV6alRTD+3/bg==
X-ME-Sender: <xms:iFwlXoeT4awUEGCIoNhG0hIwbygMtxny21agY76hFpdCdRW1h3hYfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeggdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:iFwlXucPMPoDp2O2Z_xjarpGvriIbcvyHK6SaoyByf77N6AxmIzVyQ>
    <xmx:iFwlXkg8X3G0gNyS1UoWfQ9yBeqhphzQi2ZfvIqz9oK3I8oShkDC7Q>
    <xmx:iFwlXiRkFOe1-COtPjsvKBvmanIelog9XIGaYWeBorPKwFteYxLuOA>
    <xmx:iFwlXgOvx7lS6fKG-sCg3QYc7V9QeAXjREHMT5HoUkOKrLueocfnkQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8DEB68005B;
        Mon, 20 Jan 2020 02:53:43 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/4] mlxsw: Adjust SPAN egress mirroring buffer size handling for Spectrum-2
Date:   Mon, 20 Jan 2020 09:52:49 +0200
Message-Id: <20200120075253.3356176-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Jiri says:

For Spectrum-2 the computation of SPAN egress mirroring buffer uses a
different formula. On top of MTU it needs also current port speed. Fix
the computation and also trigger the buffer size set according to PUDE
event, which happens when port speed changes.

Jiri Pirko (4):
  mlxsw: spectrum: Push code getting port speed into a helper
  mlxsw: spectrum_span: Put buffsize update code into helper function
  mlxsw: spectrum: Fix SPAN egress mirroring buffer size for Spectrum-2
  spectrum: Add a delayed work to update SPAN buffsize according to
    speed

 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 59 ++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  7 +++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 14 +----
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 61 +++++++++++--------
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |  1 +
 5 files changed, 105 insertions(+), 37 deletions(-)

-- 
2.24.1

