Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6C11092E4
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 18:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfKYRfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 12:35:05 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:59628 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfKYRfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 12:35:05 -0500
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id AB8B513C359;
        Mon, 25 Nov 2019 09:35:04 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com AB8B513C359
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1574703304;
        bh=OAhdWTOkQdFWKZ9SkSAFdccapJhLBZmFAKS7gpZ50M8=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=ZDEba6lcctP0IgU34phg1NBJW1WNk5KiyA/Nw/ZD/QGP98dU2cGpEc7Xh2QFnLL/j
         X1+lm/6x9ZqInDBioybuoSmYqMSJlhxtrNAFx1YeWrspgn71D9NPIp+EJeiEEMem5J
         tO+H+hOmd/gnxsg+lH/D1fok9Hmbmes1aVYvUYyY=
Subject: Re: VRF and/or cgroups problem on Fedora-30, 5.2.21+ kernel
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
References: <05276b67-406b-2744-dd7c-9bda845a5bb1@candelatech.com>
 <850a6d4e-3a67-a389-04a0-87032e0683d8@gmail.com>
 <213aa1d3-5df9-0337-c583-34f3de5f1582@candelatech.com>
 <8ae551e1-5c2e-6a95-b4d1-3301c5173171@gmail.com>
 <ffbeb74f-09d5-e854-190e-5362cc703a10@candelatech.com>
 <fb74534d-f5e8-7b9b-b8c0-b6d6e718a275@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <3daeee00-317a-1f82-648e-80ec14cfed22@candelatech.com>
Date:   Mon, 25 Nov 2019 09:35:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <fb74534d-f5e8-7b9b-b8c0-b6d6e718a275@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/19 10:10 AM, David Ahern wrote:
> On 11/22/19 5:23 PM, Ben Greear wrote:
>>>
>>
>> Setting:  ulimit -l 1024
>>
>> 'fixed' the problem.
>>
>> I'd rather waste a bit of memory and not have any of my users hit such
>> an esoteric
>> bug, so I'll set it to at least 1024 going forward.
> 
> agreed.
> 
>>
>> Would large numbers of vrf and/or network devices mean you need more
>> locked memory?
> 
> I have seen this problem way too much, but not taken the time to track
> down all of the locked memory use. A rough estimate is that each 'ip vrf
> exec' uses 1 page (4kB) of locked memory until the command exits. If you
> use that as a rule you would be on the high end. Commands in the same
> cgroup hierarchy should all be using the same program.

I am not sure if it is a coincidence or not, but we saw the problem when
connected with rdesktop more often than we connected with VNC.

>> And surely 'ip' could output a better error than just 'permission
>> denied' for
>> this error case?  Or even something that would show up in dmesg to give
>> a clue?
> 
> That error comes from the bpf syscall:
> 
> bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_CGROUP_SOCK, insn_cnt=6,
> insns=0x7ffc8e5d1e00, license="GPL", log_level=1, log_size=262144,
> log_buf="", kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0,
> prog_name="", prog_ifindex=0,
> expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=0,
> func_info_rec_size=0, func_info=NULL, func_info_cnt=0,
> line_info_rec_size=0, line_info=NULL, line_info_cnt=0}, 112) = -1 EPERM
> (Operation not permitted)

So, we can change iproute/lib/bpf.c to print a suggestion to increase locked memory
if this returns EPERM?

Thanks,
Ben

> 
> Yes it is odd and unhelpful for a memory limit to cause the failure and
> then return EPERM.
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

