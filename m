Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6214A25D0CA
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 07:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgIDFD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 01:03:28 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11924 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgIDFDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 01:03:22 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f51ca8c0000>; Thu, 03 Sep 2020 22:03:08 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 03 Sep 2020 22:03:22 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 03 Sep 2020 22:03:22 -0700
Received: from [10.21.180.64] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Sep
 2020 05:03:13 +0000
Subject: Re: [PATCH net-next RFC v3 02/14] devlink: Add reload actions
 counters
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
 <1598801254-27764-3-git-send-email-moshe@mellanox.com>
 <20200831104827.GB3794@nanopsycho.orion>
 <1fa33c3c-57b8-fe38-52d6-f50a586a8d3f@nvidia.com>
 <20200901170127.7bf0d045@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <ea262edd-96e1-6b15-5a7a-80867b42c175@nvidia.com>
Date:   Fri, 4 Sep 2020 08:03:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200901170127.7bf0d045@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599195788; bh=qKDcv2oHASmKOtICKUlIuZGw+N8YcHxYlJdxGiuRcHM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=SyxcfG5/uG671ylO5Ecbe38XP+PTE+7vS2hZ3Q5AktfpkNIv938L39U3ujI3fiW02
         AZmQiwqvt7bzaa704dteqqs9+6ZqKtpc7B+ejbUtj93dMOJ3f4sH5KZorUJCK1wwcU
         ppe8OOMVkw4mqv7OgqZOT70UwhJj2hVRuD5u+NMVy/u8ZRdUb4W9KPlJ3YkrIFm0aT
         NcgT8wml0ny7yX9SKnFIypAgQ02W5+685KbLDqlHEvk6vF5bO5tSIk8epzZ/z1ItWG
         MjqlBbWssZLTX8p74/e8lTmRrGjarB5ewxl6sz306QFYXlqgnjtZulhCQ3AlaZ8f90
         P68fvQDYJ+9FA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/2/2020 3:01 AM, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Tue, 1 Sep 2020 22:05:36 +0300 Moshe Shemesh wrote:
>>>> +void devlink_reload_actions_cnts_update(struct devlink *devlink, unsigned long actions_done)
>>>> +{
>>>> +  int action;
>>>> +
>>>> +  for (action = 0; action < DEVLINK_RELOAD_ACTION_MAX; action++) {
>>>> +          if (!test_bit(action, &actions_done))
>>>> +                  continue;
>>>> +          devlink->reload_actions_cnts[action]++;
>>>> +  }
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(devlink_reload_actions_cnts_update);
>>> I don't follow why this is an exported symbol if you only use it from
>>> this .c. Looks like a leftover...
>>>
>> Not leftover, in the commit message I notified and explained why I
>> exposed it.
> We should generate devlink notifications on this event (down and up)
> so the counters don't have to be exposed to drivers. We need a more
> thorough API.


I will add devlink notifications for the counters, but what I meant here 
is to have counters data updated also on hosts that are having reset but 
didn't trigger the fw_activate action by themselves, so such host's 
devlink is not aware of it. I mean fw_activate action was triggered on 
another's host devlink sharing the same device/firmware.

Maybe I should have named this function 
devlink_reload_implicit_actions_performed().

