Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40C21653A4
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgBTAe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:34:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49570 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgBTAe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 19:34:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 671C915BD9502;
        Wed, 19 Feb 2020 16:34:56 -0800 (PST)
Date:   Wed, 19 Feb 2020 16:34:55 -0800 (PST)
Message-Id: <20200219.163455.2118359448089082650.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, plroskin@gmail.com, edumazet@google.com,
        willemb@google.com
Subject: Re: [PATCH net] udp: rehash on disconnect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219191632.253526-1-willemdebruijn.kernel@gmail.com>
References: <20200219191632.253526-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 16:34:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 19 Feb 2020 14:16:32 -0500

> From: Willem de Bruijn <willemb@google.com>
> 
> As of the below commit, udp sockets bound to a specific address can
> coexist with one bound to the any addr for the same port.
> 
> The commit also phased out the use of socket hashing based only on
> port (hslot), in favor of always hashing on {addr, port} (hslot2).
> 
> The change broke the following behavior with disconnect (AF_UNSPEC):
> 
>     server binds to 0.0.0.0:1337
>     server connects to 127.0.0.1:80
>     server disconnects
>     client connects to 127.0.0.1:1337
>     client sends "hello"
>     server reads "hello"	// times out, packet did not find sk
> 
> On connect the server acquires a specific source addr suitable for
> routing to its destination. On disconnect it reverts to the any addr.
> 
> The connect call triggers a rehash to a different hslot2. On
> disconnect, add the same to return to the original hslot2.
> 
> Skip this step if the socket is going to be unhashed completely.
> 
> Fixes: 4cdeeee9252a ("net: udp: prefer listeners bound to an address")
> Reported-by: Pavel Roskin <plroskin@gmail.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable, thanks Willem.
