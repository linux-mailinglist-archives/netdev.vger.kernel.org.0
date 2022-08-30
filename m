Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65F75A6350
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 14:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiH3M3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 08:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiH3M3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 08:29:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBE6EE4AC
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 05:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wUipEENb5pG3AhDTYHjfqG9RcHxWGnoFkq5IutLEo1A=; b=AMKS3dyu71DQeqfvJfytGSztL1
        bzuTUt6aoG0ei7Z4XI6mjAYDVLYY5mGR6mKJju4FZEfgwjja0VAnEyRCZVXVL8h/sLNkfnyF2Mvz0
        QMxlFkUB1wp1bVFWnNTcVaKRPZxv3Vi27noJ58sSIUqnGJZAqYRsqGzx6N10cbPTrIpI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oT0Me-00F4Qv-HC; Tue, 30 Aug 2022 14:29:08 +0200
Date:   Tue, 30 Aug 2022 14:29:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, qiangqing.zhang@nxp.com,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH v2] net: fec: Use unlocked timecounter reads for saving
 state
Message-ID: <Yw4ClKHWACSP2EQ1@lunn.ch>
References: <20220830111516.82875-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830111516.82875-1-csokas.bence@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	fec_ptp_gettime(&fep->ptp_caps, &fep->ptp_saved_state.ts_phc);
> +	if (preempt_count_equals(0)) {

~/linux/drivers$ grep -r preempt_count_equals *
~/linux/drivers$ 

No other driver plays games like this.

Why not unconditionally take the lock?

    Andrew
