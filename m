Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1A54E60B6
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 09:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349046AbiCXI5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 04:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237920AbiCXI5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 04:57:21 -0400
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE4D9D074;
        Thu, 24 Mar 2022 01:55:49 -0700 (PDT)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id BB8B5E491E9;
        Thu, 24 Mar 2022 09:55:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1648112146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+woDWFZcPgqPY0chl6IjyANJVAaopdil00T5QCbF7E=;
        b=InO0yzyZU3QaeY3J8ths/cL9YOwpfDv9uIL616GmIlQRjsvz8ItHOgN2zT40/Y8FWsRSgP
        Kppy0V5Ft8HOz3rqo4NleRyvSAa1mMIR41RFSwE19LDUNek97TyGDRKmKZeaTpkkovO202
        1p5wkp/jtBk8rE5/zx6jClPW0qttBkQ=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Halil Pasic <pasic@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Toke =?ISO-8859-1?Q?H=F8iland=2DJ=F8rgensen?= <toke@toke.dk>,
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
Date:   Thu, 24 Mar 2022 09:55:44 +0100
Message-ID: <5806580.lOV4Wx5bFT@natalenko.name>
In-Reply-To: <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
References: <1812355.tdWV9SEqCh@natalenko.name> <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
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

Hello.

On st=C5=99eda 23. b=C5=99ezna 2022 18:27:21 CET Linus Torvalds wrote:
> On Wed, Mar 23, 2022 at 12:19 AM Oleksandr Natalenko
> <oleksandr@natalenko.name> wrote:
> > These commits appeared in v5.17 and v5.16.15, and both kernels are
> > broken for me. I'm pretty confident these commits make the difference
> > since I've built both v5.17 and v5.16.15 without them, and it fixed
> > the issue.
>=20
> Can you double-check (or just explicitly confirm if you already did
> that test) that you need to revert *both* of those commits, and it's
> the later "rework" fix that triggers it?

I can confirm that if I revert aa6f8dcbab47 only, but leave ddbd89deb7d3 in=
 place, AP works. So, it seems that the latest "rework" triggers the issue =
for me.

Thanks.

=2D-=20
Oleksandr Natalenko (post-factum)


