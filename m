Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1FA4820BA
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 23:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242316AbhL3Wvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 17:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242303AbhL3Wvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 17:51:43 -0500
X-Greylist: delayed 378 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Dec 2021 14:51:42 PST
Received: from smtp-8fa8.mail.infomaniak.ch (smtp-8fa8.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fa8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A79C06173E
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 14:51:42 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JQ3JL6GwHzN3kf8;
        Thu, 30 Dec 2021 23:45:22 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4JQ3JL1Bj1zlhMCh;
        Thu, 30 Dec 2021 23:45:21 +0100 (CET)
Message-ID: <bf9e42b5-5034-561e-b872-7ab20738326b@digikod.net>
Date:   Thu, 30 Dec 2021 23:50:04 +0100
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
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 0/1] Landlock network PoC
In-Reply-To: <f7c587ab-5449-8c9f-aace-4ca60c60663f@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 30/12/2021 18:59, Casey Schaufler wrote:
> On 12/29/2021 6:56 PM, Konstantin Meskhidze wrote:

[...]

> 
>> But I agree, that socket itself (as collection of data used for 
>> interproccess communication) could be not be an object.
>>
>> Anyway, my approach would not work in containerized environment: RUNC, 
>> containerd ect. Mickaёl suggested to go another way for Landlock 
>> network confinement: Defining "object" with connection port.
> 
> Oh, the old days of modeling ...
> 
> A port number is a name. It identifies a subject. A subject
> "names" itself by binding to a port number. The port itself
> isn't a thing.

It depends on the definition of subject, object and action. The action 
can be connect or bind, and the object a TCP port, i.e. a subject doing 
an action on an object may require a corresponding access right.

> 
> You could change that. In fact, Smack includes port labeling
> for local IPv6. I don't recommend it, as protocol correctness
> is very difficult to achieve. Smack will forgo port labeling
> as soon as CALIPSO support (real soon now - priorities permitting)
> is available.
Please keep in mind that Landlock is a feature available to unprivileged 
(then potentially malicious) processes. I'm not sure packet labeling 
fits this model, but if it does and there is a need, we may consider it 
in the future. Let's first see with Smack. ;)

Landlock is also designed to be extensible. It makes sense to start with 
an MVP network access control. Being able to restrict TCP connect and 
bind actions, with exception for a set of ports, is simple, pragmatic 
and useful. Let's start with that.

> 
> Again, on the other hand, you're not doing anything that's an
> access control decision. You're saying "I don't want to bind to
> port 3920, stop me if I try".

This is an access control. A subject can define restrictions for itself 
and others (e.g. future child processes). We may also consider that the 
same process can transition from one subject to another over time. This 
may be caused by a call to landlock_restrict_self(2) or, more 
abstractly, by an exploited vulnerability (e.g. execve, ROP…). Not 
everyone may agree with this lexical point of view (e.g. we can replace 
"subject" with "role"…), but the important point is that Landlock is an 
access control system, which is not (only) configured by the root user.

> All you're doing is asking the
> kernel to remember something for you, on the off chance you
> forget. There isn't any reason I can see for this to be associated
> with the port. It should be associated with the task.

I don't understand your point. What do you want to associate with a 
task? Landlock domains are already tied to a set of tasks.

> 
>> Can be checked here:
>> https://lore.kernel.org/netdev/d9aa57a7-9978-d0a4-3aa0-4512fd9459df@digikod.net 
>>
>>
>> Hope I exlained my point. Thanks again for your comments.

[...]
