Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58ECB26A53C
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 14:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgIOMdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 08:33:11 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1710 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIOMcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 08:32:07 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f60b3ad0001>; Tue, 15 Sep 2020 05:29:33 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 05:31:54 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 15 Sep 2020 05:31:54 -0700
Received: from [10.21.180.139] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 12:31:42 +0000
Subject: Re: [PATCH net-next RFC v4 04/15] devlink: Add reload actions stats
 to dev get
To:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>
CC:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-5-git-send-email-moshe@mellanox.com>
 <20200914134500.GH2236@nanopsycho.orion> <20200915064519.GA5390@shredder>
 <20200915074402.GM2236@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <0d6cb0da-761b-b122-f5b1-b82320cfd5c4@nvidia.com>
Date:   Tue, 15 Sep 2020 15:31:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200915074402.GM2236@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600172973; bh=6GnH+s+wPmmcwLshKereQrHcEjLsmpWekoc/3TO4SNo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=ONfXMAOMdYwSN8Wq7w6h3+GpdyH67OeBZOBmIHW8x4No9yx9wJgRuIVkM6+k7jPIJ
         SWOgXVeyXAz5f/2vWkk8wDjoPIyyA5L1PphlZE3S/s5SilrIvDyTiORltKyOii8K4O
         cqxCYc0lalqlU+NAKWRiH6d+w/0jKBDlj94AsJ/B1w1pUtWAcxvKpCmoiPa22973Lx
         teYHDrdx8UttJzzlP6QwhLxy/26jYLMiUn7oPb4UlTjnBZeNrIGBPLLP8hgScFdTH+
         H74vBkPJ0xltUs1NikLgnl4EEez6oBKyzTAtMl7A/Jym3kici+aVxqvKc32Z+JzQdA
         LLveMlUOwgngA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/15/2020 10:44 AM, Jiri Pirko wrote:
> Tue, Sep 15, 2020 at 08:45:19AM CEST, idosch@idosch.org wrote:
>> On Mon, Sep 14, 2020 at 03:45:00PM +0200, Jiri Pirko wrote:
>>> Mon, Sep 14, 2020 at 08:07:51AM CEST, moshe@mellanox.com wrote:
>>>> Expose devlink reload actions stats to the user through devlink dev
>>>> get command.
>>>>
>>>> Examples:
>>>> $ devlink dev show
>>>> pci/0000:82:00.0:
>>>>   reload_action_stats:
>>>>     driver_reinit 2
>>>>     fw_activate 1
>>>>     driver_reinit_no_reset 0
>>>>     fw_activate_no_reset 0
>>>> pci/0000:82:00.1:
>>>>   reload_action_stats:
>>>>     driver_reinit 1
>>>>     fw_activate 1
>>>>     driver_reinit_no_reset 0
>>>>     fw_activate_no_reset 0
>>> I would rather have something like:
>>>     stats:
>>>       reload_action:
>>>         driver_reinit 1
>>>         fw_activate 1
>>>         driver_reinit_no_reset 0
>>>         fw_activate_no_reset 0
>>>
>>> Then we can easily extend and add other stats in the tree.


Sure, I will add it.

>>>
>>> Also, I wonder if these stats could be somehow merged with Ido's metrics
>>> work:
>>> https://github.com/idosch/linux/commits/submit/devlink_metric_rfc_v1
>>>
>>> Ido, would it make sense?
>> I guess. My original idea for devlink-metric was to expose
>> design-specific metrics to user space where the entity registering the
>> metrics is the device driver. In this case the entity would be devlink
>> itself and it would be auto-registered for each device.
> Yeah, the usecase is different, but it is still stats, right.
>
>
>>>
>>>> $ devlink dev show -jp
>>>> {
>>>>     "dev": {
>>>>         "pci/0000:82:00.0": {
>>>>             "reload_action_stats": [ {
>>>>                     "driver_reinit": 2
>>>>                 },{
>>>>                     "fw_activate": 1
>>>>                 },{
>>>>                     "driver_reinit_no_reset": 0
>>>>                 },{
>>>>                     "fw_activate_no_reset": 0
>>>>                 } ]
>>>>         },
>>>>         "pci/0000:82:00.1": {
>>>>             "reload_action_stats": [ {
>>>>                     "driver_reinit": 1
>>>>                 },{
>>>>                     "fw_activate": 1
>>>>                 },{
>>>>                     "driver_reinit_no_reset": 0
>>>>                 },{
>>>>                     "fw_activate_no_reset": 0
>>>>                 } ]
>>>>         }
>>>>     }
>>>> }
>>>>
>>> [..]
