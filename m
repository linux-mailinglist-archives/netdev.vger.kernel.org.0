Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F44E5B2CB
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 03:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfGABpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 21:45:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32916 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727117AbfGABpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 21:45:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9819B133E9BD5;
        Sun, 30 Jun 2019 18:45:31 -0700 (PDT)
Date:   Sun, 30 Jun 2019 18:45:31 -0700 (PDT)
Message-Id: <20190630.184531.1271846411270928340.davem@davemloft.net>
To:     john.hurley@netronome.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com
Subject: Re: [PATCH net 1/1] net: openvswitch: fix csum updates for MPLS
 actions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561642650-1974-1-git-send-email-john.hurley@netronome.com>
References: <1561642650-1974-1-git-send-email-john.hurley@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 30 Jun 2019 18:45:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>
Date: Thu, 27 Jun 2019 14:37:30 +0100

> Skbs may have their checksum value populated by HW. If this is a checksum
> calculated over the entire packet then the CHECKSUM_COMPLETE field is
> marked. Changes to the data pointer on the skb throughout the network
> stack still try to maintain this complete csum value if it is required
> through functions such as skb_postpush_rcsum.
> 
> The MPLS actions in Open vSwitch modify a CHECKSUM_COMPLETE value when
> changes are made to packet data without a push or a pull. This occurs when
> the ethertype of the MAC header is changed or when MPLS lse fields are
> modified.
> 
> The modification is carried out using the csum_partial function to get the
> csum of a buffer and add it into the larger checksum. The buffer is an
> inversion of the data to be removed followed by the new data. Because the
> csum is calculated over 16 bits and these values align with 16 bits, the
> effect is the removal of the old value from the CHECKSUM_COMPLETE and
> addition of the new value.
> 
> However, the csum fed into the function and the outcome of the
> calculation are also inverted. This would only make sense if it was the
> new value rather than the old that was inverted in the input buffer.
> 
> Fix the issue by removing the bit inverts in the csum_partial calculation.
> 
> The bug was verified and the fix tested by comparing the folded value of
> the updated CHECKSUM_COMPLETE value with the folded value of a full
> software checksum calculation (reset skb->csum to 0 and run
> skb_checksum_complete(skb)). Prior to the fix the outcomes differed but
> after they produce the same result.
> 
> Fixes: 25cd9ba0abc0 ("openvswitch: Add basic MPLS support to kernel")
> Fixes: bc7cc5999fd3 ("openvswitch: update checksum in {push,pop}_mpls")
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Applied and queued up for -stable, thanks.
