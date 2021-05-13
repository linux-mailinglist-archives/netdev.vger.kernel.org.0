Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B57137FB3B
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 18:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhEMQKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 12:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234935AbhEMQJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 12:09:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4AB6613B6;
        Thu, 13 May 2021 16:08:43 +0000 (UTC)
Date:   Thu, 13 May 2021 12:08:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Joel Fernandes <joelaf@google.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC][PATCH] vhost/vsock: Add vsock_list file to map cid with
 vhost tasks
Message-ID: <20210513120842.4ed3fb0e@gandalf.local.home>
In-Reply-To: <YJ1Mbie1YGKRR6b8@stefanha-x1.localdomain>
References: <20210505163855.32dad8e7@gandalf.local.home>
        <YJ1Mbie1YGKRR6b8@stefanha-x1.localdomain>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 May 2021 16:57:34 +0100
Stefan Hajnoczi <stefanha@redhat.com> wrote:


> This approach relies on process hierarchy of the VMM (QEMU).
> Multi-process QEMU is in development and will allow VIRTIO devices to
> run as separate processes from the main QEMU. It then becomes harder to
> correlate a VIRTIO device process with its QEMU process.

And we need to know all these mapping regardless, as we need to map each
thread / process to the vCPU in order to correlate between host thread and
vCPU thread for showing in KernelShark.

Thus this mapping to find the main thread/process needs to be done
regardless.

> 
> So I think in the end this approach ends up being as fragile as parsing
> command-lines. The kernel doesn't really have the concept of a "VM" that
> the vhost_vsock is associated with :). Maybe just parse QEMU and crosvm
> command-lines?
>

That's what we do now, and it already broke once, and even parsing the
command line wont be enough for the stated reasons above.

-- Steve
