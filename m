Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8464C17C5
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 16:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbiBWPxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 10:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbiBWPxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 10:53:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23A9E8B
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 07:52:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5632BB820C4
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 15:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF30C340E7;
        Wed, 23 Feb 2022 15:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645631573;
        bh=cX5ja7eRNo3oh1/1CWircmpXSGRa2hFzD4aytDQ/LK8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J/YG8AApT6Ede6LNOVdifnH/QyTOM2C3sC9ZNxQjPBIqZlIrr1aDSypXCIBo40s7O
         VIkOjfPGe8Wy18HYlPWxFmxAfOQM1wEzSyjSCAZDsL8wbqciMzue9FzvgAxHe9ITUJ
         /jtgor5jHaYSL7P6Nncg/xSfFuCyH16vUR7NA6R6B9TYGWt713w3Et85YK38gyxh3z
         Jr6mEZUyAoDF0QN5dvdo7W1grag2TcwTaXZ992NgdSMOKqFQdO3x23doyNa0SwJJsA
         S5z6M3DrMSJicJF2md4LnhbedMj7Z90CrPPfENN808JBPm7JeqH/I3v7sOERDJDXj5
         SmSrlVnjSDluw==
Date:   Wed, 23 Feb 2022 07:52:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH net] ping: fix the dif and sdif check in ping_lookup
Message-ID: <20220223075251.7d512101@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADvbK_fgrvLNUPiTBOddrUcGFep-XkO4wbp01UXPybg0vXPVzA@mail.gmail.com>
References: <ea03066bc7256ab86df8d3501f3440819305be57.1644988852.git.lucien.xin@gmail.com>
        <20220217075712.6bf6368c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADvbK_fgrvLNUPiTBOddrUcGFep-XkO4wbp01UXPybg0vXPVzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022 14:08:06 +0800 Xin Long wrote:
> On Thu, Feb 17, 2022 at 11:57 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Are you sure this is not reachable from some networking path allowing
> > attacker (or local user) to DoS the kernel logs?  
> Hi, Jakub, sorry for late.
> 
> I actually didn't see how a skb with protocol != IP/IPV6 could reach here.
> ping_err() is using "BUG()" for this kind of case.
> I added this 'else' branch mostly to avoid the possible compiling
> warning for "Use of uninitialized value dif/sdif".

Understood but it's best practice to avoid prints on the datapath.
We should either drop the print completely (given it's impossible)
or make it _once.
