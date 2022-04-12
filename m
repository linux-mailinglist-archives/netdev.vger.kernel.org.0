Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A8F4FDFF2
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354443AbiDLMVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355386AbiDLMTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:19:00 -0400
Received: from smtp-8faa.mail.infomaniak.ch (smtp-8faa.mail.infomaniak.ch [IPv6:2001:1600:4:17::8faa])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AE78CCE4
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 04:21:20 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Kd3FW2FPGzMq00y;
        Tue, 12 Apr 2022 13:21:19 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Kd3FV5Cj0zlhSMn;
        Tue, 12 Apr 2022 13:21:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1649762479;
        bh=rm7a8rabVO5Lb6X8RYrfyMkwRDPX4KxWPPKKY4ubdY4=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=09gLwqKl5nZSYLhNLonAbaTdkPCwlmWvSEmvsrrRAKFPfrzMmD6swTKDvniKI/c8a
         9duU285iQR+h6m4FSerzjPmn88Ow8bD1j1S3Ju372SysJCA2JYitmR7P28tq+r8i/4
         bmghbm9gWZzyd2VX2xJKCX7YZo2cJqx24FBwtkfo=
Message-ID: <d4724117-167d-00b0-1f10-749b35bffc2f@digikod.net>
Date:   Tue, 12 Apr 2022 13:21:36 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-8-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 07/15] landlock: user space API network support
In-Reply-To: <20220309134459.6448-8-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/03/2022 14:44, Konstantin Meskhidze wrote:
> User space API was refactored to support
> network actions. New network access flags,
> network rule and network attributes were
> added.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v3:
> * Split commit.
> * Refactoring User API for network rule type.
> 
> ---
>   include/uapi/linux/landlock.h | 48 +++++++++++++++++++++++++++++++++++
>   security/landlock/syscalls.c  |  5 ++--
>   2 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
> index b3d952067f59..4fc6c793fdf4 100644
> --- a/include/uapi/linux/landlock.h
> +++ b/include/uapi/linux/landlock.h
> @@ -25,6 +25,13 @@ struct landlock_ruleset_attr {
>   	 * compatibility reasons.
>   	 */
>   	__u64 handled_access_fs;
> +
> +	/**
> +	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
> +	 * that is handled by this ruleset and should then be forbidden if no
> +	 * rule explicitly allow them.
> +	 */
> +	__u64 handled_access_net;
>   };
> 
>   /*
> @@ -46,6 +53,11 @@ enum landlock_rule_type {
>   	 * landlock_path_beneath_attr .
>   	 */
>   	LANDLOCK_RULE_PATH_BENEATH = 1,
> +	/**
> +	 * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
> +	 * landlock_net_service_attr .
> +	 */
> +	LANDLOCK_RULE_NET_SERVICE = 2,
>   };
> 
>   /**
> @@ -70,6 +82,24 @@ struct landlock_path_beneath_attr {
>   	 */
>   } __attribute__((packed));
> 
> +/**
> + * struct landlock_net_service_attr - TCP subnet definition
> + *
> + * Argument of sys_landlock_add_rule().
> + */
> +struct landlock_net_service_attr {
> +	/**
> +	 * @allowed_access: Bitmask of allowed access network for services
> +	 * (cf. `Network flags`_).
> +	 */
> +	__u64 allowed_access;
> +	/**
> +	 * @port: Network port
> +	 */
> +	__u16 port;
> +
> +} __attribute__((packed));
> +
>   /**
>    * DOC: fs_access
>    *
> @@ -134,4 +164,22 @@ struct landlock_path_beneath_attr {
>   #define LANDLOCK_ACCESS_FS_MAKE_BLOCK			(1ULL << 11)
>   #define LANDLOCK_ACCESS_FS_MAKE_SYM			(1ULL << 12)
> 
> +/**
> + * DOC: net_access
> + *
> + * Network flags
> + * ~~~~~~~~~~~~~~~~
> + *
> + * These flags enable to restrict a sandboxed process to a set of network
> + * actions.
> + *
> + * TCP sockets with allowed actions:
> + *
> + * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
> + * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
> + *   a remote port.
> + */
> +#define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
> +#define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
> +
>   #endif /* _UAPI_LINUX_LANDLOCK_H */
> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index 8c0f6165fe3a..fcbce83d64ef 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -81,8 +81,9 @@ static void build_check_abi(void)
>   	 * struct size.
>   	 */
>   	ruleset_size = sizeof(ruleset_attr.handled_access_fs);
> +	ruleset_size += sizeof(ruleset_attr.handled_access_net);
>   	BUILD_BUG_ON(sizeof(ruleset_attr) != ruleset_size);
> -	BUILD_BUG_ON(sizeof(ruleset_attr) != 8);
> +	BUILD_BUG_ON(sizeof(ruleset_attr) != 16);
> 
>   	path_beneath_size = sizeof(path_beneath_attr.allowed_access);
>   	path_beneath_size += sizeof(path_beneath_attr.parent_fd);
> @@ -184,7 +185,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
> 
>   	/* Checks content (and 32-bits cast). */
>   	if ((ruleset_attr.handled_access_fs | LANDLOCK_MASK_ACCESS_FS) !=
> -			LANDLOCK_MASK_ACCESS_FS)
> +			 LANDLOCK_MASK_ACCESS_FS)

Don't add cosmetic changes. FYI, I'm relying on the way Vim does line 
cuts, which is mostly tabs. Please try to do the same.


>   		return -EINVAL;
>   	access_mask_set.fs = ruleset_attr.handled_access_fs;
> 
> --
> 2.25.1
> 

You need to also update Documentation/userspace-api/landlock.rst 
accordingly. You can check you changes by building the HTML doc.
