Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C9EE489B
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 12:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438529AbfJYKcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 06:32:47 -0400
Received: from relay-b01.edpnet.be ([212.71.1.221]:35618 "EHLO
        relay-b01.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438055AbfJYKcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 06:32:47 -0400
X-ASG-Debug-ID: 1571999564-0a7ff54e9618dbad0001-BZBGGp
Received: from zotac.vandijck-laurijssen.be (77.109.77.221.wls.msr91gen3.adsl.dyn.edpnet.net [77.109.77.221]) by relay-b01.edpnet.be with ESMTP id CeI4JD5S3ixiZEfx; Fri, 25 Oct 2019 12:32:44 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: 77.109.77.221.wls.msr91gen3.adsl.dyn.edpnet.net[77.109.77.221]
X-Barracuda-Apparent-Source-IP: 77.109.77.221
Received: from x1.vandijck-laurijssen.be (74.250-240-81.adsl-static.isp.belgacom.be [81.240.250.74])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id 5587EAA6DC8;
        Fri, 25 Oct 2019 12:32:43 +0200 (CEST)
Date:   Fri, 25 Oct 2019 12:32:42 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, wg@grandegger.com, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1] j1939: transport: make sure EOMA is send with the
 total message size set
Message-ID: <20191025103242.GA2031@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: [PATCH v1] j1939: transport: make sure EOMA is send with the
 total message size set
Mail-Followup-To: Oleksij Rempel <o.rempel@pengutronix.de>,
        mkl@pengutronix.de, wg@grandegger.com, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
References: <20191025093015.24506-1-o.rempel@pengutronix.de>
 <20191025093626.snrkgseuuyjejvbv@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191025093626.snrkgseuuyjejvbv@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: 77.109.77.221.wls.msr91gen3.adsl.dyn.edpnet.net[77.109.77.221]
X-Barracuda-Start-Time: 1571999564
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1031
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.7223 1.0000 1.5425
X-Barracuda-Spam-Score: 1.54
X-Barracuda-Spam-Status: No, SCORE=1.54 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.77578
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On vr, 25 okt 2019 11:36:26 +0200, Oleksij Rempel wrote:
> Hi all,
> 
> i decided to be strict here and drop malformed EOMA packages. At least
> it makes testing easier.
> I have no idea how far is it from reality. Will it brake some thing?
> 
> 
> On Fri, Oct 25, 2019 at 11:30:15AM +0200, Oleksij Rempel wrote:
> > We was sending malformed EOMA with total message size set to 0. So, fix this
> > bug and add sanity check to the RX path.
> > 
...
> > +	if (session->total_message_size != len) {
> > +		netdev_warn(session->priv->ndev, "%s: 0x%p: Incorrect size. Expected: %i; got: %i.\n",
> > +			    __func__, session, session->total_message_size,
> > +			    len);

A warning is usefull here, maybe rate-limited.

> > +		return;

But returning an otherwise complete transfer is rough.
I'm sure verifying this at this stage is unusual.
I'm sure there are little controllers out there that fail here.

Be tolerant on the input and strict on the output, isn't it?

Kind regards,
Kurt 
> > +	}
> > +
