Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB821D3F0D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgENUjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgENUjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:39:24 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71EFC061A0C;
        Thu, 14 May 2020 13:39:23 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jZKdG-0000K8-KW; Thu, 14 May 2020 22:39:06 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id DA9531004CE; Thu, 14 May 2020 22:39:05 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        linux-arch@vger.kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier support for it
In-Reply-To: <20200514121848.052966b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200513192532.4058934-1-andriin@fb.com> <20200513192532.4058934-2-andriin@fb.com> <20200514121848.052966b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Thu, 14 May 2020 22:39:05 +0200
Message-ID: <87h7wixndi.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 13 May 2020 12:25:27 -0700 Andrii Nakryiko wrote:
>> One interesting implementation bit, that significantly simplifies (and thus
>> speeds up as well) implementation of both producers and consumers is how data
>> area is mapped twice contiguously back-to-back in the virtual memory. This
>> allows to not take any special measures for samples that have to wrap around
>> at the end of the circular buffer data area, because the next page after the
>> last data page would be first data page again, and thus the sample will still
>> appear completely contiguous in virtual memory. See comment and a simple ASCII
>> diagram showing this visually in bpf_ringbuf_area_alloc().
>
> Out of curiosity - is this 100% okay to do in the kernel and user space
> these days? Is this bit part of the uAPI in case we need to back out of
> it? 
>
> In the olden days virtually mapped/tagged caches could get confused
> seeing the same physical memory have two active virtual mappings, or 
> at least that's what I've been told in school :)

Yes, caching the same thing twice causes coherency problems.

VIVT can be found in ARMv5, MIPS, NDS32 and Unicore32.

> Checking with Paul - he says that could have been the case for Itanium
> and PA-RISC CPUs.

Itanium: PIPT L1/L2.
PA-RISC: VIPT L1 and PIPT L2

Thanks,

        tglx
