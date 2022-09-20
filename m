Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C151A5BD8BB
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 02:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiITAVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 20:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiITAVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 20:21:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5245247F
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 17:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663633291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kBetV1101hfdFvC0CO1umfBPx9zMW1qE7FXiLHYebTU=;
        b=CvKX3DQuhshvUGVVOmyXuIoUp3GQRIK3h5YhBLQpbHoWMdERS5/Jxv7OIQIkU7HCki0q5W
        itsRPh6z1W9FIkgmm+vD7SjsW8zSYyIUiN7rNxxycpYDcsktx20gHBfYeA2oqYYCCO/9uf
        HV4+KXCvZxeskd1KGK1AscCBzQkg9IA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-574-mk61iPZHPQ-GobOnCqH9lg-1; Mon, 19 Sep 2022 20:21:30 -0400
X-MC-Unique: mk61iPZHPQ-GobOnCqH9lg-1
Received: by mail-qt1-f199.google.com with SMTP id fz10-20020a05622a5a8a00b0035ce18717daso672625qtb.11
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 17:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=kBetV1101hfdFvC0CO1umfBPx9zMW1qE7FXiLHYebTU=;
        b=5JpgTU6rtp2OsHyWpmqLy9MLqHZrjGxbkl/Fp3+n0FBAxS2u8Z45yJfWb3M1q7YW6t
         VPMQLOeBeKPvGdTVl6laq1mT4wLLQ17LEaiYhZwaNqlP8kdsk7Jm6T7rJMZ1sXWUAEpS
         r8tzVpXSLJdRTxUhwNZFKyoeiD2oxcfikdF/xj4rIZPOmPLeLvvmF8G0vkbL8dwUczds
         eOTXI0/dx4rFhR2WPomyUFyXogGI5vq6CmALmMvPVsveFT1sAXVOPsegUZdyuLG5d85U
         m9zh0Ww5olJSHEnHp/va0ucDR83kbhpqpDbBSCLNJ7/eoLEGYd0s0ldDA4Ng3TshUWTC
         rLXw==
X-Gm-Message-State: ACrzQf1N/dnblyUKhgHoTD77v/BgB246LXQkR8WxjaRbr9+Rk1e3MXgz
        Vs71iSMy2xtTvkI/Orcp9Yv4y9D+ENa/F3pYZPm0htwNYh7CJBvLOW6W38pf6X/LZdL1TUjzYnl
        rng2LwLYgl3T5YtOP
X-Received: by 2002:a05:6214:19c7:b0:4ad:32e9:a414 with SMTP id j7-20020a05621419c700b004ad32e9a414mr8328376qvc.115.1663633288923;
        Mon, 19 Sep 2022 17:21:28 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4DyUYrtkHa2QUqcCdNGHLn5NMDVIEGrzukSM5kG6wAzOlNtoK+dsZcVAEwt0I2pDlAefcbVQ==
X-Received: by 2002:a05:6214:19c7:b0:4ad:32e9:a414 with SMTP id j7-20020a05621419c700b004ad32e9a414mr8328359qvc.115.1663633288691;
        Mon, 19 Sep 2022 17:21:28 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id r4-20020ae9d604000000b006bb29d932e1sm13826998qkk.105.2022.09.19.17.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 17:21:28 -0700 (PDT)
Message-ID: <ab41cc04-1686-3a15-c209-387b1d60f7ef@redhat.com>
Date:   Mon, 19 Sep 2022 20:21:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net 1/2] selftests: bonding: cause oops in
 bond_rr_gen_slave_id
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <cover.1663628505.git.jtoppins@redhat.com>
 <bb3abf634d23944a24f4a9453e07c37c7b2168e9.1663628505.git.jtoppins@redhat.com>
 <18171.1663632104@famine>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <18171.1663632104@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/22 20:01, Jay Vosburgh wrote:
> Jonathan Toppins <jtoppins@redhat.com> wrote:
> 
>> This bonding selftest causes the following kernel oops on aarch64 and
>> should be architectures agnostic.
>>
>> [  329.805838] kselftest: Running tests in drivers/net/bonding
>> [  330.011028] eth0: renamed from link1_2
>> [  330.220846] eth0: renamed from link1_1
>> [  330.387755] bond0: (slave eth0): making interface the new active one
>> [  330.394165] bond0: (slave eth0): Enslaving as an active interface with an up link
>> [  330.401867] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>> [  334.586619] bond0: (slave eth0): Releasing backup interface
>> [  334.671065] bond0: (slave eth0): Enslaving as an active interface with an up link
>> [  334.686773] Unable to handle kernel paging request at virtual address ffff2c91ac905000
>> [  334.694703] Mem abort info:
>> [  334.697486]   ESR = 0x0000000096000004
>> [  334.701234]   EC = 0x25: DABT (current EL), IL = 32 bits
>> [  334.706536]   SET = 0, FnV = 0
>> [  334.709579]   EA = 0, S1PTW = 0
>> [  334.712719]   FSC = 0x04: level 0 translation fault
>> [  334.717586] Data abort info:
>> [  334.720454]   ISV = 0, ISS = 0x00000004
>> [  334.724288]   CM = 0, WnR = 0
>> [  334.727244] swapper pgtable: 4k pages, 48-bit VAs, pgdp=000008044d662000
>> [  334.733944] [ffff2c91ac905000] pgd=0000000000000000, p4d=0000000000000000
>> [  334.740734] Internal error: Oops: 96000004 [#1] SMP
>> [  334.745602] Modules linked in: bonding tls veth rfkill sunrpc arm_spe_pmu vfat fat acpi_ipmi ipmi_ssif ixgbe igb i40e mdio ipmi_devintf ipmi_msghandler arm_cmn arm_dsu_pmu cppc_cpufreq acpi_tad fuse zram crct10dif_ce ast ghash_ce sbsa_gwdt nvme drm_vram_helper drm_ttm_helper nvme_core ttm xgene_hwmon
>> [  334.772217] CPU: 7 PID: 2214 Comm: ping Not tainted 6.0.0-rc4-00133-g64ae13ed4784 #4
>> [  334.779950] Hardware name: GIGABYTE R272-P31-00/MP32-AR1-00, BIOS F18v (SCP: 1.08.20211002) 12/01/2021
>> [  334.789244] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> [  334.796196] pc : bond_rr_gen_slave_id+0x40/0x124 [bonding]
>> [  334.801691] lr : bond_xmit_roundrobin_slave_get+0x38/0xdc [bonding]
>> [  334.807962] sp : ffff8000221733e0
>> [  334.811265] x29: ffff8000221733e0 x28: ffffdbac8572d198 x27: ffff80002217357c
>> [  334.818392] x26: 000000000000002a x25: ffffdbacb33ee000 x24: ffff07ff980fa000
>> [  334.825519] x23: ffffdbacb2e398ba x22: ffff07ff98102000 x21: ffff07ff981029c0
>> [  334.832646] x20: 0000000000000001 x19: ffff07ff981029c0 x18: 0000000000000014
>> [  334.839773] x17: 0000000000000000 x16: ffffdbacb1004364 x15: 0000aaaabe2f5a62
>> [  334.846899] x14: ffff07ff8e55d968 x13: ffff07ff8e55db30 x12: 0000000000000000
>> [  334.854026] x11: ffffdbacb21532e8 x10: 0000000000000001 x9 : ffffdbac857178ec
>> [  334.861153] x8 : ffff07ff9f6e5a28 x7 : 0000000000000000 x6 : 000000007c2b3742
>> [  334.868279] x5 : ffff2c91ac905000 x4 : ffff2c91ac905000 x3 : ffff07ff9f554400
>> [  334.875406] x2 : ffff2c91ac905000 x1 : 0000000000000001 x0 : ffff07ff981029c0
>> [  334.882532] Call trace:
>> [  334.884967]  bond_rr_gen_slave_id+0x40/0x124 [bonding]
>> [  334.890109]  bond_xmit_roundrobin_slave_get+0x38/0xdc [bonding]
>> [  334.896033]  __bond_start_xmit+0x128/0x3a0 [bonding]
>> [  334.901001]  bond_start_xmit+0x54/0xb0 [bonding]
>> [  334.905622]  dev_hard_start_xmit+0xb4/0x220
>> [  334.909798]  __dev_queue_xmit+0x1a0/0x720
>> [  334.913799]  arp_xmit+0x3c/0xbc
>> [  334.916932]  arp_send_dst+0x98/0xd0
>> [  334.920410]  arp_solicit+0xe8/0x230
>> [  334.923888]  neigh_probe+0x60/0xb0
>> [  334.927279]  __neigh_event_send+0x3b0/0x470
>> [  334.931453]  neigh_resolve_output+0x70/0x90
>> [  334.935626]  ip_finish_output2+0x158/0x514
>> [  334.939714]  __ip_finish_output+0xac/0x1a4
>> [  334.943800]  ip_finish_output+0x40/0xfc
>> [  334.947626]  ip_output+0xf8/0x1a4
>> [  334.950931]  ip_send_skb+0x5c/0x100
>> [  334.954410]  ip_push_pending_frames+0x3c/0x60
>> [  334.958758]  raw_sendmsg+0x458/0x6d0
>> [  334.962325]  inet_sendmsg+0x50/0x80
>> [  334.965805]  sock_sendmsg+0x60/0x6c
>> [  334.969286]  __sys_sendto+0xc8/0x134
>> [  334.972853]  __arm64_sys_sendto+0x34/0x4c
>> [  334.976854]  invoke_syscall+0x78/0x100
>> [  334.980594]  el0_svc_common.constprop.0+0x4c/0xf4
>> [  334.985287]  do_el0_svc+0x38/0x4c
>> [  334.988591]  el0_svc+0x34/0x10c
>> [  334.991724]  el0t_64_sync_handler+0x11c/0x150
>> [  334.996072]  el0t_64_sync+0x190/0x194
>> [  334.999726] Code: b9001062 f9403c02 d53cd044 8b040042 (b8210040)
>> [  335.005810] ---[ end trace 0000000000000000 ]---
>> [  335.010416] Kernel panic - not syncing: Oops: Fatal exception in interrupt
>> [  335.017279] SMP: stopping secondary CPUs
>> [  335.021374] Kernel Offset: 0x5baca8eb0000 from 0xffff800008000000
>> [  335.027456] PHYS_OFFSET: 0x80000000
>> [  335.030932] CPU features: 0x0000,0085c029,19805c82
>> [  335.035713] Memory Limit: none
>> [  335.038756] Rebooting in 180 seconds..
>>
>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>> ---
>> .../selftests/drivers/net/bonding/Makefile    |  3 +-
>> .../bonding/bond-arp-interval-causes-panic.sh | 48 +++++++++++++++++++
>> 2 files changed, 50 insertions(+), 1 deletion(-)
>> create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh
>>
>> diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
>> index 0f9659407969..1d866658e541 100644
>> --- a/tools/testing/selftests/drivers/net/bonding/Makefile
>> +++ b/tools/testing/selftests/drivers/net/bonding/Makefile
>> @@ -2,7 +2,8 @@
>> # Makefile for net selftests
>>
>> TEST_PROGS := bond-break-lacpdu-tx.sh \
>> -	      dev_addr_lists.sh
>> +	      dev_addr_lists.sh \
>> +	      bond-arp-interval-causes-panic.sh
>>
>> TEST_FILES := lag_lib.sh
>>
>> diff --git a/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh b/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh
>> new file mode 100755
>> index 000000000000..095c262ba74c
>> --- /dev/null
>> +++ b/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh
>> @@ -0,0 +1,48 @@
>> +#!/bin/sh
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# cause kernel oops in bond_rr_gen_slave_id
>> +DEBUG=${DEBUG:-0}
>> +
>> +set -e
>> +test ${DEBUG} -ne 0 && set -x
>> +
>> +function finish()
>> +{
>> +	ip -all netns delete
> 
> 	Would it be friendlier to only delete the netns created by the
> test itself?

Sure I can list the specific namespaces.

> 
> 	I'm not too familiar with the selftest harness, so I'm not sure
> if it handles that (runs the test in a container or something), but if
> the test is run directly could this clobber other netns unrelated to the
> test?

Sure and if the namespace "server" has already been created the script 
will get an EEXISTS error.

The only limitation I am aware of is a timeout limitation, meaning the 
script must execute within 45 seconds. The script 
tools/testing/selftests/run_kselftest.sh appears to run the script 
directly within the context under which run_kselftest.sh was started. 
For example when I used it to verify this bug I used sudo to run as 
root, `sudo run_kselftest.sh`.

-Jon

