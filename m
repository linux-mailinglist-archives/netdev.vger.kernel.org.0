Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF15A186A71
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 12:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730928AbgCPLzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 07:55:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56367 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730895AbgCPLzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 07:55:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584359719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cBwRVHEr2REFxsn5N6zTYtaMJu4RfZd7/sp8yXrqHBU=;
        b=QBXRInlTer5MbO8Mq32pBlj8z+or2Ak65H8ojsYC1oXWPqekKV7bwZ+3H14FfN6PCW2fir
        yVfDniEX7AEKlHABipFsMQUUc98kJu8TSyxO45EOCQpgAYOp/9Jt4bgx6/3lKCPgNrgf59
        chaWC+tS2ePX/EDfQ41qzk46jj+X1mw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-BJBSVhIWOreHmuvSOuWkWw-1; Mon, 16 Mar 2020 07:55:16 -0400
X-MC-Unique: BJBSVhIWOreHmuvSOuWkWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC6F1DB60;
        Mon, 16 Mar 2020 11:55:14 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B32B85C1B2;
        Mon, 16 Mar 2020 11:55:08 +0000 (UTC)
Date:   Mon, 16 Mar 2020 12:55:07 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     Edward Cree <ecree@solarflare.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-net-drivers@solarflare.com, mhabets@solarflare.com,
        cmclachlan@solarflare.com, ilias.apalodimas@linaro.org,
        lorenzo@kernel.org, "Jubran, Samih" <sameehj@amazon.com>,
        brouer@redhat.com,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next] sfc: fix XDP-redirect in this driver
Message-ID: <20200316125507.1a8a92ba@carbon>
In-Reply-To: <CAOJe8K2BC2ABk9SdUm5236iPk=f4BNMsHQxFPsQy+Wc8+QjTSg@mail.gmail.com>
References: <158410589474.499645.16292046086222118891.stgit@firesoul>
        <20200316.014927.1864775444299469362.davem@davemloft.net>
        <98fd3c0c-225b-d64c-a64f-ca497205d4ce@solarflare.com>
        <20200316113515.16f7e243@carbon>
        <CAOJe8K2BC2ABk9SdUm5236iPk=f4BNMsHQxFPsQy+Wc8+QjTSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 13:45:23 +0300
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> On 3/16/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> > On Mon, 16 Mar 2020 10:10:01 +0000
> > Edward Cree <ecree@solarflare.com> wrote:
> >  
> >> On 16/03/2020 08:49, David Miller wrote:  
> >> > Solarflare folks, please review.  
> >>
> >> This looks like a correct implementation of what it purports to do, so
> >> Acked-by: Edward Cree <ecree@solarflare.com>  
> >
> > Thanks for the review!
> >  
> >> It did take me some digging to understand _why_ it was needed though;
> >>  Jesper, is there any documentation of the tailroom requirement?  It
> >>  doesn't seem to be mentioned anywhere I could find.  
> >
> > I admit that is is poorly documented.  It is a requirement as both
> > cpumap and veth have a dependency when they process the redirected
> > packet.  We/I also need to update the doc on one page per packet
> > requirement, as it is (in-practice) no longer true.  
> 
> Hi Jesper,
> 
> that means that's on-going work to add multi-buffer/page support to XDP, right?

Yes, it seems that both Amazon and Google have a need for this.

Do notice that there is a fair amount of work-ahead.  I'm working on
establishing a frame size/end, such that we can get reserved storage
space for multi-buffer references/segments[3].  I know Samih from
Amazon is working on the multi-buffer part of using this area.
 
> >
> > I'm noticing these bugs, because I'm working on a patchset that add
> > tailroom extend, and also reserves this 'skb_shared_info' tailroom area.
> > The real goal is to later add XDP multi-buffer support, using this
> > 'skb_shared_info' tailroom area, as desc here[2]
> >
> > [2]
> > https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org

[3] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org#storage-space-for-multi-buffer-referencessegments
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

