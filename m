Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5AB568F7E4
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 20:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjBHTSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 14:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjBHTSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 14:18:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFC14FC3A;
        Wed,  8 Feb 2023 11:18:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4874361777;
        Wed,  8 Feb 2023 19:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59434C433D2;
        Wed,  8 Feb 2023 19:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675883928;
        bh=RNVG/fngAuTX1edF9YmgOOb6HQhsd4ZE1AaeTKTAc6s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WPakw7qetankEe38YkQuRVyrkF5MsN9MNBIwTWnmrbqj+0QY2w5GGTfhBEZS3eCop
         4rinc3u0esNgAtJFF2awt1EM3UxmC3sjlwgntO7MdIPYtwGUXYRQTRwOahLovPwFhZ
         dtH1XM/xsB4MRPfqJsF6DKCF2ZjhwvqqrdnOyKelyCLWOat2y33tKDSdjB3G+P3+c5
         JVti4bVDxGeJb8SqBV65gICQf/j267nxoXwp3CMl/b3ECC3MttfpObgSX007LAIhRq
         6DfADMUQFg13blAk3QIcwtWUSKC6Txa3K0ixNSllHwqYM5gwfe5N8+iJGD5h2pOMMt
         E0RE7oU3fqjog==
Date:   Wed, 8 Feb 2023 11:18:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net ] vmxnet3: move rss code block under eop descriptor
Message-ID: <20230208111847.5110b2d4@kernel.org>
In-Reply-To: <3051468A-19BA-4CF4-AA4F-61ECA561E5F2@vmware.com>
References: <20230207192849.2732-1-doshir@vmware.com>
        <20230207221221.52de5c9a@kernel.org>
        <3051468A-19BA-4CF4-AA4F-61ECA561E5F2@vmware.com>
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

On Wed, 8 Feb 2023 18:48:42 +0000 Ronak Doshi wrote:
> > On Tue, 7 Feb 2023 11:28:49 -0800 Ronak Doshi wrote:  
> > > Commit b3973bb40041 ("vmxnet3: set correct hash type based on
> > > rss information") added hashType information into skb. However,
> > > rssType field is populated for eop descriptor.
> > >
> > > This patch moves the RSS codeblock under eop descritor.  
> >
> > Does it mean it always fails, often fails or occasionally fails
> > to provide the right hash?  
>
> This will cause issues mostly for cases which require multiple rx descriptors.
> For single rx descriptor packet, eop and sop will be same, so no issue.

Could you add to the commit message when user will most likely
encounter that situation?  With high MTUs?  Depending on the
underlying HW/NIC?
