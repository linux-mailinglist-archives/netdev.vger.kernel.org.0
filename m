Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D5C62E5FB
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 21:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240575AbiKQUeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 15:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240606AbiKQUeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 15:34:04 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2484CDEBE
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 12:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gYFKGLWxfaDIsV9sv+tzomRDBoThosPZ/XulOk/3N3I=; b=loZVncdTnKtkNrxa3K6Saf0dZ7
        6SzT8Er+Rm+4SBmPa1/dmXvo6ozHIr/bUFlxtooJUn3fTNqdIKvhwWsQU0NC5cQ1leCPCMxzanHIf
        TXYoNOPU+wht7RIl9XmPK+iKLZs7v+p1IYGYNYcEX9tRwjapghtVDL44eMNuBtfz2ZnA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovla8-002j9A-Hx; Thu, 17 Nov 2022 21:33:56 +0100
Date:   Thu, 17 Nov 2022 21:33:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/4] tsnep: Throttle interrupts
Message-ID: <Y3aatP+384keCkpN@lunn.ch>
References: <20221117201440.21183-1-gerhard@engleder-embedded.com>
 <20221117201440.21183-2-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117201440.21183-2-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 09:14:37PM +0100, Gerhard Engleder wrote:
> Without interrupt throttling, iperf server mode generates a CPU load of
> 100% (A53 1.2GHz). Also the throughput suffers with less than 900Mbit/s
> on a 1Gbit/s link. The reason is a high interrupt load with interrupts
> every ~20us.

Not my area of expertise, but is NAPI working correctly? It should be
that you disable interrupts while NAPI is polling, and only re-enable
interrupts when polling has stopped. If you are receiving at near line
rate at 100% load, i would of thought that NAPI would be polling most
of the time and interrupts would be mostly disabled?

Interrupt coalescence makes a lot of sense thought, so the patch
itself is useful.

       Andrew
