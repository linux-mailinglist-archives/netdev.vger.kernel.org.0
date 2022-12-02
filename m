Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F4A641017
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 22:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbiLBVjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 16:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbiLBVjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 16:39:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8929EDE5E7
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 13:39:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A924B822B4
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 21:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59BCC433C1;
        Fri,  2 Dec 2022 21:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670017143;
        bh=pztomAxQIkCDHkDFu0pkzBVSvo5Pu95UTc7JuVWJtVU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HGR/w+W8QAV90+RYK4Elk2ojhLM3Q4mr1dvF0dHksZLiMkW1Sy/Ooqqx0kS6xQaAz
         AINYHlPXZ2I72ITf5K4bv3PYS2+DwGOM0cDTjvLtti+YdOlsQkFg1rJ0gLvU/wi/Cf
         JOJlMCjtEXuUOCdTlwJnoF+lRxtX1fYLGvC+Fsbz1uBZfDoc1UaudLhxdP0T1grHQK
         irNBkjXu6OL7/lZVFPsBaQWJyMH/+WREs1mxcucx2vzO0aT8bAPRXwT+iXmBwZv6jH
         qALN9J8kG3VnYh6eDUmEazCW8Zu8dghfy0E96eZBCBPtquYyXE3/T1DIo16jR3kJuf
         3Ji32UrAGNDEg==
Date:   Fri, 2 Dec 2022 13:39:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Etienne Champetier <champetier.etienne@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Multicast packet reordering
Message-ID: <20221202133902.7888c0ce@kernel.org>
In-Reply-To: <CAOdf3goC0eXSqdpdcq_-4wegMTBmYdK_uQOKUpjX7azvTamWDA@mail.gmail.com>
References: <e0f9fb60-b09c-30ad-0670-aa77cc3b2e12@gmail.com>
        <20221202103429.1887d586@kernel.org>
        <CAOdf3goC0eXSqdpdcq_-4wegMTBmYdK_uQOKUpjX7azvTamWDA@mail.gmail.com>
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

On Fri, 2 Dec 2022 15:09:13 -0500 Etienne Champetier wrote:
> > Yes, there are per-cpu queues in various places to help scaling,
> > if you don't pin the sender to one CPU and it gets moved you can
> > understandably get reordering w/ UDP (both on lo and veth).  
> 
> Is enabling RPS a workaround that will continue to work in the long term,
> or it just fixes this reordering "by accident" ?

For lo and veth it should continue to work.

> And I guess pinning the sender to one CPU is also important when
> sending via a real NIC, not only moving packets internally ?

Yes, for UDP with real NICs you may want to try to pin a flow 
to a particular NIC queue.. somehow. Not sure how much of a problem
this is in practice.
