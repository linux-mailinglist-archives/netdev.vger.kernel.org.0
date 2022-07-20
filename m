Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8DD757B182
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiGTHPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbiGTHPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:15:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2E6E24BEA
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658301333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SMUVaPglTlK65G+/E3LhTM8Mfs/GIAQi7/iblHbTRlo=;
        b=L8sqjh2TudcolXXJYdWL9u1XMbVw+ajA5Bnm1EYyxS9iG7yWccG45FfcVFMr3gXOb12biW
        QN4glHPCAaO103foTj1l+L64Ymrq2xmJ3JH967Z6eMW23Iev2KL91Oib+ULJ1W1wQVHnAS
        aHDdg2QF28IZSygwb8vMSYkSqoG6APA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-uv8nxNwhNIGetmFwEKn3gQ-1; Wed, 20 Jul 2022 03:15:32 -0400
X-MC-Unique: uv8nxNwhNIGetmFwEKn3gQ-1
Received: by mail-wr1-f71.google.com with SMTP id a3-20020adfbc43000000b0021e46febb93so285714wrh.4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SMUVaPglTlK65G+/E3LhTM8Mfs/GIAQi7/iblHbTRlo=;
        b=3oOAg01EstpPZVroR3awj8Ym04H7F8/4JexZ8Rj5MzxDqLQ92MpdezCg+8g1gnKLkO
         UfUjYdYLJbesm8jCcYLeYCZ6atsiyh0DJkxrCyRk1VDLn12sxlHiKbQr2AR0Io6L8Hbk
         kOzkqMuZbN1KklGxmtjoaTRpGl1i2Tjfh/Ktl0oPC2HR8vjBnpacUaK+J9fgomXWH6Da
         OcOxUarpOvW3uKeaZMZi++0+RBW6a5mqSp0pg0tGA6ZPGzXaXNBbLtOtnr1hp8RZfepK
         VWcj2Lrl1ie3CUqohw8rgFJPk8JkuFwi1vZcZwmaCtZNz1ShKcbcWLIsB/tUq6GonPkM
         eN6w==
X-Gm-Message-State: AJIora+t+EPi6U3hUnpgotuPyPJfS0Kp3M2CWrT8U4WwGaX3+q1RgMIU
        U6CtX+Unuor2s5vmRnXVlv/LthY5qasBO8qdXoSzE1kugiIJtM7SbHa5If9q23TAJ11rFBsM4Wt
        Zx6+WvKSiZCsaYAeU
X-Received: by 2002:a5d:6c67:0:b0:21d:b9bf:5e12 with SMTP id r7-20020a5d6c67000000b0021db9bf5e12mr28533280wrz.127.1658301331185;
        Wed, 20 Jul 2022 00:15:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u+ViyEMqYUc/IQO0E4XrKgBIM1BPnt0iY6qv99AjW2typyyiyVKLoKB6lEkRc6WZHXyO97Jg==
X-Received: by 2002:a5d:6c67:0:b0:21d:b9bf:5e12 with SMTP id r7-20020a5d6c67000000b0021db9bf5e12mr28533269wrz.127.1658301330929;
        Wed, 20 Jul 2022 00:15:30 -0700 (PDT)
Received: from redhat.com ([2.55.47.4])
        by smtp.gmail.com with ESMTPSA id p22-20020a05600c431600b003a327b98c0asm1321138wme.22.2022.07.20.00.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 00:15:30 -0700 (PDT)
Date:   Wed, 20 Jul 2022 03:15:27 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Jason Wang <jasowang@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing
 support
Message-ID: <20220720031436-mutt-send-email-mst@kernel.org>
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <20220719172652.0d072280@kernel.org>
 <20220720022901-mutt-send-email-mst@kernel.org>
 <CACGkMEvFdMRX-sb7hUpEq+6e04ubehefr8y5Gjnjz8R26f=qDA@mail.gmail.com>
 <20220720030343-mutt-send-email-mst@kernel.org>
 <CAJs=3_DHW6qwjjx3ZBH2SVC0kaKviSrHHG+Hsh8-VxAbRNdP7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJs=3_DHW6qwjjx3ZBH2SVC0kaKviSrHHG+Hsh8-VxAbRNdP7A@mail.gmail.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 10:07:11AM +0300, Alvaro Karsz wrote:
> > Hmm. we currently (ab)use tx_max_coalesced_frames values 0 and 1 to mean tx
> napi on/off.
> > However I am not sure we should treat any value != 1 as napi on.
> >
> > I don't really have good ideas - I think abusing coalescing might
> > have been a mistake. But now that we are there, I feel we need
> > a way for userspace to at least be able to figure out whether
> > setting coalescing to 0 will have nasty side effects.
> 
> 
> So, how can I proceed from here?
> Maybe we don't need to use tx napi when this feature is negotiated (like Jakub
> suggested in prev. versions)?
> It makes sense, since the number of TX notifications can be reduced by setting
> tx_usecs/tx_max_packets with ethtool.


Hmm Jason had some ideas about extensions in mind when he
coded the current UAPI, let's see if he has ideas.
I'll ruminate on compatibility a bit too.

> > It's also a bit of a spec defect that it does not document corner cases
> > like what do 0 values do, are they different from 1? or what are max values.
> > Not too late to fix?
> 
> 
> I think that some of the corner cases can be understood from the coalescing
> values.
> For example:
> if rx_usecs=0 we should wait for 0 usecs, meaning that we should send a
> notification immediately.
> But if rx_usecs=1 we should wait for 1 usec.
> The case with max_packets is a little bit unclear for the values 0/1, and it
> seems that in both cases we should send a notification immediately after
> receiving/sending a packet.
> 
> 
> > So the spec says
> >         Device supports notifications coalescing.
> >
> > which makes more sense - there's not a lot guest needs to do here.
> 
> 
> Noted.
> 
> > parameters?
> 
>  
> I'll change it to "settings".
> 
> > why with dash here? And why not just put the comments near the fields
> > themselves?
> 
> 
> Noted.

