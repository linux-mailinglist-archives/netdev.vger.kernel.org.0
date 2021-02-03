Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9309B30E761
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhBCXaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhBCX36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:29:58 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5A4C061573;
        Wed,  3 Feb 2021 15:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=QSMs8iE5sDVKrKhLTidBMmDgBXHbDNDVBvD5m7DqLWs=; b=EPyZqZNsDH73V4t1vdU879zpP0
        dqT2Wz5F1H4A4RzdOkm5uACEp/AzZ75oSOCkjTXC8fLdHkM4hcPgHEQ/bvb4VHfbllL0/o8VPVdUc
        3PMd5rXKPihqeQpJpiJC0lae8IagoPQVgBt3nOwh0hVrvMMZQM/1Jt2COiMCXPKQNtKV3jy/iaSV3
        sXKvr3lX+tPNHIgA0DEy82vhOt39+W6qBypdWcdj7vAIQmpMHprFjBl78K4KKWqPsxqjdwPzsL290
        Mml57965jztD5Y03zXuzYqvDMwWtDFNKtmo94478lAUxAS7s3I1CmKKwCsyAPFR9lmbNaA5HbibFJ
        D7ThIOww==;
Received: from [2601:1c0:6280:3f0::aec2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7RaA-0007sD-Jj; Wed, 03 Feb 2021 23:29:11 +0000
Subject: Re: [PATCH bpf-next] libbpf: stop using feature-detection Makefiles
To:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     kernel-team@fb.com, Arnaldo Carvalho de Melo <acme@redhat.com>
References: <20210203203445.3356114-1-andrii@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2127a682-1d78-49a5-26e2-cfda5b35602d@infradead.org>
Date:   Wed, 3 Feb 2021 15:29:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210203203445.3356114-1-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/21 12:34 PM, Andrii Nakryiko wrote:
> Libbpf's Makefile relies on Linux tools infrastructure's feature detection
> framework, but libbpf's needs are very modest: it detects the presence of
> libelf and libz, both of which are mandatory. So it doesn't benefit much from
> the framework, but pays significant costs in terms of maintainability and
> debugging experience, when something goes wrong. The other feature detector,
> testing for the presernce of minimal BPF API in system headers is long
> obsolete as well, providing no value.
> 
> So stop using feature detection and just assume the presence of libelf and
> libz during build time. Worst case, user will get a clear and actionable
> linker error, e.g.:
> 
>   /usr/bin/ld: cannot find -lelf
> 
> On the other hand, we completely bypass recurring issues various users
> reported over time with false negatives of feature detection (libelf or libz
> not being detected, while they are actually present in the system).
> 
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/lib/bpf/.gitignore |  1 -
>  tools/lib/bpf/Makefile   | 47 ++++------------------------------------
>  2 files changed, 4 insertions(+), 44 deletions(-)

Hi Andrii,

This does indeed fix the build problems that I was seeing,
so I can add:
Acked-by: Randy Dunlap <rdunlap@infradead.org>

but in the long term I think that features/libs/etc. that are
used should be checked for instead of being used blindly... IMO.

Thanks.

-- 
~Randy
