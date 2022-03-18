Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8069E4DE096
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 18:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbiCRR6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 13:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240041AbiCRR6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 13:58:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19483262D44
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 10:56:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C23FAB824EF
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 17:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50530C340E8;
        Fri, 18 Mar 2022 17:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647626212;
        bh=WE2KarA0Jv5Fje4nc+MypRB+rxKa8QxxOnfzb/d/opU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d+a9Wkph7PtQQkItuC1J3euVoZNKP/m6ExyhY1PNEnzDsJXhqAqVwAAjK0UUwvCmi
         qfO7HTaUcXCmBNrCd9PN5BFcPnn31s0eckqhhXNks/VE4fQFOMlRUEmIaHpDBkVO7U
         8g4QEtbSbwQmaJurLuW+8MH2UXpfExbVsGGhC6NXtgnvUuZ+PEdPDR1jp2PbYneyVZ
         bkXeFGQzGkt9wII5JpKLw0plglnhHYM5xH/m8+/U4T7F3Zr3KFTpbvok74Br4/SvUm
         1xf9lsfAOONtinoaCeyoYNdlkM6bWkTIZClP9Wp94rT0HrIIsFFISX95XeRmlEPOXd
         1NloDwrx0u+fw==
Date:   Fri, 18 Mar 2022 10:56:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next 10/10] nfp: nfdk: implement xdp tx path for
 NFDK
Message-ID: <20220318105645.3ee1cb6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220318101302.113419-11-simon.horman@corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
        <20220318101302.113419-11-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 11:13:02 +0100 Simon Horman wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Due to the different definition of txbuf in NFDK comparing to NFD3,
> there're no pre-allocated txbufs for xdp use in NFDK's implementation,
> we just use the existed rxbuf and recycle it when xdp tx is completed.
> 
> For each packet to transmit in xdp path, we cannot use more than
> `NFDK_TX_DESC_PER_SIMPLE_PKT` txbufs, one is to stash virtual address,
> and another is for dma address, so currently the amount of transmitted
> bytes is not accumulated. Also we borrow the last bit of virtual addr
> to indicate a new transmitted packet due to address's alignment
> attribution.
> 
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Fei Qin <fei.qin@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Breaks 32 bit :(
