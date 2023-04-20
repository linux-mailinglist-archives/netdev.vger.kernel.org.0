Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A606E9960
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjDTQUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjDTQUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:20:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEDB2139
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682007565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P6imfKiL+T/hSmG2W1TUbtBQVDF8VHMuJe5BkrlXV4k=;
        b=Nj1ifKN+ujwZzBUH0H1W+TIFBoLraLR4s5ZfgNRHqCi58/vKoThjpEMkPD6vOz/QERsK7Z
        QChD8M44eUQb60kr70S2saAVm04c6eLw+z6F43QzN0yt9qDmirZOjxh6ACzQS5wvuZks9L
        ynNyFF+11KRR2+CZZq59OUTVDxvB1H4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-QynxwgtqPH62N9Mcw4L8jQ-1; Thu, 20 Apr 2023 12:19:24 -0400
X-MC-Unique: QynxwgtqPH62N9Mcw4L8jQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f080f46fb1so3291575e9.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:19:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682007562; x=1684599562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6imfKiL+T/hSmG2W1TUbtBQVDF8VHMuJe5BkrlXV4k=;
        b=Ecln+SY9hZZiWI3SdScUYPfjUEwUTEm18+7PHT9y2guVZR8/eDtjwRLL3ntGSKaJcE
         hgrW+IaYzZn5OJdZnFz/vgMfgtN7QvUFJOziX4Lw8h/l80B8hlaUiugeWJdyqCMHOfgc
         KYuikK574AsONM2G07F4qTZkOH0Rpwpokq5S5Rr7kJ76B1hXRi+kFYbci7ob5DzPegpt
         0ICQrm6NmGlrIiur+yQepBZrmWcu4txt9x7X+4TbaeESlyKW3NPmDpmhzHpMspBDsf2r
         xFDgEhlTb/ashJtSf7oQckMvYso0rUY+/c0lOX9YKWIjfwvdfI9VbwffZp8nHzMk3r6o
         IZqA==
X-Gm-Message-State: AAQBX9eSZhypyC4qyGfnQ/FyzLjKY5bmJyYzzc7mDNqG9PS1yf3trnWX
        bwrjOyEf0Y25Q7avm+CFi2zvMak9MIsZRliGYMf2HM/0uvOUCRHNTas+6x6wjEAbibFOuNXxZ6B
        fTtSBLcOOGQzaivYQbo8CUu52
X-Received: by 2002:adf:ec02:0:b0:2fb:aa2f:3e50 with SMTP id x2-20020adfec02000000b002fbaa2f3e50mr1674075wrn.59.1682007562750;
        Thu, 20 Apr 2023 09:19:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350aUo332bWPjus69lZR3d63MPC/5JqobCxoOwqI0JepTKIt3r46N2l/NcVu5XHj3woxYOU/rLQ==
X-Received: by 2002:adf:ec02:0:b0:2fb:aa2f:3e50 with SMTP id x2-20020adfec02000000b002fbaa2f3e50mr1674048wrn.59.1682007562357;
        Thu, 20 Apr 2023 09:19:22 -0700 (PDT)
Received: from debian ([2001:4649:fcb8:0:bac2:a5a6:5482:8a9e])
        by smtp.gmail.com with ESMTPSA id m6-20020adfdc46000000b002d45575643esm2337178wrj.43.2023.04.20.09.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 09:19:21 -0700 (PDT)
Date:   Thu, 20 Apr 2023 18:19:19 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Aleksey Shumnik <ashumnik9@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, waltje@uwalt.nl.mugnet.org,
        gw4pts@gw4pts.ampr.org, xeb@mail.ru, kuznet@ms2.inr.ac.ru,
        rzsfl@rz.uni-sb.de
Subject: Re: [BUG] In af_packet.c::dev_parse_header() skb.network_header does
 not point to the network header
Message-ID: <ZEFmB07IcyhjiqTC@debian>
References: <CAJGXZLgcH6bjmj7YR-hAWpEQW1CPjEcOdMN01hqsVk18E4ScZQ@mail.gmail.com>
 <64362359316d5_1b9cfb29415@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64362359316d5_1b9cfb29415@willemb.c.googlers.com.notmuch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 11:19:53PM -0400, Willem de Bruijn wrote:
> Aleksey Shumnik wrote:
> > but in ip6_gre.c all
> > skb_mac_header(), skb_network_header(), skb_tranport_header() returns
> > a pointer to payload (skb.data).
> > This function is called when receiving a packet and parsing it in
> > af_packet.c::packet_rcv() in dev_parse_header().
> > The problem is that there is no way to accurately determine the
> > beginning of the ip header.
> 
> The issue happens when comparing packet_rcv on an ip_gre tunnel vs an
> ip6_gre tunnel.
> 
> The packet_rcv call does the same in both cases, e.g., setting
> skb->data at mac or network header depending on SOCK_DGRAM or
> SOCK_RAW.
> 
> The issue then is likely with a difference in tunnel implementations.
> Both implement header_ops and header_ops.create (which is used on
> receive by dev_has_header, but on transmit by dev_hard_header). They
> return different lengths: one with and one without the IP header.

The problem is that, upon reception on an af_packet socket, ip_gre
wants to set the outer source IP address in sll->sll_addr. That is, it
considers the outer IP header as the mac header of the gre device.

As far as I know, ip_gre is the only tunnel that does that.

> We've seen inconsistency in this before between tunnels. See also
> commit aab1e898c26c. ipgre_xmit has special logic to optionally pull
> the headers, but only if header_ops is set, which it isn't for all
> variants of GRE tunnels.
> 
> Probably particularly relevant is this section in __ipgre_rcv:
> 
>                 /* Special case for ipgre_header_parse(), which expects the
>                  * mac_header to point to the outer IP header.
>                  */
>                 if (tunnel->dev->header_ops == &ipgre_header_ops)
>                         skb_pop_mac_header(skb);
>                 else
>                         skb_reset_mac_header(skb);
> 
> and see this comment in the mentioned commit:
> 
>     ipgre_header_parse() seems to be the only case that requires mac_header
>     to point to the outer header. We can detect this case accurately by
>     checking ->header_ops. For all other cases, we can reset mac_header.

The problem was about unifying the different ip tunnel behaviours, as
described in the cover letter of the series (merge commit 8eb517a2a4ae
("Merge branch 'reset-mac'") has all the details).

The idea is to make all tunnel devices consistently set ->mac_header
and ->network_header to the corresponding inner headers. For tunnels
that directly transport network protocols, ->mac_header equals
->network_header (that is, the mac header length is 0).

But there's a problem with ip_gre, as it wants to access the outer
headers again, even though it has already pulled them. To do that,
ip_gre saves the offset of the outer ip header in the ->mac_header, so
that ipgre_header_parse() can find it again later. That's why ip_gre
can't properly set ->mac_header to the inner mac header offset, as the
other tunnels do.

I personally find this use of ->mac_header a bit hacky, but it's used
to implement a feature that's required for some users (see commit
0e3da5bb8da4 ("ip_gre: fix msg_name parsing for recvfrom/recvmsg")). We
could probably store the outer IP header offset elsewhere and reset
->mac_header the way all other tunnels do. But I didn't find a
satisfying solution, so I just kept ip_gre as an exception.

> > diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
> > index 90565b8..0d0c37b 100644
> > --- a/net/ipv6/ip6_gre.c
> > +++ b/net/ipv6/ip6_gre.c
> > @@ -1404,8 +1404,16 @@ static int ip6gre_header(struct sk_buff *skb,
> > struct net_device *dev,
> >   return -t->hlen;
> >  }
> > 
> > +static int ip6gre_header_parse(const struct sk_buff *skb, unsigned char *haddr)
> > +{
> > + const struct ipv6hdr *ipv6h = (const struct ipv6hdr *) skb_mac_header(skb);
> > + memcpy(haddr, &ipv6h->saddr, 16);
> > + return 16;
> > +}
> > +
> >  static const struct header_ops ip6gre_header_ops = {
> >   .create = ip6gre_header,
> > + .parse = ip6gre_header_parse,
> >  };
> > 
> >  static const struct net_device_ops ip6gre_netdev_ops = {
> > 
> > Would you answer whether this behavior is an error and why the
> > behavior in ip_gre.c and ip6_gre.c differs?
> > 
> > Regards,
> > Aleksey
> 
> 

