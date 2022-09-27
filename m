Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C905ECC27
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 20:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiI0Sct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 14:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiI0Scr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 14:32:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE941B8C85;
        Tue, 27 Sep 2022 11:32:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58469B81D16;
        Tue, 27 Sep 2022 18:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4379C433D6;
        Tue, 27 Sep 2022 18:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664303564;
        bh=lDAstUYH+b8Vttes5ZoyAJec6S7HjNPI+UMBYiUSXvE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nEZK1tSZPwg+xlxzmwdSbORnEn0N3jNryhA6/eQml7wXReAFrKwnxb5j1WvJ395Ue
         ranjvuz9Ddt1Rsi3pPhLiinrg3PRPWXvPdK6bOskODaO6+WmgNatpoeFUoI1gdWUFq
         ZzsjWI4jgd0Zy4x5FR9zt9FrinAEmJjKTX6UxyD1YvWIQ+4zPy7D+i98dILZkR4nxI
         smiDVlk6V05GhHE7one8Cm6bNqv060BD+S3MUhjVrd5VHTkotssFyUh4q2rsVBc9hj
         6PvDvjwv/LtC4tFFsmk37axZTQqP01NZRMDSJtAk7FzfJHOxHgDqUxPonXHb5Wg4Y5
         OIrlji3BCuqHw==
Date:   Tue, 27 Sep 2022 11:32:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Bo Liu <liubo03@inspur.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: Remove usage of the deprecated ida_simple_xxx API
Message-ID: <20220927113242.0349e2a8@kernel.org>
In-Reply-To: <YzMRM0jwh+fauIWz@hoboy.vegasvil.org>
References: <20220926012744.3363-1-liubo03@inspur.com>
        <YzMQSJtLA1LDMGOm@hoboy.vegasvil.org>
        <YzMRM0jwh+fauIWz@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 08:05:23 -0700 Richard Cochran wrote:
> On Tue, Sep 27, 2022 at 08:01:28AM -0700, Richard Cochran wrote:
> > On Sun, Sep 25, 2022 at 09:27:44PM -0400, Bo Liu wrote:  
> > > Use ida_alloc_xxx()/ida_free() instead of
> > > ida_simple_get()/ida_simple_remove().
> > > The latter is deprecated and more verbose.  
> > 
> > I can't say that I am excited about this.  It seems like a way to
> > create a regression.  I don't see any need to change.  After all,
> > there are many "deprecated" interfaces in use.  
> 
> /git/linux$ git grep ida_simple_get | wc -l
> 119
> 
> ~/git/linux$ git grep ida_simple_remove | wc -l
> 169
> 
> Please go take care of the other 100+ users of this API first, then
> come bother me again.

It's clearly marked as deprecated and the old API is literally
a define to the new one:

/*
 * ida_simple_get() and ida_simple_remove() are deprecated. Use
 * ida_alloc() and ida_free() instead respectively.
 */
#define ida_simple_get(ida, start, end, gfp)	\
			ida_alloc_range(ida, start, (end) - 1, gfp)
#define ida_simple_remove(ida, id)	ida_free(ida, id)


This transition is happening sooner or later. Do you have an objection
here or just don't want to review this? I can double check the ASM is
identical after applying...
