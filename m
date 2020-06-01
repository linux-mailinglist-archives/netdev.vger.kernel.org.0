Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790D41EAC89
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731179AbgFAShp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728887AbgFAShm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:37:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081B3C00863A;
        Mon,  1 Jun 2020 11:32:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86D1511D53F8B;
        Mon,  1 Jun 2020 11:32:07 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:32:06 -0700 (PDT)
Message-Id: <20200601.113206.2297277969426428314.davem@davemloft.net>
To:     hexie3605@gmail.com
Cc:     kuba@kernel.org, madhuparnabhowmik04@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/wan/lapbether.c: Fixed kernel panic when
 used with AF_PACKET sockets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528032134.13752-1-hexie3605@gmail.com>
References: <20200528032134.13752-1-hexie3605@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:32:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <hexie3605@gmail.com>
Date: Wed, 27 May 2020 20:21:33 -0700

> When we use "AF_PACKET" sockets to send data directly over LAPB over
> Ethernet using this driver, the kernel will panic because of
> insufficient header space allocated in the "sk_buff" struct.
> 
> The header space needs 18 bytes because:
>   the lapbether driver will remove a pseudo header of 1 byte;
>   the lapb module will prepend the LAPB header of 2 or 3 bytes;
>   the lapbether driver will prepend a length field of 2 bytes and the
> Ethernet header of 14 bytes.
> 
> So -1 + 3 + 16 = 18.
> 
> Signed-off-by: Xie He <hexie3605@gmail.com>

This is not the real problem.

The real problem is that this is a stacked, layered, device and the
lapbether driver does not take the inner device's header length into
consideration.  It should take this from the child device's netdev
structure rather than use constants.

Your test case will still fail when lapbether is stacked on top of a
VLAN device or similar, even with your changes.
