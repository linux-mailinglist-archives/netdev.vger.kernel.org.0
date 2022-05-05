Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0525651C48B
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381625AbiEEQIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiEEQIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:08:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EED515A3;
        Thu,  5 May 2022 09:04:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB227B82DBE;
        Thu,  5 May 2022 16:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C73C385A4;
        Thu,  5 May 2022 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766674;
        bh=HAVCUwKRzzzGViCcf2QhsPvIC0F6WRsXgFuVQn2MY9w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nuuatEu5lMst9s45JGhFoVMYbDXrcZTeHgSmbpsW8EzqskUyskFg9sJAhdxfPeFlP
         HaKSPGtZNW4mWv5oIsypnLqzTgeKX6/wwnfO8dpeSeH5xKJfiDI7C9dnCHFv/5attR
         gKTETkGyfeMJr+Z8qzwWqhbCg65soALoeeo4m4/nq2f+eGtJ2bpMT5dGwBnnjJ4jWq
         M2KOVV4o2MdHoJTyJwbm49vJbP44M8Hl3YuCh0ZWPX4CGl7LGqPWPm2J65VusdKCyE
         TjojtlmOUlL3rTOMqrR66ox7su6Jgd+FFWYyYJsdOD6oF7Vf0Nvs9pwkD5T8zRCqG7
         HrsB88hBaCfJg==
Date:   Thu, 5 May 2022 09:04:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Carlos Fernandez <carlos.fernandez@technica-engineering.de>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Carlos Fernansez <carlos.escuin@gmail.com>,
        "carlos.fernandez@technica-enineering.de" 
        <carlos.fernandez@technica-enineering.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/macsec copy salt to MACSec ctx for XPN
Message-ID: <20220505090432.544ce339@kernel.org>
In-Reply-To: <AM9PR08MB6788E94C6961047699B20871DBC29@AM9PR08MB6788.eurprd08.prod.outlook.com>
References: <XPN copy to MACSec context>
        <20220502121837.22794-1-carlos.escuin@gmail.com>
        <f277699b10b28b0553c8bbfc296e14096b9f402a.camel@redhat.com>
        <AM9PR08MB6788E94C6961047699B20871DBC29@AM9PR08MB6788.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 May 2022 12:32:33 +0000 Carlos Fernandez wrote:
> When macsec offloading is used with XPN, before mdo_add_rxsa
> and mdo_add_txsa functions are called, the key salt is not
> copied to the macsec context struct.


So that it can be read out later by user space, but kernel 
doesn't need it. Is that correct?

Please also see below.

> Fix by copying salt to context struct before calling the
> offloading functions.
> 
> Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
> ---
>  drivers/net/macsec.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)

[snip]

>         rtnl_unlock();
> --
> 2.25.1
> 
> ________________________________________
> From: Paolo Abeni <pabeni@redhat.com>
> Sent: Tuesday, May 3, 2022 1:42 PM
> To: Carlos Fernansez
> Cc: carlos.fernandez@technica-enineering.de; Carlos Fernandez; David S. Miller; Eric Dumazet; Jakub Kicinski; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] net/macsec copy salt to MACSec ctx for XPN
> 
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.

You'll need to make a fresh posting without this quote and the legal
footer. Posting as a new thread is encouraged, you don't need to try
to make it a reply to the previous posting.

> Hello,
> 
> On Mon, 2022-05-02 at 14:18 +0200, Carlos Fernansez wrote:
> > From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
> >
> > Salt and KeyId copied to offloading context.
> >
> > If not, offloaded phys cannot work with XPN
> >
> > Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>  
> 
> This looks like a bugfix, could you please provide a relevant 'Fixes'
> tag? (in a v2).

