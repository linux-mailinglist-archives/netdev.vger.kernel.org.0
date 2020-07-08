Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB12218CAA
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbgGHQMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:12:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728148AbgGHQMm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 12:12:42 -0400
Received: from linux-8ccs.fritz.box (p57a23121.dip0.t-ipconnect.de [87.162.49.33])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F4620720;
        Wed,  8 Jul 2020 16:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594224761;
        bh=wvHjxZxUZUUkYWq6mEbxkcnvzWEL0F6xg2+xf/F0qnA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OdlewKOXT4w7chOuimi+NRrqQKuLn+dX5NTKYo4SIzQyDzA12aSFG6KscIhvd9VHU
         cebUXOVOlotPVrB9iqWRvv5KxuVMB+L50oQ1FRo3NwitSn01OTkTU6LrbmN74gjyPi
         LJfjrwd4dzS6QqKI3qGEuCERfNXDGHfirUjbEXZA=
Date:   Wed, 8 Jul 2020 18:12:33 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] module: Do not expose section addresses to
 non-CAP_SYSLOG
Message-ID: <20200708161233.GB5609@linux-8ccs.fritz.box>
References: <20200702232638.2946421-1-keescook@chromium.org>
 <20200702232638.2946421-4-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200702232638.2946421-4-keescook@chromium.org>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+++ Kees Cook [02/07/20 16:26 -0700]:
>The printing of section addresses in /sys/module/*/sections/* was not
>using the correct credentials to evaluate visibility.
>
>Before:
>
> # cat /sys/module/*/sections/.*text
> 0xffffffffc0458000
> ...
> # capsh --drop=CAP_SYSLOG -- -c "cat /sys/module/*/sections/.*text"
> 0xffffffffc0458000
> ...
>
>After:
>
> # cat /sys/module/*/sections/*.text
> 0xffffffffc0458000
> ...
> # capsh --drop=CAP_SYSLOG -- -c "cat /sys/module/*/sections/.*text"
> 0x0000000000000000
> ...
>
>Additionally replaces the existing (safe) /proc/modules check with
>file->f_cred for consistency.
>
>Cc: stable@vger.kernel.org
>Reported-by: Dominik Czarnota <dominik.czarnota@trailofbits.com>
>Fixes: be71eda5383f ("module: Fix display of wrong module .text address")
>Signed-off-by: Kees Cook <keescook@chromium.org>

Tested-by: Jessica Yu <jeyu@kernel.org>
Acked-by: Jessica Yu <jeyu@kernel.org>

