Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4996C138400
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 00:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731665AbgAKXbg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 11 Jan 2020 18:31:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49516 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731658AbgAKXbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 18:31:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 443D115A0BDD7;
        Sat, 11 Jan 2020 15:31:35 -0800 (PST)
Date:   Sat, 11 Jan 2020 15:31:34 -0800 (PST)
Message-Id: <20200111.153134.978765596460592103.davem@davemloft.net>
To:     johnathanx.mantey@intel.com
Cc:     netdev@vger.kernel.org, sam@mendozajonas.com
Subject: Re: [PATCH] Propagate NCSI channel carrier loss/gain events to the
 kernel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b2ef76f2-cf4e-3d14-7436-8c66e63776ba@intel.com>
References: <b2ef76f2-cf4e-3d14-7436-8c66e63776ba@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 11 Jan 2020 15:31:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johnathan Mantey <johnathanx.mantey@intel.com>
Date: Fri, 10 Jan 2020 14:02:23 -0800


Please format your Subject line as:

Subject: $SUBSYSTEM_PREFIX: Summary.

Here, $SUBSYSTEM_PREFIX would be "ncsi: "

> Problem statement:
> Insertion or removal of a network cable attached to a NCSI controlled
> network channel does not notify the kernel of the loss/gain of the
> network link.
> 
> The expectation is that /sys/class/net/eth(x)/carrier will change
> state after a pull/insertion event. In addition the carrier_up_count
> and carrier_down_count files should increment.
> 
> Change statement:
> Use the NCSI Asynchronous Event Notification handler to detect a
> change in a NCSI link.
> Add code to propagate carrier on/off state to the network interface.
> The on/off state is only modified after the existing code identifies
> if the network device HAD or HAS a link state change.

Please remove this "Problem statement:" and "Change statement:", we know
what you are talking about.

> @@ -89,6 +89,12 @@ static int ncsi_aen_handler_lsc(struct ncsi_dev_priv
> *ndp,
>      if ((had_link == has_link) || chained)
>          return 0;
>  
> +    if (had_link) {
> +        netif_carrier_off(ndp->ndev.dev);
> +    } else {
> +        netif_carrier_on(ndp->ndev.dev);
> +    }

As per coding style, single line basic blocks should not get curly
braces around them in this situation.

Thank you.
