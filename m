Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA486E46CA
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjDQLud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjDQLuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:50:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2826B659D
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681732020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L56R2gu/x3s7dqlmSUQPJXypT34J4O84wjA7Kd+V4c4=;
        b=ChJKp5Lw+LbWFAZ/6DDp0nYWCdez1jSvXx3ZqOILmEdTU3vMUMWatJXtJ7W3WucYsqoWkO
        j04nZ5/On3hY/9BdoiW2QPszvQfglofenz6SN7lFJbWgWFBfb9z6/VYKJLo1Ugtq2KEvTo
        3/ttR5GfV99EpLiqSHZZg6cEf8LnOCg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-hMr5gVitMzeZT4QJcouzfA-1; Mon, 17 Apr 2023 07:40:25 -0400
X-MC-Unique: hMr5gVitMzeZT4QJcouzfA-1
Received: by mail-wm1-f70.google.com with SMTP id m4-20020a05600c3b0400b003f0968719a7so9205013wms.2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:40:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681731623; x=1684323623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L56R2gu/x3s7dqlmSUQPJXypT34J4O84wjA7Kd+V4c4=;
        b=gHlMOWccMeemeH6RvGj92elVsr7YwI+Esc/6/spijEB101M42MOpZOxRE144dig/Sp
         Wq45MtJasxcg/alKzBdzd9MB0c+b/G8VydhwFsh+rvy0mU2aGJBw0y6LMkP/uiaaXgXr
         rdlMQNLlU8gVI1eg2UgUyp5v0gLBwWrqjkJM0CqQShNB7zwA9/8kCiQAufM7O73emL8+
         +iJH4i3Ai1jRD4GotFb7cp3YYAQFCyHQp6eBGAaIwgWmoL6ogq19NT8H9aVMtDN4U7za
         uLoQnSU1lEqBJEA9BzmA/2ITy46PXf8RWV6RIeNc5roPpKkIX672jtybLMBFsE3eV/gz
         i8eQ==
X-Gm-Message-State: AAQBX9etIdk2Q0lY0xasPzNVAdPuZWogvMDGxyhgs3LVUFaMrWOfB8Kg
        uIdn+QXO+ElKBEucaDi8j6qRPdqyel6WYw/sDlsIBquUiQR+YzFxUbsBWY3kkPENCGBPQk7suS7
        wBmpTVgXcOAwOx1MF5A5nIx61MIs=
X-Received: by 2002:a7b:cc94:0:b0:3f0:5beb:6f0 with SMTP id p20-20020a7bcc94000000b003f05beb06f0mr10675205wma.18.1681731623565;
        Mon, 17 Apr 2023 04:40:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350bzdruND4QIBAEvHw/OOARmMTC+ApbrrhIRUF7EKyLK+57bgrdl2Y6bv5uzN2rwe1n5p+gkUg==
X-Received: by 2002:a7b:cc94:0:b0:3f0:5beb:6f0 with SMTP id p20-20020a7bcc94000000b003f05beb06f0mr10675192wma.18.1681731623309;
        Mon, 17 Apr 2023 04:40:23 -0700 (PDT)
Received: from redhat.com ([2.52.136.129])
        by smtp.gmail.com with ESMTPSA id y25-20020a05600c365900b003f0aeac475esm9692979wmq.44.2023.04.17.04.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 04:40:22 -0700 (PDT)
Date:   Mon, 17 Apr 2023 07:40:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Message-ID: <20230417073830-mutt-send-email-mst@kernel.org>
References: <20230416164453-mutt-send-email-mst@kernel.org>
 <CACGkMEvFhVyWb5+ET_akPvnjUq04+ZbJC8o_GtNBWqSMGNum8A@mail.gmail.com>
 <20230417021725-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723B8489F8F9AE547393697D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417023911-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237BFB8BB3A3606CE6A408D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417030713-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723F3E6AE381AEC36D1AEFED49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417051816-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237705695AFD873DEE4530D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB47237705695AFD873DEE4530D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 10:04:56AM +0000, Alvaro Karsz wrote:
> > > So, what do you think, we should fix virtio-net to work with smaller rings? we should fail probe?
> > >
> > > I think that since this never came up until now, there is no big demand to such small rings.
> > 
> > The worry is that once we start failing probe there's just a tiny chance
> > hosts begin to rely on us failing probe then we won't be able to fix it.
> > So it depends on the size of the patch I think. So far it seems small enough
> > that wasting code on failing probe isn't worth it.
> > 
> 
> I see your point.
> Regardless, we'll need to fail probe in some cases.
> ring size of 1 for example (if I'm not mistaken)

Hmm. We can make it work if we increase hard header size, then
there will always be room for vnet header.

> control vq even needs a bigger ring.

Why does it?

> Maybe we can fix virtnet to allow smaller rings + fail probe in some cases, all in the same patch/patchset.

If we can't make it work then yes.

-- 
MST

