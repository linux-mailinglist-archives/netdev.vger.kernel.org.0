Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF5861602F
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 10:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiKBJqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 05:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKBJqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 05:46:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCCB1F9EC
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 02:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667382317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DW2a/80J8hDerpO8ayxyonD3c6E1iUdSbhWZlEaOu5c=;
        b=OP9ZBS21JauMiqj2jqv6a43yEvWdJ0McCa0JXokqbN5UX3iAAXyFAqtS09jmXco2Hi3qTw
        i0wwS7s6wl5itmVZRwiaeKNygX+nVp7gCLZjy31xf1ZxBLCLAiLgFWYGcUT8UxHBE9gId8
        L5a5cwgRe483yx43XIZQTw0nvjW+m/w=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-622-TqlHtguYPXONQHkM2j5KnQ-1; Wed, 02 Nov 2022 05:45:15 -0400
X-MC-Unique: TqlHtguYPXONQHkM2j5KnQ-1
Received: by mail-qv1-f71.google.com with SMTP id z18-20020a0cfed2000000b004bc28af6f7dso121406qvs.4
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 02:45:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DW2a/80J8hDerpO8ayxyonD3c6E1iUdSbhWZlEaOu5c=;
        b=rxUc1ywnMYfCLnwPtyb91UqxcPgrBUfgv6sphd3smHcshD2Nn/w2M7D9tNfqD+OSmc
         D/i3MBnfC1VyxLfNZ+zoBHoNBA14fugCs/zxuNlIArtzCz9yzXLbDF5JVEkGUDTMuE1K
         qfvkIMq1L1Yze3BR0gJpjfebLTqjOHEnXoIMqFp7A8LgKa4+afo9dqvotgZmcxtPJeZR
         ZKxEnksp3fWNGt0lN7Oc1uBghSX4/A1aIpHuKzMR/Cm3aSkTHR51UjoCQZ1ey+nkFqDW
         1EJZGf/LVoaB8OM+qcApfhNyyRp/IHY6lmr0xcvuxngHAY82khOr/ft52dcPeeoTuf9m
         MzUw==
X-Gm-Message-State: ACrzQf1FNKFNKTU+JNugaai3zrSJR/WK/9bRmX7+crH5kO79taYdc28i
        pQpre3LiY5i5oxTVK5mnDJ/EyzBsXUejlwtXkKt/Tat8GOyLHsRiE7aBxDRJvZf7jtv0wpUXLfx
        XvWZBfEg9lH36kukL
X-Received: by 2002:a0c:906e:0:b0:4bb:e024:53b5 with SMTP id o101-20020a0c906e000000b004bbe02453b5mr16117819qvo.39.1667382315414;
        Wed, 02 Nov 2022 02:45:15 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6DBLvfnyHa64NTohsQ2JJkSO3mLcgL9P+qhtcouJauIw3nBBLEsYTgOuVHQoDiDy+GcHZILg==
X-Received: by 2002:a0c:906e:0:b0:4bb:e024:53b5 with SMTP id o101-20020a0c906e000000b004bbe02453b5mr16117805qvo.39.1667382315054;
        Wed, 02 Nov 2022 02:45:15 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id h4-20020a05620a400400b006cdd0939ffbsm8126852qko.86.2022.11.02.02.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 02:45:14 -0700 (PDT)
Date:   Wed, 2 Nov 2022 10:45:04 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Frederic Dalleau <frederic.dalleau@docker.com>
Cc:     wei.liu@kernel.org, netdev@vger.kernel.org, haiyangz@microsoft.com,
        linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        stephen@networkplumber.org, edumazet@google.com, kuba@kernel.org,
        arseny.krasnov@kaspersky.com, decui@microsoft.com
Subject: Re: [PATCH 2/2] vsock: fix possible infinite sleep in
 vsock_connectible_wait_data()
Message-ID: <20221102094504.vhf6x2hgo6fqr7pi@sgarzare-redhat>
References: <20221028205646.28084-1-decui@microsoft.com>
 <20221028205646.28084-3-decui@microsoft.com>
 <20221031084327.63vikvodhs7aowhe@sgarzare-redhat>
 <CANWeT6gyKNRraJWzO=02gkqDwa-=tw7NmP2WYRGUyodUBLotkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANWeT6gyKNRraJWzO=02gkqDwa-=tw7NmP2WYRGUyodUBLotkQ@mail.gmail.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 09:21:06PM +0100, Frederic Dalleau via Virtualization wrote:
>Hi Dexan, Stephano,
>
>This solution has been proposed here,
>https://lists.linuxfoundation.org/pipermail/virtualization/2022-August/062656.html

Ops, I missed it!

Did you use scripts/get_maintainer.pl?
https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html#select-the-recipients-for-your-patch

Since your patch should be reposted (hasn't been sent to 
netdev@vger.kernel.org, missing Fixes tag, etc.) and Dexuan's patch on 
the other hand is ready (I just reviewed it), can you test it and 
respond with your Tested-by?

I would like to give credit to both, so I asked to add your Reported-by 
to the Dexuan's patch.

Thanks,
Stefano

