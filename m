Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C23338338
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 02:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhCLBhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 20:37:52 -0500
Received: from mga14.intel.com ([192.55.52.115]:25698 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229938AbhCLBhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 20:37:21 -0500
IronPort-SDR: ETyV+qGn5b7VJ7gdlTO6dqA+G+gba9188HlPmMFJxlh3o/J7wJdRI5Q+QFdU7iA3hUsoNUOwOW
 +lvpXjY2Bx4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188131759"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="188131759"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 17:37:19 -0800
IronPort-SDR: OsP2ibwKgbiZCIqHpXErOVIXZRVkTtMdPT12UsGVzETQmRDXrR+VJOSlZgGsslap/LW/zq0mWI
 Kz1nn2ibHYLg==
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="410833620"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.208.46]) ([10.254.208.46])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 17:37:16 -0800
Subject: Re: [PATCH 1/2] vhost-vdpa: fix use-after-free of v->config_ctx
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210311135257.109460-1-sgarzare@redhat.com>
 <20210311135257.109460-2-sgarzare@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <82e63dc0-7589-98f7-0ea5-dd86ce64949d@intel.com>
Date:   Fri, 12 Mar 2021 09:37:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210311135257.109460-2-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/2021 9:52 PM, Stefano Garzarella wrote:
> When the 'v->config_ctx' eventfd_ctx reference is released we didn't
> set it to NULL. So if the same character device (e.g. /dev/vhost-vdpa-0)
> is re-opened, the 'v->config_ctx' is invalid and calling again
> vhost_vdpa_config_put() causes use-after-free issues like the
> following refcount_t underflow:
>
>      refcount_t: underflow; use-after-free.
>      WARNING: CPU: 2 PID: 872 at lib/refcount.c:28 refcount_warn_saturate+0xae/0xf0
>      RIP: 0010:refcount_warn_saturate+0xae/0xf0
>      Call Trace:
>       eventfd_ctx_put+0x5b/0x70
>       vhost_vdpa_release+0xcd/0x150 [vhost_vdpa]
>       __fput+0x8e/0x240
>       ____fput+0xe/0x10
>       task_work_run+0x66/0xa0
>       exit_to_user_mode_prepare+0x118/0x120
>       syscall_exit_to_user_mode+0x21/0x50
>       ? __x64_sys_close+0x12/0x40
>       do_syscall_64+0x45/0x50
>       entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
> Cc: lingshan.zhu@intel.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   drivers/vhost/vdpa.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ef688c8c0e0e..00796e4ecfdf 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -308,8 +308,10 @@ static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *argp)
>   
>   static void vhost_vdpa_config_put(struct vhost_vdpa *v)
>   {
> -	if (v->config_ctx)
> +	if (v->config_ctx) {
>   		eventfd_ctx_put(v->config_ctx);
> +		v->config_ctx = NULL;
> +	}
>   }
>   
>   static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
Thanks Stefano!

Reviewed-by: Zhu Lingshan <lingshan.zhu@intel.com>
