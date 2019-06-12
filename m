Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BABBE41A6F
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 04:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436514AbfFLCkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 22:40:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37130 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406202AbfFLCkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 22:40:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yvy/gkrIuOAqW1aZMYOf3AGFTiXylWG+oKPZyKjIo4w=; b=juH7/uOYpZ8jrItAQ7kbO3cWF
        t2fmGc+ksnS3y/SXiuvQqTb5NklWSxrFgXXQqRQJBtZuS6QRqiZHTPq9vlQg6cjARtYfByfwJlBLR
        kcj2xXFRseqw4IJnSFvuZrvQmLORk+DHSNqOzXJi+mUdIWusr4FOXjaDoZWOrlGYciRlbNQglynUX
        743DguT32rU6j1hOn0ql6TVad55xC17RcI54BJgfyEslIfGMPjDx/ZzpMt3HLV0RHad2QERo47mSG
        4JabUXwBWYCbBwT3MM/PtaiQ/lEhqv0D9WNmZo7V2YXhrAbwVHXJWQqDz+JdNlJTOVJykIWAa/ZSi
        4kx41DZbA==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=dragon.dunlab)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hatB9-0006Wi-L2; Wed, 12 Jun 2019 02:39:59 +0000
Subject: Re: [PATCH net] mpls: fix af_mpls dependencies
To:     Matteo Croce <mcroce@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
References: <20190608125019.417-1-mcroce@redhat.com>
 <20190609.195742.739339469351067643.davem@davemloft.net>
 <d19abcd4-799c-ac2f-ffcb-fa749d17950c@infradead.org>
 <CAGnkfhyS15NPEO2ygkjazECULtUDkJgPk8wCYFhA9zL2+w27pg@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <49b58181-90da-4ee4-cbb0-80e226d040fc@infradead.org>
Date:   Tue, 11 Jun 2019 19:39:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAGnkfhyS15NPEO2ygkjazECULtUDkJgPk8wCYFhA9zL2+w27pg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/19 5:08 PM, Matteo Croce wrote:
> On Wed, Jun 12, 2019 at 1:07 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> On 6/9/19 7:57 PM, David Miller wrote:
>>> From: Matteo Croce <mcroce@redhat.com>
>>> Date: Sat,  8 Jun 2019 14:50:19 +0200
>>>
>>>> MPLS routing code relies on sysctl to work, so let it select PROC_SYSCTL.
>>>>
>>>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>>>> Suggested-by: David Ahern <dsahern@gmail.com>
>>>> Signed-off-by: Matteo Croce <mcroce@redhat.com>
>>>
>>> Applied, thanks.
>>>
>>
>> This patch causes build errors when
>> # CONFIG_PROC_FS is not set
>> because PROC_SYSCTL depends on PROC_FS.  The build errors are not
>> in fs/proc/ but in other places in the kernel that never expect to see
>> PROC_FS not set but PROC_SYSCTL=y.
>>
> 
> Hi,
> 
> Maybe I'm missing something, if PROC_SYSCTL depends on PROC_FS, how is
> possible to have PROC_FS not set but PROC_SYSCTL=y?

When MPLS=y and MPLS_ROUTING=[y|m], MPLS_ROUTING selects PROC_SYSCTL.
That enables PROC_SYSCTL, whether PROC_FS is set/enabled or not.

There is a warning about this in Documentation/kbuild/kconfig-language.rst:

  Note:
	select should be used with care. select will force
	a symbol to a value without visiting the dependencies.
	By abusing select you are able to select a symbol FOO even
	if FOO depends on BAR that is not set.
	In general use select only for non-visible symbols
	(no prompts anywhere) and for symbols with no dependencies.
	That will limit the usefulness but on the other hand avoid
	the illegal configurations all over.


> I tried it by manually editing .config. but make oldconfig warns:
> 
> WARNING: unmet direct dependencies detected for PROC_SYSCTL
>   Depends on [n]: PROC_FS [=n]
>   Selected by [m]:
>   - MPLS_ROUTING [=m] && NET [=y] && MPLS [=y] && (NET_IP_TUNNEL [=n]
> || NET_IP_TUNNEL [=n]=n)

Yes, I get this also.

> *
> * Restart config...
> *
> *
> * Configure standard kernel features (expert users)
> *
> Configure standard kernel features (expert users) (EXPERT) [Y/?] y
>   Multiple users, groups and capabilities support (MULTIUSER) [Y/n/?] y
>   sgetmask/ssetmask syscalls support (SGETMASK_SYSCALL) [N/y/?] n
>   Sysfs syscall support (SYSFS_SYSCALL) [N/y/?] n
>   Sysctl syscall support (SYSCTL_SYSCALL) [N/y/?] (NEW)

So I still say that MPLS_ROUTING should depend on PROC_SYSCTL,
not select it.

-- 
~Randy
