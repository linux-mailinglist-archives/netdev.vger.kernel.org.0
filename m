Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662A43F6C18
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 01:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhHXXNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 19:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231248AbhHXXNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 19:13:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72A4661373;
        Tue, 24 Aug 2021 23:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629846752;
        bh=n/zfAIcx3DiiNK821fTyENrmYDzJqlsQ0empUPjl08k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ofTRzDMMrR08TGjI0+y+wGElHR4uVgE/sgpRCpR9GQhNZggegAEPZ9E74DY/gWyIt
         W1F3lvdp/zB1vzOYjzVkAPVsc7Uo2W74/omXL6qq8zrGZx1WnjR7ib/JmsTC0IpcWo
         v0zhjWFIhoxZW4jWY8zJN3XmRa/FATAl0Cv2D8G7jqw/7n1GbSZivA/9FR5z3Z5hHt
         B4fFkVwdQPI8aHFCA9FlLg/565TdjbJbdn6zhQwz6HC5l91x/8xbRw+lL/oCYGphVC
         h3GvuvyDqXbVdbln2VAvbb+NJu3Ki0cHdUgmb9MoPXAo3QhigaW8xBTwXB2pd7Mnpc
         g7Ja+lMAfLBJQ==
Date:   Tue, 24 Aug 2021 16:12:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v3 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <20210824161231.5e281f1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210824130344.1828076-2-idosch@idosch.org>
References: <20210824130344.1828076-1-idosch@idosch.org>
        <20210824130344.1828076-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021 16:03:39 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Add a pair of new ethtool messages, 'ETHTOOL_MSG_MODULE_SET' and
> 'ETHTOOL_MSG_MODULE_GET', that can be used to control transceiver
> modules parameters and retrieve their status.

Lgtm! A few "take it or leave it" nit picks below.

> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

> +The optional ``ETHTOOL_A_MODULE_POWER_MODE_POLICY`` attribute encodes the
> +transceiver module power mode policy enforced by the host. The default policy
> +is driver-dependent and can be queried using this attribute.

Should we make a recommendation for those who don't have to worry about
legacy behavior? Like:

  The default policy is driver-dependent (but "auto" is the recommended
  and generally assumed to be used for drivers no implementing this API).

IMHO the "and can be queried using this attribute" part can be skipped.

> +/**
> + * struct ethtool_module_power_mode_params - module power mode parameters
> + * @policy: The power mode policy enforced by the host for the plug-in module.
> + * @mode: The operational power mode of the plug-in module. Should be filled by
> + * device drivers on get operations.

Indent continuation lines by one tab.

> + * @mode_valid: Indicates the validity of the @mode field. Should be set by
> + * device drivers on get operations when a module is plugged-in.

Should we make a firm decision on whether we want to use these kind of
valid bits or choose invalid defaults? As you may guess my preference
is the latter since that's what I usually do, that way drivers don't
have to write two fields.

Actually I think this may be the first "valid" in ethtool, I thought we
already had one but I don't see it now..

> +struct ethtool_module_power_mode_params {
> +	enum ethtool_module_power_mode_policy policy;
> +	enum ethtool_module_power_mode mode;
> +	u8 mode_valid:1;
> +};
