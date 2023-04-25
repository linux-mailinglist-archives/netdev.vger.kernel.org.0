Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A2F6EDE5C
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbjDYImU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbjDYIlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:41:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D277ECE
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682411895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=12yPNwee6eKmLgy6pNQQ5971cnoVK8ZLgf7UFS2TwrU=;
        b=WHBg8ownhxkVWBryAN78Jj852TNERC5/EiafoxlrfutKqjE/smzJX67BnZYWFQ94YoYcwZ
        4S5VKO6TU1lhTJB2sT8uI/NAq57GVzvSLD7npgocx2UFTnHx08od4BSrAQs1Uxw/gj7M9g
        ctk9TK9D4YuZw+ig6dvfJCFzDLyk3AY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-nNOO69qsMeGuOd6_gsK2iw-1; Tue, 25 Apr 2023 04:35:04 -0400
X-MC-Unique: nNOO69qsMeGuOd6_gsK2iw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-2fbb99cb2easo1725424f8f.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411703; x=1685003703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=12yPNwee6eKmLgy6pNQQ5971cnoVK8ZLgf7UFS2TwrU=;
        b=aVT9ctFVR3Ak+wBf0vLB+DMnsohVsi8wA21vPWf0Dm7ggIx2tCUf1IAQDWQlKK34hS
         gKHD96ENjN172qOC317sUY73Y1mhsZgYMXE8Sd/4zeUgntPB9gftH+hY1Mhxc/Ch9mPK
         jcfgCKgpkmxSkqbyXx9QlEHI+G2dFVu6YBC4MyC1KvZcDW6pzj8pNYwO6do3qKjkoFsf
         /58RYWII5V9ugtoILqHxww4MKJ9d+60LXNmAJAeTPo5UFfJJXi0UaAdvCZCPx9FXCXvk
         Zj3aP7paP8LMvZU8Qdwos8tvjRcrgp80U7uki7zzwGNWmhcy/z1/J0AMjHGrSNrDN9T1
         6l+Q==
X-Gm-Message-State: AAQBX9fXORalu3mNazGSOCFGjS61IQqeD4uVVYeVo+1wlOdIzALxqMUU
        j4E0lN15rV2ppKE+/YowSx+o9EUyXmm6lp5tBB3mXq0P4xNtlo1049oJc9RP1qaloXW2ZKHpr8e
        oLTgDbH6kI6J5gZEAmP0fphPd
X-Received: by 2002:adf:f24c:0:b0:2f4:6574:5a93 with SMTP id b12-20020adff24c000000b002f465745a93mr12516601wrp.4.1682411703056;
        Tue, 25 Apr 2023 01:35:03 -0700 (PDT)
X-Google-Smtp-Source: AKy350YzvhAFxQchdtafHwvmXBchE/YcmkSUeMa1HoC1zk1lBrrRDtHRpjgJc3aGfUSP7c/RWHiheA==
X-Received: by 2002:adf:f24c:0:b0:2f4:6574:5a93 with SMTP id b12-20020adff24c000000b002f465745a93mr12516582wrp.4.1682411702685;
        Tue, 25 Apr 2023 01:35:02 -0700 (PDT)
Received: from redhat.com ([2.55.61.39])
        by smtp.gmail.com with ESMTPSA id f4-20020a0560001b0400b002ffbf2213d4sm12594526wrz.75.2023.04.25.01.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:35:02 -0700 (PDT)
Date:   Tue, 25 Apr 2023 04:34:58 -0400
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
Message-ID: <20230425041352-mutt-send-email-mst@kernel.org>
References: <20230417051816-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237705695AFD873DEE4530D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417073830-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417075645-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA90465186B5A8A5C001D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423031308-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47233B680283E892C45430BCD4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423065132-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237D46ADE7954289025B66D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB47237D46ADE7954289025B66D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 12:28:49PM +0000, Alvaro Karsz wrote:
> 
> > > > The rest of stuff can probably just be moved to after find_vqs without
> > > > much pain.
> > > >
> > > Actually, I think that with a little bit of pain :)
> > > If we use small vrings and a GRO feature bit is set, Linux will need to allocate 64KB of continuous memory for every receive descriptor..
> > 
> > Oh right. Hmm. Well this is same as big packets though, isn't it?
> > 
> 
> Well, when VIRTIO_NET_F_MRG_RXBUF is not negotiated and one of the GRO features is, the receive buffers are page size buffers chained together to form a 64K buffer.
> In this case, do all the chained descriptors actually point to a single block of continuous memory, or is it possible for the descriptors to point to pages spread all over?
> 
> > 
> > > Instead of failing probe if GRO/CVQ are set, can we just reset the device if we discover small vrings and start over?
> > > Can we remember that this device uses small vrings, and then just avoid negotiating the features that we cannot support?
> > 
> > 
> > We technically can of course. I am just not sure supporting CVQ with just 1 s/g entry will
> > ever be viable.
> 
> Even if we won't support 1 s/g entry, do we want to fail probe in such cases?
> We could just disable the CVQ feature (with reset, as suggested before).
> I'm not saying that we should, just raising the option.
> 

So, let's add some funky flags in virtio device to block out
features, have core compare these before and after,
detect change, reset and retry?


-- 
MST

