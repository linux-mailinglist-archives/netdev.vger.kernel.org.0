Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A599101090
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKSBSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:18:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52146 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbfKSBSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:18:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A5006150FA0F8;
        Mon, 18 Nov 2019 17:18:09 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:18:09 -0800 (PST)
Message-Id: <20191118.171809.606798780477403243.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, pieter.jansenvanvuuren@netronome.com
Subject: Re: [PATCH net] net: sched: ensure opts_len <= IP_TUNNEL_OPTS_MAX
 in act_tunnel_key
From:   David Miller <davem@davemloft.net>
In-Reply-To: <920e2171915c7d2ba4c7ea4315e049370002afbe.1574069974.git.lucien.xin@gmail.com>
References: <920e2171915c7d2ba4c7ea4315e049370002afbe.1574069974.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 17:18:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Nov 2019 17:39:34 +0800

> info->options_len is 'u8' type, and when opts_len with a value >
> IP_TUNNEL_OPTS_MAX, 'info->options_len = opts_len' will cast int
> to u8 and set a wrong value to info->options_len.
> 
> Kernel crashed in my test when doing:
> 
>   # opts="0102:80:00800022"
>   # for i in {1..99}; do opts="$opts,0102:80:00800022"; done
>   # ip link add name geneve0 type geneve dstport 0 external
>   # tc qdisc add dev eth0 ingress
>   # tc filter add dev eth0 protocol ip parent ffff: \
>        flower indev eth0 ip_proto udp action tunnel_key \
>        set src_ip 10.0.99.192 dst_ip 10.0.99.193 \
>        dst_port 6081 id 11 geneve_opts $opts \
>        action mirred egress redirect dev geneve0
> 
> So we should do the similar check as cls_flower does, return error
> when opts_len > IP_TUNNEL_OPTS_MAX in tunnel_key_copy_opts().
> 
> Fixes: 0ed5269f9e41 ("net/sched: add tunnel option support to act_tunnel_key")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
