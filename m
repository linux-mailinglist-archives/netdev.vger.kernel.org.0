Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39083E39E5
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503773AbfJXRZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:25:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27846 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2503753AbfJXRZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 13:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571937921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iXOnFSfNhNPTjcWXUtOF+yLaeNt74t+Dwru1WIRQ94c=;
        b=NHDmx0DDEPKnU9SX7Kz0sm4ryXG+ahsGT+uH80K6N2EoODXhdoGHVPwvrMSAryj9rZp2XE
        kAlKQb0poZeECDHhYyVpKm79kHnISI3AEF4F/zMzUm6BNZV3QPV/X6odhEbpl5eKDRrBIT
        leeo3Zp+epaSbqbgTEG98rkTl9v0i0I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-_Czfr_FAN1ieTF1P6DBbzA-1; Thu, 24 Oct 2019 13:25:20 -0400
Received: by mail-wr1-f71.google.com with SMTP id 4so9053722wrf.19
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 10:25:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1tLVyJdKCuQgsNv1sXrcha1cG9zhjVmljxh1NemQynM=;
        b=VkncP8e3keeSVq3/ueLV2DGOgiHL4JcPklnNRSHGYLtbE+g1pD9K++daUYaCJyk2Q8
         bekt02YgRQw1mRdIff+LI6XQRFhr4cpGSgYIdr1J7HtotaJCBcTgJkhkL5sTcvvwr8ER
         G1vYvVo6wLE0a7EM7lz/5lHyCf+PwS5ncM56EHz9CpMtztPiL51aNJZDT1fSGKJqqhDk
         W2jpsJopPPi9k/EtDg03udd2Tyywg2HjAyu9Oja3WcWChdQfXGQ4t1g67x3R/8hHW34M
         a5VqGbcmoIA0F8AbcObFcfeHzopVlYu/jROopaVez1lySLEayWDJEUeGT+qOtcsPs05m
         LNqA==
X-Gm-Message-State: APjAAAWGsG3kf6YHLWlNjLHQB1jzOwLhiuftNEwyitVQpLj5KDf9g2bp
        b6eJ3cmbbozXACamFHT3dKtGkjoYkPsQkOckJUDmDpiiGcF/YLRsXwhsNjz64zyxTcTI3P9UYUt
        k83SdEEANE/edMeQZ
X-Received: by 2002:a5d:424a:: with SMTP id s10mr4699709wrr.108.1571937918920;
        Thu, 24 Oct 2019 10:25:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyriwuqPsHKpY30rz7sHHDNla5FgdU0iJGQy5mR4Dg4Ubmi0Cx/2paGQ2bzZvi1RoZnn9Mlng==
X-Received: by 2002:a5d:424a:: with SMTP id s10mr4699692wrr.108.1571937918722;
        Thu, 24 Oct 2019 10:25:18 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 200sm4253443wme.32.2019.10.24.10.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 10:25:18 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/3] mvpp2: prefetch frame header
Date:   Thu, 24 Oct 2019 19:24:58 +0200
Message-Id: <20191024172458.7956-4-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191024172458.7956-1-mcroce@redhat.com>
References: <20191024172458.7956-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: _Czfr_FAN1ieTF1P6DBbzA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiving traffic, eth_type_trans() is high up on the perf top list,
because it's the first function which access the packet data.

Move the DMA unmap a bit higher, and put a prefetch just after it, so we
have more time to load the data into the cache.

The packet rate increase is about 14% with a tc drop test: 1620 =3D> 1853 k=
pps

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/=
ethernet/marvell/mvpp2/mvpp2_main.c
index 15818e1d6b04..a55de943d5cb 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2963,6 +2963,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct n=
api_struct *napi,
 =09=09dma_sync_single_for_cpu(dev->dev.parent, dma_addr,
 =09=09=09=09=09rx_bytes + MVPP2_MH_SIZE,
 =09=09=09=09=09DMA_FROM_DEVICE);
+=09=09prefetch(data);
=20
 =09=09if (bm_pool->frag_size > PAGE_SIZE)
 =09=09=09frag_size =3D 0;
--=20
2.21.0

