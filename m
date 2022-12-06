Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9140643B22
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiLFCCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiLFCCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:02:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC92109D
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 18:02:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C19F9CE16C1
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B07C433C1;
        Tue,  6 Dec 2022 02:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670292156;
        bh=Y7FBk3MJw036RbymRzlGzg4cWU43CIn+UXqI5r1dqPA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OUk095gpFu6uj6wAz7ijiTen65RknF4IykV3wwE1M7H4iHORV1Do8jP4LNaSCcdzL
         b1k/UwslUej2W/VNdebnOaQ9P68/J3B1UsNJsDf9bx56f2cSRP2uoXaEFUdGRGFbQn
         y0vqsV0NOn2UjeruPrJzbRZ2ux6I+DbcEkw/hhHpS7qpC8pX5kaWK+AuyCp+2NN0gc
         Q9gfZvOxQrcgKmMIGqCX34XmssagQrpp9o7ED7Z0763ZmuDAXhjdY7HOY8SyGlSsW6
         d8eHodxqH50RGP8xTm39nzu92z85uUNdzf5tQgjXn31W0VeI8K749XkpuTRb2gdchD
         Vp//If01ntOOQ==
Date:   Mon, 5 Dec 2022 18:02:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, danielj@nvidia.com, yishaih@nvidia.com,
        jiri@nvidia.com, saeedm@nvidia.com, parav@nvidia.com
Subject: Re: [PATCH net-next V3 4/8] devlink: Expose port function commands
 to control RoCE
Message-ID: <20221205180234.2a8a5423@kernel.org>
In-Reply-To: <34381666-a7b5-9507-211a-162827b86153@amd.com>
References: <20221204141632.201932-1-shayd@nvidia.com>
        <20221204141632.201932-5-shayd@nvidia.com>
        <34381666-a7b5-9507-211a-162827b86153@amd.com>
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

On Mon, 5 Dec 2022 15:37:26 -0800 Shannon Nelson wrote:
> >   enum devlink_port_function_attr {
> >          DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
> >          DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,     /* binary */
> >          DEVLINK_PORT_FN_ATTR_STATE,     /* u8 */
> >          DEVLINK_PORT_FN_ATTR_OPSTATE,   /* u8 */
> > +       DEVLINK_PORT_FN_ATTR_CAPS,      /* bitfield32 */  
> 
> Will 32 bits be enough, or should we start off with u64?  It will 
> probably be fine, but since we're setting a uapi thing here we probably 
> want to be sure we won't need to change it in the future.

Ah, if only variable size integer types from Olek were ready :(

Unfortunately there is no bf64 today, so we'd either have to add soon
to be deprecated bf64 or hold off waiting for Olek...
I reckon the dumb thing of merging bf32 may be the best choice right
now :(
