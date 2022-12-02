Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B527F63FD02
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiLBA1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiLBA0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:26:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37379DC87A
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:21:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB4C2621DC
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA182C433D7;
        Fri,  2 Dec 2022 00:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669940493;
        bh=GM+9b582pvxOdiQfqpVh+/5cuatGwrwuf6A+Ka3FJLc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dlMSASim81XvxzhOWVamk7laj9AJww+YASgil4YfUSizBMPs0lyuNO0EuvKoz+AVO
         xGSGveH87Sn5PJejvNWKhMA7twDT05rAcgpScvaPOwjXZ/TWgaiUNA8H/BGBma4v9J
         A1+BQh/opoZms8Q8rxF6gnvUsWikQpoX6Zn1lC0YgTg/ke9V5Aw8tenxMu/XGmI5IA
         KF55GoZTFvz7cV2G6MOZAwTFf0Qb1rmOKjqJ6bUAqt3h1g0A1ZAOVz8hPfOa2kdrow
         G0HsuiDThHoDUxSGL6lmgOThTbeejLzfuFP7Vphka/mpRRrPm+r+KWLAFK87Yo08cS
         yUE+xrLO0PTmA==
Date:   Thu, 1 Dec 2022 16:21:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] ethtool: add tx aggregation parameters
Message-ID: <20221201162131.1f6c6188@kernel.org>
In-Reply-To: <20221130124616.1500643-2-dnlplm@gmail.com>
References: <20221130124616.1500643-1-dnlplm@gmail.com>
        <20221130124616.1500643-2-dnlplm@gmail.com>
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

On Wed, 30 Nov 2022 13:46:14 +0100 Daniele Palmas wrote:
> Add the following ethtool tx aggregation parameters:

> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index bede24ef44fd..ac51a01b674d 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -1002,6 +1002,9 @@ Kernel response contents:
>    ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
>    ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
>    ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
> +  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES``     u32     max aggr packets size, Tx
> +  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES``    u32     max aggr packets, Tx
> +  ``ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS``    u32     time (us), aggr pkts, Tx
>    ===========================================  ======  =======================

Please double check make htmldocs does not generate warnings.
I think you went outside of the table bounds (further than
the ==== line)...
