Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4F323F695
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 07:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgHHFnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 01:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgHHFnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 01:43:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 647B42177B;
        Sat,  8 Aug 2020 05:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596865387;
        bh=Gow8EnzM5fWfP3mZhZVoa+SnXxaXlDH20QUzxm9L8Ck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Po+8Wm8vqO79Mbwdrc9oYj/ZjXH8UYIQlB75Tym7cJdAsxCHiT3ndt4kHE/UNWOOg
         DGLbs+XQu2rxgSUwRDu4QYed8QKt6M+mYUSgvQnh765NtNXmKa6e7p/exOH7MiwuuV
         qPD8yYGq0qaNm6j5iT7ehaVy46MHURCIjAXaBhUA=
Date:   Sat, 8 Aug 2020 07:43:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathan Adams <jwadams@google.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 2/7] core/metricfs: add support for percpu metricfs
 files
Message-ID: <20200808054304.GC1037591@kroah.com>
References: <20200807212916.2883031-1-jwadams@google.com>
 <20200807212916.2883031-3-jwadams@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807212916.2883031-3-jwadams@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 02:29:11PM -0700, Jonathan Adams wrote:
> Add a simple mechanism for exporting percpu data through metricfs.
> The API follows the existing metricfs pattern.  A percpu file is
> defined with:
> 
>     METRIC_EXPORT_PERCPU_INT(name, desc, fn)
>     METRIC_EXPORT_PERCPU_COUNTER(name, desc, fn)
> 
> The first defines a file for exposing a percpu int.  The second is
> similar, but is for a counter that accumulates since boot.  The
> 'name' is used as the metricfs file.  The 'desc' is a description
> of the metric.  The 'fn' is a callback function to emit a single
> percpu value:
> 
>     void (*fn)(struct metric_emitter *e, int cpu);
> 
> The callback must call METRIC_EMIT_PERCPU_INT with the value for
> the specified CPU.
> 
> Signed-off-by: Jonathan Adams <jwadams@google.com>
> 
> ---
> 
> jwadams@google.com: rebased to 5.6-pre6, renamed funcs to start with
> 	metric_.  This is work originally done by another engineer at
> 	google, who would rather not have their name associated with this
> 	patchset. They're okay with me sending it under my name.
> ---
>  include/linux/metricfs.h | 28 +++++++++++++++++++
>  kernel/metricfs.c        | 58 ++++++++++++++++++++++++++++++++++++----

fs/metricfs/ ?  This isn't a kernel "core" feature.

Or just put it in fs/debugfs/ and tack it along with one of the debugfs
helper functions to make it easier for everyone to use these (if they
actually are valuable.  It's hard to see how this differs from any other
debugfs interface today.

thanks,

greg k-h
