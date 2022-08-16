Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F85B595634
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiHPJ1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiHPJ1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:27:10 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C783F1FF;
        Tue, 16 Aug 2022 00:44:40 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VMPESrz_1660635875;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VMPESrz_1660635875)
          by smtp.aliyun-inc.com;
          Tue, 16 Aug 2022 15:44:36 +0800
Date:   Tue, 16 Aug 2022 15:44:35 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, zmlcc@linux.alibaba.com,
        hans@linux.alibaba.com, zhiyuan2048@linux.alibaba.com,
        herongguang@linux.alibaba.com
Subject: Re: [RFC net-next 1/1] net/smc: SMC for inter-VM communication
Message-ID: <YvtK48VO4c/UwsW8@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220720170048.20806-1-tonylu@linux.alibaba.com>
 <0ccf9cc6-4916-7815-9ce2-990dc7884849@linux.ibm.com>
 <20220803164119.5955b442@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220803164119.5955b442@hermes.local>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 04:41:19PM -0700, Stephen Hemminger wrote:
> On Wed, 3 Aug 2022 16:27:54 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
> > On 7/20/22 1:00 PM, Tony Lu wrote:
> > > Hi all,
> > > 
> > > # Background
> > > 
> > > We (Alibaba Cloud) have already used SMC in cloud environment to
> > > transparently accelerate TCP applications with ERDMA [1]. Nowadays,
> > > there is a common scenario that deploy containers (which runtime is
> > > based on lightweight virtual machine) on ECS (Elastic Compute Service),
> > > and the containers may want to be scheduled on the same host in order to
> > > get higher performance of network, such as AI, big data or other
> > > scenarios that are sensitive with bandwidth and latency. Currently, the
> > > performance of inter-VM is poor and CPU resource is wasted (see
> > > #Benchmark virtio). This scenario has been discussed many times, but a
> > > solution for a common scenario for applications is missing [2] [3] [4].
> > > 
> > > # Design
> > > 
> > > In inter-VM scenario, we use ivshmem (Inter-VM shared memory device)
> > > which is modeled by QEMU [5]. With it, multiple VMs can access one
> > > shared memory. This shared memory device is statically created by host
> > > and shared to desired guests. The device exposes as a PCI BAR, and can
> > > interrupt its peers (ivshmem-doorbell).
> > > 
> > > In order to use ivshmem in SMC, we write a draft device driver as a
> > > bridge between SMC and ivshmem PCI device. To make it easier, this
> > > driver acts like a SMC-D device in order to fit in SMC without modifying
> > > the code, which is named ivpci (see patch #1).
> > > 
> > >    ©°©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©´
> > >    ©¦  ©°©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©´ ©°©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©´  ©¦
> > >    ©¦  ©¦      VM1      ©¦ ©¦      VM2      ©¦  ©¦
> > >    ©¦  ©¦©°©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©´©¦ ©¦©°©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©´©¦  ©¦
> > >    ©¦  ©¦©¦ Application ©¦©¦ ©¦©¦ Application ©¦©¦  ©¦
> > >    ©¦  ©¦©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È©¦ ©¦©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È©¦  ©¦
> > >    ©¦  ©¦©¦     SMC     ©¦©¦ ©¦©¦     SMC     ©¦©¦  ©¦
> > >    ©¦  ©¦©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È©¦ ©¦©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È©¦  ©¦
> > >    ©¦  ©¦©¦    ivpci    ©¦©¦ ©¦©¦    ivpci    ©¦©¦  ©¦
> > >    ©¦  ©¸©¸©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¼©¼ ©¸©¸©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¼©¼  ©¦
> > >    ©¦        x  *               x  *        ©¦
> > >    ©¦        x  ****************x* *        ©¦
> > >    ©¦        x  xxxxxxxxxxxxxxxxx* *        ©¦
> > >    ©¦        x  x                * *        ©¦
> > >    ©¦  ©°©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©´ ©°©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©´  ©¦
> > >    ©¦  ©¦shared memories©¦ ©¦ivshmem-server ©¦  ©¦
> > >    ©¦  ©¸©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¼ ©¸©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¼  ©¦
> > >    ©¦                HOST A                 ©¦
> > >    ©¸©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¼
> > >     *********** Control flow (interrupt)
> > >     xxxxxxxxxxx Data flow (memory access)
> > > 
> > > Inside ivpci driver, it implements almost all the operations of SMC-D
> > > device. It can be divided into two parts:
> > > 
> > > - control flow, most of it is same with SMC-D, use ivshmem trigger
> > >    interruptions in ivpci and process CDC flow.
> > > 
> > > - data flow, the shared memory of each connection is one large region
> > >    and divided into two part for local and remote RMB. Every writer
> > >    syscall copies data to sndbuf and calls ISM's move_data() to move data
> > >    to remote RMB in ivshmem and interrupt remote. And reader then
> > >    receives interruption and check CDC message, consume data if cursor is
> > >    updated.
> > > 
> > > # Benchmark
> > > 
> > > Current POC of ivpci is unstable and only works for single SMC
> > > connection. Here is the brief data:
> > > 
> > > Items         Latency (pingpong)    Throughput (64KB)
> > > TCP (virtio)   19.3 us                3794.185 MBps
> > > TCP (SR-IOV)   13.2 us                3948.792 MBps
> > > SMC (ivshmem)   6.3 us               11900.269 MBps
> > > 
> > > Test environments:
> > > 
> > > - CPU Intel Xeon Platinum 8 core, mem 32 GiB
> > > - NIC Mellanox CX4 with 2 VFs in two different guests
> > > - using virsh to setup virtio-net + vhost
> > > - using sockperf and single connection
> > > - SMC + ivshmem throughput uses one-copy (userspace -> kernel copy)
> > >    with intrusive modification of SMC (see patch #1), latency (pingpong)
> > >    use two-copy (user -> kernel and move_data() copy, patch version).
> > > 
> > > With the comparison, SMC with ivshmem gets 3-4x bandwidth and a half
> > > latency.
> > > 
> > > TCP + virtio is the most usage solution for guest, it gains lower
> > > performance. Moreover, it consumes extra thread with full CPU core
> > > occupied in host to transfer data, wastes more CPU resource. If the host
> > > is very busy, the performance will be worse.
> > >   
> > 
> > Hi Tony,
> > 
> > Quite interesting!  FWIW for s390x we are also looking at passthrough of 
> > host ISM devices to enable SMC-D in QEMU guests:
> > https://lore.kernel.org/kvm/20220606203325.110625-1-mjrosato@linux.ibm.com/
> > https://lore.kernel.org/kvm/20220606203614.110928-1-mjrosato@linux.ibm.com/
> > 
> > But seems to me an 'emulated ISM' of sorts could still be interesting 
> > even on s390x e.g. for scenarios where host device passthrough is not 
> > possible/desired.
> > 
> > Out of curiosity I tried this ivpci module on s390x but the device won't 
> > probe -- This is possibly an issue with the s390x PCI emulation layer in 
> > QEMU, I'll have to look into that.
> > 
> > > # Discussion
> > > 
> > > This RFC and solution is still in early stage, so we want to come it up
> > > as soon as possible and fully discuss with IBM and community. We have
> > > some topics putting on the table:
> > > 
> > > 1. SMC officially supports this scenario.
> > > 
> > > SMC + ivshmem shows huge improvement when communicating inter VMs. SMC-D
> > > and mocking ISM device might not be the official solution, maybe another
> > > extension for SMC besides SMC-R and SMC-D. So we are wondering if SMC
> > > would accept this idea to fix this scenario? Are there any other
> > > possibilities?  
> > 
> > I am curious about ivshmem and its current state though -- e.g. looking 
> > around I see mention of v2 which you also referenced but don't see any 
> > activity on it for a few years?  And as far as v1 ivshmem -- server "not 
> > for production use", etc.
> > 
> > Thanks,
> > Matt
> > 
> > > 
> > > 2. Implementation of SMC for inter-VM.
> > > 
> > > SMC is used in container and cloud environment, maybe we can propose a
> > > new device and new protocol if possible in these new scenarios to solve
> > > this problem.
> > > 
> > > 3. Standardize this new protocol and device.
> > > 
> > > SMC-R has an open RFC 7609, so can this new device or protocol like
> > > SMC-D can be standardized. There is a possible option that proposing a
> > > new device model in QEMU + virtio ecosystem and SMC supports this
> > > standard virtio device, like [6].
> > > 
> > > If there are any problems, please point them out.
> > > 
> > > Hope to hear from you, thank you.
> > > 
> > > [1] https://lwn.net/Articles/879373/
> > > [2] https://projectacrn.github.io/latest/tutorials/enable_ivshmem.html
> > > [3] https://dl.acm.org/doi/10.1145/2847562
> > > [4] https://hal.archives-ouvertes.fr/hal-00368622/document
> > > [5] https://github.com/qemu/qemu/blob/master/docs/specs/ivshmem-spec.txt
> > > [6] https://github.com/siemens/jailhouse/blob/master/Documentation/ivshmem-v2-specification.md
> > > 
> > > Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>  
> 
> 
> Also looks a lot like existing VSOCK which has transports for Virtio, HyperV and VMWare already.

Yes, VSOCK, ivshmem with SMC are both approaches to communicate
across VMs, and widely used.

The main idea that combines SMC and ivshmem is to let SMC cover this
case transparently and get better performance. SMC can choose the best
approach for peers communication, such as local shared memory, ISM, RDMA
or even fallback to TCP, and this is transparent for applications.

Tony Lu
