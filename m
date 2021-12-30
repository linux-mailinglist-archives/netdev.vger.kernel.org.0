Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D5D4818C9
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbhL3C4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:56:46 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4328 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbhL3C4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:56:44 -0500
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JPXtH5TN2z67xQP;
        Thu, 30 Dec 2021 10:54:31 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Thu, 30 Dec 2021 03:56:41 +0100
Message-ID: <62cf5983-2a81-a273-d892-58b014a90997@huawei.com>
Date:   Thu, 30 Dec 2021 05:56:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH 0/1] Landlock network PoC
Content-Language: ru
To:     Casey Schaufler <casey@schaufler-ca.com>, <mic@digikod.net>
CC:     <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20211228115212.703084-1-konstantin.meskhidze@huawei.com>
 <ea82de6a-0b28-7d96-a84e-49fa0be39f0e@schaufler-ca.com>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <ea82de6a-0b28-7d96-a84e-49fa0be39f0e@schaufler-ca.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!
Thank you for the quick reply.
Also thanks for you reply on previous
RFC patch:
https://lore.kernel.org/linux-security-module/802be0d0-cb8c-7fda-dd4e-2eb83d228ead@schaufler-ca.com/


12/28/2021 9:14 PM, Casey Schaufler wrote:
> On 12/28/2021 3:52 AM, Konstantin Meskhidze wrote:
>> Hi, all!
>> Here is another PoC patch for Landlock network confinement.
>> Now 2 hooks are supported for TCP sockets:
>>     - hook_socket_bind()
>>     - hook_socket_connect()
>>
>> After architectuire has been more clear, there will be a patch with
>> selftests.
>>
>> Please welcome with any comments and suggestions.
>>
>>
>> Implementation related issues
>> =============================
>>
>> 1. It was suggested by Mickaёl using new network rules
>> attributes, like:
>>
>> struct landlock_net_service_attr {
>>        __u64 allowed_access; // LANDLOCK_NET_*_TCP
>>        __u16 port;
>> } __attribute__((packed));
>>
>> I found that, if we want to support inserting port attributes,
>> it's needed to add port member into struct landlock_rule:
>>
>> struct landlock_rule {
>>     ...
>>     struct landlock_object *object;
>>     /**
>>      * @num_layers: Number of entries in @layers.
>>      */
>>     u32 num_layers;
>>
>>     u16 port;
>>     ...
>> };
>>
>> In this case 2 functions landlock_insert_rule() and insert_rule()
>> must be refactored;
>>
>> But, if struct landlock_layer be modified -
>>
>> struct landlock_layer {
>>     /**
>>      * @level: Position of this layer in the layer stack.
>>      */
>>     u16 level;
>>     /**
>>      * @access: Bitfield of allowed actions on the kernel object.  
>> They are
>>      * relative to the object type (e.g. %LANDLOCK_ACTION_FS_READ).
>>      */
>>     u16 access;
>>
>>     u16 port;
>> };
>> so, just one landlock_insert_rule() must be slightly refactored.
>> Also many new attributes could be easily supported in future versions.
>>
>> 2. access_masks[] member of struct landlock_ruleset was modified
>> to support multiple rule type masks.
>> I suggest using 2D array semantic for convenient usage:
>>     access_masks[rule_type][layer_level]
>>
>> But its also possible to use 1D array with modulo arithmetic:
>>     access_masks[rule_type % layer_level]
>>
>> 3. Kernel objects.
>> As was disscussed earlier, base Landlock version supports some file 
>> access
>> rules, and inodes objects (files' and directories' inodes) are used to 
>> tie
>> filesystem landlock rules.
>> For socket operations it makes sense tagging underlying socket inode by
>> landlock rules and it's perfectly fits to subject-object concept where
>> proccess is a subject and object is one of kernel objects: inodes, 
>> sockets,
> 
> I will repeat myself this one time and then be quiet.
> Sockets are not objects. A socket is a collection of
> data used to identify the endpoints of an interprocess
> communication. Objects are passive. If process A writes
> to socket SA and process B reads from socket SB what
> subject is responsible for moving the message from
> SA to SB? Are you proposing that SA is a subject, which
> writes to SB? If you do that, you have to identify the
> subject attributes of SA as well as the object attributes
> of SB. No doubt you will choose to use the attributes of
> A. Since the object attributes on SB undoubtedly came
> from B (passed descriptors excepted, of course) you are
> making it unnecessarily complicated to introduce a socket
> as an object. The access is A writes B. Store all the
> attributes in the socket, that's fine. But that doesn't
> make the socket an object.
> 
> On the other hand, the code doesn't care if you call
> the socket an object, and you have to store the access
> attributes in the socket for a number of reasons. Also,
> the restrictions you're proposing aren't really access
> controls, so it doesn't matter if you call a socket an
> object. I doubt you're going to be taking this through
> any sort of formal analysis.
> 
I have read the article you sent in previous reply:
https://books.google.com/books?id=vQEHUD51YNEC&pg=PA97&lpg=PA97&dq=\
schaufler+bsd+ipc+policy+and+model&source=bl&ots=59ogRfQYy-&sig=\
ACfU3U07kZnTRD_1InkS4tk-f05OJgRd2w&hl=en&sa=X&ved=2ahUKEwiA8aH3y9n0AhXCN30KHfzhAg4Q6AF6BAgQEAM

I think there is a misunderstanding here about what I meant. Its my 
mistake that I could not explain it properly. Sorry about that.

I tried to follow the main idea of Landlock impementation, at least
for filesystem confinement:
	- A Landlock rule describes an action on an object.
	An object is currently a file hierarchy, and the related 	
	filesystem actions are defined with access rights.
(https://www.kernel.org/doc/html/latest/userspace-api/landlock.html).

So all rules are attached to uderlying inodes of a file hierarchy.
As for the sockets I was following the same way - rules could be tied to
uderlying socket inodes. So "object" here is a socket inode like in 
filesytem approach.
LSM mechanism adds security data fields inside kernel objects:
For pipe, file and socket, security field added to
– struct inode and struct file.
I got it from the next articles:
https://elinux.org/images/0/0a/ELC_Inside_LSM.pdf
https://www.usenix.org/legacy/events/sec02/full_papers/wright/wright.pdf

So the main point here: Under sockets objects I meant sockets inodes.
But I agree, that socket itself (as collection of data used for 
interproccess communication) could be not be an object.

Anyway, my approach would not work in containerized environment: RUNC, 
containerd ect. Mickaёl suggested to go another way for Landlock network 
confinement: Defining "object" with connection port.
Can be checked here:
https://lore.kernel.org/netdev/d9aa57a7-9978-d0a4-3aa0-4512fd9459df@digikod.net

Hope I exlained my point. Thanks again for your comments.
> 
>> ect. But here is one issue that should be also discussed and solved.
>> Now there is an undergoing work for Landlock support in RUNC and other
>> container environments:
>>     https://github.com/opencontainers/runtime-spec/issues/1110
>>     https://github.com/opencontainers/runc/issues/2859
>>
>> When RUNC wants to launch a container it first reads a spec.json file
>> with container specification. Here is an example landlock rules
>> specification in spec.json:
>>
>>     "landlock": {
>>         "rules": [
>>                  {
>>             "type": "path_beneath",
>>             "restrictPaths": {
>>                 "allowedAccess": [
>>                     "LANDLOCK_ACCESS_FS_EXECUTE",
>>                     "LANDLOCK_ACCESS_FS_READ_FILE",
>>                     "LANDLOCK_ACCESS_FS_READ_DIR"
>>                 ],
>>                 "paths": [
>>                     "/usr",
>>                     "/bin"
>>                 ]
>>             }
>>                  },
>>         {
>>             "type": "net_service",
>>             "tcp_net_service":
>>                 "allowedAccess": [
>>                     "LANDLOCK_ACCESS_NET_CONNECT_TCP",
>>                     "LANDLOCK_ACCESS_NET_BIND_TCP",
>>                 ],
>>                 "port": [
>>                     "3920"
>>                 ],
>>             }
>>                  },
>>     ]
>>
>> For fs part RUNC can easily create rules and tie them to underlying
>> inodes of filesystem. Then, when it starts a container all fs rules will
>> be inherited by the container proccess.
>> But for network rules it's impossible, because there no any socket object
>> created during RUNC phase. All socket objects are created after an
>> application has started in the container.
>> Possible solution:
>>   - All network rules from spec.json are tied to task_struct object of 
>> the
>>   container process. In this case, RUNC creates network rules, attach 
>> them
>>   to itself and, then rules are inherited by the launched container
>>   proccess. These rules are global for all sockets in a container and,
>>   then user could add additional restrictions to any socket connection,
>>   imposing some kind of granularity.
>>
>> Konstantin Meskhidze (1):
>>    landlock: TCP network hooks implementation
>>
>>   include/uapi/linux/landlock.h |  52 +++++++++
>>   security/landlock/Makefile    |   2 +-
>>   security/landlock/fs.c        |   8 +-
>>   security/landlock/limits.h    |   5 +
>>   security/landlock/net.c       | 213 ++++++++++++++++++++++++++++++++++
>>   security/landlock/net.h       |  40 +++++++
>>   security/landlock/ruleset.c   |  70 +++++++++--
>>   security/landlock/ruleset.h   |  19 +--
>>   security/landlock/setup.c     |   3 +
>>   security/landlock/syscalls.c  | 141 +++++++++++++++-------
>>   10 files changed, 487 insertions(+), 66 deletions(-)
>>   create mode 100644 security/landlock/net.c
>>   create mode 100644 security/landlock/net.h
>>
>> -- 
>> 2.25.1
>>
>> >From fee4f0dbec1e4a8fa8d34cec57a8cdbf351e9c12 Mon Sep 17 00:00:00 2001
>> From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> Date: Tue, 28 Dec 2021 14:47:39 +0800
>> Subject: [RFC PATCH 1/1] landlock: TCP network hooks implementation
>>
>> Support of socket_bind() and socket_connect() hooks.
>> Current prototype can restrict binding and connecting of TCP
>> types of sockets. Its just basic idea how Landlock could support
>> network confinement.
>>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>>   include/uapi/linux/landlock.h |  52 +++++++++
>>   security/landlock/Makefile    |   2 +-
>>   security/landlock/fs.c        |   8 +-
>>   security/landlock/limits.h    |   5 +
>>   security/landlock/net.c       | 213 ++++++++++++++++++++++++++++++++++
>>   security/landlock/net.h       |  40 +++++++
>>   security/landlock/ruleset.c   |  70 +++++++++--
>>   security/landlock/ruleset.h   |  19 +--
>>   security/landlock/setup.c     |   3 +
>>   security/landlock/syscalls.c  | 141 +++++++++++++++-------
>>   10 files changed, 487 insertions(+), 66 deletions(-)
>>   create mode 100644 security/landlock/net.c
>>   create mode 100644 security/landlock/net.h
>>
>> diff --git a/include/uapi/linux/landlock.h 
>> b/include/uapi/linux/landlock.h
>> index b3d952067f59..1745a3a2f7a9 100644
>> --- a/include/uapi/linux/landlock.h
>> +++ b/include/uapi/linux/landlock.h
>> @@ -25,6 +25,15 @@ struct landlock_ruleset_attr {
>>        * compatibility reasons.
>>        */
>>       __u64 handled_access_fs;
>> +
>> +    /**
>> +     * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
>> +     * that is handled by this ruleset and should then be forbidden 
>> if no
>> +     * rule explicitly allow them.  This is needed for backward
>> +     * compatibility reasons.
>> +     */
>> +    __u64 handled_access_net;
>> +
>>   };
>>
>>   /*
>> @@ -46,6 +55,12 @@ enum landlock_rule_type {
>>        * landlock_path_beneath_attr .
>>        */
>>       LANDLOCK_RULE_PATH_BENEATH = 1,
>> +
>> +    /**
>> +     * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
>> +     * landlock_net_service_attr .
>> +     */
>> +    LANDLOCK_RULE_NET_SERVICE = 2,
>>   };
>>
>>   /**
>> @@ -70,6 +85,24 @@ struct landlock_path_beneath_attr {
>>        */
>>   } __attribute__((packed));
>>
>> +/**
>> + * struct landlock_net_service_attr - TCP subnet definition
>> + *
>> + * Argument of sys_landlock_add_rule().
>> + */
>> +struct landlock_net_service_attr {
>> +    /**
>> +     * @allowed_access: Bitmask of allowed access network for services
>> +     * (cf. `Network flags`_).
>> +     */
>> +    __u64 allowed_access;
>> +    /**
>> +     * @port: Network port
>> +     */
>> +    __u16 port;
>> +
>> +} __attribute__((packed));
>> +
>>   /**
>>    * DOC: fs_access
>>    *
>> @@ -134,4 +167,23 @@ struct landlock_path_beneath_attr {
>>   #define LANDLOCK_ACCESS_FS_MAKE_BLOCK            (1ULL << 11)
>>   #define LANDLOCK_ACCESS_FS_MAKE_SYM            (1ULL << 12)
>>
>> +/**
>> + * DOC: net_access
>> + *
>> + * Network flags
>> + * ~~~~~~~~~~~~~~~~
>> + *
>> + * These flags enable to restrict a sandboxed process to a set of 
>> network
>> + * actions.
>> + *
>> + * TCP sockets with allowed actions:
>> + *
>> + * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a IP address.
>> + * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
>> + *   a listening one.
>> + */
>> +#define LANDLOCK_ACCESS_NET_BIND_TCP            (1ULL << 0)
>> +#define LANDLOCK_ACCESS_NET_CONNECT_TCP            (1ULL << 1)
>> +
>> +
>>   #endif /* _UAPI_LINUX_LANDLOCK_H */
>> diff --git a/security/landlock/Makefile b/security/landlock/Makefile
>> index 7bbd2f413b3e..afa44baaa83a 100644
>> --- a/security/landlock/Makefile
>> +++ b/security/landlock/Makefile
>> @@ -1,4 +1,4 @@
>>   obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
>>
>>   landlock-y := setup.o syscalls.o object.o ruleset.o \
>> -    cred.o ptrace.o fs.o
>> +    cred.o ptrace.o fs.o net.o
>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>> index 97b8e421f617..a27ac76ea1ee 100644
>> --- a/security/landlock/fs.c
>> +++ b/security/landlock/fs.c
>> @@ -154,6 +154,7 @@ int landlock_append_fs_rule(struct 
>> landlock_ruleset *const ruleset,
>>   {
>>       int err;
>>       struct landlock_object *object;
>> +    u8 rule_fs_type;
>>
>>       /* Files only get access rights that make sense. */
>>       if (!d_is_dir(path->dentry) && (access_rights | ACCESS_FILE) !=
>> @@ -162,8 +163,9 @@ int landlock_append_fs_rule(struct 
>> landlock_ruleset *const ruleset,
>>       if (WARN_ON_ONCE(ruleset->num_layers != 1))
>>           return -EINVAL;
>>
>> +    rule_fs_type = LANDLOCK_RULE_PATH_BENEATH - 1;
>>       /* Transforms relative access rights to absolute ones. */
>> -    access_rights |= LANDLOCK_MASK_ACCESS_FS & 
>> ~ruleset->fs_access_masks[0];
>> +    access_rights |= LANDLOCK_MASK_ACCESS_FS & 
>> ~ruleset->access_masks[rule_fs_type][0];
>>       object = get_inode_object(d_backing_inode(path->dentry));
>>       if (IS_ERR(object))
>>           return PTR_ERR(object);
>> @@ -229,6 +231,7 @@ static int check_access_path(const struct 
>> landlock_ruleset *const domain,
>>       struct path walker_path;
>>       u64 layer_mask;
>>       size_t i;
>> +    u8 rule_fs_type;
>>
>>       /* Make sure all layers can be checked. */
>>       BUILD_BUG_ON(BITS_PER_TYPE(layer_mask) < LANDLOCK_MAX_NUM_LAYERS);
>> @@ -249,10 +252,11 @@ static int check_access_path(const struct 
>> landlock_ruleset *const domain,
>>       if (WARN_ON_ONCE(domain->num_layers < 1))
>>           return -EACCES;
>>
>> +    rule_fs_type = LANDLOCK_RULE_PATH_BENEATH - 1;
>>       /* Saves all layers handling a subset of requested accesses. */
>>       layer_mask = 0;
>>       for (i = 0; i < domain->num_layers; i++) {
>> -        if (domain->fs_access_masks[i] & access_request)
>> +        if (domain->access_masks[rule_fs_type][i] & access_request)
>>               layer_mask |= BIT_ULL(i);
>>       }
>>       /* An access request not handled by the domain is allowed. */
>> diff --git a/security/landlock/limits.h b/security/landlock/limits.h
>> index 2a0a1095ee27..6a1e5ea4c7d2 100644
>> --- a/security/landlock/limits.h
>> +++ b/security/landlock/limits.h
>> @@ -18,4 +18,9 @@
>>   #define LANDLOCK_LAST_ACCESS_FS        LANDLOCK_ACCESS_FS_MAKE_SYM
>>   #define LANDLOCK_MASK_ACCESS_FS        ((LANDLOCK_LAST_ACCESS_FS << 
>> 1) - 1)
>>
>> +#define LANDLOCK_LAST_ACCESS_NET    LANDLOCK_ACCESS_NET_CONNECT_TCP
>> +#define LANDLOCK_MASK_ACCESS_NET    ((LANDLOCK_LAST_ACCESS_NET << 1) 
>> - 1)
>> +
>> +#define LANDLOCK_RULE_TYPE_NUM        LANDLOCK_RULE_NET_SERVICE
>> +
>>   #endif /* _SECURITY_LANDLOCK_LIMITS_H */
>> diff --git a/security/landlock/net.c b/security/landlock/net.c
>> new file mode 100644
>> index 000000000000..443933db3e23
>> --- /dev/null
>> +++ b/security/landlock/net.c
>> @@ -0,0 +1,213 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Landlock LSM - Filesystem management and hooks
>> + *
>> + * Copyright © 2016-2020 Mickaël Salaün <mic@digikod.net>
>> + * Copyright © 2018-2020 ANSSI
>> + */
>> +
>> +#include <linux/socket.h>
>> +#include <linux/net.h>
>> +
>> +#include "cred.h"
>> +#include "limits.h"
>> +#include "net.h"
>> +
>> +/* Underlying object management */
>> +static void release_task_object(struct landlock_object *const object)
>> +{
>> +    /* Untie landlock object from a process task_struct */
>> +    object->underobj = NULL;
>> +}
>> +
>> +static const struct landlock_object_underops landlock_net_underops = {
>> +    .release = release_task_object
>> +};
>> +
>> +static struct landlock_object *get_task_object(struct task_struct 
>> *const task)
>> +{
>> +    struct landlock_object *object, *new_object;
>> +    struct landlock_task_security *task_sec = landlock_task(task);
>> +
>> +    object = task_sec->object;
>> +    /* There is no race condition here, cause a process
>> +     * creating a landlock object (for network rules) ties
>> +     * one to itself, but it better to save landlock object
>> +     * refcounter usage logic here.
>> +     */
>> +    if (object)
>> +        if (likely(refcount_inc_not_zero(&object->usage)))
>> +            return object;
>> +
>> +    /*
>> +     * If there is no object tied to task, then create a new one.
>> +     */
>> +    new_object = landlock_create_object(&landlock_net_underops, task);
>> +    if (IS_ERR(new_object))
>> +        return new_object;
>> +
>> +    task_sec->object = new_object;
>> +    return new_object;
>> +}
>> +
>> +int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
>> +                             u32 access_rights)
>> +{
>> +    int err;
>> +    struct landlock_object *object;
>> +    u8 rule_net_type;
>> +
>> +    rule_net_type = LANDLOCK_RULE_NET_SERVICE - 1;
>> +    /* Transforms relative access rights to absolute ones. */
>> +    access_rights |= LANDLOCK_MASK_ACCESS_NET & 
>> ~ruleset->access_masks[rule_net_type][0];
>> +
>> +    /* Get the current proccess's landlock object */
>> +    object = get_task_object(current);
>> +    if (IS_ERR(object))
>> +        return PTR_ERR(object);
>> +    mutex_lock(&ruleset->lock);
>> +    err = landlock_insert_rule(ruleset, object, access_rights);
>> +    mutex_unlock(&ruleset->lock);
>> +    /*
>> +     * No need to check for an error because landlock_insert_rule()
>> +     * increments the refcount for the new object if needed.
>> +     */
>> +    landlock_put_object(object);
>> +    return err;
>> +}
>> +
>> +/* Access-control management */
>> +static inline bool unmask_layers(
>> +        const struct landlock_ruleset *const domain,
>> +        const u32 access_request, u64 layer_mask)
>> +{
>> +    const struct landlock_rule *rule;
>> +    const struct task_struct *task;
>> +    size_t i;
>> +    bool allowed = false;
>> +
>> +    /* Get current procces task_struct */
>> +    task = current;
>> +
>> +    rule = landlock_find_rule(domain, landlock_task(task)->object);
>> +
>> +    /* Grant access if there is no rule for an oject */
>> +    if (!rule)
>> +        return allowed = true;
>> +
>> +    /*
>> +     * An access is granted if, for each policy layer, at least one rule
>> +     * encountered on network actions requested,
>> +     * regardless of their position in the layer stack. We must then 
>> check
>> +     * the remaining layers, from the first added layer to
>> +     * the last one.
>> +     */
>> +    for (i = 0; i < rule->num_layers; i++) {
>> +        const struct landlock_layer *const layer = &rule->layers[i];
>> +        const u64 layer_level = BIT_ULL(layer->level - 1);
>> +
>> +        /* Checks that the layer grants access to the request. */
>> +        if ((layer->access & access_request) == access_request) {
>> +            layer_mask &= ~layer_level;
>> +            allowed = true;
>> +
>> +            if (layer_mask == 0)
>> +                return allowed;
>> +        } else {
>> +            layer_mask &= ~layer_level;
>> +
>> +            if (layer_mask == 0)
>> +                return allowed;
>> +        }
>> +    }
>> +    return allowed;
>> +}
>> +
>> +static int check_socket_access(const struct landlock_ruleset *const 
>> domain,
>> +                   u32 access_request)
>> +{
>> +    bool allowed = false;
>> +    u64 layer_mask;
>> +    size_t i;
>> +    u8 rule_net_type;
>> +
>> +    /* Make sure all layers can be checked. */
>> +    BUILD_BUG_ON(BITS_PER_TYPE(layer_mask) < LANDLOCK_MAX_NUM_LAYERS);
>> +
>> +    if (WARN_ON_ONCE(!domain))
>> +        return 0;
>> +    if (WARN_ON_ONCE(domain->num_layers < 1))
>> +        return -EACCES;
>> +
>> +    /* Saves all layers handling a subset of requested
>> +     * socket access rules.
>> +     */
>> +    rule_net_type = LANDLOCK_RULE_NET_SERVICE - 1;
>> +    layer_mask = 0;
>> +    for (i = 0; i < domain->num_layers; i++) {
>> +        if (domain->access_masks[rule_net_type][i] & access_request)
>> +            layer_mask |= BIT_ULL(i);
>> +    }
>> +    /* An access request not handled by the domain is allowed. */
>> +    if (layer_mask == 0)
>> +        return 0;
>> +
>> +    /*
>> +     * We need to walk through all the hierarchy to not miss any 
>> relevant
>> +     * restriction.
>> +     */
>> +    allowed = unmask_layers(domain, access_request, layer_mask);
>> +
>> +    return allowed ? 0 : -EACCES;
>> +}
>> +
>> +static int hook_socket_bind(struct socket *sock, struct sockaddr 
>> *address, int addrlen)
>> +{
>> +    short socket_type;
>> +    const struct landlock_ruleset *const dom = 
>> landlock_get_current_domain();
>> +
>> +    /* Check if the hook catches AF_INET* socket's action */
>> +    if ((address->sa_family != AF_INET) && (address->sa_family != 
>> AF_INET6))
>> +        return 0;
>> +
>> +    socket_type = sock->type;
>> +    /* Check if it's a TCP socket */
>> +    if (socket_type != SOCK_STREAM)
>> +        return 0;
>> +
>> +    if (!dom)
>> +        return 0;
>> +
>> +    return check_socket_access(dom, LANDLOCK_ACCESS_NET_BIND_TCP);
>> +}
>> +
>> +static int hook_socket_connect(struct socket *sock, struct sockaddr 
>> *address, int addrlen)
>> +{
>> +    short socket_type;
>> +    const struct landlock_ruleset *const dom = 
>> landlock_get_current_domain();
>> +
>> +    /* Check if the hook catches AF_INET* socket's action */
>> +    if ((address->sa_family != AF_INET) && (address->sa_family != 
>> AF_INET6))
>> +        return 0;
>> +
>> +    socket_type = sock->type;
>> +    /* Check if it's a TCP socket */
>> +    if (socket_type != SOCK_STREAM)
>> +        return 0;
>> +
>> +    if (!dom)
>> +        return 0;
>> +
>> +    return check_socket_access(dom, LANDLOCK_ACCESS_NET_CONNECT_TCP);
>> +}
>> +
>> +static struct security_hook_list landlock_hooks[] __lsm_ro_after_init 
>> = {
>> +    LSM_HOOK_INIT(socket_bind, hook_socket_bind),
>> +    LSM_HOOK_INIT(socket_connect, hook_socket_connect),
>> +};
>> +
>> +__init void landlock_add_net_hooks(void)
>> +{
>> +    security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
>> +            LANDLOCK_NAME);
>> +}
>> diff --git a/security/landlock/net.h b/security/landlock/net.h
>> new file mode 100644
>> index 000000000000..27ef59a42a1e
>> --- /dev/null
>> +++ b/security/landlock/net.h
>> @@ -0,0 +1,40 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Landlock LSM - Network management and hooks
>> + *
>> + * Copyright © 2017-2020 Mickaël Salaün <mic@digikod.net>
>> + * Copyright © 2018-2020 ANSSI
>> + */
>> +
>> +#ifndef _SECURITY_LANDLOCK_NET_H
>> +#define _SECURITY_LANDLOCK_NET_H
>> +
>> +#include "common.h"
>> +#include "ruleset.h"
>> +#include "setup.h"
>> +
>> +/**
>> + * struct landlock_task_security - Process task security blob
>> + *
>> + * Enable to reference a &struct landlock_object tied to a task (i.e.
>> + * underlying object).
>> + */
>> +struct landlock_task_security {
>> +    /**
>> +     * @object: Pointer to an allocated object.
>> +     */
>> +    struct landlock_object *object;
>> +};
>> +
>> +static inline struct landlock_task_security *landlock_task(
>> +        const struct task_struct *const task)
>> +{
>> +    return task->security + landlock_blob_sizes.lbs_task;
>> +}
>> +
>> +__init void landlock_add_net_hooks(void);
>> +
>> +int landlock_append_net_rule(struct landlock_ruleset *const ruleset,
>> +                             u32 access_hierarchy);
>> +
>> +#endif /* _SECURITY_LANDLOCK_NET_H */
>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>> index ec72b9262bf3..a335c475965c 100644
>> --- a/security/landlock/ruleset.c
>> +++ b/security/landlock/ruleset.c
>> @@ -27,9 +27,24 @@
>>   static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>>   {
>>       struct landlock_ruleset *new_ruleset;
>> +    u16 row, col, rules_types_num;
>> +
>> +    new_ruleset = kzalloc(sizeof *new_ruleset +
>> +                  sizeof *(new_ruleset->access_masks),
>> +                  GFP_KERNEL_ACCOUNT);
>> +
>> +    rules_types_num = LANDLOCK_RULE_TYPE_NUM;
>> +    /* Initializes access_mask array for multiple rule types.
>> +     * Double array semantic is used convenience: 
>> access_mask[rule_type][num_layer].
>> +     */
>> +    for (row = 0; row < rules_types_num; row++) {
>> +        new_ruleset->access_masks[row] = kzalloc(sizeof
>> +                    *(new_ruleset->access_masks[row]),
>> +                    GFP_KERNEL_ACCOUNT);
>> +        for (col = 0; col < num_layers; col++)
>> +            new_ruleset->access_masks[row][col] = 0;
>> +    }
>>
>> -    new_ruleset = kzalloc(struct_size(new_ruleset, fs_access_masks,
>> -                num_layers), GFP_KERNEL_ACCOUNT);
>>       if (!new_ruleset)
>>           return ERR_PTR(-ENOMEM);
>>       refcount_set(&new_ruleset->usage, 1);
>> @@ -39,21 +54,30 @@ static struct landlock_ruleset 
>> *create_ruleset(const u32 num_layers)
>>       /*
>>        * hierarchy = NULL
>>        * num_rules = 0
>> -     * fs_access_masks[] = 0
>> +     * access_masks[][] = 0
>>        */
>>       return new_ruleset;
>>   }
>>
>> -struct landlock_ruleset *landlock_create_ruleset(const u32 
>> fs_access_mask)
>> +struct landlock_ruleset *landlock_create_ruleset(const u32 
>> fs_access_mask,
>> +                         const u32 net_access_mask)
>>   {
>>       struct landlock_ruleset *new_ruleset;
>> +    u8 rule_fs_type, rule_net_type;
>>
>>       /* Informs about useless ruleset. */
>> -    if (!fs_access_mask)
>> +    if (!fs_access_mask && !net_access_mask)
>>           return ERR_PTR(-ENOMSG);
>>       new_ruleset = create_ruleset(1);
>> -    if (!IS_ERR(new_ruleset))
>> -        new_ruleset->fs_access_masks[0] = fs_access_mask;
>> +
>> +    rule_fs_type = LANDLOCK_RULE_PATH_BENEATH - 1;
>> +    if (!IS_ERR(new_ruleset) && fs_access_mask)
>> +        new_ruleset->access_masks[rule_fs_type][0] = fs_access_mask;
>> +
>> +    rule_net_type = LANDLOCK_RULE_NET_SERVICE - 1;
>> +    if (!IS_ERR(new_ruleset) && net_access_mask)
>> +        new_ruleset->access_masks[rule_net_type][0] = net_access_mask;
>> +
>>       return new_ruleset;
>>   }
>>
>> @@ -112,15 +136,23 @@ static void free_rule(struct landlock_rule 
>> *const rule)
>>
>>   static void build_check_ruleset(void)
>>   {
>> +    u8 rule_fs_type, rule_net_type;
>> +
>>       const struct landlock_ruleset ruleset = {
>>           .num_rules = ~0,
>>           .num_layers = ~0,
>>       };
>> -    typeof(ruleset.fs_access_masks[0]) fs_access_mask = ~0;
>> +
>> +    rule_fs_type = LANDLOCK_RULE_PATH_BENEATH - 1;
>> +    rule_net_type = LANDLOCK_RULE_NET_SERVICE - 1;
>> +
>> +    typeof(ruleset.access_masks[rule_fs_type][0]) fs_access_mask = ~0;
>> +    typeof(ruleset.access_masks[rule_net_type][0]) net_access_mask = ~0;
>>
>>       BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
>>       BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
>>       BUILD_BUG_ON(fs_access_mask < LANDLOCK_MASK_ACCESS_FS);
>> +    BUILD_BUG_ON(net_access_mask < LANDLOCK_MASK_ACCESS_NET);
>>   }
>>
>>   /**
>> @@ -260,8 +292,12 @@ static int merge_ruleset(struct landlock_ruleset 
>> *const dst,
>>           struct landlock_ruleset *const src)
>>   {
>>       struct landlock_rule *walker_rule, *next_rule;
>> +    u8 rule_fs_type, rule_net_type;
>>       int err = 0;
>>
>> +    rule_fs_type = LANDLOCK_RULE_PATH_BENEATH - 1;
>> +    rule_net_type = LANDLOCK_RULE_NET_SERVICE - 1;
>> +
>>       might_sleep();
>>       /* Should already be checked by landlock_merge_ruleset() */
>>       if (WARN_ON_ONCE(!src))
>> @@ -279,7 +315,14 @@ static int merge_ruleset(struct landlock_ruleset 
>> *const dst,
>>           err = -EINVAL;
>>           goto out_unlock;
>>       }
>> -    dst->fs_access_masks[dst->num_layers - 1] = src->fs_access_masks[0];
>> +
>> +    /* Copy fs access masks. */
>> +    dst->access_masks[rule_fs_type][dst->num_layers - 1] =
>> +                    src->access_masks[rule_fs_type][0];
>> +    /* Copy network access masks. */
>> +    dst->access_masks[rule_net_type][dst->num_layers - 1] =
>> +                    src->access_masks[rule_net_type][0];
>> +
>>
>>       /* Merges the @src tree. */
>>       rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
>> @@ -336,9 +379,12 @@ static int inherit_ruleset(struct 
>> landlock_ruleset *const parent,
>>           err = -EINVAL;
>>           goto out_unlock;
>>       }
>> -    /* Copies the parent layer stack and leaves a space for the new 
>> layer. */
>> -    memcpy(child->fs_access_masks, parent->fs_access_masks,
>> -            flex_array_size(parent, fs_access_masks, 
>> parent->num_layers));
>> +    /* Copies the parent layer stack and leaves a space for the new 
>> layer.
>> +     * Remember to copy num_layers*num_tule_types size.
>> +     */
>> +    memcpy(child->access_masks, parent->access_masks,
>> +            flex_array_size(parent, access_masks, 
>> LANDLOCK_RULE_TYPE_NUM *
>> +                                  parent->num_layers));
>>
>>       if (WARN_ON_ONCE(!parent->hierarchy)) {
>>           err = -EINVAL;
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index 2d3ed7ec5a0a..965a69a108e9 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -124,23 +124,24 @@ struct landlock_ruleset {
>>                */
>>               u32 num_layers;
>>               /**
>> -             * @fs_access_masks: Contains the subset of filesystem
>> -             * actions that are restricted by a ruleset.  A domain
>> -             * saves all layers of merged rulesets in a stack
>> -             * (FAM), starting from the first layer to the last
>> -             * one.  These layers are used when merging rulesets,
>> -             * for user space backward compatibility (i.e.
>> -             * future-proof), and to properly handle merged
>> +             * @access_masks: Contains the subset of filesystem
>> +             * or network actions that are restricted by a ruleset.
>> +             * A domain saves all layers of merged rulesets in a
>> +             * stack(FAM), starting from the first layer to the
>> +             * last one. These layers are used when merging
>> +             * rulesets, for user space backward compatibility
>> +             * (i.e. future-proof), and to properly handle merged
>>                * rulesets without overlapping access rights.  These
>>                * layers are set once and never changed for the
>>                * lifetime of the ruleset.
>>                */
>> -            u16 fs_access_masks[];
>> +            u16 *access_masks[];
>>           };
>>       };
>>   };
>>
>> -struct landlock_ruleset *landlock_create_ruleset(const u32 
>> fs_access_mask);
>> +struct landlock_ruleset *landlock_create_ruleset(const u32 
>> fs_access_mask,
>> +                         const u32 net_access_mask);
>>
>>   void landlock_put_ruleset(struct landlock_ruleset *const ruleset);
>>   void landlock_put_ruleset_deferred(struct landlock_ruleset *const 
>> ruleset);
>> diff --git a/security/landlock/setup.c b/security/landlock/setup.c
>> index f8e8e980454c..91ab06ec8ce0 100644
>> --- a/security/landlock/setup.c
>> +++ b/security/landlock/setup.c
>> @@ -14,6 +14,7 @@
>>   #include "fs.h"
>>   #include "ptrace.h"
>>   #include "setup.h"
>> +#include "net.h"
>>
>>   bool landlock_initialized __lsm_ro_after_init = false;
>>
>> @@ -21,6 +22,7 @@ struct lsm_blob_sizes landlock_blob_sizes 
>> __lsm_ro_after_init = {
>>       .lbs_cred = sizeof(struct landlock_cred_security),
>>       .lbs_inode = sizeof(struct landlock_inode_security),
>>       .lbs_superblock = sizeof(struct landlock_superblock_security),
>> +    .lbs_task = sizeof(struct landlock_task_security),
>>   };
>>
>>   static int __init landlock_init(void)
>> @@ -28,6 +30,7 @@ static int __init landlock_init(void)
>>       landlock_add_cred_hooks();
>>       landlock_add_ptrace_hooks();
>>       landlock_add_fs_hooks();
>> +    landlock_add_net_hooks();
>>       landlock_initialized = true;
>>       pr_info("Up and running.\n");
>>       return 0;
>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>> index 32396962f04d..0dad22e99500 100644
>> --- a/security/landlock/syscalls.c
>> +++ b/security/landlock/syscalls.c
>> @@ -31,6 +31,7 @@
>>   #include "limits.h"
>>   #include "ruleset.h"
>>   #include "setup.h"
>> +#include "net.h"
>>
>>   /**
>>    * copy_min_struct_from_user - Safe future-proof argument copying
>> @@ -73,7 +74,8 @@ static void build_check_abi(void)
>>   {
>>       struct landlock_ruleset_attr ruleset_attr;
>>       struct landlock_path_beneath_attr path_beneath_attr;
>> -    size_t ruleset_size, path_beneath_size;
>> +    struct landlock_net_service_attr net_service_attr;
>> +    size_t ruleset_size, path_beneath_size, net_service_size;
>>
>>       /*
>>        * For each user space ABI structures, first checks that there 
>> is no
>> @@ -81,17 +83,22 @@ static void build_check_abi(void)
>>        * struct size.
>>        */
>>       ruleset_size = sizeof(ruleset_attr.handled_access_fs);
>> +    ruleset_size += sizeof(ruleset_attr.handled_access_net);
>>       BUILD_BUG_ON(sizeof(ruleset_attr) != ruleset_size);
>> -    BUILD_BUG_ON(sizeof(ruleset_attr) != 8);
>> +    BUILD_BUG_ON(sizeof(ruleset_attr) != 16);
>>
>>       path_beneath_size = sizeof(path_beneath_attr.allowed_access);
>>       path_beneath_size += sizeof(path_beneath_attr.parent_fd);
>>       BUILD_BUG_ON(sizeof(path_beneath_attr) != path_beneath_size);
>>       BUILD_BUG_ON(sizeof(path_beneath_attr) != 12);
>> +
>> +    net_service_size = sizeof(net_service_attr.allowed_access);
>> +    net_service_size += sizeof(net_service_attr.port);
>> +    BUILD_BUG_ON(sizeof(net_service_attr) != net_service_size);
>> +    BUILD_BUG_ON(sizeof(net_service_attr) != 10);
>>   }
>>
>>   /* Ruleset handling */
>> -
>>   static int fop_ruleset_release(struct inode *const inode,
>>           struct file *const filp)
>>   {
>> @@ -176,18 +183,24 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>>
>>       /* Copies raw user space buffer. */
>>       err = copy_min_struct_from_user(&ruleset_attr, 
>> sizeof(ruleset_attr),
>> -            offsetofend(typeof(ruleset_attr), handled_access_fs),
>> +            offsetofend(typeof(ruleset_attr), handled_access_net),
>>               attr, size);
>>       if (err)
>>           return err;
>>
>> -    /* Checks content (and 32-bits cast). */
>> +    /* Checks fs content (and 32-bits cast). */
>>       if ((ruleset_attr.handled_access_fs | LANDLOCK_MASK_ACCESS_FS) !=
>>               LANDLOCK_MASK_ACCESS_FS)
>>           return -EINVAL;
>>
>> +    /* Checks network content (and 32-bits cast). */
>> +    if ((ruleset_attr.handled_access_net | LANDLOCK_MASK_ACCESS_NET) !=
>> +            LANDLOCK_MASK_ACCESS_NET)
>> +        return -EINVAL;
>> +
>>       /* Checks arguments and transforms to kernel struct. */
>> -    ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs);
>> +    ruleset = landlock_create_ruleset(ruleset_attr.handled_access_fs,
>> +                      ruleset_attr.handled_access_net);
>>       if (IS_ERR(ruleset))
>>           return PTR_ERR(ruleset);
>>
>> @@ -306,6 +319,7 @@ SYSCALL_DEFINE4(landlock_add_rule,
>>           const void __user *const, rule_attr, const __u32, flags)
>>   {
>>       struct landlock_path_beneath_attr path_beneath_attr;
>> +    struct landlock_net_service_attr  net_service_attr;
>>       struct path path;
>>       struct landlock_ruleset *ruleset;
>>       int res, err;
>> @@ -317,47 +331,90 @@ SYSCALL_DEFINE4(landlock_add_rule,
>>       if (flags)
>>           return -EINVAL;
>>
>> -    if (rule_type != LANDLOCK_RULE_PATH_BENEATH)
>> +    if ((rule_type != LANDLOCK_RULE_PATH_BENEATH) &&
>> +        (rule_type != LANDLOCK_RULE_NET_SERVICE))
>>           return -EINVAL;
>>
>> -    /* Copies raw user space buffer, only one type for now. */
>> -    res = copy_from_user(&path_beneath_attr, rule_attr,
>> -            sizeof(path_beneath_attr));
>> -    if (res)
>> -        return -EFAULT;
>> -
>> -    /* Gets and checks the ruleset. */
>> -    ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>> -    if (IS_ERR(ruleset))
>> -        return PTR_ERR(ruleset);
>> -
>> -    /*
>> -     * Informs about useless rule: empty allowed_access (i.e. deny 
>> rules)
>> -     * are ignored in path walks.
>> -     */
>> -    if (!path_beneath_attr.allowed_access) {
>> -        err = -ENOMSG;
>> -        goto out_put_ruleset;
>> -    }
>> -    /*
>> -     * Checks that allowed_access matches the @ruleset constraints
>> -     * (ruleset->fs_access_masks[0] is automatically upgraded to 
>> 64-bits).
>> -     */
>> -    if ((path_beneath_attr.allowed_access | 
>> ruleset->fs_access_masks[0]) !=
>> -            ruleset->fs_access_masks[0]) {
>> -        err = -EINVAL;
>> -        goto out_put_ruleset;
>> +    switch (rule_type) {
>> +    case LANDLOCK_RULE_PATH_BENEATH:
>> +        /* Copies raw user space buffer, for fs rule type. */
>> +        res = copy_from_user(&path_beneath_attr, rule_attr,
>> +                    sizeof(path_beneath_attr));
>> +        if (res)
>> +            return -EFAULT;
>> +        break;
>> +
>> +    case LANDLOCK_RULE_NET_SERVICE:
>> +        /* Copies raw user space buffer, for net rule type. */
>> +        res = copy_from_user(&net_service_attr, rule_attr,
>> +                sizeof(net_service_attr));
>> +        if (res)
>> +            return -EFAULT;
>> +        break;
>>       }
>>
>> -    /* Gets and checks the new rule. */
>> -    err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
>> -    if (err)
>> -        goto out_put_ruleset;
>> +    if (rule_type == LANDLOCK_RULE_PATH_BENEATH) {
>> +        /* Gets and checks the ruleset. */
>> +        ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>> +        if (IS_ERR(ruleset))
>> +            return PTR_ERR(ruleset);
>> +
>> +        /*
>> +         * Informs about useless rule: empty allowed_access (i.e. 
>> deny rules)
>> +         * are ignored in path walks.
>> +         */
>> +        if (!path_beneath_attr.allowed_access) {
>> +            err = -ENOMSG;
>> +            goto out_put_ruleset;
>> +        }
>> +        /*
>> +         * Checks that allowed_access matches the @ruleset constraints
>> +         * (ruleset->access_masks[fs_type][0] is automatically 
>> upgraded to 64-bits).
>> +         */
>> +        if ((path_beneath_attr.allowed_access | 
>> ruleset->access_masks[rule_type-1][0]) !=
>> +                            ruleset->access_masks[rule_type-1][0]) {
>> +            err = -EINVAL;
>> +            goto out_put_ruleset;
>> +        }
>> +
>> +        /* Gets and checks the new rule. */
>> +        err = get_path_from_fd(path_beneath_attr.parent_fd, &path);
>> +        if (err)
>> +            goto out_put_ruleset;
>> +
>> +        /* Imports the new rule. */
>> +        err = landlock_append_fs_rule(ruleset, &path,
>> +                path_beneath_attr.allowed_access);
>> +        path_put(&path);
>> +    }
>>
>> -    /* Imports the new rule. */
>> -    err = landlock_append_fs_rule(ruleset, &path,
>> -            path_beneath_attr.allowed_access);
>> -    path_put(&path);
>> +    if (rule_type == LANDLOCK_RULE_NET_SERVICE) {
>> +        /* Gets and checks the ruleset. */
>> +        ruleset = get_ruleset_from_fd(ruleset_fd, FMODE_CAN_WRITE);
>> +        if (IS_ERR(ruleset))
>> +            return PTR_ERR(ruleset);
>> +
>> +        /*
>> +         * Informs about useless rule: empty allowed_access (i.e. 
>> deny rules)
>> +         * are ignored in network actions
>> +         */
>> +        if (!net_service_attr.allowed_access) {
>> +            err = -ENOMSG;
>> +            goto out_put_ruleset;
>> +        }
>> +        /*
>> +         * Checks that allowed_access matches the @ruleset constraints
>> +         * (ruleset->access_masks[net_type][0] is automatically 
>> upgraded to 64-bits).
>> +         */
>> +        if ((net_service_attr.allowed_access | 
>> ruleset->access_masks[rule_type - 1][0]) !=
>> +                            ruleset->access_masks[rule_type - 1][0]) {
>> +            err = -EINVAL;
>> +            goto out_put_ruleset;
>> +        }
>> +
>> +        /* Imports the new rule. */
>> +        err = landlock_append_net_rule(ruleset, 
>> net_service_attr.allowed_access);
>> +    }
>>
>>   out_put_ruleset:
>>       landlock_put_ruleset(ruleset);
>> -- 
>> 2.25.1
>>
> .
