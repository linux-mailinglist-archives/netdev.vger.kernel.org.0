Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3E82A5BF8
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbgKDBbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:31:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgKDBbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:31:34 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E21BE223BD;
        Wed,  4 Nov 2020 01:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604453494;
        bh=HlQTrnq00kQjQryBCORiCzaZQwc7cb4XSeBMTAveR2U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I+/uhbnpw/tH64S548Zvc3NlRhGaBuHdJOt74oGGqH6lJ3xm0serDXkkMYDoSjysT
         8//uAApG89+TdhNLD/QVxpVy3gsOuGq6zhyBvrSkvMe3GNFQFPJznxAtASh6IeNLDf
         RfnmdSyUZsR3DwejSkl7Sqw6VCqxxXEOVOEROCwk=
Message-ID: <eca09b4aee1d4526e1ee772adbfaafab2afa1f20.camel@kernel.org>
Subject: Re: [PATCH net-next v2 12/15] net/smc: Add support for obtaining
 SMCD device list
From:   Saeed Mahameed <saeed@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Date:   Tue, 03 Nov 2020 17:31:33 -0800
In-Reply-To: <20201103102531.91710-13-kgraul@linux.ibm.com>
References: <20201103102531.91710-1-kgraul@linux.ibm.com>
         <20201103102531.91710-13-kgraul@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-03 at 11:25 +0100, Karsten Graul wrote:
> From: Guvenc Gulce <guvenc@linux.ibm.com>
> 
> Deliver SMCD device information via netlink based
> diagnostic interface.
> 
> Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> ---
>  include/uapi/linux/smc.h      |  2 +
>  include/uapi/linux/smc_diag.h | 20 +++++++++
>  net/smc/smc_core.h            | 27 +++++++++++++
>  net/smc/smc_diag.c            | 76
> +++++++++++++++++++++++++++++++++++
>  net/smc/smc_ib.h              |  1 -
>  5 files changed, 125 insertions(+), 1 deletion(-)
> 

> +
> +static int smc_diag_prep_smcd_dev(struct smcd_dev_list *dev_list,
> +				  struct sk_buff *skb,
> +				  struct netlink_callback *cb,
> +				  struct smc_diag_req_v2 *req)
> +{
> +	struct smc_diag_dump_ctx *cb_ctx = smc_dump_context(cb);
> +	int snum = cb_ctx->pos[0];
> +	struct smcd_dev *smcd;
> +	int rc = 0, num = 0;
> +
> +	mutex_lock(&dev_list->mutex);
> +	list_for_each_entry(smcd, &dev_list->list, list) {
> +		if (num < snum)
> +			goto next;
> +		rc = smc_diag_handle_smcd_dev(smcd, skb, cb, req);
> +		if (rc < 0)
> +			goto errout;
> +next:
> +		num++;
> +	}
> +errout:
> +	mutex_unlock(&dev_list->mutex);
> +	cb_ctx->pos[0] = num;
> +	return rc;
> +}
> +

this function pattern repeats at least 4 times in this series and the
only difference is the diag handler function, just abstract this
function out and pass a function pointer as handler to reduce code
repetition. 



