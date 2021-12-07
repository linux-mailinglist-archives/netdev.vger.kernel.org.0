Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13EA46BFE3
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239100AbhLGPyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbhLGPyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:54:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D64C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 07:50:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DD0DB81858
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 15:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E036C341C1;
        Tue,  7 Dec 2021 15:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638892238;
        bh=vv7gsTKN6ixW9H1cANn0Y9rohZru9cc1fkVEMi05VTk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N8XB4Wm4ecqjVwJU7U4Z8SthwWspUtqyWWyYU3q5YWZtBvctstN8z2KZkNWZdcWql
         tbS82IUxDfhzXg699V1ZoI+gELAc7xQOTVmI6Afijt+WTtRCfanGuLEms9VL7x843B
         BSZr6rhEhDVIMIJtIkYKdkNbs8Rl4ppw7je4m8tHB6MUusNhxUOofEaVDyd3G52gAC
         WzbzzcUGaJck/o/YvbXWzh7k/9Tyd+/kFJJ2HX3enV3qq/GfLYygrjYB/WZS/wjKhf
         rM2JwxvAKIi7da08dv3RuYEuGum7dGeFi2ec8wdO1/3kg9JI3aLAwUTaXh6ZTDUqNT
         5fLNgdx+VOcyA==
Date:   Tue, 7 Dec 2021 07:50:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com,
        iamjoonsoo kim <iamjoonsoo.kim@lge.com>,
        akpm@linux-foundation.org, vbabka@suse.cz
Subject: Re: [RFC net-next 2/2] ipv6: ioam: Support for Buffer occupancy
 data field
Message-ID: <20211207075037.6cda8832@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <262812089.220024115.1638878044162.JavaMail.zimbra@uliege.be>
References: <20211206211758.19057-1-justin.iurman@uliege.be>
        <20211206211758.19057-3-justin.iurman@uliege.be>
        <20211206161625.55a112bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <262812089.220024115.1638878044162.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Dec 2021 12:54:04 +0100 (CET) Justin Iurman wrote:
> >> The function kmem_cache_size is used to retrieve the size of a slab
> >> object. Note that it returns the "object_size" field, not the "size"
> >> field. If needed, a new function (e.g., kmem_cache_full_size) could be
> >> added to return the "size" field. To match the definition from the
> >> draft, the number of bytes is computed as follows:
> >> 
> >> slabinfo.active_objs * size
> > 
> > Implementing the standard is one thing but how useful is this
> > in practice?  
> 
> IMHO, very useful. To be honest, if I were to implement only a few data
> fields, these two would be both included. Take the example of CLT [1]
> where the queue length data field is used to detect low-level issues
> from inside a L5-7 distributed tracing tool. And this is just one
> example among many others. The queue length data field is very specific
> to TX queues, but we could also use the buffer occupancy data field to
> detect more global loads on a node. Actually, the goal for operators
> running their IOAM domain is to quickly detect a problem along a path
> and react accordingly (human or automatic action). For example, if you
> monitor TX queues along a path and detect an increasing queue on a
> router, you could choose to, e.g.,  rebalance its queues. With the
> buffer occupancy, you could detect high-loaded nodes in general and,
> e.g., rebalance traffic to another branch. Again, this is just one
> example among others. Apart from more accurate ECMPs, you could for
> instance deploy a smart (micro)service selection based on different
> metrics, etc.
> 
>   [1] https://github.com/Advanced-Observability/cross-layer-telemetry

Ack, my question was more about whether the metric as implemented
provides the best signal. Since the slab cache scales dynamically
(AFAIU) it's not really a big deal if it's full as long as there's
memory available on the system.
