Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5730B1BADE
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbfEMQTb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 May 2019 12:19:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39358 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728639AbfEMQTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:19:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EDBBE14E226ED;
        Mon, 13 May 2019 09:19:30 -0700 (PDT)
Date:   Mon, 13 May 2019 09:19:30 -0700 (PDT)
Message-Id: <20190513.091930.1863448800331209213.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     sd@queasysnail.net, netdev@vger.kernel.org, danw@redhat.com
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with
 a link-netnsid
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b89367f0-18d5-61b2-2572-b1e5b4588d8d@6wind.com>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
        <b89367f0-18d5-61b2-2572-b1e5b4588d8d@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:19:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Mon, 13 May 2019 16:50:51 +0200

> Le 13/05/2019 à 15:47, Sabrina Dubroca a écrit :
>> Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
>> iflink == ifindex.
>> 
>> In some cases, a device can be created in a different netns with the
>> same ifindex as its parent. That device will not dump its IFLA_LINK
>> attribute, which can confuse some userspace software that expects it.
>> For example, if the last ifindex created in init_net and foo are both
>> 8, these commands will trigger the issue:
>> 
>>     ip link add parent type dummy                   # ifindex 9
>>     ip link add link parent netns foo type macvlan  # ifindex 9 in ns foo
>> 
>> So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
>> always put the IFLA_LINK attribute as well.
>> 
>> Thanks to Dan Winship for analyzing the original OpenShift bug down to
>> the missing netlink attribute.
>> 
>> Analyzed-by: Dan Winship <danw@redhat.com>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> I would say:
> Fixes: 5e6700b3bf98 ("sit: add support of x-netns")
> 
> Because before this patch, there was no device with an iflink that can be put in
> another netns.

I kind of agree.

What's important for people is knowing at what point they need to backport a
fix in order to actually fix a real problem.

Sabrina, please adjust the Fixes tag, thank you.
