Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36BC515344
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 20:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378012AbiD2SHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 14:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243172AbiD2SHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 14:07:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A1D8BE26
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 11:03:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01C8CB8376A
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 18:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4DBC385A7;
        Fri, 29 Apr 2022 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651255428;
        bh=fG3PhQdwEV8ap91EThyFQ8ikM/vmOL4FgriTu6LVUpI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=am4VfvIzY8E5vSZjaBR9Cl5TsLMj+KKxQAIl7RZJUI5aDlCi9djKjPwbrNM+Ga5R9
         zzfJdAGFFgAUiYSy8PVD3C7Ij3lkZ3dYCvpqUV/VZ2V65yv5kg7XbzpI6MpS29EezS
         pmXq110ZzjEebjJFAcX/l1LstG+v6Gq/rmzVc0WL3G7qmdKBvrO/9HUfY2x1VtzCSM
         Vs89kL+A2aq6t+FroVGz4ekOr354aPUTaPM77v81dpIel8mMSz9iuDT9I0TApkPLdb
         aEYKsT5X0AV92uDfjrc51Tns+IbclZiGdIfb+4mKw9q+RLbDT8d5pkGQbhIi+QHEBs
         u5C+8MgWtKS5Q==
Date:   Fri, 29 Apr 2022 11:03:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bin Chen <bin.chen@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next] nfp: VF rate limit support
Message-ID: <20220429110347.1d563c7b@kernel.org>
In-Reply-To: <SA1PR13MB5491A2994E4170BA33CCB7CEECFC9@SA1PR13MB5491.namprd13.prod.outlook.com>
References: <20220422131945.948311-1-simon.horman@corigine.com>
        <20220425165321.1856ebb7@kernel.org>
        <SA1PR13MB5491A2994E4170BA33CCB7CEECFC9@SA1PR13MB5491.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 08:54:53 +0000 Bin Chen wrote:
> On Tue, 26 Apr 2022 7:53 AM, Jakub wrote:
> > On Fri, 22 Apr 2022 15:19:45 +0200 Simon Horman wrote:  
> > > +	if (max_tx_rate > 0 || min_tx_rate > 0) {
> > > +		if (max_tx_rate > 0 && max_tx_rate < min_tx_rate) {
> > > +			nfp_warn(app->cpp, "min-tx-rate exceeds max_tx_rate.\n");
> > > +			return -EINVAL;
> > > +		}  
> > 
> > This check should be moved to the core, I reckon.
> >  
> We agree with your suggestion, thanks. We plan to do this in two steps:
> 1.The firmware that currently support this feature will reject the nonzero min_tx_rate configuration, so the check here will not step in.  We will remove the check from driver site and upstream the patch. 
> 2.We will do more investigation jobs and add an appropriate check in the core.
> What do you think?

Sorry, I meant the second part of the condition only, basically
something like:

