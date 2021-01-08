Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2221D2EF9B9
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 22:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbhAHU7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 15:59:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727003AbhAHU7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 15:59:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610139476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tI3f/CbjeFp6lzbYuyiGtjhIQKeMvRX5xXCzzer+hYE=;
        b=MdAYES8KZDsuf4R0+Djh1cKGNEqMZbsFkpTKvOQ6rveoiDWo1V2TqsLfS1pzzWtcxK+xta
        jfdERzAZMpD+5Gk2XnPfGccipqid4NhDwauZvkO9FWbGbzeM6IYptKUty1V1Bde3uDcooN
        TgebuqENXxHJD/z+ATY7BokukEdFZpg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-Eq3_6LGHOw67Ji10Rk9iYg-1; Fri, 08 Jan 2021 15:57:54 -0500
X-MC-Unique: Eq3_6LGHOw67Ji10Rk9iYg-1
Received: by mail-wr1-f70.google.com with SMTP id q2so4622822wrp.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 12:57:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tI3f/CbjeFp6lzbYuyiGtjhIQKeMvRX5xXCzzer+hYE=;
        b=pzdbERFaNSmv8+HPR8qyJAycwUfj8RhT12ymHa4QxVgiQ5jN8DY4KK5i/ZpRSxPa13
         fGVBu0nDQ/P3GPbRb/PYJ5NPWsCMnu/kOry8a7OcZ6fBf0PezwTrE3oVHGjZHAsJVPqU
         cEHYWOtI1OCYNpwK8k1Lz95fBLm2gG0KJN1EPdSrCNnxe/rQXbTmCQwMjmtMA6FxXv4V
         HAA1nwMq5NzAudKb/wObnXI0miqE2L4lzN+xb+KAqVjB1m5Pzb10c4H60Kw/lWF+uXiE
         OUXQxiqlkzgqtipsnKodrZ3tUnm5aVckYovV1KaJS7SCUBfzMdbwUg7pDHi1Dfs6IwZC
         Vbqw==
X-Gm-Message-State: AOAM530DrMfffslTpHJayhktEpx/NjDz79hNAli0RjJCvwz2sE2f3KKp
        ql7sW7sD00bGhkuGQvmGPVxvko8Cg/CIqWwO39TakdyHYjhQNXAROlbHKhEeUYKioAzq2yPZHGs
        9CcQa/e5O3Foxkgat
X-Received: by 2002:a1c:bb07:: with SMTP id l7mr4681443wmf.9.1610139473018;
        Fri, 08 Jan 2021 12:57:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzCEc/BM8oDVIBb3Mx8Rh/5NDPSu0D8nBj7Sjj8borAGM06cCibwqpk0czBdGBodaknijOpjw==
X-Received: by 2002:a1c:bb07:: with SMTP id l7mr4681429wmf.9.1610139472834;
        Fri, 08 Jan 2021 12:57:52 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id a62sm15345452wmh.40.2021.01.08.12.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 12:57:52 -0800 (PST)
Date:   Fri, 8 Jan 2021 21:57:50 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net v3] ppp: fix refcount underflow on channel unbridge
Message-ID: <20210108205750.GA14215@linux.home>
References: <20210107181315.3128-1-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107181315.3128-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 06:13:15PM +0000, Tom Parkin wrote:
> When setting up a channel bridge, ppp_bridge_channels sets the
> pch->bridge field before taking the associated reference on the bridge
> file instance.
> 
> This opens up a refcount underflow bug if ppp_bridge_channels called
> via. iotcl runs concurrently with ppp_unbridge_channels executing via.
> file release.
> 
> The bug is triggered by ppp_bridge_channels taking the error path
> through the 'err_unset' label.  In this scenario, pch->bridge is set,
> but the reference on the bridged channel will not be taken because
> the function errors out.  If ppp_unbridge_channels observes pch->bridge
> before it is unset by the error path, it will erroneously drop the
> reference on the bridged channel and cause a refcount underflow.
> 
> To avoid this, ensure that ppp_bridge_channels holds a reference on
> each channel in advance of setting the bridge pointers.

Thanks for following up on this!

Acked-by: Guillaume Nault <gnault@redhat.com>

