Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34387622532
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 09:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiKIITb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 03:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiKIITa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 03:19:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD5017E3F
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 00:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667981914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dgGprYoeTN22cTQDR5YOz3sASLNpnLaaRp5I0puxy0k=;
        b=AVb96HoqsFxhJwmho87cl+Da/mWdRY3ElfBZelcdDeXuwQYkiALZsWe7lVYHB0PkbQR/g/
        9YRZg1HEBCVtUKruYIT/AL7CxTlbOzt7+YyyNYUHYMqDFNnkDWWEuQsSZmPnndkJuwp3aL
        oclobTSHpCtr6ZO1fMM26i5h8tR7uEM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-81-_XhhI5ErPU2cc7sRMsiNHw-1; Wed, 09 Nov 2022 03:18:32 -0500
X-MC-Unique: _XhhI5ErPU2cc7sRMsiNHw-1
Received: by mail-qk1-f200.google.com with SMTP id bs7-20020a05620a470700b006fac7447b1cso8214255qkb.17
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 00:18:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dgGprYoeTN22cTQDR5YOz3sASLNpnLaaRp5I0puxy0k=;
        b=0c45If6FOqWm6liDAhUEDufZdipnQMuaT4s6DzOc0BgO6KOzdox3V6mPhTUFmuIgAB
         OQpVOK20bPquseT4hZEQXTpEuXCkfyJQ0/JbXxXrPZU88btWCEpXPL2MY3xunMCecrxk
         EMR5LYEtF6mVtkWiUagWLP/n9QrYp3AFz6hI43uDSQukGNebxC9owrNwbp8ePS5fTt5z
         /Aqx8IjPHd3GZG/AryON5a3PtitOMMByShmH736SZzqWR6RY4+u2Z9CkLXCaagatr93C
         HtNAp6MFCCYTSx/bWrZ7DKHXMjY84n4HJyg4GwgvXtaAQpr9LA6CFZbFBuUaytGR/Vhp
         LZtQ==
X-Gm-Message-State: ACrzQf2pYmvgCchezFdaCYsGNr7ww0jT+bmGQnEpZqK0zrVHv+StyC55
        T4H9xvwThoscmGpKy0wSAcaVk7ES7RDH1trCC7Np10Q3WiaLg7LpAC0/4PoQLY0IDlP5Z0JCnMl
        MdAyWpPpADwGofLbS
X-Received: by 2002:a0c:de07:0:b0:4bc:187a:7085 with SMTP id t7-20020a0cde07000000b004bc187a7085mr38386059qvk.13.1667981912274;
        Wed, 09 Nov 2022 00:18:32 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5nr5OeV6fr2CjoyWBfrNdvGZsceXntb36rsvEakUXbxiiIfozncmPJPob44jTHHjm5hBECkg==
X-Received: by 2002:a0c:de07:0:b0:4bc:187a:7085 with SMTP id t7-20020a0cde07000000b004bc187a7085mr38386045qvk.13.1667981912018;
        Wed, 09 Nov 2022 00:18:32 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id bi14-20020a05620a318e00b006b929a56a2bsm10711570qkb.3.2022.11.09.00.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 00:18:31 -0800 (PST)
Date:   Wed, 9 Nov 2022 09:18:23 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost: fix range used in translate_desc()
Message-ID: <20221109081823.tg5roitl26opqe6k@sgarzare-redhat>
References: <20221108103437.105327-1-sgarzare@redhat.com>
 <20221108103437.105327-3-sgarzare@redhat.com>
 <CACGkMEuRnqxESo=V2COnfUjP5jGLTXzNRt3=Tp2x-9jsS-RNGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACGkMEuRnqxESo=V2COnfUjP5jGLTXzNRt3=Tp2x-9jsS-RNGQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 11:28:41AM +0800, Jason Wang wrote:
>On Tue, Nov 8, 2022 at 6:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> vhost_iotlb_itree_first() requires `start` and `last` parameters
>> to search for a mapping that overlaps the range.
>>
>> In translate_desc() we cyclically call vhost_iotlb_itree_first(),
>> incrementing `addr` by the amount already translated, so rightly
>> we move the `start` parameter passed to vhost_iotlb_itree_first(),
>> but we should hold the `last` parameter constant.
>>
>> Let's fix it by saving the `last` parameter value before incrementing
>> `addr` in the loop.
>>
>> Fixes: 0bbe30668d89 ("vhost: factor out IOTLB")
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>
>> I'm not sure about the fixes tag. On the one I used this patch should
>> apply cleanly, but looking at the latest stable (4.9), maybe we should
>> use
>>
>> Fixes: a9709d6874d5 ("vhost: convert pre sorted vhost memory array to interval tree")
>
>I think this should be the right commit to fix.

Yeah, @Michael should I send a v2 with that tag?

>
>Other than this
>
>Acked-by: Jason Wang <jasowang@redhat.com>
>

Thanks for the review,
Stefano

