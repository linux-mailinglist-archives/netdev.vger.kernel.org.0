Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CCE66A704
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 00:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjAMX0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 18:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjAMXZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 18:25:59 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6CC6719A
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:25:58 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id g23so9342287plq.12
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7LC7fNege2OL4xDfFuGevF0Ei2VV6+IVloPCGY2mC84=;
        b=MQSckLaP9MDMihN8IVNuJQUpTW1vJIXHEx+t/qCBH6J5ilCMUBM1zf08VHdoX+tKZW
         9HIO1MBvdApwghKPOFszI9JeacZ40ycHgcaWdFyF8OW/YQLSfSEZ55B4kUK60aoCVcxk
         r0QF5AfNJsYBYVyTQ38p/3ckAwJ+CuCsWHWebx8AJ8BPRSdesilMngzYYguQ1bG4Whwi
         crCzTDVEFUtgC8oTVPKClbYg/+k0TgEnx7oHREH6wK/o/NPqFZEHNiOYTDjHfy3JX6Fs
         E80uDnhvZsrVh8N2wRyqp940p2SIEaVgb4/SMxban2vu063kYCx0iB4Zw/7YtKNKD9GM
         DP7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7LC7fNege2OL4xDfFuGevF0Ei2VV6+IVloPCGY2mC84=;
        b=VKU9wApGb3Zp1SW1h30QyXEpXSykZ1oSpzPWrIULFVVGtkgec5/KeHNqbvVjYWS69k
         y83YhWOtytWiGr/MecugchE/ZR/BBxDh1IG4WX4s3R35CBqd8UB0FXfH3VwllmDttce0
         2zRltlfSz1uFSgdqgzVg8ldLG68lFPrTboOxAHWllAOV+IH09nuKLgbMEVd67tH9QNv3
         Nr1o0otWxS9GH+O7VwqmWRIBr/HHjmW4+eX0OKV64rgpqo9bfs3wZ2Oh3l7U5e4tx0bs
         Bj9f/AyYcFY1p70gMJ1tOXQbgArOr/Zpj4sNhK9+RcQES36fCaLdLUHWfnfGQyXcfICm
         4BEg==
X-Gm-Message-State: AFqh2kq1j8xpugZdB13xlpBfPI3F23FYANDLu2xnC14OYsgu05mv6FNW
        pYb7HvjmiGKwPKlmRK19eg8=
X-Google-Smtp-Source: AMrXdXvMg/bqbsdgPLqa+5sgVJpVn7AqukKkKmjeNH7wQlJ/TWCYDzQm7rVRVLMvJ2a1cv1qO9fXeg==
X-Received: by 2002:a17:90b:280d:b0:21a:1f5f:e798 with SMTP id qb13-20020a17090b280d00b0021a1f5fe798mr85938652pjb.48.1673652358133;
        Fri, 13 Jan 2023 15:25:58 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id oj11-20020a17090b4d8b00b001fde655225fsm4396304pjb.2.2023.01.13.15.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 15:25:57 -0800 (PST)
Message-ID: <01a95e4ac97cba9a2f656e5e4e345640d65a5005.camel@gmail.com>
Subject: Re: [PATCH net-next 2/2] virtio_net: Reuse buffer free function
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Parav Pandit <parav@nvidia.com>, mst@redhat.com,
        jasowang@redhat.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org
Date:   Fri, 13 Jan 2023 15:25:55 -0800
In-Reply-To: <20230113223619.162405-3-parav@nvidia.com>
References: <20230113223619.162405-1-parav@nvidia.com>
         <20230113223619.162405-3-parav@nvidia.com>
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
> virtnet_rq_free_unused_buf() helper function to free the buffer
> already exists. Avoid code duplication by reusing existing function.
>=20
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> ---
>  drivers/net/virtio_net.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index d45e140b6852..c1faaf11fbcd 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1251,13 +1251,7 @@ static void receive_buf(struct virtnet_info *vi, s=
truct receive_queue *rq,
>  	if (unlikely(len < vi->hdr_len + ETH_ZLEN)) {
>  		pr_debug("%s: short packet %i\n", dev->name, len);
>  		dev->stats.rx_length_errors++;
> -		if (vi->mergeable_rx_bufs) {
> -			put_page(virt_to_head_page(buf));
> -		} else if (vi->big_packets) {
> -			give_pages(rq, buf);
> -		} else {
> -			put_page(virt_to_head_page(buf));
> -		}
> +		virtnet_rq_free_unused_buf(rq->vq, buf);
>  		return;
>  	}
> =20

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
