Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974AA6EE1E8
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbjDYMcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbjDYMcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:32:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC80CE43
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682425922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xUCCLfKIJcIMQQC1+iJEFgXpJl2oC+XHJLW7QTm0PdU=;
        b=PlY3ZoIZ0wjvS+r+XfO90W9C6u/2g7j1SM7fg6BubFo1MPtgluBhjTYYBI/B2tcsdk/0Qm
        P3MU1bSNztBLWu+edwuda8yVEFhMDreoEL31i+LApP/++ZDpjSH989IvGxdBTza+55f4f5
        ACfxTjiNz4dRHe412C5ufS1q9BJ0yWY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-u7AVC1CLPACahDZuN43T_A-1; Tue, 25 Apr 2023 08:32:00 -0400
X-MC-Unique: u7AVC1CLPACahDZuN43T_A-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-2fbb99cb244so3208531f8f.3
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:32:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682425919; x=1685017919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xUCCLfKIJcIMQQC1+iJEFgXpJl2oC+XHJLW7QTm0PdU=;
        b=fHD0yH5yldmOeWjWnDRNQDIBDSBsclN9omSKQL+BF994dvNN96x0c+uq3LtjmfqK1J
         o3iK317pQDQAaVWaDoovPo/k2R04KBPOV0LopM1EmH6DRtE9v8M9VyWH2h0Yf07y41Pm
         6ymxUFhghvoxsS2zYOBl83xiA2PhJ7b4OoRtqR/gcnKrR8zKA7YvdT1hcWkDX/vklMGz
         8PHdf8EaMsDXMSuK07Hgq+7ISSl2uYE8ywOJghfVBMcBmXz6/y84loVtvkaFvh9VXERF
         vRzYj7v52A/2XJl6lCM0MBnNb6Ldxn/DcLPUK5eP7yfjU3jYsnwx5yXq+RskK4UGgvLw
         ED0Q==
X-Gm-Message-State: AAQBX9dSw1b5MyJw1juzp52TcpP6z9kYbG5Wjd8V4HfwgckeY+wewupd
        zUDuYsWEA1/KWEpJ+9xLB+ouzbJokitmBtPyU1/JjMKGNjyQzdtEGJ6sPoCMWtlIKBXXSu54PUR
        Odr4vmhyKuxDvDLqtdudTkqbF
X-Received: by 2002:adf:ffcf:0:b0:301:8551:446a with SMTP id x15-20020adfffcf000000b003018551446amr12600270wrs.2.1682425918925;
        Tue, 25 Apr 2023 05:31:58 -0700 (PDT)
X-Google-Smtp-Source: AKy350YNPM6rmdz9nqud0Gs0uKp5JlWWQ13dR/vmTBC10HPYXJvjvSupNGyK5SYEMtOckP8U65WVkg==
X-Received: by 2002:adf:ffcf:0:b0:301:8551:446a with SMTP id x15-20020adfffcf000000b003018551446amr12600255wrs.2.1682425918573;
        Tue, 25 Apr 2023 05:31:58 -0700 (PDT)
Received: from redhat.com ([2.55.17.255])
        by smtp.gmail.com with ESMTPSA id a15-20020adfdd0f000000b003048d07f9absm1411810wrm.70.2023.04.25.05.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 05:31:57 -0700 (PDT)
Date:   Tue, 25 Apr 2023 08:31:54 -0400
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
Message-ID: <20230425082150-mutt-send-email-mst@kernel.org>
References: <20230417073830-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417075645-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA90465186B5A8A5C001D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423031308-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47233B680283E892C45430BCD4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423065132-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237D46ADE7954289025B66D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230425041352-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723CE2A9B8BFA7963A66A98D4649@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723CE2A9B8BFA7963A66A98D4649@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 09:41:35AM +0000, Alvaro Karsz wrote:
> > So, let's add some funky flags in virtio device to block out
> > features, have core compare these before and after,
> > detect change, reset and retry?
> 
> In the virtnet case, we'll decide which features to block based on the ring size.
> 2 < ring < MAX_FRAGS + 2  -> BLOCK GRO + MRG_RXBUF
> ring < 2  -> BLOCK GRO + MRG_RXBUF + CTRL_VQ

why MRG_RXBUF? what does it matter?

> So we'll need a new virtio callback instead of flags.
> Furthermore, other virtio drivers may decide which features to block based on parameters different than ring size (I don't have a good example at the moment).
> So maybe we should leave it to the driver to handle (during probe), and offer a virtio core function to re-negotiate the features?
> 
> In the solution I'm working on, I expose a new virtio core function that resets the device and renegotiates the received features.
> + A new virtio_config_ops callback peek_vqs_len to peek at the VQ lengths before calling find_vqs. (The callback must be called after the features negotiation)
> 
> So, the flow is something like:
> 
> * Super early in virtnet probe, we peek at the VQ lengths and decide if we are 
>    using small vrings, if so, we reset and renegotiate the features.

Using which APIs? What does peek_vqs_len do and why does it matter that
it is super early?

> * We continue normally and create the VQs.
> * We check if the created rings are small.
>    If they are and some blocked features were negotiated anyway (may occur if 
>    the re-negotiation fails, or if the transport has no implementation for 
>    peek_vqs_len), we fail probe.
>    If the ring is small and the features are ok, we mark the virtnet device as 
>    vring_small and fixup some variables.
>  
> 
> peek_vqs_len is needed because we must know the VQ length before calling init_vqs.
> 
> During virtnet_find_vqs we check the following:
> vi->has_cvq
> vi->big_packets
> vi->mergeable_rx_bufs
> 
> But these will change if the ring is small..
> 
> (Of course, another solution will be to re-negotiate features after init_vqs, but this will make a big mess, tons of things to clean and reconfigure)
> 
> 
> The 2 < ring < MAX_FRAGS + 2 part is ready, I have tested a few cases and it is working.
> 
> I'm considering splitting the effort into 2 series.
> A 2 < ring < MAX_FRAGS + 2  series, and a follow up series with the ring < 2 case.
> 
> I'm also thinking about sending the first series as an RFC soon, so it will be more broadly tested.
> 
> What do you think?

Lots of work spilling over to transports.

And I especially don't like that it slows down boot on good path.

I have the following idea:
- add a blocked features value in virtio_device
- before calling probe, core saves blocked features
- if probe fails, checks blocked features.
  if any were added, reset, negotiate all features
  except blocked ones and do the validate/probe dance again


This will mean mostly no changes to drivers: just check condition,
block feature and fail probe.


-- 
MST

