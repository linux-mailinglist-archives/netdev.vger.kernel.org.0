Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D2820E501
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391251AbgF2VbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391253AbgF2VbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 17:31:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF20C2073E;
        Mon, 29 Jun 2020 21:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593466276;
        bh=6Rquy2N+77cv5G2ToRAuJ74ccl4EYoOwpisZ9ZJ0xXs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LQ1rQ5tzXc9vh13lSW1B+8EyuhW0MwgV4UtHEFLVj54wVAcBPYWS6xdDXnlJCMCya
         ZED3HCEpxcxmk0YequHC2/IFM41TrSXLCZjoqJhI2vHsCUL2p2bbCta3Rpdng2pspM
         S67NU/+x9pZy4WEMvQvndESMOeKKO4CsrFBC9tfc=
Date:   Mon, 29 Jun 2020 14:31:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Brady, Alan" <alan.brady@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: [net-next v3 13/15] iecm: Add ethtool
Message-ID: <20200629143114.64fca33e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <MW3PR11MB45223CBE134055CC3A4EA3958F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
        <20200626122742.20b47bb8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <MW3PR11MB45223CBE134055CC3A4EA3958F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 21:00:57 +0000 Brady, Alan wrote:
> > > +/* Helper macro to define an iecm_stat structure with proper size and type.
> > > + * Use this when defining constant statistics arrays. Note that
> > > +@_type expects
> > > + * only a type name and is used multiple times.
> > > + */
> > > +#define IECM_STAT(_type, _name, _stat) { \
> > > +	.stat_string = _name, \
> > > +	.sizeof_stat = sizeof_field(_type, _stat), \
> > > +	.stat_offset = offsetof(_type, _stat) \ }
> > > +
> > > +/* Helper macro for defining some statistics related to queues */
> > > +#define IECM_QUEUE_STAT(_name, _stat) \
> > > +	IECM_STAT(struct iecm_queue, _name, _stat)
> > > +
> > > +/* Stats associated with a Tx queue */ static const struct iecm_stats
> > > +iecm_gstrings_tx_queue_stats[] = {
> > > +	IECM_QUEUE_STAT("%s-%u.packets", q_stats.tx.packets),
> > > +	IECM_QUEUE_STAT("%s-%u.bytes", q_stats.tx.bytes), };
> > > +
> > > +/* Stats associated with an Rx queue */ static const struct
> > > +iecm_stats iecm_gstrings_rx_queue_stats[] = {
> > > +	IECM_QUEUE_STAT("%s-%u.packets", q_stats.rx.packets),
> > > +	IECM_QUEUE_STAT("%s-%u.bytes", q_stats.rx.bytes),
> > > +	IECM_QUEUE_STAT("%s-%u.generic_csum", q_stats.rx.generic_csum),
> > > +	IECM_QUEUE_STAT("%s-%u.basic_csum", q_stats.rx.basic_csum),  
> > 
> > What's basic and generic? perhaps given them the Linux names?  
> 
> I believe these should be hw_csum for basic_csum and csum_valid for generic_csum, will fix.

I was thinking of just saying csum_complete and csum_unnecessary.

But generic_sum doesn't seem to be incremented in this patch, so hard
to tell what it is :S

> > > +	q->itr.target_itr = coalesce_usecs;
> > > +	if (use_adaptive_coalesce)
> > > +		q->itr.target_itr |= IECM_ITR_DYNAMIC;
> > > +	/* Update of static/dynamic ITR will be taken care when interrupt is
> > > +	 * fired
> > > +	 */
> > > +	return 0;
> > > +}
> > > +
> > > +/**
> > > + * iecm_set_q_coalesce - set ITR values for specific queue
> > > + * @vport: vport associated to the queue that need updating
> > > + * @ec: coalesce settings to program the device with
> > > + * @q_num: update ITR/INTRL (coalesce) settings for this queue
> > > +number/index
> > > + * @is_rxq: is queue type Rx
> > > + *
> > > + * Return 0 on success, and negative on failure  */ static int
> > > +iecm_set_q_coalesce(struct iecm_vport *vport, struct ethtool_coalesce *ec,
> > > +		    int q_num, bool is_rxq)
> > > +{
> > > +	if (is_rxq) {
> > > +		struct iecm_queue *rxq = iecm_find_rxq(vport, q_num);
> > > +
> > > +		if (rxq && __iecm_set_q_coalesce(ec, rxq))
> > > +			return -EINVAL;
> > > +	} else {
> > > +		struct iecm_queue *txq = iecm_find_txq(vport, q_num);
> > > +
> > > +		if (txq && __iecm_set_q_coalesce(ec, txq))
> > > +			return -EINVAL;
> > > +	}  
> > 
> > What's the point? Callers always call this function with tx, then rx.
> > Just set both.  
> 
> As I understand it's possible to have a different number of TX and RX
> queues.  Theoretically iecm_find_Xq will just return NULL if there's
> no queue for some index so we could do both, but then we have to
> figure which one is greater etc etc.  It seems less error prone and
> clearer to me to just call it for the queues we need to.  We can make
> this iecm_set_q_coalesce function a little less terse, perhaps that
> is sufficient?

I don't feel strongly about this one, up to you.
