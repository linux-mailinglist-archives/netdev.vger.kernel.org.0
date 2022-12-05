Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B5B643852
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 23:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiLEWry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 17:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiLEWrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 17:47:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2B113E36;
        Mon,  5 Dec 2022 14:47:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42406B81211;
        Mon,  5 Dec 2022 22:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A8AC433D7;
        Mon,  5 Dec 2022 22:47:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Sv1+xdk2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1670280466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1MQ3jVf0OM9VGCaDYuk2IzBHCGdJRv1IhHaHOfSmowk=;
        b=Sv1+xdk2FWGT08UiCRWDpgU9oXKtdkhdu7l3gfy62hn94WYdJfGZIq/HfoQkydKN9RbDRy
        7dxTCllaO6bKugQoLHwFr6ZFgj9PSPm6jL+oYroN5BBsANE/y+loQa4tMTGiMTgFGxbOqz
        3L+C2upAFS02vSbAcnq2TO4pzhpDXhI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 552cf31e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 5 Dec 2022 22:47:46 +0000 (UTC)
Date:   Mon, 5 Dec 2022 23:47:44 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: [PATCH] bpf: call get_random_u32() for random integers
Message-ID: <Y451ENAK7BQQDJc/@zx2c4.com>
References: <20221205181534.612702-1-Jason@zx2c4.com>
 <730fd355-ad86-a8fa-6583-df23d39e0c23@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <730fd355-ad86-a8fa-6583-df23d39e0c23@iogearbox.net>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 11:21:51PM +0100, Daniel Borkmann wrote:
> On 12/5/22 7:15 PM, Jason A. Donenfeld wrote:
> > Since BPF's bpf_user_rnd_u32() was introduced, there have been three
> > significant developments in the RNG: 1) get_random_u32() returns the
> > same types of bytes as /dev/urandom, eliminating the distinction between
> > "kernel random bytes" and "userspace random bytes", 2) get_random_u32()
> > operates mostly locklessly over percpu state, 3) get_random_u32() has
> > become quite fast.
> 
> Wrt "quite fast", do you have a comparison between the two? Asking as its
> often used in networking worst case on per packet basis (e.g. via XDP), would
> be useful to state concrete numbers for the two on a given machine.

Median of 25 cycles vs median of 38, on my Tiger Lake machine. So a
little slower, but too small of a difference to matter.
