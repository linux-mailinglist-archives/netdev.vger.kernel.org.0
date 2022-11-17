Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FC862E4AA
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 19:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240704AbiKQSoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 13:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240509AbiKQSn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 13:43:56 -0500
Received: from smtp-8faf.mail.infomaniak.ch (smtp-8faf.mail.infomaniak.ch [IPv6:2001:1600:3:17::8faf])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BF3D2E1
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 10:43:54 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NCpj526JjzMpnfl;
        Thu, 17 Nov 2022 19:43:53 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4NCpj44ZCXzMpnPc;
        Thu, 17 Nov 2022 19:43:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1668710633;
        bh=flViVCnxrcbvocS6RXp/Cd/lLoxdHH641JZYXBowmcw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Dt/vbPUKA6CRPYSdu8UmtxgBZf+e9kgCRxcrZhwqkSptQnkLvW+ij8cCoCm7gJrnA
         RpQrZJ8PapqK+XEI+WrdJ4FkBDowXV/Cd5+T0ZCFLSbnEna/cKhf6EopbXxbDBlSDE
         TSU1sEw34yVYCj1WXWEVHFxU/9BlmrvNoniBxECU=
Message-ID: <62210161-c645-7999-0a2b-95c539d990ba@digikod.net>
Date:   Thu, 17 Nov 2022 19:43:52 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 09/12] selftests/landlock: Share enforce_ruleset()
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-10-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20221021152644.155136-10-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21/10/2022 17:26, Konstantin Meskhidze wrote:
> This commit moves enforce_ruleset() helper function to common.h so that
> to be used both by filesystem tests and network ones.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v7:
> * Refactors commit message.
> 
> Changes since v6:
> * None.
> 
> Changes since v5:
> * Splits commit.
> * Moves enforce_ruleset helper into common.h
> * Formats code with clang-format-14.
> 
> ---
>   tools/testing/selftests/landlock/common.h  | 10 ++++++++++
>   tools/testing/selftests/landlock/fs_test.c | 10 ----------
>   2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
> index d7987ae8d7fc..bafed1c0c2a6 100644
> --- a/tools/testing/selftests/landlock/common.h
> +++ b/tools/testing/selftests/landlock/common.h
> @@ -256,3 +256,13 @@ static int __maybe_unused send_fd(int usock, int fd_tx)
>   		return -errno;
>   	return 0;
>   }
> +
> +__attribute__((__unused__)) static void

We can now use __maybe_unused instead. This enables to avoid 
checkpatch.pl warning.


> +enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
> +{
> +	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
> +	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
> +	{
> +		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
> +	}
> +}
> diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
> index d5dab986f612..20c1ac8485f1 100644
> --- a/tools/testing/selftests/landlock/fs_test.c
> +++ b/tools/testing/selftests/landlock/fs_test.c
> @@ -563,16 +563,6 @@ static int create_ruleset(struct __test_metadata *const _metadata,
>   	return ruleset_fd;
>   }
> 
> -static void enforce_ruleset(struct __test_metadata *const _metadata,
> -			    const int ruleset_fd)
> -{
> -	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
> -	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
> -	{
> -		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
> -	}
> -}
> -
>   TEST_F_FORK(layout1, proc_nsfs)
>   {
>   	const struct rule rules[] = {
> --
> 2.25.1
> 
