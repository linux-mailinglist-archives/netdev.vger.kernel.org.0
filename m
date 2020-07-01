Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444AC210CBD
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731230AbgGANx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:53:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37260 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729503AbgGANx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:53:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id d4so11752943pgk.4;
        Wed, 01 Jul 2020 06:53:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h6MIEo0w4YZ3T+eJF1TvR/2DQpsBFpaOhagpRiYZ+H8=;
        b=t6nk2qVKdVSukXvHycISu9uTL6cCz6rvevc22alvK1fF8ZNHGSt4yug1o/lCWSKhXV
         BXjxfdjDm+AlfpbTiWXfmje8OwyKdfQDJN9TYt1m4FA4oVIBsobzqJQuMuuXLx6RMwXk
         aMDfa+vQfenIIAq0Aei1FnGiO0Kl8TrVGSddTgtgR7fhK1bGJnUcKgPdvDbZ0zOvGjDe
         8yfe4q79fBQUtVBnp577jSThCErUiR57C15XHez6m7M3X0CnQvFDm8xQIa7Qs6Ic3Jyk
         +IFEKt/E/Zy2WLzpwnvCaDTq+1ff4Lim9KfxmtwQChOT7/92ue6SIq9L5Wr/NSgUYhQb
         cpbg==
X-Gm-Message-State: AOAM532fXXcfp/yreCRFUsGPsYL7XAtICVut+qW22OIxG/sEKQlDsb6F
        0CqU62QG3cNKskhbkkLdolI=
X-Google-Smtp-Source: ABdhPJwr8PB63d+2w+lLb3Er1zsrEZRI+fJcdyF7BlE5PN4Mx8QBpZaoVFxqxCr8t6D5Itc3OYVSZA==
X-Received: by 2002:a62:1801:: with SMTP id 1mr24742854pfy.242.1593611606042;
        Wed, 01 Jul 2020 06:53:26 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id w20sm6018568pfn.44.2020.07.01.06.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 06:53:24 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 3BAEC403DC; Wed,  1 Jul 2020 13:53:24 +0000 (UTC)
Date:   Wed, 1 Jul 2020 13:53:24 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>, ast@kernel.org,
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
Message-ID: <20200701135324.GS4332@42.do-not-panic.com>
References: <9e767819-9bbe-2181-521e-4d8ca28ca4f7@de.ibm.com>
 <20200624160953.GH4332@42.do-not-panic.com>
 <ea41e2a9-61f7-aec1-79e5-7b08b6dd5119@de.ibm.com>
 <4e27098e-ac8d-98f0-3a9a-ea25242e24ec@de.ibm.com>
 <4d8fbcea-a892-3453-091f-d57c03f9aa90@de.ibm.com>
 <1263e370-7cee-24d8-b98c-117bf7c90a83@de.ibm.com>
 <20200626025410.GJ4332@42.do-not-panic.com>
 <20200630175704.GO13911@42.do-not-panic.com>
 <b24d8dae-1872-ba2c-acd4-ed46c0781317@de.ibm.com>
 <a6792135-3285-0861-014e-3db85ea251dc@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6792135-3285-0861-014e-3db85ea251dc@i-love.sakura.ne.jp>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 10:24:29PM +0900, Tetsuo Handa wrote:
> On 2020/07/01 19:08, Christian Borntraeger wrote:
> > 
> > 
> > On 30.06.20 19:57, Luis Chamberlain wrote:
> >> On Fri, Jun 26, 2020 at 02:54:10AM +0000, Luis Chamberlain wrote:
> >>> On Wed, Jun 24, 2020 at 08:37:55PM +0200, Christian Borntraeger wrote:
> >>>>
> >>>>
> >>>> On 24.06.20 20:32, Christian Borntraeger wrote:
> >>>> [...]> 
> >>>>> So the translations look correct. But your change is actually a sematic change
> >>>>> if(ret) will only trigger if there is an error
> >>>>> if (KWIFEXITED(ret)) will always trigger when the process ends. So we will always overwrite -ECHILD
> >>>>> and we did not do it before. 
> >>>>>
> >>>>
> >>>> So the right fix is
> >>>>
> >>>> diff --git a/kernel/umh.c b/kernel/umh.c
> >>>> index f81e8698e36e..a3a3196e84d1 100644
> >>>> --- a/kernel/umh.c
> >>>> +++ b/kernel/umh.c
> >>>> @@ -154,7 +154,7 @@ static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
> >>>>                  * the real error code is already in sub_info->retval or
> >>>>                  * sub_info->retval is 0 anyway, so don't mess with it then.
> >>>>                  */
> >>>> -               if (KWIFEXITED(ret))
> >>>> +               if (KWEXITSTATUS(ret))
> >>>>                         sub_info->retval = KWEXITSTATUS(ret);
> 
> Well, it is not br_stp_call_user() but br_stp_start() which is expecting
> to set sub_info->retval for both KWIFEXITED() case and KWIFSIGNALED() case.
> That is, sub_info->retval needs to carry raw value (i.e. without "umh: fix
> processed error when UMH_WAIT_PROC is used" will be the correct behavior).

br_stp_start() doesn't check for the raw value, it just checks for err
or !err. So the patch, "umh: fix processed error when UMH_WAIT_PROC is
used" propagates the correct error now.

Christian, can you try removing the binary temporarily and seeing if
you get your bridge working?

  Luis
