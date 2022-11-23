Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED301634EAE
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbiKWENP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiKWENA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:13:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B09641E;
        Tue, 22 Nov 2022 20:12:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48A3861A25;
        Wed, 23 Nov 2022 04:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57845C4347C;
        Wed, 23 Nov 2022 04:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669176767;
        bh=+72b3XhG2hPjlw3D+lPFi2jw3BBqLoiKOxT5UPam+fY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U7RoLHwb0Kgj69uEoGmbFN5sk15Fh8gO8XnOvlhonv9vf0YHKwcobObTleIRQaKL3
         5+AblBNFX4f1LKPkRGYQd6S/K/ePrAGFdAcY0so1yFnL83T13+B5nuHSjlBJsGDXAC
         CQ7oov/7E5rWNFzUG85So/1TJQU50FWq109b5O3oetMU4cTDlYFXj0vt0KdaVkd7v2
         2PFkMFQlJgFSKyfzfgB4aiox/k7rLkAQ8U7SJXauqTLy/6yC7MkV4MPN0bLHmBlDN3
         /vROvvyQkcpjVxsZByWtXyujizr74ms/pR6lmDxO6ch7rek5951eYOOM3mLK1guBJA
         BPhH5jSAZz6rQ==
Date:   Tue, 22 Nov 2022 20:12:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate
 default information
Message-ID: <20221122201246.0276680f@kernel.org>
In-Reply-To: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
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

On Wed, 23 Nov 2022 00:49:34 +0900 Vincent Mailhol wrote:
>  static int
>  devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
>  		     enum devlink_command cmd, u32 portid,
>  		     u32 seq, int flags, struct netlink_ext_ack *extack)
>  {
>  	struct devlink_info_req req = {};
> +	struct device *dev = devlink_to_dev(devlink);

nit: longest to shortest lines

>  	void *hdr;
>  	int err;
>  
> @@ -6707,6 +6733,16 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
>  	if (err)
>  		goto err_cancel_msg;
>  
> +	err = devlink_nl_driver_info_get(dev->driver, &req);
> +	if (err)
> +		goto err_cancel_msg;

won't this result in repeated attributes, potentially?
Unlike ethtool which copies data into a struct devlink
adds an attribute each time you request. It does not override.
So we need to extend req with some tracking of whether driver
already put in the info in question

> +	if (!strcmp(dev->parent->type->name, "usb_device")) {
> +		err = devlink_nl_usb_info_get(to_usb_device(dev->parent), &req);
> +		if (err)
> +			goto err_cancel_msg;
> +	}
