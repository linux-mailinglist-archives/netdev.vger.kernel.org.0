Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA37012F237
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgACAdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:33:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55872 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgACAdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:33:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2AF0615729D00;
        Thu,  2 Jan 2020 16:33:03 -0800 (PST)
Date:   Thu, 02 Jan 2020 16:33:02 -0800 (PST)
Message-Id: <20200102.163302.1487790740822950185.davem@davemloft.net>
To:     po.liu@nxp.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com, ivan.khoronzhuk@linaro.org
Subject: Re: [v3,net-next] enetc: add support time specific departure base
 on the qos etf
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200102044300.29951-1-Po.Liu@nxp.com>
References: <20191227025547.4452-1-Po.Liu@nxp.com>
        <20200102044300.29951-1-Po.Liu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 16:33:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <po.liu@nxp.com>
Date: Thu, 2 Jan 2020 04:59:24 +0000

> ENETC implement time specific departure capability, which enables
> the user to specify when a frame can be transmitted. When this
> capability is enabled, the device will delay the transmission of
> the frame so that it can be transmitted at the precisely specified time.
> The delay departure time up to 0.5 seconds in the future. If the
> departure time in the transmit BD has not yet been reached, based
> on the current time, the packet will not be transmitted.
> 
> This driver was loaded by Qos driver ETF. User could load it by tc
> commands. Here are the example commands:
> 
> tc qdisc add dev eth0 root handle 1: mqprio \
> 	   num_tc 8 map 0 1 2 3 4 5 6 7 hw 1
> tc qdisc replace dev eth0 parent 1:8 etf \
> 	   clockid CLOCK_TAI delta 30000  offload
> 
> These example try to set queue mapping first and then set queue 7
> with 30us ahead dequeue time.
> 
> Then user send test frame should set SO_TXTIME feature for socket.
> 
> There are also some limitations for this feature in hardware:
> - Transmit checksum offloads and time specific departure operation
> are mutually exclusive.
> - Time Aware Shaper feature (Qbv) offload and time specific departure
> operation are mutually exclusive.
> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes v2-v3:
> - Avoid tx checking sum offload when setting TXTIME offload. This is
> not support in hardware.

This looks a lot better, applied, thank you.
