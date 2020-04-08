Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9A71A2B4B
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 23:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730748AbgDHVel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 17:34:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53034 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgDHVel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 17:34:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C4D2127D38BE;
        Wed,  8 Apr 2020 14:34:40 -0700 (PDT)
Date:   Wed, 08 Apr 2020 14:34:39 -0700 (PDT)
Message-Id: <20200408.143439.2032281152789533700.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        jakub@cloudflare.com, dirk.vandermerwe@netronome.com,
        simon.horman@netronome.com, dcaratti@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/tls: fix const assignment warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200408185452.279040-1-arnd@arndb.de>
References: <20200408185452.279040-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Apr 2020 14:34:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed,  8 Apr 2020 20:54:43 +0200

> Building with some experimental patches, I came across a warning
> in the tls code:
> 
> include/linux/compiler.h:215:30: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>   215 |  *(volatile typeof(x) *)&(x) = (val);  \
>       |                              ^
> net/tls/tls_main.c:650:4: note: in expansion of macro 'smp_store_release'
>   650 |    smp_store_release(&saved_tcpv4_prot, prot);
> 
> This appears to be a legitimate warning about assigning a const pointer
> into the non-const 'saved_tcpv4_prot' global. Annotate both the ipv4 and
> ipv6 pointers 'const' to make the code internally consistent.
> 
> Fixes: 5bb4c45d466c ("net/tls: Read sk_prot once when building tls proto ops")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.
