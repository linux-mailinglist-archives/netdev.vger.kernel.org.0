Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1AC46296C
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 02:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhK3BH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 20:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhK3BH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 20:07:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBE6C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:04:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1A43B80CB6
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 01:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A6AC53FC7;
        Tue, 30 Nov 2021 01:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638234277;
        bh=3DlJmzU1ErxGnMT9QEdg5DCrMSop6l30qDKCkeQwffo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cpfMg1550LS+F9Hi5iwzI131zC5qGTJ5SmBUjhCxFBDSHOirjPBFkj7wC2B+npSHX
         EogFFpFfoBKlGiXv02gluDLPqL7IVgf043HbF6/PiasZiB7x4GeugYC8lNjbSFwSKU
         VxZYOWxGnNtCpZ1ARYT3QVSFRtEQAp3GX0wUqkhdywlnHLDiuV0d24Ebx47NAzkD5X
         wGXKpmgIQxOCFxd2xGiyCtCaUcco7026XVbllY0pyiU4RQqBWZCjIRCvrF33njNgZR
         EQTRRFAg6F9Jfe+7k0ZsOUHlFNvvhPGp40fzAb4UhqinNd4aOGkCCMxTg2YWUIAGDH
         RzwpcNrLIKi5A==
Date:   Mon, 29 Nov 2021 17:04:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        jacob.e.keller@intel.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 3/4] ethtool: Add ability to flash
 transceiver modules' firmware
Message-ID: <20211129170435.31148177@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YaVqtD0pOKdrC9X0@lunn.ch>
References: <20211127174530.3600237-1-idosch@idosch.org>
        <20211127174530.3600237-4-idosch@idosch.org>
        <YaVqtD0pOKdrC9X0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 01:05:08 +0100 Andrew Lunn wrote:
> What i'm missing is some sort of state machine to keep track of the
> SFP. Since RTNL is not held other operations could be performed in
> parallel. Does CMIS allow this? Can you intermix firmware writes with
> reading the temperature sensor for hwmon? Poll the LOS indicator to
> see if the link has been lost?

Ah, rtnl_lock is not held throughout? I just looked at this code:

+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ret = module_flash_fw(dev, tb, info->extack);
+
+	ethnl_ops_complete(dev);
+
+out_rtnl:
+	rtnl_unlock();

and assumed module_flash_fw() flashes the module's FW, not starts 
an async process...

And it appears the user is racy:

+	dev_put(ns->netdev);
+	rtnl_lock();
+	ns->ethtool.module_fw.in_progress = false;
+	rtnl_unlock();
+	release_firmware(ns->ethtool.module_fw.fw);

The dev_put() should be last, otherwise references to ns could be UAF?

> With cable testing, phylib already has a state machine, and i added a
> new state for cable test running. If any other operation happened
> which would cause a change out of this state, like ifdown, or a
> request to restart autoneg, the cable test is aborted first.
