Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971C867DE9D
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 08:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjA0HhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 02:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbjA0HhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 02:37:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59764627BD
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 23:37:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12B49B81F9D
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 07:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BD9C433EF;
        Fri, 27 Jan 2023 07:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674805035;
        bh=Q/rweXDFDjnFaUV/v7tLdn7UZ+JPL5ACYCxMBs+xcuc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZpWDAzNNvqVJG7JFkrf74AkNG4jQG5TjTDOS2fAAxFzM/0ZimNJZvn5Fj+54KBh/U
         2z+c7mnEaz6GHeVVhCyr3cu8Xr7yZCaELapoSMPreZd3ZWgcqMrPceiVppnZLsbqqW
         NioKnfgIkix2yhPGnGAXHucVauijAPJz57ENg7jq2gGEAYdRKh+N9XGJPk31TdqiS5
         ktxVgGnCJy8erfILvd0kjrmuWTNJtFFgSGVfjaXLKU24lMLH2PWruKJGAN1F51VBIg
         qZ27N+9I1ApHzRgaDUsIFTc5DBroiRYSL2tBty3dCW+LpJn9mOJf/OoQ/RIjh/RNVA
         XDl9nXkupW6AA==
Date:   Thu, 26 Jan 2023 23:37:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Brian Haley <haleyb.dev@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] neighbor: fix proxy_delay usage when it is
 zero
Message-ID: <20230126233713.28c64c4e@kernel.org>
In-Reply-To: <20230125195114.596295-1-haleyb.dev@gmail.com>
References: <20230125195114.596295-1-haleyb.dev@gmail.com>
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

On Wed, 25 Jan 2023 14:51:14 -0500 Brian Haley wrote:
> +	or proxy_ndp is enabled. A random value between [0, proxy_delay]

Do you mean: [0, proxy_delay) or there's something that can give us an
extra jiffy (IOW shouldn't the upper limit be open) ?

it's 
  random() % MAX - (1 - noise)

where (1 - noise) is the fraction of jiffy which already passed since
the tick.

Sorry if I'm slow to get it..
