Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71D5481443
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 15:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240440AbhL2Oyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 09:54:33 -0500
Received: from riva6.ni.fr.eu.org ([163.172.103.116]:46910 "EHLO
        riva6.ni.fr.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbhL2Oy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 09:54:27 -0500
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Dec 2021 09:54:27 EST
Received: by riva6.ni.fr.eu.org (Postfix, from userid 1000)
        id 7B98520019; Wed, 29 Dec 2021 15:45:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ni.fr.eu.org;
        s=riva6-20210311; t=1640789147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aCq0FYQNYvN2lRDdZ/eTN1s6JWA47rQFTJjimL6/WZg=;
        b=EHn1/ctEeZGagzjKkFyT4I0wOIF4kilopaP3FW6DpBxAcPLRFNRGqWtDOVQOVLYrEsLjmv
        FsGBY4eTB745v+FhgcJ4JykwzqSuMDHkUbrdeo9GydVi+otVkNw4PDWv2zsWq87U8GUgZ5
        QPFPkQz3QEX6JANXSo2VTWx57SX4pelesztvWrr2RZuZsTZA+NE1oeQrp6q/fBFzBM+jk9
        V1+enLruhPM9lecR5G3eoucZsFB0EuobD4kNU0SWn9uPWFnIZkeUQE8Sl/Sr8ZAHP4S8V3
        VUtSK48M08GwcLvPuUtWAmh805+VOY5bSrGUj4srpX5RvHa4WmSp/Qw3TfmY/g==
Date:   Wed, 29 Dec 2021 15:45:47 +0100
From:   Nicolas Schodet <nico@ni.fr.eu.org>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
Message-ID: <Ycx0mwQcFsmVqWVH@ni.fr.eu.org>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-13-miquel.raynal@bootlin.com>
 <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

* Alexander Aring <alex.aring@gmail.com> [2021-12-29 09:30]:
> Hi,
> On Wed, 22 Dec 2021 at 10:58, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> ...
> > +{
> > +       bool promiscuous_on = mac802154_check_promiscuous(local);
> > +       int ret;
> > +
> > +       if ((state && promiscuous_on) || (!state && !promiscuous_on))
> > +               return 0;
> > +
> > +       ret = drv_set_promiscuous_mode(local, state);
> > +       if (ret)
> > +               pr_err("Failed to %s promiscuous mode for SW scanning",
> > +                      state ? "set" : "reset");
> The semantic of promiscuous mode on the driver layer is to turn off
> ack response, address filtering and crc checking. Some transceivers
> don't allow a more fine tuning on what to enable/disable. I think we
> should at least do the checksum checking per software then?
> Sure there is a possible tune up for more "powerful" transceivers then...

In this case, the driver could change the (flags &
IEEE802154_HW_RX_DROP_BAD_CKSUM) bit dynamically to signal it does not
check the checksum anymore. Would it work?

Nicolas.
