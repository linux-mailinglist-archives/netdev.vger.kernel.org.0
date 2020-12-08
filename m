Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70A82D29DF
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 12:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgLHLkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 06:40:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729190AbgLHLkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 06:40:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607427556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mztAL0IbDNTerxOKqrjs7RBlEmfpHYSq6RMdJCS9850=;
        b=X96YciVXFxZ2SmyP+HLTdSkVycnSL926XBc7h53j/RVy5vk1iIBHVXPTiAvvkwnuo1zThp
        a1pctpRlY7QuEShUHqdBHYfriZfSIhQ9WakKOlbRH7n8krRGQT6c/Xs6dfvt/nP7eGEp9R
        tLPuge6Yxfhv48tYgWEKo+Z1i0sDe4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-1dU4fq_MOYe02b5FQc8kiQ-1; Tue, 08 Dec 2020 06:39:14 -0500
X-MC-Unique: 1dU4fq_MOYe02b5FQc8kiQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B5B110054FF;
        Tue,  8 Dec 2020 11:39:12 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3ED335D9DE;
        Tue,  8 Dec 2020 11:39:02 +0000 (UTC)
Date:   Tue, 8 Dec 2020 12:39:01 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, brouer@redhat.com
Subject: Re: [PATCH v4 2/6] igb: take vlan double header into account
Message-ID: <20201208123901.20e87ee5@carbon>
In-Reply-To: <MW3PR11MB45544E9B9B610CC6553F246B9CCD0@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
        <20201111170453.32693-3-sven.auhagen@voleatech.de>
        <DM6PR11MB454615FDFC4E7B71D9B82FA29CF40@DM6PR11MB4546.namprd11.prod.outlook.com>
        <20201201095852.2dc1e8f8@carbon>
        <20201205094213.p64bkcmd3lr4iejl@SvensMacBookAir-2.local>
        <MW3PR11MB45544E9B9B610CC6553F246B9CCD0@MW3PR11MB4554.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 10:52:28 +0000
"Penigalapati, Sandeep" <sandeep.penigalapati@intel.com> wrote:

> On Tue, Dec 01, 2020 at 09:58:52AM +0100, Jesper Dangaard Brouer wrote:
> > > On Tue, 1 Dec 2020 08:23:23 +0000
> > > "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com> wrote:
> > >  
> > > > Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>  
> > >
> > > Very happy that you are testing this.
> > >
> > > Have you also tested that samples/bpf/ xdp_redirect_cpu program works?  
> > 
> > Hi Jesper,
> > 
> > I have tested the xdp routing example but it would be good if someone can
> > double check this.
> > 
> Hi Jesper, Sven
> 
> I have tested xdp_redirect_cpu and it is working.

Thanks this is great to hear.

You have tested with large frames right?  As cpumap just creates SKBs
based on xdp_frame, and send them to the normal network stack (on
remote CPU), you can just to a standard TCP-stream throughput test with
iperf or netperf.  That should hopefully blowup if we screwed up the
boundaries of the two packets sharing the same page.  (In principle we
should verify the content of the TCP transfer, so maybe a scp + md5sum
is a better test).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

