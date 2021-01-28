Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EE4306AEF
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhA1CNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:13:04 -0500
Received: from novek.ru ([213.148.174.62]:45700 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229569AbhA1CND (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 21:13:03 -0500
Received: from [172.23.108.4] (unknown [88.151.187.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 04062500472;
        Thu, 28 Jan 2021 05:13:35 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 04062500472
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1611800017; bh=srbIJEcnPkE+WNttQaQEC79yNHWefbohWspktG1+KEk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VjpJ8Nykv73jHf1cgzHpK2gmwgPQ0vIWz2Wh1IDm18IhaJCteRtqWHQym10sWVYHb
         oMwRc9rXlujQ4li6VGG/jE6EaaaWCDw1nMZPk5qgOutL3wXnmPCVz2ja994F3fEakM
         9JY4eQGKUZFOaF0yrlG1HEYBxr/y+tcHPiq+LfCg=
Subject: Re: BUG: Incorrect MTU on GRE device if remote is unspecified
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Slava Bacherikov <mail@slava.cc>,
        Willem de Bruijn <willemb@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Xie He <xie.he.0141@gmail.com>
References: <e2dde066-44b2-6bb3-a359-6c99b0a812ea@slava.cc>
 <20210127165602.610b10c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpUe+UAQ_G8mGJ_R-nupSfVpH3ykaqtNn3WXY+kCKN-u7A@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <86788b50-90eb-12e6-4038-7f48cccfb129@novek.ru>
Date:   Thu, 28 Jan 2021 02:12:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUe+UAQ_G8mGJ_R-nupSfVpH3ykaqtNn3WXY+kCKN-u7A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.01.2021 01:38, Cong Wang wrote:
> On Wed, Jan 27, 2021 at 4:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Mon, 25 Jan 2021 22:10:10 +0200 Slava Bacherikov wrote:
>>> Hi, I'd like to report a regression. Currently, if you create GRE
>>> interface on the latest stable or LTS kernel (5.4 branch) with
>>> unspecified remote destination it's MTU will be adjusted for header size
>>> twice. For example:
>>>
>>> $ ip link add name test type gre local 127.0.0.32
>>> $ ip link show test | grep mtu
>>> 27: test@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group
>>> default qlen 1000
>>>
>>> or with FOU
>>>
>>> $ ip link add name test2   type gre local 127.0.0.32 encap fou
>>> encap-sport auto encap-dport 6666
>>> $ ip link show test2 | grep mtu
>>> 28: test2@NONE: <NOARP> mtu 1436 qdisc noop state DOWN mode DEFAULT
>>> group default qlen 1000
>>>
>>> The same happens with GUE too (MTU is 1428 instead of 1464).
>>> As you can see that MTU in first case is 1452 (1500 - 24 - 24) and with
>>> FOU it's 1436 (1500 - 32 - 32), GUE 1428 (1500 - 36 - 36). If remote
>>> address is specified MTU is correct.
>>>
>>> This regression caused by fdafed459998e2be0e877e6189b24cb7a0183224 commit.
>>
>> Cong is this one on your radar?
> 
> Yeah, I guess ipgre_link_update() somehow gets called twice,
> but I will need to look into it.
> 
> Thanks.
> 

Hi!
The problem is in ip_tunnel_bind_dev() where mtu is set for tunnel device.

   	if (tdev) {
		hlen = tdev->hard_header_len + tdev->needed_headroom;
		mtu = min(tdev->mtu, IP_MAX_MTU);
	}

	dev->needed_headroom = t_hlen + hlen;
	mtu -= (dev->hard_header_len + t_hlen);

ipgre_tunnel_init sets hard_header_len to tunnel->hlen + sizeof(*iph) and
ip_tunnel_bind_dev adds header overhead once again.

I'll post a patch a bit later but I need someone with extended tests.

Thanks
