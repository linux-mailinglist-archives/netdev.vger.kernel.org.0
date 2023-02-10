Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB9769248E
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbjBJRg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbjBJRg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:36:57 -0500
Received: from smtp-42ae.mail.infomaniak.ch (smtp-42ae.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ae])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52B1B46F
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 09:36:55 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PD1BV1Pc3zMqvc8;
        Fri, 10 Feb 2023 18:36:50 +0100 (CET)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4PD1BT34J3zMrPCY;
        Fri, 10 Feb 2023 18:36:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1676050610;
        bh=YZzAYC81mA80WyAKHIQsLTNokUD3fImvjpBYUNazif4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=d6hn7yZwytcvla6MGDO9ShvZekx0TOb4ZpzyQg3XCZ0KFSXN3vz21dQ2dVvXmQHLC
         dHYvxKvkseg5YPiV7MdudkBvLGnd0MiaUCUtL0ak4yKbn/7NdmmpgTACdb6aBCjftb
         d139LBmYffNZZggnNXuQX+CTuJf9iyPjgUmwZ/sI=
Message-ID: <d014f6db-0073-5461-afcd-5b046f3db096@digikod.net>
Date:   Fri, 10 Feb 2023 18:36:48 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 03/12] landlock: Refactor
 landlock_find_rule/insert_rule
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-4-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230116085818.165539-4-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16/01/2023 09:58, Konstantin Meskhidze wrote:
> Add a new landlock_key union and landlock_id structure to support
> a socket port rule type. A struct landlock_id identifies a unique entry
> in a ruleset: either a kernel object (e.g inode) or typed data (e.g TCP
> port). There is one red-black tree per key type.
> 
> This patch also adds is_object_pointer() and get_root() helpers.
> is_object_pointer() returns true if key type is LANDLOCK_KEY_INODE.
> get_root() helper returns a red_black tree root pointer according to
> a key type.
> 
> Refactor landlock_insert_rule() and landlock_find_rule() to support coming
> network modifications. Adding or searching a rule in ruleset can now be
> done thanks to a Landlock ID argument passed to these helpers.
> 
> Remove unnecessary inlining.
> 

You need to keep the Co-developed-by before the Signed-off-by for my entry.

> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v8:
> * Refactors commit message.
> * Removes inlining.
> * Minor fixes.
> 
> Changes since v7:
> * Completes all the new field descriptions landlock_key,
>    landlock_key_type, landlock_id.
> * Refactors commit message, adds a co-developer.
> 
> Changes since v6:
> * Adds union landlock_key, enum landlock_key_type, and struct
>    landlock_id.
> * Refactors ruleset functions and improves switch/cases: create_rule(),
>    insert_rule(), get_root(), is_object_pointer(), free_rule(),
>    landlock_find_rule().
> * Refactors landlock_append_fs_rule() functions to support new
>    landlock_id type.
> 
> Changes since v5:
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Refactors insert_rule() and create_rule() functions by deleting
> rule_type from their arguments list, it helps to reduce useless code.
> 
> Changes since v3:
> * Splits commit.
> * Refactors landlock_insert_rule and landlock_find_rule functions.
> * Rename new_ruleset->root_inode.
> 
> ---
>   security/landlock/fs.c      |  49 ++++++------
>   security/landlock/ruleset.c | 148 +++++++++++++++++++++++++-----------
>   security/landlock/ruleset.h |  65 +++++++++++++---
>   3 files changed, 185 insertions(+), 77 deletions(-)
> 
> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
> index 0ae54a639e16..273ed8549da1 100644
> --- a/security/landlock/fs.c
> +++ b/security/landlock/fs.c

[...]

> @@ -191,12 +193,15 @@ int landlock_append_fs_rule(struct landlock_ruleset *const ruleset,
>    *
>    * Returns NULL if no rule is found or if @dentry is negative.
>    */
> -static inline const struct landlock_rule *
> +static const struct landlock_rule *

Can you please create a (previous) dedicated patch for all the inlining 
changes?


>   find_rule(const struct landlock_ruleset *const domain,
>   	  const struct dentry *const dentry)
>   {
>   	const struct landlock_rule *rule;
>   	const struct inode *inode;
> +	struct landlock_id id = {
> +		.type = LANDLOCK_KEY_INODE,
> +	};
>   
>   	/* Ignores nonexistent leafs. */
>   	if (d_is_negative(dentry))

[...]

> @@ -652,7 +657,7 @@ static inline int check_access_path(const struct landlock_ruleset *const domain,
>   }
>   
>   static int current_check_access_path(const struct path *const path,
> -					    const access_mask_t access_request)
> +				     const access_mask_t access_request)

This syntax fix should be moved to patch 2/12.


[...]

> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
> index 1f3188b4e313..c5c88a100f74 100644
> --- a/security/landlock/ruleset.c
> +++ b/security/landlock/ruleset.c

[...]

> @@ -285,23 +333,23 @@ static int merge_ruleset(struct landlock_ruleset *const dst,


> -		if (WARN_ON_ONCE(walker_rule->num_layers != 1)) {
> -			err = -EINVAL;
> -			goto out_unlock;
> -		}
> -		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0)) {
> -			err = -EINVAL;
> -			goto out_unlock;
> -		}
> +		if (WARN_ON_ONCE(walker_rule->num_layers != 1))
> +			return -EINVAL;
> +		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0))
> +			return -EINVAL;

This introduces two potential bugs. Why change this code?
