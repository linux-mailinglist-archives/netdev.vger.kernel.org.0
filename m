Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AE720FD24
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgF3T6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgF3T6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:58:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2B2C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:58:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E31DC1275B691;
        Tue, 30 Jun 2020 12:58:02 -0700 (PDT)
Date:   Tue, 30 Jun 2020 12:58:02 -0700 (PDT)
Message-Id: <20200630.125802.533305649716945637.davem@davemloft.net>
To:     tobias@waldekranz.com
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com
Subject: Re: [PATCH net] net: ethernet: fec: prevent tx starvation under
 high rx load
From:   David Miller <davem@davemloft.net>
In-Reply-To: <C3U8BLV1WZ9R.1SDRQTA6XXRPB@wkz-x280>
References: <20200629.130731.932623918439489841.davem@davemloft.net>
        <C3U8BLV1WZ9R.1SDRQTA6XXRPB@wkz-x280>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 12:58:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Tobias Waldekranz" <tobias@waldekranz.com>
Date: Tue, 30 Jun 2020 08:39:58 +0200

> On Mon Jun 29, 2020 at 3:07 PM CEST, David Miller wrote:
>> I don't see how this can happen since you process the TX queue
>> unconditionally every NAPI pass, regardless of what bits you see
>> set in the IEVENT register.
>>
>> Or don't you? Oh, I see, you don't:
>>
>> for_each_set_bit(queue_id, &fep->work_tx, FEC_ENET_MAX_TX_QS) {
>>
>> That's the problem. Just unconditionally process the TX work regardless
>> of what is in IEVENT. That whole ->tx_work member and the code that
>> uses it can just be deleted. fec_enet_collect_events() can just return
>> a boolean saying whether there is any RX or TX work at all.
> 
> Maybe Andy could chime in here, but I think the ->tx_work construction
> is load bearing. It seems to me like that is the only thing stopping
> us from trying to process non-existing queues on older versions of the
> silicon which only has a single queue.

Then iterate over "actually existing" queues.

My primary point still stands.
