Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDE31DDC19
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgEVAWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbgEVAWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:22:18 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BF7A20825;
        Fri, 22 May 2020 00:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590106937;
        bh=UQBu9s+09ZRXhgbAFPY56Fnwnv0wKwGiaFArpYa/goQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CoNgODwuHX4WaU/4wf7BBMTIy5y5apCsVJb/nk5LzA7PjS9dtkTxf+x23sRxmB19K
         Nm8y7bAP+SetbndPW4bAnJO6ogntIKnO13z394/LWPcP8zcpAQ28nfqnNTM4OIhfYc
         Z2D014SfbcQR1RDa6rypeFF5ViJGPZWCWIeNXLME=
Date:   Fri, 22 May 2020 09:22:11 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: clean up and streamline probe_kernel_* and friends v4
Message-Id: <20200522092211.dd45d126b7598c4bf2182859@kernel.org>
In-Reply-To: <20200521152301.2587579-1-hch@lst.de>
References: <20200521152301.2587579-1-hch@lst.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 17:22:38 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Hi all,
> 
> this series start cleaning up the safe kernel and user memory probing
> helpers in mm/maccess.c, and then allows architectures to implement
> the kernel probing without overriding the address space limit and
> temporarily allowing access to user memory.  It then switches x86
> over to this new mechanism by reusing the unsafe_* uaccess logic.
> 
> This version also switches to the saner copy_{from,to}_kernel_nofault
> naming suggested by Linus.
> 
> I kept the x86 helpers as-is without calling unsage_{get,put}_user as
> that avoids a number of hard to trace casts, and it will still work
> with the asm-goto based version easily.
> 
> Changes since v3:
>  - cleanup how bpf and trace_kprobe perform the TASK_SIZE checks
>  - remove the unused dst argument to probe_kernel_read_allowed
>  - document the -ERANGE return value

This series looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

for this series.

Thank you!

> 
> Changes since v2:
>  - rebased on 5.7-rc6 with the bpf trace format string changes
>  - rename arch_kernel_read to __get_kernel_nofault and arch_kernel_write
>    to __put_kernel_nofault
>  - clean up the tracers to only allowd "mixed" reads when the kernel
>    has non-overlapping address spaces


-- 
Masami Hiramatsu <mhiramat@kernel.org>
