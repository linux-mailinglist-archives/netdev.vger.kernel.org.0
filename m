Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BFA4BC5D7
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 06:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbiBSFmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 00:42:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbiBSFmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 00:42:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44DF3FDBE
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 21:42:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB39BB827AA
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 05:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C39CC004E1;
        Sat, 19 Feb 2022 05:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645249346;
        bh=u+Kw79QdnQS7gIOHL1Oei+8antqRq0JZN2EctZA6hbg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D8mAn3yZwLktFUaDGTDl6UZuV3imUSEE1HxUTIOG4oRsIfvHwNDdmII6ypVYsBo4O
         EPPR8hXeNjj9MwT7Jwv07eH5OHr5qvZ2F1/oJvW8FcigsP7FJdPX8NORp91zbsxKHh
         PhZR5ka7Zmx9oqZv0ZTC7J7mhtXAv3/4DN/DcnLumFkKb3xSeCaXnImu4Rh5Icx1G5
         Gb+EWybqQOMCS3chgyLZe2zm/c09mSQfFNQK+M2J3KtY5RPkbPLVn/i+gEllbriRxW
         vODpClpimU7F/o2mWVUMb9ytLhnWuBl2VVE9y3oiYu+IawP0uTvq1xbLvD9/u9n7Mx
         kwuqJUDMd8UOw==
Date:   Fri, 18 Feb 2022 21:42:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] mctp: Fix incorrect netdev unref for extended
 addr
Message-ID: <20220218214224.7b990673@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220218062908.1994506-1-matt@codeconstruct.com.au>
References: <20220218062908.1994506-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 14:29:08 +0800 Matt Johnston wrote:
>  		rt->dev = __mctp_dev_get(dev);
> +		if (rt->dev)
> +			mctp_dev_hold(rt->dev);

Is it safe to have the ref like that? mctp_dev_hold() just does a
refcount_inc(), does something prevent the refcount from dropping
to zero between __mctp_dev_get() and mctp_dev_hold()?
