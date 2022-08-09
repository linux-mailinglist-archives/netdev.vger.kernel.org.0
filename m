Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91A958DD8E
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 19:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245532AbiHIR7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 13:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343902AbiHIR65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 13:58:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35217315
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 10:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660067933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=09PduL8Bxz81WATsNd44JrQ3EwyDrrI3zDl7S+d/+nU=;
        b=LlE3iROLxlwW/zX6ZD7jADUZUOpOFYjyars7ImwovVFwHdRnG2/6ww2AIEJsouuINEpkXw
        Swclr3yyi+4QGtvo2uhT0jCfzxxhWUYUXVrP6dqTRp/dYbTE7ZiVPbhhamYOd68mmIJ/a/
        Xw/GhvHzagBjawOaUcNur+wZ6DTnnq8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-WreljIGDO0-Js0dvj949TQ-1; Tue, 09 Aug 2022 13:58:52 -0400
X-MC-Unique: WreljIGDO0-Js0dvj949TQ-1
Received: by mail-qk1-f200.google.com with SMTP id l15-20020a05620a28cf00b006b46997c070so10873296qkp.20
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 10:58:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=09PduL8Bxz81WATsNd44JrQ3EwyDrrI3zDl7S+d/+nU=;
        b=gU1sSL0BNGlxpZx9hRZPGV06YiE89OOV9dmlL9W8kvYrf2rxDeWa9iMpw2fNvd7iZx
         ZmSmHueDEF4cEnVK0DsXbuGP8EUDTJXdrsVfrA8b1OnVafWSYWua/B107FZJuPIM8Mr5
         WEaLitYGOWr7UtrCVgXy5aLMUeIOeHyGCf4noIK1plmLkBr9jqSoOl1A4jWjuFHP4z3i
         y7iqx9+uAUrBqyIgHrVjz0u4JpSX5rA6nBcpC7+fSvp1uZF02zqh0/nvHfXkU6K/bzyu
         dm+qccxqlIizbHvXYMbnlfb+jJ6dlCxPyW+gjv8GLquRtWrtWUYQ1jDFPe3aAQzQItjw
         S7fw==
X-Gm-Message-State: ACgBeo17VBRgUWg13F2FJ4s9rlYPMLT0dqX5R65AbR7EEUlbauBRl50x
        tprKzQJS+68lkEu4Asy2AwjfDSDaCYL0tUGGPxSBfw2HbfM3tlsHAVTLqn1qfmEWmyWuWCxhUMC
        gYvvtQ4q1nSAGKswA
X-Received: by 2002:a05:6214:5098:b0:476:b536:3308 with SMTP id kk24-20020a056214509800b00476b5363308mr20615754qvb.81.1660067932210;
        Tue, 09 Aug 2022 10:58:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7oPyfJWfTABDCpAON4FDDHUZg1fgqWSPEtwElsZqbu+JeG21LUxNMaLpon4QMXifDE0JbcFw==
X-Received: by 2002:a05:6214:5098:b0:476:b536:3308 with SMTP id kk24-20020a056214509800b00476b5363308mr20615739qvb.81.1660067931874;
        Tue, 09 Aug 2022 10:58:51 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id a127-20020a379885000000b006af039ff090sm11607104qke.97.2022.08.09.10.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 10:58:51 -0700 (PDT)
Message-ID: <c51343e9-3b39-5874-b44c-c15c310cbde8@redhat.com>
Date:   Tue, 9 Aug 2022 13:58:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC net] bonding: 802.3ad: fix no transmission of LACPDUs
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <c2f698e6f73e6e78232ab4ded065c3828d245dbd.1660065706.git.jtoppins@redhat.com>
 <12990.1660066616@famine>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <12990.1660066616@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/22 13:36, Jay Vosburgh wrote:
> Jonathan Toppins <jtoppins@redhat.com> wrote:
> 
>> Running the script in
>> `tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh` puts
>> bonding into a state where it never transmits LACPDUs.
>>
>> line 53: echo 65535 > /sys/class/net/fbond/bonding/ad_actor_sys_prio
>> setting bond param: ad_actor_sys_prio
>> given:
>>     params.ad_actor_system = 0
>> call stack:
>>     bond_option_ad_actor_sys_prio()
>>     -> bond_3ad_update_ad_actor_settings()
>>        -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
>>        -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
>>             params.ad_actor_system == 0
>> results:
>>      ad.system.sys_mac_addr = bond->dev->dev_addr
>>
>> line 59: ip link set fbond address 52:54:00:3B:7C:A6
>> setting bond MAC addr
>> call stack:
>>     bond->dev->dev_addr = new_mac
>>
>> line 63: echo 65535 > /sys/class/net/fbond/bonding/ad_actor_sys_prio
>> setting bond param: ad_actor_sys_prio
>> given:
>>     params.ad_actor_system = 0
>> call stack:
>>     bond_option_ad_actor_sys_prio()
>>     -> bond_3ad_update_ad_actor_settings()
>>        -> set ad.system.sys_priority = bond->params.ad_actor_sys_prio
>>        -> ad.system.sys_mac_addr = bond->dev->dev_addr; because
>>             params.ad_actor_system == 0
>> results:
>>      ad.system.sys_mac_addr = bond->dev->dev_addr
>>
>> line 71: ip link set veth1-bond down master fbond
>> given:
>>     params.ad_actor_system = 0
>>     params.mode = BOND_MODE_8023AD
>>     ad.system.sys_mac_addr == bond->dev->dev_addr
>> call stack:
>>     bond_enslave
>>     -> bond_3ad_initialize(); because first slave
>>        -> if ad.system.sys_mac_addr != bond->dev->dev_addr
>>           return
>> results:
>>      Nothing is run in bond_3ad_initialize() because dev_add equals
>>      sys_mac_addr leaving the global ad_ticks_per_sec zero as it is
>>      never initialized anywhere else.
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>> ---
>> MAINTAINERS                                   |  1 +
>> drivers/net/bonding/bond_3ad.c                |  2 +-
>> .../net/bonding/bond-break-lacpdu-tx.sh       | 88 +++++++++++++++++++
>> 3 files changed, 90 insertions(+), 1 deletion(-)
>> create mode 100644 tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 386178699ae7..6e7cebc1bca3 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3636,6 +3636,7 @@ F:	Documentation/networking/bonding.rst
>> F:	drivers/net/bonding/
>> F:	include/net/bond*
>> F:	include/uapi/linux/if_bonding.h
>> +F:	tools/testing/selftests/net/bonding/
>>
>> BOSCH SENSORTEC BMA400 ACCELEROMETER IIO DRIVER
>> M:	Dan Robertson <dan@dlrobertson.com>
>> diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
>> index d7fb33c078e8..e357bc6b8e05 100644
>> --- a/drivers/net/bonding/bond_3ad.c
>> +++ b/drivers/net/bonding/bond_3ad.c
>> @@ -84,7 +84,7 @@ enum ad_link_speed_type {
>> static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned = {
>> 	0, 0, 0, 0, 0, 0
>> };
>> -static u16 ad_ticks_per_sec;
>> +static u16 ad_ticks_per_sec = 1000/AD_TIMER_INTERVAL;
> 
> 	How does this resolve the problem?  Does bond_3ad_initialize
> actually run, or is this change sort of jump-starting things?

It is jump-starting things. Really bond_3ad_initialize() should be 
fixed, but it seemed this change would be easier from a backporting 
perspective. The real issue seems to be bond_3ad_initialize() checks to 
make sure the "bond is not initialized yet" and if this check fails no 
initialization is done, which seems incorrect. Some minimal amount of 
initialization it seems needs to be done.

This is also an order of execution bug, as I tried to layout in the 
commit message. Basically setting fbond's MAC and then resetting the 
option ad_actor_sys_prio causes the if check in bond_3ad_initialize() to 
not execute anything. We first saw this when using NetworkManager as for 
some reason NetworkManager was setting options twice, this is being 
looked at as well.

I am open to other possible fixes, I just chose the one that appeared to 
be the easiest to backport, hence the RFC.

> 
>> static const int ad_delta_in_ticks = (AD_TIMER_INTERVAL * HZ) / 1000;
>>
>> static const u8 lacpdu_mcast_addr[ETH_ALEN + 2] __long_aligned =
>> diff --git a/tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh b/tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh
>> new file mode 100644
>> index 000000000000..be9f1b64e89e
>> --- /dev/null
>> +++ b/tools/testing/selftests/net/bonding/bond-break-lacpdu-tx.sh
>> @@ -0,0 +1,88 @@
>> +#!/bin/sh
>> +
>> +# Regression Test:
>> +#   Verify LACPDUs get transmitted after setting the MAC address of
>> +#   the bond.
>> +#
>> +# https://bugzilla.redhat.com/show_bug.cgi?id=2020773
>> +#
>> +#       +---------+
>> +#       | fab-br0 |
>> +#       +---------+
>> +#            |
>> +#       +---------+
>> +#       |  fbond  |
>> +#       +---------+
>> +#        |       |
>> +#    +------+ +------+
>> +#    |veth1 | |veth2 |
>> +#    +------+ +------+
>> +#
>> +# We use veths instead of physical interfaces
>> +
>> +set -e
>> +#set -x
>> +tmp=$(mktemp -q dump.XXXXXX)
>> +cleanup() {
>> +	ip link del fab-br0 >/dev/null 2>&1 || :
>> +	ip link del fbond  >/dev/null 2>&1 || :
>> +	ip link del veth1-bond  >/dev/null 2>&1 || :
>> +	ip link del veth2-bond  >/dev/null 2>&1 || :
>> +	modprobe -r bonding  >/dev/null 2>&1 || :
>> +	rm -f -- ${tmp}
>> +}
>> +
>> +trap cleanup 0 1 2
>> +cleanup
>> +sleep 1
>> +
>> +# create the bridge
>> +ip link add fab-br0 address 52:54:00:3B:7C:A6 mtu 1500 type bridge \
>> +	forward_delay 15
>> +
>> +# create the bond
>> +ip link add fbond type bond
>> +ip link set fbond up
>> +
>> +# set bond sysfs parameters
>> +ip link set fbond down
>> +echo 802.3ad           > /sys/class/net/fbond/bonding/mode
>> +echo 200               > /sys/class/net/fbond/bonding/miimon
>> +echo 1                 > /sys/class/net/fbond/bonding/xmit_hash_policy
>> +echo 65535             > /sys/class/net/fbond/bonding/ad_actor_sys_prio
>> +echo stable            > /sys/class/net/fbond/bonding/ad_select
>> +echo slow              > /sys/class/net/fbond/bonding/lacp_rate
>> +echo any               > /sys/class/net/fbond/bonding/arp_all_targets
> 
> 	Having a test case is very nice; would it be possible to avoid
> using sysfs, though?  I believe all of these parameters are available
> via /sbin/ip.

I can convert the test case to `ip link`, it doesn't appear the method 
of configuration would cause a difference in the result.

> 
> 	Also, is setting "arp_all_targets" necessary for the test?

Its probably not, I probably do not need to configure most of these 
options because most are default values. I can work on trimming it down 
even more.

> 
> 	-J
> 
>> +
>> +# set bond address
>> +ip link set fbond address 52:54:00:3B:7C:A6
>> +ip link set fbond up
>> +
>> +# set again bond sysfs parameters
>> +echo 65535             > /sys/class/net/fbond/bonding/ad_actor_sys_prio
>> +
>> +# create veths
>> +ip link add name veth1-bond type veth peer name veth1-end
>> +ip link add name veth2-bond type veth peer name veth2-end
>> +
>> +# add ports
>> +ip link set fbond master fab-br0
>> +ip link set veth1-bond down master fbond
>> +ip link set veth2-bond down master fbond
>> +
>> +# bring up
>> +ip link set veth1-end up
>> +ip link set veth2-end up
>> +ip link set fab-br0 up
>> +ip link set fbond up
>> +ip addr add dev fab-br0 10.0.0.3
>> +
>> +tcpdump -n -i veth1-end -e ether proto 0x8809 >${tmp} 2>&1 &
>> +sleep 60
>> +pkill tcpdump >/dev/null 2>&1
>> +num=$(grep "packets captured" ${tmp} | awk '{print $1}')
>> +if test "$num" -gt 0; then
>> +	echo "PASS, captured ${num}"
>> +else
>> +	echo "FAIL"
>> +fi
>> -- 
>> 2.31.1
>>
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
> 

