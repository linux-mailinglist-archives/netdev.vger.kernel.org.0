Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C175EB6FC
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 03:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiI0Biq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 21:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiI0Bip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 21:38:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E50647C6
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 18:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F8FFB81719
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 01:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CCFC433D6;
        Tue, 27 Sep 2022 01:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664242721;
        bh=ZKvRwEfXPUycdtZzZdLOByPIRNHQG0sai7JBSKAcki8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qnKJOlBPRxZtFBYbT4n5p/b7uEkyVAG61YFXrz0hx+egh4uaDtOwAmQjz4L6GD0lG
         7K1tCdxeU/k1ZSsQ+KJmYCoRePCF7u5fe7WS7zHJgRIBeO3eGlu+70tqOZFwexc2g2
         sUbGvMRmvhjExfYyAaj3KrF9qK7Ad6snktpMyQlCg6gDAUvPv6mMwyLvzYbY59xUMY
         wfNxbyaL2o7yjcdcXkS8r2bl6QQPFpe61PR97YAqX77Pmyd6AWVaXUofuU7eTDYIf5
         RVWRbOwd5AFJb4VHqcFMAfK37qBorEQcs/4SNn8sg6cRMx7elHg5uM+sv+ijef1NJ5
         lMGD7FCeHaZ9w==
Date:   Mon, 26 Sep 2022 18:38:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next 2/3] nfp: add support for link auto negotiation
Message-ID: <20220926183840.12b96ca7@kernel.org>
In-Reply-To: <20220927011353.GA20766@nj-rack01-04.nji.corigine.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
        <20220921121235.169761-3-simon.horman@corigine.com>
        <20220922180040.50dd1af0@kernel.org>
        <DM6PR13MB3705B174455A7E5225CAF996FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20220923062114.7db02bce@kernel.org>
        <20220923154157.GA13912@nj-rack01-04.nji.corigine.com>
        <20220923172410.5af0cc9f@kernel.org>
        <20220924024530.GA8804@nj-rack01-04.nji.corigine.com>
        <20220926092547.4f2a484e@kernel.org>
        <20220927011353.GA20766@nj-rack01-04.nji.corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 09:13:53 +0800 Yinjun Zhang wrote:
> On Mon, Sep 26, 2022 at 09:25:47AM -0700, Jakub Kicinski wrote:
> > On Sat, 24 Sep 2022 10:45:30 +0800 Yinjun Zhang wrote:  
> > > Not only check if it's flower, but also check if it's sp_indiff when
> > > it's not flower by parsing the tlv caps.  
> > 
> > Seems bogus. The speed independence is a property of the whole FW image,
> > you record it in the pf structure.  
> 
> It's indeed a per-fw property, but we don't have existing way to expose
> per-fw capabilities to driver currently, so use per-vnic tlv caps here.
> Maybe define a new fw symbol is a choice, but my concern is it's not
> visible to netvf driver.
> Any suggestion is welcomed.

Why not put an rtsym with the value in the FW? That'd be my first
go-to way of communicating information about the FW as a whole.
