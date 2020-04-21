Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D7E1B1AA2
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 02:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDUAZQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Apr 2020 20:25:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:44342 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbgDUAZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 20:25:16 -0400
IronPort-SDR: oUqXf3CXBinsfEsHhCkMRI5+cw0AjhlwKS/Ju0F/JNCb5jiOKaNDLTrbL4F6rZz11Pd5yGjRo6
 dtvZUM3T19zQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 17:25:15 -0700
IronPort-SDR: pb/c/km1ZTyldQgQT7ao+gvNKotDmZk3D2WqsR3wVfrALa/l1XRN4v1Xf0q4pdTJRBpTNVZP71
 JqEWMidXDMTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="255112021"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga003.jf.intel.com with ESMTP; 20 Apr 2020 17:25:15 -0700
Received: from fmsmsx122.amr.corp.intel.com (10.18.125.37) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 17:25:15 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 fmsmsx122.amr.corp.intel.com ([169.254.5.179]) with mapi id 14.03.0439.000;
 Mon, 20 Apr 2020 17:25:14 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [RFC PATCH v5 04/16] RDMA/irdma: Add HMC backing store setup
 functions
Thread-Topic: [RFC PATCH v5 04/16] RDMA/irdma: Add HMC backing store setup
 functions
Thread-Index: AQHWFNtwja2EMaM5GkuTEHgi3g50gKh+NimAgAQP44A=
Date:   Tue, 21 Apr 2020 00:25:14 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD48573@fmsmsx124.amr.corp.intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-5-jeffrey.t.kirsher@intel.com>
 <20200417201749.GF3083@unreal>
In-Reply-To: <20200417201749.GF3083@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC PATCH v5 04/16] RDMA/irdma: Add HMC backing store setup
> functions
> 
> On Fri, Apr 17, 2020 at 10:12:39AM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > HW uses host memory as a backing store for a number of protocol
> > context objects and queue state tracking.
> > The Host Memory Cache (HMC) is a component responsible for managing
> > these objects stored in host memory.
> >
> > Add the functions and data structures to manage the allocation of
> > backing pages used by the HMC for the various objects
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
[....]

> > diff --git a/drivers/infiniband/hw/irdma/hmc.h
> > b/drivers/infiniband/hw/irdma/hmc.h
> > new file mode 100644
> > index 000000000000..6f3fbf61f048
> > --- /dev/null
> > +++ b/drivers/infiniband/hw/irdma/hmc.h
> > @@ -0,0 +1,217 @@
> > +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> > +/* Copyright (c) 2015 - 2019 Intel Corporation */ #ifndef IRDMA_HMC_H
> > +#define IRDMA_HMC_H
> > +
> > +#include "defs.h"
> > +
> > +#define IRDMA_HMC_MAX_BP_COUNT			512
> > +#define IRDMA_MAX_SD_ENTRIES			11
> > +#define IRDMA_HW_DBG_HMC_INVALID_BP_MARK	0xca
> > +#define IRDMA_HMC_INFO_SIGNATURE		0x484d5347
> > +#define IRDMA_HMC_PD_CNT_IN_SD			512
> > +#define IRDMA_HMC_DIRECT_BP_SIZE		0x200000
> > +#define IRDMA_HMC_MAX_SD_COUNT			8192
> > +#define IRDMA_HMC_PAGED_BP_SIZE			4096
> > +#define IRDMA_HMC_PD_BP_BUF_ALIGNMENT		4096
> > +#define IRDMA_FIRST_VF_FPM_ID			8
> > +#define FPM_MULTIPLIER				1024
> > +
> > +#define IRDMA_INC_SD_REFCNT(sd_table)	((sd_table)->ref_cnt++)
> > +#define IRDMA_INC_PD_REFCNT(pd_table)	((pd_table)->ref_cnt++)
> > +#define IRDMA_INC_BP_REFCNT(bp)		((bp)->ref_cnt++)
> > +
> > +#define IRDMA_DEC_SD_REFCNT(sd_table)	((sd_table)->ref_cnt--)
> > +#define IRDMA_DEC_PD_REFCNT(pd_table)	((pd_table)->ref_cnt--)
> > +#define IRDMA_DEC_BP_REFCNT(bp)		((bp)->ref_cnt--)
> 
> It is bad for two reasons, first you obfuscated simple ++/-- and second you called
> it refcnt, while we have special type for that.
>

Agreed on all fronts. Will fix.
