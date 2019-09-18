Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B495B5BAF
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 08:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfIRGMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 02:12:41 -0400
Received: from ozlabs.org ([203.11.71.1]:53747 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbfIRGMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 02:12:41 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46Y8lq3kqtz9sCJ;
        Wed, 18 Sep 2019 16:12:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1568787159;
        bh=rKbION4BRPZJT2pVRWztj3dezrjkCwmBEIqMY9p6PwM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=QY/9K8+m/yJdqnZ3LNdZBaa+TpfQPC3Ev3jRfcmfiOogz72qFx1Ge0VppqA0ik4sf
         /pT+hFIbHBUlB/4gKA52zNc6pW83UbJE9nESuNFU8ayoAKY5s5LZJGFDAMYCbsilFE
         N/R0TbJb+RcLzLfDL4O45/bepv7BWhiq0DdbuqVupmIVIBtoqVWLi8vAiErAAea6uK
         ZvFEstiXYCGM8PnvqtiBktJ8PdbhoIZySgWJr+Wg91mhVnIXobZNcSoE4yUjPwg8O5
         3yJTH9fmEeruNdQVGGdclsxHlqhm7lEDO6YhU4qocUNRvNUcS1FXhv9gqTHzk+KPyY
         JjBuIDdR8qmCw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Juliet Kim <julietk@linux.vnet.ibm.com>, netdev@vger.kernel.org
Cc:     julietk@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        tlfalcon@linux.vnet.ibm.com
Subject: Re: [PATCH v3 2/2] net/ibmvnic: prevent more than one thread from running in reset
In-Reply-To: <20190917171552.32498-3-julietk@linux.vnet.ibm.com>
References: <20190917171552.32498-1-julietk@linux.vnet.ibm.com> <20190917171552.32498-3-julietk@linux.vnet.ibm.com>
Date:   Wed, 18 Sep 2019 16:12:39 +1000
Message-ID: <87ef0ew2so.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Juliet,

Juliet Kim <julietk@linux.vnet.ibm.com> writes:
> Signed-off-by: Juliet Kim <julietk@linux.vnet.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 23 ++++++++++++++++++++++-
>  drivers/net/ethernet/ibm/ibmvnic.h |  3 +++
>  2 files changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index ba340aaff1b3..f344ccd68ad9 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2054,6 +2054,13 @@ static void __ibmvnic_reset(struct work_struct *work)
>  
>  	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
>  
> +	if (adapter->resetting) {
> +		schedule_delayed_work(&adapter->ibmvnic_delayed_reset,
> +				      IBMVNIC_RESET_DELAY);
> +		return;
> +	}
> +
> +	adapter->resetting = true;
>  	reset_state = adapter->state;

Is there some locking/serialisation around this?

Otherwise that looks very racy. ie. two CPUs could both see
adapter->resetting == false, then both set it to true, and then continue
executing and stomp on each other.

cheers
