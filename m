Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FCA4A4004
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 11:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358091AbiAaKVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 05:21:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348432AbiAaKVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 05:21:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643624475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+tvnYyJZcShmI86itURRcFQ1Cfttvs/xwgltvCFnI7c=;
        b=R+3vGD5MyDq2zVCiPRh13E5wrLovBJ/HGFgclUbizW0Zx5Ep52klJtgScb7sMqYVcYWdTZ
        E3Yz8bTz67OT8dp7WUieg7Nt2QQhxJ6joH0ilGRweIqYpH0IiI6p5VQZoYJgW2t2YNmpFm
        ju4SIwOFBmUXWFVBTEHEDeWipK+/yr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-JaFTszvqNiiyO6yWceWU5Q-1; Mon, 31 Jan 2022 05:21:11 -0500
X-MC-Unique: JaFTszvqNiiyO6yWceWU5Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C94701083F61;
        Mon, 31 Jan 2022 10:21:10 +0000 (UTC)
Received: from localhost (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 020EF22E0E;
        Mon, 31 Jan 2022 10:21:09 +0000 (UTC)
Date:   Mon, 31 Jan 2022 11:21:08 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: Re: [PATCH net-next 5/5] ptp: start virtual clocks at current system
 time.
Message-ID: <Yfe4FPHbFjc6FoTa@localhost>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
 <20220127114536.1121765-6-mlichvar@redhat.com>
 <20220127220116.GB26514@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127220116.GB26514@hoboy.vegasvil.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 02:01:16PM -0800, Richard Cochran wrote:
> On Thu, Jan 27, 2022 at 12:45:36PM +0100, Miroslav Lichvar wrote:
> > When a virtual clock is being created, initialize the timecounter to the
> > current system time instead of the Unix epoch to avoid very large steps
> > when the clock will be synchronized.
> 
> I think we agreed that, going forward, new PHC drivers should start at
> zero (1970) instead of TAI - 37.

I tried to find the discussion around this decision, but failed. Do
you have a link?

To me, it seems very strange to start the PHC at 0. It makes the
initial clock correction unnecessarily larger by ~7 orders of
magnitude. The system clock is initialized from the RTC, which can
have an error comparable to the TAI-UTC offset, especially if the
machine was turned off for a longer period of time, so why not
initialize the PHC from the system time? The error is much smaller
than billions of seconds.

-- 
Miroslav Lichvar

