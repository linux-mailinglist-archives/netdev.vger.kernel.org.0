Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFBB4B1928
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 00:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345515AbiBJXLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 18:11:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345508AbiBJXLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 18:11:52 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC455F5D;
        Thu, 10 Feb 2022 15:11:52 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 1E5A31F469B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1644534711;
        bh=xJk1X1Ou6Pj/lU4m3+l3X4A8FKv0b4TtWehWstyFtXM=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=lkNkBwNu3iDeSbxbxmet/aqfx3hhFrQ3FBBRbXIoO+lQStXrobNg3t/g4nl3tQ1gX
         FIZPublwfNFKTq0N+K3/aOdozYJVx5cKySe/NoLst7xgG5oghsf/2DTe1rKAmYXk52
         OSHezvvvrA2ceJ0fxhgAi35xzbqLDZN6a4Z+DN2AQNHnQT92cxiCzYGSaZhHpD6tqQ
         bYRF3c7Sh6e/B7vfE1bxu5Iji30pldoNAFuBGMvg47DAV/WAwWUVdBtNjDaC3tYaeB
         zUzQ3D2nvsEL2zJywXcCRm+3Lp9K0H4azyW19a8BUVPwPwRd0vy8w/V1khLtWkOR22
         7fPgtj9o+VzXg==
Message-ID: <63e239fc-9282-0276-50b2-3172a446262d@collabora.com>
Date:   Fri, 11 Feb 2022 04:11:40 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     usama.anjum@collabora.com, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2] selftests/seccomp: Fix seccomp failure by adding
 missing headers
Content-Language: en-US
To:     Sherry Yang <sherry.yang@oracle.com>, skhan@linuxfoundation.org,
        shuah@kernel.org, keescook@chromium.org, luto@amacapital.net,
        wad@chromium.org, christian@brauner.io, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
References: <20220210203049.67249-1-sherry.yang@oracle.com>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <20220210203049.67249-1-sherry.yang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/22 1:30 AM, Sherry Yang wrote:
> seccomp_bpf failed on tests 47 global.user_notification_filter_empty
> and 48 global.user_notification_filter_empty_threaded when it's
> tested on updated kernel but with old kernel headers. Because old
> kernel headers don't have definition of macro __NR_clone3 which is
> required for these two tests. Since under selftests/, we can install
> headers once for all tests (the default INSTALL_HDR_PATH is
> usr/include), fix it by adding usr/include to the list of directories
> to be searched. Use "-isystem" to indicate it's a system directory as
> the real kernel headers directories are.
> 
> Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
> Tested-by: Sherry Yang <sherry.yang@oracle.com>
> ---
>  tools/testing/selftests/seccomp/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
> index 0ebfe8b0e147..585f7a0c10cb 100644
> --- a/tools/testing/selftests/seccomp/Makefile
> +++ b/tools/testing/selftests/seccomp/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> -CFLAGS += -Wl,-no-as-needed -Wall
> +CFLAGS += -Wl,-no-as-needed -Wall -isystem ../../../../usr/include/"../../../../usr/include/" directory doesn't have header files if
different output directory is used for kselftests build like "make -C
tools/tests/selftest O=build". Can you try adding recently added
variable, KHDR_INCLUDES here which makes this kind of headers inclusion
easy and correct for other build combinations as well?

