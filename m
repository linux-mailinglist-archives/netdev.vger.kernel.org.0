Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72B84DE32F
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239224AbiCRVDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiCRVDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:03:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9512DF3C8;
        Fri, 18 Mar 2022 14:02:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6B0AB82584;
        Fri, 18 Mar 2022 21:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30459C340E8;
        Fri, 18 Mar 2022 21:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647637319;
        bh=/GpQ4N6hhrN3D8ouvzjMJqXG0gXZidH3kDz4f2MPDLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HkCijFl/oV+GsvrqIM28miZDn7/+/0YG8rqCaJcHVguONz5RxWkFqWD32Kmm5wzUk
         cXwBtCT1lN7twuqKnxIse8J7CXm8nL6XivOQybI0CXLT4xRWsXitHt+ZsHdnSd5h6m
         an+g8TX+O/ys0zOkxnztBvzIX5GU0hmgNMPOqa+t1GGRJb9ueDcAeHaq7IgODTEpE+
         xgeXuwBhiNjyVlPoVmrWREG3yzawr9448KdVE/a+lBQXKry64d8vvW7hwI1c8C9Z0/
         vftqhIMDlpkbCbzFrLLz8V4tl2vPvkoHLPxZ9orFfF5g8T0GNOywVSfUVwWar5TMBD
         w3MF85tGQ2H2A==
Date:   Fri, 18 Mar 2022 14:01:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, pabeni@redhat.com,
        toke@redhat.com, andrii@kernel.org, nbd@nbd.name
Subject: Re: [PATCH bpf-next] net: xdp: introduce XDP_PACKET_HEADROOM_MIN
 for veth and generic-xdp
Message-ID: <20220318140153.592ac996@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YjTji4qgDbrXg4D+@lore-desk>
References: <039064e87f19f93e0d0347fc8e5c692c789774e6.1647630686.git.lorenzo@kernel.org>
        <20220318123323.75973f84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YjTji4qgDbrXg4D+@lore-desk>
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

On Fri, 18 Mar 2022 20:54:51 +0100 Lorenzo Bianconi wrote:
> > IIUC the initial purpose of SKB mode was to be able to test or
> > experiment with XDP "until drivers add support". If that's still
> > the case the semantics of XDP SKB should be as close to ideal
> > XDP implementation as possible.
> 
> XDP in skb-mode is useful if we want to perform a XDP_REDIRECT from
> an ethernet driver into a wlan device since mac80211 requires a skb.

Ack, I understand the use case is real, but given that the TC
alternative exists we can apply more scrutiny to the trade offs.
IMO production use of XDP skb mode would be a mistake, the thing 
is a layering violation by nature. Our time is better spent making
TC / XDP code portability effortless.

> > We had a knob for specifying needed headroom, is that thing not
> > working / not a potentially cleaner direction?
> >
>
> which one do you mean? I guess it would be useful :)

We have ndo_set_rx_headroom and dev->needed_headroom.
Sorry for brevity, I'm on the move today, referring to things 
from memory :)
