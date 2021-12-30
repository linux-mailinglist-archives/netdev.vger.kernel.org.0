Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D8C4820D7
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 00:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241470AbhL3XVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 18:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240325AbhL3XVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 18:21:50 -0500
Received: from smtp-42af.mail.infomaniak.ch (smtp-42af.mail.infomaniak.ch [IPv6:2001:1600:3:17::42af])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A713C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 15:21:49 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JQ46M3Rc3zMshdH;
        Fri, 31 Dec 2021 00:21:47 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4JQ46L741dzlkSY9;
        Fri, 31 Dec 2021 00:21:46 +0100 (CET)
Message-ID: <bdbae25f-5136-8905-ca64-03314b125a40@digikod.net>
Date:   Fri, 31 Dec 2021 00:26:42 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20211228115212.703084-1-konstantin.meskhidze@huawei.com>
 <d9aa57a7-9978-d0a4-3aa0-4512fd9459df@digikod.net>
 <02806c8e-e255-232b-1722-65ea1dba2948@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 0/1] Landlock network PoC
In-Reply-To: <02806c8e-e255-232b-1722-65ea1dba2948@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30/12/2021 02:43, Konstantin Meskhidze wrote:
> Hi Mickaël,
> Thanks for the quick reply.
> I apologise that I did not follow some rules here.
> I'm a newbie in the Linux community communication and probably missed 
> some important points.
> Thank you for noticing about them - I will fix my misses.

No worries, these RFCs are here to improve the proposition but also to 
learn.

> 
> 12/29/2021 1:09 AM, Mickaël Salaün wrote:
>> Hi Konstantin,
>>
>> Please read the full how-to about sending patches: 
>> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
>>
>> There are at least these issues:
>> - no link to the previous version: 
>> https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/ 
>>
>> - no version: [RFC PATCH v2 0/1]
>> - even if there is only one patch, please make the cover letter a 
>> separate email (i.e. git format-patch --cover-letter).
> 
> I got it. My mistake.
> Anyway I can resend the patch ,if you would like, with all corrections.

No need to resend the same patch series, just follow these rules for the 
next patch series.

> 
>>
>> It seems that you missed some of my previous (inlined) comments, you 
>> didn't reply to most of them: 
>> https://lore.kernel.org/linux-security-module/b50ed53a-683e-77cf-9dc2-f4ae1b5fa0fd@digikod.net/ 
>>
> 
> Sorry about that. I will take it into account.
> I will reply your previous comments.
> 
>>
>> Did you test your changes before submitting this patch series?
> 
> I tested it into QEMU environment. I wrote net_sandboxer.c
> file just for test insering network rules and bind() and connect() 
> syscalls.

Ok, but I'm wondering about the content if this code and what you 
actually tested with it. This is one reason why included standalone 
tests are useful.

> Also I launched your sandboxer.c and it worked well.
> I'm going to provide seltests in another patch series.

Great!

> 
>>
>> This series can only forbids TCP connects and binds to processes other 
>> than the one creating the ruleset, which doesn't make sense here (as I 
>> already explained). TCP ports are not checked.
> 
> Yes. I provided just inserting network access rules into a prosess 
> ruleset.For the port checking, I wanted to ask your opinion about how it 
> would possible to insert port rule. Cause I have my view, that differs 
> from your one.
> 
>>
>> If you have any doubts about any of the comments, please rephrase, 
>> challenge them and ask questions.
>>
>>
>> On 28/12/2021 12:52, Konstantin Meskhidze wrote:
>>> Hi, all!
>>> Here is another PoC patch for Landlock network confinement.
>>> Now 2 hooks are supported for TCP sockets:
>>>     - hook_socket_bind()
>>>     - hook_socket_connect()
>>>
>>> After architectuire has been more clear, there will be a patch with
>>> selftests.
>>>
>>> Please welcome with any comments and suggestions.
>>>
>>>
>>> Implementation related issues
>>> =============================
>>>
>>> 1. It was suggested by Mickaёl using new network rules
>>> attributes, like:
>>>
>>> struct landlock_net_service_attr {
>>>        __u64 allowed_access; // LANDLOCK_NET_*_TCP
>>>        __u16 port;
>>> } __attribute__((packed));
>>>
>>> I found that, if we want to support inserting port attributes,
>>> it's needed to add port member into struct landlock_rule:
>>>
>>> struct landlock_rule {
>>>     ...
>>>     struct landlock_object *object;
>>>     /**
>>>      * @num_layers: Number of entries in @layers.
>>>      */
>>>     u32 num_layers;
>>>
>>>     u16 port;
>>
>> In this case the "object" is indeed defined by a port. You can then 
>> create an union containing either a struct landlock_object pointer or 
>> a raw value (here a u16 port). Of course, every code that use the 
>> object field must be audited and updated accordingly. I think the 
>> following update should be a good approach (with updated documentation):
>>
>> struct landlock_rule {
>> [...]
>>      union {
>>          struct landlock_object *ptr;
>>          uintptr_t data;
>>      } object;
>> [...]
>> };
>>
>> …and then a function helper to convert raw data to/from port.
>>
>> It would be a good idea to use a dedicated tree for objects identified 
>> by (typed) data vs. pointer:
>>
>> struct landlock_ruleset {
>>      struct rb_root root_inode; // i.e. the current "root" field.
>>      struct rb_root root_net_port;
>> [...]
>> };
>>
> 
> This approach makes sense. I did not think in this way. I was following 
> the concept that every rule must be tied to a real kernel object. Using 
> pseudo "object" defined by a port is a good idea. Thanks.
> 
>>
>>>     ...
>>> };
>>>
>>> In this case 2 functions landlock_insert_rule() and insert_rule()
>>> must be refactored;
>>>
>>> But, if struct landlock_layer be modified -
>>>
>>> struct landlock_layer {
>>>     /**
>>>      * @level: Position of this layer in the layer stack.
>>>      */
>>>     u16 level;
>>>     /**
>>>      * @access: Bitfield of allowed actions on the kernel object. 
>>> They are
>>>      * relative to the object type (e.g. %LANDLOCK_ACTION_FS_READ).
>>>      */
>>>     u16 access;
>>>
>>>     u16 port;
>>
>> No, struct landlock_layer doesn't need to be modified. This struct is 
>> independent from the type of object. I talked about that in the 
>> previous series.
> 
> I got it. Thanks for the comment.
> 
>>
>>> };
>>> so, just one landlock_insert_rule() must be slightly refactored.
>>> Also many new attributes could be easily supported in future versions.
>>>
>>> 2. access_masks[] member of struct landlock_ruleset was modified
>>> to support multiple rule type masks.
>>> I suggest using 2D array semantic for convenient usage:
>>>     access_masks[rule_type][layer_level]
>>>
>>> But its also possible to use 1D array with modulo arithmetic:
>>>     access_masks[rule_type % layer_level]
>>
>> What about my previous suggestion to use a (well defined) upper bit to 
>> identify the type of access?
>>
> 
> Maybe I missed your point here. But I can't see how to identify 
> different rule types here. If there just one ruleset created, so there 
> is just one access_mask[0] in the ruleset. Its either can be used for 
> filesystem mask or for network one. To support both rule type we need to 
> use at least access_mask[] array with size of 2.
> Also using upper bit to identify access rule type will narrow down
> possible access ammount in future version.
> Anyway please corrent me if I'm wrong here.

We should avoid using multi-dimentional arrays because it makes the code 
more complex (e.g. when allocating memory).

The idea is to split the access masks' u16 to the actual access masks 
and a bit to identify the type of access. Because there is no more than 
13 access rights for now (per access type, i.e. for the file system), 
the 3 upper bits are unused. A simple bit mask (and a shift) can get 
these 3 upper bits or the 13 lower bits. If/when new access bits will be 
used, we'll just need to upgrade the u16 to a u32, but the logic will be 
the same and the userspace ABI unchanged.

[...]

>>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>>> index ec72b9262bf3..a335c475965c 100644
>>> --- a/security/landlock/ruleset.c
>>> +++ b/security/landlock/ruleset.c
>>> @@ -27,9 +27,24 @@
>>>   static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>>>   {
>>>       struct landlock_ruleset *new_ruleset;
>>> +    u16 row, col, rules_types_num;
>>> +
>>> +    new_ruleset = kzalloc(sizeof *new_ruleset +
>>> +                  sizeof *(new_ruleset->access_masks),
>>
>> sizeof(access_masks) is 0.
> 
> Actually sizeof *(new_ruleset->access_masks) is 8.
> It's a 64 bit pointer to u16 array[]. I checked this
> 2D FAM array implementation in a standalone test.

Yes, this gives the size of the pointed element, but I wanted to point 
out that access_masks doesn't have a size (actually a sizeof() call on 
it would failed). This kzalloc() only allocates one element in the 
array. What happen when there is more than one layer?

> 
>>
>>> +                  GFP_KERNEL_ACCOUNT);
>>> +
>>> +    rules_types_num = LANDLOCK_RULE_TYPE_NUM;
>>> +    /* Initializes access_mask array for multiple rule types.
>>> +     * Double array semantic is used convenience: 
>>> access_mask[rule_type][num_layer].
>>> +     */
>>> +    for (row = 0; row < rules_types_num; row++) {
>>> +        new_ruleset->access_masks[row] = kzalloc(sizeof
>>> +                    *(new_ruleset->access_masks[row]),
>>> +                    GFP_KERNEL_ACCOUNT);
>>> +        for (col = 0; col < num_layers; col++)
>>> +            new_ruleset->access_masks[row][col] = 0;
>>> +    }
>>
>> This code may segfault. I guess it wasn't tested. Please enable most 
>> test/check features as I suggested in the previous series.
> 
> I compiled the kernel 5.13 with this patch and tested it in QEMU. No 
> crashes. I tested your sandboxer.c and it works without segfaults.
> But I will provide seltests in future patch.

Did you run the current selftests?

fakeroot make -C tools/testing/selftests TARGETS=landlock gen_tar
tar -xf 
tools/testing/selftests/kselftest_install/kselftest-packages/kselftest.tar.gz
# as root in a VM with Landlock enabled:
./run_kselftest.sh

BTW, you should test with the latest kernel (i.e. latest Linus's tag).

> 
> 
>>
>>>
>>> -    new_ruleset = kzalloc(struct_size(new_ruleset, fs_access_masks,
>>> -                num_layers), GFP_KERNEL_ACCOUNT);
>>
>> What about my comment in the previous series?
> 
> As I replied above.
> Maybe I missed your point here. But I can't see how to identify 
> different rule types here. If there just one ruleset created, so there 
> is just one access_mask[0] in the ruleset. Its either can be used for 
> filesystem mask or for network one. To support both rule type we need to 
> use at least access_mask[] array with size of 2.
> Also using upper bit to identify access rule type will narrow down
> possible access ammount in future version.
> I suggest using 2D array or 1D array with module arithmetic to
> support different rule type masks.
> Anyway please corrent me if I'm wrong here.

See my above comment.

[...]
