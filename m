Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05FF599097
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240046AbiHRWfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiHRWfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:35:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0336BD1D8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5FHCrsQWn+Oo15cL7KtAssu55xmWtK2XJJsD7uuDqkU=; b=hOwc9PRFEoIXbSPD16HtpGaFYe
        KkVp4VN/kPKtCW7hJuHOLuS0oaB5jmAEz5ZsgNyi3eIZ3tlne5hAYAEufGHI4scAi2XH6Wl5aNAuO
        r7JVQbt2MjriLW+da0OVRiw29IBe4GaG0fVvuIElQUZpwtndHW0T8bXFkKttewshK/kw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOo6V-00Dqva-JR; Fri, 19 Aug 2022 00:35:07 +0200
Date:   Fri, 19 Aug 2022 00:35:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH net-next 00/10] Use robust notifiers in DSA
Message-ID: <Yv6+m7T4HqYnYoDm@lunn.ch>
References: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
 <Yv6z5HTyenpJ+pex@lunn.ch>
 <20220818222850.mskqhmzpvz2ooamv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818222850.mskqhmzpvz2ooamv@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 01:28:50AM +0300, Vladimir Oltean wrote:
> On Thu, Aug 18, 2022 at 11:49:24PM +0200, Andrew Lunn wrote:
> > I would split it into two classes of errors:
> > 
> > Bus transactions fail. This very likely means the hardware design is
> > bad, connectors are loose, etc. There is not much we can do about
> > this, bad things are going to happen no what.
> > 
> > We have consumed all of some sort of resource. Out of memory, the ATU
> > is full, too many LAGs, etc. We try to roll back in order to get out
> > of this resource problem.
> > 
> > So i would say -EIO, -ETIMEDOUT, we don't care about too
> > much. -ENOMEM, -ENOBUF, -EOPNOTSUPP or whatever, we should try to do a
> > robust rollback.
> > 
> > The original design of switchdev was two phase:
> > 
> > 1) Allocate whatever resources are needed, can fail
> > 2) Put those resources into use, must not fail
> > 
> > At some point that all got thrown away.
> 
> So you think that rollback at the cross-chip notifier layer is a new
> problem we need to tackle, because we don't have enough transactional
> layering in the code?

No, i don't think it is a new problem, but it might help explain why
you don't feel quite right about it. Some errors we simply don't care
about because we cannot do anything about it. Other errors we should
try to rollback, and hence need robust notifiers for those errors.

    Andrew

