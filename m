Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6FC665CD1
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjAKNlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239360AbjAKNkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:40:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C8165EC
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3viKEJtoefuCzIsw4cj9a/tqnAHW97AlqTJ7QgbsSHc=; b=UBbhISvsahglFEuh2j/Fgw4W2l
        Vc+BNKRXMSbN+HVzlSB8oLEC6xiI1EIydH5LWn9z4Vn1Ttk0DVgpXarg1+WVCl2nLXSrn2DgSMYL8
        OfUaQjgYHlI+m1N3cSjiOyINlHe/SZjjBSHkwCOj9f3cAkRH5Qo7W3Za1p+dcmgzZmHg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pFbJi-001mQ1-H9; Wed, 11 Jan 2023 14:38:58 +0100
Date:   Wed, 11 Jan 2023 14:38:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Enable PTP receive for
 mv88e6390
Message-ID: <Y7678lFYTzDFc27j@lunn.ch>
References: <20230111080417.147231-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111080417.147231-1-kurt@linutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 09:04:17AM +0100, Kurt Kanzenbach wrote:
> The switch receives management traffic such as STP and LLDP. However, PTP
> messages are not received, only transmitted.
> 
> Ideally, the switch would trap all PTP messages to the management CPU. This
> particular switch has a PTP block which identifies PTP messages and traps them
> to a dedicated port. There is a register to program this destination. This is
> not used at the moment.
> 
> Therefore, program it to the same port as the MGMT traffic is trapped to. This
> allows to receive PTP messages as soon as timestamping is enabled.
> 
> In addition, the datasheet mentions that this register is not valid e.g. for
> 6190 variants. So, add a new cpu port method for 6390 which programs the MGTM
> and PTP destination.

The mv88e6190x_ops and ops mv88e6190_ops structure does not have a
ptp_ops member. So these two devices do not support PTP.

I think it would be cleaner to implement setting the PTP MGMT port as
part of the ptp_ops. Maybe add a new op, which is called from
mv88e6xxx_ptp_setup() if set?

	Andrew
