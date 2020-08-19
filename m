Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64E8249DA5
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 14:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgHSMSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 08:18:39 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3498 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbgHSMSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 08:18:36 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3d188e0000>; Wed, 19 Aug 2020 05:18:22 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 19 Aug 2020 05:18:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 19 Aug 2020 05:18:36 -0700
Received: from [10.21.180.203] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Aug
 2020 12:18:26 +0000
Subject: Re: [PATCH net-next RFC v2 01/13] devlink: Add reload action option
 to devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
 <1597657072-3130-2-git-send-email-moshe@mellanox.com>
 <20200817163612.GA2627@nanopsycho>
 <3ed1115e-8b44-b398-55f2-cee94ef426fd@nvidia.com>
 <20200818171010.11e4b615@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <cd0e3d7e-4746-d26d-dd0c-eb36c9c8a10f@nvidia.com>
Date:   Wed, 19 Aug 2020 15:18:22 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200818171010.11e4b615@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597839502; bh=qyxddY+ZMpyr1B0Q/HCmtCniMU+Ksoc1x35q4ykLbCk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=Ev/qRgG4hxTkvQbhMeF94aTFAm2rglurkWPF6kUqHYiT/0Ta1jRKU00wbi9uqUgeN
         E/xCYfq8FsMGb3BFRGiOeuhfD0oQJIoRLT2MIpAgc/p8r4tc+JkD/coSHCjUUFYYWy
         bSazyWxxsKKRXpfroBFCAHKyi24o3PnZFYR4yGgf/PL1g+3NSpOqqHL4JQdfQMx8kc
         tdGYRK3Qu26fgqJ+e9jBV9LsV2YA5H2tUovFT2Slqe7f0nrC6YAUUOU0/IG3MEzDpm
         77xAS/16o+UuGjrckSgvDYdHmi30lqX08z9aZNm0vDSsa2RH1jj8+dzhTv/D6q6ODi
         qaa91E/wleScQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/19/2020 3:10 AM, Jakub Kicinski wrote:
>
> On Tue, 18 Aug 2020 12:10:36 +0300 Moshe Shemesh wrote:
>> On 8/17/2020 7:36 PM, Jiri Pirko wrote:
>>> Mon, Aug 17, 2020 at 11:37:40AM CEST, moshe@mellanox.com wrote:
>>>> Add devlink reload action to allow the user to request a specific reload
>>>> action. The action parameter is optional, if not specified then devlink
>>>> driver re-init action is used (backward compatible).
>>>> Note that when required to do firmware activation some drivers may need
>>>> to reload the driver. On the other hand some drivers may need to reset
>>> Sounds reasonable. I think it would be good to indicate that though. Not
>>> sure how...
>> Maybe counters on the actions done ? Actually such counters can be
>> useful on debug, knowing what reloads we had since driver was up.
> Wouldn't we need to know all types of reset of drivers may do?


Right, we can't tell all reset types driver may have, but we can tell 
which reload actions were done.

> I think documenting this clearly should be sufficient.
>
> A reset counter for the _requested_ reset type (fully maintained by
> core), however - that may be useful. The question "why did this NIC
> reset itself / why did the link just flap" comes up repeatedly.


I will add counters on which reload were done. reload_down()/up() can 
return which actions were actually done and devlink will show counters.

