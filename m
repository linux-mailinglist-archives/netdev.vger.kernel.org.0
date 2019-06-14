Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB01E46236
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfFNPKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:10:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56798 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfFNPKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:10:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mE9NtdIMLtRYrJYsPVWIdYlP8QGELtHjDgLDViKfFl8=; b=FnqdDZiJoa/hEZr3Y2wAtAUvW
        RwDKcxBcqFY2c4fPRp6dSp+IE8gwtLiBGpdqJHcJmQvP+4Ydz77mape5I6u1BOJPd61R25r3sE1Uq
        Wsu8q691aQtts8MORMHhDzbud0v3H9nwLCsJZQ9FeadiPcbNDKVkGJkTUgMY27NGkZwebeaGufkjc
        FYFyjqmMpwzysLyHIAAogDRhsHYoQ+Gifq4FFht8alnljAOYi/gKzwpdRNMAaaZ+9Ea6vwAjo3KZC
        +A+uix0ZXF6suPpy6TiGQsXZeuTTHRG0i2hNhQR9tuor/hc3xiQYTTfy4JEylUiV4lzI7oUjXqisS
        5KamCY3rg==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbnqt-00089R-Jx; Fri, 14 Jun 2019 15:10:51 +0000
Subject: Re: [PATCH net] mpls: fix af_mpls dependencies
To:     Arnd Bergmann <arnd@arndb.de>, David Ahern <dsahern@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>
References: <20190608125019.417-1-mcroce@redhat.com>
 <20190609.195742.739339469351067643.davem@davemloft.net>
 <d19abcd4-799c-ac2f-ffcb-fa749d17950c@infradead.org>
 <CAGnkfhyS15NPEO2ygkjazECULtUDkJgPk8wCYFhA9zL2+w27pg@mail.gmail.com>
 <49b58181-90da-4ee4-cbb0-80e226d040fc@infradead.org>
 <CAK8P3a1mwnDFeD3xnQ6bm1x8C6yX=YEccxN2jknvTbRiCfD=Bg@mail.gmail.com>
 <47f1889a-e919-e3fd-f90c-39c26cb1ccbb@gmail.com>
 <CAK8P3a0w3K1O23616g3Nz4XQdgw-xHDPWSQ+Rb_O3VAy-3FnQg@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <dd09f750-5001-d7e4-8ef7-15bfcb29ee10@infradead.org>
Date:   Fri, 14 Jun 2019 08:10:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0w3K1O23616g3Nz4XQdgw-xHDPWSQ+Rb_O3VAy-3FnQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 7:26 AM, Arnd Bergmann wrote:
> On Fri, Jun 14, 2019 at 4:07 PM David Ahern <dsahern@gmail.com> wrote:
>> On 6/14/19 8:01 AM, Arnd Bergmann wrote:
>>> On Wed, Jun 12, 2019 at 9:41 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>>>> On 6/11/19 5:08 PM, Matteo Croce wrote:
>>>
>>> It clearly shouldn't select PROC_SYSCTL, but I think it should not
>>> have a 'depends on' statement either. I think the correct fix for the
>>> original problem would have been something like
>>>
>>> --- a/net/mpls/af_mpls.c
>>> +++ b/net/mpls/af_mpls.c
>>> @@ -2659,6 +2659,9 @@ static int mpls_net_init(struct net *net)
>>>         net->mpls.ip_ttl_propagate = 1;
>>>         net->mpls.default_ttl = 255;
>>>
>>> +       if (!IS_ENABLED(CONFIG_PROC_SYSCTL))
>>> +               return 0;
>>> +
>>>         table = kmemdup(mpls_table, sizeof(mpls_table), GFP_KERNEL);
>>>         if (table == NULL)
>>>                 return -ENOMEM;
>>>
>>
>> Without sysctl, the entire mpls_router code is disabled. So if sysctl is
>> not enabled there is no point in building this file.
> 
> Ok, I see.
> 
> There are a couple of other drivers that use 'depends on SYSCTL',
> which may be the right thing to do here. In theory, one can still
> build a kernel with CONFIG_SYSCTRL_SYSCALL=y and no
> procfs.

Yes, that makes sense.

-- 
~Randy
