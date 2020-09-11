Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AEF266217
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgIKP1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:27:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60326 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726457AbgIKPYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599837860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iJ/U/CoQkEukOmnim/wnnLlXQJbF+mCf7O0yvaasEUI=;
        b=Ka9IYn1OYm7kntVMXBDiVtFCrTVISjmh6q5rAuzGkdB9jLsFDCtLfTywlmdb0csDvfCQjN
        KBkefUQzqq7nIr6J/WWVoHuV4yQVdK6S9nYfazAKeE/8/GXC+44LD2id7prczQxl1uADMC
        nQGLMc5QBvPNM9Rd5vN8+B4X1ANhHzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-GWhH9Sb-Pf2rVZMqBlDXxA-1; Fri, 11 Sep 2020 11:24:17 -0400
X-MC-Unique: GWhH9Sb-Pf2rVZMqBlDXxA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA8E9107B270;
        Fri, 11 Sep 2020 15:24:14 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44A057ED65;
        Fri, 11 Sep 2020 15:24:11 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id EFACE41853FD; Fri, 11 Sep 2020 12:23:44 -0300 (-03)
Date:   Fri, 11 Sep 2020 12:23:44 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, frederic@kernel.org,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com
Subject: Re: [RFC][Patch v1 2/3] i40e: limit msix vectors based on
 housekeeping CPUs
Message-ID: <20200911152344.GA21157@fuller.cnet>
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-3-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909150818.313699-3-nitesh@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 11:08:17AM -0400, Nitesh Narayan Lal wrote:
> In a realtime environment, it is essential to isolate unwanted IRQs from
> isolated CPUs to prevent latency overheads. Creating MSIX vectors only
> based on the online CPUs could lead to a potential issue on an RT setup
> that has several isolated CPUs but a very few housekeeping CPUs. This is
> because in these kinds of setups an attempt to move the IRQs to the
> limited housekeeping CPUs from isolated CPUs might fail due to the per
> CPU vector limit. This could eventually result in latency spikes because
> of the IRQ threads that we fail to move from isolated CPUs.
> 
> This patch prevents i40e to add vectors only based on available
> housekeeping CPUs by using num_housekeeping_cpus().
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 2e433fdbf2c3..3b4cd4b3de85 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -5,6 +5,7 @@
>  #include <linux/of_net.h>
>  #include <linux/pci.h>
>  #include <linux/bpf.h>
> +#include <linux/sched/isolation.h>
>  #include <generated/utsrelease.h>
>  
>  /* Local includes */
> @@ -11002,7 +11003,7 @@ static int i40e_init_msix(struct i40e_pf *pf)
>  	 * will use any remaining vectors to reach as close as we can to the
>  	 * number of online CPUs.
>  	 */
> -	cpus = num_online_cpus();
> +	cpus = num_housekeeping_cpus();
>  	pf->num_lan_msix = min_t(int, cpus, vectors_left / 2);
>  	vectors_left -= pf->num_lan_msix;
>  
> -- 
> 2.27.0

For patches 1 and 2:

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

