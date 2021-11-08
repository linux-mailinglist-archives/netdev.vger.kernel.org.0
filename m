Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B5F449E65
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 22:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240534AbhKHVnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 16:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238555AbhKHVnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 16:43:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD15461159;
        Mon,  8 Nov 2021 21:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636407664;
        bh=vlApOlZg8tuxZYUqxaGvAFGDPBEScZWGaGGKOnJSs2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DjoiNDBpndRoL13n3ZhjI9oyQHSAU9exwXH7nVlLQLkORpxbDZL8ibSXDD3RjZylv
         m6W9O/KHAvHd0T9uGefQcM4lW87gDipbQ6J+MkIofvEVCMFkLl/A+qUX+UtXN/r1Px
         Jmy5L0i8l241le+ambikNLddi1TA6FO4ztE2nqfdh9TwOlA/qOaAkSm4K184hv6ftf
         owQq/89M9C3G6czmk1O5khizV16VGbuU7qBMGv1iI1cxKUIfeLUsduNfhcKd7y3g2I
         oNIxKr6ltH3LMRGc6WEK7wcnKpbkB2TcwdnObtJ/61GL1HGfknOe6gE4vmHVfgWKEi
         dMjsOhLGklkxg==
Date:   Mon, 8 Nov 2021 13:40:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v17 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <20211108134059.738ce863@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YYl1P+nPSuMjI+e6@lore-desk>
References: <cover.1636044387.git.lorenzo@kernel.org>
        <fd0400802295a87a921ba95d880ad27b9f9b8636.1636044387.git.lorenzo@kernel.org>
        <20211105162941.46b807e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlWcuUwcKGYtWAR@lore-desk>
        <87fss6r058.fsf@toke.dk>
        <YYl1P+nPSuMjI+e6@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 20:06:39 +0100 Lorenzo Bianconi wrote:
> > Not sure I get what the issue is with this either? But having a test
> > that can be run to validate this on hardware would be great in any case,
> > I suppose - we've been discussing more general "compliance tests" for
> > XDP before...  
> 
> what about option 2? We can add a frag_size field to rxq [0] that is set by
> the driver initializing the xdp_buff. frag_size set to 0 means we can use
> all the buffer.

So 0 would mean xdp->frame_sz can be used for extending frags?

I was expecting that we'd used rxq->frag_size in place of xdp->frame_sz.

For devices doing payload packing we will not be able to extend the
last frag at all. Wouldn't it be better to keep 0 for the case where
extending is not allowed?
