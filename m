Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA17913502D
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgAHX55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:57:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49632 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgAHX54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 18:57:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC3E91511CAA1;
        Wed,  8 Jan 2020 15:57:55 -0800 (PST)
Date:   Wed, 08 Jan 2020 15:57:55 -0800 (PST)
Message-Id: <20200108.155755.1067276795351478319.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net] tipc: fix link overflow issue at socket shutdown
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200108021815.24713-1-tuong.t.lien@dektech.com.au>
References: <20200108021815.24713-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 15:57:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Wed,  8 Jan 2020 09:18:15 +0700

> When a socket is suddenly shutdown or released, it will reject all the
> unreceived messages in its receive queue. This applies to a connected
> socket too, whereas there is only one 'FIN' message required to be sent
> back to its peer in this case.
> 
> In case there are many messages in the queue and/or some connections
> with such messages are shutdown at the same time, the link layer will
> easily get overflowed at the 'TIPC_SYSTEM_IMPORTANCE' backlog level
> because of the message rejections. As a result, the link will be taken
> down. Moreover, immediately when the link is re-established, the socket
> layer can continue to reject the messages and the same issue happens...
> 
> The commit refactors the '__tipc_shutdown()' function to only send one
> 'FIN' in the situation mentioned above. For the connectionless case, it
> is unavoidable but usually there is no rejections for such socket
> messages because they are 'dest-droppable' by default.
> 
> In addition, the new code makes the other socket states clear
> (e.g.'TIPC_LISTEN') and treats as a separate case to avoid misbehaving.
> 
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied.
