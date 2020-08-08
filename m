Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165C923F68E
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 07:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgHHFlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 01:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgHHFlr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 01:41:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 832172177B;
        Sat,  8 Aug 2020 05:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596865307;
        bh=zZB6wpjl7y81v9umrlk/yZ28yBq8cLqHYj1M+cdlj+0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h4HfvatdyE43mb3wFMw+wqp6RtzNI6q2/SaDnBcKMlSABzwXKWCbuvVah+VYtA3GG
         qQIhZjCXs6wp7ZT2j62m8Ogn7+G93uDhDlo26bH239nay+7SP26WOwqMWrAPf+XiEs
         z/oOjo7rCaEPyyTyrpBCNq3ileswcpwOlRsTUgS4=
Date:   Sat, 8 Aug 2020 07:41:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathan Adams <jwadams@google.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        Justin TerAvest <teravest@google.com>
Subject: Re: [RFC PATCH 1/7] core/metricfs: Create metricfs, standardized
 files under debugfs.
Message-ID: <20200808054143.GB1037591@kroah.com>
References: <20200807212916.2883031-1-jwadams@google.com>
 <20200807212916.2883031-2-jwadams@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807212916.2883031-2-jwadams@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

debugfs interaction nits:

On Fri, Aug 07, 2020 at 02:29:10PM -0700, Jonathan Adams wrote:
> +static struct dentry *metricfs_init_dentry(void)
> +{
> +	static int once;
> +
> +	if (d_metricfs)
> +		return d_metricfs;
> +
> +	if (!debugfs_initialized())
> +		return NULL;
> +
> +	d_metricfs = debugfs_create_dir("metricfs", NULL);
> +
> +	if (!d_metricfs && !once) {

As it is impossible for d_metricfs to ever be NULL, why are you checking
it?

> +		once = 1;
> +		pr_warn("Could not create debugfs directory 'metricfs'\n");

There is a pr_warn_once I think, but again, how can this ever trigger?

> +		return NULL;
> +	}
> +
> +	return d_metricfs;
> +}
> +
> +/* We always cast in and out to struct dentry. */
> +struct metricfs_subsys {
> +	struct dentry dentry;
> +};
> +
> +static struct dentry *metricfs_create_file(const char *name,
> +					   mode_t mode,
> +					   struct dentry *parent,
> +					   void *data,
> +					   const struct file_operations *fops)
> +{
> +	struct dentry *ret;
> +
> +	ret = debugfs_create_file(name, mode, parent, data, fops);
> +	if (!ret)
> +		pr_warn("Could not create debugfs '%s' entry\n", name);

As ret can never be NULL, why check?

There is no need to ever check debugfs return values, just keep on
going, that's the design of it.

thanks,

greg k-h
