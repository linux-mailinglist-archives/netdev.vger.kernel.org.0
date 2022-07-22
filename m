Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7572257DC41
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbiGVIWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiGVIWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:22:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDCD9E29F;
        Fri, 22 Jul 2022 01:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 112CBB8273C;
        Fri, 22 Jul 2022 08:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A427EC341C6;
        Fri, 22 Jul 2022 08:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658478128;
        bh=XGwOBIQ70b38PDak8j4LkJrvWTb0yE8WzAWK9ZxMX4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CCJKmNZSo0xL/TYMV2O0Ody1OFAoC7gA7iwMj9taKid7LZJ8uMkZUiXG+aKiVHAG0
         kVE4bHC3UBv5XXr2yhF27+4y27ZEI27zTB7dczgp3h3vpnq62QBoTxKnR8fvsO3e/1
         JmAGrMrEhSajJegpu6zum04O7kpgPsC82/xnxm9YcqtBRDGcCWbvTHz6C3U1kOQUJ6
         Htm1f21uYIgXWE8NbUio/BbgUJMT7Iby9CvcvJDyaNpw8+qufM5g0UnGWS8eeE/Qa9
         7bz4OfWlBbPxGPlkSZSKYdhdp9bYgYB/Bki9jzy4PB0q8LZi1rBmnPTAgZl58B3BXp
         5rwVkSjMUOjPA==
Date:   Fri, 22 Jul 2022 10:21:59 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, casey@schaufler-ca.com,
        ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
Subject: Re: [PATCH v3 1/4] security, lsm: Introduce security_create_user_ns()
Message-ID: <20220722082159.jgvw7jgds3qwfyqk@wittgenstein>
References: <20220721172808.585539-1-fred@cloudflare.com>
 <20220721172808.585539-2-fred@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220721172808.585539-2-fred@cloudflare.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 12:28:05PM -0500, Frederick Lawler wrote:
> Preventing user namespace (privileged or otherwise) creation comes in a
> few of forms in order of granularity:
> 
>         1. /proc/sys/user/max_user_namespaces sysctl
>         2. OS specific patch(es)
>         3. CONFIG_USER_NS
> 
> To block a task based on its attributes, the LSM hook cred_prepare is a
> good candidate for use because it provides more granular control, and
> it is called before create_user_ns():
> 
>         cred = prepare_creds()
>                 security_prepare_creds()
>                         call_int_hook(cred_prepare, ...
>         if (cred)
>                 create_user_ns(cred)
> 
> Since security_prepare_creds() is meant for LSMs to copy and prepare
> credentials, access control is an unintended use of the hook. Therefore
> introduce a new function security_create_user_ns() with an accompanying
> userns_create LSM hook.
> 
> This hook takes the prepared creds for LSM authors to write policy
> against. On success, the new namespace is applied to credentials,
> otherwise an error is returned.
> 
> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
> 
> ---

Nice and straightforward,
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
