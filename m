Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0ABB4853BA
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbiAENmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:42:07 -0500
Received: from www62.your-server.de ([213.133.104.62]:54236 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234294AbiAENmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 08:42:05 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n56YE-0007D6-Pc; Wed, 05 Jan 2022 14:42:02 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1n56YE-000Pvo-H9; Wed, 05 Jan 2022 14:42:02 +0100
Subject: Re: [PATCH net] scripts/pahole-flags.sh: Make sure pahole --version
 works
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
References: <20211231075607.94752-1-saeed@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8cf93086-4990-f14a-3271-92bc2ee0519e@iogearbox.net>
Date:   Wed, 5 Jan 2022 14:42:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211231075607.94752-1-saeed@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26413/Wed Jan  5 10:23:50 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/31/21 8:56 AM, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> I had a broken pahole and it's been driving me crazy to see tons of the
> following error messages on every build.
> 
> pahole: symbol lookup error: pahole: undefined symbol: btf_gen_floats
> scripts/pahole-flags.sh: line 12: [: : integer expression expected
> scripts/pahole-flags.sh: line 16: [: : integer expression expected
> 
> Address this by redirecting pahole --version stderr to devnull,
> and validate stdout has a non empty string, otherwise exit silently.

I'll leave this up to Andrii, but broken pahole version sounds like it would
have been better to fix the local pahole installation instead [rather than the
kernel having to guard against it, especially if it's driving you crazy]?

I could image that silent exit on empty version string due to broken pahole
deployment might rather waste developer's time to then go and debug why btf
wasn't generated..

> Fixes: 9741e07ece7c ("kbuild: Unify options for BTF generation for vmlinux and modules")
> CC: Andrii Nakryiko <andrii@kernel.org>
> CC: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>   scripts/pahole-flags.sh | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
> index e6093adf4c06..b3b53f890d40 100755
> --- a/scripts/pahole-flags.sh
> +++ b/scripts/pahole-flags.sh
> @@ -7,7 +7,8 @@ if ! [ -x "$(command -v ${PAHOLE})" ]; then
>   	exit 0
>   fi
>   
> -pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
> +pahole_ver=$(${PAHOLE} --version 2>/dev/null | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
> +[ -z "${pahole_ver}" ] && exit 0
>   
>   if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
>   	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
> 

