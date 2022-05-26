Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA80A5355CE
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244735AbiEZVqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiEZVqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:46:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479D51F8;
        Thu, 26 May 2022 14:46:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nuLIs-0008H6-Ef; Thu, 26 May 2022 23:45:58 +0200
Date:   Thu, 26 May 2022 23:45:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: Re: [PATCH v4 bpf-next 06/14] bpf: Whitelist some fields in nf_conn
 for BPF_WRITE
Message-ID: <20220526214558.GA31193@breakpoint.cc>
References: <cover.1653600577.git.lorenzo@kernel.org>
 <2954ab26de09afeecf3a56ba93624f9629072102.1653600578.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2954ab26de09afeecf3a56ba93624f9629072102.1653600578.git.lorenzo@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> 
> Since we want to allow user to set some fields in nf_conn after it is
> allocated but before it is inserted, we can permit BPF_WRITE for normal
> nf_conn, and then mark return value as read only on insert, preventing
> further BPF_WRITE. This way, nf_conn can be written to using normal
> BPF instructions after allocation, but not after insertion.
> 
> Note that we special nf_conn a bit here, inside the btf_struct_access
> callback for XDP and TC programs. Since this is the only struct for
> these programs requiring such adjustments, making this mechanism
> more generic has been left as an exercise for a future patch adding
> custom callbacks for more structs.

Are you sure this is safe?
As far as I can see this allows nf_conn->status = ~0ul.
I'm fairly sure this isn't a good idea, see nf_ct_delete() for example.
