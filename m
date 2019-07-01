Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D69F65BCC1
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 15:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbfGANWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 09:22:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbfGANWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 09:22:09 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 83FCA81DFC;
        Mon,  1 Jul 2019 13:22:03 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-215.ams2.redhat.com [10.36.116.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 522866F923;
        Mon,  1 Jul 2019 13:21:58 +0000 (UTC)
Date:   Mon, 1 Jul 2019 15:21:57 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Andreas Steinmetz <ast@domdv.de>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] macsec: add brackets and indentation after
 calling macsec_decrypt
Message-ID: <20190701132157.GA15622@bistromath.localdomain>
References: <4932e7da775e76aa928f44c19288aa3a6ec72313.camel@domdv.de>
 <CA+FuTSfmi3XCTR5CCiUk180XTy69mJsL4Y_5zStP727b=woWJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+FuTSfmi3XCTR5CCiUk180XTy69mJsL4Y_5zStP727b=woWJQ@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 01 Jul 2019 13:22:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-06-30, 22:05:41 -0400, Willem de Bruijn wrote:
> On Sun, Jun 30, 2019 at 4:48 PM Andreas Steinmetz <ast@domdv.de> wrote:
> >
> > At this point, skb could only be a valid pointer, so this patch does
> > not introduce any functional change.
> 
> Previously, macsec_post_decrypt could be called on the original skb if
> the initial condition was false and macsec_decrypt is skipped. That
> was probably unintended. Either way, then this is a functional change,
> and perhaps a bugfix?

Ouch, I missed that when Andreas sent me that patch before. No, it is
actually intended. If we skip macsec_decrypt(), we should still
account for that packet in the InPktsUnchecked/InPktsDelayed
counters. That's in Figure 10-5 in the standard.

Thanks for catching this, Willem. That patch should only move the
IS_ERR(skb) case under the block where macsec_decrypt() is called, but
not move the call to macsec_post_decrypt().


> > Signed-off-by: Andreas Steinmetz <ast@domdv.de>
> >
> > --- a/drivers/net/macsec.c      2019-06-30 22:05:17.785683634 +0200
> > +++ b/drivers/net/macsec.c      2019-06-30 22:05:20.526171178 +0200
> > @@ -1205,21 +1205,22 @@
> >
> >         /* Disabled && !changed text => skip validation */
> >         if (hdr->tci_an & MACSEC_TCI_C ||
> > -           secy->validate_frames != MACSEC_VALIDATE_DISABLED)
> > +           secy->validate_frames != MACSEC_VALIDATE_DISABLED) {
> >                 skb = macsec_decrypt(skb, dev, rx_sa, sci, secy);
> >
> > -       if (IS_ERR(skb)) {
> > -               /* the decrypt callback needs the reference */
> > -               if (PTR_ERR(skb) != -EINPROGRESS) {
> > -                       macsec_rxsa_put(rx_sa);
> > -                       macsec_rxsc_put(rx_sc);
> > +               if (IS_ERR(skb)) {
> > +                       /* the decrypt callback needs the reference */
> > +                       if (PTR_ERR(skb) != -EINPROGRESS) {
> > +                               macsec_rxsa_put(rx_sa);
> > +                               macsec_rxsc_put(rx_sc);
> > +                       }
> > +                       rcu_read_unlock();
> > +                       return RX_HANDLER_CONSUMED;
> >                 }
> > -               rcu_read_unlock();
> > -               return RX_HANDLER_CONSUMED;
> > -       }
> >
> > -       if (!macsec_post_decrypt(skb, secy, pn))
> > -               goto drop;
> > +               if (!macsec_post_decrypt(skb, secy, pn))
> > +                       goto drop;
> > +       }
> >
> >  deliver:
> >         macsec_finalize_skb(skb, secy->icv_len,
> >

-- 
Sabrina
