Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EE8660771
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 20:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbjAFTyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 14:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236271AbjAFTx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 14:53:29 -0500
X-Greylist: delayed 1383 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 Jan 2023 11:53:12 PST
Received: from smtp-42ae.mail.infomaniak.ch (smtp-42ae.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ae])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4731A81D7B
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 11:53:12 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NpYML4MhWzMr9RW;
        Fri,  6 Jan 2023 20:30:06 +0100 (CET)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4NpYMK5v7LzMq1SD;
        Fri,  6 Jan 2023 20:30:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1673033406;
        bh=8m+V9XjVRq7eOpHMDURvUdsB7aE8b7bVPr2IcgzFoj0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JcDVDgO6SAv65XudXuIZZS6CGoVlqo3/OdXPVT8bTbPv3mhQWOindU3hEajVHum7+
         yH9QTSUGgZCU7B2V3dlYg5l7XSpTWgbno99nyzo2QpwZQjGImFz9Y15kHJMly+6j12
         yaAr3PDTLMHjvpFRnacEyUp0hAx6LDAAXT7G5M+8=
Message-ID: <ec54eb66-ed9f-035c-1301-644f93873e5f@digikod.net>
Date:   Fri, 6 Jan 2023 20:30:05 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 08/12] landlock: Implement TCP network hooks
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        netdev@vger.kernel.org, linux-api@vger.kernel.org,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-9-konstantin.meskhidze@huawei.com>
 <3452964b-04d3-b297-92a1-1220e087323e@digikod.net>
 <258ba4aa-6b12-abda-75b9-ffa196fba683@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <258ba4aa-6b12-abda-75b9-ffa196fba683@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/01/2023 09:57, Konstantin Meskhidze (A) wrote:
> 
> 
> 11/17/2022 9:43 PM, Mickaël Salaün пишет:
>>
>> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>>> This patch adds support of socket_bind() and socket_connect() hooks.
>>> It's possible to restrict binding and connecting of TCP sockets to
>>> particular ports.
>>
>> Implement socket_bind() and socket_connect LSM hooks, which enable to
>> restrict TCP socket binding and connection to specific ports.
>>
>>
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v7:
>>> * Minor fixes.
>>> * Refactors commit message.
>>>
>>> Changes since v6:
>>> * Updates copyright.
>>> * Refactors landlock_append_net_rule() and check_socket_access()
>>>     functions with landlock_id type.
>>>
>>> Changes since v5:
>>> * Fixes some logic errors.
>>> * Formats code with clang-format-14.
>>>
>>> Changes since v4:
>>> * Factors out CONFIG_INET into make file.
>>> * Refactors check_socket_access().
>>> * Adds helper get_port().
>>> * Adds CONFIG_IPV6 in get_port(), hook_socket_bind/connect
>>> functions to support AF_INET6 family.
>>> * Adds AF_UNSPEC family support in hook_socket_bind/connect
>>> functions.
>>> * Refactors add_rule_net_service() and landlock_add_rule
>>> syscall to support network rule inserting.
>>> * Refactors init_layer_masks() to support network rules.
>>>
>>> Changes since v3:
>>> * Splits commit.
>>> * Adds SECURITY_NETWORK in config.
>>> * Adds IS_ENABLED(CONFIG_INET) if a kernel has no INET configuration.
>>> * Adds hook_socket_bind and hook_socket_connect hooks.
>>>
>>> ---
>>>    security/landlock/Kconfig    |   1 +
>>>    security/landlock/Makefile   |   2 +
>>>    security/landlock/net.c      | 164 +++++++++++++++++++++++++++++++++++
>>>    security/landlock/net.h      |  26 ++++++
>>>    security/landlock/setup.c    |   2 +
>>>    security/landlock/syscalls.c |  59 ++++++++++++-
>>>    6 files changed, 251 insertions(+), 3 deletions(-)
>>>    create mode 100644 security/landlock/net.c
>>>    create mode 100644 security/landlock/net.h
>>>
>>> diff --git a/security/landlock/Kconfig b/security/landlock/Kconfig
>>> index 8e33c4e8ffb8..10c099097533 100644
>>> --- a/security/landlock/Kconfig
>>> +++ b/security/landlock/Kconfig
>>> @@ -3,6 +3,7 @@
>>>    config SECURITY_LANDLOCK
>>>    	bool "Landlock support"
>>>    	depends on SECURITY && !ARCH_EPHEMERAL_INODES
>>> +	select SECURITY_NETWORK
>>>    	select SECURITY_PATH
>>>    	help
>>>    	  Landlock is a sandboxing mechanism that enables processes to restrict
>>> diff --git a/security/landlock/Makefile b/security/landlock/Makefile
>>> index 7bbd2f413b3e..53d3c92ae22e 100644
>>> --- a/security/landlock/Makefile
>>> +++ b/security/landlock/Makefile
>>> @@ -2,3 +2,5 @@ obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
>>>
>>>    landlock-y := setup.o syscalls.o object.o ruleset.o \
>>>    	cred.o ptrace.o fs.o
>>> +
>>> +landlock-$(CONFIG_INET) += net.o
>>> \ No newline at end of file
>>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>>> new file mode 100644
>>> index 000000000000..39e8a156a1f4
>>> --- /dev/null
>>> +++ b/security/landlock/net.c
>>> @@ -0,0 +1,164 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Landlock LSM - Network management and hooks
>>> + *
>>> + * Copyright © 2022 Huawei Tech. Co., Ltd.
>>> + * Copyright © 2022 Microsoft Corporation
>>> + */
>>> +
>>> +#include <linux/in.h>
>>> +#include <linux/net.h>
>>> +#include <linux/socket.h>
>>> +#include <net/ipv6.h>
>>> +
>>> +#include "common.h"
>>> +#include "cred.h"
>>> +#include "limits.h"
>>> +#include "net.h"
>>> +#include "ruleset.h"
>>> +
>>> +int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
>>> +			     const u16 port, access_mask_t access_rights)
>>> +{
>>> +	int err;
>>> +	const struct landlock_id id = {
>>> +		.key.data = port,
>>> +		.type = LANDLOCK_KEY_NET_PORT,
>>> +	};
>>> +	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
>>> +
>>> +	/* Transforms relative access rights to absolute ones. */
>>> +	access_rights |= LANDLOCK_MASK_ACCESS_NET &
>>> +			 ~landlock_get_net_access_mask(ruleset, 0);
>>> +
>>> +	mutex_lock(&ruleset->lock);
>>> +	err = landlock_insert_rule(ruleset, id, access_rights);
>>> +	mutex_unlock(&ruleset->lock);
>>> +
>>> +	return err;
>>> +}
>>> +
>>> +static int check_socket_access(const struct landlock_ruleset *const domain,
>>> +			       u16 port, access_mask_t access_request)
>>> +{
>>> +	bool allowed = false;
>>> +	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
>>> +	const struct landlock_rule *rule;
>>> +	access_mask_t handled_access;
>>> +	const struct landlock_id id = {
>>> +		.key.data = port,
>>> +		.type = LANDLOCK_KEY_NET_PORT,
>>> +	};
>>> +
>>> +	if (WARN_ON_ONCE(!domain))
>>> +		return 0;
>>> +	if (WARN_ON_ONCE(domain->num_layers < 1))
>>> +		return -EACCES;
>>> +
>>> +	rule = landlock_find_rule(domain, id);
>>> +	handled_access = init_layer_masks(domain, access_request, &layer_masks,
>>> +					  LANDLOCK_KEY_NET_PORT);
>>> +	allowed = unmask_layers(rule, handled_access, &layer_masks,
>>> +				ARRAY_SIZE(layer_masks));
>>> +
>>> +	return allowed ? 0 : -EACCES;
>>> +}
>>> +
>>> +static u16 get_port(const struct sockaddr *const address)
>>
>> get_port() should return a __be16 type. This enables to avoid converting
>> port when checking a rule.
> 
>     In this case a user must do a coverting port into __be16:
> 
>     struct landlock_net_service_attr net_service = {
>                   .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> 
>                   .port = htons(sock_port),
>           };
>    I think that a user should not think about this conversion cause it
> makes UAPI more complex to use. Lets do this under kernel's hood and let
> it as it is now -> u16 port.
> 
> What do you think?

BE and LE conversions may be error prone without strong typing, but the 
current Linux network UAPI uses this convention (see related syscalls), 
so developers already use htons() in their applications. I think it is 
less hazardous to use the same convention. It would be nice to have the 
point of view of network and API folks though.
