Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CB04ED7FF
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 12:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbiCaKx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 06:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbiCaKxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 06:53:24 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3F51C9446
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 03:51:36 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id F2FE3300002D0;
        Thu, 31 Mar 2022 12:51:34 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id E8623137F8; Thu, 31 Mar 2022 12:51:34 +0200 (CEST)
Date:   Thu, 31 Mar 2022 12:51:34 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: ordering of check in phy_state_machine() since
 06edf1a940be0633499e2feea31d380375a22bd9
Message-ID: <20220331105134.GA7711@wunner.de>
References: <fbaafccd-60ee-1c29-a014-ec50661f58eb@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbaafccd-60ee-1c29-a014-ec50661f58eb@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 12:33:30PM +0200, Oliver Neukum wrote:
> looking at this I wonder whether the check isn't too late.
> Do you really want to restart autonegotiation although
> you know that the device is gone?

Ignoring PHY_CABLETEST for a moment, needs_aneg is only set to
true if state is PHY_UP, i.e. the netdev was just opened.

If the USB adapter is unplugged at that moment, the expectation
is that phy_start_aneg() returns -ENODEV, so we bail out of
phy_state_machine().

Commit 06edf1a940be looks fine to me.

Thanks,

Lukas
