Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E526544F2
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 17:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiLVQNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 11:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiLVQNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 11:13:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1763D266C
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 08:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671725537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBEp6O2/jOt5ENq0WkUw1TPazybtHKFIgxfdd4vI5bE=;
        b=hmx3HWDQJN9eL+lL6Mn01Kowhyx9DqNRdYP20CBX+rSyp7OfRfb2IR4Nbfaf3ht1XQ7gOK
        l+1IMJx7S7Jin6jzTzMdu9vVfs8XzFZrAgoPLXr153cBlBa5oseLqrq0h62mFNtcVgLO3o
        x7meCZ0KxZBfeP2Rod9uMATUdnNp5mU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-298-0U0UBjtbORKzSULgLjTu1A-1; Thu, 22 Dec 2022 11:12:15 -0500
X-MC-Unique: 0U0UBjtbORKzSULgLjTu1A-1
Received: by mail-wm1-f72.google.com with SMTP id m38-20020a05600c3b2600b003d1fc5f1f80so2520834wms.1
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 08:12:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BBEp6O2/jOt5ENq0WkUw1TPazybtHKFIgxfdd4vI5bE=;
        b=3uEodgo+cvko9Pgzku80XmHiEptWLsJkPV4GCGiIPddrl/+3wVd4PgAdQH+KF5Zy9S
         Pi/dh6Zknpj0jhSUJb9jiTp6MypnnEdQ4kZk9PSqjut8cE6YrMRbppWGqp03J1p2Zng5
         X2Td4DA35aTFGijMvLQpXcQjzrD7qHoswDoVFH0h2We2TewXRygRyq/oX/LvzAwLwBbC
         wM6fjJYtFZEQmt619jY/S9nh/ZqZb7FvMGO2sh6viXOGRB4YU7BxaehqUL3n/t4hNN37
         Zne9HzmJxZURmCWb+P7i/lYUyNqKncQHJHcLysTUBZJ2T3NvWrxt/e1H9BjclUZ95Cef
         9EFw==
X-Gm-Message-State: AFqh2kpFklXLfGuUkwW047K67CzlwvgukZ0BeuL2Lcraftwu+hbBPJ/o
        jbKekRMW8KUWjmChGlEEEGOkC8HsspPR+gyA4pvvsssRaDuTYCObRnOASwczBeRfRbUEQvZS+En
        Sh5G2qyU3pJlF0JPZ
X-Received: by 2002:a05:600c:1e10:b0:3d1:f496:e25f with SMTP id ay16-20020a05600c1e1000b003d1f496e25fmr5085967wmb.16.1671725533952;
        Thu, 22 Dec 2022 08:12:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXslzwMNluVox2+651CRytf+LjdZRrVoHW4jcmdQz59I9rt2BiIEP9IWKIjZ3C6PjnfTgw8X9A==
X-Received: by 2002:a05:600c:1e10:b0:3d1:f496:e25f with SMTP id ay16-20020a05600c1e1000b003d1f496e25fmr5085949wmb.16.1671725533751;
        Thu, 22 Dec 2022 08:12:13 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003d1d5a83b2esm6734980wmq.35.2022.12.22.08.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 08:12:12 -0800 (PST)
Message-ID: <08d4d56b4b2ef422e2724e99a0a4d21baed7c9b5.camel@redhat.com>
Subject: Re: [PATCH net 0/8] Add support for two classes of VCAP rules
From:   Paolo Abeni <pabeni@redhat.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     UNGLinuxDriver@microchip.com, Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>
Date:   Thu, 22 Dec 2022 17:12:10 +0100
In-Reply-To: <cc41ccf443b1f2c7a4cb5e247dabfa53a6674226.camel@microchip.com>
References: <20221221132517.2699698-1-steen.hegelund@microchip.com>
         <0efd4a7072fb90cc9bc9992b00d9ade233a38de1.camel@redhat.com>
         <cc41ccf443b1f2c7a4cb5e247dabfa53a6674226.camel@microchip.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-12-22 at 16:02 +0100, Steen Hegelund wrote:
> On Thu, 2022-12-22 at 15:22 +0100, Paolo Abeni wrote:
> > Despite the 'net' target, this looks really like net-next material as
> > most patches look like large refactor. I see there are a bunch of fixes
> > in patches 3-8, but quite frankly it's not obvious at all what the
> > refactors/new features described into the commit messages themself
> > really fix.
> 
> Yes the patches 3-8 is the response to Michael Walles observations on LAN966x
> and Jakubs Kicinski comment (see link), but the description in the commits may
> not be that clear, in the sense that they do not state one-to-one what the
> mitigation is.
> 
> See https://lore.kernel.org/netdev/20221209150332.79a921fd@kernel.org/
> 
> So essentially this makes it possible to have rules that are always in the VCAP
> HW (to make the PTP feature work), even before the TC chains have been
> established (which was the problem that Michael encountered).
> 
> I still think this a net submission, since it fixes the problem that was
> observed in the previous netnext window.
> 
> But I will rephrase the reasoning in a V2 to hopefully make that more
> understandable.
> 
> If you still think it is better to post this in the upcoming net-next window, I
> am also OK with that.

IMHO this series is quite too invasive for net, especially considering
it will possibly land into the Linus tree with a timeframe promising a
large latency in response to any problem.

If there is any kind of available workaround to address the issue
(comprising disabling h/w offload) I *think* net-next would be a better
option.

Cheers,

Paolo

