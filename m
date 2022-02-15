Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403AF4B5FB6
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 02:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiBOBAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 20:00:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbiBOBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 20:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709831B79E
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 17:00:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB7D9B811E4
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 01:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A8FC340E9;
        Tue, 15 Feb 2022 01:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644886807;
        bh=FjQYj4cIkaDGv3E7Y/sTdt0Oe5zdswSHfUtlK/ej+ok=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MWSDZJx67pBZeC8OMTddaUnPsOGz0UIXlG4nBGvg090wsQ7Q6iDKvnwD3hM4VB91F
         kVpS1IE131ktBnqirtK9QWlPSyPkjYepwMzThxN/LCoqZpwlAcJqHUe4C/ikhhHNEZ
         Rndk60+yTLCkUSzDZedMdcDhkZg/E+sz4LMhLJPGshu0V/xVc1phkoqwl5fkpTulnu
         Qi2WKEtZKOJOZjvQHO/lGcY9M2dcA+eDW8TUI7pNhB/H7VGaPzFQVlpscURGl6Uk7D
         9j6Wg2D+e+RG6Dr4foBNfMu2NKweWftmzIwzYDyoZWnz7Kaahj+fn8QuDtZdGmsXTL
         UcrWecb/a4uvg==
Date:   Mon, 14 Feb 2022 17:00:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mobashshera Rasool <mobash.rasool.linux@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, mrasool@vmware.com,
        equinox@opensourcerouting.org, mobash.rasool@gmail.com
Subject: Re: [PATCH net-next] net: ip6mr: add support for passing full
 packet on wrong mif
Message-ID: <20220214170006.7a99b88d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJceWd-o4ubk=-rC_3DQfj55QqRMPr4T5BF1odxdiz9Gk1J1Bg@mail.gmail.com>
References: <BYAPR05MB6392296287614B80498B73C5CE339@BYAPR05MB6392.namprd05.prod.outlook.com>
        <CAJceWd-o4ubk=-rC_3DQfj55QqRMPr4T5BF1odxdiz9Gk1J1Bg@mail.gmail.com>
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

On Tue, 15 Feb 2022 02:53:49 +0530 Mobashshera Rasool wrote:
> This patch adds support for MRT6MSG_WRMIFWHOLE which is used to pass
> full packet and real vif id when the incoming interface is wrong.
> While the RP and FHR are setting up state we need to be sending the
> registers encapsulated with all the data inside otherwise we lose it.
> The RP then decapsulates it and forwards it to the interested parties.
> Currently with WRONGMIF we can only be sending empty register packets
> and will lose that data.
> This behaviour can be enabled by using MRT_PIM with
> val == MRT6MSG_WRMIFWHOLE. This doesn't prevent MRT6MSG_WRONGMIF from
> happening, it happens in addition to it, also it is controlled by the same
> throttling parameters as WRONGMIF (i.e. 1 packet per 3 seconds currently).
> Both messages are generated to keep backwards compatibily and avoid
> breaking someone who was enabling MRT_PIM with val == 4, since any
> positive val is accepted and treated the same.
> 
> Signed-off-by: Mobashshera Rasool <mobash.rasool@gmail.com>

Your patch got corrupted by your email client (line-wrapped), 
perhaps try git send-email?
