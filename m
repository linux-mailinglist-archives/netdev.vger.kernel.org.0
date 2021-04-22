Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2913680F7
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbhDVM7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhDVM7p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 08:59:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65CB661424;
        Thu, 22 Apr 2021 12:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619096350;
        bh=UjMAOd2UY1Y84zIa/x0wRbJZbLQX/kFg0f6APiYraiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OYosfNU8EEAgG1j3LOtzhMky4usmFyOUV5AG64cPFjg3fc2ckgRR4jVwbFa8ovqhJ
         UZLs4iOOp4PExPkyrg0TcEsvGruBhtmNv6RWd47aRwCDsAlhmzFtTsgPzKWuTTA3PU
         9Gye/+s1byQMhPz0jxz1PTJbnjmGdFZ2jhAJHmyncGDjD94tQPW4juXiBIZ3i3t7vB
         53QrI9nt1RHgAgiqtteGS1Y+9zBVSyx1WK5R/nB8uC43DShl7QCL6seYgj/1dnH1YA
         IE5VSvpDiIUPfQ2Vb504FmeFB0vK/Ghz/iOpj8Y3IUaRXndSBPDMb//++Z6hkLm/OP
         AvLRfcDe3pA8Q==
Date:   Thu, 22 Apr 2021 13:59:04 +0100
From:   Will Deacon <will@kernel.org>
To:     Liam Howlett <liam.howlett@oracle.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH 1/3] arm64: armv8_deprecated: Fix swp_handler() signal
 generation
Message-ID: <20210422125903.GD1521@willie-the-truck>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 04:50:12PM +0000, Liam Howlett wrote:
> arm64_notify_segfault() was written to decide on the si_code from the
> assembly emulation of the swp_handler(), but was also used for the
> signal generation from failed access_ok() and unaligned instructions.
> 
> When access_ok() fails, there is no need to search for the offending
> address in the VMA space.  Instead, simply set the error to SIGSEGV with
> si_code SEGV_ACCERR.
> 
> Change the return code from emulate_swpX() when there is an unaligned
> pointer so the caller can differentiate from the EFAULT.  It is
> unnecessary to search the VMAs in the case of an unaligned pointer.
> This change uses SIGSEGV and SEGV_ACCERR instead of SIGBUS to keep with
> what was returned before.
> 
> Fixes: bd35a4adc413 (arm64: Port SWP/SWPB emulation support from arm)
> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> ---
>  arch/arm64/kernel/armv8_deprecated.c | 20 +++++++++++++-------

Can you give an example of something that is fixed by this, please? At first
glance, it doesn't look like it changes the user-visible behaviour.

We should also be compatible with arch/arm/ here (see set_segfault()).

Will
