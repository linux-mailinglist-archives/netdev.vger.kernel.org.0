Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CC03F1CA1
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240109AbhHSPZg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Aug 2021 11:25:36 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:45472 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239151AbhHSPZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:25:35 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id E2013CED18;
        Thu, 19 Aug 2021 17:24:57 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH] Revert "Bluetooth: Shutdown controller after workqueues
 are flushed or cancelled"
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210816231150.1478727-1-dmitry.baryshkov@linaro.org>
Date:   Thu, 19 Aug 2021 17:24:57 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6CF07A82-966F-4DC2-B2B6-D0AB3DE354B5@holtmann.org>
References: <20210816231150.1478727-1-dmitry.baryshkov@linaro.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

> This reverts commit 0ea9fd001a14ebc294f112b0361a4e601551d508. It moved
> calling shutdown callback after flushing the queues. In doing so it
> disabled calling the shutdown hook completely: shutdown condition
> tests for HCI_UP in hdev->flags, which gets cleared now before checking
> this condition (see test_and_clear_bit(HCI_UP, ...) call). Thus shutdown
> hook was never called.
> 
> This would not be a problem itself and could fixed with just removing
> the HCI_UP condition (since if we are this point, we already know that
> the HCI device was up before calling hci_dev_do_close(). However the
> fact that shutdown hook was not called hid the fact that it is not
> proper to call shutdown hook so late in the sequence. The hook would
> usually call __hci_cmd_sync()/__hci_cmd_sync_ev(), which would timeout
> without running queues.
> 
> Thus I think it is more proper at this moment to revert the commit and
> look for a better solution.
> 
> Fixes: 0ea9fd001a14 ("Bluetooth: Shutdown controller after workqueues are flushed or cancelled")
> Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> ---
> net/bluetooth/hci_core.c | 16 ++++++++--------
> 1 file changed, 8 insertions(+), 8 deletions(-)

I just merged this patch:

commit 0ea53674d07fb6db2dd7a7ec2fdc85a12eb246c2
Author: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Tue Aug 10 12:53:15 2021 +0800

    Bluetooth: Move shutdown callback before flushing tx and rx queue
    
    Commit 0ea9fd001a14 ("Bluetooth: Shutdown controller after workqueues
    are flushed or cancelled") introduced a regression that makes mtkbtsdio
    driver stops working:

Please check if this works for you.

Regards

Marcel

