Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D5F4A8A81
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352965AbiBCRo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:44:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234361AbiBCRoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:44:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643910294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LH/P6aA+px/1wh2DJc3LLa9raaWD77OaX/3A6gTxrnQ=;
        b=Pop0hqLEsDPxGoX+Ae9pZbnyUMB72lAMa9XVjc+2VSBKJvRJlWS7NEt51FeEMXpT0gGAG5
        XZ5nkJrt820cirzPvNC3HZ2Apa+XCRnF8YRAjZ5M/ECIYU04KVzXCeUUqiMoQAvSWErdtf
        bWRfTWujhkLLB4qevYTyVkbhEhKdeOw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-voFHh1sfM1-PbzxPUq2QLQ-1; Thu, 03 Feb 2022 12:44:53 -0500
X-MC-Unique: voFHh1sfM1-PbzxPUq2QLQ-1
Received: by mail-wr1-f71.google.com with SMTP id t14-20020adfa2ce000000b001e1ad2deb3dso964532wra.0
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 09:44:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LH/P6aA+px/1wh2DJc3LLa9raaWD77OaX/3A6gTxrnQ=;
        b=iO4XQbnG6DdDLFivR3Cfrn1EpIa8RIoO1ykLtFiywWEHCFFxBfzu0CAXJD+jSmymc5
         miNcTgWolm4sNuPHpraxIzXfFPfnFlm9CmsHGrGzoIyPRSpr2TkG4NYndyvYWfaBUvlv
         rX449vCYuWYUh6VvhcHbkEjO9XQwyQ4OLxZUagkF/ndH6PV24Nsr5zl6X6HQk1mbXAnk
         u0IxJ84CPHEcyfl5sAXQ/k0OOC555f3gHowwfKJi6KrE8yiddCFmkG4caFGkqTG+W2Lx
         5md1ZXMTXr85bcZWT6Uxmvq0MV23irVT9yXZmoCPsrtya8tNkyeTrhCo71YoK7QWaGil
         MApQ==
X-Gm-Message-State: AOAM5339ct+iLrLLYmzjVEPMhw97z81EtRvj/thDsAw9P3sLQZ/tJzjF
        fK5KN1+chB2H/CJ5LwIrzJKMmWNJNMPEdoLbIeNY3S3gpGv1XR+IANWcUgqGjF/bTg3k1WO/jwU
        8o7tUHNJGAmK6TyaU
X-Received: by 2002:adf:dec3:: with SMTP id i3mr31819022wrn.695.1643910291980;
        Thu, 03 Feb 2022 09:44:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxqXwQCwow7T8ux8hJeKV6GsFGwYHgP/c86y4J8c0IuMqza3+nm3U/qE4cy9EJIqxdcZBeyOQ==
X-Received: by 2002:adf:dec3:: with SMTP id i3mr31819008wrn.695.1643910291769;
        Thu, 03 Feb 2022 09:44:51 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id a26sm9036956wmj.18.2022.02.03.09.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 09:44:51 -0800 (PST)
Message-ID: <6fa7380a0a775375ca7ce83526dbfce20a87c91c.camel@redhat.com>
Subject: Re: [PATCH net-next 2/3] net: gro: minor optimization for
 dev_gro_receive()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Eric Dumazet <edumazet@google.com>
Date:   Thu, 03 Feb 2022 18:44:50 +0100
In-Reply-To: <07cd64ccacb61cb933bb66af83cb238caf956c96.camel@gmail.com>
References: <cover.1643902526.git.pabeni@redhat.com>
         <2a6db6d6ca415cb35cc7b3e4d9424baf0516d782.1643902526.git.pabeni@redhat.com>
         <07cd64ccacb61cb933bb66af83cb238caf956c96.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-03 at 08:39 -0800, Alexander H Duyck wrote:
> On Thu, 2022-02-03 at 16:48 +0100, Paolo Abeni wrote:
> > While inspecting some perf report, I noticed that the compiler
> > emits suboptimal code for the napi CB initialization, fetching
> > and storing multiple times the memory for flags bitfield.
> > This is with gcc 10.3.1, but I observed the same with older compiler
> > versions.
> > 
> > We can help the compiler to do a nicer work clearing several
> > fields at once using an u32 alias. The generated code is quite
> > smaller, with the same number of conditional.
> > 
> > Before:
> > objdump -t net/core/gro.o | grep " F .text"
> > 0000000000000bb0 l     F .text  0000000000000357 dev_gro_receive
> > 
> > After:
> > 0000000000000bb0 l     F .text  000000000000033c dev_gro_receive
> > 
> > RFC -> v1:
> >  - use __struct_group to delimt the zeroed area (Alexander)
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  include/net/gro.h | 52 +++++++++++++++++++++++++--------------------
> > --
> >  net/core/gro.c    | 18 +++++++---------
> >  2 files changed, 35 insertions(+), 35 deletions(-)
> > 
> > diff --git a/include/net/gro.h b/include/net/gro.h
> > index 8f75802d50fd..fa1bb0f0ad28 100644
> > --- a/include/net/gro.h
> > +++ b/include/net/gro.h
> > @@ -29,46 +29,50 @@ struct napi_gro_cb {
> >         /* Number of segments aggregated. */
> >         u16     count;
> >  
> > -       /* Start offset for remote checksum offload */
> > -       u16     gro_remcsum_start;
> > +       /* Used in ipv6_gro_receive() and foo-over-udp */
> > +       u16     proto;
> >  
> >         /* jiffies when first packet was created/queued */
> >         unsigned long age;
> >  
> > -       /* Used in ipv6_gro_receive() and foo-over-udp */
> > -       u16     proto;
> > +       /* portion of the cb set to zero at every gro iteration */
> > +       __struct_group(/* no tag */, zeroed, /* no attrs */,
> 
> Any specific reason for using __struct_group here rather than the
> struct_group macro instead?

Just sheer ignorance on my side. I'll fix on the next iteration.

Thanks!

Paolo

