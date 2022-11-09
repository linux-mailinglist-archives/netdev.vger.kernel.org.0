Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8652062281E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiKIKLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiKIKLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:11:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D91CC6E
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667988644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5MPz3Ec+EPgg7rG8vMEpdX68m++2s8DqWYBcdW2qsvI=;
        b=C1Eo/z9K0XzWDaxc+N2ZUnny0vBIxOYELgbh6/qYFOnLDLMRo22mvJfbf407k8f1NbuxZA
        95UXa2IWafvCjJdGwxs1vZeLkTcaDjhFV0qv0R5e/u9ZQ6inbKsZcTFBxTrd7wCQVsuWAh
        jF6Z3SDexZ6bgJ8pNEDtNUqaXH8pD7M=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-516-7A_q0LtsPCyxSplA98tS_Q-1; Wed, 09 Nov 2022 05:10:43 -0500
X-MC-Unique: 7A_q0LtsPCyxSplA98tS_Q-1
Received: by mail-qv1-f70.google.com with SMTP id z18-20020a0cfed2000000b004bc28af6f7dso11360133qvs.4
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 02:10:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MPz3Ec+EPgg7rG8vMEpdX68m++2s8DqWYBcdW2qsvI=;
        b=ODCPawKAnHUjqHiaGYuwUhuCAXj4DxF1NuF4wyY8MqSsnM/Oax0L+9IgGxctECIWTk
         oxP85H8oIIaNusdgTANCHM8ZhKcBIhBNbVKO/zoM8Tw/+Fx4TkcPO10rYkE4DIuTsuCc
         9SsPDklneX4v+tt0Ca2IRABNDz9nAgCMiJdMsn/2EPKEpX5rB2+scv8/unNY0PlkhmaA
         bJkMuW6REGmRGX+nGFMLA4y7OjJ3jZNpUdM+9QxB1DWysV2wTvENcz4P4kfq/UgQiyqu
         tqfObNC5yuK9sfF9AFNEioJyf/AyfLMwvQcqdXnnFIGsogxUmuKZiccp/tuuhBICkqU6
         cFhA==
X-Gm-Message-State: ACrzQf1TkLuFn47XQIFGieSSRDkLXNAuEKePp2l/9VReUhsnVJS1W7sN
        fb1si2lHmnv++QXQGE2uqN+z5GJihUL8zB/4nKOlckhgmK1hnZosy8QABE51dY5L0acLLarz4ND
        wOVuyznoD2IewfXtL
X-Received: by 2002:ac8:5058:0:b0:3a5:3cb0:959 with SMTP id h24-20020ac85058000000b003a53cb00959mr32919860qtm.123.1667988642846;
        Wed, 09 Nov 2022 02:10:42 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7zaE5m+054WqSltDiseEsHQRGbV23se1lE6TQwdYPc3zaWSm4fkB44f0GuQqZbDqR+b7Kc9w==
X-Received: by 2002:ac8:5058:0:b0:3a5:3cb0:959 with SMTP id h24-20020ac85058000000b003a53cb00959mr32919847qtm.123.1667988642628;
        Wed, 09 Nov 2022 02:10:42 -0800 (PST)
Received: from redhat.com ([185.195.59.52])
        by smtp.gmail.com with ESMTPSA id r4-20020ae9d604000000b006fa2b1c3c1esm10651656qkk.58.2022.11.09.02.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 02:10:42 -0800 (PST)
Date:   Wed, 9 Nov 2022 05:10:37 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost: fix range used in translate_desc()
Message-ID: <20221109051030-mutt-send-email-mst@kernel.org>
References: <20221108103437.105327-1-sgarzare@redhat.com>
 <20221108103437.105327-3-sgarzare@redhat.com>
 <CACGkMEuRnqxESo=V2COnfUjP5jGLTXzNRt3=Tp2x-9jsS-RNGQ@mail.gmail.com>
 <20221109081823.tg5roitl26opqe6k@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109081823.tg5roitl26opqe6k@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 09:18:23AM +0100, Stefano Garzarella wrote:
> On Wed, Nov 09, 2022 at 11:28:41AM +0800, Jason Wang wrote:
> > On Tue, Nov 8, 2022 at 6:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > 
> > > vhost_iotlb_itree_first() requires `start` and `last` parameters
> > > to search for a mapping that overlaps the range.
> > > 
> > > In translate_desc() we cyclically call vhost_iotlb_itree_first(),
> > > incrementing `addr` by the amount already translated, so rightly
> > > we move the `start` parameter passed to vhost_iotlb_itree_first(),
> > > but we should hold the `last` parameter constant.
> > > 
> > > Let's fix it by saving the `last` parameter value before incrementing
> > > `addr` in the loop.
> > > 
> > > Fixes: 0bbe30668d89 ("vhost: factor out IOTLB")
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > > 
> > > I'm not sure about the fixes tag. On the one I used this patch should
> > > apply cleanly, but looking at the latest stable (4.9), maybe we should
> > > use
> > > 
> > > Fixes: a9709d6874d5 ("vhost: convert pre sorted vhost memory array to interval tree")
> > 
> > I think this should be the right commit to fix.
> 
> Yeah, @Michael should I send a v2 with that tag?

Pls do.

> > 
> > Other than this
> > 
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > 
> 
> Thanks for the review,
> Stefano

