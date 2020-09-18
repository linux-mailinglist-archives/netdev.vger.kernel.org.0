Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5B826EA3D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgIRBFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgIRBFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 21:05:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B09FC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 18:05:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 696D71368368E;
        Thu, 17 Sep 2020 17:48:22 -0700 (PDT)
Date:   Thu, 17 Sep 2020 18:05:08 -0700 (PDT)
Message-Id: <20200917.180508.408478469576670851.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, cpaasch@apple.com
Subject: Re: [PATCH net-next] mptcp: fix integer overflow in
 mptcp_subflow_discard_data()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1a927c595adf46cf5ff186ca6b129f12fb70f492.1600375771.git.pabeni@redhat.com>
References: <1a927c595adf46cf5ff186ca6b129f12fb70f492.1600375771.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 17:48:22 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 17 Sep 2020 23:07:24 +0200

> Christoph reported an infinite loop in the subflow receive path
> under stress condition.
> 
> If there are multiple subflows, each of them using a large send
> buffer, the delta between the sequence number used by
> MPTCP-level retransmission can and the current msk->ack_seq
> can be greater than MAX_INT.
> 
> In the above scenario, when calling mptcp_subflow_discard_data(),
> such delta will be truncated to int, and could result in a negative
> number: no bytes will be dropped, and subflow_check_data_avail()
> will try again to process the same packet, looping forever.
> 
> This change addresses the issue by expanding the 'limit' size to 64
> bits, so that overflows are not possible anymore.
> 
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/87
> Fixes: 6719331c2f73 ("mptcp: trigger msk processing even for OoO data")
> Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net-next patch, as the culprit commit is only on net-next currently

Applied, thank you.
