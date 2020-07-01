Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552CD210FE8
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732214AbgGAP6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:58:23 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39250 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732045AbgGAP6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 11:58:23 -0400
Received: by mail-pl1-f196.google.com with SMTP id s14so10073487plq.6;
        Wed, 01 Jul 2020 08:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vhjTDAhbhu56LOxVyk2itTItRi0VSUk3vpRCYOsvLps=;
        b=o6c07wB8Nk3RU3bKWbKPtKs9WhlM6nFgY6bMyr3RQsXsoj/385+XJcZq/ytlv9u76I
         K+z9qzXAYX3SXf66Cc+MuN9GGLtz15xa2vQJt4eelB542a2sZZvJKUIpF7O7ljNllcSw
         KccGRHAHQLNmFe6zCf0rAYri+vaSgbMFCHrxM0BkDzaAAlrguDOZpVPrMUkoyjJIVd8y
         m+BOROAcuyJSyoQD3/9UFTf+qMFISws5PjG0tt2GanQpvUO5CfTARS+6SJE726KqpQNs
         bgVADdxF6DXZXFvndLbY6o9OtNXckJP6MeP7eGuZQaRbEqt3N9u/U18LTc1I8Mefy8E2
         m0Tw==
X-Gm-Message-State: AOAM533c70XavZq+WZVrJsf+Dc9i9h3A6J0WtLSKkq2YhUj4YYtJU0gm
        e884pwY8IYNKBj66eSnMckk=
X-Google-Smtp-Source: ABdhPJxvf5MuNk7GstFk4o8V8i6QVmoWUER1GnE9OdBRmndl8MWc4FrVkJpuazefUlO6cRHWSimmKg==
X-Received: by 2002:a17:90b:3547:: with SMTP id lt7mr2756806pjb.181.1593619102016;
        Wed, 01 Jul 2020 08:58:22 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id c2sm6046631pgk.77.2020.07.01.08.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 08:58:20 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 08F13403DC; Wed,  1 Jul 2020 15:58:20 +0000 (UTC)
Date:   Wed, 1 Jul 2020 15:58:19 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, ast@kernel.org,
        axboe@kernel.dk, bfields@fieldses.org,
        bridge@lists.linux-foundation.org, chainsaw@gentoo.org,
        christian.brauner@ubuntu.com, chuck.lever@oracle.com,
        davem@davemloft.net, dhowells@redhat.com,
        gregkh@linuxfoundation.org, jarkko.sakkinen@linux.intel.com,
        jmorris@namei.org, josh@joshtriplett.org, keescook@chromium.org,
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
Message-ID: <20200701155819.GU4332@42.do-not-panic.com>
References: <4d8fbcea-a892-3453-091f-d57c03f9aa90@de.ibm.com>
 <1263e370-7cee-24d8-b98c-117bf7c90a83@de.ibm.com>
 <20200626025410.GJ4332@42.do-not-panic.com>
 <20200630175704.GO13911@42.do-not-panic.com>
 <b24d8dae-1872-ba2c-acd4-ed46c0781317@de.ibm.com>
 <a6792135-3285-0861-014e-3db85ea251dc@i-love.sakura.ne.jp>
 <20200701135324.GS4332@42.do-not-panic.com>
 <8d714a23-bac4-7631-e5fc-f97c20a46083@i-love.sakura.ne.jp>
 <20200701153859.GT4332@42.do-not-panic.com>
 <f9f0f868-e511-990a-2a74-1806ac0cb7ac@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9f0f868-e511-990a-2a74-1806ac0cb7ac@de.ibm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 05:48:48PM +0200, Christian Borntraeger wrote:
> 
> 
> On 01.07.20 17:38, Luis Chamberlain wrote:
> > On Wed, Jul 01, 2020 at 11:08:57PM +0900, Tetsuo Handa wrote:
> >> On 2020/07/01 22:53, Luis Chamberlain wrote:
> >>>> Well, it is not br_stp_call_user() but br_stp_start() which is expecting
> >>>> to set sub_info->retval for both KWIFEXITED() case and KWIFSIGNALED() case.
> >>>> That is, sub_info->retval needs to carry raw value (i.e. without "umh: fix
> >>>> processed error when UMH_WAIT_PROC is used" will be the correct behavior).
> >>>
> >>> br_stp_start() doesn't check for the raw value, it just checks for err
> >>> or !err. So the patch, "umh: fix processed error when UMH_WAIT_PROC is
> >>> used" propagates the correct error now.
> >>
> >> No. If "/sbin/bridge-stp virbr0 start" terminated due to e.g. SIGSEGV
> >> (for example, by inserting "kill -SEGV $$" into right after "#!/bin/sh" line),
> >> br_stp_start() needs to select BR_KERNEL_STP path. We can't assume that
> >> /sbin/bridge-stp is always terminated by exit() syscall (and hence we can't
> >> ignore KWIFSIGNALED() case in call_usermodehelper_exec_sync()).
> > 
> > Ah, well that would be a different fix required, becuase again,
> > br_stp_start() does not untangle the correct error today really.
> > I also I think it would be odd odd that SIGSEGV or another signal 
> > is what was terminating Christian's bridge stp call, but let's
> > find out!
> > 
> > Note we pass 0 to the options to wait so the mistake here could indeed
> > be that we did not need KWIFSIGNALED(). I was afraid of this prospect...
> > as it other implications.
> > 
> > It means we either *open code* all callers, or we handle this in a
> > unified way on the umh. And if we do handle this in a unified way, it
> > then begs the question as to *what* do we pass for the signals case and
> > continued case. Below we just pass the signal, and treat continued as
> > OK, but treating continued as OK would also be a *new* change as well.
> > 
> > For instance (this goes just boot tested, but Christian if you can
> > try this as well that would be appreciated):
> 
> 
> Does not help, the bridge stays in DOWN state. 

OK thanks for testing, that was fast! Does your code go through the
STP kernel path or userpath? If it is taking the STP kernel path
then this is not the real culprit to your issue then.

  Luis
