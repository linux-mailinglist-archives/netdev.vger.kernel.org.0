Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582496EC305
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 00:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjDWW4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 18:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDWW4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 18:56:53 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56360E7C;
        Sun, 23 Apr 2023 15:56:52 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f09b4a1527so39198315e9.0;
        Sun, 23 Apr 2023 15:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682290611; x=1684882611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FySrqR3I9d2HCqC1MT7U/tQkVY+ilau9mLcrZc6QcIY=;
        b=mZT7t8bzo16wHQRVA8V4NkONZ6iLIScE5PMAGD/1ZThj5o5tvY6c0aR23RyV47Na5v
         C2ucjU2s7HX+Cm5ykpK4CZzExQaeEDfEaDLJBOTb2LxBhznZ/9DHrOxfB3pQXD/nUhxj
         vpuIixxNzcT+GmZoZSj4M5bHWeFXg4ZK0isnDzgkTGU2Abs4UU081rSvp3+C9jGHem1O
         9uZ4tn/P6ryrVDM48/tLSf1jS5x0n2NS5BCxPX2td7APmh8p+SdCE+DlUErBq1Jj62XJ
         gPUG4HQYSty3Mb3k5mIsSDU6ix7zk/F78x1cRISue3UiCbAARPpvzD/wkUBQ0S0ZUGuv
         Qw1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682290611; x=1684882611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FySrqR3I9d2HCqC1MT7U/tQkVY+ilau9mLcrZc6QcIY=;
        b=LZ9+/Wph3dsatxtmEemfv6TnBqVYiwvs6Eg61EKB9GL8VencbHM/g6WARsHm9n3H4C
         ksKRwj1h+ayYItGfeGnrK/1TYWjRVUPUBPWUgJD5y2+vf47vETrf/DBAILrT4xtQa1so
         7VHFt3ync3XeC1j6ir89eMksUPqhkJqE9gM2bbCiaV+RZfT3kyVluJ37maT5vEyzugWG
         aBexsPdtqjvga8RCCKby92I58CsIkhcCMele2iP+oGN1VwJe/eMYHJ3/Q4621E5ReAJH
         EmAVPLYQGKQ/NNmPnXYFnGIWcNYLca7y+Ytw6KMB2rMGhD43mJ1QTSyksOI4bi3igiHh
         XZJw==
X-Gm-Message-State: AAQBX9d/WpFpHayaP2HUNspPB+JDsuYoZvRSeaXSuPlxspHdDOPNB+LL
        X7EHxUhFWAqRznucAal1Xe8=
X-Google-Smtp-Source: AKy350b82f+U7u9J6kn0j7kDyXpFIBXu+ByS2Jos5JwWTL0rqSZb8T8t659h3+NCD45oLu9KUIqrgA==
X-Received: by 2002:a7b:c5d4:0:b0:3f0:a0bb:58ef with SMTP id n20-20020a7bc5d4000000b003f0a0bb58efmr6224103wmk.25.1682290610521;
        Sun, 23 Apr 2023 15:56:50 -0700 (PDT)
Received: from localhost ([2a00:23c5:dc8c:8701:1663:9a35:5a7b:1d76])
        by smtp.gmail.com with ESMTPSA id p17-20020a056000019100b002fda1b12a0bsm9585766wrx.2.2023.04.23.15.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 15:56:49 -0700 (PDT)
Date:   Sun, 23 Apr 2023 23:56:48 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] mm/gup: disallow GUP writing to file-backed mappings by
 default
Message-ID: <14c6f0f3-0747-4800-8718-4f109f7321ea@lucifer.local>
References: <f86dc089b460c80805e321747b0898fd1efe93d7.1682168199.git.lstoakes@gmail.com>
 <20230423222941.GR447837@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423222941.GR447837@dread.disaster.area>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 08:29:41AM +1000, Dave Chinner wrote:
> On Sat, Apr 22, 2023 at 02:37:05PM +0100, Lorenzo Stoakes wrote:
> > +/*
> > + * Writing to file-backed mappings using GUP is a fundamentally broken operation
> > + * as kernel write access to GUP mappings may not adhere to the semantics
> > + * expected by a file system.
> > + *
> > + * In most instances we disallow this broken behaviour, however there are some
> > + * exceptions to this enforced here.
> > + */
> > +static inline bool can_write_file_mapping(struct vm_area_struct *vma,
> > +					  unsigned long gup_flags)
> > +{
> > +	struct file *file = vma->vm_file;
> > +
> > +	/* If we aren't pinning then no problematic write can occur. */
> > +	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
> > +		return true;
> > +
> > +	/* Special mappings should pose no problem. */
> > +	if (!file)
> > +		return true;
>
> Ok...
>
> > +
> > +	/* Has the caller explicitly indicated this case is acceptable? */
> > +	if (gup_flags & FOLL_ALLOW_BROKEN_FILE_MAPPING)
> > +		return true;
> > +
> > +	/* shmem and hugetlb mappings do not have problematic semantics. */
> > +	return vma_is_shmem(vma) || is_file_hugepages(file);
> > +}
>
> This looks backwards. We only want the override to occur when the
> target won't otherwise allow it. i.e.  This should be:
>
> 	if (vma_is_shmem(vma))
> 		return true;
> 	if (is_file_hugepages(vma)
> 		return true;
>
> 	/*
> 	 * Issue a warning only if we are allowing a write to a mapping
> 	 * that does not support what we are attempting to do functionality.
> 	 */
> 	if (WARN_ON_ONCE(gup_flags & FOLL_ALLOW_BROKEN_FILE_MAPPING))
> 		return true;
> 	return false;
>
> i.e. we only want the warning to fire when the override is
> triggered - indicating that the caller is actually using a file
> mapping in a broken way, not when it is being used on
> file/filesystem that actually supports file mappings in this way.
>
> >  static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> >  {
> >  	vm_flags_t vm_flags = vma->vm_flags;
> >  	int write = (gup_flags & FOLL_WRITE);
> >  	int foreign = (gup_flags & FOLL_REMOTE);
> > +	bool vma_anon = vma_is_anonymous(vma);
> >
> >  	if (vm_flags & (VM_IO | VM_PFNMAP))
> >  		return -EFAULT;
> >
> > -	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
> > +	if ((gup_flags & FOLL_ANON) && !vma_anon)
> >  		return -EFAULT;
> >
> >  	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
> > @@ -978,6 +1008,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> >  		return -EFAULT;
> >
> >  	if (write) {
> > +		if (!vma_anon &&
> > +		    WARN_ON_ONCE(!can_write_file_mapping(vma, gup_flags)))
> > +			return -EFAULT;
>
> Yeah, the warning definitely belongs in the check function when the
> override triggers allow broken behaviour to proceed, not when we
> disallow a write fault because the underlying file/filesystem does
> not support the operation being attempted.

I disagree for two reasons:-

1. There are places in the kernel that rely on this broken behaviour, most
   notably ptrace (and /proc/$pid/mem), but also the other places where you
   can see I've added this flag. I'm not sure spamming warnings for
   ordinary cases would be useful.

2. The purpose of putting a warning here is to catch any case I might have
   missed where broken behaviour is required, but now disallowed, because it
   might actually be hard for a GUP user to track down that this is why the
   GUP is no longer functioning (since all they'll see is an -EFAULT).

This warned upon check should in reality not occur, because it implies the
GUP user is trying to do something broken and is _not_ explicitly telling
GUP that it knows it's doing it and can live with the consequences. And on
that basis, is worthy of a warning so we know we have to go put this flag
in that place (and know it is a source of problematic GUP usage), or fix
the caller.

An example case is placing breakpoints in gdb, without the flag being set
for /proc/$pid/mem this will just fail. Raising a kernel warning when a
user places a breakpoint seems... unhelpful :)

>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
