Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2BD764BD
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 13:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfGZLoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 07:44:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:44498 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbfGZLoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 07:44:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 04:44:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,310,1559545200"; 
   d="scan'208";a="194229033"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.145])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jul 2019 04:44:17 -0700
Received: from andy by smile with local (Exim 4.92)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1hqye0-0001LZ-85; Fri, 26 Jul 2019 14:44:16 +0300
Date:   Fri, 26 Jul 2019 14:44:16 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Sedat Dilek <sedat.dilek@credativ.de>
Cc:     =?iso-8859-1?Q?Cl=E9ment?= Perrochaud 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [PATCH v3 01/14] NFC: fix attrs checks in netlink interface
Message-ID: <20190726114416.GS9224@smile.fi.intel.com>
References: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
 <1208463309.1019.1564131262506@ox.credativ.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1208463309.1019.1564131262506@ox.credativ.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 10:54:22AM +0200, Sedat Dilek wrote:
> [ Please CC me I am not subscribed to this ML ]
> 
> Hi Andy,
> 
> unfortunately, I did not found a cover-letter on netdev mailing-list.
> So, I am answering here.
> 
> What are the changes v2->v3?

I combined my 11 patches with 1 from syzkaller team and 2 from you.
That's only the change for the series.

Administratively I resent it to have updated Cc list.

> Again, unfortunately I throw away all v2 out of my local linux Git repository.
> So, I could have looked at the diff myself.

It should be no changes in the code.

> 
> Thanks for v3 upgrade!
> 
> Regards,
> - Sedat -
> 
> [1] https://marc.info/?a=131071969100005&r=1&w=2
> 
> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> hat am 25. Juli 2019 21:34 geschrieben:
> > 
> >  
> > From: Andrey Konovalov <andreyknvl@google.com>
> > 
> > nfc_genl_deactivate_target() relies on the NFC_ATTR_TARGET_INDEX
> > attribute being present, but doesn't check whether it is actually
> > provided by the user. Same goes for nfc_genl_fw_download() and
> > NFC_ATTR_FIRMWARE_NAME.
> > 
> > This patch adds appropriate checks.
> > 
> > Found with syzkaller.
> > 
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  net/nfc/netlink.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
> > index 4a30309bb67f..60fd2748d0ea 100644
> > --- a/net/nfc/netlink.c
> > +++ b/net/nfc/netlink.c
> > @@ -970,7 +970,8 @@ static int nfc_genl_dep_link_down(struct sk_buff *skb, struct genl_info *info)
> >  	int rc;
> >  	u32 idx;
> >  
> > -	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
> > +	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
> > +	    !info->attrs[NFC_ATTR_TARGET_INDEX])
> >  		return -EINVAL;
> >  
> >  	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
> > @@ -1018,7 +1019,8 @@ static int nfc_genl_llc_get_params(struct sk_buff *skb, struct genl_info *info)
> >  	struct sk_buff *msg = NULL;
> >  	u32 idx;
> >  
> > -	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
> > +	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
> > +	    !info->attrs[NFC_ATTR_FIRMWARE_NAME])
> >  		return -EINVAL;
> >  
> >  	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
> > -- 
> > 2.20.1
> 
> 
> -- 
> Mit freundlichen Grüssen 
> Sedat Dilek
> Telefon: +49 2166 9901-153 
> E-Mail: sedat.dilek@credativ.de 
> Internet: https://www.credativ.de/
> 
> GPG-Fingerprint: EA6D E17D D269 AC7E 101D C910 476F 2B3B 0AF7 F86B
> 
> credativ GmbH, Trompeterallee 108, 41189 Mönchengladbach 
> Handelsregister: Amtsgericht Mönchengladbach HRB 12080 USt-ID-Nummer DE204566209 
> Geschäftsführung: Dr. Michael Meskes, Jörg Folz, Sascha Heuer
> 
> Unser Umgang mit personenbezogenen Daten unterliegt folgenden Bestimmungen: 
> https://www.credativ.de/datenschutz/

-- 
With Best Regards,
Andy Shevchenko


