Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F712C637E
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgK0Kyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:54:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726039AbgK0Kyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:54:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606474483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ouvI00UbI/uzDqEObWfu8c5eamHZNFtUjMgSLpP+1nc=;
        b=TaetW1pga+DdLku+NWRiZ6Do1Uz+WPc21OZFle9NubMQtEqz5tk26kI2GDQJAxfzuDLLzO
        bsHvzg3lCR1jBikPOHMdl1LbbSNU3umA0N40bJBNxsmH8FGp68y3bSKedNUY5xrc/5iTWO
        M0+JD/FJM49KW5vdbC6z3DXY066GDpI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-LK5kzVwhMMOgZRpiIqXEoA-1; Fri, 27 Nov 2020 05:54:40 -0500
X-MC-Unique: LK5kzVwhMMOgZRpiIqXEoA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0DC48049C7;
        Fri, 27 Nov 2020 10:54:38 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.192.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DA6D60BF1;
        Fri, 27 Nov 2020 10:54:37 +0000 (UTC)
Date:   Fri, 27 Nov 2020 11:54:34 +0100
From:   Antonio Cardace <acardace@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, shuah@kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH] tools/testing: add kselftest shell helper library
Message-ID: <20201127105434.vwojcml2lpa7zvqi@yoda.fritz.box>
References: <20201123162508.585279-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123162508.585279-1-willemdebruijn.kernel@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 11:25:08AM -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Kselftest expects processes to signal pass/fail/skip through exitcode.
> 
> C programs can include kselftest.h for readable definitions.
> 
> Add analogous kselftest.sh for shell tests. Extract the existing
> definitions from udpgso_bench.sh.
> 
> Tested: make TARGETS=net kselftest
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20201113231655.139948-4-acardace@redhat.com/
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> 
> ---
> 
> applies cleanly to netnext (f9e425e99b07) and kselftest (v5.10-rc1)
> ---
>  tools/testing/selftests/kselftest.sh        | 52 +++++++++++++++++++++
>  tools/testing/selftests/net/udpgso_bench.sh | 42 +----------------
>  2 files changed, 53 insertions(+), 41 deletions(-)
>  create mode 100644 tools/testing/selftests/kselftest.sh
> 
> diff --git a/tools/testing/selftests/kselftest.sh b/tools/testing/selftests/kselftest.sh
> new file mode 100644
> index 000000000000..c5a1cff57402
> --- /dev/null
> +++ b/tools/testing/selftests/kselftest.sh
> @@ -0,0 +1,52 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# kselftest shell test support library
> +#
> +# - Define pass/fail/skip exitcodes
> +# - Multiprocess support: aggregate child process results
> +
> +readonly KSFT_PASS=0
> +readonly KSFT_FAIL=1
> +readonly KSFT_SKIP=4
> +
> +readonly GREEN='\033[0;92m'
> +readonly YELLOW='\033[0;33m'
> +readonly RED='\033[0;31m'
> +readonly NC='\033[0m' # No Color
> +
> +num_pass=0
> +num_err=0
> +num_skip=0
> +
> +# Test child process exit code, add to aggregates.
> +kselftest_test_exitcode() {
> +	local -r exitcode=$1
> +
> +	if [[ ${exitcode} -eq ${KSFT_PASS} ]]; then
> +		num_pass=$(( $num_pass + 1 ))
> +	elif [[ ${exitcode} -eq ${KSFT_SKIP} ]]; then
> +		num_skip=$(( $num_skip + 1 ))
> +	else
> +		num_err=$(( $num_err + 1 ))
> +	fi
> +}
> +
> +# Exit from main process.
> +kselftest_exit() {
> +	echo -e "$(basename $0): PASS=${num_pass} SKIP=${num_skip} FAIL=${num_err}"
> +
> +	if [[ $num_err -ne 0 ]]; then
> +		echo -e "$(basename $0): ${RED}FAIL${NC}"
> +		exit ${KSFT_FAIL}
> +	fi
> +
> +	if [[ $num_skip -ne 0 ]]; then
> +		echo -e "$(basename $0): ${YELLOW}SKIP${NC}"
> +		exit ${KSFT_SKIP}
> +	fi
> +
> +	echo -e "$(basename $0): ${GREEN}PASS${NC}"
> +	exit ${KSFT_PASS}
> +}
> +
> diff --git a/tools/testing/selftests/net/udpgso_bench.sh b/tools/testing/selftests/net/udpgso_bench.sh
> index 80b5d352702e..c1f9affe6cf0 100755
> --- a/tools/testing/selftests/net/udpgso_bench.sh
> +++ b/tools/testing/selftests/net/udpgso_bench.sh
> @@ -3,47 +3,7 @@
>  #
>  # Run a series of udpgso benchmarks
> 
> -readonly GREEN='\033[0;92m'
> -readonly YELLOW='\033[0;33m'
> -readonly RED='\033[0;31m'
> -readonly NC='\033[0m' # No Color
> -
> -readonly KSFT_PASS=0
> -readonly KSFT_FAIL=1
> -readonly KSFT_SKIP=4
> -
> -num_pass=0
> -num_err=0
> -num_skip=0
> -
> -kselftest_test_exitcode() {
> -	local -r exitcode=$1
> -
> -	if [[ ${exitcode} -eq ${KSFT_PASS} ]]; then
> -		num_pass=$(( $num_pass + 1 ))
> -	elif [[ ${exitcode} -eq ${KSFT_SKIP} ]]; then
> -		num_skip=$(( $num_skip + 1 ))
> -	else
> -		num_err=$(( $num_err + 1 ))
> -	fi
> -}
> -
> -kselftest_exit() {
> -	echo -e "$(basename $0): PASS=${num_pass} SKIP=${num_skip} FAIL=${num_err}"
> -
> -	if [[ $num_err -ne 0 ]]; then
> -		echo -e "$(basename $0): ${RED}FAIL${NC}"
> -		exit ${KSFT_FAIL}
> -	fi
> -
> -	if [[ $num_skip -ne 0 ]]; then
> -		echo -e "$(basename $0): ${YELLOW}SKIP${NC}"
> -		exit ${KSFT_SKIP}
> -	fi
> -
> -	echo -e "$(basename $0): ${GREEN}PASS${NC}"
> -	exit ${KSFT_PASS}
> -}
> +source "$(dirname $0)/../kselftest.sh"
> 
>  wake_children() {
>  	local -r jobs="$(jobs -p)"
> --
> 2.29.2.454.gaff20da3a2-goog
> 

Reviewed-by: Antonio Cardace <acardace@redhat>

