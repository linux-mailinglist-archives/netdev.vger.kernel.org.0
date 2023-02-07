Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BE668E162
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 20:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjBGTnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 14:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBGTnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 14:43:33 -0500
Received: from serv108.segi.ulg.ac.be (serv108.segi.ulg.ac.be [139.165.32.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CBA3BD8A;
        Tue,  7 Feb 2023 11:43:28 -0800 (PST)
Received: from [192.168.1.33] (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 5CD38200DB93;
        Tue,  7 Feb 2023 20:43:21 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 5CD38200DB93
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1675799001;
        bh=ZTMUX6X1J/XABDFmvs+Lpwp33RpNaWNr2W0qLXyiHQw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IbueBcFXcbMKDG3UgIhGHwETSy6qj5Nm6y//gwCk8dH3ojzwmw5gVR6w0pgKcGPw3
         ce8X8sIvoo8VSbNqMpwqHo2KKKc07Y0X+9AMAoJB2Gte/hPf6Ez+/pWTeSFfzEIoVs
         Kt+DCF0gbkQzjD8zNQxVeRccc2U5iUuvyTztsQcAuHLznj25Z+OSpvifjqoRgQMjBv
         tdJlQ70B/cHAjebWjeABhY7nqx6xTGAPZuculJhXMzSwV1n5KV5cKe+tXAj2wO0Y/w
         EZG60QYDCT2ov60w6byZjL6sfTnZyOIK5nZuaZTToQsiX7/MFaC3bYHSB/pWYDKHCw
         4BH/SCJIlN7nQ==
Message-ID: <63ae677b-a659-58ca-f432-6f863affda59@uliege.be>
Date:   Tue, 7 Feb 2023 20:43:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [QUESTION] bpf, iproute2/tc: verifier fails because of a map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
References: <d1440852-3a3b-7b46-6ad6-a06cd5a3fb62@uliege.be>
 <CAADnVQL87R07UM3prVPwVmz_e2+uuO67QmXJxXqECgjt3S=54w@mail.gmail.com>
Content-Language: en-US
From:   Justin Iurman <justin.iurman@uliege.be>
In-Reply-To: <CAADnVQL87R07UM3prVPwVmz_e2+uuO67QmXJxXqECgjt3S=54w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/23 19:31, Alexei Starovoitov wrote:
> On Tue, Feb 7, 2023 at 3:09 AM Justin Iurman <justin.iurman@uliege.be> wrote:
>>
>> Hello,
>>
>> CC'ing netdev as well, since I initially suspected an issue in iproute2.
>> However, after having recompiled iproute2 with libbpf, I'm still stuck
>> facing the same problem.
>>
>> Environment:
>>    - OS: Ubuntu 20.04.5 LTS
>>    - kernel: 5.4.0-137-generic x86_64 (CONFIG_DEBUG_INFO_BTF=y)
>>    - clang version 10.0.0-4ubuntu1
>>    - iproute2-6.1.0, libbpf 1.2.0 (iproute2-ss200127 installed by default
>> without libbpf)
>>
>> Note: same result with kernel 6.2.0-rc6+ (net-next), as a test to be
>> aligned with latest iproute2 version (just in case).
>>
>> Long story short: I can't for the life of me make the ebpf program load
>> correctly with tc. What's the cause? Well, a map, and the verifier
>> doesn't like it. I must definitely be doing something wrong, but can't
>> find what. Here is a reproducible and minimal example:
>>
>> #include "vmlinux.h"
>> #include <bpf/bpf_helpers.h>
>>
>> #define TC_ACT_OK 0
>> #define MAX_BYTES 2048
>>
>> char _license[] SEC("license") = "GPL";
>>
>> struct mystruct_t {
>>          __u8 bytes[MAX_BYTES];
>> };
>>
>> struct {
>>          __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
>>          __uint(key_size, sizeof(__u8));
>>          __uint(value_size, sizeof(struct mystruct_t));
>>          __uint(max_entries, 1);
>> } percpu_map SEC(".maps");
>>
>> SEC("egress")
>> int xxx(struct __sk_buff *skb)
>> {
>>          __u8 idx = 0;
>>          struct mystruct_t *x = bpf_map_lookup_elem(&percpu_map, &idx);
>>          return TC_ACT_OK;
>> }
>>
>>
>> Here is how I compile the whole thing:
>>
>> git clone --recursive --depth 1 https://github.com/libbpf/libbpf
>> ./deps/libbpf
>> make -j -C deps/libbpf/src/ BUILD_STATIC_ONLY=y DESTDIR="build"
>> INCLUDEDIR= LIBDIR= UAPIDIR= install
>>
>> git clone --recursive --depth 1 https://github.com/libbpf/bpftool
>> ./deps/bpftool
>> make -j -C deps/bpftool/src/
>> deps/bpftool/src/bpftool btf dump file /sys/kernel/btf/vmlinux format c
>>   > build/vmlinux.h
>>
>> clang -g -O2 -Wall -Wextra -target bpf -D__TARGET_ARCH_x86_64 -I build/
>> -c program.c -o build/program.o
>>
>>
>> I noticed that "clang-bpf-co-re" is OFF when compiling bpftool, don't
>> know if it's part of the problem or not. Here is what the "build"
>> directory looks like after that:
>>
>> $ ls -al build
>> [...]
>> drwxr-xr-x 2 justin justin    4096 fév  6 18:20 bpf
>> -rw-rw-r-- 1 justin justin 3936504 fév  6 18:20 libbpf.a
>> drwxr-xr-x 2 justin justin    4096 fév  6 18:20 pkgconfig
>> -rw-rw-r-- 1 justin justin   10592 fév  7 10:42 program.o
>> -rw-rw-r-- 1 justin justin 2467774 fév  7 10:42 vmlinux.h
>>
>>
>> And here is the verifier error I got when loading it with tc (qdisc
>> clsact already attached):
>>
>> $ sudo ../deps/iproute2/tc/tc filter add dev eno2 egress bpf da obj
>> program.o sec egress
>>
>> libbpf: map 'percpu_map': failed to create: Invalid argument(-22)
>> libbpf: failed to load object 'program.o'
>> Unable to load program
> 
> It's likely due to
> __uint(key_size, sizeof(__u8));
> 
> https://docs.kernel.org/bpf/map_array.html
> "The key type is an unsigned 32-bit integer (4 bytes) and the map is
> of constant size."

Sigh... don't know if I should laugh or cry. Thanks!
