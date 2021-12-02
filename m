Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E65466631
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358838AbhLBPMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:12:08 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39284 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345686AbhLBPMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 10:12:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1D20CE2302
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 15:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0C4C00446;
        Thu,  2 Dec 2021 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638457720;
        bh=SNstSMLIOPD9MGs0gEXIgX2SVc5sBOhh8+ptB6GjQFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eC8G4V86nwSHYR4DY15ve3oIOWQX6vfz9RTEYV0AdDKuZa6dTwAnhNrbmnQHXBLCG
         +e3ujcDGUcM2KATS1vFQ9BncWR0vJ5CC0V+d5OMJuxTcNi1TU0OWevEMQus4txU3B5
         24zCeRvHiBQJLa/sG84K3CnvK3YoEzBksgbR1ezgMumIOUyCwAWbcoFTrIhkYkQJZi
         tjMTZA6H/c3zEnkt7Hp2v7KpF/syP8osj8iq0i+yyFvDfJAftTAMRAEONZmmJseFR4
         R76pFF1O2D4/Hif7EZ789dI9iQssdrXwBhFHOu1J5aDkJhf+VADfJvkT7AvgQ+2RWE
         kyAQIAj35aZzA==
Date:   Thu, 2 Dec 2021 17:08:36 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Battersby <tonyb@cybernetics.com>,
        Tal Gilboa <talgi@nvidia.com>
Cc:     netdev@vger.kernel.org
Subject: Re: dim_calc_stats() may cause uninitialized values to be used
Message-ID: <YajhdLVPnuZkuKMU@unreal>
References: <fb600754-30c9-2ff7-dc95-7f7fc4c7aefb@cybernetics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb600754-30c9-2ff7-dc95-7f7fc4c7aefb@cybernetics.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 02:40:47PM -0500, Tony Battersby wrote:
> I am reporting the following possible logic bug:
> 
> lib/dim/dim.c::dim_calc_stats() doesn't set curr_stats if delta_us == 0,
> which would result in using uninitialized values in net_dim_decision()
> and rdma_dim_decision().
> 
> I don't know anything about this code.  I encountered this only as a
> compiler warning compiling an out-of-tree module that had a copy of
> dim_calc_stats() inlined for compatibility with old kernels, and I
> decided to investigate and report.  There is no compiler warning in
> mainline since dim_calc_stats() and net_dim() are in separate C files so
> the compiler can't fully analyze it, but it looks like mainline has the
> problem also, if the delta_us == 0 condition is possible.

IMHO, it is false alarm, I don't see how delta_us can be 0. I would remove
this if (!delta_us) check.

Tal?

Thanks

> 
> Tony Battersby
> Cybernetics
> 
