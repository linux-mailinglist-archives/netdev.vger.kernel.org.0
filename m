Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E2C6E5BFC
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjDRI2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjDRI2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:28:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049361708
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 01:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681806433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MREzUlrj7n/A3t+HzoYR0Y9aLZUZbKEGAr7lzy3qn2g=;
        b=OJLsmc+nIV4+4hrKgs4cEAqAW5KV1DQw75kv+iA6QbANoo0XL9sdLFLCusTR530XeRicMp
        rIwgOnJcg/788QsBz4zMT7hUFBYtmtfEo9xQ7cOdWVy/9JKbzhxNEE5VLW6sZqKoK1/yJJ
        TO+qy84s35w5eprXEVSiIoo/e7jbOpE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-iA-Bihq0MYmySx-o9k9FGA-1; Tue, 18 Apr 2023 04:27:11 -0400
X-MC-Unique: iA-Bihq0MYmySx-o9k9FGA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f0a16eb83bso5473595e9.0
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 01:27:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681806430; x=1684398430;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MREzUlrj7n/A3t+HzoYR0Y9aLZUZbKEGAr7lzy3qn2g=;
        b=CjfIQHkuOBfWsYO/Uan/Tvu0cQg+MzckYLBeVJ8YBv7MeNPOCezJsPUEl6FNnkMowh
         QMsm0YHxO4OmYiENl/6Bk5HbYfubFBjUpsEDq1iYudlx5uVjOJKcKGDXVuRt0Ti83WMn
         oNeCnaAk9ZxlSnNJd52KaauR5U+DRXjV2ZMYC1Lskv6L6nqv6wwN7mcq3uZv532WKQmY
         h1XhvzCi2ekZV5vJEMnBbvCyY/deu0w4mpk6wM6dkHqWn8rSCIzVdCgiiUbSZg2f0IFI
         eAP6eOTwgFiOc7auDU/2wws5a+02wwehUJZTI/LtOYpOoKtYE5SPykZzHmcnDFEXioK0
         Aqfg==
X-Gm-Message-State: AAQBX9e3onFT5PetJa5Qntkk3dOukDIk4Bu8y6QjxoUv3UVxBpUMrla0
        LCBHpcCAo2Y/shZ8ULal7F+mIFCqbq4JYdUStSQdpk6RSl21SGRYTy+msXbhd1ehKOfv5x8yGOZ
        QdAIe4F+HKX4TRNeJ
X-Received: by 2002:a05:600c:3d18:b0:3f1:7490:e595 with SMTP id bh24-20020a05600c3d1800b003f17490e595mr3691443wmb.2.1681806430444;
        Tue, 18 Apr 2023 01:27:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zg0WNXAUtuScHxVjRqynn872fn99A/LUSVDsZY3KNP0ldqKWsFWEKpdQ3Rj3NLNpfKkAlNaQ==
X-Received: by 2002:a05:600c:3d18:b0:3f1:7490:e595 with SMTP id bh24-20020a05600c3d1800b003f17490e595mr3691426wmb.2.1681806430142;
        Tue, 18 Apr 2023 01:27:10 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-229-200.dyn.eolo.it. [146.241.229.200])
        by smtp.gmail.com with ESMTPSA id jb17-20020a05600c54f100b003f17316ab46sm6031322wmb.13.2023.04.18.01.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 01:27:09 -0700 (PDT)
Message-ID: <e4309e95bc98ff2d464dd26fc4f3e77a914a6cb5.camel@redhat.com>
Subject: Re: [PATCH net-next v2 6/6] tsnep: Add XDP socket zero-copy TX
 support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com
Date:   Tue, 18 Apr 2023 10:27:08 +0200
In-Reply-To: <20230415144256.27884-7-gerhard@engleder-embedded.com>
References: <20230415144256.27884-1-gerhard@engleder-embedded.com>
         <20230415144256.27884-7-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-04-15 at 16:42 +0200, Gerhard Engleder wrote:
> Send and complete XSK pool frames within TX NAPI context. NAPI context
> is triggered by ndo_xsk_wakeup.
>=20
> Test results with A53 1.2GHz:
>=20
> xdpsock txonly copy mode:
>                    pps            pkts           1.00
> tx                 284,409        11,398,144
> Two CPUs with 100% and 10% utilization.
>=20
> xdpsock txonly zero-copy mode:
>                    pps            pkts           1.00
> tx                 511,929        5,890,368
> Two CPUs with 100% and 1% utilization.
>=20
> Packet rate increases and CPU utilization is reduced.
>=20
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep.h      |   2 +
>  drivers/net/ethernet/engleder/tsnep_main.c | 131 +++++++++++++++++++--
>  2 files changed, 123 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet=
/engleder/tsnep.h
> index d0bea605a1d1..11b29f56aaf9 100644
> --- a/drivers/net/ethernet/engleder/tsnep.h
> +++ b/drivers/net/ethernet/engleder/tsnep.h
> @@ -70,6 +70,7 @@ struct tsnep_tx_entry {
>  	union {
>  		struct sk_buff *skb;
>  		struct xdp_frame *xdpf;
> +		bool zc;
>  	};
>  	size_t len;
>  	DEFINE_DMA_UNMAP_ADDR(dma);
> @@ -88,6 +89,7 @@ struct tsnep_tx {
>  	int read;
>  	u32 owner_counter;
>  	int increment_owner_counter;
> +	struct xsk_buff_pool *xsk_pool;
> =20
>  	u32 packets;
>  	u32 bytes;
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/eth=
ernet/engleder/tsnep_main.c
> index 13e5d4438082..de51d0cc8935 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -54,6 +54,8 @@
>  #define TSNEP_TX_TYPE_SKB_FRAG	BIT(1)
>  #define TSNEP_TX_TYPE_XDP_TX	BIT(2)
>  #define TSNEP_TX_TYPE_XDP_NDO	BIT(3)
> +#define TSNEP_TX_TYPE_XDP	(TSNEP_TX_TYPE_XDP_TX | TSNEP_TX_TYPE_XDP_NDO)
> +#define TSNEP_TX_TYPE_XSK	BIT(4)
> =20
>  #define TSNEP_XDP_TX		BIT(0)
>  #define TSNEP_XDP_REDIRECT	BIT(1)
> @@ -322,13 +324,51 @@ static void tsnep_tx_init(struct tsnep_tx *tx)
>  	tx->increment_owner_counter =3D TSNEP_RING_SIZE - 1;
>  }
> =20
> +static void tsnep_tx_enable(struct tsnep_tx *tx)
> +{
> +	struct netdev_queue *nq;
> +
> +	nq =3D netdev_get_tx_queue(tx->adapter->netdev, tx->queue_index);
> +
> +	local_bh_disable();
> +	__netif_tx_lock(nq, smp_processor_id());

The above 2 statements could be replaced with:

	__netif_tx_lock_bh()

> +	netif_tx_wake_queue(nq);
> +	__netif_tx_unlock(nq);
> +	local_bh_enable();

__netif_tx_unlock_bh()

> +}
> +
> +static void tsnep_tx_disable(struct tsnep_tx *tx, struct napi_struct *na=
pi)
> +{
> +	struct netdev_queue *nq;
> +	u32 val;
> +
> +	nq =3D netdev_get_tx_queue(tx->adapter->netdev, tx->queue_index);
> +
> +	local_bh_disable();
> +	__netif_tx_lock(nq, smp_processor_id());

Same here.


Thanks!

Paolo

