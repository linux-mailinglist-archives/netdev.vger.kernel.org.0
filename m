Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6467128A21B
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388973AbgJJWy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730799AbgJJTOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:14:06 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09ABWpXx113152
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 07:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=in-reply-to : subject :
 from : to : cc : date : mime-version : references :
 content-transfer-encoding : content-type : message-id; s=pp1;
 bh=NiDLo4pOxkTOHNh379y2lMt59tGJeK9BGhibE+AHe30=;
 b=fFl+sWZ60CJNW5vj7Uw0QdIFBZaJLDIK+TmFY7+uXdPQEExbAUVKU05YhKg5dS5u6J9M
 gRTcbWK1ehAiHgiW0QiEErv4vh+5MOV1iJMmz3AgZqVrCWi+Nh1nNGlGLl5qNxYu9TT3
 rsErWvzJTnT/TvD/yGmIkQ5cIJnW2dxyfP5KEerqQF50430xLTdRCdzrzGOBj/IVBjpb
 ZIGntFQpbgC01amsKXwfy1cB65UwCiqnbdgLT6Z6Qd+CSe7yV4n3BXy+qSd8xdiYdQTK
 an7SA2yY6csjDSnstIEkYdPhg6mYvKJGwGGY1NoLkcuzdqKyvDxx/5UGYpv3tzPn6Oq9 ZA== 
Received: from smtp.notes.na.collabserv.com (smtp.notes.na.collabserv.com [192.155.248.91])
        by mx0a-001b2d01.pphosted.com with ESMTP id 343b0wh7jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 07:36:56 -0400
Received: from localhost
        by smtp.notes.na.collabserv.com with smtp.notes.na.collabserv.com ESMTP
        for <netdev@vger.kernel.org> from <BMT@zurich.ibm.com>;
        Sat, 10 Oct 2020 11:36:55 -0000
Received: from us1a3-smtp05.a3.dal06.isc4sb.com (10.146.71.159)
        by smtp.notes.na.collabserv.com (10.106.227.143) with smtp.notes.na.collabserv.com ESMTP;
        Sat, 10 Oct 2020 11:36:50 -0000
Received: from us1a3-mail162.a3.dal06.isc4sb.com ([10.146.71.4])
          by us1a3-smtp05.a3.dal06.isc4sb.com
          with ESMTP id 2020101011364991-175970 ;
          Sat, 10 Oct 2020 11:36:49 +0000 
In-Reply-To: <20201009195033.3208459-11-ira.weiny@intel.com>
Subject: Re: [PATCH RFC PKS/PMEM 10/58] drivers/rdma: Utilize new kmap_thread()
From:   "Bernard Metzler" <BMT@zurich.ibm.com>
To:     ira.weiny@intel.com
Cc:     "Andrew Morton" <akpm@linux-foundation.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Mike Marciniszyn" <mike.marciniszyn@intel.com>,
        "Dennis Dalessandro" <dennis.dalessandro@intel.com>,
        "Doug Ledford" <dledford@redhat.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        "Faisal Latif" <faisal.latif@intel.com>,
        "Shiraz Saleem" <shiraz.saleem@intel.com>, x86@kernel.org,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Fenghua Yu" <fenghua.yu@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kexec@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-efi@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-um@lists.infradead.org, linux-ntfs-dev@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, cluster-devel@redhat.com,
        ecryptfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-rdma@vger.kernel.org, amd-gfx@lists.freed.esktop.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        drbd-dev@tron.linbit.com, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-cachefs@redhat.com,
        samba-technical@lists.samba.org, intel-wired-lan@lists.osuosl.org
Date:   Sat, 10 Oct 2020 11:36:49 +0000
MIME-Version: 1.0
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <20201009195033.3208459-11-ira.weiny@intel.com>,<20201009195033.3208459-1-ira.weiny@intel.com>
X-Mailer: IBM iNotes ($HaikuForm 1054.1) | IBM Domino Build
 SCN1812108_20180501T0841_FP65 April 15, 2020 at 09:48
X-LLNOutbound: False
X-Disclaimed: 59823
X-TNEFEvaluated: 1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
x-cbid: 20101011-2475-0000-0000-0000044A0339
X-IBM-SpamModules-Scores: BY=0.233045; FL=0; FP=0; FZ=0; HX=0; KW=0; PH=0;
 SC=0.421684; ST=0; TS=0; UL=0; ISC=; MB=0.000000
X-IBM-SpamModules-Versions: BY=3.00013982; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000295; SDB=6.01447073; UDB=6.00777937; IPR=6.01229775;
 MB=3.00034472; MTD=3.00000008; XFM=3.00000015; UTC=2020-10-10 11:36:54
X-IBM-AV-DETECTION: SAVI=unsuspicious REMOTE=unsuspicious XFE=unused
X-IBM-AV-VERSION: SAVI=2020-10-10 06:57:40 - 6.00011937
x-cbparentid: 20101011-2476-0000-0000-0000DAA5035B
Message-Id: <OF849D92D8.F4735ECA-ON002585FD.003F5F27-002585FD.003FCBD6@notes.na.collabserv.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-10_07:2020-10-09,2020-10-10 signatures=0
X-Proofpoint-Spam-Reason: orgsafe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----ira.weiny@intel.com wrote: -----

>To: "Andrew Morton" <akpm@linux-foundation.org>, "Thomas Gleixner"
><tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
>Petkov" <bp@alien8.de>, "Andy Lutomirski" <luto@kernel.org>, "Peter
>Zijlstra" <peterz@infradead.org>
>From: ira.weiny@intel.com
>Date: 10/09/2020 09:52PM
>Cc: "Ira Weiny" <ira.weiny@intel.com>, "Mike Marciniszyn"
><mike.marciniszyn@intel.com>, "Dennis Dalessandro"
><dennis.dalessandro@intel.com>, "Doug Ledford" <dledford@redhat.com>,
>"Jason Gunthorpe" <jgg@ziepe.ca>, "Faisal Latif"
><faisal.latif@intel.com>, "Shiraz Saleem" <shiraz.saleem@intel.com>,
>"Bernard Metzler" <bmt@zurich.ibm.com>, x86@kernel.org, "Dave Hansen"
><dave.hansen@linux.intel.com>, "Dan Williams"
><dan.j.williams@intel.com>, "Fenghua Yu" <fenghua.yu@intel.com>,
>linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
>linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org,
>linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
>linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
>netdev@vger.kernel.org, bpf@vger.kernel.org,
>kexec@lists.infradead.org, linux-bcache@vger.kernel.org,
>linux-mtd@lists.infradead.org, devel@driverdev.osuosl.org,
>linux-efi@vger.kernel.org, linux-mmc@vger.kernel.org,
>linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
>linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
>linux-ext4@vger.kernel.org, linux-aio@kvack.org,
>io-uring@vger.kernel.org, linux-erofs@lists.ozlabs.org,
>linux-um@lists.infradead.org, linux-ntfs-dev@lists.sourceforge.net,
>reiserfs-devel@vger.kernel.org,
>linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
>cluster-devel@redhat.com, ecryptfs@vger.kernel.org,
>linux-cifs@vger.kernel.org, linux-btrfs@vger.kernel.org,
>linux-afs@lists.infradead.org, linux-rdma@vger.kernel.org,
>amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
>intel-gfx@lists.freedesktop.org, drbd-dev@tron.linbit.com,
>linux-block@vger.kernel.org, xen-devel@lists.xenproject.org,
>linux-cachefs@redhat.com, samba-technical@lists.samba.org,
>intel-wired-lan@lists.osuosl.org
>Subject: [EXTERNAL] [PATCH RFC PKS/PMEM 10/58] drivers/rdma: Utilize
>new kmap=5Fthread()
>
>From: Ira Weiny <ira.weiny@intel.com>
>
>The kmap() calls in these drivers are localized to a single thread.
>To
>avoid the over head of global PKRS updates use the new kmap=5Fthread()
>call.
>
>Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
>Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
>Cc: Doug Ledford <dledford@redhat.com>
>Cc: Jason Gunthorpe <jgg@ziepe.ca>
>Cc: Faisal Latif <faisal.latif@intel.com>
>Cc: Shiraz Saleem <shiraz.saleem@intel.com>
>Cc: Bernard Metzler <bmt@zurich.ibm.com>
>Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>---
> drivers/infiniband/hw/hfi1/sdma.c      |  4 ++--
> drivers/infiniband/hw/i40iw/i40iw=5Fcm.c | 10 +++++-----
> drivers/infiniband/sw/siw/siw=5Fqp=5Ftx.c  | 14 +++++++-------
> 3 files changed, 14 insertions(+), 14 deletions(-)
>
>diff --git a/drivers/infiniband/hw/hfi1/sdma.c
>b/drivers/infiniband/hw/hfi1/sdma.c
>index 04575c9afd61..09d206e3229a 100644
>--- a/drivers/infiniband/hw/hfi1/sdma.c
>+++ b/drivers/infiniband/hw/hfi1/sdma.c
>@@ -3130,7 +3130,7 @@ int ext=5Fcoal=5Fsdma=5Ftx=5Fdescs(struct hfi1=5Fdev=
data
>*dd, struct sdma=5Ftxreq *tx,
> 		}
>=20
> 		if (type =3D=3D SDMA=5FMAP=5FPAGE) {
>-			kvaddr =3D kmap(page);
>+			kvaddr =3D kmap=5Fthread(page);
> 			kvaddr +=3D offset;
> 		} else if (WARN=5FON(!kvaddr)) {
> 			=5F=5Fsdma=5Ftxclean(dd, tx);
>@@ -3140,7 +3140,7 @@ int ext=5Fcoal=5Fsdma=5Ftx=5Fdescs(struct hfi1=5Fdev=
data
>*dd, struct sdma=5Ftxreq *tx,
> 		memcpy(tx->coalesce=5Fbuf + tx->coalesce=5Fidx, kvaddr, len);
> 		tx->coalesce=5Fidx +=3D len;
> 		if (type =3D=3D SDMA=5FMAP=5FPAGE)
>-			kunmap(page);
>+			kunmap=5Fthread(page);
>=20
> 		/* If there is more data, return */
> 		if (tx->tlen - tx->coalesce=5Fidx)
>diff --git a/drivers/infiniband/hw/i40iw/i40iw=5Fcm.c
>b/drivers/infiniband/hw/i40iw/i40iw=5Fcm.c
>index a3b95805c154..122d7a5642a1 100644
>--- a/drivers/infiniband/hw/i40iw/i40iw=5Fcm.c
>+++ b/drivers/infiniband/hw/i40iw/i40iw=5Fcm.c
>@@ -3721,7 +3721,7 @@ int i40iw=5Faccept(struct iw=5Fcm=5Fid *cm=5Fid, str=
uct
>iw=5Fcm=5Fconn=5Fparam *conn=5Fparam)
> 		ibmr->device =3D iwpd->ibpd.device;
> 		iwqp->lsmm=5Fmr =3D ibmr;
> 		if (iwqp->page)
>-			iwqp->sc=5Fqp.qp=5Fuk.sq=5Fbase =3D kmap(iwqp->page);
>+			iwqp->sc=5Fqp.qp=5Fuk.sq=5Fbase =3D kmap=5Fthread(iwqp->page);
> 		dev->iw=5Fpriv=5Fqp=5Fops->qp=5Fsend=5Flsmm(&iwqp->sc=5Fqp,
> 							iwqp->ietf=5Fmem.va,
> 							(accept.size + conn=5Fparam->private=5Fdata=5Flen),
>@@ -3729,12 +3729,12 @@ int i40iw=5Faccept(struct iw=5Fcm=5Fid *cm=5Fid,
>struct iw=5Fcm=5Fconn=5Fparam *conn=5Fparam)
>=20
> 	} else {
> 		if (iwqp->page)
>-			iwqp->sc=5Fqp.qp=5Fuk.sq=5Fbase =3D kmap(iwqp->page);
>+			iwqp->sc=5Fqp.qp=5Fuk.sq=5Fbase =3D kmap=5Fthread(iwqp->page);
> 		dev->iw=5Fpriv=5Fqp=5Fops->qp=5Fsend=5Flsmm(&iwqp->sc=5Fqp, NULL, 0, 0);
> 	}
>=20
> 	if (iwqp->page)
>-		kunmap(iwqp->page);
>+		kunmap=5Fthread(iwqp->page);
>=20
> 	iwqp->cm=5Fid =3D cm=5Fid;
> 	cm=5Fnode->cm=5Fid =3D cm=5Fid;
>@@ -4102,10 +4102,10 @@ static void i40iw=5Fcm=5Fevent=5Fconnected(struct
>i40iw=5Fcm=5Fevent *event)
> 	i40iw=5Fcm=5Finit=5Ftsa=5Fconn(iwqp, cm=5Fnode);
> 	read0 =3D (cm=5Fnode->send=5Frdma0=5Fop =3D=3D SEND=5FRDMA=5FREAD=5FZERO=
);
> 	if (iwqp->page)
>-		iwqp->sc=5Fqp.qp=5Fuk.sq=5Fbase =3D kmap(iwqp->page);
>+		iwqp->sc=5Fqp.qp=5Fuk.sq=5Fbase =3D kmap=5Fthread(iwqp->page);
> 	dev->iw=5Fpriv=5Fqp=5Fops->qp=5Fsend=5Frtt(&iwqp->sc=5Fqp, read0);
> 	if (iwqp->page)
>-		kunmap(iwqp->page);
>+		kunmap=5Fthread(iwqp->page);
>=20
> 	memset(&attr, 0, sizeof(attr));
> 	attr.qp=5Fstate =3D IB=5FQPS=5FRTS;
>diff --git a/drivers/infiniband/sw/siw/siw=5Fqp=5Ftx.c
>b/drivers/infiniband/sw/siw/siw=5Fqp=5Ftx.c
>index d19d8325588b..4ed37c328d02 100644
>--- a/drivers/infiniband/sw/siw/siw=5Fqp=5Ftx.c
>+++ b/drivers/infiniband/sw/siw/siw=5Fqp=5Ftx.c
>@@ -76,7 +76,7 @@ static int siw=5Ftry=5F1seg(struct siw=5Fiwarp=5Ftx *c=
=5Ftx,
>void *paddr)
> 			if (unlikely(!p))
> 				return -EFAULT;
>=20
>-			buffer =3D kmap(p);
>+			buffer =3D kmap=5Fthread(p);
>=20
> 			if (likely(PAGE=5FSIZE - off >=3D bytes)) {
> 				memcpy(paddr, buffer + off, bytes);
>@@ -84,7 +84,7 @@ static int siw=5Ftry=5F1seg(struct siw=5Fiwarp=5Ftx *c=
=5Ftx,
>void *paddr)
> 				unsigned long part =3D bytes - (PAGE=5FSIZE - off);
>=20
> 				memcpy(paddr, buffer + off, part);
>-				kunmap(p);
>+				kunmap=5Fthread(p);
>=20
> 				if (!mem->is=5Fpbl)
> 					p =3D siw=5Fget=5Fupage(mem->umem,
>@@ -96,10 +96,10 @@ static int siw=5Ftry=5F1seg(struct siw=5Fiwarp=5Ftx
>*c=5Ftx, void *paddr)
> 				if (unlikely(!p))
> 					return -EFAULT;
>=20
>-				buffer =3D kmap(p);
>+				buffer =3D kmap=5Fthread(p);
> 				memcpy(paddr + part, buffer, bytes - part);
> 			}
>-			kunmap(p);
>+			kunmap=5Fthread(p);
> 		}
> 	}
> 	return (int)bytes;
>@@ -505,7 +505,7 @@ static int siw=5Ftx=5Fhdt(struct siw=5Fiwarp=5Ftx *c=
=5Ftx,
>struct socket *s)
> 				page=5Farray[seg] =3D p;
>=20
> 				if (!c=5Ftx->use=5Fsendpage) {
>-					iov[seg].iov=5Fbase =3D kmap(p) + fp=5Foff;
>+					iov[seg].iov=5Fbase =3D kmap=5Fthread(p) + fp=5Foff;

This misses a corresponding kunmap=5Fthread() in siw=5Funmap=5Fpages()
(pls change line 403 in siw=5Fqp=5Ftx.c as well)

Thanks,
Bernard.

> 					iov[seg].iov=5Flen =3D plen;
>=20
> 					/* Remember for later kunmap() */
>@@ -518,9 +518,9 @@ static int siw=5Ftx=5Fhdt(struct siw=5Fiwarp=5Ftx *c=
=5Ftx,
>struct socket *s)
> 							plen);
> 				} else if (do=5Fcrc) {
> 					crypto=5Fshash=5Fupdate(c=5Ftx->mpa=5Fcrc=5Fhd,
>-							    kmap(p) + fp=5Foff,
>+							    kmap=5Fthread(p) + fp=5Foff,
> 							    plen);
>-					kunmap(p);
>+					kunmap=5Fthread(p);
> 				}
> 			} else {
> 				u64 va =3D sge->laddr + sge=5Foff;
>--=20
>2.28.0.rc0.12.gb6a658bd00c9
>
>

