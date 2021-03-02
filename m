Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C73F32B3A7
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449879AbhCCEEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:04:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1580337AbhCBSBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 13:01:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06C6F64F1E;
        Tue,  2 Mar 2021 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614708048;
        bh=6KnJp1FUtZrpZC7tqgaXpVtSc7KpPK6aUdDT/zoa/wc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hcPaFw1/ehVxKH7HHUDb3MKCIzkn0ptfV2Sbj5QJjIvDCOWL+Haz+7vvHURK0m2Bh
         IIEPhh6GojQ2o0k0QH0dGpl/Lgz1hr2cDaBFURim8DcMr/sy+d60Qv36ojnJR/se3T
         rdzCfyOTAUTzpgL/X5kn6dnkguBEGJG9m6zDu4NYTLw9WWLMwZ4avhJzDZwwvL0s7s
         MFvcpCQN4YDSXHskGLFB1CkY1h9vd8UzxlCgv+L+O+YaSPhviFvSw5qdPWY70EoEfe
         tuDwIKl62aNHrKHT8VgLrOpOdm33dylB16YSQrzaUSG/g/HttSxJSLGAkcmi4dWP+1
         GwlsgM5PNu8RQ==
Date:   Tue, 2 Mar 2021 10:00:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, kernel-team@fb.com,
        Neil Spring <ntspring@fb.com>
Subject: Re: [PATCH net-next v2] tcp: make TCP Fast Open retransmission
 ignore Tx status
Message-ID: <20210302100047.43e8fed9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210302175259.971778-1-kuba@kernel.org>
References: <20210302175259.971778-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Mar 2021 09:52:59 -0800 Jakub Kicinski wrote:
> When receiver does not accept TCP Fast Open it will only ack
> the SYN, and not the data. We detect this and immediately queue
> the data for (re)transmission in tcp_rcv_fastopen_synack().
> 
> In DC networks with very low RTT and without RFS the SYN-ACK
> may arrive before NIC driver reported Tx completion on
> the original SYN. In which case skb_still_in_host_queue()
> returns true and sender will need to wait for the retransmission
> timer to fire milliseconds later.
> 
> Work around this issue by passing negative segment count to
> __tcp_retransmit_skb() as suggested by Eric.
> 
> The condition triggers more often when Tx coalescing is configured
> higher than Rx coalescing on the underlying NIC, but it does happen
> even with relatively moderate and even settings (e.g. 33us).
> 
> Note that DC machines usually run configured to always accept
> TCP FastOpen data so the problem may not be very common.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Neil Spring <ntspring@fb.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

.. and now I realized net-next is closed. I'll keep an eye on patchwork
and resend as needed, sorry.
