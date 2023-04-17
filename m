Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9A96E4062
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjDQHLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDQHL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:11:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1845940C7
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 00:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681715441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=khZ23ut9tSZy0CNwgidrOfEO75uvb5JIpDX8+Rd9+Ts=;
        b=igckol3oPJ1VnIf/3wVQ9G5qWEx1pRoUIpyV62faUmgaOL/g5o08B4tFH+cSLlNi731a21
        AU4GDdXxlw7qTp9vxO6s4NKvvwVgqsn24wzjvYjc4mVB8MkQ+uGN5/afIYTtXHPLSOHjGb
        bCJ33jGlcAGDlcjrCk7vCvh6UP/otDQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-Y5fv2-0kOjio6x3FTYGciQ-1; Mon, 17 Apr 2023 03:10:38 -0400
X-MC-Unique: Y5fv2-0kOjio6x3FTYGciQ-1
Received: by mail-qv1-f70.google.com with SMTP id n12-20020a0cbe8c000000b005e79f8d1417so12803166qvi.13
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 00:10:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681715437; x=1684307437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=khZ23ut9tSZy0CNwgidrOfEO75uvb5JIpDX8+Rd9+Ts=;
        b=JP8AmFQp1DY0t6JR3kM623SK8jDFofomhvlWVP3kCHef17ipTWBWi7fFo0EM3lCH0j
         6gaxlzvBCpqEIes4XFrFKQZDZAYuQ1f0pMdwVi44FohfGOfxFYtaTB4KGaKUuiuV/eMd
         KjM9Tms0UW87v0bIY0PXN+kMb7chJltgXyVfNtteHATZp9K5DtFlji3y7e9lRrrj8acu
         iDhfhEjnvsh14kUwuZLSjf00opBBeL5tN5v3EY4KxAFL+460yR3jNBjS3X7XP9RYKgXd
         vG8bveY80bt691NYAG5ppauUuaurRmn0ZelbY1F+YkgfIA6Tfwl4Sc2Drxt447lXo2R4
         S7kg==
X-Gm-Message-State: AAQBX9er2Un5AqyzQIm0G0CibjBgNyTDpb/Lbn+RL6I+t2U54M6YtQNf
        5DNpwoPtSUypEZ4VEqX+CUt8dQ3aIV48YwW/OZ5Q1SkjcpqYv4zYdpjY1KSEzMaWscE4USmgkBu
        bFMUyc1eBctML6iKW
X-Received: by 2002:ac8:5705:0:b0:3e1:18cc:7fb0 with SMTP id 5-20020ac85705000000b003e118cc7fb0mr19873674qtw.41.1681715437547;
        Mon, 17 Apr 2023 00:10:37 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZZNAN+4+EZys8WaUUUa9OgEdVXOuEUlcNT1Oqqqd2RWhLnDZZTLPDbDA7IGY19/AulMU52SA==
X-Received: by 2002:ac8:5705:0:b0:3e1:18cc:7fb0 with SMTP id 5-20020ac85705000000b003e118cc7fb0mr19873659qtw.41.1681715437280;
        Mon, 17 Apr 2023 00:10:37 -0700 (PDT)
Received: from redhat.com ([185.199.103.251])
        by smtp.gmail.com with ESMTPSA id p15-20020a05622a00cf00b003ecf475286csm1559676qtw.39.2023.04.17.00.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 00:10:36 -0700 (PDT)
Date:   Mon, 17 Apr 2023 03:10:29 -0400
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
Message-ID: <20230417030713-mutt-send-email-mst@kernel.org>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
 <AM0PR04MB4723C6E99A217F51973710F5D49F9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230416164453-mutt-send-email-mst@kernel.org>
 <CACGkMEvFhVyWb5+ET_akPvnjUq04+ZbJC8o_GtNBWqSMGNum8A@mail.gmail.com>
 <20230417021725-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723B8489F8F9AE547393697D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417023911-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237BFB8BB3A3606CE6A408D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB47237BFB8BB3A3606CE6A408D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 07:03:52AM +0000, Alvaro Karsz wrote:
> > > > Actually, I think that all you need to do is disable NETIF_F_SG,
> > > > and things will work, no?
> > >
> > > I think that this is not so simple, if I understand correctly, by disabling NETIF_F_SG we will never receive a chained skbs to transmit, but we still have more functionality to address, for example:
> > > * The TX timeouts.
> > 
> > I don't get it. With a linear skb we can transmit it as long as there's
> > space for 2 entries in the vq: header and data. What's the source of the
> > timeouts?
> > 
> 
> I'm not saying that this is not possible, I meant that we need more changes to virtio-net.
> The source of the timeouts is from the current implementation of virtnet_poll_tx.
> 
> if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
> 	netif_tx_wake_queue(txq);

Oh right. So this should check NETIF_F_SG then.
BTW both ring size and s/g can be tweaked by ethtool, also
needs handling.


> 
> > > * Guest GSO/big MTU (without VIRTIO_NET_F_MRG_RXBUF?), we can't chain page size buffers anymore.
> > 
> > I think we can.  mergeable_min_buf_len will just be large.
> > 
> 
> I meant that we can't just by clearing NETIF_F_SG, we'll need to change virtio-net a little bit more, for example, the virtnet_set_big_packets function.
> 

Right - for RX, big_packets_num_skbfrags ignores ring size and that's
probably a bug if mtu is very large.

-- 
MST

