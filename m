Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6119547211
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 06:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344892AbiFKEpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 00:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiFKEpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 00:45:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD6D6D3BE;
        Fri, 10 Jun 2022 21:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CDD060AB2;
        Sat, 11 Jun 2022 04:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDABC34116;
        Sat, 11 Jun 2022 04:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654922708;
        bh=wGn2rPCuxew5qwldJYSVq19UhC8f95uZDKrBI+AiCAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EOyxoKLc9zXozWV7DhcLaFfbrZrgbhBfWXvYbc+Lt4wFOIHKclOPGOCzoYGcMtDZh
         RG+SyRAXenLZQC7KMgi/e5wAXA9dlIAaqo4FYwicuklL6O0V9bglXECa/erWrP4892
         sw28v8UNUIYjuFFFMlOHMn/BdLYAZIHQRGrzcV/XzvwhmGAi9GgAUU1+7j9oQpVSZu
         KEAJfI1eUdBhkdaITLN7U9feUtgkZEAQHZnP6BAj4Ky1qSqXNF/e0sJZ9ONuARh66L
         ayhkV6fKRt1LWfXp0iWBx92ZBISS7NHAaodySUd+q6PFhPK39pZ2YFQtu5IxElOEY1
         U14TuxV1zh5dQ==
Date:   Fri, 10 Jun 2022 21:45:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 0/6] Configurable VLAN mode for NCSI driver
Message-ID: <20220610214506.74c3f89c@kernel.org>
In-Reply-To: <3c9fa928-f416-3526-be23-12644d18db3b@linux.intel.com>
References: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
        <20220610130903.0386c0d9@kernel.org>
        <3c9fa928-f416-3526-be23-12644d18db3b@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Jun 2022 11:25:03 +0800 Jiaqing Zhao wrote:
> > Why is "ncsi,vlan-mode" set via the device tree? Looks like something
> > that can be configured at runtime.   
> 
> Actually this cannot be configured at runtime, the NCSI spec defines no
> command or register to determine which mode is supported by the device.

To be clear I'm not saying that it should be auto-detected and
auto-configured. Just that user space can issue a command to change 
the config.

> If kernel want to enable VLAN on the NCSI device, either "Filtered tagged
> + Untagged" (current default) or "Any tagged + untagged" mode should be
> enabled, but unfortunately both of these two modes are documented to be
> optionally supported in the spec. And in real cases, there are devices
> that only supports one of them, or neither of them. So I added the device
> tree property to configure which mode to use.

But for a given device its driver knows what modes are supported.
Is it not possible to make the VLAN mode passed thru ncsi-netlink?

Better still, can't "Filtered tagged + Untagged" vs "Any tagged +
untagged" be decided based on netdev features being enabled like it
is for normal netdevs?
