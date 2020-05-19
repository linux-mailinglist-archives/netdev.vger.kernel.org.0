Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A0F1D8F84
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgESFuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:50:16 -0400
Received: from verein.lst.de ([213.95.11.211]:42358 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbgESFuN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 01:50:13 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B2C5568B02; Tue, 19 May 2020 07:50:09 +0200 (CEST)
Date:   Tue, 19 May 2020 07:50:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Christoph Hellwig <hch@lst.de>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: clean up and streamline probe_kernel_* and friends v2
Message-ID: <20200519055009.GB23853@lst.de>
References: <20200513160038.2482415-1-hch@lst.de> <10c58b09-5ece-e49f-a7c8-2aa6dfd22fb4@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10c58b09-5ece-e49f-a7c8-2aa6dfd22fb4@iogearbox.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 01:04:38AM +0200, Daniel Borkmann wrote:
> Aside from comments on list, the series looks reasonable to me. For BPF
> the bpf_probe_read() helper would be slightly penalized for probing user
> memory given we now test on copy_from_kernel_nofault() first and if that
> fails only then fall back to copy_from_user_nofault(), but it seems
> small enough that it shouldn't matter too much and aside from that we have
> the newer bpf_probe_read_kernel() and bpf_probe_read_user() anyway that
> BPF progs should use instead, so I think it's okay.
>
> For patch 14 and patch 15, do you roughly know the performance gain with
> the new probe_kernel_read_loop() + arch_kernel_read() approach?

I don't think there should be any measurable difference in performance
for typical use cases.  We'll save the stac/clac pair, but that's it.
The real eason is to avoid that stac/clac pair that opens up a window
for explots, and as a significant enabler for killing of set_fs based 
address limit overrides entirely.
