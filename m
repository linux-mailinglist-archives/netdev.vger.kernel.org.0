Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1394C6E3FFA
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 08:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjDQGmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 02:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDQGmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 02:42:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32977268F
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 23:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681713673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OxKMHMF5ij1bxNLeFZRcL6SeBcLJINT9bFcDHFvcGBQ=;
        b=YuETFynOezCctj1CJlHYhFR+u8Gtev3GqeiR4y5+NBR8qP9E3DPA4HBtcAIyNzhvt4sDLc
        kVVfYzhcOUvBNMtBVOY2BcM6VhjQ7bc3f3xvBEmtceifg98HEa3AKCm6ygU2JY+y0VuO19
        roQOQ21fzHzFbHc1bga78lJrY93CVNk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-5cKN0QHTOHybpL5XsSO3YQ-1; Mon, 17 Apr 2023 02:41:12 -0400
X-MC-Unique: 5cKN0QHTOHybpL5XsSO3YQ-1
Received: by mail-qv1-f70.google.com with SMTP id b5-20020a0cbf45000000b005e7e2c57182so12378828qvj.22
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 23:41:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681713671; x=1684305671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OxKMHMF5ij1bxNLeFZRcL6SeBcLJINT9bFcDHFvcGBQ=;
        b=MOPBP0OBfQjh/QLTAEBvHwB2sljYJt0yjdN1wG052OeCfmqsv8CSFJzKG+R0G7deo7
         S7AHj6FIH4nm2/+wZNsCfLWgPsphfz7FiQXgO6RzAuU24ymsB0lCDB96giA/NeLmdvlE
         0k2meJbYlR3sQolZBNlbuI6UhzvixrX3kpIRtzj5xklo80vCJMkWks4oOFzjMhJ1zz3m
         k4quaAxJEz/kquwc0FEelmXOKy7wp4PmK3NIj70EZWaB4rbhdQLsMIcmTNTdv3AVrrhn
         5Fw/y1j3xTo+7mdchkJQONxwXtzB6QRqKU99/H5wyeP0fH5wwr9GuRiblQvX7ORW/rck
         Fq0g==
X-Gm-Message-State: AAQBX9fmGwcvQvk/EzBksspSRN78tgqJxgQPn6eoalPnnT92AlustywX
        UxG4oeQ6ZgM1JmbCqWRRBcdG8zQ38RJ7brq/5O7NC1bUDWBrhbco+WXDSyj8ICte1x/F2JkWGcf
        Cqc+UdsTJR1RZmYEJ
X-Received: by 2002:a05:622a:144:b0:3e3:9036:8d7b with SMTP id v4-20020a05622a014400b003e390368d7bmr23144625qtw.24.1681713671547;
        Sun, 16 Apr 2023 23:41:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350awUisy2QmOytI/7wHAUSKfUVvRV0PC8LxBgH9zz1azFDxXLfpwgedyZCjCtr2bsDRdI6Gagw==
X-Received: by 2002:a05:622a:144:b0:3e3:9036:8d7b with SMTP id v4-20020a05622a014400b003e390368d7bmr23144611qtw.24.1681713671291;
        Sun, 16 Apr 2023 23:41:11 -0700 (PDT)
Received: from redhat.com ([185.199.103.251])
        by smtp.gmail.com with ESMTPSA id bi8-20020a05620a318800b007456b51ee13sm1898249qkb.16.2023.04.16.23.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 23:41:10 -0700 (PDT)
Date:   Mon, 17 Apr 2023 02:41:04 -0400
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
Message-ID: <20230417023911-mutt-send-email-mst@kernel.org>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
 <AM0PR04MB4723C6E99A217F51973710F5D49F9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230416164453-mutt-send-email-mst@kernel.org>
 <CACGkMEvFhVyWb5+ET_akPvnjUq04+ZbJC8o_GtNBWqSMGNum8A@mail.gmail.com>
 <20230417021725-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723B8489F8F9AE547393697D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723B8489F8F9AE547393697D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 06:38:43AM +0000, Alvaro Karsz wrote:
> > Actually, I think that all you need to do is disable NETIF_F_SG,
> > and things will work, no?
> 
> I think that this is not so simple, if I understand correctly, by disabling NETIF_F_SG we will never receive a chained skbs to transmit, but we still have more functionality to address, for example:
> * The TX timeouts.

I don't get it. With a linear skb we can transmit it as long as there's
space for 2 entries in the vq: header and data. What's the source of the
timeouts?

> * Guest GSO/big MTU (without VIRTIO_NET_F_MRG_RXBUF?), we can't chain page size buffers anymore.

I think we can.  mergeable_min_buf_len will just be large.


> > Alvaro, can you try?
> 
> It won't matter at the moment, we'll get TX timeout after the first tx packet, we need to address this part as well.

