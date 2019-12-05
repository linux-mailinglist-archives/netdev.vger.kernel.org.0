Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D97FD1147FE
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 21:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfLEUQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 15:16:32 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:33545 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729154AbfLEUQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 15:16:31 -0500
Received: by mail-ua1-f66.google.com with SMTP id v19so1121863uap.0
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 12:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=usp-br.20150623.gappssmtp.com; s=20150623;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=+PAsaau8Pc86dNWNE5WgPPHpnNJ+hPG17eeu+dzateg=;
        b=U3XBGzfONuK1hmDoEufcSfEkOKVeqXSwnBCvvNAV0eP69OTgBOJ/31ZuHdC1hgPhrm
         5ixFOcB4CsfBTWvKwcHLlyb3lxjme4XnFZQ6mSOhHFAKwgjaqB5QmSNbRvLevY7j60s+
         Vo3qb1rjucy7wu5jMjTcKT7tyUpST4HlwrXtvu+k3B0l/M6zFaokzSIuXuVE1X8uXfAw
         T6huCivyiV7Vc5vKObg2T8Et+d37RYxxpgxaELVbPchlcpp0pgv9VCD9epIDLvj2EA2S
         gG/xhKFD5eiPTeIQyrvw1VTJJWbQzH7DzRV1k06llNLx9rQfswR2O7ieX5vPqHynmWeN
         Wswg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=+PAsaau8Pc86dNWNE5WgPPHpnNJ+hPG17eeu+dzateg=;
        b=QxNDYaV4k97Xz2KobE3K+z3tzZd5t5x11m8tO7fjAIw3iDRYO/lzlgMhIsILFJTGLo
         vlFGfc0tADGsaLfq/sVMTrUFZq9qcVEgWjNmN7UcuorQtAexP4r0kv9Ts4BeWFbVAUCJ
         uklX2vW45EQNdlYwhLJ8/CvTh3pNvFnUdUkcPhsW3ffU3jE7pgsJsDGQ5gW2/qcVlw8p
         Q60c53UgwBzlQJXfb+tAm99uH8ugQ/podwP0tlMENyvAUTVlEsVwyr9VJGVlStxVe9yz
         0wI+DaFBHS/JYAYkE7JcnjZVxkeWRpazc4lgYkdo3Cy+d3NeKuBxxXnpWATnISgC4B0t
         FkxA==
X-Gm-Message-State: APjAAAW7pFadBKDshL/Ql1h227Zps2qo0nWaDIF20B/cfSk5r0X9hZ+L
        txnLB/WA8RwK8oQI2rMbi6GsGaqp1fytylqv
X-Google-Smtp-Source: APXvYqxbQ0BlUQrYzKzKpuJqlfUf6qBDONo+nNcKVthvLVWsG01zeFgFEowODLmdUN97IC4I0HloNw==
X-Received: by 2002:ab0:2982:: with SMTP id u2mr8964173uap.138.1575576989976;
        Thu, 05 Dec 2019 12:16:29 -0800 (PST)
Received: from [172.19.109.238] ([143.107.45.1])
        by smtp.gmail.com with ESMTPSA id q3sm4949615vkd.4.2019.12.05.12.16.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Dec 2019 12:16:29 -0800 (PST)
From:   Bruno Carneiro da Cunha <brunocarneirodacunha@usp.br>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: [PATCH] lpc_eth: kernel BUG on remove
Message-Id: <3A5A66BC-5DAB-4408-A904-10D5EDD99158@usp.br>
Date:   Thu, 5 Dec 2019 17:16:26 -0300
Cc:     linux@danielsmartinez.com
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3445.104.8)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We may have found a bug in the nxp/lpc_eth.c driver. The function =
platform_set_drvdata() is called twice, the second time it is called, in =
lpc_mii_init(), it overwrites the struct net_device which should be at =
pdev->dev->driver_data with pldat->mii_bus. When trying to remove the =
driver, in lpc_eth_drv_remove(), platform_get_drvdata() will return the =
pldat->mii_bus pointer and try to use it as a struct net_device pointer. =
This causes unregister_netdev to segfault and generate a kernel BUG. Is =
this reproducible?

We recommend the following patch to fix it.=20

Signed-off-by: Daniel Martinez <linux@danielsmartinez.com>
Signed-off-by: Bruno Carneiro da Cunha <brunocarneirodacunha@usp.br>

---
 drivers/net/ethernet/nxp/lpc_eth.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c =
b/drivers/net/ethernet/nxp/lpc_eth.c
index ebb81d6d4..656169214 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -817,8 +817,6 @@ static int lpc_mii_init(struct netdata_local *pldat)
 	pldat->mii_bus->priv =3D pldat;
 	pldat->mii_bus->parent =3D &pldat->pdev->dev;

-	platform_set_drvdata(pldat->pdev, pldat->mii_bus);
-
 	node =3D of_get_child_by_name(pldat->pdev->dev.of_node, "mdio");
 	err =3D of_mdiobus_register(pldat->mii_bus, node);
 	of_node_put(node);
--
2.20.1=20=
