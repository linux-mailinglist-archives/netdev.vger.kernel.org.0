Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B297E107D2F
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 06:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfKWFfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 00:35:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55538 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfKWFfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 00:35:17 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iYO4g-0000Iw-CC; Sat, 23 Nov 2019 05:35:14 +0000
Date:   Sat, 23 Nov 2019 05:35:14 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Wenbo Zhang <ethercflow@gmail.com>, bpf@vger.kernel.org,
        ast@kernel.org.com, daniel@iogearbox.net, yhs@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
Message-ID: <20191123053514.GJ26530@ZenIV.linux.org.uk>
References: <cover.1574162990.git.ethercflow@gmail.com>
 <e8b1281b7405eb4b6c1f094169e6efd2c8cc95da.1574162990.git.ethercflow@gmail.com>
 <20191123031826.j2dj7mzto57ml6pr@ast-mbp.dhcp.thefacebook.com>
 <20191123045151.GH26530@ZenIV.linux.org.uk>
 <20191123051919.dsw7v6jyad4j4ilc@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191123051919.dsw7v6jyad4j4ilc@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 09:19:21PM -0800, Alexei Starovoitov wrote:

> hard to tell. It will be run out of bpf prog that attaches to kprobe or
> tracepoint. What is the concern about locking?
> d_path() doesn't take any locks and doesn't depend on any locks. Above 'if'
> checks that plain d_path() is used and not some specilized callback with
> unknown logic.

It sure as hell does.  It might end up taking rename_lock and/or mount_lock
spinlock components.  It'll try not to, but if the first pass ends up with
seqlock mismatch, it will just grab the spinlock the second time around.

> > with this number; quite possibly never before that function had been called
> > _and_ not once after it has returned.
> 
> Right. TOCTOU is not a concern here. It's tracing. It's ok for full path to be
> 'one time deal'.

It might very well be a full path of something completely unrelated to what
the syscall ends up operating upon.  It's not that the file might've been
moved; it might be a different file.  IOW, results of that tracing might be
misleading.
