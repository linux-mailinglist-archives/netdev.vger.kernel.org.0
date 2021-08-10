Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E14E3E570E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237978AbhHJJdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:33:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234448AbhHJJdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628588002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xkoncmgpwyCE9vcjur8qPBXpdxj1Iwp0mD4/CoZdQhI=;
        b=L2IICG4VY8s3jmcNk/8j3+x9wqF9D572qE4AoLb8LIW++L4mZJdfHNX8enl1zTbzbXnSkO
        X3LH5xVksv18AOWJd46GykvRIFQf3+8SQP4+1j8tW6Krb4xZNcKwijVczMX/kJNLpfmFNP
        Ys20eqlt6TjoPyfFlcV8OBeK97Gr7fQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-wZh5C8sqOyWAzpAQGuBmhQ-1; Tue, 10 Aug 2021 05:33:21 -0400
X-MC-Unique: wZh5C8sqOyWAzpAQGuBmhQ-1
Received: by mail-wm1-f69.google.com with SMTP id o26-20020a05600c511ab0290252d0248251so869414wms.1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:33:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xkoncmgpwyCE9vcjur8qPBXpdxj1Iwp0mD4/CoZdQhI=;
        b=ZfFiBN35fNIKmxoZ3PBaJZyT/HWdRF8/l8gxgKrQ3RYAIfylQ+D70hPLilvjGnEVOz
         lWMCPDWd+iUEDytbNvGrkryM9lsKYLpgtW3T9Cjn/Jw6f/x86eTLbPFWaK0HA6Tp9sH2
         HuzYU/Ex1raFY4YMs8fPMZCvbyhIre5XCG4YNNmbJkkp5PIpcvbQAtb+zyowlVDRMyYK
         x6yUCzFPu+wAsgScNds4KOjdiVrSocdm4AsRbWvOzTWE+rZ35FoXTn1gz363hBmIcRf5
         8KUqQ/yPjES6isI9YLzSNpk5SHXmr6XjVqCQHCVw6iFQIqtJCcKm/IeidpGg5G/t+aG0
         xpwA==
X-Gm-Message-State: AOAM531sxWbAzSSJcraRNT9QTGBxgH7ERdw4msj4lHtjaxfuxmvib1Lq
        bCctnMjNKRtRfeclaJLgdUhahGUjVXhHS1o5louJPas7pton8DhGFtjOP1GhMCxCg489aFPojWq
        hLWKCLJrnbP+yyPMI
X-Received: by 2002:a1c:2504:: with SMTP id l4mr21674096wml.55.1628587999682;
        Tue, 10 Aug 2021 02:33:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1OUiU8S0nPPdAaGHN+n5B33zD70DPVHOhuc/ZlzveKbx35fib7xA1cDMoj8dY+PMJUPd43Q==
X-Received: by 2002:a1c:2504:: with SMTP id l4mr21674073wml.55.1628587999450;
        Tue, 10 Aug 2021 02:33:19 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id o17sm2066684wmp.13.2021.08.10.02.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 02:33:18 -0700 (PDT)
Date:   Tue, 10 Aug 2021 11:33:04 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] bareudp: Fix invalid read beyond skb's linear data
Message-ID: <20210810093304.GA14279@pc-32.home>
References: <7741c46545c6ef02e70c80a9b32814b22d9616b3.1628264975.git.gnault@redhat.com>
 <20210806162234.69334902@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210808161625.GA2912@pc-32.home>
 <20210809091918.68ae21e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809091918.68ae21e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 09:19:18AM -0700, Jakub Kicinski wrote:
> On Sun, 8 Aug 2021 18:16:25 +0200 Guillaume Nault wrote:
> > On Fri, Aug 06, 2021 at 04:22:34PM -0700, Jakub Kicinski wrote:
> > > On Fri, 6 Aug 2021 17:52:06 +0200 Guillaume Nault wrote:  
> > > > Data beyond the UDP header might not be part of the skb's linear data.
> > > > Use skb_copy_bits() instead of direct access to skb->data+X, so that
> > > > we read the correct bytes even on a fragmented skb.
> > > > 
> > > > Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
> > > > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > > > ---
> > > >  drivers/net/bareudp.c | 16 +++++++++++-----
> > > >  1 file changed, 11 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> > > > index a7ee0af1af90..54e321a695ce 100644
> > > > --- a/drivers/net/bareudp.c
> > > > +++ b/drivers/net/bareudp.c
> > > > @@ -71,12 +71,18 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
> > > >  		family = AF_INET6;
> > > >  
> > > >  	if (bareudp->ethertype == htons(ETH_P_IP)) {
> > > > -		struct iphdr *iphdr;
> > > > +		__u8 ipversion;
> > > >  
> > > > -		iphdr = (struct iphdr *)(skb->data + BAREUDP_BASE_HLEN);
> > > > -		if (iphdr->version == 4) {
> > > > -			proto = bareudp->ethertype;
> > > > -		} else if (bareudp->multi_proto_mode && (iphdr->version == 6)) {
> > > > +		if (skb_copy_bits(skb, BAREUDP_BASE_HLEN, &ipversion,
> > > > +				  sizeof(ipversion))) {  
> > > 
> > > No preference just curious - could skb_header_pointer() be better suited?  
> > 
> > I have no preference either. I just used skb_copy_bits() because it
> > didn't seem useful to get a pointer to the buffer (just to read one
> > byte of data).
> 
> Right, the advantage would be in the "fast" case of skb_header_pointer()
> being inlined.

Yes indeed. The problem was found because of some automated functionnal
tests, not because of any practical use cases. So I didn't consider the
possible performance differences.

I see that you've applied the patch as is already. I can switch to
skb_header_pointer() in the future, if anyone sees any practical
benefit for it.

Thanks for the review.

