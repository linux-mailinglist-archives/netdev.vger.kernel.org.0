Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5FFD7286
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 11:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbfJOJvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 05:51:35 -0400
Received: from smtp1.goneo.de ([85.220.129.30]:45392 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbfJOJve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 05:51:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.goneo.de (Postfix) with ESMTP id 85B6D23F4B8;
        Tue, 15 Oct 2019 11:51:30 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.074
X-Spam-Level: 
X-Spam-Status: No, score=-3.074 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.174, BAYES_00=-1.9] autolearn=ham
Received: from smtp1.goneo.de ([127.0.0.1])
        by localhost (smtp1.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sBGS03dGLi35; Tue, 15 Oct 2019 11:51:29 +0200 (CEST)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp1.goneo.de (Postfix) with ESMTPSA id 7CE9423F856;
        Tue, 15 Oct 2019 11:51:28 +0200 (CEST)
Date:   Tue, 15 Oct 2019 11:51:24 +0200
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jilayne Lovejoy <opensource@jilayne.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steve Winslow <swinslow@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Johan Hovold <johan@kernel.org>,
        "open list:NFC SUBSYSTEM" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH v9 4/7] nfc: pn533: Split pn533 init & nfc_register
Message-ID: <20191015095124.GA17778@lem-wkst-02.lemonage>
References: <20191008140544.17112-1-poeschel@lemonage.de>
 <20191008140544.17112-5-poeschel@lemonage.de>
 <20191009174023.528c278b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009174023.528c278b@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 05:40:23PM -0700, Jakub Kicinski wrote:
> On Tue,  8 Oct 2019 16:05:41 +0200, Lars Poeschel wrote:
> > There is a problem in the initialisation and setup of the pn533: It
> > registers with nfc too early. It could happen, that it finished
> > registering with nfc and someone starts using it. But setup of the pn533
> > is not yet finished. Bad or at least unintended things could happen.
> > So I split out nfc registering (and unregistering) to seperate functions
> > that have to be called late in probe then.
> > 
> > Cc: Johan Hovold <johan@kernel.org>
> > Cc: Claudiu Beznea <Claudiu.Beznea@microchip.com>
> > Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> 
> > diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
> > index 1abd40398a5a..e9e5a1ec8857 100644
> > --- a/drivers/nfc/pn533/i2c.c
> > +++ b/drivers/nfc/pn533/i2c.c
> > @@ -193,12 +193,10 @@ static int pn533_i2c_probe(struct i2c_client *client,
> >  	phy->i2c_dev = client;
> >  	i2c_set_clientdata(client, phy);
> >  
> > -	priv = pn533_register_device(PN533_DEVICE_PN532,
> > -				     PN533_NO_TYPE_B_PROTOCOLS,
> > +	priv = pn53x_common_init(PN533_DEVICE_PN532,
> >  				     PN533_PROTO_REQ_ACK_RESP,
> >  				     phy, &i2c_phy_ops, NULL,
> > -				     &phy->i2c_dev->dev,
> > -				     &client->dev);
> > +				     &phy->i2c_dev->dev);
> 
> nit: start of continuation lines should match the opening parenthesis,
>      please run checkpatch and fix the style issue

Ok, I will change that.

> >  	if (IS_ERR(priv)) {
> >  		r = PTR_ERR(priv);
> > @@ -220,13 +218,17 @@ static int pn533_i2c_probe(struct i2c_client *client,
> >  	if (r)
> >  		goto fn_setup_err;
> >  
> > -	return 0;
> > +	r = pn53x_register_nfc(priv, PN533_NO_TYPE_B_PROTOCOLS, &client->dev);
> > +	if (r)
> > +		goto fn_setup_err;
> > +
> > +	return r;
> >  
> >  fn_setup_err:
> >  	free_irq(client->irq, phy);
> >  
> >  irq_rqst_err:
> > -	pn533_unregister_device(phy->priv);
> > +	pn53x_common_clean(phy->priv);
> >  
> >  	return r;
> >  }
> > @@ -239,7 +241,8 @@ static int pn533_i2c_remove(struct i2c_client *client)
> >  
> >  	free_irq(client->irq, phy);
> >  
> > -	pn533_unregister_device(phy->priv);
> > +	pn53x_unregister_nfc(phy->priv);
> > +	pn53x_common_clean(phy->priv);
> >  
> >  	return 0;
> >  }
> > diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
> > index 64836c727aee..e5d5e4c83a04 100644
> > --- a/drivers/nfc/pn533/pn533.c
> > +++ b/drivers/nfc/pn533/pn533.c
> > @@ -2590,14 +2590,12 @@ int pn533_finalize_setup(struct pn533 *dev)
> >  }
> >  EXPORT_SYMBOL_GPL(pn533_finalize_setup);
> >  
> > -struct pn533 *pn533_register_device(u32 device_type,
> > -				u32 protocols,
> > +struct pn533 *pn53x_common_init(u32 device_type,
> >  				enum pn533_protocol_type protocol_type,
> >  				void *phy,
> >  				struct pn533_phy_ops *phy_ops,
> >  				struct pn533_frame_ops *fops,
> > -				struct device *dev,
> > -				struct device *parent)
> > +				struct device *dev)
> >  {
> >  	struct pn533 *priv;
> >  	int rc = -ENOMEM;
> > @@ -2638,43 +2636,18 @@ struct pn533 *pn533_register_device(u32 device_type,
> >  	skb_queue_head_init(&priv->fragment_skb);
> >  
> >  	INIT_LIST_HEAD(&priv->cmd_queue);
> > -
> > -	priv->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols,
> > -					   priv->ops->tx_header_len +
> > -					   PN533_CMD_DATAEXCH_HEAD_LEN,
> > -					   priv->ops->tx_tail_len);
> > -	if (!priv->nfc_dev) {
> > -		rc = -ENOMEM;
> > -		goto destroy_wq;
> > -	}
> > -
> > -	nfc_set_parent_dev(priv->nfc_dev, parent);
> > -	nfc_set_drvdata(priv->nfc_dev, priv);
> > -
> > -	rc = nfc_register_device(priv->nfc_dev);
> > -	if (rc)
> > -		goto free_nfc_dev;
> 
> Aren't you moving too much out of here? Looking at commit 32ecc75ded72
> ("NFC: pn533: change order operations in dev registation") it seems like
> IRQ handler may want to access the data structures, do this change not
> reintroduce the problem?

Yes, you are right, there could be a problem if an irq gets served
before the driver is registered to the nfc subsystem.
Well, but the purpose of this patch is exactly that: Prevent use of nfc
subsystem before the chip is fully initialized.
To address this, I would not change the part above, but move the
request_threaded_irq to the very bottom in pn533_i2c_probe, after the
call to pn53x_register_nfc. So it is not possible to use nfc before the
chip is initialized and irqs don't get served before the driver is
registered to nfc subsystem.
Thank you for this!
I will include this in v10 of the patchset.

> >  	return priv;
> >  
> > -free_nfc_dev:
> > -	nfc_free_device(priv->nfc_dev);
> > -
> > -destroy_wq:
> > -	destroy_workqueue(priv->wq);
> >  error:
> >  	kfree(priv);
> >  	return ERR_PTR(rc);
> >  }
> > -EXPORT_SYMBOL_GPL(pn533_register_device);
> > +EXPORT_SYMBOL_GPL(pn53x_common_init);
> >  
> > -void pn533_unregister_device(struct pn533 *priv)
> > +void pn53x_common_clean(struct pn533 *priv)
> >  {
> >  	struct pn533_cmd *cmd, *n;
> >  
> > -	nfc_unregister_device(priv->nfc_dev);
> > -	nfc_free_device(priv->nfc_dev);
> > -
> >  	flush_delayed_work(&priv->poll_work);
> >  	destroy_workqueue(priv->wq);
> >  
> 
