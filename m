Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FD5469088
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 07:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238087AbhLFGwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 01:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbhLFGwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 01:52:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E91BC0613F8;
        Sun,  5 Dec 2021 22:49:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D279FB80EE6;
        Mon,  6 Dec 2021 06:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5955C341C7;
        Mon,  6 Dec 2021 06:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638773346;
        bh=c3IkfB6+YssMmenDD39hHVKdYX6KS+hEdVqhCCHzous=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XGC+8gy9OUDDSrdfBJPM3F5ynMzn+fA5T4r5MA5O3ULhiwBNLbKDSD9Wv7ow0XaGP
         H1/FGFXjlfvj7KfC1ygz9RIdKPpZXRGZs0IEaMYAA6vh22idvDJH+mp2YYCdccQOgz
         sLF6HF6utfsvnWn0B23Bvwm1BR/cs4cxB8JvmWOvvLhVrLsX21BAFoVn5WHgZD5pXx
         IBbhoBXqKoInnTja7mSOgLI599IIfz+SLg4wKszz5BR1donH0mPE7ojSwJaGzON0kM
         90mZAesVPbp4FnB+iKBJ5ww+Ux2QNE6x/3Z5fmu/fRPjM4pCUrD134GqpTWHgNP/D2
         je4mpy0LFNlEg==
Date:   Mon, 6 Dec 2021 08:49:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Leo Yan <leo.yan@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, codalist@coda.cs.cmu.edu,
        linux-audit@redhat.com
Subject: Re: [PATCH v1 1/7] pid: Introduce helper task_is_in_root_ns()
Message-ID: <Ya2yXZAn+36yhfdU@unreal>
References: <20211205145105.57824-1-leo.yan@linaro.org>
 <20211205145105.57824-2-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211205145105.57824-2-leo.yan@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 05, 2021 at 10:50:59PM +0800, Leo Yan wrote:
> Currently the kernel uses open code in multiple places to check if a
> task is in the root PID namespace with the kind of format:
> 
>   if (task_active_pid_ns(current) == &init_pid_ns)
>       do_something();
> 
> This patch creates a new helper function, task_is_in_root_ns(), it
> returns true if a passed task is in the root PID namespace, otherwise
> returns false.  So it will be used to replace open codes.
> 
> Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  include/linux/pid_namespace.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
> index 7c7e627503d2..bf82b373f022 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -86,4 +86,9 @@ extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
>  void pidhash_init(void);
>  void pid_idr_init(void);
>  
> +static inline bool task_is_in_root_ns(struct task_struct *tsk)

It is bad that this name doesn't reflect PID nature of this namespace.
Won't it better to name it task_is_in_init_pid_ns()?

Thanks

> +{
> +	return task_active_pid_ns(tsk) == &init_pid_ns;
> +}
> +
>  #endif /* _LINUX_PID_NS_H */
> -- 
> 2.25.1
> 
