Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF8227EECF
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731140AbgI3QSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:18:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbgI3QSh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:18:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F223120708;
        Wed, 30 Sep 2020 16:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601482716;
        bh=FZDd9NrX/b3X4mhyCraw4fkVuDp38h8GVcG5bQ6IPOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D7dOdHbAvycDMu4PnK4XYyk/tC2brcv/Hwix+oIE4qjeoZ8xW7wMDdN4A2R/g3WIa
         YsGQKbpds+73FShsHxCwNy5uwRqdPjJnXOk/I1BvRu+y8S+Z+icclMvJ14HjPP/src
         NX4ao28aABFZeohCKkrOJrqptQ1EcL5/zsbgYr1c=
Date:   Wed, 30 Sep 2020 18:18:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Oliver Neukum <oneukum@suse.com>,
        "open list:USB ACM DRIVER" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
Message-ID: <20200930161838.GB1663344@kroah.com>
References: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr>
 <20200930144602.10290-6-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930144602.10290-6-mailhol.vincent@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 11:45:32PM +0900, Vincent Mailhol wrote:
> +	num_element =
> +	    es58x_msg_num_element(es58x_dev->dev,
> +				  bulk_rx_loopback_msg->rx_loopback_msg,
> +				  msg_len);
> +	if (unlikely(num_element <= 0))
> +		return num_element;

Meta-comment on your use of 'unlikely' everywhere.  Please drop it, it's
only to be used if you can actually measure the difference in a
benchmark.  You are dealing with USB devices, which are really really
slow here.  Also, humans make horrible guessers for this type of thing,
the compiler and CPU can get this right much more often than we can, and
we had the numbers for it (someone measured that 80-90% of our usages of
these markings are actually wrong on modern cpus).

So just drop them all, it makes the code simpler to read and understand,
and the cpu can actually go faster.

thanks,

greg k-h
