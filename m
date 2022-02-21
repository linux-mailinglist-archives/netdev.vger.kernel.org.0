Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D654BD690
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 07:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345715AbiBUGzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 01:55:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345700AbiBUGzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 01:55:15 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B892AD4;
        Sun, 20 Feb 2022 22:54:51 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V50drxT_1645426488;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V50drxT_1645426488)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Feb 2022 14:54:49 +0800
Date:   Mon, 21 Feb 2022 14:54:48 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, kgraul@linux.ibm.com,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Subject: Re: [PATCH 0/4] RDMA device net namespace support for SMC
Message-ID: <YhM3OC3Bz6pVeIwr@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
 <8701fa4557026983a9ec687cfdd7ac5b3b85fd39.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8701fa4557026983a9ec687cfdd7ac5b3b85fd39.camel@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 12:33:06PM +0100, Niklas Schnelle wrote:
> On Tue, 2021-12-28 at 21:06 +0800, Tony Lu wrote:
> > This patch set introduces net namespace support for linkgroups.
> > 
> > Path 1 is the main approach to implement net ns support.
> > 
> > Path 2 - 4 are the additional modifications to let us know the netns.
> > Also, I will submit changes of smc-tools to github later.
> > 
> > Currently, smc doesn't support net namespace isolation. The ibdevs
> > registered to smc are shared for all linkgroups and connections. When
> > running applications in different net namespaces, such as container
> > environment, applications should only use the ibdevs that belongs to the
> > same net namespace.
> > 
> > This adds a new field, net, in smc linkgroup struct. During first
> > contact, it checks and find the linkgroup has same net namespace, if
> > not, it is going to create and initialized the net field with first
> > link's ibdev net namespace. When finding the rdma devices, it also checks
> > the sk net device's and ibdev's net namespaces. After net namespace
> > destroyed, the net device and ibdev move to root net namespace,
> > linkgroups won't be matched, and wait for lgr free.
> > 
> > If rdma net namespace exclusive mode is not enabled, it behaves as
> > before.
> > 
> > Steps to enable and test net namespaces:
> > 
> > 1. enable RDMA device net namespace exclusive support
> > 	rdma system set netns exclusive # default is shared
> > 
> > 2. create new net namespace, move and initialize them
> > 	ip netns add test1 
> > 	rdma dev set mlx5_1 netns test1
> > 	ip link set dev eth2 netns test1
> > 	ip netns exec test1 ip link set eth2 up
> > 	ip netns exec test1 ip addr add ${HOST_IP}/26 dev eth2
> > 
> > 3. setup server and client, connect N <-> M
> > 	ip netns exec test1 smc_run sockperf server --tcp # server
> > 	ip netns exec test1 smc_run sockperf pp --tcp -i ${SERVER_IP} # client
> > 
> > 4. netns isolated linkgroups (2 * 2 mesh) with their own linkgroups
> >   - server
> 
> Hi Tony,
> 
> I'm having a bit of trouble getting this to work for me and was
> wondering if you could test my scenario or help me figure out what's
> wrong.
> 
> I'm using network namespacing to be able to test traffic between two
> VFs of the same card/port with a single Linux system. By having one VF
> in each of a client and server namespace, traffic doesn't shortcut via
> loopback. This works great for TCP and with "rdma system set netns
> exclusive" I can also verify that RDMA with "qperf -cm1 ... rc_bw" only
> works once the respective RDMA device is also added to each namespace.
> 
> When I try the same with SMC-R I tried:
> 
>   ip netns exec server smc_run qperf &
>   ip netns exec client smc_run qperf <ip_server> tcp_bw
> 
> With that however I only see fallback TCP connections in "ip netns exec
> client watch smc_dbg". It doesn't seem to be an "smc_dbg" problem
> either since the performance with and without smc_run is the same. I
> also do have the same PNET_ID set on the interfaces.

Hi Niklas,

I understood your problem. This connection falls back to TCP for unknown
reasons. You can find out the fallback reason of this connection. It can
help us find out the root cause of fallbacks. For example,
if SMC_CLC_DECL_MEM (0x01010000) is occurred in this connection, it
means that there is no enough memory (smc_init_info, sndbuf, RMB,
proposal buf, clc msg).

Before you giving out the fallback reason, based on your environment,
this are some potential possibilities. You can check this list:

- RDMA device availability in netns. Run "ip netns exec server rdma dev"
  to check RDMA device in both server/client. If exclusive mode is setted,
  it should have different devices in different netns.
- SMC-R device availability in netns. Run "ip netns exec server smcr d"
  to check SMC device available list. Only if we have eth name in the
  list, it can access by this netns. smc-tools matches ethernet NIC and
  RDMA device, it can only find the name of eth nic in this netns, so
  there is no name if this eth nic doesn't belong to this netns.

  Net-Dev         IB-Dev   IB-P  IB-State  Type          Crit  #Links  PNET-ID
                  mlx5_0      1    ACTIVE  RoCE_Express2   No       0
  eth2            mlx5_1      1    ACTIVE  RoCE_Express2   No       0

  This output shows we have ONE available RDMA device in this netns.
- Misc checks, such as memory usage, loop back connection and so on.
  Also, you can check dmesg for device operations if you moved netns of
  RDMA device. Every device's operation will log in dmesg.

  # SMC module init, adds two RDMA device.
  [  +0.000512] smc: adding ib device mlx5_0 with port count 1
  [  +0.000534] smc:    ib device mlx5_0 port 1 has pnetid
  [  +0.000516] smc: adding ib device mlx5_1 with port count 1
  [  +0.000525] smc:    ib device mlx5_1 port 1 has pnetid

  # Move one RDMA device to another netns.
  [Feb21 14:16] smc: removing ib device mlx5_1
  [  +0.015723] smc: adding ib device mlx5_1 with port count 1
  [  +0.000600] smc:    ib device mlx5_1 port 1 has pnetid

> As an aside do you know how to gracefully put the RDMA devices back
> into the default namespace? For network interfaces I can use "ip -n
> <ns> link set dev <iface> netns 1" but the equivalent "ip netns exec
> <ns> rdma dev set <rdmadev> netns 1" doesn't work because there is no
> PID variant. Deleting the namespace and killing processes using the
> RDMA device does seem to get it back but with some delay.

Yes, just remove net namespace, we need to wait for all the connections
shutdown, because every sock will get refcnt of this netns.

I didn't move back device gracefully before, because life of containers
is as long as RDMA device. But you reminded me this, after reading the
implement of iproute2, I believe it's because iproute2 doesn't implement
this (based on nsid) for RDMA devices.

RDMA core provides RDMA_NLDEV_NET_NS_FD in netlink, iproute2 just
handles name (string) in this function, which is created by ip command
before.

// iproute2/rdma/dev.c
static int dev_set_netns(struct rd *rd)
{
	char *netns_path;
	uint32_t seq;
	int netns;
	int ret;

	if (rd_no_arg(rd)) {
		pr_err("Please provide device name.\n");
		return -EINVAL;
	}

	// netns_path is created before by ip command.
	// File located in /var/run/netns/{NS_NAME}, such as
	// /var/run/netns/server.
	if (asprintf(&netns_path, "%s/%s", NETNS_RUN_DIR, rd_argv(rd)) < 0)
		return -ENOMEM;

	netns = open(netns_path, O_RDONLY | O_CLOEXEC);
	if (netns < 0) {
		fprintf(stderr, "Cannot open network namespace \"%s\": %s\n",
			rd_argv(rd), strerror(errno));
		ret = -EINVAL;
		goto done;
	}

	rd_prepare_msg(rd, RDMA_NLDEV_CMD_SET,
		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);

	// based on the fd in this netns.
	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_NET_NS_FD, netns);
	ret = rd_sendrecv_msg(rd, seq);
	close(netns);
done:
	free(netns_path);
	return ret;
}

I don't know if there are other tools that can do it with RDMA device.
But we can do it by calling netlink with RDMA_NLDEV_NET_NS_FD, and set
this value to the fd of desired netns, such as /proc/1/ns/net.

Hope this information can help you.

Best regards,
Tony Lu
