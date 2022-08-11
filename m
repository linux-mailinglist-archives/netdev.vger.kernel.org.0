Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338405904CC
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbiHKQpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbiHKQo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:44:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EA9C2E81;
        Thu, 11 Aug 2022 09:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 094FF614D3;
        Thu, 11 Aug 2022 16:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2BCC433C1;
        Thu, 11 Aug 2022 16:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234642;
        bh=t9VhEpUjYvTdJkRqI5lS5IsBAlj1Zh6IR8yLwF+TAS8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HVN683FPMyha4FVsEredCDYla35x2DGWmAWifZ6GP2ZpaA6v+DYiGudIs8eJnXUvQ
         G6ZDcUKg3Ei25uADd9glqDPlHfzm64i7jwt0OyaiYxmNOgnqLCXkEMuWI3Px5hedlP
         ZngoY8FrUg9Lq8gR/GI2wVD7lYdxlpZrXElESAjuF6gYrxJZpO0QDwOtLwV8Zpv1u8
         Zl1pZGpoL1KJUX0OpQxkltJVXzn0s0CydsNXitP6foUJsP+gOf9sxq2oyalpX7vcYa
         gtVQ/ffDsj52C9Hzdy/VI4xQt6OHb+E6HspA3pSGUfGMWrR7rDXDMTZqCjDupx0vYq
         jq8nSoJPt1fgQ==
Date:   Thu, 11 Aug 2022 09:17:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, ecree@xilinx.com,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-net-drivers@amd.com, Jacob Keller <jacob.e.keller@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [RFC PATCH net-next] docs: net: add an explanation of VF (and
 other) Representors
Message-ID: <20220811091720.1e82eb46@kernel.org>
In-Reply-To: <CAKgT0UdLFjxdxHTPb7c+Deih2Bciziz=gZxDYWUFsLNNetOFQg@mail.gmail.com>
References: <20220805165850.50160-1-ecree@xilinx.com>
        <20220805184359.5c55ca0d@kernel.org>
        <71af8654-ca69-c492-7e12-ed7ff455a2f1@gmail.com>
        <20220808204135.040a4516@kernel.org>
        <572c50b0-2f10-50d5-76fc-dfa409350dbe@gmail.com>
        <20220810105811.6423f188@kernel.org>
        <cccb1511-3200-d5aa-8872-804f0d7f43a8@gmail.com>
        <CAKgT0UdLFjxdxHTPb7c+Deih2Bciziz=gZxDYWUFsLNNetOFQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 15:58:54 -0700 Alexander Duyck wrote:
> > Sure, but as an application of that, people talk about e.g. "host"
> >  and "device" ends of a bus, DMA transfer, etc.  As a result of which
> >  "host" has come to mean "computer; server; the big rack-mounted box
> >  you plug cards into".
> > A connotation which is unfortunate once a single device can live on
> >  two separate PCIe hierarchies, connected to two computers each with
> >  its own hostname, and the one which owns the device is the cluster
> >  of embedded CPUs inside the card, rather than the big metal box.  
> 
> I agree that "host" isn't going to work as a multi-host capable device
> might end up having only one "host" that can actually handle the
> configuration of the switch for the entire device. So then you have
> different types of "host" interfaces.

Thank $deity I haven't had to think about multi-host NPU/DPU/IPUs
for a couple of years now, but I think trying to elect a leader in
charge across the hosts is not a good idea there. Much easier to proxy
all configuration thru FW, as much as I hate that (since FW is usually
closed).

That said choosing the term is about intuition not proofs so "host"
won't fly.
