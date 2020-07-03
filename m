Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C282213AF9
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 15:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgGCN2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 09:28:54 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33519 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgGCN2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 09:28:53 -0400
Received: by mail-pl1-f195.google.com with SMTP id 72so2088344ple.0;
        Fri, 03 Jul 2020 06:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nZixvdmK63kTxJGVp6SPuFsnYljJqU7VXv2wxF9MXFA=;
        b=XlNdsEJKuh017yoaqze1QzzzKwb783SXTEXBcadTk0ed7oA0Sm9nPzkmkG/qKzrvEU
         x65NJnpnvbpqJk3IIddNLcEFc7l4Q+/G3w8PRmJJKa6cnmgSZyNEpbNLnO003LUDNoWG
         UcMNQqXDIw8J1ptTFItLwr8SKneXNiFzj1h/tEagCN1MbHMoVQPrkt+DyOCl+bJGan/v
         ICsT56q9x2sRIMeVNfo1yDRB0cXK80hl+0mZJqzXYST5IwX7IUV7AYSp4gbZWsLBWolx
         WFEpexWDUQ9c6YCO01nzQ46uHQn9/yp4qNK4vOr4JuUdvWMwqWutVPLflMZ87p8Y/qM2
         3UPA==
X-Gm-Message-State: AOAM5302es4kl5puR7Xy9zWGA/rez4EwCHDqFyMFAI9j3/0ffCfy5mgr
        5qBgU2pGPtZDXLhiVgt8QlU=
X-Google-Smtp-Source: ABdhPJx7Zgvv1Ln8YT3HW6KzNg/0D212spMjLCprFe2ez6VGItOK7VCNoHYcRalmweCVJasHt2okLw==
X-Received: by 2002:a17:90a:3223:: with SMTP id k32mr38367135pjb.121.1593782932606;
        Fri, 03 Jul 2020 06:28:52 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 125sm11298479pff.130.2020.07.03.06.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 06:28:51 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 5569C40945; Fri,  3 Jul 2020 13:28:50 +0000 (UTC)
Date:   Fri, 3 Jul 2020 13:28:50 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     David Howells <dhowells@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, ast@kernel.org,
        axboe@kernel.dk, bfields@fieldses.org,
        bridge@lists.linux-foundation.org, chainsaw@gentoo.org,
        christian.brauner@ubuntu.com, chuck.lever@oracle.com,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        jarkko.sakkinen@linux.intel.com, jmorris@namei.org,
        josh@joshtriplett.org, keescook@chromium.org,
        keyrings@vger.kernel.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, slyfox@gentoo.org,
        viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn,
        netdev@vger.kernel.org, markward@linux.ibm.com,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: linux-next: umh: fix processed error when UMH_WAIT_PROC is used
 seems to break linux bridge on s390x (bisected)
Message-ID: <20200703132850.GW4332@42.do-not-panic.com>
References: <20200626025410.GJ4332@42.do-not-panic.com>
 <20200630175704.GO13911@42.do-not-panic.com>
 <b24d8dae-1872-ba2c-acd4-ed46c0781317@de.ibm.com>
 <a6792135-3285-0861-014e-3db85ea251dc@i-love.sakura.ne.jp>
 <20200701135324.GS4332@42.do-not-panic.com>
 <8d714a23-bac4-7631-e5fc-f97c20a46083@i-love.sakura.ne.jp>
 <20200701153859.GT4332@42.do-not-panic.com>
 <e3f3e501-2cb7-b683-4b85-2002b7603244@i-love.sakura.ne.jp>
 <20200702194656.GV4332@42.do-not-panic.com>
 <d8a74a06-de97-54ae-de03-0d955e82f62b@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8a74a06-de97-54ae-de03-0d955e82f62b@i-love.sakura.ne.jp>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 03, 2020 at 09:52:01AM +0900, Tetsuo Handa wrote:
> On 2020/07/03 4:46, Luis Chamberlain wrote:
> > The alternative to making a compromise is using generic wrappers for
> > things which make sense and letting the callers use those.
> 
> I suggest just introducing KWIFEXITED()/KWEXITSTATUS()/KWIFSIGNALED()/KWTERMSIG()
> macros and fixing the callers, for some callers are not aware of possibility of
> KWIFSIGNALED() case.

OK so we open code all uses. Do that in a next iteration.

  Luis

