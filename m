Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6AD631812
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 02:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiKUBCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 20:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiKUBCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 20:02:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4AE2B184
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 17:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668992484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rXsfTFQRDnhK+uagajXB8h99nAVFJiQ0wRyOTdCGKlM=;
        b=TY4/l3jsvKuZEC2XePU8BAwSsKOUyg2w8SdtAx2dWZmnpKuFQi2fH5+yg8D1NhuAyVFzYr
        UfEb7Gf7GG/2H8hmvGIV+yckw6bLsy0Q6JQthITH88oLaJrVG9O/+GngbExZYT40LtZRky
        tKUjWk1dtkVQLnDCrjLDbpSOQ+8+R8g=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-651-GoAFvUJ2Of-_50HKccPaHQ-1; Sun, 20 Nov 2022 20:01:23 -0500
X-MC-Unique: GoAFvUJ2Of-_50HKccPaHQ-1
Received: by mail-ed1-f69.google.com with SMTP id m7-20020a056402430700b0045daff6ee5dso5773233edc.10
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 17:01:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rXsfTFQRDnhK+uagajXB8h99nAVFJiQ0wRyOTdCGKlM=;
        b=wHMEUhE2T40sD88KeBMqqp5b35X5sSsqK+BVkPhP2BQjw01IPHglZ5i+4eQUOWymId
         gVjPJyFbhT9zMdUjCZkKEiRIBsd5RfWIcHGycheIUq8F8qEi/t9UDt2TPW7y9I8ANmjl
         cidmwsmHDxCtZmyX6ftsNrtbg0ZX4HYQbJ6XzX0ZvqjLHzWWQkuMQ2YO35AZC04WKEQ1
         fH4pQJA1CDRwSTXtHGYeoOE9EmzwFG3A/7CLyUGSZ0QKNuWphLkSuW3yEIIuyg/xlG7N
         Gb724TJqOHWKmHWbG5WItBwbe35/dQ5qPU+Daw/hxRFIqNkgu1yHPgyd6e4Ng9k1arpa
         +HrA==
X-Gm-Message-State: ANoB5pmopKKOX0AZx0WMZKpK9XnDUJumq1kNycltPsOX3gA7IjTTIMcu
        8wPWxSdhNNguGbrYg6gaHh8e5kWRV65Y4m14qHfSMuGDTXZkqKVDrlJagy/A6AwtWi3wJl0EcNW
        uZUCFQPmXvn/rNYp2mTr7WMuWKtHg1wAS
X-Received: by 2002:a17:906:830d:b0:79e:5ea1:4f83 with SMTP id j13-20020a170906830d00b0079e5ea14f83mr175752ejx.372.1668992482532;
        Sun, 20 Nov 2022 17:01:22 -0800 (PST)
X-Google-Smtp-Source: AA0mqf42QYppf5NH1cqt0xyVFjIxmUaf+Lq0MxOv2aowlRXTyyHPvBMJhl9UHdaWtC1Y4EQUcRT4eJ5mOZxuU+7iW1Y=
X-Received: by 2002:a17:906:830d:b0:79e:5ea1:4f83 with SMTP id
 j13-20020a170906830d00b0079e5ea14f83mr175738ejx.372.1668992482393; Sun, 20
 Nov 2022 17:01:22 -0800 (PST)
MIME-Version: 1.0
References: <20221102151915.1007815-1-miquel.raynal@bootlin.com>
 <20221102151915.1007815-2-miquel.raynal@bootlin.com> <CAK-6q+iSzRyDDiNusXiRWvUsS5dSS5bSzAtNjSLTt6kgaxtbHg@mail.gmail.com>
 <20221118230443.2e5ba612@xps-13> <CAK-6q+jJKoFy359_Pd4_d+EfqLw4PTdG4F7H4u+URD=UKu9k6w@mail.gmail.com>
In-Reply-To: <CAK-6q+jJKoFy359_Pd4_d+EfqLw4PTdG4F7H4u+URD=UKu9k6w@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 20 Nov 2022 20:01:11 -0500
Message-ID: <CAK-6q+j_NOL0Q4MU4XOawx-54112Qdq1pKRVue8Ea13ScPDk3w@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/3] ieee802154: Advertize coordinators discovery
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Nov 20, 2022 at 7:57 PM Alexander Aring <aahringo@redhat.com> wrote:
...
> >
> > Yes this is how it is working, you only see PANs on one preamble at a
> > time. That's why we need to tell on which preamble we received the
> > beacon.
> >
>
> But then I don't know how you want to change the preamble while
> scanning? I know there are registers for changing the preamble and I
> thought that is a vendor specific option. However I am not an expert
> to judge if it's needed or not, but somehow curious how it's working.
>
> NOTE: that the preamble is so far I know (and makes sense for me)
> _always_ filtered on PHY side.

*I hope we are talking here about the same preamble.

- Alex

