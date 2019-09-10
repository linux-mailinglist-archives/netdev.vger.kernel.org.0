Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73C8AE66A
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 11:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfIJJOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 05:14:21 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:46114 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfIJJOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 05:14:21 -0400
Received: from tux.wizards.de (pD9EBF359.dip0.t-ipconnect.de [217.235.243.89])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 27A7B416C9C4;
        Tue, 10 Sep 2019 11:14:20 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id CF4A7F015AB;
        Tue, 10 Sep 2019 11:14:19 +0200 (CEST)
Subject: Re: Default qdisc not correctly initialized with custom MTU
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
References: <211c7151-7500-f895-7fd7-2c868dd48579@applied-asynchrony.com>
 <CAM_iQpWKsSWDZ55kMO6mzDe5C7tHW-ub_eH91hRzZMdUtKJtfA@mail.gmail.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <dbc359d3-5cac-9b2e-6520-df4a25964bd3@applied-asynchrony.com>
Date:   Tue, 10 Sep 2019 11:14:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWKsSWDZ55kMO6mzDe5C7tHW-ub_eH91hRzZMdUtKJtfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/10/19 12:52 AM, Cong Wang wrote:
> On Mon, Sep 9, 2019 at 5:44 AM Holger Hoffstätte
> <holger@applied-asynchrony.com> wrote:
>> I can't help but feel this is a slight bug in terms of initialization order,
>> and that the default qdisc should only be created when it's first being
>> used/attached to a link, not when the sysctls are configured.
> 
> Yeah, this is because the fq_codel qdisc is initialized once and
> doesn't get any notification when the netdev's MTU get changed.

My point was that it shouldn't be created or initialized at all when
the sysctl is configured, only the name should be validated/stored and
queried when needed. If any interface is brought up before that point,
no value (yet) would just mean "trod along with the defaults" to whoever
is doing the work.

> We can "fix" this by adding a NETDEV_CHANGEMTU notifier to
> qdisc's, but I don't know if it is really worth the effort.

This is essentially the opposite of what I had in mind. The problem is
that the entity was created, not that it needs to be notified.
Also I don't think that would work for scenarios with multiple links
using different MTUs.

> Is there any reason you can't change that order?

Yes, because that wouldn't solve anything?
Like i said I can just kick the root qdisc to update itself in
a post interface-setup script, and that works fine. Since I need
that script anyway for setting several other parameters for
the device it's no big deal - just another workaround.

A brief look at the initialization in sch_mq/sch_generic unfortunately
didn't really help clear things up for me, hence I guess my real
question is whether a qdisc *must* be created early for some reason
(assuming sysctls come before link setup), or whether this is something
that could be delayed and done on-demand.

thanks,
Holger
