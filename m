Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6052C19EF83
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 05:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgDFDQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 23:16:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46578 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgDFDQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 23:16:13 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLIF0-00BlXN-Gi; Mon, 06 Apr 2020 03:16:02 +0000
Date:   Mon, 6 Apr 2020 04:16:02 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com
Subject: Re: [RFC 0/3] bpf: Add d_path helper
Message-ID: <20200406031602.GR23230@ZenIV.linux.org.uk>
References: <20200401110907.2669564-1-jolsa@kernel.org>
 <20200402142106.GF23230@ZenIV.linux.org.uk>
 <20200403090828.GF2784502@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403090828.GF2784502@krava>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 03, 2020 at 11:08:28AM +0200, Jiri Olsa wrote:

> if we limit it just to task context I think it would still be
> helpful for us:
> 
>   if (in_task())
> 	d_path..
> 
> perhaps even create a d_path version without d_dname callback
> if that'd be still a problem, because it seems to be there mainly
> for special filesystems..?

IDGI...
	1) d_path(), by definition, is dependent upon the
process' root - the same <mount,dentry> pair will yield
different strings if caller is chrooted.  You *can't* just
use a random process' root
	2) we are *NOT* making rename_lock and mount_lock
disable interrupts.  Not happening.

So it has to be process-synchronous anyway.  Could you describe
where that thing is going to be callable?
