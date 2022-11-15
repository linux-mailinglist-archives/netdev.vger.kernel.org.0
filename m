Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35F1629E10
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbiKOPvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiKOPvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:51:04 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3042E9C6;
        Tue, 15 Nov 2022 07:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bWe4UU0UXa8p1ABRwhll495O8D3qa/Pr4ibjParckTE=; b=rh+IRlUscld/0QXEfEe/6f2zKh
        002EbrLp0z3QjCY+nZM8h4VNyTCXJQQTDG3J8s9Wr/qAGat7umMF+Jr0unnLZn+Bd4tp9IUOPpRjy
        A2WrbkcQp6DBqccNrMqKOMXukbI1IhDM0Tj4QmNBz3UMpwIpoukl9egQ+rU8SzJJexfM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouyD1-002TTk-Hy; Tue, 15 Nov 2022 16:50:47 +0100
Date:   Tue, 15 Nov 2022 16:50:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        mw@semihalf.com, linux@armlinux.org.uk, leon@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yusongping@huawei.com
Subject: Re: [PATCH net v2] net: mvpp2: fix possible invalid pointer
 dereference
Message-ID: <Y3O1V4FAACa9Ed9S@lunn.ch>
References: <20221115090433.232165-1-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115090433.232165-1-tanghui20@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 05:04:33PM +0800, Hui Tang wrote:
> It will cause invalid pointer dereference to priv->cm3_base behind,
> if PTR_ERR(priv->cm3_base) in mvpp2_get_sram().

As i pointed out for the MDIO driver, i wonder if this is the correct
fix. mvpp2_get_sram() is probably a better place to handle this

In fact, please add a devm_ioremap_resource_optional() which returns
NULL if the resource does not exist, or an error code for real errors,
and make drivers fail the probe on real errors.

	Andrew
