Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AEC3E9A41
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhHKVKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231927AbhHKVKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 17:10:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A13AF61058;
        Wed, 11 Aug 2021 21:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628716180;
        bh=OGt1kefX9SyqR9veg0o20NAPlVu3t7zr5uqyF3w4gUk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uW2uc2AuPRTd5RJqnZdgUeitZUrgWQFAX5erc3FUzZCse44hquRDbmzUr+ReZvO2C
         YkvWTGVZsycNK2vEPuGtSXveZBvgeNOeCX7VAPjYNyDtqRrkMKjf6Mz0yl5Os0JaaJ
         F//ov3vNiFCMMSdUTrbitl1qeC95tSSzL5Eje8p/hcoTwvvqCjfypdcdhkckawDivq
         8SifiRAP3+LCgZvBCbqAGqvdM5k7Jg6RNQmiaRcxe035Kp+GWR1t1IDeKAZXvVogjh
         LQqhI5XYjp9H4+I3OZ3dSiE5xA8mgxHMs8HH54YpypbAxBiTjJw7Whnv0ny/FnuZX7
         5D4Ut7Rf8mIJQ==
Date:   Wed, 11 Aug 2021 14:09:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Jeffrey Huang <huangjw@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Andrew Gospodarek <gospo@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: Re: [PATCH net 1/4] bnxt: don't lock the tx queue from napi poll
Message-ID: <20210811140939.3a13b6e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLin+2hzGOGqt0Qs8HNHnBADooZN=6yt7budLEUn_BhmU5Q@mail.gmail.com>
References: <20210811193239.3155396-1-kuba@kernel.org>
        <20210811193239.3155396-2-kuba@kernel.org>
        <CACKFLin+2hzGOGqt0Qs8HNHnBADooZN=6yt7budLEUn_BhmU5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 13:42:40 -0700 Michael Chan wrote:
> > -       if (unlikely(netif_tx_queue_stopped(txq)) &&
> > -           (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh)) {
> > -               __netif_tx_lock(txq, smp_processor_id());
> > -               if (netif_tx_queue_stopped(txq) &&
> > -                   bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
> > -                   txr->dev_state != BNXT_DEV_STATE_CLOSING)
> > -                       netif_tx_wake_queue(txq);
> > -               __netif_tx_unlock(txq);
> > -       }
> > +       if (netif_tx_queue_stopped(txq) &&
> > +           bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
> > +           READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING)  
> 
> This can race with bnxt_start_xmit().  bnxt_start_xmit() can also wake
> up the queue when it sees that descriptors are available.  I think
> this is the reason we added tx locking here.  The race may be ok
> because in the worst case, we will wake up the TX queue when it's not
> supposed to wakeup.  If that happens, bnxt_start_xmit() will return
> NETDEV_TX_BUSY and stop the queue again when there are not enough TX
> descriptors.

Good point, let me remove the warning from patch 3, then.
