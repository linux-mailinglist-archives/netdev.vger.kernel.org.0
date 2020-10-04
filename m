Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B17828293C
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 08:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgJDGqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 02:46:00 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2257 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgJDGp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 02:45:59 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f796f3d0001>; Sat, 03 Oct 2020 23:44:13 -0700
Received: from [10.21.180.76] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 4 Oct
 2020 06:45:47 +0000
Subject: Re: [PATCH net-next 02/16] devlink: Add reload action option to
 devlink reload command
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-3-git-send-email-moshe@mellanox.com>
 <20201003075209.GD3159@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <1992fb83-5b77-41c3-1498-626c6aa5333b@nvidia.com>
Date:   Sun, 4 Oct 2020 09:45:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201003075209.GD3159@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601793853; bh=34T1XSNeRu3FYi1Ic2D1fb3NimeI7zrwJTXhd0kkoko=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=IsWc0KHEMcaYZ9w44A5UiojOkSC8OFgdHkSJ40UikyjXMTt57h5KxJeH1CVqNtn2G
         e8k7sYN1qwmqXbJfgl+Q65ziwOBAnsRqZJuMF/PVvMVOL/kUgd8m+b+tZUVI6KKt0q
         d7/X3L5POpF9jG7oSOPUbAtX/BIl46+eb9FM6EPC3whsEAtcdDZ5U/FSIVvwWV49LS
         FyVTxq5HLABGhDtiVF4695fgrBy/kTUs8Gjl127Av14UfVEq4+MFlsIO+mksYPYoJN
         5/UD3SaUSnzpZXoxRL2rIEreDVLQj3FA9tj9JeeSzKqJzuOpllUQ5U/AOOMr2z7huz
         csIfdJcVmRfLg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/3/2020 10:52 AM, Jiri Pirko wrote:
> Thu, Oct 01, 2020 at 03:59:05PM CEST, moshe@mellanox.com wrote:
>
> [...]
>
>> +static int
>> +devlink_nl_reload_actions_performed_snd(struct devlink *devlink,
>> +					unsigned long actions_performed,
>> +					enum devlink_command cmd, struct genl_info *info)
>> +{
>> +	struct sk_buff *msg;
>> +	void *hdr;
>> +
>> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +	if (!msg)
>> +		return -ENOMEM;
>> +
>> +	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq, &devlink_nl_family, 0, cmd);
>> +	if (!hdr)
>> +		goto free_msg;
>> +
>> +	if (devlink_nl_put_handle(msg, devlink))
>> +		goto nla_put_failure;
>> +
>> +	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED, actions_performed,
> This should be NLA_BITFIELD, I believe. We use it for other bitfields
> too.
>

OK, I see it now, NLA_BITFIELD32.

>> +			      DEVLINK_ATTR_PAD))
> [...]
