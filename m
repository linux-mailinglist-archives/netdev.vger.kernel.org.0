Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D65521200D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgGBJgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:36:52 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:9932 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgGBJgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:36:52 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A624842181;
        Thu,  2 Jul 2020 17:36:42 +0800 (CST)
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVFN3f8OCy-zWWV+ZmKomdn8Cm3dFtbux0figRCDsU9tw@mail.gmail.com>
 <10af044d-c51b-9b85-04b9-ea97a3c3ebdb@ucloud.cn>
 <CAM_iQpWmyAd3UOk+6+J8aYw3_P=ZWhCPpoYNUyFdj4FCPuuLoA@mail.gmail.com>
 <8b06ac17-e19b-90f3-6dd2-0274a0ee474b@ucloud.cn>
 <CAM_iQpWWmCASPidrQYO6wCUNkZLR-S+Y9r9XrdyjyPHE-Q9O5g@mail.gmail.com>
 <012daf78-a18f-3dde-778a-482204c5b6af@ucloud.cn>
 <a205bada-8879-0dfd-c3ed-53fe9cef6449@ucloud.cn>
 <CAM_iQpV_1_H_Cb3t4hCCfRXf2Tn2x9sT0vJ5rh6J6iWQ=PNesA@mail.gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <7aaefcef-5709-04a8-0c54-c8c6066e1e90@ucloud.cn>
Date:   Thu, 2 Jul 2020 17:36:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpV_1_H_Cb3t4hCCfRXf2Tn2x9sT0vJ5rh6J6iWQ=PNesA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSElDS0tLS01DTU1PTk5ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXMjULOBw5FS8aEgoKDUoeCRoOQjocVlZVSkJOTEkoSVlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBA6ESo*Ej8pNhVJIUwTAjko
        AVEwFAxVSlVKTkJITUNJTUtJQktJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFPSUtLNwY+
X-HM-Tid: 0a730ee2ab012086kuqya624842181
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/2/2020 1:33 AM, Cong Wang wrote:
> On Wed, Jul 1, 2020 at 1:21 AM wenxu <wenxu@ucloud.cn> wrote:
>>
>> On 7/1/2020 2:21 PM, wenxu wrote:
>>> On 7/1/2020 2:12 PM, Cong Wang wrote:
>>>> On Tue, Jun 30, 2020 at 11:03 PM wenxu <wenxu@ucloud.cn> wrote:
>>>>> Only forward packet case need do fragment again and there is no need do defrag explicit.
>>>> Same question: why act_mirred? You have to explain why act_mirred
>>>> has the responsibility to do this job.
>>> The fragment behavior only depends on the mtu of the device sent in act_mirred. Only in
>>>
>>> the act_mirred can decides whether do the fragment or not.
>> Hi cong,
>>
>>
>> I still think this should be resolved in the act_mirred.  Maybe it is not matter with a "responsibility"
>>
>> Did you have some other suggestion to solve this problem?
> Like I said, why not introduce a new action to handle fragment/defragment?
>
> With that, you can still pipe it to act_ct and act_mirred to achieve
> the same goal.

Thanks.  Consider about the act_fagment, There are two problem for this.


The frag action will put the ressemble skb to more than one packets. How these packets

go through the following tc filter or chain?


When should use the act_fragament the action,  always before the act_mirred?


rule1 in chain0

eth_type ipv4 dst_ip 1.1.1.1 ip_flags frag/firstfrag  

action order 1: ct zone 1 nat pipe

action order 2: gact action goto chain 4


rule2 in chain0

eth_type ipv4 dst_ip 1.1.1.1 ip_flags frag/nofirstfrag  

action order 1: ct zone 1 nat pipe

action order 2: gact action goto chain 4


fragment 1 and 2 do the defag and conntrack nat jump to rule3 in chain4


dst_mac fa:ff:ff:ff:ff:ff
src_mac 52:54:00:00:12:34
  eth_type ipv4
  ip_flags nofrag
  ct_state +trk+est
  ct_zone 1

action order 1: mirred (Egress Redirect to device net2) stolen


There is no definitely reason for user to set the act_fragment action. Or

there is a key  ip_frags ressembly?



