Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70AD54C0B07
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 05:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbiBWEXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 23:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBWEXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 23:23:32 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E5C27145
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 20:23:04 -0800 (PST)
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id D75A020159;
        Wed, 23 Feb 2022 12:22:58 +0800 (AWST)
Message-ID: <d7ee44e4ca9340943e88306542326f0e3b756837.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v3 1/2] mctp: make __mctp_dev_get() take a
 refcount hold
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Matt Johnston <matt@codeconstruct.com.au>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 23 Feb 2022 12:22:58 +0800
In-Reply-To: <20220222195914.6f001f66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220222041739.511255-1-matt@codeconstruct.com.au>
         <20220222041739.511255-2-matt@codeconstruct.com.au>
         <20220222195914.6f001f66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> Jeremy, did you have any specific semantics or naming scheme in mind
> here? PTAL. Is it better to make __mctp_dev_get() "safe" or create
> mctp_dev_get()? etc

The __ prefix is (was?) more about the requirement for the RCU read lock
there. That's still the case, so the __ may still be applicable.

We only have one non-test usage of a contender for a RCU-locked
mctp_dev_get(), ie, currently:

  rcu_read_lock();
  dev = __mctp_dev_get();
  rcu_read_unlock();

 - so I'm not sure it's worthwhile adding a separate function for that
at present, and I'm OK with this patch retaining the __.

I guess the question is really: as per existing conventions, does __
more imply an unlocked accessor, or a non-reference-counting accessor?

Cheers,


Jeremy

