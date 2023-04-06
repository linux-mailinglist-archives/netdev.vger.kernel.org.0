Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8665B6DA233
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 22:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbjDFUHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 16:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238238AbjDFUH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 16:07:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41648903F
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 13:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680811600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UhmlLvqF6da/QeN+M/XiLghLgzDAr8RSwO2FXFQLnAM=;
        b=fo+s4t3gHydQtSYukR101dvYEjiPtJ11UYRHI7eJum/+q5r5qacYSxpbcVYudPIM755f1b
        bwnRL3XjTQr4bMDxIGVJ/TKMnqb1JEYD965h7i+hYEogE8GRUU48yK4OEga0kctUfXYn1s
        7unWkZEP3DOUmYt3bXoIPYTD1AHc5yU=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-nK1xJpMCMWOc9hrqH4tX1w-1; Thu, 06 Apr 2023 16:06:39 -0400
X-MC-Unique: nK1xJpMCMWOc9hrqH4tX1w-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3e385709826so3669151cf.0
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 13:06:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680811599; x=1683403599;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UhmlLvqF6da/QeN+M/XiLghLgzDAr8RSwO2FXFQLnAM=;
        b=n+7/6OEDq5BD7l5W8nZr78CN6RaU7+YYhl+DuMWzARl9R3EXAjvbZfLpLxJ9PwWbPT
         +Tth9z/DyS1GpYNnyd3gmeV1bxPH40LYw7PnCvXLCfGKdHl+/FRBWYYP5DrLYGSEGb0j
         U1HLmpfrtofQHWd269JW9IzdNv52M8kUAU9gGKPIfbdKLELCuFQDhvH/DAV1hOMIC2nu
         8NEaaa1jkI65YnVxejZZ/qmYClCs9dvqqKHS1bAHrmLlpdF5NynPqWh7QPknKSVyTv4Z
         q7JbNdrkjH2o/W/huZZwI3j+VjPLZxdm5c2rOr300SQlMdttYekLWmQ191yL1UnPVZ8w
         7Kwg==
X-Gm-Message-State: AAQBX9eYJ+O1DMiJC9ojmAXjLGPlUJebX2jATXVwIZ6l81fDA9wbwSfV
        oPWg7Tie/JWpS60i+UIpMvuNWRNWD0AV1IdOJcPPuQGV0Wy8+lu8HHtTJoXsqwcCjLCTgAm3jdP
        4hU4kJxe0azaKrAZe
X-Received: by 2002:ac8:4e81:0:b0:3e6:707e:d3b1 with SMTP id 1-20020ac84e81000000b003e6707ed3b1mr367777qtp.0.1680811598751;
        Thu, 06 Apr 2023 13:06:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZPAT8/mfBeygZApOE+HH1z1q+F581N5hs+GA2lzop1GnVCSbhthuavSrBaVKK/62Zf7anwGQ==
X-Received: by 2002:ac8:4e81:0:b0:3e6:707e:d3b1 with SMTP id 1-20020ac84e81000000b003e6707ed3b1mr367746qtp.0.1680811598535;
        Thu, 06 Apr 2023 13:06:38 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-227-151.dyn.eolo.it. [146.241.227.151])
        by smtp.gmail.com with ESMTPSA id m8-20020ac866c8000000b003e398d00fabsm647030qtp.85.2023.04.06.13.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 13:06:38 -0700 (PDT)
Message-ID: <7ab4950ea08e89fe0481a08a8b49de4291b9451f.camel@redhat.com>
Subject: Re: [PATCH net-next 2/3] ksz884x: remove unused #defines
From:   Paolo Abeni <pabeni@redhat.com>
To:     Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Date:   Thu, 06 Apr 2023 22:06:35 +0200
In-Reply-To: <ZC7vgRFmqAjGQyss@kernel.org>
References: <20230405-ksz884x-unused-code-v1-0-a3349811d5ef@kernel.org>
         <20230405-ksz884x-unused-code-v1-2-a3349811d5ef@kernel.org>
         <454a61709e442f717fbde4b0ebb8b4c3fdfb515e.camel@redhat.com>
         <20230406090017.0fc0ae34@kernel.org> <ZC7vgRFmqAjGQyss@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-04-06 at 18:12 +0200, Simon Horman wrote:
> On Thu, Apr 06, 2023 at 09:00:17AM -0700, Jakub Kicinski wrote:
> > On Thu, 06 Apr 2023 15:37:36 +0200 Paolo Abeni wrote:
> > > On Wed, 2023-04-05 at 10:39 +0200, Simon Horman wrote:
> > > > Remove unused #defines from ksz884x driver.
> > > >=20
> > > > These #defines may have some value in documenting the hardware.
> > > > But that information may be accessed via scm history. =20
> > >=20
> > > I personally have a slight preference for keeping these definitions i=
n
> > > the sources (for doc purposes), but it's not a big deal.=20
> > >=20
> > > Any 3rd opinion more then welcome!
> >=20
> > I had the same reaction, FWIW.
> >=20
> > Cleaning up unused "code" macros, pure software stuff makes perfect
> > sense. But I feel a bit ambivalent about removing definitions of HW
> > registers and bits.
>=20
> I guess that it two down-votes for removing the #defines.
>=20
> Would it be acceptable if I reworked the series to only remove
> the dead code - which would leave only subset of patch 3/3 ?

I would be fine with that.

Thanks!

Paolo

