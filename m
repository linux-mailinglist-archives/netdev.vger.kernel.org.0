Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A93D10A6B3
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfKZWle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:41:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43510 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfKZWle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:41:34 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E10E14D78B28;
        Tue, 26 Nov 2019 14:41:33 -0800 (PST)
Date:   Tue, 26 Nov 2019 14:41:31 -0800 (PST)
Message-Id: <20191126.144131.1380494669149571889.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, yotamg@mellanox.com, jiri@mellanox.com,
        jhs@mojatatu.com, simon.horman@netronome.com,
        roopa@cumulusnetworks.com
Subject: Re: [PATCH net] net: psample: fix skb_over_panic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191126221644.23281-1-nikolay@cumulusnetworks.com>
References: <20191126221644.23281-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 14:41:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Wed, 27 Nov 2019 00:16:44 +0200

> We need to calculate the skb size correctly otherwise we risk triggering
> skb_over_panic[1]. The issue is that data_len is added to the skb in a
> nl attribute, but we don't account for its header size (nlattr 4 bytes)
> and alignment. We account for it when calculating the total size in
> the > PSAMPLE_MAX_PACKET_SIZE comparison correctly, but not when
> allocating after that. The fix is simple - use nla_total_size() for
> data_len when allocating.
> 
> To reproduce:
>  $ tc qdisc add dev eth1 clsact
>  $ tc filter add dev eth1 egress matchall action sample rate 1 group 1 trunc 129
>  $ mausezahn eth1 -b bcast -a rand -c 1 -p 129
>  < skb_over_panic BUG(), tail is 4 bytes past skb->end >
> 
> [1] Trace:
 ...
> CC: Yotam Gigi <yotamg@mellanox.com>
> CC: Jiri Pirko <jiri@mellanox.com>
> CC: Jamal Hadi Salim <jhs@mojatatu.com>
> CC: Simon Horman <simon.horman@netronome.com>
> CC: Roopa Prabhu <roopa@cumulusnetworks.com>
> Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied and queued up for -stable, thanks.
