Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1F642F443
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbhJONym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:54:42 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:48653 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236395AbhJONyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 09:54:36 -0400
Received: (Authenticated sender: i.maximets@ovn.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 16F3D240007;
        Fri, 15 Oct 2021 13:52:24 +0000 (UTC)
Message-ID: <8c4ee3e8-0400-ee6e-b12c-327806f26dae@ovn.org>
Date:   Fri, 15 Oct 2021 15:52:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Cc:     ovs dev <dev@openvswitch.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, i.maximets@ovn.org
Content-Language: en-US
To:     Cpp Code <cpp.code.lv@gmail.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
References: <20210928194727.1635106-1-cpp.code.lv@gmail.com>
 <20210928174853.06fe8e66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d1e5b178-47f5-9791-73e9-0c1f805b0fca@6wind.com>
 <20210929061909.59c94eff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAASuNyVe8z1R6xyCfSAxZbcrL3dej1n8TXXkqS-e8QvA6eWd+w@mail.gmail.com>
 <b091ef39-dc29-8362-4d31-0a9cc498e8ea@6wind.com>
 <CAASuNyW81zpSu+FGSDuUrOsyqJj7SokZtvX081BbeXi0ARBaYg@mail.gmail.com>
 <a4894aef-b82a-8224-611d-07be229f5ebe@6wind.com>
 <CAASuNyUWP2HQLhGf29is3fG2+uG8SqOFoXHeHf-vC6HYJ1Wb7g@mail.gmail.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH net-next v6] net: openvswitch: IPv6: Add IPv6
 extension header support
In-Reply-To: <CAASuNyUWP2HQLhGf29is3fG2+uG8SqOFoXHeHf-vC6HYJ1Wb7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/21 23:12, Cpp Code wrote:
> On Mon, Oct 4, 2021 at 11:41 PM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>
>> Le 01/10/2021 à 22:42, Cpp Code a écrit :
>>> On Fri, Oct 1, 2021 at 12:21 AM Nicolas Dichtel
>>> <nicolas.dichtel@6wind.com> wrote:
>>>>
>>>> Le 30/09/2021 à 18:11, Cpp Code a écrit :
>>>>> On Wed, Sep 29, 2021 at 6:19 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>>>
>>>>>> On Wed, 29 Sep 2021 08:19:05 +0200 Nicolas Dichtel wrote:
>>>>>>>> /* Insert a kernel only KEY_ATTR */
>>>>>>>> #define OVS_KEY_ATTR_TUNNEL_INFO    __OVS_KEY_ATTR_MAX
>>>>>>>> #undef OVS_KEY_ATTR_MAX
>>>>>>>> #define OVS_KEY_ATTR_MAX            __OVS_KEY_ATTR_MAX
>>>>>>> Following the other thread [1], this will break if a new app runs over an old
>>>>>>> kernel.
>>>>>>
>>>>>> Good point.
>>>>>>
>>>>>>> Why not simply expose this attribute to userspace and throw an error if a
>>>>>>> userspace app uses it?
>>>>>>
>>>>>> Does it matter if it's exposed or not? Either way the parsing policy
>>>>>> for attrs coming from user space should have a reject for the value.
>>>>>> (I say that not having looked at the code, so maybe I shouldn't...)
>>>>>
>>>>> To remove some confusion, there are some architectural nuances if we
>>>>> want to extend code without large refactor.
>>>>> The ovs_key_attr is defined only in kernel side. Userspace side is
>>>>> generated from this file. As well the code can be built without kernel
>>>>> modules.
>>>>> The code inside OVS repository and net-next is not identical, but I
>>>>> try to keep some consistency.
>>>> I didn't get why OVS_KEY_ATTR_TUNNEL_INFO cannot be exposed to userspace.
>>>
>>> OVS_KEY_ATTR_TUNNEL_INFO is compressed version of OVS_KEY_ATTR_TUNNEL
>>> and for clarity purposes its not exposed to userspace as it will never
>>> use it.
>>> I would say it's a coding style as it would not brake anything if exposed.
>> In fact, it's the best way to keep the compatibility in the long term.
>> You can define it like this:
>> OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info, reserved for kernel use */
>>
>>>
>>>>
>>>>>
>>>>> JFYI This is the file responsible for generating userspace part:
>>>>> https://github.com/openvswitch/ovs/blob/master/build-aux/extract-odp-netlink-h
>>>>> This is the how corresponding file for ovs_key_attr looks inside OVS:
>>>>> https://github.com/openvswitch/ovs/blob/master/datapath/linux/compat/include/linux/openvswitch.h
>>>>> one can see there are more values than in net-next version.
>>>> There are still some '#ifdef __KERNEL__'. The standard 'make headers_install'
>>>> filters them. Why not using this standard mechanism?
>>>
>>> Could you elaborate on this, I don't quite understand the idea!? Which
>>> ifdef you are referring, the one along OVS_KEY_ATTR_TUNNEL_INFO or
>>> some other?
>> My understanding is that this file is used for the userland third party, thus,
>> theoretically, there should be no '#ifdef __KERNEL__'. uapi headers generated
>> with 'make headers_install' are filtered to remove them.
> 
> From https://lwn.net/Articles/507794/ I understand that is the goal,
> but this part of the code is still used in the kernel part.
> 
>>
>>>
>>>>
>>>> In this file, there are two attributes (OVS_KEY_ATTR_PACKET_TYPE and
>>>> OVS_KEY_ATTR_ND_EXTENSIONS) that doesn't exist in the kernel.
>>>> This will also breaks if an old app runs over a new kernel. I don't see how it
>>>> is possible to keep the compat between {old|new} {kernel|app}.

I don't know why the initial design looked like this, but here some
thoughts on why it works without noticeable issues:

OVS_KEY_ATTR_TUNNEL_INFO is defined only for kernel and not used by
userspace application.  If we have newer app and older kernel, new
app can send a different attribute, kernel than will interpret it
as OVS_KEY_ATTR_TUNNEL_INFO.  This will pass the
'type > OVS_KEY_ATTR_MAX' check.  However, this will always fail the
check_attr_len() check, because the length for OVS_KEY_ATTR_TUNNEL_INFO
is not defined in 'ovs_key_lens' and will be treated as zero, while
correct attributes always has non-zero length (at least current ones
has).  Kind of ugly, but should work.  And yes, more explicit
rejection should be implemented, I think.

OVS_KEY_ATTR_PACKET_TYPE and OVS_KEY_ATTR_ND_EXTENSIONS doesn't
exist in kernel and moreover not even used by the application for
kernel datapath, so it's fine.  And it's application's responsibility
to never send them to kernel as they are not intended to be sent.
So, this is in realm of the app, kernel should not care about these
two attributes.
If newer kernel will send some different attributes to the old app,
app will drop them as these are not expected to be ever received from
a kernel (similar attribute length check as in above case with
OVS_KEY_ATTR_TUNNEL_INFO).  Another point is that kernel should not
normally return attributes not previously set by userspace application,
so this should only happen in a runtime application downgrade scenario.

All-in-all it should be safe to add new attributes before the
OVS_KEY_ATTR_TUNNEL_INFO inside the kernel without introducing
any new paddings.  At least, as long as there are no common (valid
for both kernel AND the app) attributes defined after the
OVS_KEY_ATTR_TUNNEL_INFO.

But, well, I agree that current design doesn't look great.  OTOH,
paddings makes it even worse.

>>>
>>> Looks like this most likely is a bug while working on multiple
>>> versions of code.  Need to do add more padding.
>> As said above, just define the same uapi for everybody and the problem is gone
>> forever.

That should be a right change to do.  We can start with exposing the
OVS_KEY_ATTR_TUNNEL_INFO.  At the same time userspace-only attributes
in the OVS codebase should, likely, be moved to a separate enum/structure
to avoid confusion and keep kernel uapi clean.  Though this will require
some code changes on the OVS side.

>>
> 
> As this part of the code was already there, I think the correct way
> would be to refactor that in a separate commit if necessary.

It's OK to make this a separate change, but, please, don't add
paddings in a current one.  Add the new attribute before the
OVS_KEY_ATTR_TUNNEL_INFO instead.

Best regards, Ilya Maximets.

> 
>>
>> Regards,
>> Nicolas
> 
> Best,
> Tom
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
> 

