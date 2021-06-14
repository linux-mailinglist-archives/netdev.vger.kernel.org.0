Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819F53A7196
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 23:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhFNV5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 17:57:02 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42444 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhFNV4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 17:56:52 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2988664229;
        Mon, 14 Jun 2021 23:52:37 +0200 (CEST)
Date:   Mon, 14 Jun 2021 23:53:51 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, roid@nvidia.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] Revert "netfilter: flowtable: Remove redundant hw
 refresh bit"
Message-ID: <20210614215351.GA734@salvia>
References: <20210614193440.3813-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210614193440.3813-1-olek2@wp.pl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jun 14, 2021 at 09:34:40PM +0200, Aleksander Jan Bajkowski wrote:
> This reverts commit c07531c01d8284aedaf95708ea90e76d11af0e21.
>
> The previously mentioned commit significantly reduces NAT performance
> in OpenWRT. Another user reports a high ping issue. The results of
> IPv4 NAT benchmark on BT Home Hub 5A (with software flow offloading):
> * 5.4.124             515 Mb/s
> * 5.10.41             570 Mb/s
> * 5.10.42             250 Mb/s
> * 5.10.42 + revert    580 Mb/s
>
> Reverting this commit fixes this issue.

The xt_flowoffload module is inconditionally setting on the hardware
offload flag:

static int __init xt_flowoffload_tg_init(void)
{
       int ret;

       register_netdevice_notifier(&flow_offload_netdev_notifier);

       ret = init_flowtable(&flowtable[0]);
       if (ret)
               return ret;

       ret = init_flowtable(&flowtable[1]);
       if (ret)
               goto cleanup;

       flowtable[1].ft.flags = NF_FLOWTABLE_HW_OFFLOAD;
[...]

which is triggering the slow down because packet path is allocating
work to offload the entry to hardware, however, this driver does not
support for hardware offload.

Probably this module can be updated to unset the flowtable flag if the
harware does not support hardware offload.
