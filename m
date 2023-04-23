Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1416EC231
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 22:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjDWUSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 16:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDWUSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 16:18:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B24E70
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 13:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682281062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b5ejvIIx/RJ7eYanc2DeN6LKkOul5lY8GnPOGLq5m+0=;
        b=dkJQsWm5kU8xdjiueJcB1na8+LovmB6bKDobXr5eDBLspDyYXmYzgKgpZNC8Ivfgf5LC7J
        KNw+JpcGqrtcsSEvTwmaOkMbve9YpkZwTKQr77CsGUFZL0Dah5RZSMh+xC43lZbepF1iYj
        rQr2wDb85DCOU+z+087iBJ9b53eOnwc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-iSrVg3u5PE6Pa697aXWjvw-1; Sun, 23 Apr 2023 16:17:40 -0400
X-MC-Unique: iSrVg3u5PE6Pa697aXWjvw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f21e35dc08so1978555e9.2
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 13:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682281059; x=1684873059;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5ejvIIx/RJ7eYanc2DeN6LKkOul5lY8GnPOGLq5m+0=;
        b=XP4OvxbG/FmPhGoLioH8ZaARDRyC5piP8EFOCA9qMpXXV0STvqCv3JughkcvTV9Wfi
         ZHsg0SkrLS7AwKdYeLxcpkeL2JflXuqfZrCJ/yeL8WfhaRJ/7We7LG5nQI7Tb2pPGx/5
         tWyYqeom725pKJu+D/L/PYG2Hq3XIWKR6kIfYeWuxdIuAc3z3RPg0QoLLNS3kjasNVmf
         raSW0goIyedbXSAwaiz/vGdQHwMKWrngJgGyY4c8bQ5PCPfmQUGe5kK4rxTIbGi+7FWD
         cePSdWpiAlzlxCOJEhWWyLjh8SRRrjyI2pMueTnxksmo2c+CNt9dWwNEK3Wp9n8xYUH7
         CwGQ==
X-Gm-Message-State: AAQBX9eG1lFcNKNdibpVlYMk4TykONNqBMQW6dkjHwmw4jQ+pvJSxdHu
        8PHj3Nwitv+QbCH+sTDJvCLAj1v7ZVEF8Ct/NO8Nb5Zs45RMybVVnJZzrXQmnm8LutSLv9BFLb1
        xKaw1niuUndpfjZyg
X-Received: by 2002:a7b:c008:0:b0:3f1:7440:f21d with SMTP id c8-20020a7bc008000000b003f17440f21dmr5959106wmb.33.1682281059807;
        Sun, 23 Apr 2023 13:17:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZVUD7fuAvXZZNUn5Xb6tdyv5ONlZ2mzUgnHxdl0RaH2ytQnY0R7FH9hzI+EcGWub/tnAP+6A==
X-Received: by 2002:a7b:c008:0:b0:3f1:7440:f21d with SMTP id c8-20020a7bc008000000b003f17440f21dmr5959093wmb.33.1682281059474;
        Sun, 23 Apr 2023 13:17:39 -0700 (PDT)
Received: from redhat.com ([2.55.61.39])
        by smtp.gmail.com with ESMTPSA id p1-20020a5d48c1000000b002f27dd92643sm2357771wrs.99.2023.04.23.13.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 13:17:38 -0700 (PDT)
Date:   Sun, 23 Apr 2023 16:17:35 -0400
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
Message-ID: <20230423161644-mutt-send-email-mst@kernel.org>
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
        autolearn=ham autolearn_force=no version=3.4.6
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

OK I'm convinced, reset and re-negotiate seems cleaner.

-- 
MST

