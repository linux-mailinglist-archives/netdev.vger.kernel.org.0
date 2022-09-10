Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40515B48F7
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 23:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiIJVPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 17:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiIJVPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 17:15:05 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DE725E85;
        Sat, 10 Sep 2022 14:15:02 -0700 (PDT)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MQ5FT6DZvz67KY4;
        Sun, 11 Sep 2022 05:13:49 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 23:15:00 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 22:14:59 +0100
Message-ID: <7026ab20-588d-26b6-bc68-316cb7c785a4@huawei.com>
Date:   Sun, 11 Sep 2022 00:14:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 18/18] landlock: Document Landlock's network support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-19-konstantin.meskhidze@huawei.com>
 <9f354862-2bc3-39ea-92fd-53803d9bbc21@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <9f354862-2bc3-39ea-92fd-53803d9bbc21@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



9/6/2022 11:12 AM, Mickaël Salaün пишет:
> 
> On 29/08/2022 19:04, Konstantin Meskhidze wrote:
>> Describe network access rules for TCP sockets.
>> Add network access example in the tutorial.
>> Point out AF_UNSPEC socket family behaviour.
>> Point out UDP sockets issues.
>> Add kernel configuration support for network.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v6:
>> * Adds network support documentaion.
>> 
>> ---
>>   Documentation/userspace-api/landlock.rst | 84 +++++++++++++++++++-----
>>   1 file changed, 66 insertions(+), 18 deletions(-)
>> 
>> diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
>> index 2509c2fbf98f..4b099d1b5a9d 100644
>> --- a/Documentation/userspace-api/landlock.rst
>> +++ b/Documentation/userspace-api/landlock.rst
>> @@ -11,10 +11,10 @@ Landlock: unprivileged access control
>>   :Date: August 2022
>> 
>>   The goal of Landlock is to enable to restrict ambient rights (e.g. global
>> -filesystem access) for a set of processes.  Because Landlock is a stackable
>> -LSM, it makes possible to create safe security sandboxes as new security layers
>> -in addition to the existing system-wide access-controls. This kind of sandbox
>> -is expected to help mitigate the security impact of bugs or
>> +filesystem or network access) for a set of processes.  Because Landlock
>> +is a stackable LSM, it makes possible to create safe security sandboxes as new
>> +security layers in addition to the existing system-wide access-controls. This
>> +kind of sandbox is expected to help mitigate the security impact of bugs or
>>   unexpected/malicious behaviors in user space applications.  Landlock empowers
>>   any process, including unprivileged ones, to securely restrict themselves.
>> 
>> @@ -30,18 +30,20 @@ Landlock rules
>> 
>>   A Landlock rule describes an action on an object.  An object is currently a
>>   file hierarchy, and the related filesystem actions are defined with `access
>> -rights`_.  A set of rules is aggregated in a ruleset, which can then restrict
>> -the thread enforcing it, and its future children.
>> +rights`_.  Since ABI version 3 a port "object" appears with related network actions
> 
> Version 3 is wrong here, it should be version 4. Please fix everywhere
> else too.

   Ok.
> 
> Why do you quote "object"?

   Because for filesystem we work with inodes which are kernel objects,
   but network port is not, so I used quotes here.
> 
> Let's use object (e.g. for filesystem/inode) or data (e.g. for TCP port).
> 
   Ok. I will fixt it.
> 
>> +for TCP4/TCP6 sockets families.  A set of rules is aggregated in a ruleset, which
> 
> TCP4/TCP6 would not make sense for users, please be explicit, and in
> this case "TCP" is enough.

   Got it.
> 
> BTW, IP4 and IP6 don't exist, they should be replaced *everywhere* with
> IPv4 and IPv6.
> 
   Ok. Thanks.
> 
>> +can then restrict the thread enforcing it, and its future children.
>> 
>>   Defining and enforcing a security policy
>>   ----------------------------------------
>> 
>>   We first need to define the ruleset that will contain our rules.  For this
>>   example, the ruleset will contain rules that only allow read actions, but write
>> -actions will be denied.  The ruleset then needs to handle both of these kind of
>> +actions will be denied. The ruleset then needs to handle both of these kind of
>>   actions.  This is required for backward and forward compatibility (i.e. the
>>   kernel and user space may not know each other's supported restrictions), hence
>> -the need to be explicit about the denied-by-default access rights.
>> +the need to be explicit about the denied-by-default access rights.  Also ruleset
>> +will have network rules for specific ports, so it should handle network actions.
>> 
>>   .. code-block:: c
>> 
>> @@ -62,6 +64,9 @@ the need to be explicit about the denied-by-default access rights.
>>               LANDLOCK_ACCESS_FS_MAKE_SYM |
>>               LANDLOCK_ACCESS_FS_REFER |
>>               LANDLOCK_ACCESS_FS_TRUNCATE,
>> +        .handled_access_net =
>> +            LANDLOCK_ACCESS_NET_BIND_TCP |
>> +            LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>       };
>> 
>>   Because we may not know on which kernel version an application will be
>> @@ -70,9 +75,9 @@ should try to protect users as much as possible whatever the kernel they are
>>   using.  To avoid binary enforcement (i.e. either all security features or
>>   none), we can leverage a dedicated Landlock command to get the current version
>>   of the Landlock ABI and adapt the handled accesses.  Let's check if we should
>> -remove the `LANDLOCK_ACCESS_FS_REFER` or `LANDLOCK_ACCESS_FS_TRUNCATE` access
>> -rights, which are only supported starting with the second and third version of
>> -the ABI.
>> +remove the `LANDLOCK_ACCESS_FS_REFER` or `LANDLOCK_ACCESS_FS_TRUNCATE` or
>> +network access rights, which are only supported starting with the second and
>> +third version of the ABI.
>> 
>>   .. code-block:: c
>> 
>> @@ -87,9 +92,13 @@ the ABI.
>>               /* Removes LANDLOCK_ACCESS_FS_REFER for ABI < 2 */
>>               ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_REFER;
>>               __attribute__((fallthrough));
>> +            /* Removes network support for ABI < 2 */
>> +            ruleset_attr.handled_access_net = 0;
> 
> This is not correct.

  I will refactor the demo code and then update it here.
> 
> 
>>       case 2:
>>               /* Removes LANDLOCK_ACCESS_FS_TRUNCATE for ABI < 3 */
>>               ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_TRUNCATE;
>> +            /* Removes network support for ABI < 3 */
>> +            ruleset_attr.handled_access_net = 0;
> 
> This part should be for the fourth version.

   Ok. Will be fixed.
> 
> 
>>       }
>> 
>>   This enables to create an inclusive ruleset that will contain our rules.
>> @@ -129,6 +138,24 @@ descriptor.
>>       }
>>       err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
>>                               &path_beneath, 0);
>> +
>> +It may also be required to create rules following the same logic as explained
>> +for the ruleset creation, by filtering access rights according to the Landlock
>> +ABI version.  In this example, this is not required because all of the requested
>> +`allowed_access` rights are already available in ABI 1.
> 
> This paragraph should not be moved. Furthermore, this hunk remove error
> handling…

   Ok. Got it.
> 
> 
>> +
>> +For network part we can add number of rules containing a port number and actions
>> +that a process is allowed to do for certian ports.
>> +
>> +.. code-block:: c
>> +
>> +    struct landlock_net_service_attr net_service = {
>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>> +        .port = 8080,
>> +    };
>> +
>> +    err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +                            &net_service, 0);
>>       close(path_beneath.parent_fd);
>>       if (err) {
>>           perror("Failed to update ruleset");
>> @@ -136,13 +163,9 @@ descriptor.
>>           return 1;
>>       }
>> 
>> -It may also be required to create rules following the same logic as explained
>> -for the ruleset creation, by filtering access rights according to the Landlock
>> -ABI version.  In this example, this is not required because all of the requested
>> -`allowed_access` rights are already available in ABI 1.
>> -
> 
> Please add similar standalone code + explanation sections for network here.
> 
   Is added section for network not enough?
> 
>>   We now have a ruleset with one rule allowing read access to ``/usr`` while
>> -denying all other handled accesses for the filesystem.  The next step is to
>> +denying all other handled accesses for the filesystem.  The ruleset also contains
>> +a rule allowing to bind current proccess to the port 8080.  The next step is to
>>   restrict the current thread from gaining more privileges (e.g. thanks to a SUID
>>   binary).
>> 
>> @@ -280,6 +303,13 @@ It should also be noted that truncating files does not require the
>>   system call, this can also be done through :manpage:`open(2)` with the flags
>>   `O_RDONLY | O_TRUNC`.
>> 
>> +AF_UNSPEC socket family
>> +-----------------------
>> +
>> +Sockets of AF_UNSPEC family types are treated as AF_INET(TCP4) socket for bind()
>> +hook.  But connect() hook is not allowed by Landlock for AF_UNSPEC sockets. This
> 
> Users don't know what is a hook. Such kernel internals are not required
> to explain things.

   Ok. I will change it to action.
> 
> 
>> +logic prevents from disconnecting already connected sockets.
>> +
>>   Compatibility
>>   =============
>> 
>> @@ -339,7 +369,7 @@ Access rights
>>   -------------
>> 
>>   .. kernel-doc:: include/uapi/linux/landlock.h
>> -    :identifiers: fs_access
>> +    :identifiers: fs_access net_access
>> 
>>   Creating a new ruleset
>>   ----------------------
>> @@ -358,6 +388,7 @@ Extending a ruleset
>> 
>>   .. kernel-doc:: include/uapi/linux/landlock.h
>>       :identifiers: landlock_rule_type landlock_path_beneath_attr
>> +                  landlock_net_service_attr
>> 
>>   Enforcing a ruleset
>>   -------------------
>> @@ -406,6 +437,13 @@ Memory usage
>>   Kernel memory allocated to create rulesets is accounted and can be restricted
>>   by the Documentation/admin-guide/cgroup-v1/memory.rst.
>> 
>> +UDP sockets restricting
>> +-----------------------
> 
> I don't think this section is needed. There is a lot of missing access
> types for now and it is not useful to list them all. The "Current
> limitations" section lists limitations about the currently implemented
> access types (e.g. filesystem, TCP).

   Ok. I will delete it in future patch.
> 
> 
>> +
>> +Current network part supports to restrict just TCP sockets type. UPD sockets sandboxing
> 
> typo: UDP

   Got it. Will be fixed.
> 
>> +adds additional issues due to unconnected nature of the protocol. UDP sockets support
>> +might come in future Landlock versions.
>> +
>>   Previous limitations
>>   ====================
>> 
>> @@ -435,6 +473,13 @@ always allowed when using a kernel that only supports the first or second ABI.
>>   Starting with the Landlock ABI version 3, it is now possible to securely control
>>   truncation thanks to the new `LANDLOCK_ACCESS_FS_TRUNCATE` access right.
>> 
>> +Network support (ABI < 3)
> 
> ABI < 4

   Ok.
> 
>> +-------------------------
>> +
>> +Starting with the Landlock ABI version 3, it is now possible to restrict TCP
>> +sockets bind() and connect() syscalls for specific ports allowing processes
>> +to establish secure connections.
> 
> Try to avoid talking about syscall directly but highlight actions
> instead. Using Landlock doesn't create "secure connections",
> unfortunately. ;)

   If I change it to restricted connections, that would be better?
> 
> 
>> +
>>   .. _kernel_support:
>> 
>>   Kernel support
>> @@ -453,6 +498,9 @@ still enable it by adding ``lsm=landlock,[...]`` to
>>   Documentation/admin-guide/kernel-parameters.rst thanks to the bootloader
>>   configuration.
>> 
>> +To support Landlock's network part, the kernel must be configured with `CONFIG_NET=y`
>> +and `CONFIG_INET=y` options.
> 
> Might be better:
> To be able to explicitly allow TCP operations (e.g., adding a network
> rule with `LANDLOCK_ACCESS_NET_TCP_BIND`), the kernel must support TCP
> (`CONFIG_INET=y`). Otherwise, sys_landlock_add_rule() returns an
> `EAFNOSUPPORT` error, which can safely be ignored because this kind of
> TCP operation is already not possible.
> 
> 
>> For TCP6 family sockets `CONFIG_IPV6=y` must be switched on.
> 
> This is not required because if IPv6 is not supported there is nothing
> to do for IPv6 sockets.

   Ok. I will delete it.
> 
> 
>> +
>>   Questions and answers
>>   =====================
>> 
>> --
>> 2.25.1
>> 
> .
