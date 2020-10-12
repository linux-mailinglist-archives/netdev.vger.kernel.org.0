Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82AA28AEA2
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 08:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgJLG7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 02:59:46 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2324 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgJLG7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 02:59:46 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f83fed50000>; Sun, 11 Oct 2020 23:59:33 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 06:59:35 +0000
Date:   Mon, 12 Oct 2020 09:59:31 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rob.miller@broadcom.com>, <lingshan.zhu@intel.com>,
        <eperezma@redhat.com>, <hanand@xilinx.com>,
        <mhabets@solarflare.com>, <amorenoz@redhat.com>,
        <maxime.coquelin@redhat.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>
Subject: Re: [RFC PATCH 10/24] vdpa: introduce config operations for
 associating ASID to a virtqueue group
Message-ID: <20201012065931.GA42327@mtl-vdi-166.wap.labs.mlnx>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-11-jasowang@redhat.com>
 <20201001132927.GC32363@mtl-vdi-166.wap.labs.mlnx>
 <70af3ff0-74ed-e519-56f5-d61e6a48767f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <70af3ff0-74ed-e519-56f5-d61e6a48767f@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602485973; bh=oLIM5KrFZSg7XdPKgA7O+c2YZdk02ihQGMxzwd+FBp0=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=j7POww5YzB1PZDV3EX1CXFYBvDpPFgva/ygZpG1yE7PKz6g+ZJtDp12l3sJ6ctI1E
         z2Zd4UjvIlDIgKuSb+OJBBsTneb2OO3PO0mEw0pl5atWLRgN6LxWswrKlOmsSNwv1W
         iKT/EgMNscVmaGXZpw8FJPhISMVx8h1EuTYJByZQFdhYyg37n2B0mmcAA8W7Qvi2hd
         ddAFj+2pk3q71sD8rAIc3mTYdoaQOOZe2j6CFc0uLBdjrEX7iTtuJVjuxja5T73K/L
         eFrbNtKJd1A0tuBxGAUU6mXdRV8XWUmIe/tuXzEpdLEqA6WAWZrHG9ke61Dtnd5/m1
         Ph5+bwqt+PcVg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 11:56:45AM +0800, Jason Wang wrote:
>=20
> On 2020/10/1 =E4=B8=8B=E5=8D=889:29, Eli Cohen wrote:
> > On Thu, Sep 24, 2020 at 11:21:11AM +0800, Jason Wang wrote:
> > > This patch introduces a new bus operation to allow the vDPA bus drive=
r
> > > to associate an ASID to a virtqueue group.
> > >=20
> > So in case of virtio_net, I would expect that all the data virtqueues
> > will be associated with the same address space identifier.
>=20
>=20
> Right.
>=20
> I will add the codes to do this in the next version. It should be more
> explicit than have this assumption by default.
>=20
>=20
> > Moreover,
> > this assignment should be provided before the set_map call that provide=
s
> > the iotlb for the address space, correct?
>=20
>=20
> I think it's better not have this limitation, note that set_map() now tak=
es
> a asid argument.
>=20
> So for hardware if the associated as is changed, the driver needs to prog=
ram
> the hardware to switch to the new mapping.
>=20
> Does this work for mlx5?
>=20

So in theory we can have several asid's (for different virtqueues), each
one should be followed by a specific set_map call. If this is so, how do
I know if I met all the conditions run my driver? Maybe we need another
callback to let the driver know it should not expect more set_maps().
