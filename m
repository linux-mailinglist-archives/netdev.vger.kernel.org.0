Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F56E4ADE05
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382762AbiBHQMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343745AbiBHQMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:12:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E4EC061576
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 08:12:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94C92616A3
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 16:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DFCC004E1;
        Tue,  8 Feb 2022 16:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644336744;
        bh=6GXXH4TfsdmfERkKnDoEch0jzcTIOQshlqOEju75yBY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FtXIpitFlgGbuzu8r2Tr4aLpCrB+AgEfgWdQpELpZgvTXKmmvEGIMEfQEI8p9KfK4
         5YHq4nkNzUbvqXocLMTOolSrnYY0XwlQRaiOFlLdR+6yXkwexbMox0ALzNcJJqgf/8
         rBuXaMuCUThGBFwOAaYZDiiYxeoOInVvuOXrOJCnWux9gbtHxHy4OPBtuSjWH91Dof
         4rUDtvBL066Gh8FsTVqWrI8XtMo7qmqVnXzStEll0dKxxFaWcpiK/2xgJqJ7OlOUXS
         4jt32Atd0CHay+o3BQ9xeFWbQqwysZZlOUqXUMX2a/mR6R4BkVSEbg+/nLEfGVVMtM
         J/00STjBEu6RQ==
Date:   Tue, 8 Feb 2022 17:12:19 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v4] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Message-ID: <20220208171219.022165d1@thinkpad>
In-Reply-To: <20220208094455.28870-1-holger.brunck@hitachienergy.com>
References: <20220208094455.28870-1-holger.brunck@hitachienergy.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Feb 2022 10:44:55 +0100
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> +static struct mv88e6352_serdes_p2p_to_val mv88e6352_serdes_p2p_to_val[] = {
> +	/* Mapping of configurable mikrovolt values to the register value */
> +	{ 14000, 0},
> +	{ 112000, 1},
> +	{ 210000, 2},
> +	{ 308000, 3},
> +	{ 406000, 4},
> +	{ 504000, 5},
> +	{ 602000, 6},
> +	{ 700000, 7},
> +};

...

> +	reg = (reg & MV88E6352_SERDES_OUT_AMP_MASK) | val;

This is weird: normally in mask we have those bits set that are to be changed.
So amplitude mask should be bits that specify the amplitue, and this
should be
  reg &= ~MV88E6352_SERDES_OUT_AMP_MASK;
  reg |= val & MV88E6352_SERDES_OUT_AMP_MASK;
and mask should be defined inversely.

...

> +#define MV88E6352_SERDES_OUT_AMP_MASK		0xfffc

And this is also weird. 0xfffc is all bits set except last 2, but in
the mapping above the maximum value is 7, so you use 3 bits for
amplitude...

Marek
