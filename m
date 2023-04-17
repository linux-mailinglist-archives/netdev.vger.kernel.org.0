Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332886E3FA3
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 08:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjDQGVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 02:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjDQGVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 02:21:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D0A3593
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 23:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681712426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ePbMyRA1sPZRgCUtm4jF6vrpMcXUEcAn5cv4sWSGRdg=;
        b=HnFmpt8n9LNrWigutZzu/ISfmmZSYwMzT6SUZb7MXFtmZbVE2nQex6bi8ZRf+9dLGXkk7b
        FLZ+lapY69suM5oCVameST1+WBGAxG99+w3V+p8b/JijXDDH9uzBf72vLvN6jSXFH29pY+
        8Y32TVqQrVwxTJa0usvG/cvWtmBAepk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-XmzC21OKPbO1NJ4qOQ8k0g-1; Mon, 17 Apr 2023 02:20:24 -0400
X-MC-Unique: XmzC21OKPbO1NJ4qOQ8k0g-1
Received: by mail-qt1-f197.google.com with SMTP id 13-20020ac8570d000000b003e37d3e6de2so17432048qtw.16
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 23:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681712424; x=1684304424;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ePbMyRA1sPZRgCUtm4jF6vrpMcXUEcAn5cv4sWSGRdg=;
        b=ls2V/L5NE9m89luWawGbXtvA4bcsxvtgeKMW3scwTZgi7OIDce5J2bnVhkKDYS37al
         b3PIskpA5Np+EA+GXhXpQlahgiogs5wPWgjTZG9OXLsXwixrkSQQ0MXECEl0qaF1+ePf
         oNgqA3RO+XnSHLjcqlw96TEUSS895iNWhEr7n3v8VcT4+Hx+Ld2m3A69mYAOgf0GJ92E
         7FST3qGeucEFUq6ZUWe2kvop1Mb0YVvvp7blcku0Y+gpAoe7+wqpqfqwopVSwjW6FqIP
         tOU5L3WBJAtcvuOkhWNsfX4YWVH7JZoFazMrG5ZGtGu0S07Szao4PZLIqHdcr9OczW1k
         mrng==
X-Gm-Message-State: AAQBX9dUHA/Pe0BpokVia9ONtLX/9M60ZVYrU906RrBwLXtLowj5AV1+
        z8coq7R131CllpFj5XFPT0ZUZupyJQuplC/BOA1gzebkt0ekXCjxK2Rwk1kNYiOTZOeuBHpGzua
        2kYr9qkkX7EEQciKm
X-Received: by 2002:a05:6214:400e:b0:5ef:5503:d41c with SMTP id kd14-20020a056214400e00b005ef5503d41cmr13070241qvb.15.1681712424108;
        Sun, 16 Apr 2023 23:20:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350YGBvzLQl8TSywlbRHoWsuwzUmdZAtbC2GsJy/SU9rWuxjFVNqOx/mP7CdWEeGgZjqG0Nm5bg==
X-Received: by 2002:a05:6214:400e:b0:5ef:5503:d41c with SMTP id kd14-20020a056214400e00b005ef5503d41cmr13070223qvb.15.1681712423865;
        Sun, 16 Apr 2023 23:20:23 -0700 (PDT)
Received: from redhat.com ([185.199.103.251])
        by smtp.gmail.com with ESMTPSA id lx4-20020a0562145f0400b005ef42af7eb7sm2870554qvb.25.2023.04.16.23.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 23:20:23 -0700 (PDT)
Date:   Mon, 17 Apr 2023 02:20:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Message-ID: <20230417021725-mutt-send-email-mst@kernel.org>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
 <AM0PR04MB4723C6E99A217F51973710F5D49F9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230416164453-mutt-send-email-mst@kernel.org>
 <CACGkMEvFhVyWb5+ET_akPvnjUq04+ZbJC8o_GtNBWqSMGNum8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEvFhVyWb5+ET_akPvnjUq04+ZbJC8o_GtNBWqSMGNum8A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 11:24:16AM +0800, Jason Wang wrote:
> On Mon, Apr 17, 2023 at 4:45 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Sun, Apr 16, 2023 at 04:54:57PM +0000, Alvaro Karsz wrote:
> > > After further consideration, other virtio drivers need a minimum limit to the vring size too.
> > >
> > > Maybe this can be more general, for example a new virtio_driver callback that is called (if implemented) during virtio_dev_probe, before drv->probe.
> > >
> > > What do you think?
> > >
> > > Thanks,
> > > Alvaro
> >
> > Let's start with what you did here, when more than 2 drivers do it we'll
> > move it to core.
> 
> I wonder how hard it is to let virtio support small vring size?
> 
> Thanks

Actually, I think that all you need to do is disable NETIF_F_SG,
and things will work, no?
Alvaro, can you try?


> >
> > --
> > MST
> >

