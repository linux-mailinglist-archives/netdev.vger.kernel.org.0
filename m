Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16136525822
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359390AbiELXNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359384AbiELXNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:13:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E1014AC85;
        Thu, 12 May 2022 16:13:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9843362032;
        Thu, 12 May 2022 23:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13DBC385B8;
        Thu, 12 May 2022 23:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652397179;
        bh=YrHyNooh+9xg1ifmHbZjruMIOFBDmwBmoHnshNnE6xs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eYi9KKU7D8PB+ECU356yHEvxwRpMIwcjUSvF8cE8bYy+Eq5XO83JfcOvgYTG9KRjM
         ogGN6u2VuCkW4DG0+JPz4c4VmUx+gwTOhCRzvidvmkoWSh3ZUMJ/7pH0WbCD+ZDC2r
         OHjhN6+fwJBJbmUOb6IrgSfNTYyL5qePmbEzJFL7BU7UNikqzNNNItgZLW+qdBth72
         N4NAfQR2S4FsA7uOU+H+YWo2DutT87vL08Z4odLJ7/u9zxFQKs3Ic03yv2iQJ7QIQl
         nKl/Qy+oHdHs7aLB7kv5+LiW0acPY/9Rhs4d5vCAS/kAS4UNoWdEbeUhA+kM5IPiDT
         9YDEZBo/evqZA==
Date:   Thu, 12 May 2022 16:12:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC,net-next,x86 0/6] Nontemporal copies in unix socket write
 path
Message-ID: <20220512161257.016b4b71@kernel.org>
In-Reply-To: <20220512225302.GA74948@fastly.com>
References: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
        <20220511162520.6174f487@kernel.org>
        <20220512010153.GA74055@fastly.com>
        <20220512124608.452d3300@kernel.org>
        <20220512225302.GA74948@fastly.com>
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

On Thu, 12 May 2022 15:53:05 -0700 Joe Damato wrote:
>  1. Do you have any strong opinions on the sendmsg flag vs a socket option?

It sounded like you want to mix nt and non-nt on a single socket hence
the flag was a requirement. socket option is better because we can have
many more of those than there are bits for flags, obviously.

>  2. If I can think of a way to avoid the indirect calls, do you think this
>     series is ready for a v1? I'm not sure if there's anything major that
>     needs to be addressed aside from the indirect calls.

Nothing comes to mind, seems pretty straightforward to me.
