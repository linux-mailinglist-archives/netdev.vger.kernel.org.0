Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEF71C7CFF
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 00:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgEFWEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 18:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728621AbgEFWEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 18:04:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B834C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 15:04:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 786E71273D970;
        Wed,  6 May 2020 15:04:05 -0700 (PDT)
Date:   Wed, 06 May 2020 15:04:04 -0700 (PDT)
Message-Id: <20200506.150404.807895268973641753.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, christian.herber@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: sja1105: the PTP_CLK extts input reacts
 on both edges
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506174813.14587-1-olteanv@gmail.com>
References: <20200506174813.14587-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 15:04:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed,  6 May 2020 20:48:13 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It looks like the sja1105 external timestamping input is not as generic
> as we thought. When fed a signal with 50% duty cycle, it will timestamp
> both the rising and the falling edge. When fed a short pulse signal,
> only the timestamp of the falling edge will be seen in the PTPSYNCTS
> register, because that of the rising edge had been overwritten. So the
> moral is: don't feed it short pulse inputs.
> 
> Luckily this is not a complete deal breaker, as we can still work with
> 1 Hz square waves. But the problem is that the extts polling period was
> not dimensioned enough for this input signal. If we leave the period at
> half a second, we risk losing timestamps due to jitter in the measuring
> process. So we need to increase it to 4 times per second.
> 
> Also, the very least we can do to inform the user is to deny any other
> flags combination than with PTP_RISING_EDGE and PTP_FALLING_EDGE both
> set.
> 
> Fixes: 747e5eb31d59 ("net: dsa: sja1105: configure the PTP_CLK pin as EXT_TS or PER_OUT")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied.
