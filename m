Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5750E545872
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 01:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbiFIXS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 19:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345664AbiFIXSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 19:18:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE5E202D09;
        Thu,  9 Jun 2022 16:18:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29401B82D85;
        Thu,  9 Jun 2022 23:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580E0C34114;
        Thu,  9 Jun 2022 23:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654816723;
        bh=jV7HoOubF6PTB2ncQUr11grjqLBwpz0PFhGJjzU5azE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GFF+OvYad586MW1XA098aEQbKkZR/csWDoiuq1bsWvvpmFu96w9PTb+Q1L3yeRM1m
         VAQ+RTjn4X2LdsCEMPHLp+CNprlppcO5JeRczRLxBIU1dqd7wuwnMztQ1p3TivfCv7
         QeuvQoxzm+hJduo9ugf698Ws4UIxvWCW5t02Dp5WudTA0MgpCC3Xr4bMlV1XSyXC+w
         82JghlyQfOk4n9LKvTCSGs7c1YyjvAUNaU6cQwM0Eam2KZQWOo9xuw5GAsvw09pIWK
         aSXRHVRr6b1g0LBCSakH0Z+xC/42BzxxKYxyGQqii4lUPxH4F4ECgdxEZl6EY1sRJW
         ilwdH5o4JlgeA==
Date:   Thu, 9 Jun 2022 16:18:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, selinux@vger.kernel.org,
        serge@hallyn.com, amir73il@gmail.com, kernel-team@cloudflare.com,
        Jeff Moyer <jmoyer@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v3] cred: Propagate security_prepare_creds() error code
Message-ID: <YqJ/0W3wxPThWqgC@sol.localdomain>
References: <20220608150942.776446-1-fred@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608150942.776446-1-fred@cloudflare.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 10:09:42AM -0500, Frederick Lawler wrote:
> diff --git a/fs/aio.c b/fs/aio.c
> index 3c249b938632..5abbe88c3ca7 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1620,6 +1620,8 @@ static void aio_fsync_work(struct work_struct *work)
>  static int aio_fsync(struct fsync_iocb *req, const struct iocb *iocb,
>  		     bool datasync)
>  {
> +	int err;
> +
>  	if (unlikely(iocb->aio_buf || iocb->aio_offset || iocb->aio_nbytes ||
>  			iocb->aio_rw_flags))
>  		return -EINVAL;
> @@ -1628,8 +1630,11 @@ static int aio_fsync(struct fsync_iocb *req, const struct iocb *iocb,
>  		return -EINVAL;
>  
>  	req->creds = prepare_creds();
> -	if (!req->creds)
> -		return -ENOMEM;
> +	if (IS_ERR(req->creds)) {
> +		err = PTR_ERR(req->creds);
> +		req->creds = NULL;
> +		return err;
> +	}

This part is a little ugly.  How about doing:

	creds = prepare_creds();
	if (IS_ERR(creds))
		return PTR_ERR(creds);
	req->creds = creds;

> diff --git a/fs/exec.c b/fs/exec.c
> index 0989fb8472a1..02624783e40e 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1468,15 +1468,19 @@ EXPORT_SYMBOL(finalize_exec);
>   */
>  static int prepare_bprm_creds(struct linux_binprm *bprm)
>  {
> +	int err = -ERESTARTNOINTR;
>  	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
> -		return -ERESTARTNOINTR;
> +		return err;
>  
>  	bprm->cred = prepare_exec_creds();
> -	if (likely(bprm->cred))
> -		return 0;
> +	if (IS_ERR(bprm->cred)) {
> +		err = PTR_ERR(bprm->cred);
> +		bprm->cred = NULL;
> +		mutex_unlock(&current->signal->cred_guard_mutex);
> +		return err;
> +	}
>  
> -	mutex_unlock(&current->signal->cred_guard_mutex);
> -	return -ENOMEM;
> +	return 0;
>  }

Similarly:

static int prepare_bprm_creds(struct linux_binprm *bprm)
{
	struct cred *cred;

	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
		return -ERESTARTNOINTR;

	cred = prepare_exec_creds();
	if (IS_ERR(cred)) {
		mutex_unlock(&current->signal->cred_guard_mutex);
		return PTR_ERR(cred);
	}
	bprm->cred = cred;
	return 0;
}

> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index eec72ca962e2..6cf75aa83b6c 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -311,6 +311,7 @@ static void put_nsset(struct nsset *nsset)
>  
>  static int prepare_nsset(unsigned flags, struct nsset *nsset)
>  {
> +	int err = -ENOMEM;
>  	struct task_struct *me = current;
>  
>  	nsset->nsproxy = create_new_namespaces(0, me, current_user_ns(), me->fs);
> @@ -324,6 +325,12 @@ static int prepare_nsset(unsigned flags, struct nsset *nsset)
>  	if (!nsset->cred)
>  		goto out;
>  
> +	if (IS_ERR(nsset->cred)) {
> +		err = PTR_ERR(nsset->cred);
> +		nsset->cred = NULL;
> +		goto out;
> +	}

Why is the NULL check above being kept?

Also, drivers/crypto/ccp/sev-dev.c needs to be updated.

- Eric
