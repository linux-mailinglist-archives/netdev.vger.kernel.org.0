Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5D0535293
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 19:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344234AbiEZRfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 13:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344134AbiEZRfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 13:35:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2D56D849
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 10:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65647B82178
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 17:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C42C385A9;
        Thu, 26 May 2022 17:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653586541;
        bh=UGNguR4h86BboxrgDKQ41X8wz11SVAhvgdPcGBdP7WM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=azjFMWdSQekJ7KmCsI3JbsQFHKcn+NKhimJEzEDVSgHEkpiTxsj3DNOnCRSUI9TIg
         PdUqCjCIZ8yw/BDUzB0rt85xFG8A7bkbXmIuV8m5TkU2b9dHr7nE3s3hWTKfxCWTm9
         JzxO1rposdq/1mhczGwDp1QQxIRaVxZDVxS2CWdq0vXAA7/zJiJiqwpyuXeSMIBpn4
         S3juJ76NJgolSg7OWwtF99tq0NhRB5+sCeZLSWn5g5wyVze6HgSCy1ItFHIjKpNogv
         3ii450dU3ChPjNkcRLWYgdKt287J1stPmEvyTKZT3knUEjZBphKYnv3FKMpTbNufRG
         aFRe1KN/2rwew==
Date:   Thu, 26 May 2022 10:35:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220526103539.60dcb7f0@kernel.org>
In-Reply-To: <Yo9obX5Cppn8GFC4@nanopsycho>
References: <20220429153845.5d833979@kernel.org>
        <YmzW12YL15hAFZRV@nanopsycho>
        <20220502073933.5699595c@kernel.org>
        <YotW74GJWt0glDnE@nanopsycho>
        <20220523105640.36d1e4b3@kernel.org>
        <Yox/TkxkTUtd0RMM@nanopsycho>
        <YozsUWj8TQPi7OkM@nanopsycho>
        <20220524110057.38f3ca0d@kernel.org>
        <Yo3KvfgTVTFM/JHL@nanopsycho>
        <20220525085054.70f297ac@kernel.org>
        <Yo9obX5Cppn8GFC4@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 May 2022 13:45:49 +0200 Jiri Pirko wrote:
> >Separate instance:
> >
> >	for (i = 0; i < sw->num_lcs; i++) {
> >		devlink_register(&sw->lc_dl[i]);
> >		devlink_line_card_link(&sw->lc[i], &sw->lc_dl[i]);
> >	}
> >
> >then report that under the linecard
> >
> >	nla_nest_start(msg, DEVLINK_SUBORDINATE_INSTANCE);
> >	devlink_nl_put_handle(msg, lc->devlink);
> >	nla_nest_end(msg...)
> >
> >then user can update the linecard like any devlink instance, switch,
> >NIC etc. It's better code reuse and I don't see any downside, TBH.  
> 
> Okay, I was thinking about this a litle bit more, and I would like to
> explore extending the components path. Exposing the components in
> "devlink dev info" and then using them in "devlink dev flash". LC could
> be just one of multiple potential users of components. Will send RFC
> soon.

Feel free to send a mockup of the devlink user space outputs.
The core code for devlink is just meaningless marshaling anyway.
