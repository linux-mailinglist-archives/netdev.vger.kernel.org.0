Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07381686188
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 09:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjBAIWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 03:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbjBAIWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 03:22:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34425EFAB
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 00:21:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66EDFB82103
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E35C433EF;
        Wed,  1 Feb 2023 08:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675239716;
        bh=9j3jJBHAunamdWYGb5H4Tv2Ei7rphM2+Sue/tXWDDJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HDfOrWR+TZK3bFVqzg59+6AJBST5j2DxQcYGM7GBS4MBiS1ID0fCm9voWfl3lYCQn
         39LeYho33/QsKzFJzEtZkkIMbGNo/Lnaj8DA5KLNrHiiUpnIc30+cc65FQBnjIZ15d
         wgSTTAhmX/bTWTgDCD2blFTxD7I2x5ULPT49Rl3zdFI9JOBNiE/+O9V+477JH+UaU/
         ad7NTIlYi9dv2x+RhjaHopPGlYIY19x6SDnerm9e14ljKrptl77ckD6tcc7WTCWTZn
         A1U1da6O7b0aiQ2+O8OzZr6yn5U9ebWuPSd+QgSQA/CrjB+9wkMoMDu0D2XoHvJ4c7
         CNy8FC4vObH8g==
Date:   Wed, 1 Feb 2023 10:21:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yanguo Li <yanguo.li@corigine.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net] nfp: flower: avoid taking mutex in atomic context
Message-ID: <Y9ohH58dRgFWx9o4@unreal>
References: <20230131080313.2076060-1-simon.horman@corigine.com>
 <Y9j/Rvi9CSYX2qSk@unreal>
 <Y9kGcnKUUO5HURZX@corigine.com>
 <Y9kXV1LvDfXjzA9R@unreal>
 <20230131132129.0d043582@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131132129.0d043582@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 01:21:29PM -0800, Jakub Kicinski wrote:
> On Tue, 31 Jan 2023 15:27:51 +0200 Leon Romanovsky wrote:
> > > > > +	if ((port_id & NFP_FL_LAG_OUT) == NFP_FL_LAG_OUT) {
> > > > > +		memset(&lag_info, 0, sizeof(struct nfp_tun_neigh_lag));  
> > > > 
> > > > This memset can be removed if you initialize lag_info to zero.
> > > > struct nfp_tun_neigh_lag lag_info = {};  
> > > 
> > > Happy to change if that is preferred.
> > > Is it preferred?  
> > 
> > I don't see why it can't be preferred.
> 
> It's too subjective to make Simon respin, IMO.

I'm not insisting on respin, but would like to hear why writing compact
code with cleared variable on stack, which anyway needs to be cleared is
not preferred.

Thanks
