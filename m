Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC938F858
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 03:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfHPBKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 21:10:38 -0400
Received: from correo.us.es ([193.147.175.20]:40820 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbfHPBKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 21:10:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8DD29C4145
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 03:10:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7CCFED2CAD
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 03:10:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 727A4DA4CA; Fri, 16 Aug 2019 03:10:35 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28DD8DA7B6;
        Fri, 16 Aug 2019 03:10:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 16 Aug 2019 03:10:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 086B34265A2F;
        Fri, 16 Aug 2019 03:10:32 +0200 (CEST)
Date:   Fri, 16 Aug 2019 03:10:33 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v4 07/12] net: sched: use flow block API
Message-ID: <20190816011033.sw34b3ckfd636afg@salvia>
References: <20190709205550.3160-1-pablo@netfilter.org>
 <20190709205550.3160-8-pablo@netfilter.org>
 <b45709c7-38b5-2dcb-3db1-0c2fca1840be@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b45709c7-38b5-2dcb-3db1-0c2fca1840be@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 05:32:34PM +0100, Edward Cree wrote:
> On 09/07/2019 21:55, Pablo Neira Ayuso wrote:
> > This patch adds tcf_block_setup() which uses the flow block API.
> >
> > This infrastructure takes the flow block callbacks coming from the
> > driver and register/unregister to/from the cls_api core.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > <snip>
> > @@ -796,13 +804,20 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
> >  				 struct netlink_ext_ack *extack)
> >  {
> >  	struct tc_block_offload bo = {};
> > +	int err;
> >  
> >  	bo.net = dev_net(dev);
> >  	bo.command = command;
> >  	bo.binder_type = ei->binder_type;
> >  	bo.block = block;
> >  	bo.extack = extack;
> > -	return dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
> > +	INIT_LIST_HEAD(&bo.cb_list);
> > +
> > +	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	return tcf_block_setup(block, &bo);
> >  }
> >  
> >  static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
> > @@ -1636,6 +1651,77 @@ void tcf_block_cb_unregister(struct tcf_block *block,
> >  }
> >  EXPORT_SYMBOL(tcf_block_cb_unregister);
> >  
> > +static int tcf_block_bind(struct tcf_block *block,
> > +			  struct flow_block_offload *bo)
> > +{
> > +	struct flow_block_cb *block_cb, *next;
> > +	int err, i = 0;
> > +
> > +	list_for_each_entry(block_cb, &bo->cb_list, list) {
> > +		err = tcf_block_playback_offloads(block, block_cb->cb,
> > +						  block_cb->cb_priv, true,
> > +						  tcf_block_offload_in_use(block),
> > +						  bo->extack);
> > +		if (err)
> > +			goto err_unroll;
> > +
> > +		i++;
> > +	}
> > +	list_splice(&bo->cb_list, &block->cb_list);
> > +
> > +	return 0;
> > +
> > +err_unroll:
> > +	list_for_each_entry_safe(block_cb, next, &bo->cb_list, list) {
> > +		if (i-- > 0) {
> > +			list_del(&block_cb->list);
> > +			tcf_block_playback_offloads(block, block_cb->cb,
> > +						    block_cb->cb_priv, false,
> > +						    tcf_block_offload_in_use(block),
> > +						    NULL);
> > +		}
> > +		flow_block_cb_free(block_cb);
> > +	}
> > +
> > +	return err;
> > +}
> >
> Why has the replay been moved from the function called by the driver
>  (__tcf_block_cb_register()) to work done by the driver's caller based on
>  what the driver has left on this flow_block_offload.cb_list?  This makes
>  it impossible for the driver to (say) unregister a block outside of an
>  explicit request from ndo_setup_tc().
> In my under-development driver, I have a teardown path called on PCI
>  remove, which calls tcf_block_cb_unregister() on all my block bindings
>  (of which the driver keeps track), to ensure that no flow rules are still
>  in place when unregister_netdev() is called;

It's the subsystem that has to release resources when
unregister_netdev() event happens. At least in netfilter, when the
device is going away, the filtering policy is removed, hence the
FLOW_BLOCK_UNBIND is called to release the blocks and, hence, the
offload resources. I remember tc ingress qdisc works like this too.

>  this is needed because some  of the driver's state for certain
>  rules involves taking a reference on  the netdevice (dev_hold()). 
>  Your structural changes here make that  impossible; is there any
>  reason why they're necessary?

May I have access to your driver code?

This would make it easier for me to understand your requirements, and
to discuss changes with you.
