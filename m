Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9224383A5
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 14:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhJWMVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 08:21:53 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:61343 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhJWMVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 08:21:50 -0400
Date:   Sat, 23 Oct 2021 12:19:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1634991566; bh=GG4tUVfOrpHe6Cd9R03tfHXWzUXIPi4QaFA+XbWzydI=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=AfZZAR9wTmzyooI6hInfocai8sWVjg5SuP6fVB2J3d4FGS6gQh0FyI6XmelurR6FC
         t7mMGjEJiErx33eJyN5/qVWB6QB4JYhcm7eeRccDj0Gkhl6K1nOajiu+yfrM4e7Br+
         j3kkWCsygrBwf5lhHpQ8voGpnLtzOS4B3j3X/vAYvZIWyHy3+b7cgx2Bu7XelC0bWn
         34WLuugx08P9HJo+/sydhh6ra1W9gl4NHHuCn9H27KokxFG3DTIWw76w1Xt/omxr2r
         le5D4MtZm4yOPUxqQoh/K7zDvd4RKmNMGRGfPG6TAHzZASIpv+wkPH8yose6Yrg7hJ
         gbBPBr2VuUp9g==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     =?utf-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next] ax88796c: fix fetching error stats from percpu containers
Message-ID: <20211023121148.113466-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rx_dropped, tx_dropped, rx_frame_errors and rx_crc_errors are being
wrongly fetched from the target container rather than source percpu
ones.
No idea if that goes from the vendor driver or was brainoed during
the refactoring, but fix it either way.

Fixes: a97c69ba4f30e ("net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Dr=
iver")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/ethernet/asix/ax88796c_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethern=
et/asix/ax88796c_main.c
index cfc597f72e3d..91fa0499ea6a 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -672,10 +672,10 @@ static void ax88796c_get_stats64(struct net_device *n=
dev,
 =09=09stats->tx_packets +=3D tx_packets;
 =09=09stats->tx_bytes   +=3D tx_bytes;

-=09=09rx_dropped      +=3D stats->rx_dropped;
-=09=09tx_dropped      +=3D stats->tx_dropped;
-=09=09rx_frame_errors +=3D stats->rx_frame_errors;
-=09=09rx_crc_errors   +=3D stats->rx_crc_errors;
+=09=09rx_dropped      +=3D s->rx_dropped;
+=09=09tx_dropped      +=3D s->tx_dropped;
+=09=09rx_frame_errors +=3D s->rx_frame_errors;
+=09=09rx_crc_errors   +=3D s->rx_crc_errors;
 =09}

 =09stats->rx_dropped =3D rx_dropped;
--
2.33.1


