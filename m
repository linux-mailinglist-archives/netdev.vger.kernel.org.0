Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92E2E39E4
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503769AbfJXRZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:25:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50790 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503754AbfJXRZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 13:25:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571937918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VpdbFdZ43dAdHsNmWOOWt4oPOrJUSHjTzkCpLMaCuuo=;
        b=GsFXKGx7kTPujXEL9R0eMQjBW3UQn6hApjMIQSS9MxgIYl26NpZScrydsne1sXOafkyrgP
        UudVun8t8HrAH2WFRVgeAgk45iEarGg0GDeTMIkZjq7kV4zGicROM01KYyUO9g0Rfzw2cf
        t9PwKs0ndgPBhiu9sJXW8YzhSEqVz+g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-bFzwgXgVMdit-WYs_w0amA-1; Thu, 24 Oct 2019 13:25:15 -0400
Received: by mail-wr1-f72.google.com with SMTP id s9so13173104wrw.23
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 10:25:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l73Ha7i7WUxT4bY8TPcGyLFhUvLl2Vyl/Ql8ZlKhlJA=;
        b=MhtATVAQTy7gE1CjTErdW+SE/SkjEhfllTrOfjniVvLKyf5u03/iXaDpkSVQVTFPbT
         f8GnmyssfhQAW1Y51vVwyWTfCav8pT2eONJXqmPdB9qUdiPKoIwdLSgIC9BwwNUnxrEX
         cavBRQ7H4sVnuK8FX4uK+r8CbSRkYG8FTrlaL8pu30B6EkIsBIEgKsJo6m4IW/OPWT2y
         bqTbRoplTUJOhUtCx0t1ckWB6KQnL1Jb235NyOlAK3Z5muHhytYcoX8L8fp7FNXz4qHA
         4S0B0eElZdlY4I7/7RelASZw+nEsjkpKFG3t4rknc54GwpHZ6lpxa3Jf63VGdX3Q5cyz
         0fdw==
X-Gm-Message-State: APjAAAX6bwP4T09v+G28cF/W3DSeQGQHQxJ1KdxhhubhWEvbwKpxdzOZ
        S7V85fVPJnKYI2cW9CGCZIWktXDcoTPeb+aLHJBoRUJeDGJxv5fQhKpDYGpOKtpL/uzvGIvJSzi
        KZcTvQz5bkvwQHs1O
X-Received: by 2002:a5d:4f89:: with SMTP id d9mr5056832wru.286.1571937913968;
        Thu, 24 Oct 2019 10:25:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwHb1xE6BrpQ9IL+1bpB0SlzJ+EkiGGWVx3kl5wPRrTnXwQf2aGUhZCPyS1D1C/Gt0smnGOBg==
X-Received: by 2002:a5d:4f89:: with SMTP id d9mr5056818wru.286.1571937913738;
        Thu, 24 Oct 2019 10:25:13 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 200sm4253443wme.32.2019.10.24.10.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 10:25:13 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/3] mvpp2: sync only the received frame
Date:   Thu, 24 Oct 2019 19:24:57 +0200
Message-Id: <20191024172458.7956-3-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191024172458.7956-1-mcroce@redhat.com>
References: <20191024172458.7956-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: bFzwgXgVMdit-WYs_w0amA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the RX path we always sync against the maximum frame size for that pool.
Do the DMA sync and the unmap separately, so we can only sync by the
size of the received frame.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/=
ethernet/marvell/mvpp2/mvpp2_main.c
index 33f327447b70..15818e1d6b04 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2960,6 +2960,10 @@ static int mvpp2_rx(struct mvpp2_port *port, struct =
napi_struct *napi,
 =09=09if (rx_status & MVPP2_RXD_ERR_SUMMARY)
 =09=09=09goto err_drop_frame;
=20
+=09=09dma_sync_single_for_cpu(dev->dev.parent, dma_addr,
+=09=09=09=09=09rx_bytes + MVPP2_MH_SIZE,
+=09=09=09=09=09DMA_FROM_DEVICE);
+
 =09=09if (bm_pool->frag_size > PAGE_SIZE)
 =09=09=09frag_size =3D 0;
 =09=09else
@@ -2977,8 +2981,9 @@ static int mvpp2_rx(struct mvpp2_port *port, struct n=
api_struct *napi,
 =09=09=09goto err_drop_frame;
 =09=09}
=20
-=09=09dma_unmap_single(dev->dev.parent, dma_addr,
-=09=09=09=09 bm_pool->buf_size, DMA_FROM_DEVICE);
+=09=09dma_unmap_single_attrs(dev->dev.parent, dma_addr,
+=09=09=09=09       bm_pool->buf_size, DMA_FROM_DEVICE,
+=09=09=09=09       DMA_ATTR_SKIP_CPU_SYNC);
=20
 =09=09rcvd_pkts++;
 =09=09rcvd_bytes +=3D rx_bytes;
--=20
2.21.0

