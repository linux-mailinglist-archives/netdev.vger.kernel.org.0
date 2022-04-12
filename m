Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261DE4FDFC2
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352174AbiDLMMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354717AbiDLMKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:10:21 -0400
Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7318D82D37;
        Tue, 12 Apr 2022 04:12:32 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Kd33L5xM1zMprpV;
        Tue, 12 Apr 2022 13:12:30 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Kd33L2CSkzlhMCQ;
        Tue, 12 Apr 2022 13:12:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1649761950;
        bh=bZYdW/tm5O312A9NSRRHYt/TwJO5MHrCuiyBeQhEYJs=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=IvnE3N6f00aDiZ2pmCgA763PDaKbUTjgpp1nKbskBjmK7gMVauHaApwNTQLYS32qO
         fcykJwt363hiwwd9xd6niS3L21iGgnb/49pOa1rvcQTvX89me3JnLLRvVD6deuUhJe
         y0Q2hIVUveb5nBJ5xmIYlQkH0qBd4aqgj3i4CZl8=
Message-ID: <638ae3c4-09cd-2eaf-858b-4909f2a9cdcc@digikod.net>
Date:   Tue, 12 Apr 2022 13:12:48 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-7-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 06/15] landlock: landlock_add_rule syscall
 refactoring
In-Reply-To: <20220309134459.6448-7-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/03/2022 14:44, Konstantin Meskhidze wrote:
> Landlock_add_rule syscall was refactored to support new
> rule types in future Landlock versions. Add_rule_path_beneath()
> helper was added to support current filesystem rules. It is called
> by the switch case.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v3:
> * Split commit.
> * Refactoring landlock_add_rule syscall.
> 
> ---
>   security/landlock/syscalls.c | 95 ++++++++++++++++++++----------------
>   1 file changed, 53 insertions(+), 42 deletions(-)
> 
> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index 5931b666321d..8c0f6165fe3a 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -274,54 +274,13 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
>   	return err;
>   }
> 
> -/**
> - * sys_landlock_add_rule - Add a new rule to a ruleset
> - *
> - * @ruleset_fd: File descriptor tied to the ruleset that should be extended
> - *		with the new rule.
> - * @rule_type: Identify the structure type pointed to by @rule_attr (only
> - *             LANDLOCK_RULE_PATH_BENEATH for now).
> - * @rule_attr: Pointer to a rule (only of type &struct
> - *             landlock_path_beneath_attr for now).
> - * @flags: Must be 0.
> - *
> - * This system call enables to define a new rule and add it to an existing
> - * ruleset.
> - *
> - * Possible returned errors are:
> - *
> - * - EOPNOTSUPP: Landlock is supported by the kernel but disabled at boot time;
> - * - EINVAL: @flags is not 0, or inconsistent access in the rule (i.e.
> - *   &landlock_path_beneath_attr.allowed_access is not a subset of the rule's
> - *   accesses);
> - * - ENOMSG: Empty accesses (e.g. &landlock_path_beneath_attr.allowed_access);
> - * - EBADF: @ruleset_fd is not a file descriptor for the current thread, or a
> - *   member of @rule_attr is not a file descriptor as expected;
> - * - EBADFD: @ruleset_fd is not a ruleset file descriptor, or a member of
> - *   @rule_attr is not the expected file descriptor type (e.g. file open
> - *   without O_PATH);
> - * - EPERM: @ruleset_fd has no write access to the underlying ruleset;
> - * - EFAULT: @rule_attr inconsistency.
> - */
> -SYSCALL_DEFINE4(landlock_add_rule,
> -		const int, ruleset_fd, const enum landlock_rule_type, rule_type,
> -		const void __user *const, rule_attr, const __u32, flags)
> +static int add_rule_path_beneath(const int ruleset_fd, const void *const rule_attr)
>   {
>   	struct landlock_path_beneath_attr path_beneath_attr;
>   	struct path path;
>   	struct landlock_ruleset *ruleset;
>   	int res, err;
> 
> -	if (!landlock_initialized)
> -		return -EOPNOTSUPP;
> -
> -	/* No flag for now. */
> -	if (flags)
> -		return -EINVAL;
> -
> -	if (rule_type != LANDLOCK_RULE_PATH_BENEATH)
> -		return -EINVAL;
> -
>   	/* Copies raw user space buffer, only one type for now. */
>   	res = copy_from_user(&path_beneath_attr, rule_attr,
>   			sizeof(path_beneath_attr));
> @@ -367,6 +326,58 @@ SYSCALL_DEFINE4(landlock_add_rule,
>   	return err;
>   }
> 
> +/**
> + * sys_landlock_add_rule - Add a new rule to a ruleset
> + *
> + * @ruleset_fd: File descriptor tied to the ruleset that should be extended
> + *		with the new rule.
> + * @rule_type: Identify the structure type pointed to by @rule_attr (only
> + *             LANDLOCK_RULE_PATH_BENEATH for now).
> + * @rule_attr: Pointer to a rule (only of type &struct
> + *             landlock_path_beneath_attr for now).
> + * @flags: Must be 0.
> + *
> + * This system call enables to define a new rule and add it to an existing
> + * ruleset.
> + *
> + * Possible returned errors are:
> + *
> + * - EOPNOTSUPP: Landlock is supported by the kernel but disabled at boot time;
> + * - EINVAL: @flags is not 0, or inconsistent access in the rule (i.e.
> + *   &landlock_path_beneath_attr.allowed_access is not a subset of the rule's
> + *   accesses);
> + * - ENOMSG: Empty accesses (e.g. &landlock_path_beneath_attr.allowed_access);
> + * - EBADF: @ruleset_fd is not a file descriptor for the current thread, or a
> + *   member of @rule_attr is not a file descriptor as expected;
> + * - EBADFD: @ruleset_fd is not a ruleset file descriptor, or a member of
> + *   @rule_attr is not the expected file descriptor type (e.g. file open
> + *   without O_PATH);
> + * - EPERM: @ruleset_fd has no write access to the underlying ruleset;
> + * - EFAULT: @rule_attr inconsistency.
> + */
> +SYSCALL_DEFINE4(landlock_add_rule,
> +		const int, ruleset_fd, const enum landlock_rule_type, rule_type,
> +		const void __user *const, rule_attr, const __u32, flags)
> +{
> +	int err;
> +
> +	if (!landlock_initialized)
> +		return -EOPNOTSUPP;
> +
> +	/* No flag for now. */
> +	if (flags)
> +		return -EINVAL;

As you can see in my yesterday patch, the get_ruleset_from_fd() call 
should be here.


> +
> +	switch (rule_type) {
> +	case LANDLOCK_RULE_PATH_BENEATH:
> +		err = add_rule_path_beneath(ruleset_fd, rule_attr);
> +		break;
> +	default:
> +		err = -EINVAL;
> +	}
> +	return err;
> +}
> +
>   /* Enforcement */
> 
>   /**
> --
> 2.25.1
> 
