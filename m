Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD246E3A37
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 18:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjDPQNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 12:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjDPQNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 12:13:33 -0400
Received: from smtp-8fae.mail.infomaniak.ch (smtp-8fae.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fae])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E893580
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 09:13:30 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PzwGJ41rmzMqCyp;
        Sun, 16 Apr 2023 18:13:28 +0200 (CEST)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PzwGH32D6zMppDR;
        Sun, 16 Apr 2023 18:13:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1681661608;
        bh=wvZktsS2wovttTPKhuIKuxoQ9kE6pVtEyePlXYSAocU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=snAwV5HoppK8rU92IrbLQPI5kLV4FAtdWXM9erbn4J9qeDk+8dQ+TJHb00MyqtEh/
         WWFcQr5dQ/atS6nigS2oSoWuaoe6EpEskhGukpXD6ZHzsEkN51aXdqj+5XJyyHYxiV
         ZY0HpqHtIscLGKWaBGYEraSZDp4v85AdMvL5l4Wk=
Message-ID: <ec23be77-566e-c8fd-179e-f50e025ac2cf@digikod.net>
Date:   Sun, 16 Apr 2023 18:13:32 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v10 13/13] landlock: Document Landlock's network support
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-14-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230323085226.1432550-14-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/03/2023 09:52, Konstantin Meskhidze wrote:
> Describe network access rules for TCP sockets. Add network access
> example in the tutorial. Add kernel configuration support for network.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v9:
> * Minor refactoring.
> 
> Changes since v8:
> * Minor refactoring.
> 
> Changes since v7:
> * Fixes documentaion logic errors and typos as Mickaёl suggested:
> https://lore.kernel.org/netdev/9f354862-2bc3-39ea-92fd-53803d9bbc21@digikod.net/
> 
> Changes since v6:
> * Adds network support documentaion.
> 
> ---
>   Documentation/userspace-api/landlock.rst | 69 ++++++++++++++++++------
>   1 file changed, 54 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
> index f6a7da21708a..0d640bfa3126 100644
> --- a/Documentation/userspace-api/landlock.rst
> +++ b/Documentation/userspace-api/landlock.rst
> @@ -11,10 +11,10 @@ Landlock: unprivileged access control
>   :Date: October 2022
> 
>   The goal of Landlock is to enable to restrict ambient rights (e.g. global
> -filesystem access) for a set of processes.  Because Landlock is a stackable
> -LSM, it makes possible to create safe security sandboxes as new security layers
> -in addition to the existing system-wide access-controls. This kind of sandbox
> -is expected to help mitigate the security impact of bugs or
> +filesystem or network access) for a set of processes.  Because Landlock
> +is a stackable LSM, it makes possible to create safe security sandboxes as new
> +security layers in addition to the existing system-wide access-controls. This
> +kind of sandbox is expected to help mitigate the security impact of bugs or
>   unexpected/malicious behaviors in user space applications.  Landlock empowers
>   any process, including unprivileged ones, to securely restrict themselves.
> 
> @@ -30,8 +30,9 @@ Landlock rules
> 
>   A Landlock rule describes an action on an object.  An object is currently a

A Landlock rule describes an action on a kernel object.  Filesystem 
objects can be defined with a file hierarchy.  Since the fourth ABI 
version, TCP ports enable to identify inbound or outbound connections. 
Actions on these kernel objects are defined according to `access 
rights`_.  A set of rules…


>   file hierarchy, and the related filesystem actions are defined with `access
> -rights`_.  A set of rules is aggregated in a ruleset, which can then restrict
> -the thread enforcing it, and its future children.
> +rights`_.  Since ABI version 4 a port data appears with related network actions
> +for TCP socket families.  A set of rules is aggregated in a ruleset, which
> +can then restrict the thread enforcing it, and its future children.
> 
>   Defining and enforcing a security policy
>   ----------------------------------------
> @@ -41,7 +42,8 @@ example, the ruleset will contain rules that only allow read actions, but write

"the ruleset will contain rules that only allow filesystem read actions 
and establish a specific TCP connection, but filesystem write actions 
and other TCP actions will be denied."


>   actions will be denied.  The ruleset then needs to handle both of these kind of
>   actions.  This is required for backward and forward compatibility (i.e. the
>   kernel and user space may not know each other's supported restrictions), hence
> -the need to be explicit about the denied-by-default access rights.
> +the need to be explicit about the denied-by-default access rights.  Also, ruleset > +will have network rules for specific ports, so it should handle 
network actions.

This hunk can then be removed.


> 
>   .. code-block:: c
> 
> @@ -62,6 +64,9 @@ the need to be explicit about the denied-by-default access rights.
>               LANDLOCK_ACCESS_FS_MAKE_SYM |
>               LANDLOCK_ACCESS_FS_REFER |
>               LANDLOCK_ACCESS_FS_TRUNCATE,
> +        .handled_access_net =
> +            LANDLOCK_ACCESS_NET_BIND_TCP |
> +            LANDLOCK_ACCESS_NET_CONNECT_TCP,
>       };
> 
>   Because we may not know on which kernel version an application will be
> @@ -70,14 +75,18 @@ should try to protect users as much as possible whatever the kernel they are
>   using.  To avoid binary enforcement (i.e. either all security features or
>   none), we can leverage a dedicated Landlock command to get the current version
>   of the Landlock ABI and adapt the handled accesses.  Let's check if we should
> -remove the ``LANDLOCK_ACCESS_FS_REFER`` or ``LANDLOCK_ACCESS_FS_TRUNCATE``
> -access rights, which are only supported starting with the second and third
> -version of the ABI.
> +remove the ``LANDLOCK_ACCESS_FS_REFER`` or ``LANDLOCK_ACCESS_FS_TRUNCATE`` or
> +network access rights, which are only supported starting with the second,
> +third and fourth version of the ABI.
> 
>   .. code-block:: c
> 
>       int abi;
> 
> +    #define ACCESS_NET_BIND_CONNECT ( \
> +        LANDLOCK_ACCESS_NET_BIND_TCP | \
> +        LANDLOCK_ACCESS_NET_CONNECT_TCP)
> +
>       abi = landlock_create_ruleset(NULL, 0, LANDLOCK_CREATE_RULESET_VERSION);
>       if (abi < 0) {
>           /* Degrades gracefully if Landlock is not handled. */
> @@ -92,6 +101,11 @@ version of the ABI.
>       case 2:
>           /* Removes LANDLOCK_ACCESS_FS_TRUNCATE for ABI < 3 */
>           ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_TRUNCATE;
> +    case 3:
> +        /* Removes network support for ABI < 4 */
> +        ruleset_attr.handled_access_net &=
> +            ~(LANDLOCK_ACCESS_NET_BIND_TCP |
> +              LANDLOCK_ACCESS_NET_CONNECT_TCP);
>       }
> 
>   This enables to create an inclusive ruleset that will contain our rules.
> @@ -143,10 +157,23 @@ for the ruleset creation, by filtering access rights according to the Landlock
>   ABI version.  In this example, this is not required because all of the requested
>   ``allowed_access`` rights are already available in ABI 1.
> 
> -We now have a ruleset with one rule allowing read access to ``/usr`` while
> -denying all other handled accesses for the filesystem.  The next step is to
> -restrict the current thread from gaining more privileges (e.g. thanks to a SUID
> -binary).
> +For network access-control, we can add a set of rules that allow to use a port
> +number for a specific action.

It would be more useful to change this example with a TCP connection to 
port 443 and explain that it will only allow to connect to HTTPS services.

"…for a specific action: HTTPS connections."


> +
> +.. code-block:: c
> +
> +    struct landlock_net_service_attr net_service = {
> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,

NET_CONNECT_TCP

> +        .port = 8080,

443


> +    };
> +
> +    err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +                            &net_service, 0);
> +
> +The next step is to restrict the current thread from gaining more privileges
> +(e.g. through a SUID binary). We now have a ruleset with the first rule allowing
> +read access to ``/usr`` while denying all other handled accesses for the filesystem,
> +and a second rule allowing TCP binding on port 8080.

"allowing HTTPS connections."


> 
>   .. code-block:: c
> 
> @@ -355,7 +382,7 @@ Access rights
>   -------------
> 
>   .. kernel-doc:: include/uapi/linux/landlock.h
> -    :identifiers: fs_access
> +    :identifiers: fs_access net_access
> 
>   Creating a new ruleset
>   ----------------------
> @@ -374,6 +401,7 @@ Extending a ruleset
> 
>   .. kernel-doc:: include/uapi/linux/landlock.h
>       :identifiers: landlock_rule_type landlock_path_beneath_attr
> +                  landlock_net_service_attr
> 
>   Enforcing a ruleset
>   -------------------
> @@ -451,6 +479,12 @@ always allowed when using a kernel that only supports the first or second ABI.
>   Starting with the Landlock ABI version 3, it is now possible to securely control
>   truncation thanks to the new ``LANDLOCK_ACCESS_FS_TRUNCATE`` access right.
> 
> +Network support (ABI < 4)
> +-------------------------
> +
> +Starting with the Landlock ABI version 4, it is now possible to restrict TCP
> +bind and connect actions to only a set of allowed ports.
> +
>   .. _kernel_support:
> 
>   Kernel support
> @@ -469,6 +503,11 @@ still enable it by adding ``lsm=landlock,[...]`` to
>   Documentation/admin-guide/kernel-parameters.rst thanks to the bootloader
>   configuration.
> 
> +To be able to explicitly allow TCP operations (e.g., adding a network rule with
> +``LANDLOCK_ACCESS_NET_TCP_BIND``), the kernel must support TCP (``CONFIG_INET=y``).
> +Otherwise, sys_landlock_add_rule() returns an ``EAFNOSUPPORT`` error, which can
> +safely be ignored because this kind of TCP operation is already not possible.
> +
>   Questions and answers
>   =====================
> 
> --
> 2.25.1
> 
