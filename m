Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEAE9D7DF7
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbfJORh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:37:57 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42526 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfJORh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 13:37:56 -0400
Received: by mail-pg1-f195.google.com with SMTP id f14so7450142pgi.9
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 10:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=xn90jPo35SaCKUCDmduyed5EQWmFjsr4MfBcqLC6pqs=;
        b=CH/9AaTVgk2KQWyeHgHFZuwrWNQ1JXBxboVhKK39E3r+yUW76QDvDSOMMnVUgtIkN5
         jQhpF+pfaDsyuXIRry8IC672BrKLf8sAhj6BF9anj5toW8F2QLRBNao0uvddGi/9ZH+4
         JQl8VjyPpK5sWejA0nR9lGYnX1pXYIOu9//uGTFpAqCrmP9RtQF1Lr63Fa/7zbliqJ8u
         /lTE9Pch/mjr2nQcu+QyiiHOaxnvkX06yy+XUYp3upnQH+3NSlYGXFQLFi+j7LS3Rvac
         pbyYGJk7RyFdKPlJHUCg8AzzxVtsnEcXuftqjMMEmsne43kTawl+QYeITOwAh+m5TAyZ
         pciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xn90jPo35SaCKUCDmduyed5EQWmFjsr4MfBcqLC6pqs=;
        b=VU5+jfJXh87tCSXrvfknhHVpBEw4DQrfW2gTCAsQ+BRumjG+2gnZUhhITSt711J6Ot
         oqyuBPedincF/MIaJlIHVyT8jrkpCruZw66/0T8/4M1Un1jhCcXsDCVxZ68s7GbVmbZF
         eeEJvQjh2cnb4Nn/B38PJ93sQbduiwMWD9y0Rr1CCTXmSdOMEMr1prP41hotM9k2UnO0
         /dzZhZddnsnEn7dB0HgaJLoPXAOBm61v0Jm7xC1b7CMBCfTW2gIE93Ttl7Gtvp2rDbK2
         xooDZ4xb+SU7wE4vwFe6AsNL/cRuPh1ScJHfblK+U7ejay86M4pUBNRP6XLzfsk33e71
         f7NQ==
X-Gm-Message-State: APjAAAUG+a+HtKiI7VK4D6jTKprP7yI1IBXGUw2vLOkE4QY5pO0gWei6
        YfplVUiI+Q+rBVYEh8+syZYND3j8NIE=
X-Google-Smtp-Source: APXvYqyTYeC2tdS08nmH2DLXelV7kgygtMXW6JyD5Z6CSDK6tnmXCYQqZFsnLNpxPLV7ElorGsUd1g==
X-Received: by 2002:a17:90a:5d0f:: with SMTP id s15mr43482307pji.126.1571161075012;
        Tue, 15 Oct 2019 10:37:55 -0700 (PDT)
Received: from [192.168.0.16] (97-115-119-26.ptld.qwest.net. [97.115.119.26])
        by smtp.gmail.com with ESMTPSA id p9sm20995608pfn.115.2019.10.15.10.37.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 10:37:54 -0700 (PDT)
Subject: Re: [PATCH net-next v2 00/10] optimize openvswitch flow looking up
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Pravin Shelar <pshelar@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
 <a9784bad-6e8d-eddc-4ddd-dd90ae31bc20@gmail.com>
 <CAMDZJNX79mZkaB-eWPR_hZbVL21Ccm0ySxcwopi3HLvFUNYw6w@mail.gmail.com>
 <af9aa8bd-c624-01f0-8e28-ae942aaa6bb8@gmail.com>
 <CAMDZJNV4S_ebb_Lz=eWw1csJyrQ_jXTC2qwbS4UmFBpFbqYDhA@mail.gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <62d4e2d9-90a1-8329-a099-a387cb268195@gmail.com>
Date:   Tue, 15 Oct 2019 10:37:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAMDZJNV4S_ebb_Lz=eWw1csJyrQ_jXTC2qwbS4UmFBpFbqYDhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/15/2019 1:25 AM, Tonghao Zhang wrote:
> On Tue, Oct 15, 2019 at 6:26 AM Gregory Rose <gvrose8192@gmail.com> wrote:

[snip]

>> Hi Tonghao,
>> I did make the change you suggested:
>>
>> git diff
>> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
>> index bc14b12..210018a 100644
>> --- a/net/openvswitch/flow_table.c
>> +++ b/net/openvswitch/flow_table.c
>> @@ -827,6 +827,8 @@ static int tbl_mask_array_add_mask(struct flow_table
>> *tbl,
>>                                                 MASK_ARRAY_SIZE_MIN);
>>                   if (err)
>>                           return err;
>> +
>> +               ma = ovsl_dereference(tbl->mask_array);
>>           }
>>
>> However, there is still an issue.  Apparently this change just moves the
>> bug.  Now I'm getting this splat:
>>
>> [  512.147478] ------------[ cut here ]------------
>> [  512.147481] kernel BUG at net/openvswitch/flow_table.c:725!
>> [  512.147526] invalid opcode: 0000 [#1] SMP PTI
>> [  512.147552] CPU: 1 PID: 14636 Comm: ovs-vswitchd Tainted:
>> G            E     5.4.0-rc1+ #138
>> [  512.147595] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>> [  512.147630] RIP: 0010:ovs_flow_tbl_remove+0x151/0x160 [openvswitch]
>> [  512.147663] Code: 55 f7 ea 89 f0 c1 f8 1f 29 c2 39 53 10 0f 8f 6a ff
>> ff ff 48 89 ef d1 fe 5b 5d e9 8a ed ff ff 0f 0b 0f 0b b8 18 00 00 00 eb
>> 92 <0f> 0b 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57
>> [  512.147753] RSP: 0018:ffffb637002cf8c8 EFLAGS: 00010246
>> [  512.147781] RAX: 0000000000000009 RBX: ffff95ebf32d23c0 RCX:
>> ffff95ebf00e5a00
>> [  512.147817] RDX: ffff95ebf32d2420 RSI: 0000000000000009 RDI:
>> ffff95ebf0dffba0
>> [  512.147852] RBP: ffffb637002cfb70 R08: ffff95ebf6030240 R09:
>> ffff95ebf1643180
>> [  512.147888] R10: ffff95ebf283b814 R11: ffffffffc0932500 R12:
>> ffff95ebf040a300
>> [  512.147924] R13: ffff95ebf0dffba0 R14: ffff95ebf283b814 R15:
>> 0000000000000007
>> [  512.147961] FS:  00007fbbab3d2980(0000) GS:ffff95ebf7a80000(0000)
>> knlGS:0000000000000000
>> [  512.148001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  512.148031] CR2: 00007fffca190ff8 CR3: 0000000232810006 CR4:
>> 00000000001606e0
>> [  512.148071] Call Trace:
>> [  512.148092]  action_fifos_exit+0x3240/0x37b0 [openvswitch]
>> [  512.148125]  ? update_sd_lb_stats+0x613/0x760
>> [  512.148152]  ? find_busiest_group+0x3e/0x520
>> [  512.148177]  ? __nla_validate_parse+0x57/0x8a0
>> [  512.148203]  ? _cond_resched+0x15/0x40
>> [  512.148226]  ? genl_family_rcv_msg_attrs_parse+0xe4/0x110
>> [  512.148256]  genl_rcv_msg+0x1ed/0x430
>> [  512.148303]  ? __switch_to_asm+0x34/0x70
>> [  512.148326]  ? __switch_to_asm+0x40/0x70
>> [  512.148349]  ? __switch_to_asm+0x34/0x70
>> [  512.148371]  ? __switch_to_asm+0x40/0x70
>> [  512.148394]  ? __switch_to_asm+0x34/0x70
>> [  512.148416]  ? __switch_to_asm+0x40/0x70
>> [  512.148439]  ? genl_family_rcv_msg_attrs_parse+0x110/0x110
>> [  512.148470]  netlink_rcv_skb+0x4a/0x110
>> [  512.148492]  genl_rcv+0x24/0x40
>> [  512.148512]  netlink_unicast+0x1a0/0x250
>> [  512.148536]  netlink_sendmsg+0x2b4/0x3b0
>> [  512.148560]  sock_sendmsg+0x5b/0x60
>> [  512.148582]  ___sys_sendmsg+0x278/0x2f0
>> [  512.148607]  ? file_update_time+0x60/0x130
>> [  512.148630]  ? pipe_write+0x286/0x400
>> [  512.148653]  ? new_sync_write+0x12d/0x1d0
>> [  512.148676]  ? __sys_sendmsg+0x5e/0xa0
>> [  512.148697]  __sys_sendmsg+0x5e/0xa0
>> [  512.148720]  do_syscall_64+0x52/0x1a0
>> [  512.148742]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [  512.148771] RIP: 0033:0x7fbbaa6f9a6d
>> [  512.149622] Code: b9 20 00 00 75 10 b8 2e 00 00 00 0f 05 48 3d 01 f0
>> ff ff 73 31 c3 48 83 ec 08 e8 fe f6 ff ff 48 89 04 24 b8 2e 00 00 00 0f
>> 05 <48> 8b 3c 24 48 89 c2 e8 47 f7 ff ff 48 89 d0 48 83 c4 08 48 3d 01
>> [  512.151428] RSP: 002b:00007fffca1a1100 EFLAGS: 00000293 ORIG_RAX:
>> 000000000000002e
>> [  512.152349] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:
>> 00007fbbaa6f9a6d
>> [  512.153266] RDX: 0000000000000000 RSI: 00007fffca1a1160 RDI:
>> 0000000000000010
>> [  512.154184] RBP: 0000000000f42680 R08: 0000000000000000 R09:
>> 00007fffca1a2118
>> [  512.155094] R10: 0000000000000008 R11: 0000000000000293 R12:
>> 00007fffca1a1f30
>> [  512.155992] R13: 00007fffca1a20c0 R14: 00007fffca1a1f38 R15:
>> 00007fffca1a15f0
>> [  512.156866] Modules linked in: vport_vxlan(E) vxlan(E) vport_gre(E)
>> ip_gre(E) ip_tunnel(E) vport_geneve(E) geneve(E) ip6_udp_tunnel(E)
>> udp_tunnel(E) openvswitch(E) nsh(E) nf_conncount(E) nf_nat_tftp(E)
>> nf_conntrack_tftp(E) nf_nat_ftp(E) nf_conntrack_ftp(E) nf_nat(E)
>> nf_conntrack_netlink(E) ip6table_filter(E) ip6_tables(E)
>> iptable_filter(E) ip_tables(E) x_tables(E) ip6_gre(E) ip6_tunnel(E)
>> tunnel6(E) gre(E) bonding(E) 8021q(E) garp(E) stp(E) mrp(E) llc(E)
>> veth(E) nfnetlink_cttimeout(E) nfnetlink(E) nf_conntrack(E)
>> nf_defrag_ipv6(E) nf_defrag_ipv4(E) binfmt_misc(E) intel_rapl_msr(E)
>> snd_hda_codec_generic(E) ledtrig_audio(E) snd_hda_intel(E)
>> snd_intel_nhlt(E) snd_hda_codec(E) intel_rapl_common(E) snd_hda_core(E)
>> snd_hwdep(E) input_leds(E) snd_pcm(E) joydev(E) snd_timer(E)
>> serio_raw(E) snd(E) soundcore(E) i2c_piix4(E) mac_hid(E) ib_iser(E)
>> rdma_cm(E) iw_cm(E) ib_cm(E) ib_core(E) configfs(E) iscsi_tcp(E)
>> libiscsi_tcp(E) libiscsi(E) scsi_transport_iscsi(E) autofs4(E) btrfs(E)
>> zstd_decompress(E)
>> [  512.156899]  zstd_compress(E) raid10(E) raid456(E)
>> async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E)
>> async_tx(E) xor(E) raid6_pq(E) libcrc32c(E) raid1(E) raid0(E)
>> multipath(E) linear(E) crct10dif_pclmul(E) crc32_pclmul(E)
>> ghash_clmulni_intel(E) aesni_intel(E) crypto_simd(E) qxl(E) ttm(E)
>> cryptd(E) glue_helper(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E)
>> sysimgblt(E) fb_sys_fops(E) psmouse(E) drm(E) pata_acpi(E) floppy(E)
>> [last unloaded: nf_conntrack_ftp]
>> [  512.168488] ---[ end trace 26730810beeb11e1 ]---
>> [  512.169555] RIP: 0010:ovs_flow_tbl_remove+0x151/0x160 [openvswitch]
>> [  512.170638] Code: 55 f7 ea 89 f0 c1 f8 1f 29 c2 39 53 10 0f 8f 6a ff
>> ff ff 48 89 ef d1 fe 5b 5d e9 8a ed ff ff 0f 0b 0f 0b b8 18 00 00 00 eb
>> 92 <0f> 0b 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57
>> [  512.172813] RSP: 0018:ffffb637002cf8c8 EFLAGS: 00010246
>> [  512.173897] RAX: 0000000000000009 RBX: ffff95ebf32d23c0 RCX:
>> ffff95ebf00e5a00
>> [  512.174991] RDX: ffff95ebf32d2420 RSI: 0000000000000009 RDI:
>> ffff95ebf0dffba0
>> [  512.176109] RBP: ffffb637002cfb70 R08: ffff95ebf6030240 R09:
>> ffff95ebf1643180
>> [  512.177229] R10: ffff95ebf283b814 R11: ffffffffc0932500 R12:
>> ffff95ebf040a300
>> [  512.178364] R13: ffff95ebf0dffba0 R14: ffff95ebf283b814 R15:
>> 0000000000000007
>> [  512.179530] FS:  00007fbbab3d2980(0000) GS:ffff95ebf7a80000(0000)
>> knlGS:0000000000000000
>> [  512.180700] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  512.181885] CR2: 00007fffca190ff8 CR3: 0000000232810006 CR4:
>> 00000000001606e0
>>
>> The code is hitting this:
>>
>> static void tbl_mask_array_del_mask(struct flow_table *tbl,
>>                                       struct sw_flow_mask *mask)
>> {
>>           struct mask_array *ma = ovsl_dereference(tbl->mask_array);
>>           int i;
>>
>>           /* Remove the deleted mask pointers from the array */
>>           for (i = 0; i < ma->count; i++) {
>>                   if (mask == ovsl_dereference(ma->masks[i]))
>>                           goto found;
>>           }
>>
>>           BUG();   <----------------------------   Here
>>
>> Pravin mentioned memory barrier usage in one of his replies. Perhaps
>> that is an avenue to explore.
> Hi Pravin, Greg
> I run the make check-kernel for a long time, and don't reproduce it.
> Greg, how did you reproduce it?

Hi Tonghao,

I use a Ubuntu 16.04 base system with updates all applied and build the 
net-next kernel (with your
patches applied) and then install it.

I boot to the new kernel and then build the current master branch of OVS 
from github:
./boot.sh
mkdir _build
cd _build
../configure
make -j8

I then run 'sudo make check-kernel TESTSUITEFLAGS="63"'

Hope this helps with your repro.

Thanks,

- Greg

>
> For using barrier, i should add READ_ONCE in flow_lookup in fast path
> (read-side ), and use WRITE_ONCE in
> tbl_mask_array_add/del_mask (write-side) protected by ovs_mutex. Other
> read-side (protected by ovs_mutex),
> e.g
> * flow_mask_find
> * ovs_flow_tbl_lookup_exact
> * ovs_flow_tbl_num_masks
>
> can access ma->count directly ?
>
>> Thanks,
>>
>> - Greg
>>

