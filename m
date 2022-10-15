Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B8F5FFAC1
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 17:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiJOPJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 11:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJOPJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 11:09:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1A511A37
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 08:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uOMgHb9WxbRds9ZVNHGmpGgfS18m3KTn/yda8oq66Y8=; b=KQ/Tx2vlQgS4MCawBCGawBtp2R
        dEKUB5kUjuKOjy999prByXxsMXuwxlF0u3ExXV9jju0owA411j6OD6ruQLz0H3NwnemVdvuwM+Eut
        Si2RDAYvTsqBQss7lH9oMuXD0sOkKypyfxea9li9zkY59XTrsHgKIQFUmyvtUgePrlSM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ojin8-00232R-A5; Sat, 15 Oct 2022 17:09:34 +0200
Date:   Sat, 15 Oct 2022 17:09:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     irusskikh@marvell.com, dbogdanov@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Li Liang <liali@redhat.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
Message-ID: <Y0rNLpmCjHVoO+D1@lunn.ch>
References: <20221014103443.138574-1-ihuguet@redhat.com>
 <Y0lSYQ99lBSqk+eH@lunn.ch>
 <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com>
 <Y0llmkQqmWLDLm52@lunn.ch>
 <CACT4oudn-sS16O7_+eihVYUqSTqgshbbqMFRBhgxkgytphsN-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4oudn-sS16O7_+eihVYUqSTqgshbbqMFRBhgxkgytphsN-Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Maybe the lock needs to be moved closer to what actually needs to be
> > protect? What is it protecting?
> 
> It's protecting the operations of aq_macsec_enable and aq_macsec_work.
> The locking was closer to them, but the idea of this patch is to move
> the locking to an earlier moment so, in the case we need to abort, do
> it before changing anything.

aq_check_txsa_expiration() seems to be one of the issues? At least,
the lock is taken before and released afterwards. So what in
aq_check_txsa_expiration() requires the lock?

I don't like the use of rtnl_trylock(). It suggests the basic design is
wrong, or overly complex, and so probably not working correctly.

https://blog.ffwll.ch/2022/07/locking-engineering.html

Please try to identify what is being protected. If it is driver
internal state, could it be replaced with a driver mutex, rather than
RTNL? Or is it network stack as a whole state, which really does
require RTNL? If so, how do other drivers deal with this problem? Is
it specific to MACSEC? Does MACSEC have a design problem?

   Andrew
