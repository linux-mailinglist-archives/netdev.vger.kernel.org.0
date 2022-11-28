Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C2363B4CD
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 23:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbiK1W11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 17:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiK1W10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 17:27:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D2E15A0C;
        Mon, 28 Nov 2022 14:27:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE38614B7;
        Mon, 28 Nov 2022 22:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F48AC433D6;
        Mon, 28 Nov 2022 22:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669674444;
        bh=o0QWT6JRyZz+eRLb3by8TcPDUkxT+t34KBC3YTAhv7s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CxitdZe/7wyGvPDGF88gk2ZSafJBtM/u6GU7D3zXGHglZjJIA3Cyr+dic3mes7HhE
         yUq0Do01KEjd0Z0yYnT+nnjzUJhpX3/xvUAvuyhUoBGjy5fsyRu2QiiARXUD77gQog
         nkK46rpy5U/ATqFvOXuiI2lAV+JL5G90kxLFuCC7putollLw9OhUUyo3Ex2hSORroL
         ZEBS6B78ued1TZE51/ldk14Nyf0dpQt8hvA4MPThsbnbxKLQSmXF8phLmMZeXclYAv
         SgoKSegm/3soTV56khvUmZGsUHDJSjJ41InvC4PVVzPtgCHzRUy/YwVVKc3N5O0Xnr
         mScgrBWmKBCnw==
Date:   Mon, 28 Nov 2022 14:27:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH v4 3/6] can: etas_es58x: export product information
 through devlink_ops::info_get()
Message-ID: <20221128142723.2f826d20@kernel.org>
In-Reply-To: <CAMZ6RqKYyLCCxQKSnOxku2u9604Uxmxw3xG9d031-2=9iC_8tw@mail.gmail.com>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
        <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
        <20221126162211.93322-4-mailhol.vincent@wanadoo.fr>
        <Y4S73jX07uFAwVQv@lunn.ch>
        <CAMZ6RqKYyLCCxQKSnOxku2u9604Uxmxw3xG9d031-2=9iC_8tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Nov 2022 23:43:19 +0900 Vincent MAILHOL wrote:
> On Mon. 28 Nov. 2022 at 22:49, Andrew Lunn <andrew@lunn.ch> wrote:
> > > devlink does not yet have a name suited for the bootloader and so this
> > > last piece of information is exposed to the userland for through a
> > > custom name: "bl".  
> >
> > Jiri, what do you think about 'bl'? Is it too short, not well known
> > enough? It could easily be 'bootloader'.  
> 
> For the record, I name it "bl" by analogy with the firmware which is
> named "fw". My personal preference would have been to name the fields
> without any abbreviations: "firmware", "bootloader" and
> "hardware.revision" (for reference ethtool -i uses
> "firmware-version"). But I tried to put my personal taste aside and
> try to fit with the devlink trends to abbreviate things. Thus the name
> "bl".

Agreed, I thought "fw" is sufficiently universally understood to be used
but "bl" is most definitely not :S  I'd suggest "fw.bootloader". Also
don't hesitate to add that to the "well known" list in devlink.h, 
I reckon it will be used by others sooner or later.
