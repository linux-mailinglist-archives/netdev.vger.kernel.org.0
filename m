Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6698485B76
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 23:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244754AbiAEWPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 17:15:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38534 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244825AbiAEWOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 17:14:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 553B8B81E1E;
        Wed,  5 Jan 2022 22:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2958C36AE9;
        Wed,  5 Jan 2022 22:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641420861;
        bh=gWq3k/6kzFkkFyA6dHL8WgURioDc9fkU0qvB6+LaeWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X7V7EnS1hS64HI5rreUE/nAkUEpKLijqB0fZh9dPBQX5ZOtaFC0Pkhtx0mTCrsvGJ
         siwDsFj84oALxlrkMsgrYqnOXxEajwLMRdSqpPCMH+kIxHtPChNut7BbDh/w/sMxCq
         IaZu/7/8miFr+TfUSGElvu2lxpwl9aiRkxT5yzyTA+x4cLW7hXEaDMp51db8qsHJA3
         5ImYlKHdpSAqW7ykv/8OKoj7MytWRYhMZB4iLQ9LznC58TIpLkjb3nU+AAUZZd4wPy
         nf2hKaTwQ4vEznyHJvrPyHDTVp72e6mdTNJQD1FiRWJ3XVS1FG+j9T5xAKsTVOnVr1
         aOhqbeETJqe3w==
Date:   Wed, 5 Jan 2022 14:14:19 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH net] scripts/pahole-flags.sh: Make sure pahole --version
 works
Message-ID: <20220105221419.tlp4lp2h5ttvssuh@sx1>
References: <20211231075607.94752-1-saeed@kernel.org>
 <8cf93086-4990-f14a-3271-92bc2ee0519e@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8cf93086-4990-f14a-3271-92bc2ee0519e@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 02:42:01PM +0100, Daniel Borkmann wrote:
>On 12/31/21 8:56 AM, Saeed Mahameed wrote:
>>From: Saeed Mahameed <saeedm@nvidia.com>
>>
>>I had a broken pahole and it's been driving me crazy to see tons of the
>>following error messages on every build.
>>
>>pahole: symbol lookup error: pahole: undefined symbol: btf_gen_floats
>>scripts/pahole-flags.sh: line 12: [: : integer expression expected
>>scripts/pahole-flags.sh: line 16: [: : integer expression expected
>>
>>Address this by redirecting pahole --version stderr to devnull,
>>and validate stdout has a non empty string, otherwise exit silently.
>
>I'll leave this up to Andrii, but broken pahole version sounds like it would
>have been better to fix the local pahole installation instead [rather than the
>kernel having to guard against it, especially if it's driving you crazy]?
>

Already did :)

>I could image that silent exit on empty version string due to broken pahole
>deployment might rather waste developer's time to then go and debug why btf
>wasn't generated..
>

Good point, I was mainly thinking about developers who are not familiar with btf
and who have no time debugging irrelevant build issues, but up to you, I
personally like silent build scripts.

>>Fixes: 9741e07ece7c ("kbuild: Unify options for BTF generation for vmlinux and modules")
>>CC: Andrii Nakryiko <andrii@kernel.org>
>>CC: Jiri Olsa <jolsa@redhat.com>
>>Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>>---
>>  scripts/pahole-flags.sh | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>>diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
>>index e6093adf4c06..b3b53f890d40 100755
>>--- a/scripts/pahole-flags.sh
>>+++ b/scripts/pahole-flags.sh
>>@@ -7,7 +7,8 @@ if ! [ -x "$(command -v ${PAHOLE})" ]; then
>>  	exit 0
>>  fi
>>-pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
>>+pahole_ver=$(${PAHOLE} --version 2>/dev/null | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
>>+[ -z "${pahole_ver}" ] && exit 0
>>  if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
>>  	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
>>
>
