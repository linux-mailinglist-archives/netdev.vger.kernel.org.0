Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1521D6BAC
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 00:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731886AbfJNW0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 18:26:24 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42375 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730369AbfJNW0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 18:26:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id e5so8583669pls.9
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 15:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=AgCuFAzDb9Te1NqfdEOImkMqtv3k1ksXYsfP2ds18vs=;
        b=DDML7uPr/W2+ah09IDSkXpL6G0T6/xizl2LyuisHVPenWL1/oozc7rkSVamNU0ETxH
         wtLjxbJip2Q3OShFbPR94IRHtZV8xK9JF7qW6DskHRT9l2tQOwaw0uhdbZSgnlMkS3/5
         qld/0oyFVspBFKbkehXfd6QdIBJu3J17WVsUCY0XJHr7bUbZIlbRnzYmSslk6L20iS8x
         va1iQyh+4Xg+cKtwPlx7mZMcfuEFoAbCFdpAYfhH8wHcLEJTNTQWMsqMYmGmBfkWDFyP
         VI3Uh0Sf4NGSh6LdqAxI1fEh9lT5FgvW+qbpwYkgD9v5p1LG1gkMJQ378eK8QV7wa7tF
         /5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AgCuFAzDb9Te1NqfdEOImkMqtv3k1ksXYsfP2ds18vs=;
        b=pjrFE2nik4BzGdKZAxaPdcQC06l9dKNHtm4daxk7XeGeus+nnJ7YO71aNq6mgnpT6v
         7WSWHEZsX4FiYTCvpZhSAFyUiw86g+9KJ/Doo09EK6fR6+GURe0QdUN8XP15InVYAPY9
         9nAPPai9PdWVvijI2sCAPORWDXx8MZNwPtsvYrmx7Urrr4AtzH1rbrqs0YQ4JP68TbR/
         YN1C4unBW+i6sn4OtfPp4hMjm1CNwCwbQ+KqySSRutN5wp/msa/mmMD8dCtHcldJ7svY
         YYlCooP2zxAp/pb3hhx2Ji1DEhgxX2RQQm8ULQka0/gT9f7+lfiq2ynP0O37u8zHgIOd
         AMww==
X-Gm-Message-State: APjAAAXHzmcdFCM8vVaow9bueHtrPIBTyrJk6we7Nvb15qcmcRDe8lRN
        tChL43ooOLurQJD24LQZ+pi1+3AujSs=
X-Google-Smtp-Source: APXvYqwgGhLm8xyQqac23ML2AH0wS+lZZdpZHnnyu4uGRF3p1yHEEcxk+XW2iLHEPRVC74cX1s153g==
X-Received: by 2002:a17:902:a581:: with SMTP id az1mr31558089plb.311.1571091981988;
        Mon, 14 Oct 2019 15:26:21 -0700 (PDT)
Received: from [192.168.0.16] (97-115-119-26.ptld.qwest.net. [97.115.119.26])
        by smtp.gmail.com with ESMTPSA id q132sm19902456pfq.16.2019.10.14.15.26.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 15:26:21 -0700 (PDT)
Subject: Re: [PATCH net-next v2 00/10] optimize openvswitch flow looking up
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Pravin Shelar <pshelar@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
 <a9784bad-6e8d-eddc-4ddd-dd90ae31bc20@gmail.com>
 <CAMDZJNX79mZkaB-eWPR_hZbVL21Ccm0ySxcwopi3HLvFUNYw6w@mail.gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <af9aa8bd-c624-01f0-8e28-ae942aaa6bb8@gmail.com>
Date:   Mon, 14 Oct 2019 15:26:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAMDZJNX79mZkaB-eWPR_hZbVL21Ccm0ySxcwopi3HLvFUNYw6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/2019 1:42 AM, Tonghao Zhang wrote:
> On Wed, Oct 9, 2019 at 1:33 AM Gregory Rose <gvrose8192@gmail.com> wrote:
>>

[snip]

>> Hi Tonghao,
>>
>> I've applied your patch series and built a 5.4.0-rc1 kernel with them.
>>
>> xxxxx@ubuntu-1604:~$ modinfo openvswitch
>> filename: /lib/modules/5.4.0-rc1+/kernel/net/openvswitch/openvswitch.ko
>> alias:          net-pf-16-proto-16-family-ovs_ct_limit
>> alias:          net-pf-16-proto-16-family-ovs_meter
>> alias:          net-pf-16-proto-16-family-ovs_packet
>> alias:          net-pf-16-proto-16-family-ovs_flow
>> alias:          net-pf-16-proto-16-family-ovs_vport
>> alias:          net-pf-16-proto-16-family-ovs_datapath
>> license:        GPL
>> description:    Open vSwitch switching datapath
>> srcversion:     F15EB8B4460D81BAA16216B
>> depends: nf_conntrack,nf_nat,nf_conncount,libcrc32c,nf_defrag_ipv6,nsh
>> retpoline:      Y
>> intree:         Y
>> name:           openvswitch
>> vermagic:       5.4.0-rc1+ SMP mod_unload modversions
>>
>> I then built openvswitch master branch from github and ran 'make
>> check-kernel'.
>>
>> In doing so I ran into the following splat in this test:
>> 63: conntrack - IPv6 fragmentation + vlan
>>
>> Here is the splat:
>> [  480.024215] ------------[ cut here ]------------
>> [  480.024218] kernel BUG at net/openvswitch/flow_table.c:725!
>> [  480.024267] invalid opcode: 0000 [#1] SMP PTI
>> [  480.024297] CPU: 2 PID: 15717 Comm: ovs-vswitchd Tainted: G            E
>> 5.4.0-rc1+ #131
>> [  480.024345] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>> [  480.024386] RIP: 0010:ovs_flow_tbl_remove+0x151/0x160 [openvswitch]
>> [  480.024424] Code: 55 f7 ea 89 f0 c1 f8 1f 29 c2 39 53 10 0f 8f 6a ff
>> ff ff 48 89 ef d1 fe 5b 5d e9 8a ed ff ff 0f 0b 0f 0b b8 18 00 00 00 eb
>> 92 <0f> 0b 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57
>> [  480.024527] RSP: 0018:ffffaf32c05e38c8 EFLAGS: 00010246
>> [  480.024560] RAX: 0000000000000010 RBX: ffff9e4f6cd5a000 RCX:
>> ffff9e4f6c585000
>> [  480.024601] RDX: ffff9e4f6cd5a098 RSI: 0000000000000010 RDI:
>> ffff9e4f6b2c6d20
>> [  480.024642] RBP: ffffaf32c05e3b70 R08: ffff9e4f6c1651c0 R09:
>> ffff9e4f756a43c0
>> [  480.024684] R10: 0000000000000000 R11: ffffffffc06e5500 R12:
>> ffff9e4f6baf7800
>> [  480.024742] R13: ffff9e4f6b2c6d20 R14: ffff9e4f724a4e14 R15:
>> 0000000000000007
>> [  480.024790] FS:  00007fdd76058980(0000) GS:ffff9e4f77b00000(0000)
>> knlGS:0000000000000000
>> [  480.024836] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  480.024871] CR2: 00007ffd18a5ac60 CR3: 0000000230f3a002 CR4:
>> 00000000001606e0
>> [  480.024917] Call Trace:
>> [  480.024941]  action_fifos_exit+0x3240/0x37b0 [openvswitch]
>> [  480.024979]  ? __switch_to_asm+0x40/0x70
>> [  480.025005]  ? __switch_to_asm+0x34/0x70
>> [  480.025031]  ? __switch_to_asm+0x40/0x70
>> [  480.025056]  ? __switch_to_asm+0x40/0x70
>> [  480.025082]  ? __switch_to_asm+0x34/0x70
>> [  480.025108]  ? __switch_to_asm+0x40/0x70
>> [  480.025134]  ? __switch_to_asm+0x34/0x70
>> [  480.025159]  ? __switch_to_asm+0x40/0x70
>> [  480.025185]  ? __switch_to_asm+0x34/0x70
>> [  480.025210]  ? __switch_to_asm+0x40/0x70
>> [  480.025236]  ? __switch_to_asm+0x34/0x70
>> [  480.025262]  ? __switch_to_asm+0x40/0x70
>> [  480.025287]  ? __switch_to_asm+0x34/0x70
>> [  480.025312]  ? __switch_to_asm+0x40/0x70
>> [  480.025338]  ? __switch_to_asm+0x34/0x70
>> [  480.025364]  ? __switch_to_asm+0x40/0x70
>> [  480.025389]  ? __switch_to_asm+0x34/0x70
>> [  480.025415]  ? __switch_to_asm+0x40/0x70
>> [  480.025443]  ? __update_load_avg_se+0x11c/0x2e0
>> [  480.025472]  ? __update_load_avg_se+0x11c/0x2e0
>> [  480.025503]  ? update_load_avg+0x7e/0x600
>> [  480.025529]  ? update_load_avg+0x7e/0x600
>> [  480.025556]  ? update_curr+0x85/0x1d0
>> [  480.025582]  ? cred_has_capability+0x85/0x130
>> [  480.025611]  ? __nla_validate_parse+0x57/0x8a0
>> [  480.025640]  ? _cond_resched+0x15/0x40
>> [  480.025666]  ? genl_family_rcv_msg_attrs_parse.isra.14+0x93/0x100
>> [  480.026523]  genl_rcv_msg+0x1d9/0x490
>> [  480.027385]  ? __switch_to_asm+0x34/0x70
>> [  480.028230]  ? __switch_to_asm+0x40/0x70
>> [  480.029050]  ? __switch_to_asm+0x40/0x70
>> [  480.029874]  ? genl_family_rcv_msg_attrs_parse.isra.14+0x100/0x100
>> [  480.030673]  netlink_rcv_skb+0x4a/0x110
>> [  480.031465]  genl_rcv+0x24/0x40
>> [  480.032312]  netlink_unicast+0x1a0/0x250
>> [  480.033059]  netlink_sendmsg+0x2b4/0x3b0
>> [  480.033758]  sock_sendmsg+0x5b/0x60
>> [  480.034422]  ___sys_sendmsg+0x278/0x2f0
>> [  480.035083]  ? file_update_time+0x60/0x130
>> [  480.035680]  ? pipe_write+0x286/0x400
>> [  480.036290]  ? new_sync_write+0x12d/0x1d0
>> [  480.036882]  ? __sys_sendmsg+0x5e/0xa0
>> [  480.037452]  __sys_sendmsg+0x5e/0xa0
>> [  480.038013]  do_syscall_64+0x52/0x1a0
>> [  480.038546]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [  480.039083] RIP: 0033:0x7fdd7537fa6d
>> [  480.039596] Code: b9 20 00 00 75 10 b8 2e 00 00 00 0f 05 48 3d 01 f0
>> ff ff 73 31 c3 48 83 ec 08 e8 fe f6 ff ff 48 89 04 24 b8 2e 00 00 00 0f
>> 05 <48> 8b 3c 24 48 89 c2 e8 47 f7 ff ff 48 89 d0 48 83 c4 08 48 3d 01
>> [  480.040769] RSP: 002b:00007ffd18a6ad40 EFLAGS: 00000293 ORIG_RAX:
>> 000000000000002e
>> [  480.041391] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:
>> 00007fdd7537fa6d
>> [  480.042045] RDX: 0000000000000000 RSI: 00007ffd18a6ada0 RDI:
>> 0000000000000014
>> [  480.042713] RBP: 0000000002300870 R08: 0000000000000000 R09:
>> 00007ffd18a6bd58
>> [  480.043438] R10: 0000000000000000 R11: 0000000000000293 R12:
>> 00007ffd18a6bb70
>> [  480.044138] R13: 00007ffd18a6bd00 R14: 00007ffd18a6bb78 R15:
>> 00007ffd18a6b230
>> [  480.044852] Modules linked in: vport_vxlan(E) vxlan(E) vport_gre(E)
>> ip_gre(E) ip_tunnel(E) vport_geneve(E) geneve(E) ip6_udp_tunnel(E)
>> udp_tunnel(E) openvswitch(E) nsh(E) nf_conncount(E) nf_nat_tftp(E)
>> nf_conntrack_tftp(E) nf_nat_ftp(E) nf_conntrack_ftp(E) nf_nat(E)
>> nf_conntrack_netlink(E) ip6table_filter(E) ip6_tables(E)
>> iptable_filter(E) ip_tables(E) x_tables(E) ip6_gre(E) ip6_tunnel(E)
>> tunnel6(E) gre(E) bonding(E) 8021q(E) garp(E) stp(E) mrp(E) llc(E)
>> veth(E) nfnetlink_cttimeout(E) nfnetlink(E) nf_conntrack(E)
>> nf_defrag_ipv6(E) nf_defrag_ipv4(E) binfmt_misc(E) intel_rapl_msr(E)
>> snd_hda_codec_generic(E) ledtrig_audio(E) snd_hda_intel(E)
>> snd_intel_nhlt(E) joydev(E) snd_hda_codec(E) input_leds(E)
>> snd_hda_core(E) snd_hwdep(E) intel_rapl_common(E) snd_pcm(E)
>> snd_timer(E) serio_raw(E) snd(E) soundcore(E) i2c_piix4(E) mac_hid(E)
>> ib_iser(E) rdma_cm(E) iw_cm(E) ib_cm(E) ib_core(E) configfs(E)
>> iscsi_tcp(E) libiscsi_tcp(E) libiscsi(E) scsi_transport_iscsi(E)
>> autofs4(E) btrfs(E) zstd_decompress(E)
>> [  480.044888]  zstd_compress(E) raid10(E) raid456(E)
>> async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E)
>> async_tx(E) xor(E) raid6_pq(E) libcrc32c(E) raid1(E) raid0(E)
>> multipath(E) linear(E) crct10dif_pclmul(E) crc32_pclmul(E)
>> ghash_clmulni_intel(E) aesni_intel(E) qxl(E) crypto_simd(E) ttm(E)
>> cryptd(E) glue_helper(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E)
>> sysimgblt(E) fb_sys_fops(E) psmouse(E) drm(E) floppy(E) pata_acpi(E)
>> [last unloaded: nf_conntrack_ftp]
>> [  480.056765] ---[ end trace 4a8c4eceeb9f5dec ]---
>> [  480.057953] RIP: 0010:ovs_flow_tbl_remove+0x151/0x160 [openvswitch]
>> [  480.059134] Code: 55 f7 ea 89 f0 c1 f8 1f 29 c2 39 53 10 0f 8f 6a ff
>> ff ff 48 89 ef d1 fe 5b 5d e9 8a ed ff ff 0f 0b 0f 0b b8 18 00 00 00 eb
>> 92 <0f> 0b 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57
>> [  480.061623] RSP: 0018:ffffaf32c05e38c8 EFLAGS: 00010246
>> [  480.062959] RAX: 0000000000000010 RBX: ffff9e4f6cd5a000 RCX:
>> ffff9e4f6c585000
>> [  480.064248] RDX: ffff9e4f6cd5a098 RSI: 0000000000000010 RDI:
>> ffff9e4f6b2c6d20
>> [  480.065524] RBP: ffffaf32c05e3b70 R08: ffff9e4f6c1651c0 R09:
>> ffff9e4f756a43c0
>> [  480.066830] R10: 0000000000000000 R11: ffffffffc06e5500 R12:
>> ffff9e4f6baf7800
>> [  480.068870] R13: ffff9e4f6b2c6d20 R14: ffff9e4f724a4e14 R15:
>> 0000000000000007
>> [  480.070081] FS:  00007fdd76058980(0000) GS:ffff9e4f77b00000(0000)
>> knlGS:0000000000000000
>> [  480.071340] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  480.072610] CR2: 00007ffd18a5ac60 CR3: 0000000230f3a002 CR4:
>> 00000000001606e0
>>
>> You're hitting the BUG_ON here:
>>
>> /* Must be called with OVS mutex held. */
>> void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
>> {
>>           struct table_instance *ti = ovsl_dereference(table->ti);
>>           struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
>>
>>           BUG_ON(table->count == 0);
>> <------------------------------------------------ Here
> Hi Greg,
> Thanks for your work, I fixed it, when relloac mask_array I don't
> update ma point in patch 5.
>
> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> index bc14b12..210018a 100644
> --- a/net/openvswitch/flow_table.c
> +++ b/net/openvswitch/flow_table.c
> @@ -827,6 +827,8 @@ static int tbl_mask_array_add_mask(struct flow_table *tbl,
>                                                MASK_ARRAY_SIZE_MIN);
>                  if (err)
>                          return err;
> +
> +               ma = ovsl_dereference(tbl->mask_array);
>          }
>
>          BUG_ON(ovsl_dereference(ma->masks[ma->count]));

Hi Tonghao,

I did make the change you suggested:

git diff
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index bc14b12..210018a 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -827,6 +827,8 @@ static int tbl_mask_array_add_mask(struct flow_table 
*tbl,
                                               MASK_ARRAY_SIZE_MIN);
                 if (err)
                         return err;
+
+               ma = ovsl_dereference(tbl->mask_array);
         }

However, there is still an issue.  Apparently this change just moves the 
bug.  Now I'm getting this splat:

[  512.147478] ------------[ cut here ]------------
[  512.147481] kernel BUG at net/openvswitch/flow_table.c:725!
[  512.147526] invalid opcode: 0000 [#1] SMP PTI
[  512.147552] CPU: 1 PID: 14636 Comm: ovs-vswitchd Tainted: 
G            E     5.4.0-rc1+ #138
[  512.147595] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  512.147630] RIP: 0010:ovs_flow_tbl_remove+0x151/0x160 [openvswitch]
[  512.147663] Code: 55 f7 ea 89 f0 c1 f8 1f 29 c2 39 53 10 0f 8f 6a ff 
ff ff 48 89 ef d1 fe 5b 5d e9 8a ed ff ff 0f 0b 0f 0b b8 18 00 00 00 eb 
92 <0f> 0b 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57
[  512.147753] RSP: 0018:ffffb637002cf8c8 EFLAGS: 00010246
[  512.147781] RAX: 0000000000000009 RBX: ffff95ebf32d23c0 RCX: 
ffff95ebf00e5a00
[  512.147817] RDX: ffff95ebf32d2420 RSI: 0000000000000009 RDI: 
ffff95ebf0dffba0
[  512.147852] RBP: ffffb637002cfb70 R08: ffff95ebf6030240 R09: 
ffff95ebf1643180
[  512.147888] R10: ffff95ebf283b814 R11: ffffffffc0932500 R12: 
ffff95ebf040a300
[  512.147924] R13: ffff95ebf0dffba0 R14: ffff95ebf283b814 R15: 
0000000000000007
[  512.147961] FS:  00007fbbab3d2980(0000) GS:ffff95ebf7a80000(0000) 
knlGS:0000000000000000
[  512.148001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  512.148031] CR2: 00007fffca190ff8 CR3: 0000000232810006 CR4: 
00000000001606e0
[  512.148071] Call Trace:
[  512.148092]  action_fifos_exit+0x3240/0x37b0 [openvswitch]
[  512.148125]  ? update_sd_lb_stats+0x613/0x760
[  512.148152]  ? find_busiest_group+0x3e/0x520
[  512.148177]  ? __nla_validate_parse+0x57/0x8a0
[  512.148203]  ? _cond_resched+0x15/0x40
[  512.148226]  ? genl_family_rcv_msg_attrs_parse+0xe4/0x110
[  512.148256]  genl_rcv_msg+0x1ed/0x430
[  512.148303]  ? __switch_to_asm+0x34/0x70
[  512.148326]  ? __switch_to_asm+0x40/0x70
[  512.148349]  ? __switch_to_asm+0x34/0x70
[  512.148371]  ? __switch_to_asm+0x40/0x70
[  512.148394]  ? __switch_to_asm+0x34/0x70
[  512.148416]  ? __switch_to_asm+0x40/0x70
[  512.148439]  ? genl_family_rcv_msg_attrs_parse+0x110/0x110
[  512.148470]  netlink_rcv_skb+0x4a/0x110
[  512.148492]  genl_rcv+0x24/0x40
[  512.148512]  netlink_unicast+0x1a0/0x250
[  512.148536]  netlink_sendmsg+0x2b4/0x3b0
[  512.148560]  sock_sendmsg+0x5b/0x60
[  512.148582]  ___sys_sendmsg+0x278/0x2f0
[  512.148607]  ? file_update_time+0x60/0x130
[  512.148630]  ? pipe_write+0x286/0x400
[  512.148653]  ? new_sync_write+0x12d/0x1d0
[  512.148676]  ? __sys_sendmsg+0x5e/0xa0
[  512.148697]  __sys_sendmsg+0x5e/0xa0
[  512.148720]  do_syscall_64+0x52/0x1a0
[  512.148742]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  512.148771] RIP: 0033:0x7fbbaa6f9a6d
[  512.149622] Code: b9 20 00 00 75 10 b8 2e 00 00 00 0f 05 48 3d 01 f0 
ff ff 73 31 c3 48 83 ec 08 e8 fe f6 ff ff 48 89 04 24 b8 2e 00 00 00 0f 
05 <48> 8b 3c 24 48 89 c2 e8 47 f7 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[  512.151428] RSP: 002b:00007fffca1a1100 EFLAGS: 00000293 ORIG_RAX: 
000000000000002e
[  512.152349] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 
00007fbbaa6f9a6d
[  512.153266] RDX: 0000000000000000 RSI: 00007fffca1a1160 RDI: 
0000000000000010
[  512.154184] RBP: 0000000000f42680 R08: 0000000000000000 R09: 
00007fffca1a2118
[  512.155094] R10: 0000000000000008 R11: 0000000000000293 R12: 
00007fffca1a1f30
[  512.155992] R13: 00007fffca1a20c0 R14: 00007fffca1a1f38 R15: 
00007fffca1a15f0
[  512.156866] Modules linked in: vport_vxlan(E) vxlan(E) vport_gre(E) 
ip_gre(E) ip_tunnel(E) vport_geneve(E) geneve(E) ip6_udp_tunnel(E) 
udp_tunnel(E) openvswitch(E) nsh(E) nf_conncount(E) nf_nat_tftp(E) 
nf_conntrack_tftp(E) nf_nat_ftp(E) nf_conntrack_ftp(E) nf_nat(E) 
nf_conntrack_netlink(E) ip6table_filter(E) ip6_tables(E) 
iptable_filter(E) ip_tables(E) x_tables(E) ip6_gre(E) ip6_tunnel(E) 
tunnel6(E) gre(E) bonding(E) 8021q(E) garp(E) stp(E) mrp(E) llc(E) 
veth(E) nfnetlink_cttimeout(E) nfnetlink(E) nf_conntrack(E) 
nf_defrag_ipv6(E) nf_defrag_ipv4(E) binfmt_misc(E) intel_rapl_msr(E) 
snd_hda_codec_generic(E) ledtrig_audio(E) snd_hda_intel(E) 
snd_intel_nhlt(E) snd_hda_codec(E) intel_rapl_common(E) snd_hda_core(E) 
snd_hwdep(E) input_leds(E) snd_pcm(E) joydev(E) snd_timer(E) 
serio_raw(E) snd(E) soundcore(E) i2c_piix4(E) mac_hid(E) ib_iser(E) 
rdma_cm(E) iw_cm(E) ib_cm(E) ib_core(E) configfs(E) iscsi_tcp(E) 
libiscsi_tcp(E) libiscsi(E) scsi_transport_iscsi(E) autofs4(E) btrfs(E) 
zstd_decompress(E)
[  512.156899]  zstd_compress(E) raid10(E) raid456(E) 
async_raid6_recov(E) async_memcpy(E) async_pq(E) async_xor(E) 
async_tx(E) xor(E) raid6_pq(E) libcrc32c(E) raid1(E) raid0(E) 
multipath(E) linear(E) crct10dif_pclmul(E) crc32_pclmul(E) 
ghash_clmulni_intel(E) aesni_intel(E) crypto_simd(E) qxl(E) ttm(E) 
cryptd(E) glue_helper(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) 
sysimgblt(E) fb_sys_fops(E) psmouse(E) drm(E) pata_acpi(E) floppy(E) 
[last unloaded: nf_conntrack_ftp]
[  512.168488] ---[ end trace 26730810beeb11e1 ]---
[  512.169555] RIP: 0010:ovs_flow_tbl_remove+0x151/0x160 [openvswitch]
[  512.170638] Code: 55 f7 ea 89 f0 c1 f8 1f 29 c2 39 53 10 0f 8f 6a ff 
ff ff 48 89 ef d1 fe 5b 5d e9 8a ed ff ff 0f 0b 0f 0b b8 18 00 00 00 eb 
92 <0f> 0b 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57
[  512.172813] RSP: 0018:ffffb637002cf8c8 EFLAGS: 00010246
[  512.173897] RAX: 0000000000000009 RBX: ffff95ebf32d23c0 RCX: 
ffff95ebf00e5a00
[  512.174991] RDX: ffff95ebf32d2420 RSI: 0000000000000009 RDI: 
ffff95ebf0dffba0
[  512.176109] RBP: ffffb637002cfb70 R08: ffff95ebf6030240 R09: 
ffff95ebf1643180
[  512.177229] R10: ffff95ebf283b814 R11: ffffffffc0932500 R12: 
ffff95ebf040a300
[  512.178364] R13: ffff95ebf0dffba0 R14: ffff95ebf283b814 R15: 
0000000000000007
[  512.179530] FS:  00007fbbab3d2980(0000) GS:ffff95ebf7a80000(0000) 
knlGS:0000000000000000
[  512.180700] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  512.181885] CR2: 00007fffca190ff8 CR3: 0000000232810006 CR4: 
00000000001606e0

The code is hitting this:

static void tbl_mask_array_del_mask(struct flow_table *tbl,
                                     struct sw_flow_mask *mask)
{
         struct mask_array *ma = ovsl_dereference(tbl->mask_array);
         int i;

         /* Remove the deleted mask pointers from the array */
         for (i = 0; i < ma->count; i++) {
                 if (mask == ovsl_dereference(ma->masks[i]))
                         goto found;
         }

         BUG();   <----------------------------   Here

Pravin mentioned memory barrier usage in one of his replies. Perhaps 
that is an avenue to explore.

Thanks,

- Greg

