Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7986B4D0096
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 15:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242845AbiCGOB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 09:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239786AbiCGOB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 09:01:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA03889333;
        Mon,  7 Mar 2022 06:00:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45E7F61266;
        Mon,  7 Mar 2022 14:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DF5C340EB;
        Mon,  7 Mar 2022 14:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646661633;
        bh=AUTZ4SHzz2itvOQ5SUm88SHoX24HvJUW+0NaQzv8J3k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F2td//5fwB39fMMh4fLb1tfGTG7iJWRLyOteTNLVh3RSr7ZDvo6TI5EoHtEmkldr3
         JHettZzepZj6pizKJFWpNJOPkrGYfw0hjj3nO54kOmGilLmflhHz/au6guRoCLiAQQ
         xArwZmCN2pbLODGTDEdML7aYksfF62X6/rGLeSkwVGAsxhWkB9WOYHALLVuf7xhik/
         T5c5EJY/3T3/j0OOwETzv0rktoa19OAdGNW7dC2pGwIr4m9qQltiOWS8z8i0lsO1vh
         m0l5yJbkSfCHreDcZgmA7uz83N7gK2UvdAUiqHTfwMuSFL6tqoG2nJ0DYYqS2+hddc
         4rmFvAw3Haetw==
Date:   Mon, 7 Mar 2022 23:00:27 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v9 02/11] fprobe: Add ftrace based probe APIs
Message-Id: <20220307230027.679cca95a201b094e700716d@kernel.org>
In-Reply-To: <YiYAw64nDTWB/V0t@krava>
References: <164655933970.1674510.3809060481512713846.stgit@devnote2>
        <164655936328.1674510.15506582463881824113.stgit@devnote2>
        <YiYAw64nDTWB/V0t@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Mar 2022 13:55:31 +0100
Jiri Olsa <olsajiri@gmail.com> wrote:

> On Sun, Mar 06, 2022 at 06:36:03PM +0900, Masami Hiramatsu wrote:
> 
> SNIP
> 
> > +}
> > +NOKPROBE_SYMBOL(fprobe_handler);
> > +
> > +/* Convert ftrace location address from symbols */
> > +static unsigned long *get_ftrace_locations(const char **syms, int num)
> > +{
> > +	unsigned long addr, size;
> > +	unsigned long *addrs;
> > +	int i;
> > +
> > +	/* Convert symbols to symbol address */
> > +	addrs = kcalloc(num, sizeof(*addrs), GFP_KERNEL);
> > +	if (!addrs)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	for (i = 0; i < num; i++) {
> > +		addrs[i] = kallsyms_lookup_name(syms[i]);
> > +		if (!addrs[i])	/* Maybe wrong symbol */
> > +			goto error;
> > +	}
> > +
> > +	/* Convert symbol address to ftrace location. */
> > +	for (i = 0; i < num; i++) {
> > +		if (!kallsyms_lookup_size_offset(addrs[i], &size, NULL) || !size)
> > +			goto error;
> > +		addr = ftrace_location_range(addrs[i], addrs[i] + size - 1);
> > +		if (!addr) /* No dynamic ftrace there. */
> > +			goto error;
> > +		addrs[i] = addr;
> > +	}
> 
> why not one just single loop ?

Indeed :-D Thanks!

> 
> jirka
> 
> 
> > +
> > +	return addrs;
> > +
> > +error:
> > +	kfree(addrs);
> > +
> > +	return ERR_PTR(-ENOENT);
> > +}
> > +
> > +static void fprobe_init(struct fprobe *fp)
> > +{
> > +	fp->nmissed = 0;
> > +	fp->ops.func = fprobe_handler;
> > +	fp->ops.flags |= FTRACE_OPS_FL_SAVE_REGS;
> > +}
> 
> SNIP


-- 
Masami Hiramatsu <mhiramat@kernel.org>
