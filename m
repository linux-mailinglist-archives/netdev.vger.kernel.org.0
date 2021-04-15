Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9332F361061
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhDOQrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhDOQrP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 12:47:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05A1A61166;
        Thu, 15 Apr 2021 16:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618505212;
        bh=vZTIRxmYQDRdnyqVJDTkq+j7TxqUfSVAK2LzWZozPV4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ljhpX6ik0p25qpmEK+hzDCLTHf67euowRh3TR9YGuY+OnDjMwNBy76onltowFwj/F
         CyC0xIP+2QLV66ZFzGJMlJd7CB8R09oH5z9knhdl9nxrQ+eMB5seeTSGQVolRBHmrg
         VZKduu1yNSluHVaGKmdXQrCGxrXftDZL1CIPHuY2ZX8rdmVud0Pisr80hsqEOiWR4u
         vbsfaFBZhoXy94xQbDPHRv+WjmRIUmB+UiVCFgZHwYoLqIxq7bIohNP4YWQXU5f5RZ
         6h2eGnYtw1zpfgbiQZ3Z4tKgR5kg5do/WloeVfLt0gn6+k2ke+Xa4VeUAS2smIEdeL
         9+TwKO4vKFpHg==
Date:   Thu, 15 Apr 2021 09:46:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 05/15] ice: replace custom AIM algorithm with
 kernel's DIM library
Message-ID: <20210415094651.06041834@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210415003013.19717-6-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
        <20210415003013.19717-6-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 17:30:03 -0700 Tony Nguyen wrote:
> +static void ice_tx_dim_work(struct work_struct *work)
> +{
> +	struct ice_ring_container *rc;
> +	struct ice_q_vector *q_vector;
> +	struct dim *dim;
> +	u16 itr, intrl;
> +
> +	dim = container_of(work, struct dim, work);
> +	rc = container_of(dim, struct ice_ring_container, dim);
> +	q_vector = container_of(rc, struct ice_q_vector, tx);
> +
> +	if (dim->profile_ix >= ARRAY_SIZE(tx_profile))
> +		dim->profile_ix = ARRAY_SIZE(tx_profile) - 1;
> +
> +	/* look up the values in our local table */
> +	itr = tx_profile[dim->profile_ix].itr;
> +	intrl = tx_profile[dim->profile_ix].intrl;
> +
> +	ice_write_itr(rc, itr);
> +	ice_write_intrl(q_vector, intrl);
> +
> +	dim->state = DIM_START_MEASURE;

Are you only doing register writes in ice_write_itr/intrl or talk to FW?
Scheduler is expensive so you can save real cycles if you don't have to
rely on a work to do the programming (not sure how hard that is with
DIM, but since you're already sorta poking at the internals I thought
I'd ask).
