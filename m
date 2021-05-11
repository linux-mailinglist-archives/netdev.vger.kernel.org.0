Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AA537A3E3
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhEKJlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:41:02 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:54358 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhEKJlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 05:41:02 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 5B537800053;
        Tue, 11 May 2021 11:39:54 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 11 May 2021 11:39:54 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 11 May
 2021 11:39:53 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 60D1431805DA; Tue, 11 May 2021 11:39:53 +0200 (CEST)
Date:   Tue, 11 May 2021 11:39:53 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        "Willem de Bruijn" <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [PATCH net 1/4] net: fix double-free on fraglist GSO skbs
Message-ID: <20210511093953.GT40979@gauss3.secunet.de>
References: <e5d4bacef76ef439b6eb8e7f4973161ca131dfee.1620223174.git.pabeni@redhat.com>
 <CAF=yD-+BAMU+ETz9MV--MR5NuCE9VrtNezDB3mAiBQR+5puZvQ@mail.gmail.com>
 <d6665869966936b79305de87aaddd052379038c4.camel@redhat.com>
 <CAF=yD-++8zxVKThLnPMdDOcR5Q+2dStne4=EKeKCD7pVyEc8UA@mail.gmail.com>
 <5276af7f06b4fd72e549e3b5aebdf41bef1a3784.camel@redhat.com>
 <CAF=yD-+XLDTzzBsPsMW-s9t0Ur3ux8w93VOAyHJ91E_cZLQS7w@mail.gmail.com>
 <78da518b491d0ad87380786dddf465c98706a865.camel@redhat.com>
 <20210506141739.0ab66f99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6f4db46541880179766a30cf6d5e47f44190b98d.camel@redhat.com>
 <3e41198f79b4d63812e3862ca688507bf3f7d65d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3e41198f79b4d63812e3862ca688507bf3f7d65d.camel@redhat.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 05:37:58PM +0200, Paolo Abeni wrote:
> 
> It's taking [much] more than expected, as it turned out that thare are
> still a number of case where the tx csum is uncorrect.
> 
> If the traffic comes from a veth we don't have a valid th->csum value
> at GRO time, setting ip_summed to CHECKSUM_UNNECESSARY - as the current
> code does - looks wrong.
> @Steffen: I see in the original discussion about GRO_FRAGLIST
> introduction that you wanted the GRO packets to be CHECKSUM_UNNECESSARY
> to avoid csum modification in fwd path. I guess that choice was mostily
> due performance reasons, to avoid touching the aggregated pkts header
> at gso_segment_list time, but it looks like it's quite bug prone. If
> so, I'm unsure the performance gain is worty.

Yes, that was for performance reasons. We don't mangle the packets
with fraglist GRO, so the checksum should be still correct when
doing GSO.

> I propose to switch to
> CHECKSUM_PARTIAL. Would you be ok with that?

If there are cases where CHECKSUM_UNNECESSARY is problematic,
then yes, let's switch to CHECKSUM_PARTIAL.

Thanks for doing this Paolo!
