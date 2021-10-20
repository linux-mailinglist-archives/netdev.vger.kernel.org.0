Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9846E43487D
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhJTKFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:05:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:45659 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhJTKFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 06:05:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="209539608"
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="209539608"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 03:02:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="720369994"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 20 Oct 2021 03:02:32 -0700
Received: from alobakin-mobl.ger.corp.intel.com (alobakin-mobl.ger.corp.intel.com [10.237.140.103])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 19KA2TYS001595;
        Wed, 20 Oct 2021 11:02:29 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        andrew@lunn.ch, amitc@mellanox.com, idosch@idosch.org,
        danieller@nvidia.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        chris.snook@gmail.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, jeroendb@google.com, csully@google.com,
        awogbemila@google.com, jdmason@kudzu.us, rain.1986.08.12@gmail.com,
        zyjzyj2000@gmail.com, kys@microsoft.com, haiyangz@microsoft.com,
        mst@redhat.com, jasowang@redhat.com, doshir@vmware.com,
        pv-drivers@vmware.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V4 net-next 0/6] ethtool: add support to set/get tx copybreak buf size and rx buf len
Date:   Wed, 20 Oct 2021 12:02:29 +0200
Message-Id: <20211020100229.183-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <e6d91f02-702c-e1b2-ffdd-15f317508443@huawei.com>
References: <20211014113943.16231-1-huangguangbin2@huawei.com> <20211014131420.23598-1-alexandr.lobakin@intel.com> <e6d91f02-702c-e1b2-ffdd-15f317508443@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: huangguangbin (A) <huangguangbin2@huawei.com>
Date: Tue, 19 Oct 2021 21:54:24 +0800

> On 2021/10/14 21:14, Alexander Lobakin wrote:
> > From: Guangbin Huang <huangguangbin2@huawei.com>
> > Date: Thu, 14 Oct 2021 19:39:37 +0800
> > 
> > Hi there,
> > 
> >> From: Hao Chen <chenhao288@hisilicon.com>
> >>
> >> This series add support to set/get tx copybreak buf size and rx buf len via
> >> ethtool and hns3 driver implements them.
> >>
> >> Tx copybreak buf size is used for tx copybreak feature which for small size
> >> packet or frag. Use ethtool --get-tunable command to get it, and ethtool
> >> --set-tunable command to set it, examples are as follow:
> >>
> >> 1. set tx spare buf size to 102400:
> >> $ ethtool --set-tunable eth1 tx-buf-size 102400
> >>
> >> 2. get tx spare buf size:
> >> $ ethtool --get-tunable eth1 tx-buf-size
> >> tx-buf-size: 102400
> > 
> > Isn't that supposed to be changed on changing Tx copybreak value
> > itsef?
> > And what if I set Tx copybreak buf size value lower than Tx
> > copybreak? I see no sanity checks for this.
> > 
> Hi Alexander,

Hi,

> HNS3 driver still execute the previous packet sending process
> when tx copybreak buf size is lower than tx copybreak,
> So, we have no check for tx copybreak buf size when set it.

So it doesn't make sense then to have two separate parameters
I believe? Just change Tx copybreak buffer size according to
the current Tx copybreak value. Any usecases when it's really
handy to have them differing in values?

> >> Rx buf len is buffer length of each rx BD. Use ethtool -g command to get
> >> it, and ethtool -G command to set it, examples are as follow:
> >>
> >> 1. set rx buf len to 4096
> >> $ ethtool -G eth1 rx-buf-len 4096
> >>
> >> 2. get rx buf len
> >> $ ethtool -g eth1
> >> ...
> >> RX Buf Len:     4096
> > 
> > Isn't that supposed to be changed on changing MTU?
> > And what if I set Rx buf len value lower than MTU? I see no checks
> > as well.
> > 
> > That means, do we _really_ need two new tunables?
> > 
> When MTU remains unchanged and rx buf len changes from 2048 to 4096.
> TCP packet receiving bandwidth of single thread changes from 34.1 Gbps to 48.6 Gbps(improve 42.5%).
> it means that when we enable hardware GRO, it make sense to change rx buf len.
> 
> And if we set rx buf len(only support 2k, 4k) which is lower than MTU,

You say your HW only supports 2k and 4k buffer size, would it
make sense if you just set it automatically depending on MTU
and NETIF_F_GRO_HW (or _LRO) to keep performance in its best
not depending on any side priv parameters that user is likely
not aware of?

> it will split packages into smaller chunks to rx bd, and in general situations,
> rx buf len is greater than MTU.
> 
> >> Change log:
> >> V3 -> V4
> >> 1.Fix a few allmodconfig compile warning.
> >> 2.Add more '=' synbol to ethtool-netlink.rst to refine format.
> >> 3.Move definement of struct ethtool_ringparam_ext to include/linux/ethtool.h.
> >> 4.Move related modify of rings_fill_reply() from patch 4/6 to patch 3/6.
> >>
> >> V2 -> V3
> >> 1.Remove documentation for tx copybreak buf size, there is description for
> >> it in userspace ethtool.
> >> 2.Move extending parameters for get/set_ringparam function from patch3/6
> >> to patch 4/6.
> >>
> >> V1 -> V2
> >> 1.Add documentation for rx buf len and tx copybreak buf size.
> >> 2.Extend structure ringparam_ext for extenal ring params.
> >> 3.Change type of ETHTOOL_A_RINGS_RX_BUF_LEN from NLA_U32 to
> >>    NLA_POLICY_MIN(NLA_U32, 1).
> >> 4.Add supported_ring_params in ethtool_ops to indicate if support external
> >>    params.
> >>
> > 
> > [snip]
> > 
> > Thanks,
> > Al

Thanks,
Al
