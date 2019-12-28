Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31F212BC01
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 01:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfL1AgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 19:36:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53800 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfL1AgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 19:36:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CE2F154D18C8;
        Fri, 27 Dec 2019 16:36:23 -0800 (PST)
Date:   Fri, 27 Dec 2019 16:36:22 -0800 (PST)
Message-Id: <20191227.163622.1874013727124631819.davem@davemloft.net>
To:     shmulik@metanetworks.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, shmulik.ladkani@gmail.com,
        sladkani@proofpoint.com
Subject: Re: [PATCH net] net/sched: act_mirred: Pull mac prior redir to non
 mac_header_xmit device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191225085101.19696-1-sladkani@proofpoint.com>
References: <20191225085101.19696-1-sladkani@proofpoint.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Dec 2019 16:36:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: shmulik@metanetworks.com
Date: Wed, 25 Dec 2019 10:51:01 +0200

> From: Shmulik Ladkani <sladkani@proofpoint.com>
> 
> There's no skb_pull performed when a mirred action is set at egress of a
> mac device, with a target device/action that expects skb->data to point
> at the network header.
> 
> As a result, either the target device is errornously given an skb with
> data pointing to the mac (egress case), or the net stack receives the
> skb with data pointing to the mac (ingress case).
> 
> E.g:
>  # tc qdisc add dev eth9 root handle 1: prio
>  # tc filter add dev eth9 parent 1: prio 9 protocol ip handle 9 basic \
>    action mirred egress redirect dev tun0
> 
>  (tun0 is a tun device. result: tun0 errornously gets the eth header
>   instead of the iph)
> 
> Revise the push/pull logic of tcf_mirred_act() to not rely on the
> skb_at_tc_ingress() vs tcf_mirred_act_wants_ingress() comparison, as it
> does not cover all "pull" cases.
> 
> Instead, calculate whether the required action on the target device
> requires the data to point at the network header, and compare this to
> whether skb->data points to network header - and make the push/pull
> adjustments as necessary.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Shmulik Ladkani <sladkani@proofpoint.com>
> Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

Applied and queued up for -stable.
