Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B26E0625
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388283AbfJVOOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:14:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36462 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728504AbfJVOOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571753686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3mPV7Lvqud62ejV9ltsaZ32Xw/m6Chr/EI0mwJ2l8R8=;
        b=UYhz/x2XJ7Uof4EQ72v/2kVFz0xqn6f0RCqyQZxM2xc2crRpjKUoaju6ntBxfzR63ZmGVL
        NNvWvmI9yGnVKeCXcz5BAUoNe+j8ZfXmhowRQCTKt+FrXUd+L7eU4wgrvHeqQ2LToAxVVg
        ah8aymwtzuxKCMgXv5u2ozJV6UblyCI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-NF3PASVqPXq1rQep7IgW3Q-1; Tue, 22 Oct 2019 10:14:45 -0400
Received: by mail-wr1-f71.google.com with SMTP id x9so2903684wrq.5
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 07:14:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kMPt/t32x+1ODJs2XSy8W133vtfVEltVTT+TH3yLruo=;
        b=Y0ZMrza3nmqkLT4rOGedDfLppAwUhNAahjZrmltD/TVRK//7a1WFDkYVf8veq2J7vK
         LmDnmvHqenZuhcAfYmC5GMDzNlnbrCtXyt7LX/0/kE8foatU4aaavPHwPJBL/5ggCZlt
         4XftCtKbl7/KLSiWEF6ndhALcO6KdW+qou3bIlx/hlrCR4FGT9z3ymQnteroXwaveUTt
         v80rXAstTwapdqbG/RT4XJ8xBLAWZkUY/d5Is/qE2KCmRIgBRZ/5gYE9z5GTeUTwejle
         sH4whD01ejqNLPAgnqI7fCZ9YwO/OhMyggUEU6pnEQQUkj25kNUqE9AUJhIG3WunoVEw
         b3XQ==
X-Gm-Message-State: APjAAAXrHYUdJVwOvZAA6zXA4WtgUilCTJRf0c1tZ2+DUHfbiw1xIf/E
        j4Drs1DcxP0zmEgvAS6lDKukuHXMqcaKKcIpggdQUAcAprbe4B9jveHn+UyK09ZAMXzt/jEcjxV
        Tq84Zol1JhvC5GUjo
X-Received: by 2002:a1c:1a95:: with SMTP id a143mr3101171wma.85.1571753683075;
        Tue, 22 Oct 2019 07:14:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwjYxSC4lQ+YDOYHCxAn6MLTwUvZVS5nL+m7CEVs7fbxB2mvutslNDGc4MQu6FR+JAKOxH8dg==
X-Received: by 2002:a1c:1a95:: with SMTP id a143mr3101149wma.85.1571753682811;
        Tue, 22 Oct 2019 07:14:42 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r19sm11625521wrr.47.2019.10.22.07.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 07:14:41 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] mvpp2: prefetch frame header
Date:   Tue, 22 Oct 2019 16:14:38 +0200
Message-Id: <20191022141438.22002-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: NF3PASVqPXq1rQep7IgW3Q-1
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

The packet rate increase is about 13% with a tc drop test: 1620 =3D> 1830 k=
pps

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/=
ethernet/marvell/mvpp2/mvpp2_main.c
index 111b3b8239e1..17378e0d8da1 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2966,6 +2966,11 @@ static int mvpp2_rx(struct mvpp2_port *port, struct =
napi_struct *napi,
 =09=09=09continue;
 =09=09}
=20
+=09=09dma_unmap_single(dev->dev.parent, dma_addr,
+=09=09=09=09 bm_pool->buf_size, DMA_FROM_DEVICE);
+
+=09=09prefetch(data);
+
 =09=09if (bm_pool->frag_size > PAGE_SIZE)
 =09=09=09frag_size =3D 0;
 =09=09else
@@ -2983,9 +2988,6 @@ static int mvpp2_rx(struct mvpp2_port *port, struct n=
api_struct *napi,
 =09=09=09goto err_drop_frame;
 =09=09}
=20
-=09=09dma_unmap_single(dev->dev.parent, dma_addr,
-=09=09=09=09 bm_pool->buf_size, DMA_FROM_DEVICE);
-
 =09=09rcvd_pkts++;
 =09=09rcvd_bytes +=3D rx_bytes;
=20
--=20
2.21.0

