Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7514C5F49E3
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 21:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiJDTwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 15:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJDTv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 15:51:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406036B156;
        Tue,  4 Oct 2022 12:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5A2B6141B;
        Tue,  4 Oct 2022 19:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A435C433C1;
        Tue,  4 Oct 2022 19:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664913109;
        bh=TeN6ehnVEox16o2vQmBTliyjz88d8D/mx70KrdN795g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HE34e9c12tSg4Qi6lrUFpmw592Qbhct2z2qjumi34iWrQzXW68Os8/HzunByR4uU2
         kSnSQpc9tRGS1Axi0mWLmI3RTN5V511XEVv6arsnCf9ROZZJ1KMCsdasrue6BSXT3H
         aAVbErjXfW/OnU7+ir6uxXUTzaxWm0lZlAs9C6a/koE5kygTmfo5alE0bv56GhC8DA
         110PiR49JR35hSuwqef1ajI8Lajml2kBwHWwfIIzyDCHZTO6/RbGLYDoJhrUaBnnUe
         CMF2o0QA9ILreyif3wN/2cqcjI3wzyWoZ4pnY6r/xGXav4AMxOJOfHngHgTE62c2mL
         hVCTG1bN97SYw==
Date:   Tue, 4 Oct 2022 12:51:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Message-ID: <20221004125147.7f76d409@kernel.org>
In-Reply-To: <87v8ozx3hb.fsf@nvidia.com>
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
        <20220929185207.2183473-2-daniel.machon@microchip.com>
        <87leq1uiyc.fsf@nvidia.com>
        <20220930175452.1937dadd@kernel.org>
        <87pmf9xrrd.fsf@nvidia.com>
        <20221003092522.6aaa6d55@kernel.org>
        <87zgebx3zb.fsf@nvidia.com>
        <87v8ozx3hb.fsf@nvidia.com>
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

On Tue, 4 Oct 2022 12:52:35 +0200 Petr Machata wrote:
> > The question is whether it's better to do it anyway. My opinion is that
> > if a userspace decides to make assumptions about the contents of a TLV,
> > and neglects to validate the actual TLV type, it's on them, and I'm not
> > obligated to keep them working. We know about this case, but really any
> > attribute addition at all could potentially trip some userspace if they
> > expected something else at this offset.  
> 
> And re the flag: I think struct dcbmsg.dcb_pad was meant to be the place
> to keep flags when the need arises, but it is not validated anywhere, so
> we cannot use it. It could be a new command, but I'm not a fan. So if we
> need to discriminate userspaces, I think it should be a new attribute.

All good points. I'm fine with not gating the attributes if that's your
preference. Your call.
