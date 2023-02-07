Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A162568CCAD
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 03:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjBGCmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 21:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBGCmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 21:42:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BAE305D7
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 18:42:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83140B81600
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9478AC433D2;
        Tue,  7 Feb 2023 02:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675737749;
        bh=Xb9WAjseTeUa2MI2Rep1PMvcyV/p+Y7ufmDcqGYGikI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JMmPlyb4LM3dv8WNLOituqWpxvJ1m9n9Ybt+isIZIkmPMTDjpjKNVXoRlgAE97T12
         /qEWiCE2KoQ+h7/1I/iMHxtuks9st/nHWuWKwamILXcT7m4lilzX5rQf/6pI13HlmD
         Z2rWRX4BStWhuN8ftLRdDkvgkQ5U3askOARqwZaDyCzePBVj1ymgY56mXQKH9cgBHE
         fDx5WuHmw0Fis1Mf8mDBao3mjr7rC6W8ZRw3NLgMZYcow6/ZXNGK3NHbStKU1DYxum
         7uqVGzaepceacgePYmRMxtrI22zhQlu1/RvesIhHySyslBOKCTNuMGJjjFrpuzHXbY
         SYurvHXRMP8Lg==
Date:   Mon, 6 Feb 2023 18:42:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <20230206184227.64d46170@kernel.org>
In-Reply-To: <20230206153603.2801791-2-simon.horman@corigine.com>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
        <20230206153603.2801791-2-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Feb 2023 16:36:02 +0100 Simon Horman wrote:
> +VF assignment setup
> +---------------------------
> +In some cases, NICs could have multiple physical ports per PF. Users can assign VFs to
> +different ports.

Please make sure you run make htmldocs when changing docs,
this will warn.

> +- Get count of VFs assigned to physical port::
> +
> +    $ devlink port show pci/0000:82:00.0/0
> +    pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical port 0 splittable true lanes 4

Physical port has VFs? My knee jerk reaction is that allocating
resources via devlink is fine but this seems to lean a bit into
forwarding. How do other vendors do it? What's the mapping of VFs
to ports?

What do you suggest should happen when user enables switchdev mode?
