Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D0B27C004
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgI2Itm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:49:42 -0400
Received: from smtpout1.mo529.mail-out.ovh.net ([178.32.125.2]:54083 "EHLO
        smtpout1.mo529.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI2Itm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:49:42 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 04:49:41 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.108.20.149])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 23A735FF0FD9;
        Tue, 29 Sep 2020 10:44:20 +0200 (CEST)
Received: from kaod.org (37.59.142.106) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 29 Sep
 2020 10:44:19 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-106R006a120b7c1-6ccf-49c4-8f3c-c4e193ec0ad7,
                    725C9DACA52B44C04E0B7BA4242CB9DA5DB7567C) smtp.auth=groug@kaod.org
Date:   Tue, 29 Sep 2020 10:44:18 +0200
From:   Greg Kurz <groug@kaod.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, "Laurent Vivier" <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] vhost: Don't call vq_access_ok() when using IOTLB
Message-ID: <20200929104418.7efad38b@bahia.lan>
In-Reply-To: <20200929034358-mutt-send-email-mst@kernel.org>
References: <160129650442.480158.12085353517983890660.stgit@bahia.lan>
        <20200929034358-mutt-send-email-mst@kernel.org>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.106]
X-ClientProxiedBy: DAG3EX2.mxp5.local (172.16.2.22) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 026b43cc-c807-47e9-88a9-2c90f0a77d81
X-Ovh-Tracer-Id: 17573890174354626921
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedrvdekgddtkecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgfgihesthejredtredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepvdefgfdtgeeluddujeejleffgffhhedtieeggffguddvgfekvefgfeettdejheevnecuffhomhgrihhnpehrvgguhhgrthdrtghomhenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepuggrvhhiugesghhisghsohhnrdgurhhophgsvggrrhdrihgurdgruh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 03:45:28 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Sep 28, 2020 at 02:35:04PM +0200, Greg Kurz wrote:
> > When the IOTLB device is enabled, the vring addresses we get from
> > userspace are GIOVAs. It is thus wrong to pass them to vq_access_ok()
> > which only takes HVAs. The IOTLB map is likely empty at this stage,
> > so there isn't much that can be done with these GIOVAs. Access validation
> > will be performed at IOTLB prefetch time anyway.
> > 
> > BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1883084
> > Fixes: 6b1e6cc7855b ("vhost: new device IOTLB API")
> > Cc: jasowang@redhat.com
> > CC: stable@vger.kernel.org # 4.14+
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> > ---
> >  drivers/vhost/vhost.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index b45519ca66a7..6296e33df31d 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -1509,7 +1509,10 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
> >  	 * If it is not, we don't as size might not have been setup.
> >  	 * We will verify when backend is configured. */
> >  	if (vq->private_data) {
> > -		if (!vq_access_ok(vq, vq->num,
> > +		/* If an IOTLB device is present, the vring addresses are
> > +		 * GIOVAs. Access will be validated during IOTLB prefetch. */
> > +		if (!vq->iotlb &&
> > +		    !vq_access_ok(vq, vq->num,
> >  			(void __user *)(unsigned long)a.desc_user_addr,
> >  			(void __user *)(unsigned long)a.avail_user_addr,
> >  			(void __user *)(unsigned long)a.used_user_addr))
> 
> OK I think you are right here.
> 
> Jason, can you ack pls?
> 
> However, I think a cleaner way to check this is by moving
> the following check from vhost_vq_access_ok to vq_access_ok:
> 
>         /* Access validation occurs at prefetch time with IOTLB */
>         if (vq->iotlb)
>                 return true;
> 

Yes I agree. I'll do that in v2.

> 
> > 
> 

