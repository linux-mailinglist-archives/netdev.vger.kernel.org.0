Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617B34A58A2
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 09:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbiBAImP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 03:42:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235486AbiBAImO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 03:42:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643704934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vxfgpW13YgAvN++vE21sBscAoqw0yNwitRZUk5D8Ba8=;
        b=D89BmQe432HAsF13P5sG7WfqVKI5dpyPxRUHrx/pz3Bh7q9G0LdzyeZkb2SXucm9/QFM+S
        xLqODsaWiPfBiKIK97MXlHxCAXb4EbaD7bmZmTHiSj4/n31EzqPeywb8Z+afYW3afD2voO
        7zGqd9CgSApE/63nuK5yc3lkZyJBy+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-k-mbE_yKNbKzYEsk2mMfqA-1; Tue, 01 Feb 2022 03:42:11 -0500
X-MC-Unique: k-mbE_yKNbKzYEsk2mMfqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 020E51091DAA;
        Tue,  1 Feb 2022 08:42:10 +0000 (UTC)
Received: from localhost (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FA5A5ED51;
        Tue,  1 Feb 2022 08:42:08 +0000 (UTC)
Date:   Tue, 1 Feb 2022 09:42:07 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: Re: [PATCH net-next 5/5] ptp: start virtual clocks at current system
 time.
Message-ID: <YfjyX893NV2Hga35@localhost>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
 <20220127114536.1121765-6-mlichvar@redhat.com>
 <20220127220116.GB26514@hoboy.vegasvil.org>
 <Yfe4FPHbFjc6FoTa@localhost>
 <20220131163240.GA22495@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131163240.GA22495@hoboy.vegasvil.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 08:32:40AM -0800, Richard Cochran wrote:
> On Mon, Jan 31, 2022 at 11:21:08AM +0100, Miroslav Lichvar wrote:
> > To me, it seems very strange to start the PHC at 0. It makes the
> > initial clock correction unnecessarily larger by ~7 orders of
> > magnitude. The system clock is initialized from the RTC, which can
> > have an error comparable to the TAI-UTC offset, especially if the
> > machine was turned off for a longer period of time, so why not
> > initialize the PHC from the system time? The error is much smaller
> > than billions of seconds.
> 
> When the clock reads Jan 1, 1970, then that is clearly wrong, and so a
> user might suspect that it is uninititalized.

FWIW, my first thought when I saw the huge offset in ptp4l was that
something is horribly broken. 

> I prefer the clarity of the first case.

I'd prefer smaller initial error and consistency. The vast majority of
existing drivers seem to initialize the clock at current system time.
Drivers starting at 0 now create confusion. If this is the right way,
shouldn't be all existing drivers patched to follow that?

-- 
Miroslav Lichvar

