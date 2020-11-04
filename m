Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49492A6453
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 13:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgKDM24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 07:28:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59277 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729583AbgKDM2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 07:28:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604492934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4PeNwU9W1AZr0nG+8m3w+EJAEsQHqQHvV9cHTBZ0vhs=;
        b=c+zt6AmUWDNHJ84L5lI+ocbvUZcD0raAj2EPIT1l/f9ql+OnN01mPbdiftGnaQuchKKde5
        fyfftA9sQgKOjsdDPJe4+vim4mkP7d0Jupj/heWWuBG+M7IlCrFmsB6geXECgHzXnh3STL
        Oxj1KvAR5JKAu5YJXLwYIutnBHt88qU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-yJ-XiHTyP1OIqQcXEt854g-1; Wed, 04 Nov 2020 07:28:49 -0500
X-MC-Unique: yJ-XiHTyP1OIqQcXEt854g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 995EE18B9F37;
        Wed,  4 Nov 2020 12:28:38 +0000 (UTC)
Received: from carbon (unknown [10.36.110.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C24641C4;
        Wed,  4 Nov 2020 12:28:35 +0000 (UTC)
Date:   Wed, 4 Nov 2020 13:28:34 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>, brouer@redhat.com
Subject: Re: [PATCH v3 net-next 1/5] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201104132834.07fc3dfd@carbon>
In-Reply-To: <20201104111902.GA11993@lore-desk>
References: <cover.1604484917.git.lorenzo@kernel.org>
        <5ef0c2886518d8ae1577c8b60ea6ef55d031673e.1604484917.git.lorenzo@kernel.org>
        <20201104121158.597fa64d@carbon>
        <20201104111902.GA11993@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Nov 2020 12:19:02 +0100
Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> > On Wed,  4 Nov 2020 11:22:54 +0100
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >   
> 
> [...]
> 
> > > +/* XDP bulk APIs introduce a defer/flush mechanism to return
> > > + * pages belonging to the same xdp_mem_allocator object
> > > + * (identified via the mem.id field) in bulk to optimize
> > > + * I-cache and D-cache.
> > > + * The bulk queue size is set to 16 to be aligned to how
> > > + * XDP_REDIRECT bulking works. The bulk is flushed when  
> > 
> > If this is connected, then why have you not redefined DEV_MAP_BULK_SIZE?
> > 
> > Cc. DPAA2 maintainers as they use this define in their drivers.
> > You want to make sure this driver is flexible enough for future changes.
> > 
> > Like:
> > 
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 3814fb631d52..44440a36f96f 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -245,6 +245,6 @@ bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
> >  void xdp_attachment_setup(struct xdp_attachment_info *info,
> >                           struct netdev_bpf *bpf);
> >  
> > -#define DEV_MAP_BULK_SIZE 16
> > +#define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE  
> 
> my idea was to address it in a separated patch, but if you prefer I can merge
> this change in v4

Please merge in V4.  As this patch contains the explanation, and we
want to avoid too much churn (remember our colleagues need to backport
and review this).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

