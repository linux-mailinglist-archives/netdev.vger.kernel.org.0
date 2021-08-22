Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C3A3F4120
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 21:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhHVTPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 15:15:06 -0400
Received: from mail.tintel.eu ([51.83.127.189]:60672 "EHLO mail.tintel.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhHVTPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 15:15:05 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Aug 2021 15:15:04 EDT
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id D8CB649A257E;
        Sun, 22 Aug 2021 21:06:58 +0200 (CEST)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id U60v3g-kLqM6; Sun, 22 Aug 2021 21:06:57 +0200 (CEST)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 7D5C84BEB7E9;
        Sun, 22 Aug 2021 21:06:57 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.tintel.eu 7D5C84BEB7E9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux-ipv6.be;
        s=502B7754-045F-11E5-BBC5-64595FD46BE8; t=1629659217;
        bh=uiCCh/yw+2jxGi6/G01t0DIPySEHU6RTnQWTOlyfBD0=;
        h=From:To:Message-ID:Date:MIME-Version;
        b=hfanWGI3A10yGgBDPG/uOIpS4YZ016j3CKI0HmIC3VZNThxtWWAN+Nw7ZavXJxhJI
         MH/W9qVLQ995iWPOM1bx58tvfzGinjVxI9HUw6ebmcvZGnTFri+RNok4Alhoaw4id5
         kslCR9ocE1XXjl0cyfoh+yDbPxC4uqh39aqYcGhE=
X-Virus-Scanned: amavisd-new at mail.tintel.eu
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id GJMYne0ppB4l; Sun, 22 Aug 2021 21:06:57 +0200 (CEST)
Received: from [IPv6:2001:67c:21bc:20::10] (unknown [IPv6:2001:67c:21bc:20::10])
        (Authenticated sender: stijn@tintel.eu)
        by mail.tintel.eu (Postfix) with ESMTPSA id 9E9D649A257E;
        Sun, 22 Aug 2021 21:06:56 +0200 (CEST)
From:   Stijn Tintel <stijn@linux-ipv6.be>
Subject: Seemingly random crashes with CONFIG_HARDENED_USERCOPY=y on ppc64be
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Message-ID: <f5d394e0-4022-5adb-ad5b-5e5048b1a2da@linux-ipv6.be>
Date:   Sun, 22 Aug 2021 22:06:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When CONFIG_HARDENED_USERCOPY=3Dy is enabled, I seem to be having random
crashes on a ppc64be system. The bug always triggers by OpenWrt's
firewall3, but in different parts of the netfilter code. See the traces
below. With the default firewall3 config, the system boots fine. Then
copying the config that triggers the crash, and calling firewall3, does
not trigger the crash. It only seems to trigger the crash when that
specific config is applied during boot. The randomness leads me to
believe the problem is in the CONFIG_HARDENED_USERCOPY* checks, but as
this is really over my head, I could use some guidance.

The device in question is a WatchGuard Firebox M300, based on NXP's
QorIQ T2081 SoC. The OpenWrt image is built from my OpenWrt staging tree
at [1]. I realize this is very OpenWrt specific, so if any additional
info is needed, I'll gladly supply it.


[   26.333649] usercopy: Kernel memory overwrite attempt detected to SLUB=
 object not in SLUB page?! (offset 0, size 8)!
[   26.344273] ------------[ cut here ]------------
[   26.348908] Kernel BUG at .usercopy_abort+0x94/0x9c [verbose debug inf=
o unavailable]
[   26.356667] Oops: Exception in kernel mode, sig: 5 [#1]
[   26.361899] BE PAGE_SIZE=3D4K SMP NR_CPUS=3D24 CoreNet Generic
[   26.367387] Modules linked in: xt_connlimit pppoe ppp_async nf_conncou=
nt l2tp_ppp iptable_nat cdc_mbim xt_state xt_nat xt_helper xt_conntrack x=
t_connmark xt_connbytes xt_REDIRECT xt_MASQUERADE xt_FLOWOFFLOAD xt_CT wi=
reguard pppox ppp
_generic nft_redir nft_ct nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat=
_pptp nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda nf_nat nf_flow_tabl=
e nf_conntrack_tftp nf_conntrack_snmp nf_conntrack_sip nf_conntrack_pptp =
nf_conntrack_netl
ink nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp nf_conntrack_broa=
dcast nf_conntrack_amanda nf_conntrack libchacha20poly1305 libblake2s ipt=
_REJECT cdc_ncm cdc_ether xt_time xt_tcpudp xt_tcpmss xt_string xt_statis=
tic xt_recent xt_quota xt_policy xt_pkttype xt_physdev xt_owner xt_multip=
ort xt_mark xt_mac xt_limit xt_length xt_hl xt_esp xt_ecn xt_dscp xt_comm=
ent xt_cgroup xt_bpf xt_addrtype xt_TRACE xt_TCPMSS xt_NFQUEUE xt_LOG xt_=
HL xt_DSCP xt_CLASSIFY xfrm_interface w83793 usbnet ts_kmp ts_fsm ts_bm s=
lhc sch_cake ptp_qoriq
[   26.367603]  nft_reject_ipv6 nft_reject_ipv4 nft_reject_inet nft_rejec=
t_bridge nft_reject nft_quota nft_objref nft_numgen nft_meta_bridge nft_l=
og nft_limit nft_hash nft_fwd_netdev nft_dup_netdev nft_counter nfnetlink=
_queue nf_tables nf_reject_ipv4 nf_log_ipv4 nf_dup_netdev nf_defrag_ipv6 =
nf_defrag_ipv4 macvlan libpoly1305 libcurve25519_generic libcrc32c libcha=
cha libblake2s_generic iptable_raw iptable_mangle iptable_filter ipt_ah i=
pt_ECN ip6table_raw ip_tables crc_ccitt cdc_wdm br_netfilter sch_tbf sch_=
ingress sch_htb sch_hfsc em_u32 cls_u32 cls_tcindex cls_route cls_matchal=
l cls_fw cls_flow cls_basic act_skbedit act_mirred act_gact i2c_dev xt_se=
t ip_set_list_set ip_set_hash_netportnet ip_set_hash_netport ip_set_hash_=
netnet ip_set_hash_netiface ip_set_hash_net ip_set_hash_mac ip_set_hash_i=
pportnet ip_set_hash_ipportip ip_set_hash_ipport ip_set_hash_ipmark ip_se=
t_hash_ip ip_set_bitmap_port ip_set_bitmap_ipmac ip_set_bitmap_ip ip_set =
nfnetlink nf_log_ipv6 nf_log_common ip6table_mangle
[   26.455354]  ip6table_filter ip6_tables ip6t_REJECT x_tables nf_reject=
_ipv6 hwmon_vid ifb sit l2tp_netlink l2tp_core udp_tunnel ip6_udp_tunnel =
ipcomp6 xfrm6_tunnel esp6 ah6 xfrm4_tunnel ipcomp esp4 ah4 netlink_diag t=
unnel6 tunnel4 ip_tunnel xfrm_user xfrm_ipcomp af_key xfrm_algo crypto_us=
er algif_skcipher algif_rng algif_hash algif_aead af_alg sha512_generic s=
ha256_generic libsha256 sha1_generic seqiv jitterentropy_rng drbg md5 hma=
c echainiv deflate zlib_inflate cbc crypto_acompress leds_gpio rtc_rs5c37=
2 ehci_platform tpm_i2c_atmel i2c_core ptp mii tpm
[   26.591596] CPU: 5 PID: 5633 Comm: fw3 Not tainted 5.10.60 #0
[   26.597357] NIP:  c000000000203f38 LR: c000000000203f34 CTR: c00000000=
0038560
[   26.604503] REGS: c00000008d9c3550 TRAP: 0700   Not tainted  (5.10.60)=

[   26.611035] MSR:  0000000080029002 <CE,EE,ME>  CR: 28004248  XER: 2000=
0000
[   26.617924] IRQMASK: 0
[   26.617924] GPR00: c000000000203f34 c00000008d9c37e0 c000000000c6d400 =
0000000000000068
[   26.617924] GPR04: c0000000ffea0678 c0000000ffea5f40 0000000000000027 =
c0000000ffea0680
[   26.617924] GPR08: 0000000000000023 0000000000000000 0000000000000000 =
0000000000000001
[   26.617924] GPR12: 0000000024004448 c00000003fffdc40 0000000000000000 =
0000000000000000
[   26.617924] GPR16: 0000000000000000 0000000000000000 00003fff9d113880 =
00003fff9d20bb80
[   26.617924] GPR20: 0000000017c8a640 00003fff9d1137e0 0000000000000009 =
0000000000000001
[   26.617924] GPR24: 0000000000000000 00003ffff411d430 c0000000831b64e0 =
0000000000000008
[   26.617924] GPR28: 8000000001000008 0000000000000000 0000000000000008 =
8000000001000000
[   26.684450] NIP [c000000000203f38] .usercopy_abort+0x94/0x9c
[   26.690109] LR [c000000000203f34] .usercopy_abort+0x90/0x9c
[   26.695679] Call Trace:
[   26.698122] [c00000008d9c37e0] [c000000000203f34] .usercopy_abort+0x90=
/0x9c (unreliable)
[   26.706225] [c00000008d9c3860] [c0000000001f1820] .__check_heap_object=
+0x170/0x190
[   26.713800] [c00000008d9c38d0] [c0000000002040c0] .__check_object_size=
+0x180/0x1f0
[   26.721384] [c00000008d9c3960] [80000000004244f4] .ip_set_sockfn_get+0=
xb4/0x380 [ip_set]
[   26.729482] [c00000008d9c3a10] [c000000000774b18] .nf_getsockopt+0x78/=
0xf0
[   26.736368] [c00000008d9c3ab0] [c000000000788a3c] .ip_getsockopt+0xcc/=
0x120
[   26.743340] [c00000008d9c3b50] [c0000000007c358c] .raw_getsockopt+0x10=
c/0x1a0
[   26.750490] [c00000008d9c3be0] [c0000000006a0d1c] .sock_common_getsock=
opt+0x2c/0x40
[   26.758152] [c00000008d9c3c50] [c00000000069f240] .__sys_getsockopt+0x=
a0/0x220
[   26.765380] [c00000008d9c3d00] [c00000000069f3dc] .__se_sys_getsockopt=
+0x1c/0x30
[   26.772784] [c00000008d9c3d70] [c00000000000fb5c] .system_call_excepti=
on+0x11c/0x220
[   26.780534] [c00000008d9c3e20] [c000000000000678] system_call_common+0=
xf8/0x200
[   26.787848] --- interrupt: c00 at 0x3fff9d25915c
[   26.787848]     LR =3D 0x100077e4
[   26.795592] Instruction dump:
[   26.798558] 392929d0 48000014 3d02ffd5 3908ee40 7d074378 7d094378 f8c1=
0070 7c661b78
[   26.806319] 3c62ffd5 38639ae0 4be9abf5 60000000 <0fe00000> 60000000 3d=
22ffde 81298ab8
[   26.814258] ---[ end trace 70b7c82100ca71f1 ]---


[=C2=A0=C2=A0 29.817617] usercopy: Kernel memory exposure attempt detecte=
d from
SLUB object not in SLUB page?! (offset 0, size 8912)!
[=C2=A0=C2=A0 29.834303] ------------[ cut here ]------------
[=C2=A0=C2=A0 29.838922] kernel BUG at mm/usercopy.c:99!
[=C2=A0=C2=A0 29.843104] Oops: Exception in kernel mode, sig: 5 [#1]
[=C2=A0=C2=A0 29.848330] BE PAGE_SIZE=3D4K SMP NR_CPUS=3D24 CoreNet Gener=
ic
[=C2=A0=C2=A0 29.853813] Modules linked in: xt_connlimit pppoe ppp_async
nf_conncount l2tp_ppp iptable_nat cdc_mbim xt_state xt_nat xt_helper
xt_conntrack xt_connmark xt_connbytes xt_REDIRECT xt_MASQUERADE
xt_FLOWOFFLOAD
=C2=A0xt_CT wireguard pppox ppp_generic nft_redir nft_ct nf_nat_tftp
nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_irc nf_nat_h323
nf_nat_ftp nf_nat_amanda nf_nat nf_flow_table nf_conntrack_tftp
nf_conntrack_snmp
nf_conntrack_sip nf_conntrack_pptp nf_conntrack_netlink nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp nf_conntrack_broadcast
nf_conntrack_amanda nf_conntrack libchacha20poly1305 libblake2s
ipt_REJECT cdc_
ncm cdc_ether xt_time xt_tcpudp xt_tcpmss xt_string xt_statistic
xt_recent xt_quota xt_policy xt_pkttype xt_physdev xt_owner xt_multiport
xt_mark xt_mac xt_limit xt_length xt_hl xt_esp xt_ecn xt_dscp xt_comment
=C2=A0xt_cgroup xt_bpf xt_addrtype xt_TRACE xt_TCPMSS xt_NFQUEUE xt_LOG x=
t_HL
xt_DSCP xt_CLASSIFY xfrm_interface w83793 usbnet ts_kmp ts_fsm ts_bm
slhc sch_cake ptp_qoriq
[=C2=A0=C2=A0 29.854028]=C2=A0 nft_reject_ipv6 nft_reject_ipv4 nft_reject=
_inet
nft_reject_bridge nft_reject nft_quota nft_objref nft_numgen
nft_meta_bridge nft_log nft_limit nft_hash nft_fwd_netdev nft_dup_netdev
nft_counter
nfnetlink_queue nf_tables nf_reject_ipv4 nf_log_ipv4 nf_dup_netdev
nf_defrag_ipv6 nf_defrag_ipv4 macvlan libpoly1305 libcurve25519_generic
libcrc32c libchacha libblake2s_generic iptable_raw iptable_mangle iptab
le_filter ipt_ah ipt_ECN ip6table_raw ip_tables crc_ccitt cdc_wdm
br_netfilter sch_tbf sch_ingress sch_htb sch_hfsc em_u32 cls_u32
cls_tcindex cls_route cls_matchall cls_fw cls_flow cls_basic act_skbedit
act_mi
rred act_gact i2c_dev xt_set ip_set_list_set ip_set_hash_netportnet
ip_set_hash_netport ip_set_hash_netnet ip_set_hash_netiface
ip_set_hash_net ip_set_hash_mac ip_set_hash_ipportnet
ip_set_hash_ipportip ip_set_
hash_ipport ip_set_hash_ipmark ip_set_hash_ip ip_set_bitmap_port
ip_set_bitmap_ipmac ip_set_bitmap_ip ip_set nfnetlink nf_log_ipv6
nf_log_common ip6table_mangle
[=C2=A0=C2=A0 29.941760]=C2=A0 ip6table_filter ip6_tables ip6t_REJECT x_t=
ables
nf_reject_ipv6 hwmon_vid ifb sit l2tp_netlink l2tp_core udp_tunnel
ip6_udp_tunnel ipcomp6 xfrm6_tunnel esp6 ah6 xfrm4_tunnel ipcomp esp4
ah4 netli
nk_diag tunnel6 tunnel4 ip_tunnel xfrm_user xfrm_ipcomp af_key xfrm_algo
crypto_user algif_skcipher algif_rng algif_hash algif_aead af_alg
sha512_generic sha256_generic libsha256 sha1_generic seqiv jitterentrop
y_rng drbg md5 hmac echainiv deflate zlib_inflate cbc crypto_acompress
leds_gpio rtc_rs5c372 ehci_platform tpm_i2c_atmel i2c_core ptp mii tpm
[=C2=A0=C2=A0 30.077962] CPU: 5 PID: 5314 Comm: iptables Not tainted 5.10=
=2E60 #0
[=C2=A0=C2=A0 30.084144] NIP:=C2=A0 c000000000203f68 LR: c000000000203f64=
 CTR:
c0000000000087e0
[=C2=A0=C2=A0 30.091280] REGS: c00000008733b3f0 TRAP: 0700=C2=A0=C2=A0 No=
t tainted=C2=A0 (5.10.60)
[=C2=A0=C2=A0 30.097807] MSR:=C2=A0 0000000080029002 <CE,EE,ME>=C2=A0 CR:=
 28002448=C2=A0 XER:
00000000
[=C2=A0=C2=A0 30.104695] IRQMASK: 0
[=C2=A0=C2=A0 30.104695] GPR00: c000000000203f64 c00000008733b680 c000000=
000c70400
000000000000006c
[=C2=A0=C2=A0 30.104695] GPR04: c0000000ffea0678 c0000000ffea5f40 0000000=
000000027
c0000000ffea0680
[=C2=A0=C2=A0 30.104695] GPR08: 0000000000000023 0000000000000000 0000000=
000000000
0000000000000001
[=C2=A0=C2=A0 30.104695] GPR12: 0000000024002842 c00000003fffdc40 0000000=
000000028
0000000000700098
[=C2=A0=C2=A0 30.104695] GPR16: 0000000000000000 0000000000000040 0000000=
017e64b92
0000000010031d60
[=C2=A0=C2=A0 30.104695] GPR20: 0000000017e64a00 0000000017e64700 c000000=
000bb8700
c000000000c79d38
[=C2=A0=C2=A0 30.104695] GPR24: 0000000017e8ff80 00000000000022d0 c000000=
000bb8700
0000000000000018
[=C2=A0=C2=A0 30.104695] GPR28: 80000000010042d0 0000000000000001 0000000=
0000022d0
8000000001002000
[=C2=A0=C2=A0 30.171224] NIP [c000000000203f68] .usercopy_abort+0x94/0x9c=

[=C2=A0=C2=A0 30.176883] LR [c000000000203f64] .usercopy_abort+0x90/0x9c
[=C2=A0=C2=A0 30.182455] Call Trace:
[=C2=A0=C2=A0 30.184900] [c00000008733b680] [c000000000203f64]
=2Eusercopy_abort+0x90/0x9c (unreliable)
[=C2=A0=C2=A0 30.193002] [c00000008733b700] [c0000000001f1850]
=2E__check_heap_object+0x170/0x190
[=C2=A0=C2=A0 30.200578] [c00000008733b770] [c0000000002040f0]
=2E__check_object_size+0x180/0x1f0
[=C2=A0=C2=A0 30.208160] [c00000008733b800] [8000000000403ee4]
=2E__do_replace+0x2d4/0x3b0 [ip_tables]
[=C2=A0=C2=A0 30.216170] [c00000008733b8d0] [8000000000405d7c]
=2Edo_ipt_set_ctl+0x48c/0x530 [ip_tables]
[=C2=A0=C2=A0 30.224355] [c00000008733b9d0] [c000000000774bf4]
=2Enf_setsockopt+0x84/0x100
[=C2=A0=C2=A0 30.231329] [c00000008733ba70] [c00000000078a0b4]
=2Eip_setsockopt+0x524/0x1920
[=C2=A0=C2=A0 30.238475] [c00000008733bb60] [c0000000007c36dc]
=2Eraw_setsockopt+0xdc/0x110
[=C2=A0=C2=A0 30.245537] [c00000008733bbf0] [c0000000006a0dfc]
=2Esock_common_setsockopt+0x2c/0x40
[=C2=A0=C2=A0 30.253200] [c00000008733bc60] [c00000000069f06c]
=2E__sys_setsockopt+0xbc/0x1e0
[=C2=A0=C2=A0 30.260428] [c00000008733bd00] [c00000000069f1b0]
=2E__se_sys_setsockopt+0x20/0x30
[=C2=A0=C2=A0 30.267831] [c00000008733bd70] [c00000000000fb5c]
=2Esystem_call_exception+0x11c/0x220
[=C2=A0=C2=A0 30.275581] [c00000008733be20] [c000000000000678]
system_call_common+0xf8/0x200
[=C2=A0=C2=A0 30.282895] --- interrupt: c00 at 0x3fffaa864714
[=C2=A0=C2=A0 30.282895]=C2=A0=C2=A0=C2=A0=C2=A0 LR =3D 0x3fffaa7815a0
[=C2=A0=C2=A0 30.290987] Instruction dump:
[=C2=A0=C2=A0 30.293953] 39290e90 48000014 3d02ffd5 3908d1c0 7d074378 7d0=
94378
f8c10070 7c661b78
[=C2=A0=C2=A0 30.301715] 3c62ffd4 38637a80 4be9abf5 60000000 <0fe00000> 6=
0000000
3d22ffde 81298838
[=C2=A0=C2=A0 30.309654] ---[ end trace 924262dfe54d8433 ]---


[=C2=A0=C2=A0 36.560294] usercopy: Kernel memory exposure attempt detecte=
d from
SLUB object not in SLUB page?! (offset 0, size 8880)!
[=C2=A0=C2=A0 36.575184] ------------[ cut here ]------------
[=C2=A0=C2=A0 36.579801] kernel BUG at mm/usercopy.c:99!
[=C2=A0=C2=A0 36.583984] Oops: Exception in kernel mode, sig: 5 [#1]
[=C2=A0=C2=A0 36.589209] BE PAGE_SIZE=3D4K SMP NR_CPUS=3D24 CoreNet Gener=
ic
[=C2=A0=C2=A0 36.594692] Modules linked in: xt_connlimit pppoe ppp_async
nf_conncount l2tp_ppp iptable_nat cdc_mbim xt_state xt_nat xt_helper
xt_conntrack xt_connmark xt_connbytes xt_REDIRECT xt_MASQUERADE
xt_FLOWOFFLOAD
=C2=A0xt_CT wireguard pppox ppp_generic nft_redir nft_ct nf_nat_tftp
nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_irc nf_nat_h323
nf_nat_ftp nf_nat_amanda nf_nat nf_flow_table nf_conntrack_tftp
nf_conntrack_snmp
nf_conntrack_sip nf_conntrack_pptp nf_conntrack_netlink nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp nf_conntrack_broadcast
nf_conntrack_amanda nf_conntrack libchacha20poly1305 libblake2s
ipt_REJECT cdc_
ncm cdc_ether xt_time xt_tcpudp xt_tcpmss xt_string xt_statistic
xt_recent xt_quota xt_policy xt_pkttype xt_physdev xt_owner xt_multiport
xt_mark xt_mac xt_limit xt_length xt_hl xt_esp xt_ecn xt_dscp xt_comment
=C2=A0xt_cgroup xt_bpf xt_addrtype xt_TRACE xt_TCPMSS xt_NFQUEUE xt_LOG x=
t_HL
xt_DSCP xt_CLASSIFY xfrm_interface w83793 usbnet ts_kmp ts_fsm ts_bm
slhc sch_cake ptp_qoriq
[=C2=A0=C2=A0 36.594911]=C2=A0 nft_reject_ipv6 nft_reject_ipv4 nft_reject=
_inet
nft_reject_bridge nft_reject nft_quota nft_objref nft_numgen
nft_meta_bridge nft_log nft_limit nft_hash nft_fwd_netdev nft_dup_netdev
nft_counter
nfnetlink_queue nf_tables nf_reject_ipv4 nf_log_ipv4 nf_dup_netdev
nf_defrag_ipv6 nf_defrag_ipv4 macvlan libpoly1305 libcurve25519_generic
libcrc32c libchacha libblake2s_generic iptable_raw iptable_mangle iptab
le_filter ipt_ah ipt_ECN ip6table_raw ip_tables crc_ccitt cdc_wdm
br_netfilter sch_tbf sch_ingress sch_htb sch_hfsc em_u32 cls_u32
cls_tcindex cls_route cls_matchall cls_fw cls_flow cls_basic act_skbedit
act_mi
rred act_gact i2c_dev xt_set ip_set_list_set ip_set_hash_netportnet
ip_set_hash_netport ip_set_hash_netnet ip_set_hash_netiface
ip_set_hash_net ip_set_hash_mac ip_set_hash_ipportnet
ip_set_hash_ipportip ip_set_
hash_ipport ip_set_hash_ipmark ip_set_hash_ip ip_set_bitmap_port
ip_set_bitmap_ipmac ip_set_bitmap_ip ip_set nfnetlink nf_log_ipv6
nf_log_common ip6table_mangle
[=C2=A0=C2=A0 36.682648]=C2=A0 ip6table_filter ip6_tables ip6t_REJECT x_t=
ables
nf_reject_ipv6 hwmon_vid ifb sit l2tp_netlink l2tp_core udp_tunnel
ip6_udp_tunnel ipcomp6 xfrm6_tunnel esp6 ah6 xfrm4_tunnel ipcomp esp4
ah4 netli
nk_diag tunnel6 tunnel4 ip_tunnel xfrm_user xfrm_ipcomp af_key xfrm_algo
crypto_user algif_skcipher algif_rng algif_hash algif_aead af_alg
sha512_generic sha256_generic libsha256 sha1_generic seqiv jitterentrop
y_rng drbg md5 hmac echainiv deflate zlib_inflate cbc crypto_acompress
leds_gpio rtc_rs5c372 ehci_platform tpm_i2c_atmel i2c_core ptp mii tpm
[=C2=A0=C2=A0 36.818853] CPU: 5 PID: 5145 Comm: fw3 Not tainted 5.10.60 #=
0
[=C2=A0=C2=A0 36.824599] NIP:=C2=A0 c000000000203f68 LR: c000000000203f64=
 CTR:
c0000000000087e0
[=C2=A0=C2=A0 36.831736] REGS: c000000083337430 TRAP: 0700=C2=A0=C2=A0 No=
t tainted=C2=A0 (5.10.60)
[=C2=A0=C2=A0 36.838263] MSR:=C2=A0 0000000080029002 <CE,EE,ME>=C2=A0 CR:=
 28002448=C2=A0 XER:
00000000
[=C2=A0=C2=A0 36.845153] IRQMASK: 0
[=C2=A0=C2=A0 36.845153] GPR00: c000000000203f64 c0000000833376c0 c000000=
000c70400
000000000000006c
[=C2=A0=C2=A0 36.845153] GPR04: c0000000ffea0678 c0000000ffea5f40 0000000=
000000027
c0000000ffea0680
[=C2=A0=C2=A0 36.845153] GPR08: 0000000000000023 0000000000000000 0000000=
000000000
fffffffffffea968
[=C2=A0=C2=A0 36.845153] GPR12: 0000000024002842 c00000003fffdc40 0000000=
000000028
0000000000a800d0
[=C2=A0=C2=A0 36.845153] GPR16: 0000000000000000 0000000000000040 00003ff=
f847a2860
0000000046a8c240
[=C2=A0=C2=A0 36.845153] GPR20: 00000000469ed0c0 0000000046affc60 0000000=
046adbf70
c000000000c79d38
[=C2=A0=C2=A0 36.845153] GPR24: 0000000046adc220 00000000000022b0 c000000=
000bb8700
0000000000000018
[=C2=A0=C2=A0 36.845153] GPR28: 80000000010042b0 0000000000000001 0000000=
0000022b0
8000000001002000
[=C2=A0=C2=A0 36.911686] NIP [c000000000203f68] .usercopy_abort+0x94/0x9c=

[=C2=A0=C2=A0 36.917345] LR [c000000000203f64] .usercopy_abort+0x90/0x9c
[=C2=A0=C2=A0 36.922917] Call Trace:
[=C2=A0=C2=A0 36.925361] [c0000000833376c0] [c000000000203f64]
=2Eusercopy_abort+0x90/0x9c (unreliable)
[=C2=A0=C2=A0 36.933463] [c000000083337740] [c0000000001f1850]
=2E__check_heap_object+0x170/0x190
[=C2=A0=C2=A0 36.941038] [c0000000833377b0] [c0000000002040f0]
=2E__check_object_size+0x180/0x1f0
[=C2=A0=C2=A0 36.948618] [c000000083337840] [8000000000677504]
=2E__do_replace+0x2d4/0x3b0 [ip6_tables]
[=C2=A0=C2=A0 36.956715] [c000000083337910] [8000000000679abc]
=2Edo_ip6t_set_ctl+0x48c/0x530 [ip6_tables]
[=C2=A0=C2=A0 36.965074] [c000000083337a10] [c000000000774bf4]
=2Enf_setsockopt+0x84/0x100
[=C2=A0=C2=A0 36.972048] [c000000083337ab0] [c00000000085e498]
=2Eipv6_setsockopt+0x128/0x130
[=C2=A0=C2=A0 36.979280] [c000000083337b50] [c000000000868f18]
=2Erawv6_setsockopt+0x58/0x290
[=C2=A0=C2=A0 36.986518] [c000000083337bf0] [c0000000006a0dfc]
=2Esock_common_setsockopt+0x2c/0x40
[=C2=A0=C2=A0 36.994179] [c000000083337c60] [c00000000069f06c]
=2E__sys_setsockopt+0xbc/0x1e0
[=C2=A0=C2=A0 37.001407] [c000000083337d00] [c00000000069f1b0]
=2E__se_sys_setsockopt+0x20/0x30
[=C2=A0=C2=A0 37.008812] [c000000083337d70] [c00000000000fb5c]
=2Esystem_call_exception+0x11c/0x220
[=C2=A0=C2=A0 37.016561] [c000000083337e20] [c000000000000678]
system_call_common+0xf8/0x200
[=C2=A0=C2=A0 37.023876] --- interrupt: c00 at 0x3fff8490e714
[=C2=A0=C2=A0 37.023876]=C2=A0=C2=A0=C2=A0=C2=A0 LR =3D 0x3fff847fa738
[=C2=A0=C2=A0 37.031969] Instruction dump:
[=C2=A0=C2=A0 37.034934] 39290e90 48000014 3d02ffd5 3908d1c0 7d074378 7d0=
94378
f8c10070 7c661b78
[=C2=A0=C2=A0 37.042696] 3c62ffd4 38637a80 4be9abf5 60000000 <0fe00000> 6=
0000000
3d22ffde 81298838
[=C2=A0=C2=A0 37.050636] ---[ end trace 1a74d40a19fa7b96 ]---

Thanks,
Stijn

[1]
https://git.openwrt.org/?p=3Dopenwrt/staging/stintel.git;a=3Dshortlog;h=3D=
refs/heads/qoriq


