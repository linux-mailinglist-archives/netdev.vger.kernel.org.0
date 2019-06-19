Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4234AF95
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 03:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbfFSBms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 21:42:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56378 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFSBms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 21:42:48 -0400
Received: from localhost (unknown [8.46.76.24])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7653014CC8ADE;
        Tue, 18 Jun 2019 18:42:36 -0700 (PDT)
Date:   Tue, 18 Jun 2019 21:42:32 -0400 (EDT)
Message-Id: <20190618.214232.430281845003030631.davem@davemloft.net>
To:     sunilmut@microsoft.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, decui@microsoft.com, mikelley@microsoft.com,
        netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] hvsock: fix epollout hang from race condition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <MW2PR2101MB111670139C7F5DC567129DD3C0EB0@MW2PR2101MB1116.namprd21.prod.outlook.com>
References: <MW2PR2101MB111670139C7F5DC567129DD3C0EB0@MW2PR2101MB1116.namprd21.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 18:42:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Muthuswamy <sunilmut@microsoft.com>
Date: Mon, 17 Jun 2019 19:26:25 +0000

> Currently, hvsock can enter into a state where epoll_wait on EPOLLOUT will
> not return even when the hvsock socket is writable, under some race
> condition. This can happen under the following sequence:
...
> Now, the EPOLLOUT will never return even if the socket write buffer is
> empty.
> 
> The fix is to set the pending size to the default size and never change it.
> This way the host will always notify the guest whenever the writable space
> is bigger than the pending size. The host is already optimized to *only*
> notify the guest when the pending size threshold boundary is crossed and
> not everytime.
> 
> This change also reduces the cpu usage somewhat since hv_stream_has_space()
> is in the hotpath of send:
> vsock_stream_sendmsg()->hv_stream_has_space()
> Earlier hv_stream_has_space was setting/clearing the pending size on every
> call.
> 
> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> ---
> - Resubmitting the patch after taking care of some spurious warnings.

Applied and queued up for -stable.
