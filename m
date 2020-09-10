Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13440263D15
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 08:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIJGRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 02:17:06 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8640 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgIJGRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:17:04 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f59c4b40000>; Wed, 09 Sep 2020 23:16:20 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 09 Sep 2020 23:17:04 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 09 Sep 2020 23:17:04 -0700
Received: from [172.27.13.224] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 10 Sep
 2020 06:16:49 +0000
Subject: Re: [PATCH net-next RFC v1 2/4] devlink: Add devlink traps under
 devlink_ports context
To:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>
CC:     Aya Levin <ayal@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>
References: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
 <1599060734-26617-3-git-send-email-ayal@mellanox.com>
 <20200906154428.GA2431016@shredder> <20200908140409.GN2997@nanopsycho.orion>
From:   Aya Levin <ayal@nvidia.com>
Message-ID: <6aeba5b9-201f-2abc-05fb-0efdd6394b65@nvidia.com>
Date:   Thu, 10 Sep 2020 09:16:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908140409.GN2997@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599718580; bh=YxbgwqDeiWqJCCQqAzriGr+eKT1ynNKp9QHvOJFUUps=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=cHgbb3LpBxfAtWg6QGLgvHvTpTbu6kf4CDNqo1s9OqQ/7bT5cHFRH1us26xGx4Q9i
         tdh1Ai1OG0LsiJywouRtnFkKnDA8ShusF1fGWlLoOLNkOA+X6R7rzyJN5h15GBNugq
         iSWet/F5SkSN3R9hAGthHNEXdgyloV/6AbU13nD+kTS3KEAK2hdjS1w0Gkoy//ljXY
         3rLYbWhcBwOVn3uYZ0D6A1Tzoe7JGElRilEJvzljDLxjHxjHDm9IPUeiR6lZxUl1jW
         YFp7QMsW7xAHOC0LdCFIG18TAmPx4t5HAfEQDS/NCxz58F5F3/YzoSbPWWyjyC9llo
         6YiddSEs/hYDA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/2020 5:04 PM, Jiri Pirko wrote:
> Sun, Sep 06, 2020 at 05:44:28PM CEST, idosch@idosch.org wrote:
>> On Wed, Sep 02, 2020 at 06:32:12PM +0300, Aya Levin wrote:
> 
> [...]
> 
>>
>> I understand how this struct allows you to re-use a lot of code between
>> per-device and per-port traps, but it's mainly enabled by the fact that
>> you use the same netlink commands for both per-device and per-port
>> traps. Is this OK?
>>
>> I see this is already done for health reporters, but it's inconsistent
>> with the devlink-param API:
>>
>> DEVLINK_CMD_PARAM_GET
>> DEVLINK_CMD_PARAM_SET
>> DEVLINK_CMD_PARAM_NEW
>> DEVLINK_CMD_PARAM_DEL
>>
>> DEVLINK_CMD_PORT_PARAM_GET
>> DEVLINK_CMD_PORT_PARAM_SET
>> DEVLINK_CMD_PORT_PARAM_NEW
>> DEVLINK_CMD_PORT_PARAM_DEL
>>
>> And also with the general device/port commands:
>>
>> DEVLINK_CMD_GET
>> DEVLINK_CMD_SET
>> DEVLINK_CMD_NEW
>> DEVLINK_CMD_DEL
>>
>> DEVLINK_CMD_PORT_GET
>> DEVLINK_CMD_PORT_SET
>> DEVLINK_CMD_PORT_NEW
>> DEVLINK_CMD_PORT_DEL
>>
>> Wouldn't it be cleaner to add new commands?
>>
>> DEVLINK_CMD_PORT_TRAP_GET
>> DEVLINK_CMD_PORT_TRAP_SET
>> DEVLINK_CMD_PORT_TRAP_NEW
>> DEVLINK_CMD_PORT_TRAP_DEL
>>
>> I think the health API is the exception in this case and therefore might
>> not be the best thing to mimic. IIUC, existing per-port health reporters
>> were exposed as per-device and later moved to be exposed as per-port
>> [1]:
>>
>> "This patchset comes to fix a design issue as some health reporters
>> report on errors and run recovery on device level while the actual
>> functionality is on port level. As for the current implemented devlink
>> health reporters it is relevant only to Tx and Rx reporters of mlx5,
>> which has only one port, so no real effect on functionality, but this
>> should be fixed before more drivers will use devlink health reporters."
> 
> Yeah, this slipped trough my fingers unfortunatelly :/ But with
> introduction of per-port health reporters, we could introduce new
> commands, that would be no problem. Pity :/
> 
> 
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ac4cd4781eacd1fd185c85522e869bd5d3254b96
>>
>> Since we still don't have per-port traps, we can design it better from
>> the start.
> 
> I agree. Let's have a separate commands for per-port.
Thanks for your input
I'm preparing V2
> 
> 
> [...]
> 
