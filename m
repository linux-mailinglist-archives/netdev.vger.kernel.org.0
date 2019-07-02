Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5425D69D
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 21:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfGBTJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 15:09:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfGBTJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 15:09:34 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 327F12186A;
        Tue,  2 Jul 2019 19:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562094573;
        bh=nr1JDauPPw6n4HbH8C5QJYLHrSVRETyq2qq+DRyk/18=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=M7xxS/Xs1oZSK7+skm+JDSozo3HkKEh2OpOC83I0XyRiUzS/36YkxixJUwcQIw0x8
         zMTvk98TQ/c52uA2bABO5LJcO7ADsihQBCNEx/Mw3NuqJIKdlSEJ9dL8wzl2iNubnX
         /wHD69u9WkdZ+d0S7wWWYZwQxxw15hBWVxgHlwO4=
Subject: Re: [PATCHv2] selftests/net: skip psock_tpacket test if KALLSYMS was
 not enabled
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>, davem@davemloft.net,
        linux-kselftest@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuah <shuah@kernel.org>
References: <20190701044031.19451-1-po-hsu.lin@canonical.com>
From:   shuah <shuah@kernel.org>
Message-ID: <8b39caac-0278-93a9-230f-0c9d83657526@kernel.org>
Date:   Tue, 2 Jul 2019 13:09:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190701044031.19451-1-po-hsu.lin@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/30/19 10:40 PM, Po-Hsu Lin wrote:
> The psock_tpacket test will need to access /proc/kallsyms, this would
> require the kernel config CONFIG_KALLSYMS to be enabled first.
> 
> Apart from adding CONFIG_KALLSYMS to the net/config file here, check the
> file existence to determine if we can run this test will be helpful to
> avoid a false-positive test result when testing it directly with the
> following commad against a kernel that have CONFIG_KALLSYMS disabled:
>      make -C tools/testing/selftests TARGETS=net run_tests
> 
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> ---
>   tools/testing/selftests/net/config            |  1 +
>   tools/testing/selftests/net/run_afpackettests | 14 +++++++++-----
>   2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
> index 4740404..3dea2cb 100644
> --- a/tools/testing/selftests/net/config
> +++ b/tools/testing/selftests/net/config
> @@ -25,3 +25,4 @@ CONFIG_NF_TABLES_IPV6=y
>   CONFIG_NF_TABLES_IPV4=y
>   CONFIG_NFT_CHAIN_NAT_IPV6=m
>   CONFIG_NFT_CHAIN_NAT_IPV4=m
> +CONFIG_KALLSYMS=y
> diff --git a/tools/testing/selftests/net/run_afpackettests b/tools/testing/selftests/net/run_afpackettests
> index ea5938e..8b42e8b 100755
> --- a/tools/testing/selftests/net/run_afpackettests
> +++ b/tools/testing/selftests/net/run_afpackettests
> @@ -21,12 +21,16 @@ fi
>   echo "--------------------"
>   echo "running psock_tpacket test"
>   echo "--------------------"
> -./in_netns.sh ./psock_tpacket
> -if [ $? -ne 0 ]; then
> -	echo "[FAIL]"
> -	ret=1
> +if [ -f /proc/kallsyms ]; then
> +	./in_netns.sh ./psock_tpacket
> +	if [ $? -ne 0 ]; then
> +		echo "[FAIL]"
> +		ret=1
> +	else
> +		echo "[PASS]"
> +	fi
>   else
> -	echo "[PASS]"
> +	echo "[SKIP] CONFIG_KALLSYMS not enabled"
>   fi
>   
>   echo "--------------------"
> 

Looks good to me. Thanks for the patch.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
