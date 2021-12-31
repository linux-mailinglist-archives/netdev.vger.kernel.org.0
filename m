Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4BD4820E5
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 00:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240855AbhL3XzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 18:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237257AbhL3XzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 18:55:08 -0500
Received: from smtp-42ad.mail.infomaniak.ch (smtp-42ad.mail.infomaniak.ch [IPv6:2001:1600:3:17::42ad])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF99C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 15:55:08 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JQ4rn6538zMqW4L;
        Fri, 31 Dec 2021 00:55:05 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4JQ4rn0x4RzlhPJV;
        Fri, 31 Dec 2021 00:55:04 +0100 (CET)
Message-ID: <a24ffb44-8f3c-e043-61fa-3652e3e648b1@digikod.net>
Date:   Fri, 31 Dec 2021 01:00:00 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Casey Schaufler <casey@schaufler-ca.com>,
        Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20211228115212.703084-1-konstantin.meskhidze@huawei.com>
 <ea82de6a-0b28-7d96-a84e-49fa0be39f0e@schaufler-ca.com>
 <62cf5983-2a81-a273-d892-58b014a90997@huawei.com>
 <f7c587ab-5449-8c9f-aace-4ca60c60663f@schaufler-ca.com>
 <bf9e42b5-5034-561e-b872-7ab20738326b@digikod.net>
 <15442102-8fa7-8665-831a-dc442f1fa073@schaufler-ca.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 0/1] Landlock network PoC
In-Reply-To: <15442102-8fa7-8665-831a-dc442f1fa073@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 31/12/2021 00:23, Casey Schaufler wrote:
> On 12/30/2021 2:50 PM, Mickaël Salaün wrote:
>>
>> On 30/12/2021 18:59, Casey Schaufler wrote:
>>> On 12/29/2021 6:56 PM, Konstantin Meskhidze wrote:
>>
>> [...]
>>
>>>
>>>> But I agree, that socket itself (as collection of data used for 
>>>> interproccess communication) could be not be an object.
>>>>
>>>> Anyway, my approach would not work in containerized environment: 
>>>> RUNC, containerd ect. Mickaёl suggested to go another way for 
>>>> Landlock network confinement: Defining "object" with connection port.
>>>
>>> Oh, the old days of modeling ...
>>>
>>> A port number is a name. It identifies a subject. A subject
>>> "names" itself by binding to a port number. The port itself
>>> isn't a thing.
>>
>> It depends on the definition of subject, object and action.
> 
> You are correct. And I am referring to the classic computer security
> model definitions.

Me too! :)

> If you want to redefine those terms to justify your
> position it isn't going to make me very happy.
> 
> 
>> The action can be connect or bind,
> 
> Nope. Sorry. Bind isn't an "action" because it does not involve a subject
> and an object.

In this context, the subject is the process calling bind. In a 
traditional model, we would probably identify the socket as the object 
though.

> 
>> and the object a TCP port,
> 
> As I pointed out earlier, a port isn't an object, it is a name.
> A port as no security attributes. "Privileged ports" are a convention.
> A port is meaningless unless it is bond, in which case all meaning is
> tied up with the process that bound it.

A port is not a kernel object, but in this case it can still be defined 
as an (abstract) object in a security policy. I think this is the 
misunderstanding here.

> 
> 
>> i.e. a subject doing an action on an object may require a 
>> corresponding access right.
> 
> You're claiming that because you want to restrict what processes can
> bind a port, ports must be objects. But that's not what you're doing here.
> You are making the problem harder than it needs to be
> 
>>
>>>
>>> You could change that. In fact, Smack includes port labeling
>>> for local IPv6. I don't recommend it, as protocol correctness
>>> is very difficult to achieve. Smack will forgo port labeling
>>> as soon as CALIPSO support (real soon now - priorities permitting)
>>> is available.
>> Please keep in mind that Landlock is a feature available to 
>> unprivileged (then potentially malicious) processes. I'm not sure 
>> packet labeling fits this model, but if it does and there is a need, 
>> we may consider it in the future. Let's first see with Smack. ;)
>>
>> Landlock is also designed to be extensible. It makes sense to start 
>> with an MVP network access control. Being able to restrict TCP connect 
>> and bind actions, with exception for a set of ports, is simple, 
>> pragmatic and useful. Let's start with that.
> 
> I'm not saying it isn't useful, I'm saying that it has nothing to do
> with subjects, objects and accesses. A process changing it's own state
> does not require access to any object.
> 
>>
>>>
>>> Again, on the other hand, you're not doing anything that's an
>>> access control decision. You're saying "I don't want to bind to
>>> port 3920, stop me if I try".
>>
>> This is an access control.
> 
> No.

:)

> 
>> A subject can define restrictions for itself and others (e.g. future 
>> child processes).
> 
> The "others" are subjects whose initial state is defined to be the
> state of the parent at time of exec. This is trivially modeled.

This doesn't change much.

> 
>> We may also consider that the same process can transition from one 
>> subject to another over time.
> 
> No, you cannot. A process pretty well defines a subject on a Linux system.
> Where the blazes did you get this notion?

I'm thinking in a more abstract way. I wanted to give this example 
because of your thinking about what is an access control or not. We 
don't have to tie semantic to concrete kernel data/objects. Because a 
process fits well to a subject for some use cases, it may not for 
others. In the end it doesn't matter much.

> 
>> This may be caused by a call to landlock_restrict_self(2) or, more 
>> abstractly, by an exploited vulnerability (e.g. execve, ROP…). Not 
>> everyone may agree with this lexical point of view (e.g. we can 
>> replace "subject" with "role"…), but the important point is that 
>> Landlock is an access control system, which is not (only) configured 
>> by the root user.
> 
> No. Landlock is a mechanism for processes to prevent themselves from 
> performing
> operations they would normally be allowed. No access control, subjects or
> objects are required to do this is many cases. Including bind.

I don't agree. An access control is a mechanism, backed by a security 
policy, which enforces restrictions on a system. Landlock is a way to 
drop privileges but also to enforce a set of security policies. We can 
see Smack, SELinux or others as a way for root to drop privileges too 
and for other users to restrict accesses they could have otherwise.

> 
>>
>>> All you're doing is asking the
>>> kernel to remember something for you, on the off chance you
>>> forget. There isn't any reason I can see for this to be associated
>>> with the port. It should be associated with the task.
>>
>> I don't understand your point. What do you want to associate with a 
>> task? Landlock domains are already tied to a set of tasks.
> 
> That's pretty much what I'm saying. It's all task data.

OK

> 
>>
>>>
>>>> Can be checked here:
>>>> https://lore.kernel.org/netdev/d9aa57a7-9978-d0a4-3aa0-4512fd9459df@digikod.net 
>>>>
>>>>
>>>> Hope I exlained my point. Thanks again for your comments.
>>
>> [...]
