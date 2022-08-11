Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690B658FD67
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 15:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiHKNas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 09:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbiHKNao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 09:30:44 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DBE6D9DE
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 06:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=o8TBXrPewxVxxKQsTX+tIUZ+idTbz+8BynimZPzO+c4=; b=IlZVGW6wlH9S2u+gmeqq7AY4IN
        13Ld5OEgm/C7lPNleI+dQ44JvqRKBpmFNB5pXO9/1Yv1PZPTCdsgMM5/ujCLnni3ANbXOfR8b75kl
        GREGs8gMIlctqzV7bsHeGD5IVQdguDP1X4vsuPLzqOfuaNQY5GgGQKw1Hu8HDs/ymWxk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oM8Gm-00D1ym-V7; Thu, 11 Aug 2022 15:30:40 +0200
Date:   Thu, 11 Aug 2022 15:30:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH] fec: Restart PPS after link state change
Message-ID: <YvUEgKl6fpHwMwuS@lunn.ch>
References: <20220809124119.29922-1-csokas.bence@prolan.hu>
 <YvKZNcVfYdLw7bkm@lunn.ch>
 <299d74d5-2d56-23f6-affc-78bb3ae3e03c@prolan.hu>
 <YvRH06S/7E6J8RY0@lunn.ch>
 <9aa60160-8d8e-477f-991a-b2f4cc72ddf6@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9aa60160-8d8e-477f-991a-b2f4cc72ddf6@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> `fep->pps_enable` is the state of the PPS the driver *believes* to be the
> case. After a reset, this belief may or may not be true anymore: if the
> driver believed formerly that the PPS is down, then after a reset, its
> belief will still be correct, thus nothing needs to be done about the
> situation. If, however, the driver thought that PPS was up, after controller
> reset, it no longer holds, so we need to update our world-view
> (`fep->pps_enable = 0;`), and then correct for the fact that PPS just
> unexpectedly stopped.

Your way of doing it just seems very unclean. I would make
fec_ptp_enable_pps() read the actual status from the
hardware. fep->pps_enable then has the clear meaning of user space
requested it should be enabled.

	  Andrew
