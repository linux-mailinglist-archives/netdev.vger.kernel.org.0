Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8014066A700
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 00:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjAMXYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 18:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjAMXYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 18:24:18 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009936084B
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:24:17 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 207so1174028pfv.5
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FNBX4IUuGCsk3iScEzWUZQTuYhBGbsHeymdyFMhVUUo=;
        b=UGm5XVLZ/Pf8mEHaqhlTVc3mvoLqx4t5aN0Wq+EvFeDu4Ou3DksaHCq7Xqnlg+tssg
         4Op9MTtWSCHUqbsMVchfpEiR+Wyy4OuwH2SLwpXFMArzD0NdBM5znXELBDVhrsb4TfZi
         ea1zK0tu8FHtrdqaKd+QsMwx8eFMe7/tZPIsY5C1iedYStuFXaMQQ0D7VXzh0NxRP4KY
         33w0BLROdaySpI6EBCG34nzgD+Ae6gAB1ORh3waKXitbQry6FVCTl8IvP9yml1+Olxt3
         zjKBAE/UzhKowPcL6KkcffuMCK1XdIQH4WSIGJ2uJuVFrc5tbYN7QDEiePkrMAbMivK2
         dJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FNBX4IUuGCsk3iScEzWUZQTuYhBGbsHeymdyFMhVUUo=;
        b=JkoeQpveKp8R0Bf23BRGm77s0xnbHKf3cLE2GA2bLkC0Ji9DR15OpNrFim/+h17a2M
         Yp6eVSBEv2ADuvnkPWqpxdPR8K59RuHNCR/lUrr/QKVgzXh9wMq51v3Zoj6Bt5mZAYeJ
         ozADDVuhSMrryQgr7AfeuXzmeeisx1D+E9tEXymwzedFK04iwcR2u7rJKvh6mdwhEp7B
         i2KqfXuNLznkZYjqb9Tq5dp9shgwgMVPBteckCJ1ycT2rJpgikj4ydbJC4fbfylLHAI+
         nnRFwdzCv5Yt5crtE16cyfYykmO4Fc1t0ictjwSf7+/LyIXPbWc8RJVUEM9gNWH44f/m
         2WnQ==
X-Gm-Message-State: AFqh2kqIaPrgCykikywS89zFv25iKIZxTvLAPgnmOAdSUIF9QMl2l5Hf
        G/a5tI0o1Vkv4uQF1eXh08k=
X-Google-Smtp-Source: AMrXdXuHNLwKi8xWKTozMMZzYnETcsNN3hEIwBwD19VFIxtKaNulpVxuR8G0u7nnncfhnRzChZEApA==
X-Received: by 2002:aa7:9143:0:b0:580:cfbd:3fd3 with SMTP id 3-20020aa79143000000b00580cfbd3fd3mr76390862pfi.26.1673652257329;
        Fri, 13 Jan 2023 15:24:17 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id n125-20020a622783000000b00582cb9deb5asm14602446pfn.176.2023.01.13.15.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 15:24:16 -0800 (PST)
Message-ID: <92b98f45dcd65facac78133c6250d9d96ea1a25f.camel@gmail.com>
Subject: Re: [PATCH net-next 1/2] virtio_net: Fix short frame length check
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Parav Pandit <parav@nvidia.com>, mst@redhat.com,
        jasowang@redhat.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org
Date:   Fri, 13 Jan 2023 15:24:15 -0800
In-Reply-To: <20230113223619.162405-2-parav@nvidia.com>
References: <20230113223619.162405-1-parav@nvidia.com>
         <20230113223619.162405-2-parav@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-01-14 at 00:36 +0200, Parav Pandit wrote:
> A smallest Ethernet frame defined by IEEE 802.3 is 60 bytes without any
> preemble and CRC.
>=20
> Current code only checks for minimal 14 bytes of Ethernet header length.
> Correct it to consider the minimum Ethernet frame length.
>=20
> Fixes: 296f96fcfc16 ("Net driver using virtio")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> ---
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7723b2a49d8e..d45e140b6852 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1248,7 +1248,7 @@ static void receive_buf(struct virtnet_info *vi, st=
ruct receive_queue *rq,
>  	struct sk_buff *skb;
>  	struct virtio_net_hdr_mrg_rxbuf *hdr;
> =20
> -	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
> +	if (unlikely(len < vi->hdr_len + ETH_ZLEN)) {
>  		pr_debug("%s: short packet %i\n", dev->name, len);
>  		dev->stats.rx_length_errors++;
>  		if (vi->mergeable_rx_bufs) {

I'm not sure I agree with this change as packets are only 60B if they
have gone across the wire as they are usually padded out on the
transmit side. There may be cases where software routed packets may not
be 60B.

As such rather than changing out ETH_HLEN for ETH_ZLEN I wonder if we
should look at maybe making this a "<=3D" comparison instead since that
is the only case I can think of where the packet would end up being
entirely empty after eth_type_trans is called and we would be passing
an skb with length 0.
