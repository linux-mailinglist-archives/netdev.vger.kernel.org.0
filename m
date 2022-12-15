Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A3864D5D5
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 05:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiLOEWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 23:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLOEWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 23:22:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52392B1BD
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 20:22:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D2DD61C04
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 04:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E704C433D2;
        Thu, 15 Dec 2022 04:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671078134;
        bh=Lb67C53t+IuUoUywOtd6VhK/1NN833+k0+6ZiU5KacE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bFl9hALWb3wf9MdSn/M3yKtYlvEl/W4RgTXiDhIIqUIGWJOwhTBUySZjQL6KE+xYt
         pZXKhTYSCVq7d97smrE670MrogJGKEChRNoAS8Q/InYSBV6T4RAaHlZCXslu86iq6b
         Qq9/WM2Ysy9NICydRonvfJy/NPxI3MRPN3Bf74JJ6mMAiVJHTEHIC1cyifh3SmNrpd
         hDv6p8wiueeA+eP6UnIJ035SJNwgGVna28g7tmWrauYNvRHFeyvdiri8ZR3ZhCo2lD
         NB4A5TLwwbWm2aIQLjmE80GTXFIBk7o05Al5J9Q7ffVvnK61Yxhq2SsSzeCm0u2RmM
         ZquKi3/SMsQIQ==
Date:   Wed, 14 Dec 2022 20:22:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool-next v2 v2] JSON output support for Netlink
 implementation of --show-coalesce option
Message-ID: <20221214202213.36ab31c0@kernel.org>
In-Reply-To: <20221215035651.65759-1-glipus@gmail.com>
References: <20221215035651.65759-1-glipus@gmail.com>
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

On Wed, 14 Dec 2022 20:56:51 -0700 Maxim Georgiev wrote:
> Add --json support for Netlink implementation of --show-coalesce option
> No changes for non-JSON output for this featire.

s/featire/feature/

I'd add another sentence here, something like:

 Note that all callers of show_u32() have to be updated but only
 coalesce is converted fully.

To make it clear that the interspersed printf()s don't matter.

One small nit pick below:

> @@ -92,7 +113,12 @@ int nl_gcoalesce(struct cmd_context *ctx)
>  				      ETHTOOL_A_COALESCE_HEADER, 0);
>  	if (ret < 0)
>  		return ret;
> -	return nlsock_send_get_request(nlsk, coalesce_reply_cb);
> +
> +	new_json_obj(ctx->json);
> +	ret = nlsock_send_get_request(nlsk, coalesce_reply_cb);
> +	delete_json_obj();
> +	return ret;
> +
>  }

Empty line befre closing bracket unnecessary.
