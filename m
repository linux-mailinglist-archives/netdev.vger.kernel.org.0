Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA77828AFEF
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgJLIRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:17:42 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19011 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgJLIRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:17:42 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8410eb0001>; Mon, 12 Oct 2020 01:16:43 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 08:17:29 +0000
Date:   Mon, 12 Oct 2020 11:17:25 +0300
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
Message-ID: <20201012081725.GB42327@mtl-vdi-166.wap.labs.mlnx>
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-11-jasowang@redhat.com>
 <20201001132927.GC32363@mtl-vdi-166.wap.labs.mlnx>
 <70af3ff0-74ed-e519-56f5-d61e6a48767f@redhat.com>
 <20201012065931.GA42327@mtl-vdi-166.wap.labs.mlnx>
 <b1ac150b-0845-874f-75d0-7440133a1d41@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b1ac150b-0845-874f-75d0-7440133a1d41@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602490603; bh=Kg9ecYgsKq8hj5s7dMs7IKjshYentJJrrOYixBkDd+g=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=q2D7izcFRuCz8XdUQF8ATaarITInVRF7zWozqgfHXXGVRHcT/oRcJVQl4k7Z0KLwY
         DIOYlsCOHiEsnMM9z+CoLIbgdlFG2EU1kXqItA/5xetkRrfQqELTWtld0zm1O+yjHv
         ycVB8C/mFGz3+hJe56udPw86gqBx4J4KLPBiTS5sUUJbZa6FiV1vfN2vXxJLofRDk7
         peUKbW0d4p3dB0DT2jJ9E6loyvejEAxy+XWWB+LNP7nzR7z/IkzcI8o5Emr48i/XJw
         tgxraQMDzAXV+F+lA6HmawnE4vTKA71DheAf73aDdOgKbdekd3p37xworK7+lvy9K3
         r4dXPDjS3/A2A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 03:45:10PM +0800, Jason Wang wrote:
> > > 
> > So in theory we can have several asid's (for different virtqueues), each
> > one should be followed by a specific set_map call. If this is so, how do
> > I know if I met all the conditions run my driver? Maybe we need another
> > callback to let the driver know it should not expect more set_maps().
> 
> 
> This should work similarly as in the past. Two parts of the work is expected
> to be done by the driver:
> 
> 1) store the mapping somewhere (e.g hardware) during set_map()
> 2) associating mapping with a specific virtqueue
> 
> The only difference is that more than one mapping is used now.

ok, so like today, I will always get DRIVER_OK after I got all the
set_maps(), right?

> 
> For the issue of more set_maps(), driver should be always ready for the new
> set_maps() call instead of not expecting new set_maps() since guest memory
> topology could be changed due to several reasons.
> 
> Qemu or vhost-vDPA will try their best to avoid the frequency of set_maps()
> for better performance (e.g through batched IOTLB updating). E.g there
> should be at most one set_map() during one time of guest booting.
> 
> 
> > 
> 
