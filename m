Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4B55982FF
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 14:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244590AbiHRMQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 08:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244575AbiHRMQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 08:16:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8600BB2749
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 05:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=svR+yoOPSrSXWAW1XY+GCBqGqHc0nqWTSo5LsA7HB+I=; b=IKxGJO/bQNPqGYXPmFdsNkvaa6
        QGsS8UsO6g9MBP7P1y1UgW3KGzgdL4NlW/nzBs2MNUKkHPeEYdpMkc3EgA1w1qiqf7ioaC1cFioYk
        KeFraGZ0klqYvFSqUShhtUF5QkAR/I91kyVXH5Sfmn4z4UoixqIcMRZST51KuR8xuaPs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOeR1-00DjsL-Sn; Thu, 18 Aug 2022 14:15:39 +0200
Date:   Thu, 18 Aug 2022 14:15:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Feiyang Chen <chris.chenfeiyang@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        Feiyang Chen <chenfeiyang@loongson.cn>, zhangqing@loongson.cn,
        Huacai Chen <chenhuacai@loongson.cn>, netdev@vger.kernel.org,
        loongarch@lists.linux.dev
Subject: Re: [PATCH v2 1/2] stmmac: Expose module parameters
Message-ID: <Yv4ta5tsYmv6WLx9@lunn.ch>
References: <cover.1660720671.git.chenfeiyang@loongson.cn>
 <5bf66e7d30d909cdaad46557d800d33118404e4d.1660720671.git.chenfeiyang@loongson.cn>
 <20220817200549.392b5891@kernel.org>
 <CACWXhKkJGO5PV8kBurR5Urf7XAiDKgX3b6epn0SPMkZdBH6iUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACWXhKkJGO5PV8kBurR5Urf7XAiDKgX3b6epn0SPMkZdBH6iUA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 02:41:11PM +0800, Feiyang Chen wrote:
> On Thu, 18 Aug 2022 at 11:05, Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed, 17 Aug 2022 15:29:18 +0800 chris.chenfeiyang@gmail.com wrote:
> > > Expose module parameters so that we can use them in specific device
> > > configurations. Add the 'stmmac_' prefix for them to avoid conflicts.
> > >
> > > Meanwhile, there was a 'buf_sz' local variable in stmmac_rx() with the
> > > same name as the global variable, and now we can distinguish them.
> >
> > Can you provide more information on the 'why'?
> 
> Hi, Jakub,
> 
> We would like to be able to change these properties when configuring
> the device data. For example, Loongson GMAC does not support Flow
> Control feature, and exposing these parameters allows us to ensure
> that flow control is off in the Loongson GMAC device.

Two comments:

One patch should do one thing, with a commit message which explains why.

The MAC needs to tell phylib about what it can do in terms of
pause. The MAC would normally call phy_set_sym_pause(phydev, False, False) and then
the PHY will not auto-get any pause, and as a result, the MAC will never to asked
to enable any sort of flow control.

   Andrew
