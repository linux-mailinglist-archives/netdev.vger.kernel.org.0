Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDEE6ADB20
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjCGJzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjCGJym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:54:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812F638038
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 01:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678182828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ggd3+ao+WeqD8liBzoZLjCqGeA5JT3k3Ek928KuXPYA=;
        b=RzP6qKsPUHGTAI4LHFDZ9vq85WStAi6SFTqna5PqZDqVtBHNuZQtiZGIqZePJWlqwMGm+h
        WeEoZdS41lfdfbKn+EOhkRs9IgN4/brqkFZi8E7Y1SbQ4w8hRV4bs8YJW4oGaLE2JNB8rh
        MxhCB0RFu5wtnPoDDtUEAWXyX8sz//U=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-UuRuN9EWNOe9aX5877Pjhg-1; Tue, 07 Mar 2023 04:53:47 -0500
X-MC-Unique: UuRuN9EWNOe9aX5877Pjhg-1
Received: by mail-qv1-f69.google.com with SMTP id u18-20020a0cec92000000b0056ea549d728so7167799qvo.10
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 01:53:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678182827;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ggd3+ao+WeqD8liBzoZLjCqGeA5JT3k3Ek928KuXPYA=;
        b=Tg7qjxQi6wCQvqIA6zRm+pXs3bSnKF/tvvKrLwpZA8UVKrA3Yx8HzP+oQ5uJwGES/b
         gg9gioPAeSl2vOI6FuqmrAGHePT9W3dAZqRLZvR88+2jwdS+E9yEYnAjm24uaBfQ4O7B
         tnghLNt8lvmW/SFfPuV2R+CbG+LWOMOGzWmTbFCKV/yOfPK4IMJmD8fMUFbKe2hDKHTX
         S1qbVB5eIAqmrXnGob0eroy52Oqz5wSAi2B7ydiDfSwqABiZcD8ssOfExbWvd2VZ4zTC
         /FezviYRujxVDbsshcK6tXPZnglGYZrNrvZaSRzQzfqs8g8x667lFI1R7Tdb3KKlO8Eb
         wRRg==
X-Gm-Message-State: AO0yUKVL+M7frfwC3A0z+bygsr9u0v+b9FGPneTU2a/daaf8VEy0n6hr
        WI+Qj/jYReDzFWwfgaLvzuRpRRmoDxAJlnqaNJso76GLwUFdmDtllO4JmtrZyeFYGstA8ru+EDO
        ubHZp6KSbjbTFA2l8
X-Received: by 2002:a05:622a:1443:b0:3bf:cf77:a861 with SMTP id v3-20020a05622a144300b003bfcf77a861mr26042689qtx.4.1678182826881;
        Tue, 07 Mar 2023 01:53:46 -0800 (PST)
X-Google-Smtp-Source: AK7set/Ht7SnNixqcSsXD0GLyGOfUcXl++SZRRVs2S7WoQNC08oY0HQ25bhDHtpsc4xRCT0+4cdvAg==
X-Received: by 2002:a05:622a:1443:b0:3bf:cf77:a861 with SMTP id v3-20020a05622a144300b003bfcf77a861mr26042676qtx.4.1678182826522;
        Tue, 07 Mar 2023 01:53:46 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-28.dyn.eolo.it. [146.241.121.28])
        by smtp.gmail.com with ESMTPSA id 127-20020a370b85000000b007425ef4cbc2sm9256355qkl.100.2023.03.07.01.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 01:53:46 -0800 (PST)
Message-ID: <27a06a7d79fef3446ae1167612808a2af09922be.camel@redhat.com>
Subject: Re: [PATCH net 0/2] add checking sq is full inside xdp xmit
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Date:   Tue, 07 Mar 2023 10:53:41 +0100
In-Reply-To: <1678153770.8281553-2-xuanzhuo@linux.alibaba.com>
References: <20230306041535.73319-1-xuanzhuo@linux.alibaba.com>
         <20230306125742-mutt-send-email-mst@kernel.org>
         <1678153770.8281553-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
On Tue, 2023-03-07 at 09:49 +0800, Xuan Zhuo wrote:
> On Mon, 6 Mar 2023 12:58:22 -0500, "Michael S. Tsirkin" <mst@redhat.com> =
wrote:
> > On Mon, Mar 06, 2023 at 12:15:33PM +0800, Xuan Zhuo wrote:
> > > If the queue of xdp xmit is not an independent queue, then when the x=
dp
> > > xmit used all the desc, the xmit from the __dev_queue_xmit() may enco=
unter
> > > the following error.
> > >=20
> > > net ens4: Unexpected TXQ (0) queue failure: -28
> > >=20
> > > This patch adds a check whether sq is full in XDP Xmit.
> > >=20
> > > Thanks.
> >=20
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> >=20
> > needed for stable?
>=20
> Yes i think.

Could you please re-post including a suitable 'Fixes' tag? That would
address stable, too. Additionally you could rename check_sq_full() in
patch 1, perhaps 'check_disable_sq_full()' would do.

You can retain the already collected tags.

Thanks!

Paolo

