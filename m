Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8884C3E9C
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237944AbiBYGtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiBYGtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:49:51 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C996C1D97C5;
        Thu, 24 Feb 2022 22:49:18 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V5S9Nen_1645771755;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V5S9Nen_1645771755)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 25 Feb 2022 14:49:16 +0800
Date:   Fri, 25 Feb 2022 14:49:15 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, kgraul@linux.ibm.com,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Subject: Re: [PATCH 0/4] RDMA device net namespace support for SMC
Message-ID: <Yhh7664WyyF8OHTp@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
 <8701fa4557026983a9ec687cfdd7ac5b3b85fd39.camel@linux.ibm.com>
 <YhM3OC3Bz6pVeIwr@TonyMac-Alibaba>
 <0849c2a2e2f95a0adbbea04ef3cf12a35ce16645.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0849c2a2e2f95a0adbbea04ef3cf12a35ce16645.camel@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 04:30:32PM +0100, Niklas Schnelle wrote:
> On Mon, 2022-02-21 at 14:54 +0800, Tony Lu wrote:
> > On Thu, Feb 17, 2022 at 12:33:06PM +0100, Niklas Schnelle wrote:
> > > On Tue, 2021-12-28 at 21:06 +0800, Tony Lu wrote:
> > > 
> ---8<---
> > > Hi Tony,
> > > 
> > > I'm having a bit of trouble getting this to work for me and was
> > > wondering if you could test my scenario or help me figure out what's
> > > wrong.
> > > 
> > > I'm using network namespacing to be able to test traffic between two
> > > VFs of the same card/port with a single Linux system. By having one VF
> > > in each of a client and server namespace, traffic doesn't shortcut via
> > > loopback. This works great for TCP and with "rdma system set netns
> > > exclusive" I can also verify that RDMA with "qperf -cm1 ... rc_bw" only
> > > works once the respective RDMA device is also added to each namespace.
> > > 
> > > When I try the same with SMC-R I tried:
> > > 
> > >   ip netns exec server smc_run qperf &
> > >   ip netns exec client smc_run qperf <ip_server> tcp_bw
> > > 
> > > With that however I only see fallback TCP connections in "ip netns exec
> > > client watch smc_dbg". It doesn't seem to be an "smc_dbg" problem
> > > either since the performance with and without smc_run is the same. I
> > > also do have the same PNET_ID set on the interfaces.
> > 
> > Hi Niklas,
> > 
> > I understood your problem. This connection falls back to TCP for unknown
> > reasons. You can find out the fallback reason of this connection. It can
> > help us find out the root cause of fallbacks. For example,
> > if SMC_CLC_DECL_MEM (0x01010000) is occurred in this connection, it
> > means that there is no enough memory (smc_init_info, sndbuf, RMB,
> > proposal buf, clc msg).
> 
> Regarding fallback reason. It seems to be that the RDMA device is not
> found (0x03030000) in smd_dbg on I see the following lines:
> 
> Server:
> State          UID   Inode   Local Address           Peer Address            Intf Mode Shutd Token    Sndbuf ..
> LISTEN         00000 0103804 0.0.0.0:37373
> ACTIVE         00000 0112895 ::ffff:10.10.93..:46093 ::ffff:10.10.93..:54474 0000 TCP 0x03030000
> ACTIVE         00000 0112701 ::ffff:10.10.93..:19765 ::ffff:10.10.93..:51934 0000 TCP 0x03030000
> LISTEN         00000 0112699 0.0.0.0:19765
> 
> Client:
> State          UID   Inode   Local Address           Peer Address            Intf Mode Shutd Token    Sndbuf ...
> ACTIVE         00000 0116203 10.10.93.11:54474       10.10.93.12:46093       0000 TCP 0x05000000/0x03030000
> ACTIVE         00000 0116201 10.10.93.11:51934       10.10.93.12:19765       0000 TCP 0x05000000/0x03030000
> 
> 
> However this doesn't match what I'm seeing in the other commands below

Based on the fallback reason, the server didn't find proper RDMA device
to start, so it fell back.

> > 
> > Before you giving out the fallback reason, based on your environment,
> > this are some potential possibilities. You can check this list:
> > 
> > - RDMA device availability in netns. Run "ip netns exec server rdma dev"
> >   to check RDMA device in both server/client. If exclusive mode is setted,
> >   it should have different devices in different netns.
> 
> I get the following output that looks as expected to me:
> 
> Server:
> 2: roceP9p0s0: node_type ca fw 14.25.1020 node_guid 1d82:ff9b:1bfe:2c28 sys_image_guid 282c:001b:9b03:9803
> Client:
> 4: roceP11p0s0: node_type ca fw 14.25.1020 node_guid 0982:ff9b:63fe:64e7 sys_image_guid e764:0063:9b03:9803

It looks good for now.

> 
> > - SMC-R device availability in netns. Run "ip netns exec server smcr d"
> >   to check SMC device available list. Only if we have eth name in the
> >   list, it can access by this netns. smc-tools matches ethernet NIC and
> >   RDMA device, it can only find the name of eth nic in this netns, so
> >   there is no name if this eth nic doesn't belong to this netns.
> > 
> >   Net-Dev         IB-Dev   IB-P  IB-State  Type          Crit  #Links  PNET-ID
> >                   mlx5_0      1    ACTIVE  RoCE_Express2   No       0
> >   eth2            mlx5_1      1    ACTIVE  RoCE_Express2   No       0
> > 
> >   This output shows we have ONE available RDMA device in this netns.
> 
> Here too things look good to me:
> 
> Server:
> 
> Net-Dev         IB-Dev   IB-P  IB-State  Type          Crit  #Links  PNET-ID
> ...
>           roceP12p    1    ACTIVE  RoCE_Express2   No       0  NET26
>           roceP11p    1    ACTIVE  RoCE_Express2   No       0  NET25
> ens2076         roceP9p0    1    ACTIVE  RoCE_Express2   No       0  NET25
> 
> Client:
> 
> Net-Dev         IB-Dev   IB-P  IB-State  Type          Crit  #Links  PNET-ID
> ...
>           roceP12p    1    ACTIVE  RoCE_Express2   No       0  NET26
> ens1296         roceP11p    1    ACTIVE  RoCE_Express2   No       0  NET25
>           roceP9p0    1    ACTIVE  RoCE_Express2   No       0  NET25
> 
> And I again confirmed that a pure RDMA workload ("qperf -cm1 ... rc_bw")
> works with the RDMA namespacing set to exclusive but only if I add the
> RDMA devices to the namespaces. I do wonder why the other RDMA devices are still
> visible in the above output though?

SMC maintains the list of ibdevices, which is isolated from rdma
command. SMC registered handlers for ib device, if ib device removed or
added, it triggered a event, and SMC will remove or add this device from
list. "smcr d" dumps all the list, and not filtered by netns.

> > - Misc checks, such as memory usage, loop back connection and so on.
> >   Also, you can check dmesg for device operations if you moved netns of
> >   RDMA device. Every device's operation will log in dmesg.
> > 
> >   # SMC module init, adds two RDMA device.
> >   [  +0.000512] smc: adding ib device mlx5_0 with port count 1
> >   [  +0.000534] smc:    ib device mlx5_0 port 1 has pnetid
> >   [  +0.000516] smc: adding ib device mlx5_1 with port count 1
> >   [  +0.000525] smc:    ib device mlx5_1 port 1 has pnetid
> > 
> >   # Move one RDMA device to another netns.
> >   [Feb21 14:16] smc: removing ib device mlx5_1
> >   [  +0.015723] smc: adding ib device mlx5_1 with port count 1
> >   [  +0.000600] smc:    ib device mlx5_1 port 1 has pnetid
> 
> There is no memory pressure and SMC-R between two systems works.
> 
> I also see the smc add/remove messages in dmesg as you describe:
> 
> smc: removing ib device roceP11p0s0
> smc: adding ib device roceP11p0s0 with port count 1
> smc:    ib device roceP11p0s0 port 1 has pnetid NET25

It looks like s390 has pnetid, other systems don't implement it and have
to set pnetid by user. Now dmesg shows that you can get pnetid directly
without setting it.

> smc: removing ib device roceP9p0s0
> smc: adding ib device roceP9p0s0 with port count 1
> smc:    ib device roceP9p0s0 port 1 has pnetid NET25
> mlx5_core 000b:00:00.0 ens1296: Link up
> mlx5_core 0009:00:00.0 ens2076: Link up
> IPv6: ADDRCONF(NETDEV_CHANGE): ens2076: link becomes ready
> smc: removing ib device roceP11p0s0
> smc: adding ib device roceP11p0s0 with port count 1
> smc:    ib device roceP11p0s0 port 1 has pnetid NET25
> mlx5_core 000b:00:00.0 ens1296: Link up
> mlx5_core 0009:00:00.0 ens2076: Link up
> smc: removing ib device roceP9p0s0
> smc: adding ib device roceP9p0s0 with port count 1
> smc:    ib device roceP9p0s0 port 1 has pnetid NET25
> IPv6: ADDRCONF(NETDEV_CHANGE): ens1296: link becomes ready
> 
> (The PCI addresses and resulting names are normal for s390)
> 
> One thing I notice is that you don't seem to have a pnetid set
> in your output, did you redact those or are you dealing differently
> with PNETIDs? Maybe there is an issue with matching PNETIDs betwen
> RDMA devices and network devices when namespaced?

It works okay if I setted pnetid in different netns, the logic of pnet
handling is untouched in my test environment.

$ ip netns exec test1 smcr d # mlx5_1 with pnetid TEST1
Net-Dev         IB-Dev   IB-P  IB-State  Type          Crit  #Links  PNET-ID
                mlx5_0      1    ACTIVE  RoCE_Express2   No       0  *TEST0
eth2            mlx5_1      1    ACTIVE  RoCE_Express2  Yes       1  *TEST1

$ ip netns exec test1 smcss # runs in mode SMCR
State          UID   Inode   Local Address           Peer Address            Intf Mode
ACTIVE         00993 0045755 11.213.45.7:8091        11.213.45.19:48884      0000 SMCR

Based on the dmesg and fallback reason, you can check the eth and ib
device are added to pnetlist correctly. SMC tries to find the proper
RDMA device in pnet list matched by pnetid. Currently, pnettable is
per-netns. So it should be added in current netns. 

If the arch doesn't enabled CONFIG_HAVE_PNETID (s390 enabled), it tries
to use the handshake device when pnetlist is empty, otherwise it tries
to find in pnetlist by pnetid, and no rdma device found when pnetlist is
empty, then fallback to TCP. So the default behavior is different when
list is empty.

After investigating the pnet logic, I found something that could be
improved in original implementation, which is out of this netns patch,
such as the limit of init_net in pnet_enter and remove. I will start the
discussion if needed.

Thanks,
Tony Lu
