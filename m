Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB3E69F8AC
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 17:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjBVQMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 11:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjBVQMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 11:12:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26873028D
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 08:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677082273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S8/ghNNTbLiIrYnO3iHVdavpmvCg0NzWCI0d6aV/XW4=;
        b=XPmvFZmJwp9zCR9TFDRy0iWYmeg2mitgiaZL2UdMgi8yhLq/Uejskqf4fRAskzb5rDPJL7
        lbC8np7dcYNCzgK5PhcLxH8gDstB+pJebEk7YW5rLYMC9WfgZZKiNeKIBirjADsDaM8h98
        qkHF9ehaMdDwFjrHKaJr/oS+K/6uVEc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-633-1AVMWintNDex0H99t4hWAA-1; Wed, 22 Feb 2023 11:11:12 -0500
X-MC-Unique: 1AVMWintNDex0H99t4hWAA-1
Received: by mail-wr1-f70.google.com with SMTP id m15-20020adfa3cf000000b002be0eb97f4fso1686053wrb.8
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 08:11:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S8/ghNNTbLiIrYnO3iHVdavpmvCg0NzWCI0d6aV/XW4=;
        b=iXT37XDyY448q5cq+Lgu5yHAUWm2a2H+mcsRdwObDN9xI5IuFC5LR1KUCNqldLWZdd
         0wzeYRFJQQFRbpr0J6nZ1zwiAMFkpxdTvEQCAz9tB9+gvKCfZOBPhpvUSvg3yRyEMT3K
         bw+NyZU5ADizPcPg4VVg89U3BGJhVUFoPKss96+ae2oUoqcZRTAKRy0OaKh+KpJUCCVv
         KxeK6zAkIWvoHOXxYNUt9pOWnhwlOaS1BQ804uusZg2RyZwcuV0NCvY7/RvTH/AsXdZy
         w334cAEhbNprbSnYGoxBbLa5HqzinwiGzflQbpT4/CW+3/FvbhAfMYv1YvIpIIjFb0rY
         A0mg==
X-Gm-Message-State: AO0yUKU5cCdvAm8dQ6NIwNP+74OwlmwePKZh70ScMBXWZ4h+U9/T7hhf
        F8Oddq2r37MUcIahM+mBIHWH5j2ruzakbtntJMTplXmy024SEK3dyvs+yBiMu5pN0AKnc+/xZgx
        UJzgvyMh45FuzMdGW
X-Received: by 2002:a05:600c:c8:b0:3d2:392e:905f with SMTP id u8-20020a05600c00c800b003d2392e905fmr6409846wmm.24.1677082271078;
        Wed, 22 Feb 2023 08:11:11 -0800 (PST)
X-Google-Smtp-Source: AK7set+Un1ypNExaFc+kZXMwSn3M07lTqk0Yp2UvtUsGjthoH8fmjLy+NvB/zR6OGvIrn8kdBsh6vQ==
X-Received: by 2002:a05:600c:c8:b0:3d2:392e:905f with SMTP id u8-20020a05600c00c800b003d2392e905fmr6409831wmm.24.1677082270782;
        Wed, 22 Feb 2023 08:11:10 -0800 (PST)
Received: from redhat.com ([2.52.2.78])
        by smtp.gmail.com with ESMTPSA id iz4-20020a05600c554400b003e203681b26sm5571009wmb.29.2023.02.22.08.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 08:11:10 -0800 (PST)
Date:   Wed, 22 Feb 2023 11:11:06 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com
Subject: Re: [patch net-next v2] net: virtio_net: implement exact header
 length guest feature
Message-ID: <20230222110534-mutt-send-email-mst@kernel.org>
References: <20230221144741.316477-1-jiri@resnulli.us>
 <63f4df39e0728_ce6df208fe@willemb.c.googlers.com.notmuch>
 <Y/TltJnD4k5hB6Z1@nanopsycho>
 <63f4ed716af37_d174a20880@willemb.c.googlers.com.notmuch>
 <Y/XLIs+4eg7xPyF0@nanopsycho>
 <63f6314d678bc_2ab6208a@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63f6314d678bc_2ab6208a@willemb.c.googlers.com.notmuch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 10:14:21AM -0500, Willem de Bruijn wrote:
> Either including the link that Michael shared or quoting the relevant
> part verbatim in the commit message would help, thanks.
> 
> Thinking it over, my main concern is that the prescriptive section in
> the spec does not state what to do when the value is clearly garbage,
> as we have seen with syzkaller.
> 
> Having to sanitize input, by dropping if < ETH_HLEN or > length, to
> me means that the device cannot trust the field, as the spec says it
> should. 

Right. I think the implication is that if device detects and illegal
value it's OK for it to just drop the packet or reset or enter
a broken mode until reset.

By contrast without the feature bit the header size can be
used as a hint e.g. to size allocations but you must
recover if it's incorrect.

And yes tap seems to break if you make it too small or if you make
it huge so it does not really follow the spec in this regard.

Setting the flag will not fix tap because we can't really
affort breaking all drivers who don't set it. But it will
prepare the ground for when tens of years from now we
actually look back and say all drivers set it, no problem.

So that's a good reason to ack this patch.

However if someone is worried about this then fixing tap
so it recovers from incorrect header length without
packet loss is a good idea.

> Sanitization is harder in the kernel, because it has to support all
> kinds of link layers, including variable length.
> 
> Perhaps that's a discussion for the spec rather than this commit. But
> it's a point to clarify as we add support to the code.

-- 
MST

