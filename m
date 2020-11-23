Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E182C195B
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 00:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgKWXVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:21:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:52243 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbgKWXVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 18:21:39 -0500
IronPort-SDR: XLTKuk4wCWSa0vdeYw1VAKGuz5v3iEUi40QYNZbXwbc0DtumOm5boE+sk4U0SlrULMHsRfGxog
 KYF3ebqC/cMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="189981206"
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="189981206"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 15:21:38 -0800
IronPort-SDR: IFGvL2bgCSrDp8wN0IS8qV0+GKUQgHbBZW9WztEc0NnYAgT4mRh/grWTpYkAoe6iMSWuZQCMwU
 lLKb5K5LDOzQ==
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="342965124"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.57.186])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 15:21:38 -0800
Date:   Mon, 23 Nov 2020 15:21:37 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Cao, Chinh T" <chinh.t.cao@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Behera, BrijeshX" <brijeshx.behera@intel.com>,
        "Valiquette, Real" <real.valiquette@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next v3 05/15] ice: create flow profile
Message-ID: <20201123152137.00003075@intel.com>
In-Reply-To: <CAKgT0Uewo+Rr19EVf9br9zBPsyOUANGMSQ0kqNVAzOJ8cjWMdw@mail.gmail.com>
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
        <20201113214429.2131951-6-anthony.l.nguyen@intel.com>
        <CAKgT0UeQ5q2M-uiR0-1G=30syPiO8S5OFHvDuN1XtQg5700hCg@mail.gmail.com>
        <fd0fc6f95f4c107d1aed18bf58239fda91879b26.camel@intel.com>
        <CAKgT0Uewo+Rr19EVf9br9zBPsyOUANGMSQ0kqNVAzOJ8cjWMdw@mail.gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Duyck wrote:

> > > I'm not sure this logic is correct. Can the flow director rules
> > > handle
> > > a field that is removed? Last I knew it couldn't. If that is the case
> > > you should be using ACL for any case in which a full mask is not
> > > provided. So in your tests below you could probably drop the check
> > > for
> > > zero as I don't think that is a valid case in which flow director
> > > would work.
> > >
> >
> > I'm not sure what you meant by a field that is removed, but Flow
> > Director can handle reduced input sets. Flow Director is able to handle
> > 0 mask, full mask, and less than 4 tuples. ACL is needed/used only when
> > a partial mask rule is requested.
> 
> So historically speaking with flow director you are only allowed one
> mask because it determines the inputs used to generate the hash that
> identifies the flow. So you are only allowed one mask for all flows
> because changing those inputs would break the hash mapping.
> 
> Normally this ends up meaning that you have to do like what we did in
> ixgbe and disable ATR and only allow one mask for all inputs. I
> believe for i40e they required that you always use a full 4 tuple. I
> didn't see something like that here. As such you may want to double
> check that you can have a mix of flow director rules that are using 1
> tuple, 2 tuples, 3 tuples, and 4 tuples as last I knew you couldn't.
> Basically if you had fields included they had to be included for all
> the rules on the port or device depending on how the tables are set
> up.

The ice driver hardware is quite a bit more capable than the ixgbe or
i40e hardware, and uses a limited set of ACL rules to support different
sets of masks. We have some limits on the number of masks and the
number of fields that we can simultaneously support, but I think
that is pretty normal for limited hardware resources.

Let's just say that if the code doesn't work on an E810 card then we
messed up and we'll have to fix it. :-)

Thanks for the review! Hope this helps...
