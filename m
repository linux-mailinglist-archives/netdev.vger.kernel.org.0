Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF8862E4A2
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 19:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240684AbiKQSnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 13:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240662AbiKQSm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 13:42:58 -0500
Received: from smtp-bc0e.mail.infomaniak.ch (smtp-bc0e.mail.infomaniak.ch [45.157.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A5486A57
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 10:42:57 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NCph00gQyzMpnsN;
        Thu, 17 Nov 2022 19:42:56 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4NCpgz3dPJzMppF7;
        Thu, 17 Nov 2022 19:42:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1668710576;
        bh=fYc9X97hnclwNG+H0gFe0zOj3YwA4juRfn/QqOEsmLM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uqok18y1hHIXiiPXTqawR9yqncT2lTGEjfPTEDP7WZRTu6cvQyI9TijEBeEwOifV9
         Q7GoYr3n0XyUTPjiWcFM9Hxx+Zh5JA6UmeE6QcJUoZMJjLy7CzZZ3+TbDUiGjYqQxE
         jlpvPY3IiF4WYW518Wy9SOPdfjPRDookoh8Di7nU=
Message-ID: <df4a441f-07c4-8eb0-6c71-58dc06604dd9@digikod.net>
Date:   Thu, 17 Nov 2022 19:42:54 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 06/12] landlock: Refactor landlock_add_rule() syscall
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-7-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20221021152644.155136-7-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21/10/2022 17:26, Konstantin Meskhidze wrote:
> Modifies landlock_add_rule() syscall to support new rule types in future

Change the landlock_add_rule() syscall…


> Landlock versions. Adds add_rule_path_beneath() helper to support

Add the…

> current filesystem rules.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
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
>   security/landlock/syscalls.c | 92 +++++++++++++++++++-----------------
>   1 file changed, 48 insertions(+), 44 deletions(-)
> 
> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index 71aca7f990bc..87389d7bfbf2 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -274,6 +274,47 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
>   	return err;
>   }
> 
> +static int add_rule_path_beneath(struct landlock_ruleset *const ruleset,
> +				 const void __user *const rule_attr)
> +{
> +	struct landlock_path_beneath_attr path_beneath_attr;
> +	struct path path;
> +	int res, err;
> +	u32 mask;

access_mask_t mask;
