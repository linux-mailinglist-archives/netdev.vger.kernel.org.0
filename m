Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B9F5EE9D4
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 01:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiI1XEN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 19:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiI1XEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 19:04:12 -0400
X-Greylist: delayed 243 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Sep 2022 16:04:12 PDT
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C82F857C8;
        Wed, 28 Sep 2022 16:04:11 -0700 (PDT)
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay09.hostedemail.com (Postfix) with ESMTP id 42F1F810C9;
        Wed, 28 Sep 2022 23:04:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf15.hostedemail.com (Postfix) with ESMTPA id C450B1A;
        Wed, 28 Sep 2022 23:04:01 +0000 (UTC)
Message-ID: <46a600465f08edbda7d413f6dd0b1b1edd57cfa4.camel@perches.com>
Subject: Re: [PATCH 3/7] s390/qeth: Convert snprintf() to scnprintf()
From:   Joe Perches <joe@perches.com>
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>, borntraeger@linux.ibm.com
Cc:     svens@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        agordeev@linux.ibm.com
Date:   Wed, 28 Sep 2022 16:04:07 -0700
In-Reply-To: <cfcc8d22-8efd-8b0b-d24f-cb734f9ef927@linux.ibm.com>
References: <YzHyniCyf+G/2xI8@fedora>
         <5138b5a347b79a5f35b75d0babf5f41dbace879a.camel@perches.com>
         <cfcc8d22-8efd-8b0b-d24f-cb734f9ef927@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Stat-Signature: 77c4p56xgruk3p35i1uacr4yaetb35qj
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: C450B1A
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18eEEanHqR4OnqcwMowgOsKUxuaq/Kzxbo=
X-HE-Tag: 1664406241-228711
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-28 at 10:24 +0200, Alexandra Winter wrote:
> On 27.09.22 16:27, Joe Perches wrote:
> > On Mon, 2022-09-26 at 19:42 +0100, Jules Irenge wrote:
> > > Coccinnelle reports a warning
> > > Warning: Use scnprintf or sprintf
> > > Adding to that, there has been a slow migration from snprintf to scnprintf.
> > > This LWN article explains the rationale for this change
> > > https: //lwn.net/Articles/69419/
> > > Ie. snprintf() returns what *would* be the resulting length,
> > > while scnprintf() returns the actual length.
> > []
> > > diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
> > []
> > > @@ -500,9 +500,9 @@ static ssize_t qeth_hw_trap_show(struct device *dev,
> > >  	struct qeth_card *card = dev_get_drvdata(dev);
> > >  
> > >  	if (card->info.hwtrap)
> > > -		return snprintf(buf, 5, "arm\n");
> > > +		return scnprintf(buf, 5, "arm\n");
> > >  	else
> > > -		return snprintf(buf, 8, "disarm\n");
> > > +		return scnprintf(buf, 8, "disarm\n");
> > >  }
> > 
> > Use sysfs_emit instead.
> > 
> 
> Thank you Joe, that sounds like the best way to handle this. 
> I propose that I take this onto my ToDo list and test it in the s390 environment.
> I will add 
> Reported-by: Jules Irenge <jbi.octave@gmail.com>
> Suggested-by: Joe Perches <joe@perches.com>
> 

Thanks.

btw: I was careless when I wrote one section of the proposed patch.

In this patch block,

@@ -467,28 +478,31 @@ static ssize_t qeth_dev_switch_attrs_show(struct device *dev,

The last line

+	return sysfs_emit_at(buf, len, "\n");

is not correct

It needs to be changed to:

	len += sysfs_emit_at(buf, len, "\n");

	return len;

