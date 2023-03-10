Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5020E6B3988
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjCJJDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbjCJJBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:01:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEB211052B
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678438528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vfaGyjJVfm635JeXhSuWAc4er0IJMoVENEv0pUS72pE=;
        b=jB52n7U17Xti1cOCjToyZC7lHBc2CeY7FuPOvQJMD1SnbP/MVnzpDJfo8x5so2Ik72ugCO
        ldrDMu+8it8tjtPrm+BQPEH0ZqJg/eEsW76blm6NTYup8qKQR3gdDDe6FeprwGeJxnlK7Y
        HtsMlK2rozl0yMdOdlW/t890pLREwlY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-t0veRF_5NM6Rq9cYdpWQEw-1; Fri, 10 Mar 2023 03:55:26 -0500
X-MC-Unique: t0veRF_5NM6Rq9cYdpWQEw-1
Received: by mail-wm1-f69.google.com with SMTP id j32-20020a05600c1c2000b003e9bdf02c9fso3564923wms.6
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:55:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678438525;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vfaGyjJVfm635JeXhSuWAc4er0IJMoVENEv0pUS72pE=;
        b=h0iHD1ul0yhBGECVbZLHOSGrFF6EdtYppbwGSjOSj54Z69hoFcFhS5uAaVAQVGTVLg
         CwNZSwjlJpxBAIhIq7ThJbv30sJzYaIwzpPK8JPLhM+kTIzve4kscQfyyZ3NIVT2hQOm
         bgIne9SIOZs8nRyOWbFDa6X5OFV5N3yu4kbJI1UeKjISKZuDK/q78QLbRCbKkCYimj5m
         FOaBPETdzsrXmQ+Sz+9ZnpR1WQXgRWVG1DYS3g58rcZARXO/A6trtLT/csnUm1TuB19J
         g/zao9MoJASi3NiucOZJkbofh9Pv6OUXxk0Oof95cIcjuNj/SqFaFLG/BT2lJIsGEnIh
         ETdA==
X-Gm-Message-State: AO0yUKXhILpsgXFRMVZLIyKmhNnnP7Oyr3uspLojLbRAsumARhlOdhfg
        XbOHMFqoMuXLPu1KmMYb9AVBis054kiUwrjIyRFgSWyMwjTl99Wkg2+zavw+BGIVAJsRsoyLj0Q
        TpE9YQ6jXKK+j13+u
X-Received: by 2002:a5d:558e:0:b0:2c9:e5f0:bd4f with SMTP id i14-20020a5d558e000000b002c9e5f0bd4fmr16454636wrv.18.1678438525521;
        Fri, 10 Mar 2023 00:55:25 -0800 (PST)
X-Google-Smtp-Source: AK7set+ZCJLrhyjyYuI2NKYdYVdjVvFfujK+H8p82JNRkHzpuum9+WBjmlvVp1x6vFu5g5usem1xCg==
X-Received: by 2002:a5d:558e:0:b0:2c9:e5f0:bd4f with SMTP id i14-20020a5d558e000000b002c9e5f0bd4fmr16454627wrv.18.1678438525223;
        Fri, 10 Mar 2023 00:55:25 -0800 (PST)
Received: from redhat.com ([2.52.9.88])
        by smtp.gmail.com with ESMTPSA id j13-20020a5d564d000000b002c5694aef92sm1620415wrw.21.2023.03.10.00.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 00:55:24 -0800 (PST)
Date:   Fri, 10 Mar 2023 03:55:21 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andrey Smetanin <asmetanin@yandex-team.ru>
Cc:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yc-core@yandex-team.ru" <yc-core@yandex-team.ru>
Subject: Re: [PATCH] vhost_net: revert upend_idx only on retriable error
Message-ID: <20230310035509-mutt-send-email-mst@kernel.org>
References: <20221123102207.451527-1-asmetanin@yandex-team.ru>
 <CACGkMEs3gdcQ5_PkYmz2eV-kFodZnnPPhvyRCyLXBYYdfHtNjw@mail.gmail.com>
 <20221219023900-mutt-send-email-mst@kernel.org>
 <62621671437948@mail.yandex-team.ru>
 <20230127031904-mutt-send-email-mst@kernel.org>
 <278011674821181@mail.yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <278011674821181@mail.yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 03:08:18PM +0300, Andrey Smetanin wrote:
> Yes, I plan. I need some time, currently I'm very busy in another direction,
> but I will return.


Jason you want to take this up maybe?

> 27.01.2023, 11:19, "Michael S. Tsirkin" <mst@redhat.com>:
> 
> 
>     On Mon, Dec 19, 2022 at 11:24:26AM +0300, Andrey Smetanin wrote:
> 
>          Sorry for the delay.
>          I will send update on this week after some tests.
>          19.12.2022, 10:39, "Michael S. Tsirkin" <mst@redhat.com>:
> 
> 
>     Do you still plan to send something? Dropping this for now.
>      
> 

