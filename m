Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A63170F8E
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgB0ESp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:18:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36894 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbgB0ESp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:18:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5AD4615B46348;
        Wed, 26 Feb 2020 20:18:44 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:18:43 -0800 (PST)
Message-Id: <20200226.201843.1419217208264213943.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net] net/smc: fix cleanup for linkgroup setup failures
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225153436.26498-1-kgraul@linux.ibm.com>
References: <20200225153436.26498-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:18:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Tue, 25 Feb 2020 16:34:36 +0100

> From: Ursula Braun <ubraun@linux.ibm.com>
> 
> If an SMC connection to a certain peer is setup the first time,
> a new linkgroup is created. In case of setup failures, such a
> linkgroup is unusable and should disappear. As a first step the
> linkgroup is removed from the linkgroup list in smc_lgr_forget().
> 
> There are 2 problems:
> smc_listen_decline() might be called before linkgroup creation
> resulting in a crash due to calling smc_lgr_forget() with
> parameter NULL.
> If a setup failure occurs after linkgroup creation, the connection
> is never unregistered from the linkgroup, preventing linkgroup
> freeing.
> 
> This patch introduces an enhanced smc_lgr_cleanup_early() function
> which
> * contains a linkgroup check for early smc_listen_decline()
>   invocations
> * invokes smc_conn_free() to guarantee unregistering of the
>   connection.
> * schedules fast linkgroup removal of the unusable linkgroup
> 
> And the unused function smcd_conn_free() is removed from smc_core.h.
> 
> Fixes: 3b2dec2603d5b ("net/smc: restructure client and server code in af_smc")
> Fixes: 2a0674fffb6bc ("net/smc: improve abnormal termination of link groups")
> Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

Applied and queued up for -stable, thanks.
