Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115EA4E7CB2
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbiCYTvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiCYTvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:51:44 -0400
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3A226B3A0;
        Fri, 25 Mar 2022 12:35:44 -0700 (PDT)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 41693E4E0DF;
        Fri, 25 Mar 2022 20:35:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1648236939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rLBMSUPo6jXDs4paj/eaDyrCRojZ9mFIvvnloZAG8yk=;
        b=HUri9bxCSlCyLJBpNkF4S2td2orUeRbu4l9z0J7Xc9HyZ3cTxDHCexUPIjSPSVKHAxd0mQ
        eQqW/2wjFoLwJYc7WDKU32po5DIGbENZn/lgaQvSZ/smVjpzYo1MRMfVsmMNRcsr6NANnJ
        4ibaaxojQmf/jlSzVt/jSOoWS3lQYjI=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Maxime Bizon <mbizon@freebox.fr>,
        Toke =?ISO-8859-1?Q?H=F8iland=2DJ=F8rgensen?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break ath9k-based AP
Date:   Fri, 25 Mar 2022 20:35:37 +0100
Message-ID: <8043549.T7Z3S40VBb@natalenko.name>
In-Reply-To: <CAHk-=wghZ3c4G2xjy3pR7txmdCnau21z_tidjfU2w0HO-90=sw@mail.gmail.com>
References: <1812355.tdWV9SEqCh@natalenko.name> <12981608.uLZWGnKmhe@natalenko.name> <CAHk-=wghZ3c4G2xjy3pR7txmdCnau21z_tidjfU2w0HO-90=sw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On p=C3=A1tek 25. b=C5=99ezna 2022 20:27:43 CET Linus Torvalds wrote:
> On Fri, Mar 25, 2022 at 12:26 PM Oleksandr Natalenko
> <oleksandr@natalenko.name> wrote:
> >
> > On p=C3=A1tek 25. b=C5=99ezna 2022 19:30:21 CET Linus Torvalds wrote:
> > > The reason the ath9k issue was found quickly
> > > is very likely *NOT* because ath9k is the only thing affected. No,
> > > it's because ath9k is relatively common.
> >
> > Indeed. But having a wife who complains about non-working Wi-Fi printer=
 definitely helps in finding the issue too.
>=20
> Well, maybe we should credit her in the eventual resolution (whatever
> it ends up being).
>=20
> Although probably not using that exact wording.

While Olha has already been Cc'ed here, I can definitely encourage her in p=
erson to provide Reported-by/Tested-by if needed :).

=2D-=20
Oleksandr Natalenko (post-factum)


