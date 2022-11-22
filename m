Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD094633F5E
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiKVOwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbiKVOwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:52:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6F1697DC
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669128674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Aql4QhJxVxvNQzM6ixf9UhoovYHEV1FkcCSwtG2tyM=;
        b=ZaXKjLDRPuJckcUuU+uZ2xnurYDmoNak7IlfpQRKi1bqOZ5M7kv/zhwQ5jlnQmsNJkJznn
        2j/PmFbEUoP3bqxY6OT0+/wJBOoPgloKlafXs5zxlIfhL71xHy5KUmNuoR9Hts3vncJvfz
        snFnqwI3RwSRA1pwfTJMTVcjiPZImIM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-2zB2XWcQM_2mPHEbjHkOIw-1; Tue, 22 Nov 2022 09:51:09 -0500
X-MC-Unique: 2zB2XWcQM_2mPHEbjHkOIw-1
Received: by mail-wm1-f71.google.com with SMTP id p14-20020a05600c204e00b003cf4cce4da5so4157401wmg.0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:51:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Aql4QhJxVxvNQzM6ixf9UhoovYHEV1FkcCSwtG2tyM=;
        b=rl/YRoqqZH29KUT5F9VfDEjfnyU8Bc+mtiRPwq9fIzSOPxMez1BZkyL8hTnyHogUUZ
         R70W3PPMdjwPJaHmxorHJToWuzwGyUV+RPPi4Jz0gh2TaFpYSjCGUXxGg9Y5oga78+Af
         IdsLmBnKy3VcvaST64rfv0rj+0FuZwzLDBopgwGZhkdxc5A1SSh3f8pafLryAUjuRWnw
         S50iyw/F28lkNBq/NY0vjZ0dcufKp0O/FJ93sukuDh19Zn6iSL2lkD0j3uM2g74sdqSy
         8+5iihuvk3zAzNE6MNUGgjq0VZjiezoKjJ+ziMf6SOtG5nmVmkjj44mGOh1XFF2wIdvP
         0AFQ==
X-Gm-Message-State: ANoB5pmd68KwmSdmFXCBsJ8gPDYd0ywAjbZo+HZTZ/W0A0CjbUXdVGET
        NlbsoNYPswLQSVcI8mr7yH+OO4RO6/LvkTzrhN6kuSWf3366XUu1pBe2VCzIBh9rgo8Ql0t2ut2
        +1BFKCJUiTnC9INCk
X-Received: by 2002:a05:600c:5023:b0:3cf:8ed7:7131 with SMTP id n35-20020a05600c502300b003cf8ed77131mr16549397wmr.84.1669128667142;
        Tue, 22 Nov 2022 06:51:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6UFJ4g7o2yW/9afzBMDZQI9UTuI0lDj4CL8APodQiMAAie0ZFGIO2Ae8fJ340N2j0NUwTGIw==
X-Received: by 2002:a05:600c:5023:b0:3cf:8ed7:7131 with SMTP id n35-20020a05600c502300b003cf8ed77131mr16549368wmr.84.1669128666842;
        Tue, 22 Nov 2022 06:51:06 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id r24-20020adfa158000000b00236b2804d79sm14782746wrr.2.2022.11.22.06.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 06:51:06 -0800 (PST)
Message-ID: <fd546e83a38157b76f8bde2219f985c70056abf7.camel@redhat.com>
Subject: Re: [PATCH net-next] tsnep: Fix rotten packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com
Date:   Tue, 22 Nov 2022 15:51:05 +0100
In-Reply-To: <20221119211825.81805-1-gerhard@engleder-embedded.com>
References: <20221119211825.81805-1-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-11-19 at 22:18 +0100, Gerhard Engleder wrote:
> If PTP synchronisation is done every second, then sporadic the interval
> is higher than one second:
> 
> ptp4l[696.582]: master offset        -17 s2 freq   -1891 path delay 573
> ptp4l[697.582]: master offset        -22 s2 freq   -1901 path delay 573
> ptp4l[699.368]: master offset         -1 s2 freq   -1887 path delay 573
>       ^^^^^^^ Should be 698.582!
> 
> This problem is caused by rotten packets, which are received after
> polling but before interrupts are enabled again. This can be fixed by
> checking for pending work and rescheduling if necessary after interrupts
> has been enabled again.
> 
> Fixes: 403f69bbdbad ("tsnep: Add TSN endpoint Ethernet MAC driver")
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

For the records, when targeting the net tree, you should include the
'net' tag into the patch prefix, instead of 'net-next'.

Thanks,

Paolo

