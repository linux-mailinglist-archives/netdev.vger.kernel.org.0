Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A74F495D5
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbfFQXZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:25:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40030 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFQXZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 19:25:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A66CF151BE53C;
        Mon, 17 Jun 2019 16:25:49 -0700 (PDT)
Date:   Mon, 17 Jun 2019 16:25:49 -0700 (PDT)
Message-Id: <20190617.162549.1412778806814827330.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, georg.waibel@sensor-technik.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: fix ptp link error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617131430.2263299-1-arnd@arndb.de>
References: <20190617131430.2263299-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 16:25:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 17 Jun 2019 15:14:10 +0200

> Due to a reversed dependency, it is possible to build
> the lower ptp driver as a loadable module and the actual
> driver using it as built-in, causing a link error:
> 
> drivers/net/dsa/sja1105/sja1105_spi.o: In function `sja1105_static_config_upload':
> sja1105_spi.c:(.text+0x6f0): undefined reference to `sja1105_ptp_reset'
> drivers/net/dsa/sja1105/sja1105_spi.o:(.data+0x2d4): undefined reference to `sja1105et_ptp_cmd'
> drivers/net/dsa/sja1105/sja1105_spi.o:(.data+0x604): undefined reference to `sja1105pqrs_ptp_cmd'
> drivers/net/dsa/sja1105/sja1105_main.o: In function `sja1105_remove':
> sja1105_main.c:(.text+0x8d4): undefined reference to `sja1105_ptp_clock_unregister'
> drivers/net/dsa/sja1105/sja1105_main.o: In function `sja1105_rxtstamp_work':
> sja1105_main.c:(.text+0x964): undefined reference to `sja1105_tstamp_reconstruct'
> drivers/net/dsa/sja1105/sja1105_main.o: In function `sja1105_setup':
> sja1105_main.c:(.text+0xb7c): undefined reference to `sja1105_ptp_clock_register'
> drivers/net/dsa/sja1105/sja1105_main.o: In function `sja1105_port_deferred_xmit':
> sja1105_main.c:(.text+0x1fa0): undefined reference to `sja1105_ptpegr_ts_poll'
> sja1105_main.c:(.text+0x1fc4): undefined reference to `sja1105_tstamp_reconstruct'
> drivers/net/dsa/sja1105/sja1105_main.o:(.rodata+0x5b0): undefined reference to `sja1105_get_ts_info'
> 
> Change the Makefile logic to always build the ptp module
> the same way as the rest. Another option would be to
> just add it to the same module and remove the exports,
> but I don't know if there was a good reason to keep them
> separate.
> 
> Fixes: bb77f36ac21d ("net: dsa: sja1105: Add support for the PTP clock")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.
