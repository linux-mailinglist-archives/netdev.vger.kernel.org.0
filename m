Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD26D270851
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIRVdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgIRVdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:33:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BB9C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 14:33:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC56C159F5F91;
        Fri, 18 Sep 2020 14:16:20 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:33:07 -0700 (PDT)
Message-Id: <20200918.143307.346490364790511956.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, ioana.ciornei@nxp.com,
        ruxandra.radulescu@nxp.com, richardcochran@gmail.com,
        saeed@kernel.org
Subject: Re: [v4, 0/5] dpaa2_eth: support 1588 one-step timestamping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918090802.13757-1-yangbo.lu@nxp.com>
References: <20200918090802.13757-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:16:21 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Fri, 18 Sep 2020 17:07:57 +0800

> This patch-set is to add MC APIs of 1588 one-step timestamping, and
> support one-step timestamping for PTP Sync packet on DPAA2.
> 
> Before egress, one-step timestamping enablement needs,
> 
> - Enabling timestamp and FAS (Frame Annotation Status) in
>   dpni buffer layout.
> 
> - Write timestamp to frame annotation and set PTP bit in
>   FAS to mark as one-step timestamping event.
> 
> - Enabling one-step timestamping by dpni_set_single_step_cfg()
>   API, with offset provided to insert correction time on frame.
>   The offset must respect all MAC headers, VLAN tags and other
>   protocol headers accordingly. The correction field update can
>   consider delays up to one second. So PTP frame needs to be
>   filtered and parsed, and written timestamp into Sync frame
>   originTimestamp field.
> 
> The operation of API dpni_set_single_step_cfg() has to be done
> when no one-step timestamping frames are in flight. So we have
> to make sure the last one-step timestamping frame has already
> been transmitted on hardware before starting to send the current
> one. The resolution is,
> 
> - Utilize skb->cb[0] to mark timestamping request per packet.
>   If it is one-step timestamping PTP sync packet, queue to skb queue.
>   If not, transmit immediately.
> 
> - Schedule a work to transmit skbs in skb queue.
> 
> - mutex lock is used to ensure the last one-step timestamping packet
>   has already been transmitted on hardware through TX confirmation queue
>   before transmitting current packet.
 ...

Series applied to net-next, thanks.
