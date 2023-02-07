Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC65768D4E6
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbjBGKx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBGKx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:53:58 -0500
X-Greylist: delayed 510 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Feb 2023 02:53:53 PST
Received: from serv108.segi.ulg.ac.be (serv108.segi.ulg.ac.be [139.165.32.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7732010C8;
        Tue,  7 Feb 2023 02:53:53 -0800 (PST)
Received: from [192.168.1.33] (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id B8158200DFA9;
        Tue,  7 Feb 2023 11:45:11 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be B8158200DFA9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1675766711;
        bh=zk/5ymI41+o8BwSpQ+4gcsolAQhEhxYXO4xJ38g2jOs=;
        h=Date:To:From:Subject:Cc:From;
        b=X0wPNKj2vsByhCzohgz7SN4/s6ROE028HNR058vsjlt7kbuO0uFZqazuyUnxC6lL6
         18VoV8zbVZ5VmsczPWtqPvm5bbv0/JnINxnbCK6ZEmaXjulM5876cUNpN9xGcsLEMw
         sl0ctg7GEOEpHZNXpFEBJNYxI2WRTEcFeK2WVGkpHrAJCQoXjTXurWJ3l/nkg34/27
         2r3/39WHF1pXUmn9is9Jiac+BMNunaoUflh5MoYJsQwvpOqo5hHfE9vzy1fPGECGid
         zl3lUScDgbGohRMRaSehWuLNGymfYzo4CXNT7EgUFgPQPAJ8JnlglgIhp2YECJQOkv
         DCykXMHfCUPCg==
Message-ID: <d1440852-3a3b-7b46-6ad6-a06cd5a3fb62@uliege.be>
Date:   Tue, 7 Feb 2023 11:45:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     bpf@vger.kernel.org
From:   Justin Iurman <justin.iurman@uliege.be>
Subject: [QUESTION] bpf, iproute2/tc: verifier fails because of a map
Cc:     netdev@vger.kernel.org, justin.iurman@uliege.be
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

CC'ing netdev as well, since I initially suspected an issue in iproute2. 
However, after having recompiled iproute2 with libbpf, I'm still stuck 
facing the same problem.

Environment:
  - OS: Ubuntu 20.04.5 LTS
  - kernel: 5.4.0-137-generic x86_64 (CONFIG_DEBUG_INFO_BTF=y)
  - clang version 10.0.0-4ubuntu1
  - iproute2-6.1.0, libbpf 1.2.0 (iproute2-ss200127 installed by default 
without libbpf)

Note: same result with kernel 6.2.0-rc6+ (net-next), as a test to be 
aligned with latest iproute2 version (just in case).

Long story short: I can't for the life of me make the ebpf program load 
correctly with tc. What's the cause? Well, a map, and the verifier 
doesn't like it. I must definitely be doing something wrong, but can't 
find what. Here is a reproducible and minimal example:

#include "vmlinux.h"
#include <bpf/bpf_helpers.h>

#define TC_ACT_OK 0
#define MAX_BYTES 2048

char _license[] SEC("license") = "GPL";

struct mystruct_t {
	__u8 bytes[MAX_BYTES];
};

struct {
	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
	__uint(key_size, sizeof(__u8));
	__uint(value_size, sizeof(struct mystruct_t));
	__uint(max_entries, 1);
} percpu_map SEC(".maps");

SEC("egress")
int xxx(struct __sk_buff *skb)
{
	__u8 idx = 0;
	struct mystruct_t *x = bpf_map_lookup_elem(&percpu_map, &idx);
	return TC_ACT_OK;
}


Here is how I compile the whole thing:

git clone --recursive --depth 1 https://github.com/libbpf/libbpf 
./deps/libbpf
make -j -C deps/libbpf/src/ BUILD_STATIC_ONLY=y DESTDIR="build" 
INCLUDEDIR= LIBDIR= UAPIDIR= install

git clone --recursive --depth 1 https://github.com/libbpf/bpftool 
./deps/bpftool
make -j -C deps/bpftool/src/
deps/bpftool/src/bpftool btf dump file /sys/kernel/btf/vmlinux format c 
 > build/vmlinux.h

clang -g -O2 -Wall -Wextra -target bpf -D__TARGET_ARCH_x86_64 -I build/ 
-c program.c -o build/program.o


I noticed that "clang-bpf-co-re" is OFF when compiling bpftool, don't 
know if it's part of the problem or not. Here is what the "build" 
directory looks like after that:

$ ls -al build
[...]
drwxr-xr-x 2 justin justin    4096 fév  6 18:20 bpf
-rw-rw-r-- 1 justin justin 3936504 fév  6 18:20 libbpf.a
drwxr-xr-x 2 justin justin    4096 fév  6 18:20 pkgconfig
-rw-rw-r-- 1 justin justin   10592 fév  7 10:42 program.o
-rw-rw-r-- 1 justin justin 2467774 fév  7 10:42 vmlinux.h


And here is the verifier error I got when loading it with tc (qdisc 
clsact already attached):

$ sudo ../deps/iproute2/tc/tc filter add dev eno2 egress bpf da obj 
program.o sec egress

libbpf: map 'percpu_map': failed to create: Invalid argument(-22)
libbpf: failed to load object 'program.o'
Unable to load program


If I compile without the -g, of course it complains about 
missing/corrupted BTF. I received a little bit more info with "legacy" 
(= w/o libbpf) iproute2 (iproute2-ss200127):

$ sudo tc filter add dev eno2 egress bpf da obj program.o sec egress

BTF debug data section '.BTF' rejected: Invalid argument (22)!
  - Length:       1628
Verifier analysis:

magic: 0xeb9f
version: 1
flags: 0x0
hdr_len: 24
type_off: 0
type_len: 948
str_off: 948
str_len: 656
btf_total_size: 1628
[1] STRUCT (anon) size=32 vlen=4
	type type_id=2 bits_offset=0
	key_size type_id=6 bits_offset=64
	value_size type_id=8 bits_offset=128
	max_entries type_id=6 bits_offset=192
[2] PTR (anon) type_id=4
[3] INT int size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
[4] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=6
[5] INT __ARRAY_SIZE_TYPE__ size=4 bits_offset=0 nr_bits=32 encoding=(none)
[6] PTR (anon) type_id=7
[7] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=1
[8] PTR (anon) type_id=9
[9] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=2048
[10] VAR percpu_map type_id=1 linkage=1
[11] PTR (anon) type_id=12
[12] STRUCT __sk_buff size=176 vlen=31
	len type_id=13 bits_offset=0
	pkt_type type_id=13 bits_offset=32
	mark type_id=13 bits_offset=64
	queue_mapping type_id=13 bits_offset=96
	protocol type_id=13 bits_offset=128
	vlan_present type_id=13 bits_offset=160
	vlan_tci type_id=13 bits_offset=192
	vlan_proto type_id=13 bits_offset=224
	priority type_id=13 bits_offset=256
	ingress_ifindex type_id=13 bits_offset=288
	ifindex type_id=13 bits_offset=320
	tc_index type_id=13 bits_offset=352
	cb type_id=15 bits_offset=384
	hash type_id=13 bits_offset=544
	tc_classid type_id=13 bits_offset=576
	data type_id=13 bits_offset=608
	data_end type_id=13 bits_offset=640
	napi_id type_id=13 bits_offset=672
	family type_id=13 bits_offset=704
	remote_ip4 type_id=13 bits_offset=736
	local_ip4 type_id=13 bits_offset=768
	remote_ip6 type_id=16 bits_offset=800
	local_ip6 type_id=16 bits_offset=928
	remote_port type_id=13 bits_offset=1056
	local_port type_id=13 bits_offset=1088
	data_meta type_id=13 bits_offset=1120
	(anon) type_id=17 bits_offset=1152
	tstamp type_id=19 bits_offset=1216
	wire_len type_id=13 bits_offset=1280
	gso_segs type_id=13 bits_offset=1312
	(anon) type_id=21 bits_offset=1344
[13] TYPEDEF __u32 type_id=14
[14] INT unsigned int size=4 bits_offset=0 nr_bits=32 encoding=(none)
[15] ARRAY (anon) type_id=13 index_type_id=5 nr_elems=5
[16] ARRAY (anon) type_id=13 index_type_id=5 nr_elems=4
[17] UNION (anon) size=8 vlen=1
	flow_keys type_id=18 bits_offset=0
[18] PTR (anon) type_id=30
[19] TYPEDEF __u64 type_id=20
[20] INT long long unsigned int size=8 bits_offset=0 nr_bits=64 
encoding=(none)
[21] UNION (anon) size=8 vlen=1
	sk type_id=22 bits_offset=0
[22] PTR (anon) type_id=31
[23] FUNC_PROTO (anon) return=3 args=(11 skb)
[24] FUNC xxx type_id=23 vlen != 0

Prog section 'egress' rejected: Permission denied (13)!
  - Type:         3
  - Instructions: 13 (0 over limit)
  - License:      GPL

Verifier analysis:

0: (b7) r1 = 0
1: (73) *(u8 *)(r10 -1) = r1
last_idx 1 first_idx 0
regs=2 stack=0 before 0: (b7) r1 = 0
2: (bf) r2 = r10
3: (07) r2 += -1
4: (18) r1 = 0x0
6: (85) call bpf_map_lookup_elem#1
R1 type=inv expected=map_ptr
processed 6 insns (limit 1000000) max_states_per_insn 0 total_states 0 
peak_states 0 mark_read 0

Error fetching program/map!
Unable to load program


So here, basically, the call to bpf_map_lookup_elem fails because the 
first argument is not a map_ptr (obviously r1 = 0x0), which is why I 
suspected some difference with iproute2. However, it looks like it is 
the same with iproute2 compiled with libbpf (is it?). But I don't know 
if it's reliable because that error appears when using tc w/o libbpf. As 
a FYI, I had the exact same issue with a global variable that I do not 
need anymore, by the way.

My question is the following: what am I doing wrong? I'm not that used 
to ebpf programming, so there must be something I'm missing.
