Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C799B6B3E97
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 13:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCJMCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 07:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjCJMCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 07:02:42 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C61EF6B6F;
        Fri, 10 Mar 2023 04:02:39 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id k10so19353707edk.13;
        Fri, 10 Mar 2023 04:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678449757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QOa3OHMvLNrNfz5ZWfMnTS8rtqZhy0qS3igt7Lniq2Y=;
        b=hk4CwKnPH99sfna6fp1wUEulY1pKhBrlM/dSWySTyugPPE2vW5uPC4eJcAt7sQfLnD
         vCOVV2VjpbHbjfXWT+j3OhVXzGahZirCgvJt5qjqoNBJSbgWNIy6Hun62VAZd4qwpdE9
         0MSO3H+81TQlwmVP+q3cH11v6OE0gwML52+A4ugeC5Z4ILTjggtai2BUGjASPVl2y9Hm
         cmLHh5Ak2D/jT+QMwORYLtA3eWWG4tYNM0kgjPVTXh525OJ0tmwJi+ZUWVjc/Hh4hmz2
         QAE+i/7WpHYiJBXseLslCclGIVnJoxcGVi3oNKCPgEnylw53VnLUSlwL7DG6lhppeHZg
         bbew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678449757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QOa3OHMvLNrNfz5ZWfMnTS8rtqZhy0qS3igt7Lniq2Y=;
        b=oxPnqkhPMS58anzpYvvzgNPg43RXiDZUejd7CtdR566rbYUU8SG4qKlDaWFHj5IRQf
         EEW65aVDGdHb1hF0+XeoMmZ2KAXSzJGkZC+L+s9tkqma+wZ9d9XEgiusR2Uivmee44no
         1tYOSNxW+ACnjH10BgnJQNX1b9KPXQk3d/rZYIVHt9w7OdsTtVu3L0BIBfgFLClgCKdW
         FHOFxHFxzrwyMAYLh2HuIQ7bQ+GZnWBM1OpzHzgAtSZYOAOBAWNjZbqfsLo5cA7VczMG
         nYEyDm3EYOjZXOt9KDLbavQivnUnXve0XuUCypKmIsLPuROXE+hfkbnadsAFDXAfMDBl
         pkgQ==
X-Gm-Message-State: AO0yUKXTtHVgyfXWAZCRM93dyzCe++4MTKh602dYGhkUfpu8C+mnKOxs
        PCSHG7Hez6eVE7dJisldgP0=
X-Google-Smtp-Source: AK7set+jyfXVJwl3h3cWH/7wjbwURG3FqCugDcrUWFsIPv/cbzwzAZ97JGlo1GGSYxPvkM67jw3vwA==
X-Received: by 2002:a05:6402:188:b0:4a3:43c1:8430 with SMTP id r8-20020a056402018800b004a343c18430mr1386558edv.4.1678449757500;
        Fri, 10 Mar 2023 04:02:37 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id h13-20020a170906854d00b008e125ee7be4sm877794ejy.176.2023.03.10.04.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 04:02:37 -0800 (PST)
Date:   Fri, 10 Mar 2023 14:02:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] dsa: marvell: Provide per device information about
 max frame size
Message-ID: <20230310120235.2cjxauvqxyei45li@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-2-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309125421.3900962-2-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 01:54:15PM +0100, Lukasz Majewski wrote:
> Different Marvell DSA switches support different size of max frame
> bytes to be sent. This value corresponds to the memory allocated
> in switch to store single frame.
> 
> For example mv88e6185 supports max 1632 bytes, which is now in-driver
> standard value.

What is the criterion based on which 1632 is the "in-driver standard value"?

> On the other hand - mv88e6250 supports 2048 bytes.

What you mean to suggest here is that, using the current classification
from mv88e6xxx_get_max_mtu(), mv88e6250 falls into the "none of the above"
bucket, for which the driver returns 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN // 1492.
But it truly supports a maximum frame length of 2048, per your research.

The problem is that I needed to spend 30 minutes to understand this, and
the true motivation for this patch.

> To be more interesting - devices supporting jumbo frames - use yet
> another value (10240 bytes)

What's interesting about this?

> 
> As this value is internal and may be different for each switch IC,
> new entry in struct mv88e6xxx_info has been added to store it.

You need to provide a justification for why the existing code structure
is not good enough.

> 
> This commit doesn't change the code functionality - it just provides
> the max frame size value explicitly - up till now it has been
> assigned depending on the callback provided by the switch driver
> (e.g. .set_max_frame_size, .port_set_jumbo_size).
> 
> Signed-off-by: Lukasz Majewski <lukma@denx.de>
> 
> ---
> Changes for v2:
> - Define max_frame_size with default value of 1632 bytes,
> - Set proper value for the mv88e6250 switch SoC (linkstreet) family
> 
> Changes for v3:
> - Add default value for 1632B of the max frame size (to avoid problems
>   with not defined values)
> 
> Changes for v4:
> - Rework the mv88e6xxx_get_max_mtu() by using per device defined
>   max_frame_size value
> 
> - Add WARN_ON_ONCE() when max_frame_size is not defined
> 
> - Add description for the new 'max_frame_size' member of mv88e6xxx_info
> 
> Changes for v5:
> - Move some code fragments (like get_mtu callback changes) to separate
>   patches

you have change log up to v5, but your subject prefix is [PATCH 1/7]
which implies v1?

> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 31 +++++++++++++++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/chip.h |  6 ++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 0a5d6c7bb128..c097a0b19ba6 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c

It would be good if the commit message contained the procedure based on
which you had made these changes - and preferably they were mechanical.
Having a small C program written would be absolutely ideal.
This is so that reviewers wouldn't have to do it in parallel...

My analysis has determined the following 3 categories:

static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
{
	struct mv88e6xxx_chip *chip = ds->priv;

	if (chip->info->ops->port_set_jumbo_size)
		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN; // 10210
	else if (chip->info->ops->set_max_frame_size)
		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN; // 1602
	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN; // 1492
}

By ops:

port_set_jumbo_size:
static const struct mv88e6xxx_ops mv88e6131_ops = {
static const struct mv88e6xxx_ops mv88e6141_ops = {
static const struct mv88e6xxx_ops mv88e6171_ops = {
static const struct mv88e6xxx_ops mv88e6172_ops = {
static const struct mv88e6xxx_ops mv88e6175_ops = {
static const struct mv88e6xxx_ops mv88e6176_ops = {
static const struct mv88e6xxx_ops mv88e6190_ops = {
static const struct mv88e6xxx_ops mv88e6190x_ops = {
static const struct mv88e6xxx_ops mv88e6240_ops = {
static const struct mv88e6xxx_ops mv88e6320_ops = {
static const struct mv88e6xxx_ops mv88e6321_ops = {
static const struct mv88e6xxx_ops mv88e6341_ops = {
static const struct mv88e6xxx_ops mv88e6350_ops = {
static const struct mv88e6xxx_ops mv88e6351_ops = {
static const struct mv88e6xxx_ops mv88e6352_ops = {
static const struct mv88e6xxx_ops mv88e6390_ops = {
static const struct mv88e6xxx_ops mv88e6390x_ops = {
static const struct mv88e6xxx_ops mv88e6393x_ops = {

set_max_frame_size:
static const struct mv88e6xxx_ops mv88e6085_ops = {
static const struct mv88e6xxx_ops mv88e6095_ops = {
static const struct mv88e6xxx_ops mv88e6097_ops = {
static const struct mv88e6xxx_ops mv88e6123_ops = {
static const struct mv88e6xxx_ops mv88e6161_ops = {
static const struct mv88e6xxx_ops mv88e6185_ops = {

none of the above:
static const struct mv88e6xxx_ops mv88e6165_ops = {
static const struct mv88e6xxx_ops mv88e6191_ops = {
static const struct mv88e6xxx_ops mv88e6250_ops = {
static const struct mv88e6xxx_ops mv88e6290_ops = {


By info:

port_set_jumbo_size (10240):
	[MV88E6131] = {
	[MV88E6141] = {
	[MV88E6171] = {
	[MV88E6172] = {
	[MV88E6175] = {
	[MV88E6176] = {
	[MV88E6190] = {
	[MV88E6190X] = {
	[MV88E6240] = {
	[MV88E6320] = {
	[MV88E6321] = {
	[MV88E6341] = {
	[MV88E6350] = {
	[MV88E6351] = {
	[MV88E6352] = {
	[MV88E6390] = {
	[MV88E6390X] = {
	[MV88E6191X] = {
	[MV88E6193X] = {
	[MV88E6393X] = {

set_max_frame_size (1632):
	[MV88E6085] = {
	[MV88E6095] = {
	[MV88E6097] = {
	[MV88E6123] = {
	[MV88E6161] = {
	[MV88E6185] = {

none of the above (1522):
	[MV88E6165] = {
	[MV88E6191] = {
	[MV88E6220] = {
	[MV88E6250] = {
	[MV88E6290] = {


Whereas your analysis seems to have determined this:

port_set_jumbo_size (10240):
	[MV88E6131] = {
	[MV88E6141] = {
	[MV88E6171] = {
	[MV88E6172] = {
	[MV88E6175] = {
	[MV88E6176] = {
	[MV88E6190] = {
	[MV88E6240] = {
	[MV88E6320] = {
	[MV88E6321] = {
	[MV88E6341] = {
	[MV88E6350] = {
	[MV88E6351] = {
	[MV88E6352] = {
	[MV88E6390] = {
	[MV88E6390X] = {
	[MV88E6393X] = {

set_max_frame_size (1632):
	[MV88E6095] = {
	[MV88E6097] = {
	[MV88E6123] = {
	[MV88E6161] = {
	[MV88E6165] = {
	[MV88E6185] = {

none of the above (1522):
	[MV88E6085] = {
	[MV88E6190X] = {
	[MV88E6191] = {
	[MV88E6191X] = {
	[MV88E6193X] = {
	[MV88E6290] = {

what's up with these?! (no max_frame_size)
	[MV88E6220] = {
	[MV88E6250] = {


So our analysis differs for:

MV88E6190X (I say 10240, you say 1522)
MV88E6191X (I say 10240, you say 1522)
MV88E6193X (I say 10240, you say 1522)
MV88E6085 (I say 1632, you say 1522)
MV88E6165 (I say 1522, you say 1632)
MV88E6220 (I say 1522, not clear what you say)
MV88E6250 (I say 1522, not clear what you say)

Double-checking with the code, I believe my analysis to be the correct one...


I have also noticed that you have not acted upon my previous review comment:
https://patchwork.kernel.org/project/netdevbpf/patch/20230106101651.1137755-1-lukma@denx.de/

| 1522 - 30 = 1492.
| 
| I don't believe that there are switches which don't support the standard
| MTU of 1500 ?!
| 
| >  		.port_base_addr = 0x10,
| >  		.phy_base_addr = 0x0,
| >  		.global1_addr = 0x1b,
| 
| Note that I see this behavior isn't new. But I've simulated it, and it
| will produce the following messages on probe:
| 
| [    7.425752] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
| [    7.437516] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 0
| [    7.588585] mscc_felix 0000:00:00.5 swp1 (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
| [    7.600433] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 1
| [    7.752613] mscc_felix 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:00.3:12] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
| [    7.764457] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 2
| [    7.900771] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY [0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
| [    7.912501] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 3
| 
| I wonder, shouldn't we first fix that, and apply this patch set afterwards?

I guess I will have to fix this now, since you haven't done it.

> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index da6e1339f809..e2b88f1f8376 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -132,6 +132,12 @@ struct mv88e6xxx_info {
>  	unsigned int num_gpio;
>  	unsigned int max_vid;
>  	unsigned int max_sid;
> +
> +	/* Max Frame Size.
> +	 * This value corresponds to the memory allocated in switch internal
> +	 * memory to store single frame.
> +	 */

What is the source of this definition?

I'm asking because I know of other switches where the internal memory
allocation scheme has nothing to do with the frame size. Instead, there
are SRAM cells of fixed and small size (say 60 octets) chained together.

> +	unsigned int max_frame_size;
>  	unsigned int port_base_addr;
>  	unsigned int phy_base_addr;
>  	unsigned int global1_addr;
> -- 
> 2.20.1
> 
