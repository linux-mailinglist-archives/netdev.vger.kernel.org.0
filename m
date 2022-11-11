Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD8D625AAF
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 13:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbiKKMry convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Nov 2022 07:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbiKKMrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 07:47:52 -0500
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30E27BE70;
        Fri, 11 Nov 2022 04:47:51 -0800 (PST)
Received: from omf17.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay07.hostedemail.com (Postfix) with ESMTP id 18DC916090C;
        Fri, 11 Nov 2022 12:47:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf17.hostedemail.com (Postfix) with ESMTPA id D79DC17;
        Fri, 11 Nov 2022 12:46:57 +0000 (UTC)
Message-ID: <180a55b046e4659609cdfeea4fd979edab17f0c9.camel@perches.com>
Subject: Re: [PATCH net-next] net: dcb: move getapptrust to separate function
From:   Joe Perches <joe@perches.com>
To:     Daniel.Machon@microchip.com, petrm@nvidia.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, vladimir.oltean@nxp.com,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        lkp@intel.com
Date:   Fri, 11 Nov 2022 04:47:45 -0800
In-Reply-To: <Y23x/PSlybLqaQIS@DEN-LT-70577>
References: <20221110094623.3395670-1-daniel.machon@microchip.com>
         <87eduaoj8g.fsf@nvidia.com> <Y23x/PSlybLqaQIS@DEN-LT-70577>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Stat-Signature: 45hxah8w8oa9dxxcp8jqf88drre3n5n8
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: D79DC17
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+8PuF79mfpcN5vujTedb2OxrBxQBlz5eY=
X-HE-Tag: 1668170817-134891
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-11 at 06:45 +0000, Daniel.Machon@microchip.com wrote:
> Den Thu, Nov 10, 2022 at 05:30:43PM +0100 skrev Petr Machata:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > Daniel Machon <daniel.machon@microchip.com> writes:
> > 
> > > diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> > > index cec0632f96db..3f4d88c1ec78 100644
> > > --- a/net/dcb/dcbnl.c
> > > +++ b/net/dcb/dcbnl.c
> > > @@ -1060,11 +1060,52 @@ static int dcbnl_build_peer_app(struct net_device *netdev, struct sk_buff* skb,
> > >       return err;
> > >  }
> > > 
> > > +static int dcbnl_getapptrust(struct net_device *netdev, struct sk_buff *skb)
> > > +{
> > > +     const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
> > > +     int nselectors, err;
> > > +     u8 *selectors;
> > > +
> > > +     selectors = kzalloc(IEEE_8021QAZ_APP_SEL_MAX + 1, GFP_KERNEL);
> > > +     if (!selectors)
> > > +             return -ENOMEM;
> > > +
> > > +     err = ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
> > > +
> > > +     if (!err) {
> > > +             struct nlattr *apptrust;
> > > +             int i;
> > 
> > (Maybe consider moving these up to the function scope. This scope
> > business made sense in the generic function, IMHO is not as useful with
> > a focused function like this one.)
> 
> I dont mind doing that, however, this 'scope business' is just staying true
> to the rest of the dcbnl code :-) - that said, I think I agree with your
> point.
> 
> > 
> > > +
> > > +             err = -EMSGSIZE;
> > > +
> > > +             apptrust = nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_TABLE);
> > > +             if (!apptrust)
> > > +                     goto nla_put_failure;
> > > +
> > > +             for (i = 0; i < nselectors; i++) {
> > > +                     enum ieee_attrs_app type =
> > > +                             dcbnl_app_attr_type_get(selectors[i]);
> > 
> > Doesn't checkpatch warn about this? There should be a blank line after
> > the variable declaration block. (Even if there wasn't one there in the
> > original code either.)
> 
> Nope, no warning. And I think it has something to do with the way the line
> is split.

yup.

And style trivia:

I suggest adding error types after specific errors,
reversing the test and unindenting the code too. 

Something like:

	err = ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
	if (err) {
		err = 0;
		goto out;
	}

	apptrust = nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_TABLE);
	if (!apptrust) {
		err = -EMSGSIZE;
		goto out;
	}

	for (i = 0; i < nselectors; i++) {
		enum ieee_attrs_app type = dcbnl_app_attr_type_get(selectors[i]);
		err = nla_put_u8(skb, type, selectors[i]);
		if (err) {
			nla_nest_cancel(skb, apptrust);
			goto out;
		}
	}
	nla_nest_end(skb, apptrust);

	err = 0;

out:
	kfree(selectors);
	return err;
}

