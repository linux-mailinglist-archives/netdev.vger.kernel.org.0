Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650FE5AE1F9
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbiIFIJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238859AbiIFIIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:08:36 -0400
X-Greylist: delayed 92 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Sep 2022 01:08:34 PDT
Received: from smtp-8fad.mail.infomaniak.ch (smtp-8fad.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fad])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FC16F24C
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:08:34 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MMJ1C1WBRzMqFwR;
        Tue,  6 Sep 2022 10:08:31 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MMJ1B37MVzMpnPl;
        Tue,  6 Sep 2022 10:08:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1662451711;
        bh=r7iIg4faxJnz6DnPDM/x7O9FrVGSuWyoxur0fSwO+Tc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LDmvMigImi67BjTeWbowKZ8e3Zrbc5DRTAQUMyzypXtrz5EvUc+X8ge4uZvEliu5Z
         HKZpHsSc9+mSwaxagMSUfHuupF6yWV2ymiL3yCuaJ8WGuwgSv3ykcGC2zU+hseCjmr
         lxV/qbhl9fH457GeTsQIBlnCbDfbt9Tkqu2kVKtk=
Message-ID: <89241aad-8c17-31bf-85bf-e2d0eea6b7ae@digikod.net>
Date:   Tue, 6 Sep 2022 10:08:29 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 07/18] landlock: user space API network support
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        hukeping@huawei.com, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-8-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220829170401.834298-8-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You can squash this commit into 8/18.

You need to increment the Landlock ABI version here.


On 29/08/2022 19:03, Konstantin Meskhidze wrote:
> Refactors user space API to support network actions. Adds new network
> access flags, network rule and network attributes.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v6:
> * None.
> 
> Changes since v5:
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * None
> 
> Changes since v3:
> * Splits commit.
> * Refactors User API for network rule type.
> 
> ---
>   include/uapi/linux/landlock.h | 49 +++++++++++++++++++++++++++++++++++
>   security/landlock/syscalls.c  |  3 ++-
>   2 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
> index 735b1fe8326e..1ce2be6a78af 100644
> --- a/include/uapi/linux/landlock.h
> +++ b/include/uapi/linux/landlock.h
> @@ -31,6 +31,13 @@ struct landlock_ruleset_attr {
>   	 * this access right.
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
> @@ -54,6 +61,11 @@ enum landlock_rule_type {
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
> @@ -79,6 +91,24 @@ struct landlock_path_beneath_attr {
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
> +	 * @port: Network port.
> +	 */
> +	__u16 port;
> +
> +} __attribute__((packed));
> +
>   /**
>    * DOC: fs_access
>    *
> @@ -169,4 +199,23 @@ struct landlock_path_beneath_attr {
>   #define LANDLOCK_ACCESS_FS_TRUNCATE			(1ULL << 14)
>   /* clang-format on */
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
> +/* clang-format off */
> +#define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
> +#define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
> +/* clang-format on */
>   #endif /* _UAPI_LINUX_LANDLOCK_H */
> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
> index 28acc4cef3e8..ffd5805eddd9 100644
> --- a/security/landlock/syscalls.c
> +++ b/security/landlock/syscalls.c
> @@ -82,8 +82,9 @@ static void build_check_abi(void)
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
> --
> 2.25.1
> 
