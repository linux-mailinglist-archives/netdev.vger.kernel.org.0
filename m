Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B0058405A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiG1NuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiG1NuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:50:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 405F95F8F
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 06:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659016209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tChXGzkEDaadDZsPCQA7MY+3fJ18aNxtVhxEUhg4NK0=;
        b=EabyEsXw4W6QKlQFBcdeeah7KmKHtOxa47ffTMypzRH06/8X/w4EnQb1pmu2zpcNLnf8oc
        d6iIAi9I+jch8hAi4a2JUboZ4b5WLiDnFqyN+NHqPb43WrBsoygwiMCwGExIBzLVGkwsqu
        uRtb2NwctoxpHWI/VEU4of7Zu+6zDVE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-beVfU-BGNaqnvKVfWrGJqA-1; Thu, 28 Jul 2022 09:50:08 -0400
X-MC-Unique: beVfU-BGNaqnvKVfWrGJqA-1
Received: by mail-wm1-f69.google.com with SMTP id c17-20020a7bc011000000b003a2bfaf8d3dso980083wmb.0
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 06:50:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tChXGzkEDaadDZsPCQA7MY+3fJ18aNxtVhxEUhg4NK0=;
        b=p52bPDF/l5ZAbkNMEm6APe3CO97bluq+RBaNGmP8R10Z5pUzz3s5ZdycPbRTp8dceL
         QRMyiUUNRHafLy7DfJSdVYIhyUw0BlBTB21q2NDXMFZai3gWSOKCb/CueivjGPIheKGY
         PhGdf73HBrYvyCGhMp7jazamyrSNqqJK8AGXxwlb4JMMGIaqJ+C/S3vNcSzCjDgxR3cg
         TD6b++Qi9/RwGU9HQ7wjxIof4bwnPFxp9lHSLFYP7OSAxK2tc8wL4S16Spp52v+jEvF7
         64XMEh3Sq7FGbw1pF9p1Ee6fAyoOsDeyzhv6PZe+vFMrL8wozmn1iCZidkWuSfAOZXyC
         4CMw==
X-Gm-Message-State: AJIora9kU5dDa160ZyaMuPYJ1oRhus7vs245MRIfo5hocPfm9roudiaP
        rdKXTBD2c3PKpdDiI168LD4+F8zmUpTst1rwuBtu94srAD+68Qpt8XyRkr323lkvlDytb66fmZZ
        StF5ncH5xQKuZALZC
X-Received: by 2002:a05:600c:3593:b0:3a3:3a49:41a3 with SMTP id p19-20020a05600c359300b003a33a4941a3mr6740012wmq.166.1659016206950;
        Thu, 28 Jul 2022 06:50:06 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ufWT771heg6CQnGhJYT28ksPuBvz3PaqMy3L541vtCGNuZ60YxsqNnjk7nz3tcnaF9Nt9H7Q==
X-Received: by 2002:a05:600c:3593:b0:3a3:3a49:41a3 with SMTP id p19-20020a05600c359300b003a33a4941a3mr6739990wmq.166.1659016206656;
        Thu, 28 Jul 2022 06:50:06 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id u1-20020adfdd41000000b0021d80f53324sm1101257wrm.7.2022.07.28.06.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 06:50:05 -0700 (PDT)
Message-ID: <e70b924a0a2ef69c4744a23862258ebb23b60907.camel@redhat.com>
Subject: Re: [PATCH net-next 2/4] tls: rx: don't consider sock_rcvtimeo()
 cumulative
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, borisp@nvidia.com,
        john.fastabend@gmail.com, maximmi@nvidia.com, tariqt@nvidia.com,
        vfedorenko@novek.ru
Date:   Thu, 28 Jul 2022 15:50:03 +0200
In-Reply-To: <20220727031524.358216-3-kuba@kernel.org>
References: <20220727031524.358216-1-kuba@kernel.org>
         <20220727031524.358216-3-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-26 at 20:15 -0700, Jakub Kicinski wrote:
> Eric indicates that restarting rcvtimeo on every wait may be fine.
> I thought that we should consider it cumulative, and made
> tls_rx_reader_lock() return the remaining timeo after acquiring
> the reader lock.
> 
> tls_rx_rec_wait() gets its timeout passed in by value so it
> does not keep track of time previously spent.
> 
> Make the lock waiting consistent with tls_rx_rec_wait() - don't
> keep track of time spent.
> 
> Read the timeo fresh in tls_rx_rec_wait().
> It's unclear to me why callers are supposed to cache the value.
> 
> Link: https://lore.kernel.org/all/CANn89iKcmSfWgvZjzNGbsrndmCch2HC_EPZ7qmGboDNaWoviNQ@mail.gmail.com/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

I have a possibly dumb question: this patch seems to introduce a change
of behavior (timeo re-arming after every progress vs a comulative one),
while re-reading the thread linked above it I (mis?)understand that the
timeo re-arming is the current behavior?

Could you please clarify/help me understand this better?

Thanks!

Paolo

