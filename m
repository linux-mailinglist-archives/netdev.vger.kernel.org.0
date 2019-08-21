Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C066498697
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730290AbfHUVZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 17:25:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33014 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbfHUVZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 17:25:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=stVrXdEt2psI1xW6LiBa6v0h4JBpgcyjIMoWqX0kuJA=; b=dDvobmV9lK90cG8bM8C7Sz+Q9
        JOxE8ZqoZA77psTtpslH4rCGOMuYrqNLiND3+RM0QnCwrvXnc0ZnkxAZe+qgVFg8MBzdDhYgRM1Vp
        A2VqybGbRmlO07SWfX1Eq9T0P4aieft6Ia7AS5N7grZiUbKLRTZiDaggWtrzKkh9ItMR+BK2KR23B
        IQbqMW49JbVeGOiELHWupQp8pP7hTB5YGdzB5tlEp8lBD1OMFXk6AA141r/CXquiIhZ9V7uibWgtO
        iBDfnCPlWUirvXdUXFZPwJfA8Z6DTVnHUcHWcANlGhRK/2lj2m3z4oT72mqwguLGcBjSFIg1Dt/dO
        Cr4KBnANQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0Y6w-0003o9-K9; Wed, 21 Aug 2019 21:25:42 +0000
Date:   Wed, 21 Aug 2019 14:25:42 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 24/38] cls_u32: Convert tc_u_common->handle_idr to XArray
Message-ID: <20190821212542.GB21442@bombadil.infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
 <20190820223259.22348-25-willy@infradead.org>
 <20190821141308.54313c30@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821141308.54313c30@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 02:13:08PM -0700, Jakub Kicinski wrote:
> On Tue, 20 Aug 2019 15:32:45 -0700, Matthew Wilcox wrote:
> > @@ -305,8 +306,12 @@ static void *u32_get(struct tcf_proto *tp, u32 handle)
> >  /* Protected by rtnl lock */
> >  static u32 gen_new_htid(struct tc_u_common *tp_c, struct tc_u_hnode *ptr)
> >  {
> > -	int id = idr_alloc_cyclic(&tp_c->handle_idr, ptr, 1, 0x7FF, GFP_KERNEL);
> > -	if (id < 0)
> > +	int err;
> > +	u32 id;
> > +
> > +	err = xa_alloc_cyclic(&tp_c->ht_xa, &id, ptr, XA_LIMIT(0, 0x7ff),
> > +			&tp_c->ht_next, GFP_KERNEL);
> 
> nit: indentation seems off here and a couple of other places.

what indentation rule does the networking stack use?  i just leave the
cursor where my editor puts it, which seems to be two tabs.
