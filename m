Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37215B8B1C
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 16:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiINOzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 10:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiINOzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 10:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D74366A46
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 07:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663167345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WLEkI//iqZSrPMfTs6GoYtZujvPTMQonmFtzUkWUMVI=;
        b=iKiDvkURsrp8G5soLH5z7dR8+Gsev+DuRGxWaJLhZ1EabRJgrEWZfNXI/D3bXaQWidj0FF
        IrKf1f0sQxRNUbfX9m/WMcYzW76AIQo4w+HTkjliEUW2O0UPtM7ZtIkyiUywXW5DsC8FK4
        P1Jm6o+rdt8XmPj6D0+9zbbH9mpSDg0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-6-uQpf9bzcPh2X9F-bf2v_aQ-1; Wed, 14 Sep 2022 10:55:44 -0400
X-MC-Unique: uQpf9bzcPh2X9F-bf2v_aQ-1
Received: by mail-qk1-f198.google.com with SMTP id l15-20020a05620a28cf00b006b46997c070so13329258qkp.20
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 07:55:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=WLEkI//iqZSrPMfTs6GoYtZujvPTMQonmFtzUkWUMVI=;
        b=IoYm3biW7K0F/wIosT/ZZE5y3qxJL/Em8d2ImQapUE85OuZFTTS4jgn8c8+2OOoaww
         3udEqeSOYryB0xKEq3vo1SaoB0oIL1ZP50tGkLyFZw0XPvw/TNHtKsH+fVhr4GH7VCT6
         Om0t+RJ2PpknFvDc445vi1mZwwIqqEwSZSEZ+iGJbRXtVi9a77/Z7EJuZPENDh4ciE+8
         xrU5B4b1ro3Tl1xRfZCmlIHpZTPNVSJNFslflF/nv0HPYn2YrYZOxZWk2eTsfEG7RU2c
         79YiBXjhTh3IaoELBtzh0Sd1ti5Z8t7uuiA40x/sD4Fani0J013UNg1aE+qPCS3ZDaBr
         GUfA==
X-Gm-Message-State: ACgBeo3/R4/iMGOsFu24zC+0+AzdfQrISR9XXFMLga0Of3kCiieu4VXl
        j0UTwhbhY8adZgG/LucE9tJvmHx5WbnEtwZWdxDn8iDqiKwSH5gnvzjyJs2KOvR7gahpRN/fr3d
        HhIqu5J2DPG3pBdW8
X-Received: by 2002:a05:620a:199d:b0:6cd:4638:7fdd with SMTP id bm29-20020a05620a199d00b006cd46387fddmr18642287qkb.201.1663167343048;
        Wed, 14 Sep 2022 07:55:43 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4OraEoH8nQK5sSjwRhI+2IypQ8xR43Dh80DqrCL8nEkJ+FCRWcBQjxF+iBLR3FTp4qgELN4A==
X-Received: by 2002:a05:620a:199d:b0:6cd:4638:7fdd with SMTP id bm29-20020a05620a199d00b006cd46387fddmr18642270qkb.201.1663167342626;
        Wed, 14 Sep 2022 07:55:42 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id q26-20020ac8451a000000b003445b83de67sm1736834qtn.3.2022.09.14.07.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 07:55:42 -0700 (PDT)
Message-ID: <9822aa27-25a0-234d-0a9d-3c3c75dd40fa@redhat.com>
Date:   Wed, 14 Sep 2022 10:55:41 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH] bonding: cause oops on aarch64 architecture in
 bond_rr_gen_slave_id
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <7565deb870649ba6b5995034695f1b498245617a.1663042611.git.jtoppins@redhat.com>
 <27975.1663166447@famine>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <27975.1663166447@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/22 10:40, Jay Vosburgh wrote:
> Jonathan Toppins <jtoppins@redhat.com> wrote:
> 
>> This bonding selftest causes the following kernel oops on aarch64 and
>> possibly ppc64le architectures. This was reproduced on net/master commit
>> 64ae13ed478428135cddc2f1113dff162d8112d4 net: core: fix flow symmetric hash
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
> 
> 	What line in the source code is that?  Looking at the function,
> I don't really see anything that's arch specific, unless perhaps the
> rr_tx_counter assignment isn't visible for some ARM cache reason (i.e.,
> the dcache on the relevant cpu already had a populated cache line that's
> out of date, and wasn't flushed).


$ printf "%#x\n" $((0x$(nm drivers/net/bonding/bonding.ko | grep 
bond_rr_gen_slave_id | awk '{print $1}') + 0x40))
0x47d0
$ eu-addr2line -e drivers/net/bonding/bonding.ko 0x47d0
/home/jtoppins/projects/linux/./arch/arm64/include/asm/percpu.h:130:1

It appears to be a percpu arch specific issue. The cache line idea is a 
thought, not sure how to go about debugging on arm. I also have a report 
with a similar stack trace on ppc64le, but do not have a box to test on 
at this moment. I mention this as maybe someone else might see a generic 
non arch specific issue.

I could not reproduce the issue on x86_64 using a Fedora 36 kernel and 
this same test-case, I have not tested this specific upstream hash on 
x86_64. That was the plan for today.

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
>> .../selftests/drivers/net/bonding/Makefile    |  1 +
>> .../bonding/bond-arp-interval-causes-panic.sh | 46 +++++++++++++++++++
>> 2 files changed, 47 insertions(+)
>> create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh
>>
>> diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
>> index ab6c54b12098..79bb06fd386a 100644
>> --- a/tools/testing/selftests/drivers/net/bonding/Makefile
>> +++ b/tools/testing/selftests/drivers/net/bonding/Makefile
>> @@ -2,5 +2,6 @@
>> # Makefile for net selftests
>>
>> TEST_PROGS := bond-break-lacpdu-tx.sh
>> +TEST_PROGS += bond-arp-interval-causes-panic.sh
>>
>> include ../../../lib.mk
>> diff --git a/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh b/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh
>> new file mode 100755
>> index 000000000000..0c3e5d486193
>> --- /dev/null
>> +++ b/tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh
>> @@ -0,0 +1,46 @@
>> +#!/bin/sh
>> +
>> +# cause kernel oops in bond_rr_gen_slave_id on aarch64 and ppcle
>> +# architectures
>> +DEBUG=${DEBUG:-0}
>> +
>> +set -e
>> +test ${DEBUG} -ne 0 && set -x
>> +
>> +function finish()
>> +{
>> +	ip -all netns delete
>> +	ip link del link1_1 || true
>> +}
>> +
>> +trap finish EXIT
>> +
>> +client_ip4=192.168.1.198
>> +server_ip4=192.168.1.254
>> +
>> +# setup kernel so it reboots after causing the panic
>> +echo 180 >/proc/sys/kernel/panic
>> +
>> +# build namespaces
>> +ip link add dev link1_1 type veth peer name link1_2
>> +
>> +ip netns add "server"
>> +ip link set dev link1_2 netns server up name eth0
>> +ip netns exec server ip addr add ${server_ip4}/24 dev eth0
>> +
>> +ip netns add "client"
>> +ip link set dev link1_1 netns client down name eth0
>> +ip netns exec client ip link add dev bond0 down type bond mode 1 miimon 100 all_slaves_active 1
>> +ip netns exec client ip link set dev eth0 down master bond0
>> +ip netns exec client ip link set dev bond0 up
>> +ip netns exec client ip addr add ${client_ip4}/24 dev bond0
>> +ip netns exec client ping -c 5 $server_ip4 >/dev/null
>> +
>> +ip netns exec client ip link set dev eth0 down nomaster
>> +ip netns exec client ip link set dev bond0 down
>> +ip netns exec client ip link set dev bond0 type bond mode 0 arp_interval 1000 arp_ip_target "+${server_ip4}"
>> +ip netns exec client ip link set dev eth0 down master bond0
>> +ip netns exec client ip link set dev bond0 up
>> +ip netns exec client ping -c 5 $server_ip4 >/dev/null
>> +
>> +exit 0
>> -- 
>> 2.31.1
>>
> 

