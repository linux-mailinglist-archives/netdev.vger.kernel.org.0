Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E7631D58E
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhBQGw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:52:26 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3373 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbhBQGwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:52:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602cbcf10000>; Tue, 16 Feb 2021 22:51:29 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 17 Feb 2021 06:51:27 +0000
Date:   Wed, 17 Feb 2021 08:51:23 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
CC:     Jason Wang <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lulu@redhat.com>
Subject: Re: [PATCH v1] vdpa/mlx5: Restore the hardware used index after
 change map
Message-ID: <20210217065123.GA128881@mtl-vdi-166.wap.labs.mlnx>
References: <0d592ed0-3cea-cfb0-9b7b-9d2755da3f12@redhat.com>
 <20210208100445.GA173340@mtl-vdi-166.wap.labs.mlnx>
 <379d79ff-c8b4-9acb-1ee4-16573b601973@redhat.com>
 <20210209061232.GC210455@mtl-vdi-166.wap.labs.mlnx>
 <411ff244-a698-a312-333a-4fdbeb3271d1@redhat.com>
 <a90dd931-43cc-e080-5886-064deb972b11@oracle.com>
 <b749313c-3a44-f6b2-f9b8-3aefa2c2d72c@redhat.com>
 <24d383db-e65c-82ff-9948-58ead3fc502b@oracle.com>
 <20210210154531.GA70716@mtl-vdi-166.wap.labs.mlnx>
 <fa78717a-3707-520b-35cb-c8e37503dccf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fa78717a-3707-520b-35cb-c8e37503dccf@oracle.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613544689; bh=gXlU4wj89dRtYqmSRTd3ZCIacCt3jo7TZ0QmF2GeH/w=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=D51MUk6a1LIHjYR7vDnSfWHJ6CpdnAzYmaYM6Tr0hfGJoFfxpOIegOEJIMEskXkZ7
         QF5PTei3v6wIctQtI1+JqYxM792BciA+JNi4F387Pd+/decgsAhTEF/ep6s6m3G1SM
         N4EgF/V5X534ag5JmwlIo0rJzDetHHwSCUtPvGFamTznzpqGW+AApQlsrHt88RGfXT
         i9MUs6F5d5NvYJAs9AfLMEjl0O5snGW5Rusz2cq8sEDkSkg+FcCPbCfV0YEWPkprk1
         fYowVXb4ekOBbJFr5efi/ICTD8EcvpccjhTd29aE/8EAp5qyFhlc7zT5leuUUWd9fe
         Q2qACShDjlaKw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 04:25:20PM -0800, Si-Wei Liu wrote:
> 
> > > The saved mvq->avail_idx will be used to recreate hardware virtq object and
> > > the used index in create_virtqueue(), once status DRIVER_OK is set. I
> > > suspect we should pass the index to mvq->used_idx in
> > > mlx5_vdpa_set_vq_state() below instead.
> > > 
> > Right, that's what I am checking but still no final conclusions. I need
> > to harness hardware guy to provide me with clear answers.
> OK. Could you update what you find from the hardware guy and let us know
> e.g. if the current firmware interface would suffice?
> 

Te answer I got is that upon query_virtqueue, the hardware available and
used indices should always return the same value for virtqueues that
complete in order - that's the case for network virtqueues. The value
returned is the consumer index of the hardware. These values should be
provided when creating a virtqueue; in case of attaching to an existing
virtqueue (e.g. after suspend and resume), the values can be non zero.

Currently there's a bug in the firmware where for RX virtqueue, the
value returned for the available index is wrong. However, the value
returned for used index is the correct value.

Therefore, we need to return the hardware used index in get_vq_state()
and restore this value into both the new object's available and used
indices.
