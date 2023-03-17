Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329386BED85
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjCQP7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjCQP7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:59:41 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98A3E39295;
        Fri, 17 Mar 2023 08:59:39 -0700 (PDT)
Received: from [192.168.2.1] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3470720C32D1;
        Fri, 17 Mar 2023 08:59:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3470720C32D1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1679068779;
        bh=eSD4HrH/QXippuTgT51HeCPn4/58lROw7Skk1W+wJbw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Kx9KjArZYqGLXeRI3pu1t2eekDre+Qmg99Kv/rQabwrnvCZNyVsr1CzY9yJxEPdGq
         jJlP2tF1Re3eNOSPPFw/uEYX5sUf+5oUgQpdkMiOyCR6f6tvWijYOFXfIgHSUV3HKl
         93Jvh84n+JCMaWfU8COQy/1R5w0HF7/JQl7Uga/Q=
Message-ID: <14d92d4b-d2c9-3a63-31b4-b083dba0878e@linux.microsoft.com>
Date:   Fri, 17 Mar 2023 16:59:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 RESEND] ptp: kvm: Use decrypted memory in confidential
 guest on x86
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Christoph Hellwig <hch@lst.de>
References: <20230308150531.477741-1-jpiotrowski@linux.microsoft.com>
Content-Language: en-US
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <20230308150531.477741-1-jpiotrowski@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/03/2023 16:05, Jeremi Piotrowski wrote:
> KVM_HC_CLOCK_PAIRING currently fails inside SEV-SNP guests because the
> guest passes an address to static data to the host. In confidential
> computing the host can't access arbitrary guest memory so handling the
> hypercall runs into an "rmpfault". To make the hypercall work, the guest
> needs to explicitly mark the memory as decrypted. Do that in
> kvm_arch_ptp_init(), but retain the previous behavior for
> non-confidential guests to save us from having to allocate memory.
> 
> Add a new arch-specific function (kvm_arch_ptp_exit()) to free the
> allocation and mark the memory as encrypted again.
> 
> Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> ---
> Hi,
> 
> I would love to not allocate a whole page just for this driver, swiotlb is
> decrypted but I don't have access to a 'struct device' here. Does anyone have
> any suggestion?
> 
> Jeremi
> 

Hi,

Does anyone have any comments or suggestions? Or can this be merged.

Jeremi

> Changes since v1:
> - forgot to commit include/linux/ptp_kvm.h
> 
>  drivers/ptp/ptp_kvm_arm.c    |  4 +++
>  drivers/ptp/ptp_kvm_common.c |  1 +
>  drivers/ptp/ptp_kvm_x86.c    | 59 +++++++++++++++++++++++++++++-------
>  include/linux/ptp_kvm.h      |  1 +
>  4 files changed, 54 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_kvm_arm.c b/drivers/ptp/ptp_kvm_arm.c
> index b7d28c8dfb84..e68e6943167b 100644
> --- a/drivers/ptp/ptp_kvm_arm.c
> +++ b/drivers/ptp/ptp_kvm_arm.c
> @@ -22,6 +22,10 @@ int kvm_arch_ptp_init(void)
>  	return 0;
>  }
>  
> +void kvm_arch_ptp_exit(void)
> +{
> +}
> +
>  int kvm_arch_ptp_get_clock(struct timespec64 *ts)
>  {
>  	return kvm_arch_ptp_get_crosststamp(NULL, ts, NULL);
> diff --git a/drivers/ptp/ptp_kvm_common.c b/drivers/ptp/ptp_kvm_common.c
> index 9141162c4237..2418977989be 100644
> --- a/drivers/ptp/ptp_kvm_common.c
> +++ b/drivers/ptp/ptp_kvm_common.c
> @@ -130,6 +130,7 @@ static struct kvm_ptp_clock kvm_ptp_clock;
>  static void __exit ptp_kvm_exit(void)
>  {
>  	ptp_clock_unregister(kvm_ptp_clock.ptp_clock);
> +	kvm_arch_ptp_exit();
>  }
>  
>  static int __init ptp_kvm_init(void)
> diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
> index 4991054a2135..902844cc1a17 100644
> --- a/drivers/ptp/ptp_kvm_x86.c
> +++ b/drivers/ptp/ptp_kvm_x86.c
> @@ -14,27 +14,64 @@
>  #include <uapi/linux/kvm_para.h>
>  #include <linux/ptp_clock_kernel.h>
>  #include <linux/ptp_kvm.h>
> +#include <linux/set_memory.h>
>  
>  static phys_addr_t clock_pair_gpa;
> -static struct kvm_clock_pairing clock_pair;
> +static struct kvm_clock_pairing clock_pair_glbl;
> +static struct kvm_clock_pairing *clock_pair;
>  
>  int kvm_arch_ptp_init(void)
>  {
> +	struct page *p;
>  	long ret;
>  
>  	if (!kvm_para_available())
>  		return -ENODEV;
>  
> -	clock_pair_gpa = slow_virt_to_phys(&clock_pair);
> -	if (!pvclock_get_pvti_cpu0_va())
> -		return -ENODEV;
> +	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
> +		p = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +		if (!p)
> +			return -ENOMEM;
> +
> +		clock_pair = page_address(p);
> +		ret = set_memory_decrypted((unsigned long)clock_pair, 1);
> +		if (ret) {
> +			__free_page(p);
> +			clock_pair = NULL;
> +			goto nofree;
> +		}
> +	} else {
> +		clock_pair = &clock_pair_glbl;
> +	}
> +
> +	clock_pair_gpa = slow_virt_to_phys(clock_pair);
> +	if (!pvclock_get_pvti_cpu0_va()) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
>  
>  	ret = kvm_hypercall2(KVM_HC_CLOCK_PAIRING, clock_pair_gpa,
>  			     KVM_CLOCK_PAIRING_WALLCLOCK);
> -	if (ret == -KVM_ENOSYS)
> -		return -ENODEV;
> +	if (ret == -KVM_ENOSYS) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
>  
>  	return ret;
> +
> +err:
> +	kvm_arch_ptp_exit();
> +nofree:
> +	return ret;
> +}
> +
> +void kvm_arch_ptp_exit(void)
> +{
> +	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
> +		WARN_ON(set_memory_encrypted((unsigned long)clock_pair, 1));
> +		free_page((unsigned long)clock_pair);
> +		clock_pair = NULL;
> +	}
>  }
>  
>  int kvm_arch_ptp_get_clock(struct timespec64 *ts)
> @@ -49,8 +86,8 @@ int kvm_arch_ptp_get_clock(struct timespec64 *ts)
>  		return -EOPNOTSUPP;
>  	}
>  
> -	ts->tv_sec = clock_pair.sec;
> -	ts->tv_nsec = clock_pair.nsec;
> +	ts->tv_sec = clock_pair->sec;
> +	ts->tv_nsec = clock_pair->nsec;
>  
>  	return 0;
>  }
> @@ -81,9 +118,9 @@ int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *tspec,
>  			pr_err_ratelimited("clock pairing hypercall ret %lu\n", ret);
>  			return -EOPNOTSUPP;
>  		}
> -		tspec->tv_sec = clock_pair.sec;
> -		tspec->tv_nsec = clock_pair.nsec;
> -		*cycle = __pvclock_read_cycles(src, clock_pair.tsc);
> +		tspec->tv_sec = clock_pair->sec;
> +		tspec->tv_nsec = clock_pair->nsec;
> +		*cycle = __pvclock_read_cycles(src, clock_pair->tsc);
>  	} while (pvclock_read_retry(src, version));
>  
>  	*cs = &kvm_clock;
> diff --git a/include/linux/ptp_kvm.h b/include/linux/ptp_kvm.h
> index c2e28deef33a..746fd67c3480 100644
> --- a/include/linux/ptp_kvm.h
> +++ b/include/linux/ptp_kvm.h
> @@ -14,6 +14,7 @@ struct timespec64;
>  struct clocksource;
>  
>  int kvm_arch_ptp_init(void);
> +void kvm_arch_ptp_exit(void);
>  int kvm_arch_ptp_get_clock(struct timespec64 *ts);
>  int kvm_arch_ptp_get_crosststamp(u64 *cycle,
>  		struct timespec64 *tspec, struct clocksource **cs);
