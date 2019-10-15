Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1469D7D98
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388641AbfJORY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:24:59 -0400
Received: from foss.arm.com ([217.140.110.172]:44076 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbfJORY7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 13:24:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53CC0337;
        Tue, 15 Oct 2019 10:24:58 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 000F23F68E;
        Tue, 15 Oct 2019 10:24:55 -0700 (PDT)
Date:   Tue, 15 Oct 2019 18:24:53 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, will@kernel.org, suzuki.poulose@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        nd@arm.com
Subject: Re: [PATCH v5 1/6] psci: Export psci_ops.conduit symbol as modules
 will use it.
Message-ID: <20191015172453.GE24604@lakrids.cambridge.arm.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-2-jianyong.wu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015104822.13890-2-jianyong.wu@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 06:48:17PM +0800, Jianyong Wu wrote:
> If arm_smccc_1_1_invoke used in modules, psci_ops.conduit should
> be export.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>

I have a patch queued [1] in the arm64 tree which adds
arm_smccc_1_1_get_conduit() for this purpose.

Please use that, adding an EXPORT_SYMBOL() if necessary.

Thanks,
Mark.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/commit/?h=for-next/smccc-conduit-cleanup&id=6b7fe77c334ae59fed9500140e08f4f896b36871

> ---
>  drivers/firmware/psci/psci.c | 6 ++++++
>  include/linux/arm-smccc.h    | 2 +-
>  include/linux/psci.h         | 1 +
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index f82ccd39a913..35c4eaab1451 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -212,6 +212,12 @@ static unsigned long psci_migrate_info_up_cpu(void)
>  			      0, 0, 0);
>  }
>  
> +enum psci_conduit psci_get_conduit(void)
> +{
> +	return psci_ops.conduit;
> +}
> +EXPORT_SYMBOL(psci_get_conduit);
> +
>  static void set_conduit(enum psci_conduit conduit)
>  {
>  	switch (conduit) {
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 552cbd49abe8..a6e4d3e3d10a 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -357,7 +357,7 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>   * The return value also provides the conduit that was used.
>   */
>  #define arm_smccc_1_1_invoke(...) ({					\
> -		int method = psci_ops.conduit;				\
> +		int method = psci_get_conduit();			\
>  		switch (method) {					\
>  		case PSCI_CONDUIT_HVC:					\
>  			arm_smccc_1_1_hvc(__VA_ARGS__);			\
> diff --git a/include/linux/psci.h b/include/linux/psci.h
> index a8a15613c157..e5cedc986049 100644
> --- a/include/linux/psci.h
> +++ b/include/linux/psci.h
> @@ -42,6 +42,7 @@ struct psci_operations {
>  	enum smccc_version smccc_version;
>  };
>  
> +extern enum psci_conduit psci_get_conduit(void);
>  extern struct psci_operations psci_ops;
>  
>  #if defined(CONFIG_ARM_PSCI_FW)
> -- 
> 2.17.1
> 
