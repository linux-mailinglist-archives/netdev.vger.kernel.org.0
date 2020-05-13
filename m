Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF531D227A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 00:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732189AbgEMW4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 18:56:15 -0400
Received: from smtp3.emailarray.com ([65.39.216.17]:40683 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732181AbgEMW4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 18:56:13 -0400
Received: (qmail 95400 invoked by uid 89); 13 May 2020 22:49:30 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 13 May 2020 22:49:30 -0000
Date:   Wed, 13 May 2020 15:49:27 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 0/6] BPF ring buffer
Message-ID: <20200513224927.643hszw3q3cgx7e6@bsd-mbp.dhcp.thefacebook.com>
References: <20200513192532.4058934-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513192532.4058934-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:25:26PM -0700, Andrii Nakryiko wrote:
> Implement a new BPF ring buffer, as presented at BPF virtual conference ([0]).
> It presents an alternative to perf buffer, following its semantics closely,
> but allowing sharing same instance of ring buffer across multiple CPUs
> efficiently.
> 
> Most patches have extensive commentary explaining various aspects, so I'll
> keep cover letter short. Overall structure of the patch set:
> - patch #1 adds BPF ring buffer implementation to kernel and necessary
>   verifier support;
> - patch #2 adds litmus tests validating all the memory orderings and locking
>   is correct;
> - patch #3 is an optional patch that generalizes verifier's reference tracking
>   machinery to capture type of reference;
> - patch #4 adds libbpf consumer implementation for BPF ringbuf;
> - path #5 adds selftest, both for single BPF ring buf use case, as well as
>   using it with array/hash of maps;
> - patch #6 adds extensive benchmarks and provide some analysis in commit
>   message, it build upon selftests/bpf's bench runner.
> 
>   [0] https://docs.google.com/presentation/d/18ITdg77Bj6YDOH2LghxrnFxiPWe0fAqcmJY95t_qr0w
> 
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>

Looks very nice!  A few random questions:

1) Why not use a structure for the header, instead of 2 32bit ints?

2) Would it make sense to reserve X bytes, but only commit Y?
   the offset field could be used to write the record length.

   E.g.:
      reserve 512 bytes    [BUSYBIT | 512][PG OFFSET]
      commit  400 bytes    [ 512 ] [ 400 ]

3) Why have 2 separate pages for producer/consumer, instead of
   just aligning to a smp cache line (or even 1/2 page?)

4) The XOR of busybit makes me wonder if there is anything that
   prevents the system from calling commit twice?
--
Jonathan
