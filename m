Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B911A64242E
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiLEIK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbiLEIKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:10:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE5112768;
        Mon,  5 Dec 2022 00:10:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA1B1CE0E70;
        Mon,  5 Dec 2022 08:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F31C433C1;
        Mon,  5 Dec 2022 08:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670227838;
        bh=bJfx2nisTz0YoKUNfyf6INNDFLiT9EB6dkRFocRpzEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UXypBBHuFXuB/WTm2gRXmQlrRlINa08iA/+Rm5vw64/4uj4uMXlCLCfAqVjRSUDy5
         xfTbNfyQr3WxHRi1ceV9MCCaLq89CJ3gsqU6RGTePGin2CTWCUsVbbItr0qPM9hqmN
         yF8Z/d2nSfWc/kFnruNiCkrq0q/09lNOC4CLT5KBfBUNlgnf4uKrYxCBILoJPBbmvO
         J8QrShIAhdcvCmkgnQSWcQJ6OOTW1exbeiEcsWdnhkw+qhGeNbuNLTl45gr3pG51/0
         FvfPHvaoA46PINU7CQ8ZN/kqCg5nFKRRNTsLLPOkVENCvqr3k+biKGG/p/wfg4PUzS
         aGLWiass2x7vw==
Date:   Mon, 5 Dec 2022 10:10:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liron Himi <lironh@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Message-ID: <Y42nerLmNeAIn5w9@unreal>
References: <20221129130933.25231-1-vburru@marvell.com>
 <20221129130933.25231-3-vburru@marvell.com>
 <Y4cirWdJipOxmNaT@unreal>
 <BYAPR18MB242397C352B0086140106A46CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
 <Y4hhpFVsENaM45Ho@unreal>
 <BYAPR18MB2423229A66D1C98C6C744EE1CC189@BYAPR18MB2423.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR18MB2423229A66D1C98C6C744EE1CC189@BYAPR18MB2423.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 04:46:31AM +0000, Veerasenareddy Burru wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Thursday, December 1, 2022 12:11 AM
> > To: Veerasenareddy Burru <vburru@marvell.com>
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Liron Himi
> > <lironh@marvell.com>; Abhijit Ayarekar <aayarekar@marvell.com>; Sathesh
> > B Edara <sedara@marvell.com>; Satananda Burla <sburla@marvell.com>;
> > linux-doc@vger.kernel.org; David S. Miller <davem@davemloft.net>; Eric
> > Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> > Paolo Abeni <pabeni@redhat.com>
> > Subject: Re: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
> > messages
> > 
> > On Wed, Nov 30, 2022 at 03:44:30PM +0000, Veerasenareddy Burru wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Leon Romanovsky <leon@kernel.org>
> > > > Sent: Wednesday, November 30, 2022 1:30 AM
> > > > To: Veerasenareddy Burru <vburru@marvell.com>
> > > > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Liron Himi
> > > > <lironh@marvell.com>; Abhijit Ayarekar <aayarekar@marvell.com>;
> > > > Sathesh B Edara <sedara@marvell.com>; Satananda Burla
> > > > <sburla@marvell.com>; linux-doc@vger.kernel.org; David S. Miller
> > > > <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> > Jakub
> > > > Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> > > > Subject: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for
> > > > control messages
> > > >
> > > > External Email
> > > >
> > > > --------------------------------------------------------------------
> > > > -- On Tue, Nov 29, 2022 at 05:09:25AM -0800, Veerasenareddy Burru
> > > > wrote:
> > > > > Poll for control messages until interrupts are enabled.
> > > > > All the interrupts are enabled in ndo_open().
> > > >
> > > > So what are you saying if I have your device and didn't enable
> > > > network device, you will poll forever?
> > > Yes, Leon. It will poll periodically until network interface is enabled.
> > 
> > I don't know if it is acceptable behaviour in netdev, but it doesn't sound right
> > to me. What type of control messages will be sent by FW, which PF should
> > listen to them?
> > 
> 
> These messages include periodic keep alive (heartbeat) messages from FW and control messages from VFs.
> Every PF will be listening for its own control messages.

@netdev, as I said, I don't know if it is valid behaviour in netdev.
Can you please comment?

Thanks
