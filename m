Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069734FC2E9
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348747AbiDKRKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235105AbiDKRKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:10:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC32F1FCD8;
        Mon, 11 Apr 2022 10:07:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9133961736;
        Mon, 11 Apr 2022 17:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6980EC385A4;
        Mon, 11 Apr 2022 17:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649696868;
        bh=zuIe1s4v0t4bbjsE+1TfmJB8us8+U2Yt33ASuWZjdCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AFOhIOI0ySF4Euc0At3UCntZCIPfQdzmGY7J+ciGuOlq5babrNYN5wJjEo0UjmK48
         K6+CTFnP6sxGiohfKEMdSzZC/lnAe2cQV8UO296ViVqiwixj/y+jmQ40TD6+jXWUkm
         kQVfxK+s2P9XQD0Xpa8jJAEme34YlB2acARad6gS1W2Gj5a+/h9oCjldKccvBx6x6t
         +QdVVnQzGgJPPf373UsV76AfCjXPcFXoZ5l1zsN4EvX0lZAwS6RglAUnAWRAb1uepO
         KD81E6z13LulmxUmqf3W6SSo9YmjjcdwhAmQjrJUMFMasdc6D1UwFDHbOnEDxNByUI
         v8/+0qRWE7aKQ==
Date:   Mon, 11 Apr 2022 10:07:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, magnus.karlsson@intel.com,
        bjorn@kernel.org, netdev@vger.kernel.org, brouer@redhat.com,
        alexandr.lobakin@intel.com, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH bpf-next 00/10] xsk: stop softirq processing on full XSK
 Rx queue
Message-ID: <20220411100746.1231a5a6@kernel.org>
In-Reply-To: <YlRNPuHdN5RTZjDn@boxer>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
        <8a81791e-342e-be8b-fc96-312f30b44be6@nvidia.com>
        <Yk/7mkNi52hLKyr6@boxer>
        <82a1e9c1-6039-7ead-e663-2b0298f31ada@nvidia.com>
        <20220408111756.1339cb68@kernel.org>
        <YlRNPuHdN5RTZjDn@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Apr 2022 17:46:06 +0200 Maciej Fijalkowski wrote:
> > +1
> > cover letter refers to busy poll, but did that test enable prefer busy
> > poll w/ the timeout configured right? It seems like similar goal can 
> > be achieved with just that.  
> 
> AF_XDP busy poll where app and driver runs on same core, without
> configuring gro_flush_timeout and napi_defer_hard_irqs does not bring much
> value, so all of the busy poll tests were done with:
> 
> echo 2 | sudo tee /sys/class/net/ens4f1/napi_defer_hard_irqs
> echo 200000 | sudo tee /sys/class/net/ens4f1/gro_flush_timeout
> 
> That said, performance can still suffer and packets would not make it up
> to user space even with timeout being configured in the case I'm trying to
> improve.

Does the system not break out of busy poll then? See if the NAPI
hrtimer fires or not.

It's a 2k queue IIRC, with timeout of 200us, so 10Mpps at least.
What rate is l2fwd sustaining without these patches?

You may have to either increase the timeout or increase the frequency
of repoll from user space (with a smaller budget).
