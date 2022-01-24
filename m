Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F188C497FC2
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241733AbiAXMpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiAXMpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:45:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58334C06173B;
        Mon, 24 Jan 2022 04:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EMEz1rACRULVBrKHzXgo2kunk9zl7ssga+Po9YSgMds=; b=GIX/sPYE/AU2KLF59arUOB3Wx8
        DDIu/x/4XnAmMZHkDHwFbUEV3sEEEIKiBGQpTkmog4sxOBFCNx5bZGnOgVaWFOALZG5ZBDKjTfcpH
        pwEMEbPs71j6SwllrDW4vQGJWi1lTADrzrDJPomOzzVQ4We1muqPai912uGbmdjnPKeBT1kshPhXo
        heAMRMKe+gW2WsSFZk261JczqbK2UA3mlN2gwPkejmBulCWb3KheBHerXhaVqP2aoRdR7fhGZ0HX/
        cPPuHNB2K+OCdC9DBgnrTu1pfhZQ+Nm6N3Rcgy8FE/j9AXLIqYOCisA7pzrTrSRP9A2Gsl1S7oqZq
        yxy6hDWA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nByip-000dUC-R8; Mon, 24 Jan 2022 12:45:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 41CCE300222;
        Mon, 24 Jan 2022 13:45:22 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 23B282027C5FC; Mon, 24 Jan 2022 13:45:22 +0100 (CET)
Date:   Mon, 24 Jan 2022 13:45:22 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Message-ID: <Ye6fYhwF9f+0NvhI@hirez.programming.kicks-ass.net>
References: <20220121194926.1970172-1-song@kernel.org>
 <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com>
 <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
 <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com>
 <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
 <5F4DEFB2-5F5A-4703-B5E5-BBCE05CD3651@fb.com>
 <CAADnVQLXGu_eF8VT6NmxKVxOHmfx7C=mWmmWF8KmsjFXg6P5OA@mail.gmail.com>
 <5E70BF53-E3FB-4F7A-B55D-199C54A8FDCA@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5E70BF53-E3FB-4F7A-B55D-199C54A8FDCA@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 01:03:25AM +0000, Song Liu wrote:

> I guess we can introduce something similar to bpf_arch_text_poke() 
> for this? 

IIRC the s390 version of the text_poke_copy() function is called
s390_kernel_write().
