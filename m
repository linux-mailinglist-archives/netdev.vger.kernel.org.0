Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4259624A
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbfHTOTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:19:48 -0400
Received: from smtp3.goneo.de ([85.220.129.37]:58500 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729853AbfHTOTs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 10:19:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id 9210923FA45;
        Tue, 20 Aug 2019 16:19:44 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.042
X-Spam-Level: 
X-Spam-Status: No, score=-3.042 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.142, BAYES_00=-1.9] autolearn=ham
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ej-nB74Ns0XQ; Tue, 20 Aug 2019 16:19:43 +0200 (CEST)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp3.goneo.de (Postfix) with ESMTPSA id 8ABEA23F9DE;
        Tue, 20 Aug 2019 16:19:42 +0200 (CEST)
Date:   Tue, 20 Aug 2019 16:32:41 +0200
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Johan Hovold <johan@kernel.org>
Cc:     Allison Randal <allison@lohutok.net>,
        Steve Winslow <swinslow@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:NFC SUBSYSTEM" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 6/7] nfc: pn533: Add autopoll capability
Message-ID: <20190820143240.GA11301@lem-wkst-02.lemonage>
References: <20190820120345.22593-1-poeschel@lemonage.de>
 <20190820120345.22593-6-poeschel@lemonage.de>
 <20190820122344.GK32300@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820122344.GK32300@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 02:23:44PM +0200, Johan Hovold wrote:
> On Tue, Aug 20, 2019 at 02:03:43PM +0200, Lars Poeschel wrote:

> >  drivers/nfc/pn533/pn533.c | 193 +++++++++++++++++++++++++++++++++++++-
> >  drivers/nfc/pn533/pn533.h |  10 +-
> >  2 files changed, 197 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
> > index a8c756caa678..7e915239222b 100644
> > --- a/drivers/nfc/pn533/pn533.c
> > +++ b/drivers/nfc/pn533/pn533.c
> > @@ -185,6 +185,32 @@ struct pn533_cmd_jump_dep_response {
> >  	u8 gt[];
> >  } __packed;
> >  
> > +struct pn532_autopoll_resp {
> > +	u8 type;
> > +	u8 ln;
> > +	u8 tg;
> > +	u8 tgdata[];
> > +} __packed;
> 
> No need for __packed.

I did a quick test without the __packed and indeed: It worked. I'd
sworn that it is needed in this place, because this autopoll response is
data that the nfc chip puts on the serial wire without padding inbetween
and this struct is used to access this data and without the __packed the
compiler should be allowed to put padding bytes between the struct
fields. But it choose to not do it. I am still not shure, why this
happens, but ok. I can remove the __packed.

> > +static int pn533_autopoll_complete(struct pn533 *dev, void *arg,
> > +			       struct sk_buff *resp)
> > +{
> > +	u8 nbtg;
> > +	int rc;
> > +	struct pn532_autopoll_resp *apr;
> > +	struct nfc_target nfc_tgt;
> > +
> > +	if (IS_ERR(resp)) {
> > +		rc = PTR_ERR(resp);
> > +
> > +		nfc_err(dev->dev, "%s  autopoll complete error %d\n",
> > +			__func__, rc);
> > +
> > +		if (rc == -ENOENT) {
> > +			if (dev->poll_mod_count != 0)
> > +				return rc;
> > +			goto stop_poll;
> > +		} else if (rc < 0) {
> > +			nfc_err(dev->dev,
> > +				"Error %d when running autopoll\n", rc);
> > +			goto stop_poll;
> > +		}
> > +	}
> > +
> > +	nbtg = resp->data[0];
> > +	if ((nbtg > 2) || (nbtg <= 0))
> > +		return -EAGAIN;
> > +
> > +	apr = (struct pn532_autopoll_resp *)&resp->data[1];
> > +	while (nbtg--) {
> > +		memset(&nfc_tgt, 0, sizeof(struct nfc_target));
> > +		switch (apr->type) {
> > +		case PN532_AUTOPOLL_TYPE_ISOA:
> > +			dev_dbg(dev->dev, "ISOA");
> 
> You forgot the '\n' here and elsewhere (some nfc_err as well).

I can add them. I will wait a bit for more review comments before
posting a new patchset.

Thanks so far for your quick review,
Lars
