Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC9737E02A
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 18:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732963AbfHAQ1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 12:27:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729293AbfHAQ1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 12:27:50 -0400
Received: from localhost (unknown [IPv6:2603:3004:624:eb00::2d06])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB304153EF902;
        Thu,  1 Aug 2019 09:27:48 -0700 (PDT)
Date:   Thu, 01 Aug 2019 12:27:45 -0400 (EDT)
Message-Id: <20190801.122745.9301893283319822.davem@davemloft.net>
To:     avifishman70@gmail.com
Cc:     venture@google.com, yuenn@google.com, benjaminfair@google.com,
        robh+dt@kernel.org, mark.rutland@arm.com,
        gregkh@linuxfoundation.org, tmaimon77@gmail.com,
        tali.perry1@gmail.com, openbmc@lists.ozlabs.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH v1 2/2] net: npcm: add NPCM7xx EMC 10/100 Ethernet
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801072611.27935-3-avifishman70@gmail.com>
References: <20190801072611.27935-1-avifishman70@gmail.com>
        <20190801072611.27935-3-avifishman70@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 01 Aug 2019 09:27:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avi Fishman <avifishman70@gmail.com>
Date: Thu,  1 Aug 2019 10:26:11 +0300

> +#Eternet 10/100 EMC

"Ethernet"

> +#ifdef CONFIG_NPCM7XX_EMC_ETH_DEBUG
> +#define DEBUG
> +#endif

Please don't control the DEBUG define in this way.

> +#if defined CONFIG_NPCM7XX_EMC_ETH_DEBUG || defined CONFIG_DEBUG_FS
> +#define REG_PRINT(reg_name) {t = scnprintf(next, size, "%-10s = %08X\n", \
> +	#reg_name, readl(ether->reg + (reg_name))); size -= t;	next += t; }
> +#define DUMP_PRINT(f, x...) {t = scnprintf(next, size, f, ## x); size -= t; \
> +	next += t; }

Really, get rid of this custom debugging infrastructure and just use
generic facilities the kernel has for this, as designed.

> +static int npcm7xx_info_dump(char *buf, int count, struct net_device *netdev)
> +{
> +	struct npcm7xx_ether *ether = netdev_priv(netdev);
> +	struct npcm7xx_txbd *txbd;
> +	struct npcm7xx_rxbd *rxbd;
> +	unsigned long flags;
> +	unsigned int i, cur, txd_offset, rxd_offset;
> +	char *next = buf;
> +	unsigned int size = count;
> +	int t;
> +	int is_locked = spin_is_locked(&ether->lock);

Reverse christmas tree (longest to shortest) ordering for local variables
please.

Audit your entire submission for this problem.
