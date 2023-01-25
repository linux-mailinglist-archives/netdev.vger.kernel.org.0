Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D6B67C096
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 00:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjAYXGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 18:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjAYXGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 18:06:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451B25EFBF
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 15:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674687941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0E7KcbC7nAQkSnECf38pK6uqYgbPRnEkq8adYGaMkso=;
        b=ZGvc5SJZjl9f4MBcjzVV55wmLDeSjD2qhuF3DwXrHUkZaRBwYVFU3qbSCgOfXD26BjiZVI
        X64oDyx3PldlIj14Sh3d5XO032i8bp/9/qlL30OwqzUysvAaYpVEWN5E6+H8hliBSBp4au
        SI0Qth29hPou1zYisqhddgL9BxwhcIc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-501-SWmQm03RPRiMP6ZuHgxzJA-1; Wed, 25 Jan 2023 18:05:40 -0500
X-MC-Unique: SWmQm03RPRiMP6ZuHgxzJA-1
Received: by mail-qv1-f71.google.com with SMTP id r10-20020ad4522a000000b004d28fcbfe17so112175qvq.4
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 15:05:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0E7KcbC7nAQkSnECf38pK6uqYgbPRnEkq8adYGaMkso=;
        b=hle9WZSODNEuwcyytFlMBCHH02Nob90OjHKmLdQWbDeBAaihKLtZ/T+4PItCW/kWmX
         KXWjIEakjQNRnF8M5rfx6EEsKmOVnjSEm1fEa1fpbXS2eabevpR6UkgXzx9ZdM2U2rnX
         B2J+6uErlezG0ybOPlI2/BQftaviffkdEkXUyrAPRZok5H0G6/4ETpTCcji5yxHD+mMd
         Z4px36x9fAllmOOWIteTx9sAm/DpHTAhuUBBpG3tdC6sV0WXXu271RGYYcxRq8l7l5sZ
         D0hkg3CUDUkGvtGXVW5gz/tS/RItWHEO2aGPEADnVrsyPm5PGfa6UyReAyffhAX9wmEn
         ts+g==
X-Gm-Message-State: AFqh2kpbV18mx75e9/54ZlVR+5wZ9FScobLMUx10lqBppsZYE8qUf3g5
        595D62ncI0qo/fbF70PF4Crgmpjdg7Sx0t76464cedQ1ay5B6vG64/ozbnfKjkO3jelj7O+75cN
        0z30tHQgmkeKM+6pG
X-Received: by 2002:ac8:65cb:0:b0:3a8:741:1c45 with SMTP id t11-20020ac865cb000000b003a807411c45mr43925719qto.42.1674687939603;
        Wed, 25 Jan 2023 15:05:39 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsSAzZA5c5S/uHo68AOfu/JMv7FyIKkI2mzAUtVrjXzXEVl79UXidL3o/wwCcmdDWO1t9aZYQ==
X-Received: by 2002:ac8:65cb:0:b0:3a8:741:1c45 with SMTP id t11-20020ac865cb000000b003a807411c45mr43925702qto.42.1674687939354;
        Wed, 25 Jan 2023 15:05:39 -0800 (PST)
Received: from 2603-7000-9400-fe80-0000-0000-0000-0318.res6.spectrum.com (2603-7000-9400-fe80-0000-0000-0000-0318.res6.spectrum.com. [2603:7000:9400:fe80::318])
        by smtp.gmail.com with ESMTPSA id z10-20020ac8430a000000b003b6325dfc4esm4171493qtm.67.2023.01.25.15.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 15:05:38 -0800 (PST)
Message-ID: <b2079e8c46815eedf40987e3c967e356242e3c52.camel@redhat.com>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
From:   Simo Sorce <simo@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Apoorv Kothari <apoorvko@amazon.com>, sd@queasysnail.net,
        borisp@nvidia.com, dueno@redhat.com, fkrenzel@redhat.com,
        gal@nvidia.com, netdev@vger.kernel.org, tariqt@nvidia.com
Date:   Wed, 25 Jan 2023 18:05:38 -0500
In-Reply-To: <20230125144351.30d1d5ab@kernel.org>
References: <Y8//pypyM3HAu+cf@hog>
         <20230125184720.56498-1-apoorvko@amazon.com>
         <20230125105743.16d7d4c6@kernel.org>
         <3e9dc325734760fc563661066cd42b813991e7ce.camel@redhat.com>
         <20230125144351.30d1d5ab@kernel.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

On Wed, 2023-01-25 at 14:43 -0800, Jakub Kicinski wrote:
> On Wed, 25 Jan 2023 16:17:26 -0500 Simo Sorce wrote:
> > > We're talking about the Tx direction, the packets are queued to the
> > > lower layers of the stack unencrypted, and get encrypted by the NIC.
> > > Until TCP gets acks for all the data awaiting offloaded crypto - we
> > > must hold onto the keys. =20
> >=20
> > Is this because the NIC does not cache the already encrypted outgoing
> > packets?
>=20
> NIC can't cache outgoing packets, there's too many and NIC is supposed
> to only do crypto. TCP stack is responsible for handing rtx.
>=20
> > If that is the case is it _guaranteed_ that the re-encrypted packets
> > are exactly identical to the previously sent ones?
>=20
> In terms of payload, yes. Modulo zero-copy cases we don't need to get
> into.
>=20
> > If it is not guaranteed, are you blocking use of AES GCM and any other
> > block cipher that may have very bad failure modes in a situation like
> > this (in the case of AES GCM I am thinking of IV reuse) ?
>=20
> I don't know what you mean.

The question was if there is *any* case where re-transmission can cause
different data to be encrypted with the same key + same IV

Simo.

--=20
Simo Sorce
RHEL Crypto Team
Red Hat, Inc



