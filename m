Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0AB6B8413
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 22:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCMVj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 17:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCMVjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 17:39:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2F437B68;
        Mon, 13 Mar 2023 14:39:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A846B810E7;
        Mon, 13 Mar 2023 21:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8C3C433D2;
        Mon, 13 Mar 2023 21:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678743559;
        bh=f8xrkbRs0vQpM4Vnb3kKGUiowgDZvwJokX47Hdhd9BQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bB/xCLjxWX/4rI2bd9wwyO4rnB2Vl74rg0z1X6jYGKeKf8mWtn0O/FX4HaDDFVlnI
         ZjC+7O8KAL6yYg2/c6BD/vts2pF/VtZ00PgUQtrWHn2V8C32WKLpvQEWbrx4J/REAH
         My7E59UJDKPCkKMMC/vv+33T+V4U9QGiwPsNEhAjG4Rzba5+OCCiq7SrW6bi8fOcdf
         C1rG9KeawpqwEc1b1FC9rKSS3ukAbHpkAUlpkcEgI2JNAfUYWfKdfyOjCBVhzTi/CC
         9ZSvfwIrLY3e13R3WQedPKwC2zLNy4SnZpANKs/KL/AOd8I7sWzk9SA6/crUMsdkDS
         dnzqe+tBBXYfg==
Date:   Mon, 13 Mar 2023 14:39:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jorge Merlino <jorge.merlino@canonical.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Add symlink in /sys/class/net for interface altnames
Message-ID: <20230313143917.076da099@kernel.org>
In-Reply-To: <20230313164903.839-1-jorge.merlino@canonical.com>
References: <20230313164903.839-1-jorge.merlino@canonical.com>
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

On Mon, 13 Mar 2023 13:49:03 -0300 Jorge Merlino wrote:
> Currently interface altnames behave almost the same as the interface
> principal name. One difference is that the not have a symlink in
> /sys/class/net as the principal has.
> This was mentioned as a TODO item in the original commit:
> https://lore.kernel.org/netdev/20190719110029.29466-1-jiri@resnulli.us
> This patch adds that symlink when an altname is created and removes it
> when the altname is deleted.

I think this is risky. Altnames are added by systemd on unsuspecting
systems, and I've seen configurations systems which assume that all
/sys/class/net entries are separate devices (basically counting how 
many NICs machine has).

I'm afraid it's too late.
