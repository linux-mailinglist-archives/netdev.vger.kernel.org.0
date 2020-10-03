Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0165E282284
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJCIiy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 3 Oct 2020 04:38:54 -0400
Received: from smtpout1.mo529.mail-out.ovh.net ([178.32.125.2]:38213 "EHLO
        smtpout1.mo529.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgJCIiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:38:54 -0400
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.76])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 4BA3C6197B53;
        Sat,  3 Oct 2020 10:38:50 +0200 (CEST)
Received: from kaod.org (37.59.142.103) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Sat, 3 Oct 2020
 10:38:49 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-103G005e6880fe4-ca63-4cea-b120-8e938ba0c296,
                    3345FDB4B62F999A850A9D5BF875A94D2EA020F3) smtp.auth=groug@kaod.org
Date:   Sat, 3 Oct 2020 10:38:48 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <qemu-devel@nongnu.org>,
        Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 2/2] vhost: Don't call log_access_ok() when using
 IOTLB
Message-ID: <20201003103848.766c7442@bahia.lan>
In-Reply-To: <d9dae1ed-49a4-909a-6840-ae46a4ffdffc@redhat.com>
References: <160139701999.162128.2399875915342200263.stgit@bahia.lan>
        <160139704424.162128.7839027287942194310.stgit@bahia.lan>
        <d9dae1ed-49a4-909a-6840-ae46a4ffdffc@redhat.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [37.59.142.103]
X-ClientProxiedBy: DAG1EX2.mxp5.local (172.16.2.2) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 7085d870-f704-48ed-abc4-e9fdc74ba25a
X-Ovh-Tracer-Id: 4078572412553632108
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedrfeekgddthecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgfgihesthhqredtredtjeenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepveelhfdtudffhfeiveehhfelgeellefgteffteekudegheejfffghefhfeeuudffnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutdefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopegurghvihgusehgihgsshhonhdrughrohhpsggvrghrrdhiugdrrghu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 3 Oct 2020 09:58:59 +0800
Jason Wang <jasowang@redhat.com> wrote:

> 
> On 2020/9/30 上午12:30, Greg Kurz wrote:
> > When the IOTLB device is enabled, the log_guest_addr that is passed by
> > userspace to the VHOST_SET_VRING_ADDR ioctl, and which is then written
> > to vq->log_addr, is a GIOVA. All writes to this address are translated
> > by log_user() to writes to an HVA, and then ultimately logged through
> > the corresponding GPAs in log_write_hva(). No logging will ever occur
> > with vq->log_addr in this case. It is thus wrong to pass vq->log_addr
> > and log_guest_addr to log_access_vq() which assumes they are actual
> > GPAs.
> >
> > Introduce a new vq_log_used_access_ok() helper that only checks accesses
> > to the log for the used structure when there isn't an IOTLB device around.
> >
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> > ---
> >   drivers/vhost/vhost.c |   23 +++++++++++++++++++----
> >   1 file changed, 19 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index c3b49975dc28..5996e32fa818 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -1370,6 +1370,20 @@ bool vhost_log_access_ok(struct vhost_dev *dev)
> >   }
> >   EXPORT_SYMBOL_GPL(vhost_log_access_ok);
> >   
> > +static bool vq_log_used_access_ok(struct vhost_virtqueue *vq,
> > +				  void __user *log_base,
> > +				  bool log_used,
> > +				  u64 log_addr,
> > +				  size_t log_size)
> > +{
> > +	/* If an IOTLB device is present, log_addr is a GIOVA that
> > +	 * will never be logged by log_used(). */
> > +	if (vq->iotlb)
> > +		return true;
> > +
> > +	return !log_used || log_access_ok(log_base, log_addr, log_size);
> > +}
> > +
> >   /* Verify access for write logging. */
> >   /* Caller should have vq mutex and device mutex */
> >   static bool vq_log_access_ok(struct vhost_virtqueue *vq,
> > @@ -1377,8 +1391,8 @@ static bool vq_log_access_ok(struct vhost_virtqueue *vq,
> >   {
> >   	return vq_memory_access_ok(log_base, vq->umem,
> >   				   vhost_has_feature(vq, VHOST_F_LOG_ALL)) &&
> > -		(!vq->log_used || log_access_ok(log_base, vq->log_addr,
> > -				  vhost_get_used_size(vq, vq->num)));
> > +		vq_log_used_access_ok(vq, log_base, vq->log_used, vq->log_addr,
> > +				      vhost_get_used_size(vq, vq->num));
> >   }
> >   
> >   /* Can we start vq? */
> > @@ -1517,8 +1531,9 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
> >   			return -EINVAL;
> >   
> >   		/* Also validate log access for used ring if enabled. */
> > -		if ((a.flags & (0x1 << VHOST_VRING_F_LOG)) &&
> > -			!log_access_ok(vq->log_base, a.log_guest_addr,
> > +		if (!vq_log_used_access_ok(vq, vq->log_base,
> > +				a.flags & (0x1 << VHOST_VRING_F_LOG),
> > +				a.log_guest_addr,
> >   				sizeof *vq->used +
> >   				vq->num * sizeof *vq->used->ring))
> 
> 
> It looks to me that we should use vhost_get_used_size() which takes 
> event into account.
> 
> Any reason that we can't reuse vq_log_access_ok() here?
> 

No reason indeed but I'll fix this in a preliminary patch, and
send a v2 shortly.

Cheers,

--
Greg

> Thanks
> 
> 
> >   			return -EINVAL;
> >
> >
> 

