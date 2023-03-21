Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1AA36C2EFF
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 11:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjCUKaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 06:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCUKak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 06:30:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD1347411
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 03:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679394571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q4qiSZ71h68FYqRH2YORiQ8Fl8qdx1/lqUe22isJ5n4=;
        b=hh3nnAOX9KOQrrPtMrvWwf2iqpzSsRl1R4TM6Do1MoiZoBeC6DiMYM2ZFiwy2fc443PMFn
        m6mAC4NPS5bQG49dj4L804Ynj6IxCV52Hx8uQ9HK89S4gg0Ivvmh8ccO4oLcSJQuQoJqkQ
        6c2d06Ua1DcM5PpycP1/+DNOUZRtkSw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-A8EUgTkuPUC__GeCT-IvpQ-1; Tue, 21 Mar 2023 06:29:29 -0400
X-MC-Unique: A8EUgTkuPUC__GeCT-IvpQ-1
Received: by mail-qt1-f200.google.com with SMTP id u1-20020a05622a198100b003e12a0467easo3456620qtc.11
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 03:29:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679394568;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q4qiSZ71h68FYqRH2YORiQ8Fl8qdx1/lqUe22isJ5n4=;
        b=3VTP8KRpv/pWD2lSAzABV/7/K2CtDAi3KWZ/J4cItfvdYXQDPqA16gukLQzxI1+iXI
         kJ49VjxilsHc0NuMUtb16v58c29cR2+QXldnxx93SjoUl+ymMGOd3wtcRKs4qMc26ONK
         GGe7LtDiy09MKQ86r3eUtMtrzdeg6lTsC4VLh8kPc7SfW6fow/efVZVvj5ckc+aheRyE
         HW3fCWobqmGFdSglQVuLrEmxqkrhLXgVin3cHnbPlNWO9Njf5cXcdUipk6fEKKnvPAEN
         6YStYrl7imP6LJhY8XhVY5HTLE5vYW46du3+sTRanrYALMAvM0cnfsnqHEMhIiUfHK3v
         /pUQ==
X-Gm-Message-State: AO0yUKWv74Qkf6y+f2K1/bOqNj4p2Pywj7pcBhIQ+2QEQogXaBTFl5sL
        DGRPq7hUW5Fod18mW8AFbaVLkXXLcmE1a4mHtKylJgLBbOyCkc7Q4GKO0atj4BkzXcBS0PTUKYm
        C5sfj3NVLDOgsm+phRlHNE9dc
X-Received: by 2002:ac8:7f0d:0:b0:3bf:c458:5bac with SMTP id f13-20020ac87f0d000000b003bfc4585bacmr3467230qtk.0.1679394567946;
        Tue, 21 Mar 2023 03:29:27 -0700 (PDT)
X-Google-Smtp-Source: AK7set9ukZnbT6cY9R6c2LFL5SoRaUhpcCK+iO6QjBqS1vjs1Ts0WuVq+CjToH+EBN2B8g2hZK1GUA==
X-Received: by 2002:ac8:7f0d:0:b0:3bf:c458:5bac with SMTP id f13-20020ac87f0d000000b003bfc4585bacmr3467214qtk.0.1679394567654;
        Tue, 21 Mar 2023 03:29:27 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-19.dyn.eolo.it. [146.241.244.19])
        by smtp.gmail.com with ESMTPSA id q6-20020ac87346000000b003df5fd89e21sm4713579qtp.0.2023.03.21.03.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 03:29:27 -0700 (PDT)
Message-ID: <33b5d0dd04c86e4186c9fb8236b874c6d8c11e65.camel@redhat.com>
Subject: Re: [PATCH v2 1/3] net: mvpp2: classifier flow fix fragmentation
 flags
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sven Auhagen <Sven.Auhagen@voleatech.de>, netdev@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com
Date:   Tue, 21 Mar 2023 11:29:23 +0100
In-Reply-To: <20230319060038.t2s7abqs4umelcr4@Svens-MacBookPro.local>
References: <20230319060038.t2s7abqs4umelcr4@Svens-MacBookPro.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2023-03-19 at 07:00 +0100, Sven Auhagen wrote:
> Add missing IP Fragmentation Flag.
>=20
> Change from v1:
> 	* Added the fixes tag
> 	* Drop the MVPP22_CLS_HEK_TAGGED change from the patch
>=20
> Fixes: f9358e12a0af ("net: mvpp2: split ingress traffic into multiple flo=
ws")
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

The code LGTM, but this series has few formal glitches. It would be
great if you could address them:
- please add a cover letter
- insert a '---' separator between the commit message and the diff
itself
- move the changelog after the '---' separator
- your SoB tag uses lowercase case for the email address, while the
sender email address uses camel case and checkpatch complains (for no
reasons, but you can avoid that using camel case in the SoB, too.

Thanks,

Paolo

