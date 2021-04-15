Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5353610B4
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbhDORDt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 15 Apr 2021 13:03:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:14000 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233330AbhDORDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 13:03:48 -0400
IronPort-SDR: PcYns0WQfnFbFiWZrgfKFrr3bmkh3TGds4zPSoPoU1N+fpKgfN1GhbowSk5FmjWw+3Fw4U2V5U
 jPbMvJOC+EqQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="194922922"
X-IronPort-AV: E=Sophos;i="5.82,225,1613462400"; 
   d="scan'208";a="194922922"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 10:03:25 -0700
IronPort-SDR: 0O3hpZUoCD7ILMmrUZqCfglcld9JUCU/ALEHV6eEwjrMHRUyrkE8jZoQNXWlvoE01P8zzgfYB+
 mfpoTxeFzS/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,225,1613462400"; 
   d="scan'208";a="399634878"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga002.jf.intel.com with ESMTP; 15 Apr 2021 10:03:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 15 Apr 2021 10:03:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 15 Apr 2021 10:03:23 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2106.013;
 Thu, 15 Apr 2021 10:03:23 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
Subject: RE: [PATCH net-next 05/15] ice: replace custom AIM algorithm with
 kernel's DIM library
Thread-Topic: [PATCH net-next 05/15] ice: replace custom AIM algorithm with
 kernel's DIM library
Thread-Index: AQHXMY5BI/rh9Tbt7kiRCvsX8EL4AKq2QBqA//+OSFA=
Date:   Thu, 15 Apr 2021 17:03:23 +0000
Message-ID: <a5c5405dbaad4bcc8b291c266ad34a39@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
        <20210415003013.19717-6-anthony.l.nguyen@intel.com>
 <20210415094651.06041834@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210415094651.06041834@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, April 15, 2021 9:47 AM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; Keller, Jacob E <jacob.e.keller@intel.com>;
> netdev@vger.kernel.org; sassmann@redhat.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Brelinski, TonyX <tonyx.brelinski@intel.com>
> Subject: Re: [PATCH net-next 05/15] ice: replace custom AIM algorithm with
> kernel's DIM library
> 
> On Wed, 14 Apr 2021 17:30:03 -0700 Tony Nguyen wrote:
> > +static void ice_tx_dim_work(struct work_struct *work)
> > +{
> > +	struct ice_ring_container *rc;
> > +	struct ice_q_vector *q_vector;
> > +	struct dim *dim;
> > +	u16 itr, intrl;
> > +
> > +	dim = container_of(work, struct dim, work);
> > +	rc = container_of(dim, struct ice_ring_container, dim);
> > +	q_vector = container_of(rc, struct ice_q_vector, tx);
> > +
> > +	if (dim->profile_ix >= ARRAY_SIZE(tx_profile))
> > +		dim->profile_ix = ARRAY_SIZE(tx_profile) - 1;
> > +
> > +	/* look up the values in our local table */
> > +	itr = tx_profile[dim->profile_ix].itr;
> > +	intrl = tx_profile[dim->profile_ix].intrl;
> > +
> > +	ice_write_itr(rc, itr);
> > +	ice_write_intrl(q_vector, intrl);
> > +
> > +	dim->state = DIM_START_MEASURE;
> 
> Are you only doing register writes in ice_write_itr/intrl or talk to FW?
> Scheduler is expensive so you can save real cycles if you don't have to
> rely on a work to do the programming (not sure how hard that is with
> DIM, but since you're already sorta poking at the internals I thought
> I'd ask).

Hmm. I believe we only have to do register writes. If I recall, at least based on reading the other DIMLIB implementations, they seem to have mostly moved to a work item for apparently moving these changes out of the hot path.. but maybe that's not really an issue. Ofcourse the current dim implementation enforces use of the work queue, so I think it would require refactoring the library to support doing immediate application as opposed to using the work item..
