Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4C8438935
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 15:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhJXNlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 09:41:01 -0400
Received: from smtp.skoda.cz ([185.50.127.80]:37763 "EHLO smtp.skoda.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230021AbhJXNlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 09:41:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=skoda.cz; s=plzenaugust2021; c=relaxed/simple;
        q=dns/txt; i=@skoda.cz; t=1635082718; x=1635687518;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BYPgQyeVIKCDIag13+U1Hy1RdQ0GUGzTpzfw/AH+SPQ=;
        b=Qa7M+Y923n0A7/R+wUEO1wnNcWDX1Q06ElTCK7Ea95ClytAZLcoi57bRKvHw6FIK
        ATKmjxrnBvj1Hd0hg1rgbLUbHXi7r65BvW5+AUR9DxjfjJxSaIVePww9jgu0BAtN
        +5+CJdWe+/oueYq/VgZsA2qRILpSnkNULt2GV2Nbzx/qu290MTsrI9W9DMCbflkq
        nJnlS3N9ptxgZZzsNk8/SPloozJju7o5Q34Lrdr+Ygzq+KRDA6iE8YMeH63ZQwFo
        E834Bno+pzgytQErgTasppvR4Tlc3hhtf8InLvyyCSpXNrNrm8Uvsc+snIZqDbdF
        djcFEsv4TqDZ0ydxDORmBQ==;
X-AuditID: 0a2a0137-1666f70000011b28-a6-617561dc65c3
Received: from trnn1532h (ELCN1443.skoda.cz [10.99.100.52])
        (using TLS with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by smtp.skoda.cz (Mail Gateway) with SMTP id F8.F9.06952.DD165716; Sun, 24 Oct 2021 15:38:38 +0200 (CEST)
Date:   Sun, 24 Oct 2021 15:38:40 +0200
From:   Cyril Strejc <cyril.strejc@skoda.cz>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: multicast: calculate csum of looped-back and
 forwarded packets
Message-ID: <20211024133807.GA1112319@trnn1532h>
References: <CA+FuTSdqS2gpdoXcyo3URn5A=yYCuW55b=grFkmiMbX2hzXcfg@mail.gmail.com>
 <20211023232608.1095185-1-cyril.strejc@skoda.cz>
 <CAF=yD-K_-i1wCaRg4VqocMqL9m7OrcCy3AXVn4d8k7yXg6yz5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-K_-i1wCaRg4VqocMqL9m7OrcCy3AXVn4d8k7yXg6yz5g@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42LhSk4x0b2XWJpocO01m8Wc8y0sFhe29bFa
        HFsgZrH45wYmBxaPLStvMnnsnHWX3WPTqk42j8+b5AJYorhsUlJzMstSi/TtErgyns/6zFpw
        k6Pi6OVtLA2ML9i6GDk5JARMJBqufGAEsYUEpjJJrJgWDWKzCKhK9M3azgRiswloScztnMwM
        YosImElsPHKDBcRmFqiQeP3+HZDNwSEsECXx9VUtiMkrYCDx/WsExMRTjBJ3PiWD2LwCghIn
        Zz6B6tSSuPHvJRNIObOAtMTyfxwgYU6BQInnGw8wT2DknYWkYxaSjlkIHQsYmVcx8hbnlhTo
        FWfnpyTqJVdtYgQFlhaj+Q7GG6fcDjEycTAeYpTgYFYS4bX5VJIoxJuSWFmVWpQfX1Sak1p8
        iFGag0VJnNd9rk6ikEB6YklqdmpqQWoRTJaJg1OqgTGgtlJy+b7iP5OPHvESveCQNm2BwEMH
        g9k1EV8u/Nty+2c75x3ey3Hm1+c1Zac9kq73+lZ/J22vwSHG6UZu5/fxNpvMmT17VRTXQoYH
        Tq/efxf9NXm3a2as0r0nG8y4PTe2mcjGmv+dse6dyvEk/rmLjffO5u+avoNJrya9LfzaIp4L
        GTUBrsFKLMUZiYZazEXFiQAym4TBGgIAAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-23T22:41:06-0400, Willem de Bruijn wrote:
> >
> > Alternatively, we could solve the CHECKSUM_NONE case by a simple,
> > practical and historical compatible "TX->RX translation" of ip_summed
> > in dev_loopback_xmit(), which keeps CHECKSUM_PARTIAL and leaves
> > __skb_checksum_validate_needed() as is:
> >
> >         if (skb->ip_summed == CHECKSUM_NONE)
> >                 skb->ip_summed = CHECKSUM_UNNECESSARY;
> >
> > or:
> >         if (skb->ip_summed != CHECKSUM_PARTIAL)
> >                 skb->ip_summed = CHECKSUM_UNNECESSARY;
> 
> Based on the idea that these packets are fully checksummed, so even if
> they loop to the tx path again with ip_summed CHECKSUM_UNNECESSARY,
> they will not cause the bug that you originally reported?
> 

It won't cause the bug. The original bug is caused solely by
CHECKSUM_PARTIAL being unconditionally translated to
CHECKSUM_UNNECESSARY in dev_loopback_xmit(). Adding the condition to
keep CHECKSUM_PARTIAL solves the issue.

> Yes, that looks like a nice solution.

I will double-check and send PATCH v2 to this e-mail thread.

