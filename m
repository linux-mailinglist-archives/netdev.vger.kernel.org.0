Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A121F6E5E77
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 12:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjDRKS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 06:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjDRKSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 06:18:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00D76EAB
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 03:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681813081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MG0Nr2BMXXdUPGLSdXJQNTH3SV8FDEpzwmgkuk+rqoY=;
        b=IuAYB32CiihbOyX452xUqm2oGGadRoE+R7KfEbV64D0sUjrW4piWuu7iVeeWai6NuTrbYA
        OF74GXfU9YcQm5jLuDriLEUjhfn4zCLifMl7zYauoOhJHxT1gQb+FToz9ndrihBued6b/e
        nE5p4OXRv+A25XtRqIBRuHWPlk/hMx8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-DAzDEQdbOS24Gc0icmRK3g-1; Tue, 18 Apr 2023 06:17:59 -0400
X-MC-Unique: DAzDEQdbOS24Gc0icmRK3g-1
Received: by mail-wm1-f70.google.com with SMTP id bd16-20020a05600c1f1000b003f172e02edbso3325737wmb.4
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 03:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681813078; x=1684405078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MG0Nr2BMXXdUPGLSdXJQNTH3SV8FDEpzwmgkuk+rqoY=;
        b=BK/1R1X3dVjnAft2KzpJyy0oN1BOBW3Ql8ufkPHBJrS8Z/g8DXZG03rKSnGpE2yUOZ
         dzsf4DkxBla/suVozr53uRL8wAh9nBhNsF4rxO6ZvQP1M+Nvozw94GNTP0vKepxusfG5
         /en8kEbt4QX04LRPtHWiFB/PamvgoMf5oBXj/jGM8EN8dXxOW2jusDFpsVuHDs+ZQC/X
         Z+If54FTaPjyGnrY3K7kEbPCPznPJQzFSLHHzZmmPyQfLr/GZ2ssl7bzp5C0Gx15rvNN
         So+vLi1DgIw9P2G1apFKqEvDMwoe8fArYP/1RZ7Xnqv3zaHesRV6sjn0F4sodYHCX48c
         SQ6Q==
X-Gm-Message-State: AAQBX9cwYqBT2wM0CBiGLvxhEtkMi/qEjO3lfnZKHZEXX2S5ok/920O3
        FHiZ06nZkfPEJ8aaLsuXqXsLQ1MjAU94xiMZYxOAaAnrSBfAFbmzTC1mzEOrIcn/3aWaSbJQzpH
        lwKAAwt9Vos/b/uTm
X-Received: by 2002:a05:600c:cf:b0:3f1:6ec5:bc6f with SMTP id u15-20020a05600c00cf00b003f16ec5bc6fmr7229574wmm.24.1681813078644;
        Tue, 18 Apr 2023 03:17:58 -0700 (PDT)
X-Google-Smtp-Source: AKy350Ym6ZWQyN42luCGewFwsYwO8ohz8iOoGYg/73E3FSOB8LN2mYA6Z4LDEdHP8XSeA1LCBedC9w==
X-Received: by 2002:a05:600c:cf:b0:3f1:6ec5:bc6f with SMTP id u15-20020a05600c00cf00b003f16ec5bc6fmr7229554wmm.24.1681813078298;
        Tue, 18 Apr 2023 03:17:58 -0700 (PDT)
Received: from debian ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id a8-20020a5d4568000000b002f61f08a9a6sm12351042wrc.50.2023.04.18.03.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 03:17:57 -0700 (PDT)
Date:   Tue, 18 Apr 2023 12:17:55 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Samuel Thibault <samuel.thibault@ens-lyon.org>,
        James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPPoL2TP: Add more code snippets
Message-ID: <ZD5uU8Wrz4cTSwqP@debian>
References: <20230416220704.xqk4q6uwjbujnqpv@begin>
 <ZD5V+z+cBaXvPbQa@debian>
 <20230418085323.h6xij7w6d2o4kxxi@begin>
 <ZD5dqwPblo4FOex1@debian>
 <20230418091148.hh3b52zceacduex6@begin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418091148.hh3b52zceacduex6@begin>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 11:11:48AM +0200, Samuel Thibault wrote:
> Guillaume Nault, le mar. 18 avril 2023 11:06:51 +0200, a ecrit:
> > On Tue, Apr 18, 2023 at 10:53:23AM +0200, Samuel Thibault wrote:
> > > Guillaume Nault, le mar. 18 avril 2023 10:34:03 +0200, a ecrit:
> > > > PPPIOCBRIDGECHAN's description
> > > > belongs to Documentation/networking/ppp_generic.rst, where it's already
> > > > documented.
> > > 
> > > Yes but that's hard to find out when you're looking from the L2TP end.
> > 
> > That's why I proposed linking to ppp_generic.rst.
> 
> Yes, but it's still not obvious to L2TP people that it's a ppp channel
> that you have to bridge. Really, having that 20-line snippet available
> would have saved me some head-scratching time.

But the reverse is also true: someone looking at the PPP documentation
is probably not going to realise that PPP sample code have been put in
the L2TP doc.

We can instead add PPP specific code in the PPP documentation. Then add
a line in l2tp.rst saying something like "Handling of the PPP layer is
described in ppp_generic."

If you feel like having sample code for a full example covering the
whole process of creating and setting up the file descriptiors needed
for bridging PPP channels (UDP, L2TP tunnels, L2TP sessions and PPP
channels, and why not PPPoE), then I feel a specific file would be more
indicated, as this would cross several different subsystems.

It'd be okay to to have a few PPP-specific calls in l2tp.rst since
L2TPv2 is tied to PPP and that could give a more complete example of
how to use the L2TP uAPI. But that should be limitted to the most basic
PPP features (creating a channel and a unit).

> Samuel
> 

