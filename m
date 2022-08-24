Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3E059FF75
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbiHXQZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239473AbiHXQZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:25:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8D475FC4
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1614B825C4
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 16:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65926C433C1;
        Wed, 24 Aug 2022 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661358322;
        bh=DKdv8QadS5I63mycpq1+ieY2nBzXqTmUtUsOZlHbusQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mDp9wL0zwTx8VkGY/Kpr4bGaZgDywVWknLMlY9ee5l2lwIn81wwWgqKXxXaVu3hiS
         zWxtKkX/beHgiYtHrh7wmDap/FrsVQ2h1/fIwQUv0n8IuuCZTdQadltNMUsnRGI6uV
         jf1W87oA0w/g/69pIEDNcnN3a5+H8RDZFc8jjpvK8siPY8LYfXDSTbNJUfkeRwYdQx
         IEOeX+EZpoxGuxveqlb0d0saab6dbSvebxnT/id+kiXIbwNma5G9TDzQvd9Tr1meRK
         XgQzx7Ym0FEmBiuEoMYiKm2neWQfdYOrmfO8yBvQqvuv99XFyvIghiODRJcbOcFSBv
         ehAigAOIkbwgg==
Date:   Wed, 24 Aug 2022 09:25:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Message-ID: <20220824092521.1a02d280@kernel.org>
In-Reply-To: <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
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

On Wed, 24 Aug 2022 16:35:41 +0300 Gal Pressman wrote:
> On 23/08/2022 18:04, Jacob Keller wrote:
> > 2) always treat ETHTOOL_FEC_AUTO as "automatic + allow disable"
> >
> >   This could work, but it means that behavior will differ depending on the
> >   firmware version. Users have no way to know that and might be surprised to
> >   find the behavior differ across devices which have different firmware
> >   which do or don't support this variation of automatic selection.  
> 
> Hi Jacob,
> This is exactly how it's already implemented in mlx5, and I don't really
> understand how firmware version is related? Is it specific to your
> device firmware?
> Maybe you can workaround that in the driver?
> 
> I feel like we're going the wrong way here having different flags
> interpretations by different drivers.

Hm, according to my notes the drivers supporting a single bit and
multiple bits were evenly split when I wrote the docs. Either way
we're going to make someone unhappy?

While we're talking about mlx5 FEC, what does it report on get?
I wasn't sure if it reports the supported or configured mode.
