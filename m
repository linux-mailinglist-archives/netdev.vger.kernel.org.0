Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7288945F5AB
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhKZUOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238219AbhKZUMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 15:12:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB6EC06175C
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 11:56:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6230E62281
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 19:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04851C9305B;
        Fri, 26 Nov 2021 19:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637956593;
        bh=Ko4FaG1AerM8MMpCrg+BfFTwSTAU2bBn6l0PLfqmt3w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tBOsQKhRkoFDCt9i1jWvSnjTStwF+M+3RuDsAEuk0YB0t6YHnKlhFE9uJEIPdElxn
         zkk2YXMZsDctzw+At1BbGkUHsccFOOrQQ0jPOwwoslMN/CR4rwlcJinphkv+7XTGyF
         gib7/lTHkmaqh3DPy1Kj3nwVtN2XKDArho0PrxBlKTUMwvtm46zXlfNYRhgaTvqfL6
         Clv1OoPQat1mRMZYpR24Fybg+k2oOZgQ0fCHcBVlPdEskw/e/0p3EwZ5QBcUVIXcap
         0EtHneAHLhk/sFbwczrwRB0OXD+eYHWWmEAijg8f8wgA5DPz7RbrFNj9WH9SfeTRlL
         S3LzQlo0HzKLA==
Date:   Fri, 26 Nov 2021 20:56:25 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211126205625.5c0e38c5@thinkpad>
In-Reply-To: <20211126154249.2958-2-holger.brunck@hitachienergy.com>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
        <20211126154249.2958-2-holger.brunck@hitachienergy.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 16:42:49 +0100
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> The mv88e6352, mv88e6240 and mv88e6176  have a serdes interface. This patch
> allows to configure the output swing to a desired value in the
> devicetree node of the switch.
> 
> CC: Andrew Lunn <andrew@lunn.ch>
> CC: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c   | 14 ++++++++++++++
>  drivers/net/dsa/mv88e6xxx/chip.h   |  3 +++
>  drivers/net/dsa/mv88e6xxx/serdes.c | 14 ++++++++++++++
>  drivers/net/dsa/mv88e6xxx/serdes.h |  4 ++++
>  4 files changed, 35 insertions(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index f00cbf5753b9..5182128959a0 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -3173,9 +3173,11 @@ static void mv88e6xxx_teardown(struct dsa_switch *ds)
>  static int mv88e6xxx_setup(struct dsa_switch *ds)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
> +	struct device_node *np = chip->dev->of_node;
>  	u8 cmode;
>  	int err;
>  	int i;
> +	int out_amp;

Reverse christmas tree please, where possible.

  	struct mv88e6xxx_chip *chip = ds->priv;
+	struct device_node *np = chip->dev->of_node;
+	int out_amp;
  	u8 cmode;
  	int err;
  	int

>  
>  	chip->ds = ds;
>  	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
> @@ -3292,6 +3294,15 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
>  	if (err)
>  		goto unlock;
>  
> +	if (chip->info->ops->serdes_set_out_amplitude && np) {
> +		if (!of_property_read_u32(np, "serdes-output-amplitude",

Hmm. Andrew, why don't we use <linux/property.h> instead of
<linux/of*.h> stuff in this dirver? Is there a reason or is this just
because it wasn't converted yet?

A simple device_property_read_u32() would be better here and we
wouldn't need the np pointer.

...
  
> +int mv88e6352_serdes_set_out_amplitude(struct mv88e6xxx_chip *chip, int val)
> +{
> +	u16 reg;
> +	int err;
> +
> +	err = mv88e6352_serdes_read(chip, MV88E6352_SERDES_SPEC_CTRL2, &reg);
> +	if (err)
> +		return err;
> +
> +	reg = (reg & MV88E6352_SERDES_OUT_AMP_MASK) | val;
> +
> +	return mv88e6352_serdes_write(chip, MV88E6352_SERDES_SPEC_CTRL2, reg);
> +}

Is there a reason why we call this from driver probe instead of 6352's
serdes_power() ?

Marek
