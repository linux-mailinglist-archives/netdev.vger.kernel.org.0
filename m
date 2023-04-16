Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8E86E3A1E
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 18:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjDPQJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 12:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDPQJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 12:09:09 -0400
Received: from smtp-bc0e.mail.infomaniak.ch (smtp-bc0e.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc0e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8DD26A8
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 09:09:06 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Pzw9C0rWmzMqCDy;
        Sun, 16 Apr 2023 18:09:03 +0200 (CEST)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Pzw996qkBzMppvT;
        Sun, 16 Apr 2023 18:09:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1681661343;
        bh=kY4S108Y0pi3vPoK9oq+aCD9SmOQ5q6AdkfXTt90Ym8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hdDdmBQM26ILvhHrHEMX3UGucwRe6obHzrffHRDb/Z9FhGerMxjX4iDOWB4uK6ES3
         P47cF81mnBZwMyD9lg6cyAQJ7Y/CPzpkUd4xkZ2gANDHFmRT4aF5KQ+pO0qZPi7/xu
         0rwSpWK0pce21n0HCovLxaEVBHR9NlrhnRfhqKkI=
Message-ID: <062447d5-bd64-f58e-9476-0d2d2034f333@digikod.net>
Date:   Sun, 16 Apr 2023 18:09:08 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v10 02/13] landlock: Allow filesystem layout changes for
 domains without such rule type
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-3-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230323085226.1432550-3-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/03/2023 09:52, Konstantin Meskhidze wrote:
> From: Mickaël Salaün <mic@digikod.net>
> 
> Allow mount point and root directory changes when there is no filesystem
> rule tied to the current Landlock domain.  This doesn't change anything
> for now because a domain must have at least a (filesystem) rule, but
> this will change when other rule types will come.  For instance, a
> domain only restricting the network should have no impact on filesystem
> restrictions.
> 
> Add a new get_current_fs_domain() helper to quickly check filesystem
> rule existence for all filesystem LSM hooks.
> 
> Remove unnecessary inlining.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> ---
> 
> Changes since v9:
> * Refactors documentaion landlock.rst.
> * Changes ACCESS_FS_INITIALLY_DENIED constant
> to LANDLOCK_ACCESS_FS_INITIALLY_DENIED.
> * Gets rid of unnecessary masking of access_dom in
> get_raw_handled_fs_accesses() function.
> 
> Changes since v8:
> * Refactors get_handled_fs_accesses().
> * Adds landlock_get_raw_fs_access_mask() helper.
> 
> ---
>   Documentation/userspace-api/landlock.rst |  6 +-
>   security/landlock/fs.c                   | 78 ++++++++++++------------
>   security/landlock/ruleset.h              | 25 +++++++-
>   security/landlock/syscalls.c             |  6 +-
>   4 files changed, 68 insertions(+), 47 deletions(-)
> 

[...]

> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index 71aca7f990bc..d35cd5d304db 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -310,6 +310,7 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
>   	struct path path;
>   	struct landlock_ruleset *ruleset;
>   	int res, err;
> +	access_mask_t mask;
> 
>   	if (!landlock_initialized)
>   		return -EOPNOTSUPP;
> @@ -348,9 +349,8 @@ SYSCALL_DEFINE4(landlock_add_rule, const int, ruleset_fd,
>   	 * Checks that allowed_access matches the @ruleset constraints
>   	 * (ruleset->access_masks[0] is automatically upgraded to 64-bits).
>   	 */
> -	if ((path_beneath_attr.allowed_access |
> -	     landlock_get_fs_access_mask(ruleset, 0)) !=
> -	    landlock_get_fs_access_mask(ruleset, 0)) {
> +	mask = landlock_get_raw_fs_access_mask(ruleset, 0);
> +	if ((path_beneath_attr.allowed_access | mask) != mask) {

This hunk can be moved to the previous patch (i.e. mask = …). This patch 
should only contains the new landlock_get_raw_fs_access_mask() call.


>   		err = -EINVAL;
>   		goto out_put_ruleset;
>   	}
> --
> 2.25.1
> 
