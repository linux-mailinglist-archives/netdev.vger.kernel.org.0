Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C21DC5C84D
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 06:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfGBEZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 00:25:17 -0400
Received: from hermes.domdv.de ([193.102.202.1]:1710 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfGBEZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 00:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XZVo4ZgxqZaWmIAP0uKYKl5UpaSN9sI0tia+9wpaFtg=; b=cQfN4dWrlOjIJMG5AMYraCzJql
        3VMZckyXNEPT2oLhkcg4RhdoMku60jJfnnQAQMVv3DTm4j4Zd50wpdPbbuBk3zYL33EDxvHzYO06Y
        k/QZRigIpJH00YVIT7X+/64EwzUJ5uXhZjTVhi1NowrfShlfMftZYO1mLl/V2gLrELTs=;
Received: from [fd06:8443:81a1:74b0::212] (port=1236 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hiAL1-0005mJ-FA; Tue, 02 Jul 2019 06:24:15 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hiAL1-0006FW-A8; Tue, 02 Jul 2019 06:24:15 +0200
Message-ID: <94382bd8cfbf924779ce86cd6405331f70f65c27.camel@domdv.de>
Subject: Re: [PATCH net 2/2] macsec: fix checksumming after decryption
From:   Andreas Steinmetz <ast@domdv.de>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Date:   Tue, 02 Jul 2019 06:24:14 +0200
In-Reply-To: <CA+FuTSdzM3AFFrvANczVzXeRP0TVZ06K--GkmTZVAk-6SKQGxA@mail.gmail.com>
References: <1250be5ff32bc4312b3f3e724a8798db0563ea3c.camel@domdv.de>
         <CA+FuTSdzM3AFFrvANczVzXeRP0TVZ06K--GkmTZVAk-6SKQGxA@mail.gmail.com>
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2019-06-30 at 21:47 -0400, Willem de Bruijn wrote:
> On Sun, Jun 30, 2019 at 4:48 PM Andreas Steinmetz <ast@domdv.de>
> wrote:
> > Fix checksumming after decryption.
> > 
> > Signed-off-by: Andreas Steinmetz <ast@domdv.de>
> > 
> > --- a/drivers/net/macsec.c      2019-06-30 22:14:10.250285314 +0200
> > +++ b/drivers/net/macsec.c      2019-06-30 22:15:11.931230417 +0200
> > @@ -869,6 +869,7 @@
> > 
> >  static void macsec_finalize_skb(struct sk_buff *skb, u8 icv_len,
> > u8 hdr_len)
> >  {
> > +       skb->ip_summed = CHECKSUM_NONE;
> >         memmove(skb->data + hdr_len, skb->data, 2 * ETH_ALEN);
> >         skb_pull(skb, hdr_len);
> >         pskb_trim_unique(skb, skb->len - icv_len);
> 
> Does this belong in macset_reset_skb?

Putting this in macsec_reset_skb would then miss out the "nosci:" part
of the RX path in macsec_handle_frame().

