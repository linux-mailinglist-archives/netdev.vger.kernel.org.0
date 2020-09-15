Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78E126A5B5
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 14:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgIOM6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 08:58:43 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7251 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIOM5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 08:57:51 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f60b9ec0002>; Tue, 15 Sep 2020 05:56:12 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 05:57:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 15 Sep 2020 05:57:00 -0700
Received: from [10.21.180.184] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 12:56:52 +0000
Subject: Re: [PATCH net-next RFC v4 01/15] devlink: Add reload action option
 to devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-2-git-send-email-moshe@mellanox.com>
 <20200914143306.4ab0f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <777fd1b8-1262-160e-a711-31e5f6e2c37c@nvidia.com>
Date:   Tue, 15 Sep 2020 15:56:48 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200914143306.4ab0f4c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600174572; bh=VctqagkNcjbrJLAhRhltgpx4bJ300HnnZqxTdWkgOJs=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=JS+uzVGM+ALC/jHztpWxpR/WL7rspeb6ynvYifZCXUTwoUCDHQhdBRpn7brmu3aH1
         MErIiLLtyxD+e3c2xskPc/LZ1txm6ktScbXutrqbklFsGkxmcWhcSOZKwjx26qnOS8
         1GkhLDO34XcKsI++BjT35uk1rlIowpW8TA8FS30fOTFGZ7HDHy32INI9OmiVW3lWVN
         1mRpPX1jVpWAgq+G27I3slsziD7fetJc3Zo0U1e+z+xpoi+b67raUgJARLD2FgNA7+
         NZGpMmh7IK2GfhTdxYcPDX8rwFQ1tGbSbsfaNmKwqbRjNuE5xD13ddqBlzWVmLNYVL
         4C39NmWEpFv1w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/15/2020 12:33 AM, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Mon, 14 Sep 2020 09:07:48 +0300 Moshe Shemesh wrote:
>> @@ -3011,12 +3060,41 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>>                        return PTR_ERR(dest_net);
>>        }
>>
>> -     err = devlink_reload(devlink, dest_net, info->extack);
>> +     if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
>> +             action = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
>> +     else
>> +             action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
>> +
>> +     if (action == DEVLINK_RELOAD_ACTION_UNSPEC || action > DEVLINK_RELOAD_ACTION_MAX) {
>> +             NL_SET_ERR_MSG_MOD(info->extack, "Invalid reload action");
>> +             return -EINVAL;
>> +     } else if (!devlink_reload_action_is_supported(devlink, action)) {
>> +             NL_SET_ERR_MSG_MOD(info->extack, "Requested reload action is not supported");
>> +             return -EOPNOTSUPP;
>> +     }
>> +
>> +     err = devlink_reload(devlink, dest_net, action, info->extack, &actions_performed);
>>
>>        if (dest_net)
>>                put_net(dest_net);
>>
>> -     return err;
>> +     if (err)
>> +             return err;
>> +
>> +     WARN_ON(!actions_performed);
>> +     msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +     if (!msg)
>> +             return -ENOMEM;
>> +
>> +     err = devlink_nl_reload_actions_performed_fill(msg, devlink, actions_performed,
>> +                                                    DEVLINK_CMD_RELOAD, info->snd_portid,
>> +                                                    info->snd_seq, 0);
>> +     if (err) {
>> +             nlmsg_free(msg);
>> +             return err;
>> +     }
>> +
>> +     return genlmsg_reply(msg, info);
> I think generating the reply may break existing users. Only generate
> the reply if request contained DEVLINK_ATTR_RELOAD_ACTION (or any other
> new attribute which existing users can't pass).


OK, I can do that. But I update stats and generate devlink notification 
anyway, that should fine, right ?

