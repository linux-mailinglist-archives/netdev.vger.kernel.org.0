Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2FE22443F
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgGQTad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbgGQTad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:30:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6B7C0619D2;
        Fri, 17 Jul 2020 12:30:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D3F311E4590B;
        Fri, 17 Jul 2020 12:30:31 -0700 (PDT)
Date:   Fri, 17 Jul 2020 12:30:27 -0700 (PDT)
Message-Id: <20200717.123027.1640292958732505858.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 04/10] net/smc: protect smc ib device initialization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200716153746.77303-5-kgraul@linux.ibm.com>
References: <20200716153746.77303-1-kgraul@linux.ibm.com>
        <20200716153746.77303-5-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 12:30:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Thu, 16 Jul 2020 17:37:40 +0200

> Fix that by protecting the critical code using a mutex.
 ...
> @@ -52,6 +52,7 @@ struct smc_ib_device {				/* ib-device infos for smc */
>  	DECLARE_BITMAP(ports_going_away, SMC_MAX_PORTS);
>  	atomic_t		lnk_cnt;	/* number of links on ibdev */
>  	wait_queue_head_t	lnks_deleted;	/* wait 4 removal of all links*/
> +	struct mutex		mutex;		/* protects smc ib device */
>  };

So which is it?  Does the mutex protect the entire contents of the
smc ib device struct, as stated in the comment?  Or does it only
synchronize object creation?

One of them is obviously wrong, so please correct that.
