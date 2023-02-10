Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA3769249C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbjBJRit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjBJRis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:38:48 -0500
Received: from smtp-bc0d.mail.infomaniak.ch (smtp-bc0d.mail.infomaniak.ch [45.157.188.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3690F78D69
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 09:38:46 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PD1Dh46zMzMr4SQ;
        Fri, 10 Feb 2023 18:38:44 +0100 (CET)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PD1Dg6QntzMrVgY;
        Fri, 10 Feb 2023 18:38:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1676050724;
        bh=YMXN/Ou/QFoSuFOOuqtOyOieN0mWJ/XfHSqmYy6DxBE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=AjmyX4+dMfvJ5SQB74r9t+XuVv9O0hgPm9pZ/ZVIGsmekkugRAXElyRoqmILu8T4t
         v/6l1QdiJUB+wsNCpLgCXD1SqjaUq6QMTB/VXbQ5SCvhih8ytHLgyBLbt0JD/Q6mo3
         cQ6hPQLCJOkuKDVTu2ADG0QigsjBKezqHrOwrbP8=
Message-ID: <633f6f0e-4380-4a2b-3e1a-ea4691092c08@digikod.net>
Date:   Fri, 10 Feb 2023 18:38:43 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 07/12] landlock: Refactor landlock_add_rule() syscall
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-8-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230116085818.165539-8-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16/01/2023 09:58, Konstantin Meskhidze wrote:
> Change the landlock_add_rule() syscall to support new rule types
> in future Landlock versions. Add the add_rule_path_beneath() helper
> to support current filesystem rules.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v8:
> * Refactors commit message.
> * Minor fixes.
> 
> Changes since v7:
> * None
> 
> Changes since v6:
> * None
> 
> Changes since v5:
> * Refactors syscall landlock_add_rule() and add_rule_path_beneath() helper
> to make argument check ordering consistent and get rid of partial revertings
> in following patches.
> * Rolls back refactoring base_test.c seltest.
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors add_rule_path_beneath() and landlock_add_rule() functions
> to optimize code usage.
> * Refactors base_test.c seltest: adds LANDLOCK_RULE_PATH_BENEATH
> rule type in landlock_add_rule() call.
> 
> Changes since v3:
> * Split commit.
> * Refactors landlock_add_rule syscall.
> 
> ---
>   security/landlock/syscalls.c | 94 +++++++++++++++++++-----------------
>   1 file changed, 50 insertions(+), 44 deletions(-)
> 
> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index d35cd5d304db..73c80cd2cdbe 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -274,6 +274,49 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
>   	return err;
>   }
>   
> +static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
> +				 const void __user *const rule_attr)
> +{
> +	struct landlock_path_beneath_attr path_beneath_attr;
> +	struct path path;
> +	int res, err;
> +	access_mask_t mask;
> +
> +	/* Copies raw user space buffer, only one type for now. */
> +	res = copy_from_user(&path_beneath_attr, rule_attr,
> +			     sizeof(path_beneath_attr));
> +	if (res)
> +		return -EFAULT;
> +
> +	/*
> +	 * Informs about useless rule: empty allowed_access (i.e. deny rules)
> +	 * are ignored in path walks.
> +	 */
> +	if (!path_beneath_attr.allowed_access) {
> +		return -ENOMSG;
> +	}

Please follows the ./scripts/checkpatch.pl conventions (i.e. no curly 
braces). You should add an empty line after this return though.



> +	/*
> +	 * Checks that allowed_access matches the @ruleset constraints
> +	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
> +	 */
> +	mask = landlock_get_raw_fs_access_mask(ruleset, 0);
> +	if ((path_beneath_attr.allowed_access | mask) != mask) {
> +		return -EINVAL;
> +	}

Same here.

> +
> +	/* Gets and checks the new rule. */
> +	err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
> +	if (err)
> +		return err;
> +
> +	/* Imports the new rule. */
> +	err = landlock_append_fs_rule(ruleset, &path,
> +				      path_beneath_attr.allowed_access);
> +	path_put(&path);
> +

No need for this empty line.

> +	return err;
> +}
> +
