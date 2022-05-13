Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE10525D30
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 10:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244030AbiEMIP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 04:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiEMIPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 04:15:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42A0B1FE1C2;
        Fri, 13 May 2022 01:15:24 -0700 (PDT)
Date:   Fri, 13 May 2022 10:15:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: [RFC] netfilter: nf_tables: ignore errors on flowtable device hw
 offload setup
Message-ID: <Yn4TmdzQPUQ4TRUr@salvia>
References: <20220510202739.67068-1-nbd@nbd.name>
 <Yn4NnwAkoVryQtCK@salvia>
 <b1fd2a80-f629-48a3-7466-0e04f2c531df@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b1fd2a80-f629-48a3-7466-0e04f2c531df@nbd.name>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 10:03:13AM +0200, Felix Fietkau wrote:
> 
> On 13.05.22 09:49, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > On Tue, May 10, 2022 at 10:27:39PM +0200, Felix Fietkau wrote:
> > > In many cases, it's not easily possible for user space to know, which
> > > devices properly support hardware offload.
> > 
> > Then, it is a matter of extending the netlink interface to expose this
> > feature? Probably add a FLOW_BLOCK_PROBE or similar which allow to
> > consult if this feature is available?
> > 
> > > Even if a device supports hardware flow offload, it is not
> > > guaranteed that it will actually be able to handle the flows for
> > > which hardware offload is requested.
> > 
> > When might this happen?
>
> I think there are many possible reasons: The flow might be using features
> not supported by the offload driver. Maybe it doesn't have any space left in
> the offload table. I'm sure there are many other possible reasons it could
> fail.

This fallback to software flowtable path for partial scenarios already
exists.

> > > Ignoring errors on the FLOW_BLOCK_BIND makes it a lot easier to set up
> > > configurations that use hardware offload where possible and gracefully
> > > fall back to software offload for everything else.
> > 
> > I understand this might be useful from userspace perspective, because
> > forcing the user to re-try is silly.
> > 
> > However, on the other hand, the user should have some way to know from
> > the control plane that the feature (hardware offload) that they
> > request is not available for their setup.
>
> In my opinion, most users of this API probably don't care and just want to
> have offload on a best effort basis.

OK, but if the setup does not support hardware offload at all, why
should the control plane accept this? I think user should know in
first place that no one single flow is going to be offloaded to
hardware.

> Assuming that is the case, wouldn't it be better if we simply have
> an API that indicates, which flowtable members hardware offload was
> actually enabled for?

What are you proposing?

I think it would be good to expose through netlink interface what the
device can actually do according to the existing supported flowtable
software datapath features.
