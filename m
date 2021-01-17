Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559772F934E
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 16:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbhAQPL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 10:11:27 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:35653 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729494AbhAQPLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 10:11:17 -0500
Received: by mail-wr1-f54.google.com with SMTP id l12so8824371wry.2;
        Sun, 17 Jan 2021 07:11:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yxPKYVAYGFQ1uVQM2y606vIDhx9zjoEHxHnN55EZo98=;
        b=TUVVHDczSAED4qTERg6ScXVXG6pdSeHnM7xdHdUaGtMng5gn+2Qn/oJLIbS182hc/w
         f7H5t9ODzo0lZ0HL4YdT84LopIZDUrICwV6Zpvtig0B6zKC7AooH/LNkbPQ7eJKx2fRy
         k40jkgJ4L1CVQxYRaM2Jj2/U/K1TNbZ7AGO4xBTk+Xp/bcnZWv7WHpC6GpEnQCxy/9/9
         fDt291EmWIiHN9GSTd7r9Ht6GP9ekW7Qr2vBla3xI0pjKespB4s8fLJ0bcNCO/pYZu0l
         E55W+ZSsLlluv1OgfilcQlOg+fPv5PiJnKNvVN9BQWiZfaTTcOe/9peE+CtBfSRtHpQP
         ALZg==
X-Gm-Message-State: AOAM530jgMI9U6aLeGz5uL3x9oTjKyxzxpm6k0m89sQbvSqUdCwdy9PT
        y3zFtfwOqU+wvpJtML5wzHY=
X-Google-Smtp-Source: ABdhPJyJPGTIXOtEZuKjxF9FdiBJ+duV8o5fKkcqf2RskvssZY/hStY35yl3A3IfKiwk8yag1fbfsA==
X-Received: by 2002:adf:ef51:: with SMTP id c17mr22353048wrp.101.1610896234710;
        Sun, 17 Jan 2021 07:10:34 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id g1sm24246408wrq.30.2021.01.17.07.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 07:10:34 -0800 (PST)
Date:   Sun, 17 Jan 2021 15:10:32 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2] hv_netvsc: Add (more) validation for untrusted
 Hyper-V values
Message-ID: <20210117151032.sbhjryq2hs3ctnlx@liuwe-devbox-debian-v2>
References: <20210114202628.119541-1-parri.andrea@gmail.com>
 <20210115203022.7005e66a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210116130201.GA1579@anparri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116130201.GA1579@anparri>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 02:02:01PM +0100, Andrea Parri wrote:
> On Fri, Jan 15, 2021 at 08:30:22PM -0800, Jakub Kicinski wrote:
> > On Thu, 14 Jan 2021 21:26:28 +0100 Andrea Parri (Microsoft) wrote:
> > > For additional robustness in the face of Hyper-V errors or malicious
> > > behavior, validate all values that originate from packets that Hyper-V
> > > has sent to the guest.  Ensure that invalid values cannot cause indexing
> > > off the end of an array, or subvert an existing validation via integer
> > > overflow.  Ensure that outgoing packets do not have any leftover guest
> > > memory that has not been zeroed out.
> > > 
> > > Reported-by: Juan Vazquez <juvazq@microsoft.com>
> > > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Alexei Starovoitov <ast@kernel.org>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Andrii Nakryiko <andrii@kernel.org>
> > > Cc: Martin KaFai Lau <kafai@fb.com>
> > > Cc: Song Liu <songliubraving@fb.com>
> > > Cc: Yonghong Song <yhs@fb.com>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: KP Singh <kpsingh@kernel.org>
> > > Cc: netdev@vger.kernel.org
> > > Cc: bpf@vger.kernel.org
> > > ---
> > > Applies to 5.11-rc3 (and hyperv-next).
> > 
> > So this is for hyperv-next or should we take it via netdev trees?
> 
> No preference, either way is good for me.

To be clear: There is no dependency on any patch in hyperv-next, right?

That's my understanding, but I would like to confirm it.

Wei.

> 
> Thanks,
>   Andrea
