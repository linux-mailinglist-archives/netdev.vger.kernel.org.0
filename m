Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024FD20B951
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 21:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgFZTaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 15:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgFZT37 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 15:29:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98D262070A;
        Fri, 26 Jun 2020 19:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593199799;
        bh=XSmORE+6UQYENxjYXGGDo83673HH9RWlSL2+UDsC4EE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UbX39J5SoDNO1IjUKFY9KB7ZfPlfGNEnFIb/ApwaAmC6KDvgnVtymFci5r+PgNu2i
         enxblJ6zc5+4NFBlVNhrv+m3jiRUMTwoIGWffJex3nIA+aK/rP14M++QOPEyP3ewVA
         6HbDUrrKlGCca+WnJOsE7t7dEvbNxSKiolKqLH+w=
Date:   Fri, 26 Jun 2020 12:29:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v3 13/15] iecm: Add ethtool
Message-ID: <20200626122957.127d21e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 19:07:35 -0700 Jeff Kirsher wrote:
> @@ -794,7 +824,57 @@ static void iecm_vc_event_task(struct work_struct *work)
>  int iecm_initiate_soft_reset(struct iecm_vport *vport,
>  			     enum iecm_flags reset_cause)
>  {
> -	/* stub */
> +	struct iecm_adapter *adapter = vport->adapter;
> +	enum iecm_state current_state;
> +	enum iecm_status status;
> +	int err = 0;
> +
> +	/* Make sure we do not end up in initiating multiple resets */
> +	mutex_lock(&adapter->reset_lock);
> +
> +	current_state = vport->adapter->state;
> +	switch (reset_cause) {
> +	case __IECM_SR_Q_CHANGE:
> +		/* If we're changing number of queues requested, we need to
> +		 * send a 'delete' message before freeing the queue resources.
> +		 * We'll send an 'add' message in adjust_qs which doesn't
> +		 * require the queue resources to be reallocated yet.
> +		 */
> +		if (current_state <= __IECM_DOWN) {
> +			iecm_send_delete_queues_msg(vport);
> +		} else {
> +			set_bit(__IECM_DEL_QUEUES, adapter->flags);
> +			iecm_vport_stop(vport);
> +		}
> +		iecm_deinit_rss(vport);
> +		status = adapter->dev_ops.vc_ops.adjust_qs(vport);
> +		if (status) {
> +			err = -EFAULT;
> +			goto reset_failure;
> +		}
> +		iecm_intr_rel(adapter);
> +		iecm_vport_calc_num_q_vec(vport);
> +		iecm_intr_req(adapter);
> +		break;
> +	case __IECM_SR_Q_DESC_CHANGE:
> +		iecm_vport_stop(vport);
> +		iecm_vport_calc_num_q_desc(vport);
> +		break;
> +	case __IECM_SR_Q_SCH_CHANGE:
> +	case __IECM_SR_MTU_CHANGE:
> +		iecm_vport_stop(vport);
> +		break;
> +	default:
> +		dev_err(&adapter->pdev->dev, "Unhandled soft reset cause\n");
> +		err = -EINVAL;
> +		goto reset_failure;
> +	}
> +
> +	if (current_state == __IECM_UP)
> +		err = iecm_vport_open(vport);
> +reset_failure:
> +	mutex_unlock(&adapter->reset_lock);
> +	return err;
>  }

The close then open mode of operation will not cut it in 21st century.

You can't free all the resources and then fail to open if system is
tight on memory.
