Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671D9E39E0
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503745AbfJXRZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:25:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22790 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503737AbfJXRZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 13:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571937911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eP2BoDS+qKrOlRNhNKzclArVzVRVn8mElyDMenO637o=;
        b=e5bgRuvVmvf9LboseYmdCtWRVU7qNcLnO0AOIPgltsqYgcPl2NC7MkXxT7wykYdf6IGsNM
        ZMung0BJ3LmUpYwmz5FFRizZSM+zbbeQwboWDsoBLs6FiudImDvzQvYAZ5INEdKteTwZyX
        c8pUzBMjijn/Jl3D1f20dNPFQicq5zs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-eaXsN3joOwG6XWbpwO4mUw-1; Thu, 24 Oct 2019 13:25:09 -0400
Received: by mail-wr1-f71.google.com with SMTP id h4so13213562wrx.15
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 10:25:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sEHK/Mm+/W2s4S1uZhkuoDS67kM3geWIeg5D1P9O+N8=;
        b=lPMvy7pzNrm5oSt8Lh23K/XJZu77dUuXkLdVOcUXSQ1s2XnjVMlD5e5Hj9yYPoA2Dw
         WBPleCmp8ls7Xxaab+mbKdWe5H5cLbC9pAjcHRRWOV/FRDIBGiD/7fjOdainCVXt2rPh
         9kTa4d9R4OiQnSSivqAmaEmAnQSvFTOGgO2QCLGnw/Fijiyc2e9WwZrNmOCkKbng25NL
         xiRtMHy3RHuKdcdA1j3EPj00VojDTvRooJGD9cAJ+dpjD5gUVB3mi5OunWQZqCQLsKfM
         aJeUadobvWVq0mFJpmw5hmJaB+5mIoyXjD6UzfSUqH3bGXRcb9VfChfPBhjP72UXAEyU
         U36w==
X-Gm-Message-State: APjAAAXCbuWS75IKAQLgWGFFCh3uVZBxNmm6SNhLZCWhVYXQz1MBbtn6
        xPNDBcCvsiADEmH0GaOpsIflRrfcQNG5CaqBayVDF+VSZ9vSA6ubuLHVJ3fXxDyfU5NQFTRE4YK
        g6sx6r93EiDHDV6ZF
X-Received: by 2002:adf:fec3:: with SMTP id q3mr4844750wrs.343.1571937907941;
        Thu, 24 Oct 2019 10:25:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw+10+EuLZ+rBVSTixGZLcQx5XS8FxFqlBPvpQbaowcsIkiyMX0FX0F2OQ+sQ4I41O86D0+1g==
X-Received: by 2002:adf:fec3:: with SMTP id q3mr4844734wrs.343.1571937907744;
        Thu, 24 Oct 2019 10:25:07 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 200sm4253443wme.32.2019.10.24.10.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 10:25:07 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/3] mvpp2: refactor frame drop routine
Date:   Thu, 24 Oct 2019 19:24:56 +0200
Message-Id: <20191024172458.7956-2-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191024172458.7956-1-mcroce@redhat.com>
References: <20191024172458.7956-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: eaXsN3joOwG6XWbpwO4mUw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move some code down to remove a backward goto.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/=
ethernet/marvell/mvpp2/mvpp2_main.c
index 111b3b8239e1..33f327447b70 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2957,14 +2957,8 @@ static int mvpp2_rx(struct mvpp2_port *port, struct =
napi_struct *napi,
 =09=09 * by the hardware, and the information about the buffer is
 =09=09 * comprised by the RX descriptor.
 =09=09 */
-=09=09if (rx_status & MVPP2_RXD_ERR_SUMMARY) {
-err_drop_frame:
-=09=09=09dev->stats.rx_errors++;
-=09=09=09mvpp2_rx_error(port, rx_desc);
-=09=09=09/* Return the buffer to the pool */
-=09=09=09mvpp2_bm_pool_put(port, pool, dma_addr, phys_addr);
-=09=09=09continue;
-=09=09}
+=09=09if (rx_status & MVPP2_RXD_ERR_SUMMARY)
+=09=09=09goto err_drop_frame;
=20
 =09=09if (bm_pool->frag_size > PAGE_SIZE)
 =09=09=09frag_size =3D 0;
@@ -2995,6 +2989,13 @@ static int mvpp2_rx(struct mvpp2_port *port, struct =
napi_struct *napi,
 =09=09mvpp2_rx_csum(port, rx_status, skb);
=20
 =09=09napi_gro_receive(napi, skb);
+=09=09continue;
+
+err_drop_frame:
+=09=09dev->stats.rx_errors++;
+=09=09mvpp2_rx_error(port, rx_desc);
+=09=09/* Return the buffer to the pool */
+=09=09mvpp2_bm_pool_put(port, pool, dma_addr, phys_addr);
 =09}
=20
 =09if (rcvd_pkts) {
--=20
2.21.0

