Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C0025D23E
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 09:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIDHT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 03:19:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55255 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726114AbgIDHT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 03:19:56 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-h0Zsa4psMzm5VGbC6ly0rw-1; Fri, 04 Sep 2020 03:19:54 -0400
X-MC-Unique: h0Zsa4psMzm5VGbC6ly0rw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0924E107464E;
        Fri,  4 Sep 2020 07:19:52 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DD0F5C1C2;
        Fri,  4 Sep 2020 07:19:41 +0000 (UTC)
Date:   Fri, 4 Sep 2020 09:19:39 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        brouer@redhat.com, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v2 net-next 1/9] xdp: introduce mb in xdp_buff/xdp_frame
Message-ID: <20200904091939.069592e4@carbon>
In-Reply-To: <20200904010705.jm6dnuyj3oq4cpjd@ast-mbp.dhcp.thefacebook.com>
References: <cover.1599165031.git.lorenzo@kernel.org>
        <1e8e82f72e46264b7a7a1ac704d24e163ebed100.1599165031.git.lorenzo@kernel.org>
        <20200904010705.jm6dnuyj3oq4cpjd@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 18:07:05 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Sep 03, 2020 at 10:58:45PM +0200, Lorenzo Bianconi wrote:
> > Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify
> > if shared_info area has been properly initialized for non-linear
> > xdp buffers
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/net/xdp.h | 8 ++++++--
> >  net/core/xdp.c    | 1 +
> >  2 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 3814fb631d52..42f439f9fcda 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -72,7 +72,8 @@ struct xdp_buff {
> >  	void *data_hard_start;
> >  	struct xdp_rxq_info *rxq;
> >  	struct xdp_txq_info *txq;
> > -	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
> > +	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved tailroom*/
> > +	u32 mb:1; /* xdp non-linear buffer */
> >  };
> >  
> >  /* Reserve memory area at end-of data area.
> > @@ -96,7 +97,8 @@ struct xdp_frame {
> >  	u16 len;
> >  	u16 headroom;
> >  	u32 metasize:8;
> > -	u32 frame_sz:24;
> > +	u32 frame_sz:23;
> > +	u32 mb:1; /* xdp non-linear frame */  
> 
> Hmm. Last time I checked compilers were generating ugly code with bitfields.
> Not performant and not efficient.
> frame_sz is used in the fast path.
> I suspect the first hunk alone will cause performance degradation.
> Could you use normal u8 or u32 flag field?

For struct xdp_buff sure we can do this.  For struct xdp_frame, I'm not
sure, as it is a state compressed version of xdp_buff + extra
information.  The xdp_frame have been called skb-light, and I know
people (e.g Ahern) wants to add more info to this, vlan, RX-hash, csum,
and we must keep this to 1-cache-line, for performance reasons.

You do make a good point, that these bit-fields might hurt performance
more.  I guess, we need to test this.  As I constantly worry that we
will slowly kill XDP performance with a 1000 paper-cuts.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

