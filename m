Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2310E6671D3
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 13:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjALMN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 07:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbjALMNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 07:13:15 -0500
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFF22600;
        Thu, 12 Jan 2023 04:12:13 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VZR2Acy_1673525527;
Received: from 30.221.129.161(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VZR2Acy_1673525527)
          by smtp.aliyun-inc.com;
          Thu, 12 Jan 2023 20:12:08 +0800
Content-Type: multipart/mixed; boundary="------------AGgUHRPn8FTngxiFshQUw0p5"
Message-ID: <b25f56de-7913-2a56-950f-dfe0defd6936@linux.alibaba.com>
Date:   Thu, 12 Jan 2023 20:12:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
From:   Wen Gu <guwen@linux.alibaba.com>
Subject: Re: [RFC PATCH net-next v2 0/5] net/smc:Introduce SMC-D based
 loopback acceleration
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
 <42f2972f1dfe45a2741482f36fbbda5b5a56d8f1.camel@linux.ibm.com>
 <4a9b0ff0-8f03-1bfd-d09c-6deb3a9bb39e@linux.alibaba.com>
 <4c7b0f4d-d57d-0aab-4ddd-6a4f15661e8d@linux.ibm.com>
In-Reply-To: <4c7b0f4d-d57d-0aab-4ddd-6a4f15661e8d@linux.ibm.com>
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,NUMERIC_HTTP_ADDR,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------AGgUHRPn8FTngxiFshQUw0p5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2023/1/5 00:09, Alexandra Winter wrote:
> 
> 
> On 21.12.22 14:14, Wen Gu wrote:
>>
>>
>> On 2022/12/20 22:02, Niklas Schnelle wrote:
>>
>>> On Tue, 2022-12-20 at 11:21 +0800, Wen Gu wrote:
>>>> Hi, all
>>>>
>>>> # Background
>>>>
>>>> As previously mentioned in [1], we (Alibaba Cloud) are trying to use SMC
>>>> to accelerate TCP applications in cloud environment, improving inter-host
>>>> or inter-VM communication.
>>>>
>>>> In addition of these, we also found the value of SMC-D in scenario of local
>>>> inter-process communication, such as accelerate communication between containers
>>>> within the same host. So this RFC tries to provide a SMC-D loopback solution
>>>> in such scenario, to bring a significant improvement in latency and throughput
>>>> compared to TCP loopback.
>>>>
>>>> # Design
>>>>
>>>> This patch set provides a kind of SMC-D loopback solution.
>>>>
>>>> Patch #1/5 and #2/5 provide an SMC-D based dummy device, preparing for the
>>>> inter-process communication acceleration. Except for loopback acceleration,
>>>> the dummy device can also meet the requirements mentioned in [2], which is
>>>> providing a way to test SMC-D logic for broad community without ISM device.
>>>>
>>>>    +------------------------------------------+
>>>>    |  +-----------+           +-----------+   |
>>>>    |  | process A |           | process B |   |
>>>>    |  +-----------+           +-----------+   |
>>>>    |       ^                        ^         |
>>>>    |       |    +---------------+   |         |
>>>>    |       |    |   SMC stack   |   |         |
>>>>    |       +--->| +-----------+ |<--|         |
>>>>    |            | |   dummy   | |             |
>>>>    |            | |   device  | |             |
>>>>    |            +-+-----------+-+             |
>>>>    |                   VM                     |
>>>>    +------------------------------------------+
>>>>
>>>> Patch #3/5, #4/5, #5/5 provides a way to avoid data copy from sndbuf to RMB
>>>> and improve SMC-D loopback performance. Through extending smcd_ops with two
>>>> new semantic: attach_dmb and detach_dmb, sender's sndbuf shares the same
>>>> physical memory region with receiver's RMB. The data copied from userspace
>>>> to sender's sndbuf directly reaches the receiver's RMB without unnecessary
>>>> memory copy in the same kernel.
>>>>
>>>>    +----------+                     +----------+
>>>>    | socket A |                     | socket B |
>>>>    +----------+                     +----------+
>>>>          |                               ^
>>>>          |         +---------+           |
>>>>     regard as      |         | ----------|
>>>>     local sndbuf   |  B's    |     regard as
>>>>          |         |  RMB    |     local RMB
>>>>          |-------> |         |
>>>>                    +---------+
>>>
>>> Hi Wen Gu,
>>>
>>> I maintain the s390 specific PCI support in Linux and would like to
>>> provide a bit of background on this. You're surely wondering why we
>>> even have a copy in there for our ISM virtual PCI device. To understand
>>> why this copy operation exists and why we need to keep it working, one
>>> needs a bit of s390 aka mainframe background.
>>>
>>> On s390 all (currently supported) native machines have a mandatory
>>> machine level hypervisor. All OSs whether z/OS or Linux run either on
>>> this machine level hypervisor as so called Logical Partitions (LPARs)
>>> or as second/third/… level guests on e.g. a KVM or z/VM hypervisor that
>>> in turn runs in an LPAR. Now, in terms of memory this machine level
>>> hypervisor sometimes called PR/SM unlike KVM, z/VM, or VMWare is a
>>> partitioning hypervisor without paging. This is one of the main reasons
>>> for the very-near-native performance of the machine hypervisor as the
>>> memory of its guests acts just like native RAM on other systems. It is
>>> never paged out and always accessible to IOMMU translated DMA from
>>> devices without the need for pinning pages and besides a trivial
>>> offset/limit adjustment an LPAR's MMU does the same amount of work as
>>> an MMU on a bare metal x86_64/ARM64 box.
>>>
>>> It also means however that when SMC-D is used to communicate between
>>> LPARs via an ISM device there is  no way of mapping the DMBs to the
>>> same physical memory as there exists no MMU-like layer spanning
>>> partitions that could do such a mapping. Meanwhile for machine level
>>> firmware including the ISM virtual PCI device it is still possible to
>>> _copy_ memory between different memory partitions. So yeah while I do
>>> see the appeal of skipping the memcpy() for loopback or even between
>>> guests of a paging hypervisor such as KVM, which can map the DMBs on
>>> the same physical memory, we must keep in mind this original use case
>>> requiring a copy operation.
>>>
>>> Thanks,
>>> Niklas
>>>
>>
>> Hi Niklas,
>>
>> Thank you so much for the complete and detailed explanation! This provides
>> me a brand new perspective of s390 device that we hadn't dabbled in before.
>> Now I understand why shared memory is unavailable between different LPARs.
>>
>> Our original intention of proposing loopback device and the incoming device
>> (virtio-ism) for inter-VM is to use SMC-D to accelerate communication in the
>> case with no existing s390 ISM devices. In our conception, s390 ISM device,
>> loopback device and virtio-ism device are parallel and are abstracted by smcd_ops.
>>
>>   +------------------------+
>>   |          SMC-D         |
>>   +------------------------+
>>   -------- smcd_ops ---------
>>   +------+ +------+ +------+
>>   | s390 | | loop | |virtio|
>>   | ISM  | | back | | -ism |
>>   | dev  | | dev  | | dev  |
>>   +------+ +------+ +------+
>>
>> We also believe that keeping the existing design and behavior of s390 ISM
>> device is unshaken. What we want to get support for is some smcd_ops extension
>> for devices with optional beneficial capability, such as nocopy here (Let's call
>> it this for now), which is really helpful for us in inter-process and inter-VM
>> scenario.
>>
>> And coincided with IBM's intention to add APIs between SMC-D and devices to
>> support various devices for SMC-D, as mentioned in [2], we send out this RFC and
>> the incoming virio-ism RFC, to provide some examples.
>>
>>>>
>>>> # Benchmark Test
>>>>
>>>>    * Test environments:
>>>>         - VM with Intel Xeon Platinum 8 core 2.50GHz, 16 GiB mem.
>>>>         - SMC sndbuf/RMB size 1MB.
>>>>
>>>>    * Test object:
>>>>         - TCP: run on TCP loopback.
>>>>         - domain: run on UNIX domain.
>>>>         - SMC lo: run on SMC loopback device with patch #1/5 ~ #2/5.
>>>>         - SMC lo-nocpy: run on SMC loopback device with patch #1/5 ~ #5/5.
>>>>
>>>> 1. ipc-benchmark (see [3])
>>>>
>>>>    - ./<foo> -c 1000000 -s 100
>>>>
>>>>                          TCP              domain              SMC-lo             SMC-lo-nocpy
>>>> Message
>>>> rate (msg/s)         75140      129548(+72.41)    152266(+102.64%)         151914(+102.17%)
>>>
>>> Interesting that it does beat UNIX domain sockets. Also, see my below
>>> comment for nginx/wrk as this seems very similar.
>>>
>>>>
>>>> 2. sockperf
>>>>
>>>>    - serv: <smc_run> taskset -c <cpu> sockperf sr --tcp
>>>>    - clnt: <smc_run> taskset -c <cpu> sockperf { tp | pp } --tcp --msg-size={ 64000 for tp | 14 for pp } -i 127.0.0.1 -t 30
>>>>
>>>>                          TCP                  SMC-lo             SMC-lo-nocpy
>>>> Bandwidth(MBps)   4943.359        4936.096(-0.15%)        8239.624(+66.68%)
>>>> Latency(us)          6.372          3.359(-47.28%)            3.25(-49.00%)
>>>>
>>>> 3. iperf3
>>>>
>>>>    - serv: <smc_run> taskset -c <cpu> iperf3 -s
>>>>    - clnt: <smc_run> taskset -c <cpu> iperf3 -c 127.0.0.1 -t 15
>>>>
>>>>                          TCP                  SMC-lo             SMC-lo-nocpy
>>>> Bitrate(Gb/s)         40.5            41.4(+2.22%)            76.4(+88.64%)
>>>>
>>>> 4. nginx/wrk
>>>>
>>>>    - serv: <smc_run> nginx
>>>>    - clnt: <smc_run> wrk -t 8 -c 500 -d 30 http://127.0.0.1:80
>>>>
>>>>                          TCP                  SMC-lo             SMC-lo-nocpy
>>>> Requests/s       154643.22      220894.03(+42.84%)        226754.3(+46.63%)
>>>
>>>
>>> This result is very interesting indeed. So with the much more realistic
>>> nginx/wrk workload it seems to copy hurts much less than the
>>> iperf3/sockperf would suggest while SMC-D itself seems to help more.
>>> I'd hope that this translates to actual applications as well. Maybe
>>> this makes SMC-D based loopback interesting even while keeping the
>>> copy, at least until we can come up with a sane way to work a no-copy
>>> variant into SMC-D?
>>>
>>
>> I agree, nginx/wrk workload is much more realistic for many applications.
>>
>> But we also encounter many other cases similar to sockperf on the cloud, which
>> requires high throughput, such as AI training and big data.
>>
>> So avoidance of copying between DMBs can help these cases a lot :)
>>
>>>>
>>>>
>>>> # Discussion
>>>>
>>>> 1. API between SMC-D and ISM device
>>>>
>>>> As Jan mentioned in [2], IBM are working on placing an API between SMC-D
>>>> and the ISM device for easier use of different "devices" for SMC-D.
>>>>
>>>> So, considering that the introduction of attach_dmb or detach_dmb can
>>>> effectively avoid data copying from sndbuf to RMB and brings obvious
>>>> throughput advantages in inter-VM or inter-process scenarios, can the
>>>> attach/detach semantics be taken into consideration when designing the
>>>> API to make it a standard ISM device behavior?
>>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>
>>> Due to the reasons explained above this behavior can't be emulated by
>>> ISM devices at least not when crossing partitions. Not sure if we can
>>> still incorporate it in the API and allow for both copying and
>>> remapping SMC-D like devices, it definitely needs careful consideration
>>> and I think also a better understanding of the benefit for real world
>>> workloads.
>>>
>>
>> Here I am not rigorous.
>>
>> Nocopy shouldn't be a standard ISM device behavior indeed. Actually we hope it be a
>> standard optional _SMC-D_ device behavior and defined by smcd_ops.
>>
>> For devices don't support these options, like ISM device on s390 architecture,
>> .attach_dmb/.detach_dmb and other reasonable extensions (which will be proposed to
>> discuss in incoming virtio-ism RFC) can be set to NULL or return invalid. And for
>> devices do support, they may be used for improving performance in some cases.
>>
>> In addition, can I know more latest news about the API design? :) , like its scale, will
>> it be a almost refactor of existing interface or incremental patching? and its object,
>> will it be tailored for exact ISM behavior or to reserve some options for other devices,
>> like nocopy here? From my understanding of [2], it might be the latter?
>>
>>>>
>>>> Maybe our RFC of SMC-D based inter-process acceleration (this one) and
>>>> inter-VM acceleration (will coming soon, which is the update of [1])
>>>> can provide some examples for new API design. And we are very glad to
>>>> discuss this on the mail list.
>>>>
>>>> 2. Way to select different ISM-like devices
>>>>
>>>> With the proposal of SMC-D loopback 'device' (this RFC) and incoming
>>>> device used for inter-VM acceleration as update of [1], SMC-D has more
>>>> options to choose from. So we need to consider that how to indicate
>>>> supported devices, how to determine which one to use, and their priority...
>>>
>>> Agree on this part, though it is for the SMC maintainers to decide, I
>>> think we would definitely want to be able to use any upcoming inter-VM
>>> devices on s390 possibly also in conjunction with ISM devices for
>>> communication across partitions.
>>>
>>
>> Yes, this part needs to be discussed with SMC maintainers. And thank you, we are very glad
>> if our devices can be applied on s390 through the efforts.
>>
>>
>> Best Regards,
>> Wen Gu
>>
>>>>
>>>> IMHO, this may require an update of CLC message and negotiation mechanism.
>>>> Again, we are very glad to discuss this with you on the mailing list.
> 
> As described in
> SMC protocol (including SMC-D): https://www.ibm.com/support/pages/system/files/inline-files/IBM%20Shared%20Memory%20Communications%20Version%202_2.pdf
> the CLC messages provide a list of up to 8 ISM devices to chose from.
> So I would hope that we can use the existing protocol.
> 
> The challenge will be to define GID (Global Interface ID) and CHID (a fabric ID) in
> a meaningful way for the new devices.
> There is always smcd_ops->query_remote_gid()  as a safety net. But the idea is that
> a CHID mismatch is a fast way to tell that these 2 interfaces do match.
> 
> 

Hi Winter and all,

Thanks for your reply and suggestions! And sorry for my late reply because it took me
some time to understand SMC-Dv2 protocol and implementation.

I agree with your opinion. The existing SMC-Dv2 protocol whose CLC messages include
ism_dev[] list can solve the devices negotiation problem. And I am very willing to use
the existing protocol, because we all know that the protocol update is a long and complex
process.

If I understand correctly, SMC-D loopback(dummy) device can coordinate with existing
SMC-Dv2 protocol as follows. If there is any mistake, please point out.


# Initialization

- Initialize the loopback device with unique GID [Q-1].

- Register the loopback device as SMC-Dv2-capable device with a system_eid whose 24th
    or 28th byte is non-zero [Q-2], so that this system's smc_ism_v2_capable will be set
    to TRUE and SMC-Dv2 is available.


# Proposal

- Find the loopback device from the smcd_dev_list in smc_find_ism_v2_device_clnt();

- Record the SEID, GID and CHID[Q-3] of loopback device in the v2 extension part of CLC
    proposal message.


# Accept

- Check the GID/CHID list and SEID in CLC proposal message, and find local matched ISM
    device from smcd_dev_list in smc_find_ism_v2_device_serv(). If both sides of the
    communication are in the same VM and share the same loopback device, the SEID, GID and
    CHID will match and loopback device will be chosen [Q-4].

- Record the loopback device's GID/CHID and matched SEID into CLC accept message.


# Confirm

- Confirm the server-selected device (loopback device) accordingto CLC accept messages.

- Record the loopback device's GID/CHID and server-selected SEID in CLC confirm message.


Follow the above process, I supplement a patch based on this RFC in the email attachment.
With the attachment patch, SMC-D loopback will switch to use SMC-Dv2 protocol.



And in the above process, there are something I want to consult and discuss, which is marked
with '[Q-*]' in the above description.

# [Q-1]:

The GID of loopback device is randomly generated in this RFC patch set, but I will find a way
to unique the GID in formal patches. Any suggestions are welcome.


# [Q-2]:

In Linux implementation, the system_eid of the first registered smcd device will determinate
system's smc_ism_v2_capable (see smcd_register_dev()).

And I wonder that

1) How to define the system_eid? It can be inferred from the code that the 24th and 28th byte
     are special for SMC-Dv2. So in attachment patch, I define the loopback device SEID as

     static struct smc_lo_systemeid LO_SYSTEM_EID = {
             .seid_string = "SMC-SYSZ-LOSEID000000000",
             .serial_number = "1000",
             .type = "1000",
     };

     Is there anything else I need to pay attention to?


2) Seems only the first added smcd device determinate the system smc_ism_v2_capable? If two
     different smcd devices respectively with v1-indicated and v2-indicated system_eid, will
     the order in which they are registered affects the result of smc_ism_v2_capable ?


# [Q-3]:

In attachment patch, I define a special CHID (0xFFFF) for loopback device, as a kind of
'unassociated ISM CHID' that not associated with any IP (OSA or HiperSockets) interfaces.

What's your opinion about this?


# [Q-4]:

In current Linux implementation, server will select the first successfully initialized device
from the candidates as the final selected one in smc_find_ism_v2_device_serv().

for (i = 0; i < matches; i++) {
	ini->smcd_version = SMC_V2;
	ini->is_smcd = true;
	ini->ism_selected = i;
	rc = smc_listen_ism_init(new_smc, ini);
	if (rc) {
		smc_find_ism_store_rc(rc, ini);
		/* try next active ISM device */
		continue;
	}
	return; /* matching and usable V2 ISM device found */
}

IMHO, maybe candidate devices should have different priorities? For example, the loopback device
may be preferred to use if loopback is available.


Best Regards,
Wen Gu

>>>>
>>>> [1] https://lore.kernel.org/netdev/20220720170048.20806-1-tonylu@linux.alibaba.com/
>>>> [2] https://lore.kernel.org/netdev/35d14144-28f7-6129-d6d3-ba16dae7a646@linux.ibm.com/
>>>> [3] https://github.com/goldsborough/ipc-bench
>>>>
>>>> v1->v2
>>>>    1. Fix some build WARNINGs complained by kernel test rebot
>>>>       Reported-by: kernel test robot <lkp@intel.com>
>>>>    2. Add iperf3 test data.
>>>>
>>>> Wen Gu (5):
>>>>     net/smc: introduce SMC-D loopback device
>>>>     net/smc: choose loopback device in SMC-D communication
>>>>     net/smc: add dmb attach and detach interface
>>>>     net/smc: avoid data copy from sndbuf to peer RMB in SMC-D loopback
>>>>     net/smc: logic of cursors update in SMC-D loopback connections
>>>>
>>>>    include/net/smc.h      |   3 +
>>>>    net/smc/Makefile       |   2 +-
>>>>    net/smc/af_smc.c       |  88 +++++++++++-
>>>>    net/smc/smc_cdc.c      |  59 ++++++--
>>>>    net/smc/smc_cdc.h      |   1 +
>>>>    net/smc/smc_clc.c      |   4 +-
>>>>    net/smc/smc_core.c     |  62 +++++++++
>>>>    net/smc/smc_core.h     |   2 +
>>>>    net/smc/smc_ism.c      |  39 +++++-
>>>>    net/smc/smc_ism.h      |   2 +
>>>>    net/smc/smc_loopback.c | 358 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>>    net/smc/smc_loopback.h |  63 +++++++++
>>>>    12 files changed, 662 insertions(+), 21 deletions(-)
>>>>    create mode 100644 net/smc/smc_loopback.c
>>>>    create mode 100644 net/smc/smc_loopback.h
>>>>
--------------AGgUHRPn8FTngxiFshQUw0p5
Content-Type: text/plain; charset=UTF-8;
 name="0001-net-smc-define-SEID-and-CHID-of-loopback-device.patch"
Content-Disposition: attachment;
 filename*0="0001-net-smc-define-SEID-and-CHID-of-loopback-device.patch"
Content-Transfer-Encoding: base64

RnJvbSBiYzk0OTg0ZDU5OWUyZThjYmM0MDhjNDI4OTY5NzM3NDVjNTMzYmI3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBXZW4gR3UgPGd1d2VuQGxpbnV4LmFsaWJhYmEuY29t
PgpEYXRlOiBTYXQsIDcgSmFuIDIwMjMgMTY6NTg6MzcgKzA4MDAKU3ViamVjdDogW1BBVENI
XSBuZXQvc21jOiBkZWZpbmUgU0VJRCBhbmQgQ0hJRCBvZiBsb29wYmFjayBkZXZpY2UKClRo
aXMgcGF0Y2ggZGVmaW5lcyBTRUlEIGFuZCBDSElEIG9mIGxvb3BiYWNrIGRldmljZSBhbmQg
dGFrZSBpdCBhcwpTTUMtRHYyIGRldmljZS4KCkJlc2lkZXMsIHRoaXMgcGF0Y2ggZGVsZXRl
IHRoZSBtb3N0IGxvZ2ljIG9mIFJGQyBwYXRjaCAyLzUgYXMgd2VsbApiZWNhdXNlIGRldmlj
ZSBzZWxlY3Rpb24gd2lsbCBiZSBjb3ZlcmVkIGJ5IFNNQy1EdjIgcHJvdG9jb2wuCgpTaWdu
ZWQtb2ZmLWJ5OiBXZW4gR3UgPGd1d2VuQGxpbnV4LmFsaWJhYmEuY29tPgotLS0KIG5ldC9z
bWMvYWZfc21jLmMgICAgICAgfCA1MCArKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQogbmV0L3NtYy9zbWNfY2xjLmMgICAgICB8ICA0ICstLS0K
IG5ldC9zbWMvc21jX2xvb3BiYWNrLmMgfCAxMSArKysrKysrLS0tLQogMyBmaWxlcyBjaGFu
Z2VkLCAxMyBpbnNlcnRpb25zKCspLCA1MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9u
ZXQvc21jL2FmX3NtYy5jIGIvbmV0L3NtYy9hZl9zbWMuYwppbmRleCBjN2RlNTY2Li40Mzk2
MzkyIDEwMDY0NAotLS0gYS9uZXQvc21jL2FmX3NtYy5jCisrKyBiL25ldC9zbWMvYWZfc21j
LmMKQEAgLTk3OSwyOCArOTc5LDYgQEAgc3RhdGljIGludCBzbWNfZmluZF9pc21fZGV2aWNl
KHN0cnVjdCBzbWNfc29jayAqc21jLCBzdHJ1Y3Qgc21jX2luaXRfaW5mbyAqaW5pKQogCXJl
dHVybiAwOwogfQogCi0vKiBjaGVjayBpZiB0aGVyZSBpcyBhIGxvIGRldmljZSBhdmFpbGFi
bGUgZm9yIHRoaXMgY29ubmVjdGlvbi4gKi8KLXN0YXRpYyBpbnQgc21jX2ZpbmRfbG9fZGV2
aWNlKHN0cnVjdCBzbWNfc29jayAqc21jLCBzdHJ1Y3Qgc21jX2luaXRfaW5mbyAqaW5pKQot
ewotCXN0cnVjdCBzbWNkX2RldiAqc2RldjsKLQotCW11dGV4X2xvY2soJnNtY2RfZGV2X2xp
c3QubXV0ZXgpOwotCWxpc3RfZm9yX2VhY2hfZW50cnkoc2RldiwgJnNtY2RfZGV2X2xpc3Qu
bGlzdCwgbGlzdCkgewotCQlpZiAoc2Rldi0+aXNfbG9vcGJhY2sgJiYgIXNkZXYtPmdvaW5n
X2F3YXkgJiYKLQkJICAgICghaW5pLT5pc21fcGVlcl9naWRbMF0gfHwKLQkJICAgICAhc21j
X2lzbV9jYW50YWxrKGluaS0+aXNtX3BlZXJfZ2lkWzBdLCBpbmktPnZsYW5faWQsCi0JCQkJ
ICAgICAgc2RldikpKSB7Ci0JCQlpbmktPmlzbV9kZXZbMF0gPSBzZGV2OwotCQkJYnJlYWs7
Ci0JCX0KLQl9Ci0JbXV0ZXhfdW5sb2NrKCZzbWNkX2Rldl9saXN0Lm11dGV4KTsKLQlpZiAo
IWluaS0+aXNtX2RldlswXSkKLQkJcmV0dXJuIFNNQ19DTENfREVDTF9OT1NNQ0RERVY7Ci0J
aW5pLT5pc21fY2hpZFswXSA9IHNtY19pc21fZ2V0X2NoaWQoaW5pLT5pc21fZGV2WzBdKTsK
LQlyZXR1cm4gMDsKLX0KLQogLyogaXMgY2hpZCB1bmlxdWUgZm9yIHRoZSBpc20gZGV2aWNl
cyB0aGF0IGFyZSBhbHJlYWR5IGRldGVybWluZWQ/ICovCiBzdGF0aWMgYm9vbCBzbWNfZmlu
ZF9pc21fdjJfaXNfdW5pcXVlX2NoaWQodTE2IGNoaWQsIHN0cnVjdCBzbWNfaW5pdF9pbmZv
ICppbmksCiAJCQkJCSAgIGludCBjbnQpCkBAIC0xMDY2LDE5ICsxMDQ0LDEwIEBAIHN0YXRp
YyBpbnQgc21jX2ZpbmRfcHJvcG9zYWxfZGV2aWNlcyhzdHJ1Y3Qgc21jX3NvY2sgKnNtYywK
IHsKIAlpbnQgcmMgPSAwOwogCi0JLyogVE9ETzoKLQkgKiBIb3cgdG8gaW5kaWNhdGUgdG8g
cGVlciBpZiBpc20gZGV2aWNlIGFuZCBsb29wYmFjawotCSAqIGRldmljZSBhcmUgYm90aCBh
dmFpbGFibGUgPwotCSAqCi0JICogVGhlIFJGQyBwYXRjaCBoYXNuJ3QgcmVzb2x2ZWQgdGhp
cywganVzdCBzaW1wbHkgYWx3YXlzCi0JICogY2hvb3NlcyBsb29wYmFjayBkZXZpY2UgZmly
c3QsIGFuZCBmYWxsYmFjayBpZiBsb29wYmFjawotCSAqIGNvbW11bmljYXRpb24gaXMgaW1w
b3NzaWJsZS4KLQkgKi8KIAkvKiBjaGVjayBpZiB0aGVyZSBpcyBhbiBpc20gb3IgbG9vcGJh
Y2sgZGV2aWNlIGF2YWlsYWJsZSAqLwogCWlmICghKGluaS0+c21jZF92ZXJzaW9uICYgU01D
X1YxKSB8fAotCSAgICAoc21jX2ZpbmRfbG9fZGV2aWNlKHNtYywgaW5pKSAmJgotCSAgICAo
c21jX2ZpbmRfaXNtX2RldmljZShzbWMsIGluaSkgfHwKLQkgICAgc21jX2Nvbm5lY3RfaXNt
X3ZsYW5fc2V0dXAoc21jLCBpbmkpKSkpCisJICAgIHNtY19maW5kX2lzbV9kZXZpY2Uoc21j
LCBpbmkpIHx8CisJICAgIHNtY19jb25uZWN0X2lzbV92bGFuX3NldHVwKHNtYywgaW5pKSkK
IAkJaW5pLT5zbWNkX3ZlcnNpb24gJj0gflNNQ19WMTsKIAkvKiBlbHNlIElTTSBWMSBpcyBz
dXBwb3J0ZWQgZm9yIHRoaXMgY29ubmVjdGlvbiAqLwogCkBAIC0yMTc4LDE4ICsyMTQ3LDkg
QEAgc3RhdGljIHZvaWQgc21jX2ZpbmRfaXNtX3YxX2RldmljZV9zZXJ2KHN0cnVjdCBzbWNf
c29jayAqbmV3X3NtYywKIAlpbmktPmlzX3NtY2QgPSB0cnVlOyAvKiBwcmVwYXJlIElTTSBj
aGVjayAqLwogCWluaS0+aXNtX3BlZXJfZ2lkWzBdID0gbnRvaGxsKHBjbGNfc21jZC0+aXNt
LmdpZCk7CiAKLQkvKiBUT0RPOgotCSAqIEhvdyB0byBrbm93IHRoYXQgcGVlciBoYXMgYm90
aCBsb29wYmFjayBhbmQgaXNtIGRldmljZSA/Ci0JICoKLQkgKiBUaGUgUkZDIHBhdGNoIGhh
c24ndCByZXNvbHZlZCB0aGlzLCBzaW1wbHkgdHJpZXMgbG9vcGJhY2sKLQkgKiBkZXZpY2Ug
Zmlyc3QsIHRoZW4gaXNtIGRldmljZS4KLQkgKi8KLQkvKiBmaW5kIGF2YWlsYWJsZSBsb29w
YmFjayBvciBpc20gZGV2aWNlICovCi0JaWYgKHNtY19maW5kX2xvX2RldmljZShuZXdfc21j
LCBpbmkpKSB7Ci0JCXJjID0gc21jX2ZpbmRfaXNtX2RldmljZShuZXdfc21jLCBpbmkpOwot
CQlpZiAocmMpCi0JCQlnb3RvIG5vdF9mb3VuZDsKLQl9CisJcmMgPSBzbWNfZmluZF9pc21f
ZGV2aWNlKG5ld19zbWMsIGluaSk7CisJaWYgKHJjKQorCQlnb3RvIG5vdF9mb3VuZDsKIAog
CWluaS0+aXNtX3NlbGVjdGVkID0gMDsKIAlyYyA9IHNtY19saXN0ZW5faXNtX2luaXQobmV3
X3NtYywgaW5pKTsKZGlmZiAtLWdpdCBhL25ldC9zbWMvc21jX2NsYy5jIGIvbmV0L3NtYy9z
bWNfY2xjLmMKaW5kZXggMzg4NzY5Mi4uZGZiOTc5NyAxMDA2NDQKLS0tIGEvbmV0L3NtYy9z
bWNfY2xjLmMKKysrIGIvbmV0L3NtYy9zbWNfY2xjLmMKQEAgLTQ4Niw5ICs0ODYsNyBAQCBz
dGF0aWMgaW50IHNtY19jbGNfcHJmeF9zZXQ0X3JjdShzdHJ1Y3QgZHN0X2VudHJ5ICpkc3Qs
IF9fYmUzMiBpcHY0LAogCQlyZXR1cm4gLUVOT0RFVjsKIAogCWluX2Rldl9mb3JfZWFjaF9p
ZmFfcmN1KGlmYSwgaW5fZGV2KSB7Ci0JCS8qIGFkZCBsb29wYmFjayBzdXBwb3J0ICovCi0J
CWlmIChpbmV0X2FkZHJfdHlwZShkZXZfbmV0KGRzdC0+ZGV2KSwgaXB2NCkgIT0gUlROX0xP
Q0FMICYmCi0JCSAgICAhaW5ldF9pZmFfbWF0Y2goaXB2NCwgaWZhKSkKKwkJaWYgKCFpbmV0
X2lmYV9tYXRjaChpcHY0LCBpZmEpKQogCQkJY29udGludWU7CiAJCXByb3AtPnByZWZpeF9s
ZW4gPSBpbmV0X21hc2tfbGVuKGlmYS0+aWZhX21hc2spOwogCQlwcm9wLT5vdXRnb2luZ19z
dWJuZXQgPSBpZmEtPmlmYV9hZGRyZXNzICYgaWZhLT5pZmFfbWFzazsKZGlmZiAtLWdpdCBh
L25ldC9zbWMvc21jX2xvb3BiYWNrLmMgYi9uZXQvc21jL3NtY19sb29wYmFjay5jCmluZGV4
IDNkZWRjYzQuLjY0MmIyNDEgMTAwNjQ0Ci0tLSBhL25ldC9zbWMvc21jX2xvb3BiYWNrLmMK
KysrIGIvbmV0L3NtYy9zbWNfbG9vcGJhY2suYwpAQCAtMTksMTMgKzE5LDE0IEBACiAjaW5j
bHVkZSAic21jX2xvb3BiYWNrLmgiCiAKICNkZWZpbmUgRFJWX05BTUUgInNtY19sb2RldiIK
KyNkZWZpbmUgTE9fQ0hJRAkweEZGRkYJLyogc3BlY2lmaWMgZm9yIGxvIGRldiAqLwogCiBz
dHJ1Y3Qgc21jX2xvX2RldiAqbG9fZGV2OwogCiBzdGF0aWMgc3RydWN0IHNtY19sb19zeXN0
ZW1laWQgTE9fU1lTVEVNX0VJRCA9IHsKIAkuc2VpZF9zdHJpbmcgPSAiU01DLVNZU1otTE9T
RUlEMDAwMDAwMDAwIiwKLQkuc2VyaWFsX251bWJlciA9ICIwMDAwIiwKLQkudHlwZSA9ICIw
MDAwIiwKKwkuc2VyaWFsX251bWJlciA9ICIxMDAwIiwKKwkudHlwZSA9ICIxMDAwIiwKIH07
CiAKIHN0YXRpYyBpbnQgc21jX2xvX3F1ZXJ5X3JnaWQoc3RydWN0IHNtY2RfZGV2ICpzbWNk
LCB1NjQgcmdpZCwgdTMyIHZpZF92YWxpZCwKQEAgLTMzLDcgKzM0LDkgQEAgc3RhdGljIGlu
dCBzbWNfbG9fcXVlcnlfcmdpZChzdHJ1Y3Qgc21jZF9kZXYgKnNtY2QsIHU2NCByZ2lkLCB1
MzIgdmlkX3ZhbGlkLAogewogCXN0cnVjdCBzbWNfbG9fZGV2ICpsZGV2ID0gc21jZC0+cHJp
djsKIAotCS8qIHJldHVybiBsb2NhbCBnaWQgKi8KKwlpZiAoIXZpZF92YWxpZCB8fCB2aWQg
IT0gSVNNX1JFU0VSVkVEX1ZMQU5JRCkKKwkJcmV0dXJuIC1FSU5WQUw7CisJLyogcmdpZCBz
aG91bGQgYmUgZXF1YWwgdG8gbGdpZCAqLwogCWlmICghbGRldiB8fCByZ2lkICE9IGxkZXYt
PmxnaWQpCiAJCXJldHVybiAtRU5FVFVOUkVBQ0g7CiAJcmV0dXJuIDA7CkBAIC0yNTUsNyAr
MjU4LDcgQEAgc3RhdGljIHU4ICpzbWNfbG9fZ2V0X3N5c3RlbV9laWQodm9pZCkKIAogc3Rh
dGljIHUxNiBzbWNfbG9fZ2V0X2NoaWQoc3RydWN0IHNtY2RfZGV2ICpzbWNkKQogewotCXJl
dHVybiAwOworCXJldHVybiBMT19DSElEOwogfQogCiBzdGF0aWMgY29uc3Qgc3RydWN0IHNt
Y2Rfb3BzIGxvX29wcyA9IHsKLS0gCjEuOC4zLjEKCg==

--------------AGgUHRPn8FTngxiFshQUw0p5--
