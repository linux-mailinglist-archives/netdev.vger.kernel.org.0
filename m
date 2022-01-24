Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397C6497BF5
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 10:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbiAXJ2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 04:28:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233715AbiAXJ2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 04:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643016515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PU7JbFuDwdFKk/VjKzygUczh9Zjw5LHX5d/gO46ICZ4=;
        b=VfGViklEVimD6k0TdE77xCrQNDYEnfO6MXn4H8IWAYqMHlW3vwHzwHJXpyjJ003lnx9ceD
        l47dFaGEr5/rwAPkK1SijzF/pT4CHc1exySixscdsaFy4qF+Tkg08Mms2K4a33Erql1jNg
        OYis1GtnDCQ+3AkdTReJtM+gua6LUtU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-h86HWp00MZiTOBQxiU5KBw-1; Mon, 24 Jan 2022 04:28:29 -0500
X-MC-Unique: h86HWp00MZiTOBQxiU5KBw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CE8B5108D;
        Mon, 24 Jan 2022 09:28:27 +0000 (UTC)
Received: from localhost (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C25C770D52;
        Mon, 24 Jan 2022 09:28:24 +0000 (UTC)
Date:   Mon, 24 Jan 2022 10:28:23 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <Ye5xN6sQvsfX1lmn@localhost>
References: <20220103232555.19791-4-richardcochran@gmail.com>
 <20220120164832.xdebp5vykib6h6dp@skbuf>
 <Yeoqof1onvrcWGNp@lunn.ch>
 <20220121040508.GA7588@hoboy.vegasvil.org>
 <20220121145035.z4yv2qsub5mr7ljs@skbuf>
 <20220121152820.GA15600@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121152820.GA15600@hoboy.vegasvil.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 07:28:20AM -0800, Richard Cochran wrote:
> On Fri, Jan 21, 2022 at 02:50:36PM +0000, Vladimir Oltean wrote:
> > So as I mentioned earlier, the use case would be hardware performance
> > testing and diagnosing. You may consider that as not that important, but
> > this is basically what I had to do for several months, and even wrote
> > a program for that, that collects packet timestamps at all possible points.
> 
> This is not possible without making a brand new CMSG to accommodate
> time stamps from all the various layers.

FWIW, scm_timestamping has three fields and the middle one no longer
seems to be used. If a new socket/timestamping option enabled all
three (SW, MAC, PHY) timestamps in the cmsg, I think that would be a
nice feature.

There are applications that receive both SW and HW timestamps in order
to fall back to SW when a HW timestamp glitched or is missing. This
could be extended to three levels with MAC and PHY timestamps.

> That is completely out of scope for this series.
> 
> The only practical use case of this series is to switch from PHY back to MAC.

From an admin point of view, it makes sense to me to have an option to
disable PHY timestamps for the whole device if there are issues with
it. For debugging and applications, it would be nice to have an option
to get all of them at the same time.

-- 
Miroslav Lichvar

