Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA2746AEE6
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377963AbhLGAUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:20:00 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37918 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbhLGAT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:19:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E7C97CE18B0
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 00:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCAAC004DD;
        Tue,  7 Dec 2021 00:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638836187;
        bh=ciIFGHp3Vk2kFf/+PUEjEQ4ngbZLvWXxYi/dHbqk3k8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h8rRCmCqKdoNfAwzurutCjozLRptHDGzg7A2uCUxo5DrlkTW9JoxTkvWmEWUb0dwg
         b+lXJbX7H4JXN7N5ZUpTxi0URdBKzDgrKcW635o/9OwgjZzRON1ZyANX3RLuvpSbkO
         I+ID4ZBvZDNblZlXkzY9ffAQfi6fgqCoMx5pDwKBjtNj4CNMUyV/FMdu2oc5v1Tqv2
         M0/EXGBtz1QJX1EvMzwbSDlWVPuPmdGty0YwbEB+Y+/RhjLB6QG+T9OjfkoOHJx1AL
         6JjnjdoLqHxXFsl4CQqBZpQGMraSeySQLB2Nptao1wYvmeFwyJrCfj5j/dtBuVkFVe
         rEQ2W2tOOhsmA==
Date:   Mon, 6 Dec 2021 16:16:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, vbabka@suse.cz
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
Message-ID: <20211206161625.55a112bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211206211758.19057-3-justin.iurman@uliege.be>
References: <20211206211758.19057-1-justin.iurman@uliege.be>
        <20211206211758.19057-3-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Dec 2021 22:17:58 +0100 Justin Iurman wrote:
> This patch is an attempt to support the buffer occupancy in IOAM trace
> data fields. Any feedback is appreciated, or any other idea if this one
> is not correct.
> 
> The draft [1] says the following:
> 
>    The "buffer occupancy" field is a 4-octet unsigned integer field.
>    This field indicates the current status of the occupancy of the
>    common buffer pool used by a set of queues.  The units of this field
>    are implementation specific.  Hence, the units are interpreted within
>    the context of an IOAM-Namespace and/or node-id if used.  The authors
>    acknowledge that in some operational cases there is a need for the
>    units to be consistent across a packet path through the network,
>    hence it is recommended for implementations to use standard units
>    such as Bytes.
> 
> An existing function (i.e., get_slabinfo) is used to retrieve info about
> skbuff_head_cache. For that, both the prototype of get_slabinfo and
> struct definition of slabinfo were moved from mm/slab.h to
> include/linux/slab.h. Any objection on this?
> 
> The function kmem_cache_size is used to retrieve the size of a slab
> object. Note that it returns the "object_size" field, not the "size"
> field. If needed, a new function (e.g., kmem_cache_full_size) could be
> added to return the "size" field. To match the definition from the
> draft, the number of bytes is computed as follows:
> 
> slabinfo.active_objs * size
> 
> Thoughts?

Implementing the standard is one thing but how useful is this 
in practice?
