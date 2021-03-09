Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC00332B01
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbhCIPsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:48:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38277 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231239AbhCIPsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:48:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615304888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bq3RjkkgvMt5Wc5hhi/ectPK68ThHpOjdimdPC3xefs=;
        b=A1107UjpNpdd+G0GSlfRiIOmfKqpzg+7U70AToTcRDLLxrh22efwJ2jk+nnX2O1poAC7RP
        Xl4Q6v8W8EL1lO4j27tel/GtXU7Ooc3O3pQlo7v4R3RORL48tMEeM33L39zcr0CIKu191G
        9s1BeK32mWsnXo1rHQj9ZKAuOgiyq5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-oURKzAU5PEWismNT9J5OXw-1; Tue, 09 Mar 2021 10:48:04 -0500
X-MC-Unique: oURKzAU5PEWismNT9J5OXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F6FF57;
        Tue,  9 Mar 2021 15:48:02 +0000 (UTC)
Received: from [10.40.192.32] (unknown [10.40.192.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DBD310013D6;
        Tue,  9 Mar 2021 15:48:00 +0000 (UTC)
Message-ID: <8e5a5a7cdf69b951b1d1077f0eaa4766cde4fbf1.camel@redhat.com>
Subject: Re: =?UTF-8?Q?=E7=AD=94=E5=A4=8D=3A?= [PATCH] net/sched:
 act_pedit: fix a NULL pointer deref in tcf_pedit_init
From:   Davide Caratti <dcaratti@redhat.com>
To:     "zhudi (J)" <zhudi21@huawei.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
In-Reply-To: <672f06766f2d49ecbb573037b3cb445a@huawei.com>
References: <20210309034736.8656-1-zhudi21@huawei.com>
         <07afbd8d9a76f3c0f0a0eb01759118a0c9e966a3.camel@redhat.com>
         <672f06766f2d49ecbb573037b3cb445a@huawei.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 09 Mar 2021 16:47:59 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-03-09 at 11:24 +0000, zhudi (J) wrote:
> > 
> > hello, thanks for the patch!
> > 
> > On Tue, 2021-03-09 at 11:47 +0800, zhudi wrote:
> > > From: Di Zhu <zhudi21@huawei.com>
> > > 
> > > when we use syzkaller to fuzz-test our kernel, one NULL pointer
> > dereference
> > > BUG happened:
> > > 
> > > Write of size 96 at addr 0000000000000010 by task syz-
> > > executor.0/22376
> > > 
> > ========================================================== ========
> > > BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000010

[...]

> > > 
> > > The root cause is that we use kmalloc() to allocate mem space for
> > > keys without checking if the ksize is 0.
> > 
> > actually Linux does this:
> > 
> > 173         parm = nla_data(pattr);
> > 174         if (!parm->nkeys) {
> > 175                 NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys
> > to be
> > passed");
> > 176                 return -EINVAL;
> > 177         }
> > 178         ksize = parm->nkeys * sizeof(struct tc_pedit_key);
> > 179         if (nla_len(pattr) < sizeof(*parm) + ksize) {
> > 180                 NL_SET_ERR_MSG_ATTR(extack, pattr, "Length of
> > TCA_PEDIT_PARMS or TCA_PEDIT_PARMS_EX pedit attribute is invalid");
> > 181                 return -EINVAL;
> > 182         }
> > 
> > maybe it's not sufficient? If so, we can add something here. I'd
> > prefer
> > to disallow inserting pedit actions with p->tcfp_nkeys equal to
> > zero,
> > because they are going to trigger a WARN(1) in the traffic path (see
> > tcf_pedit_act() at the bottom).
> 
> Yes, you are right.  I didn't notice your code submission(commit-id is
> f67169fef8dbcc1a) in 2019 
> and the kernel we tested is a bit old. Normally,  your code submission
> can avoid this bug.

well... :) 

that commit protected us against cases where param->nkeys was 0.
However, when parm->nkeys is equal to 536870912, the value of ksize
computed at line 178 becomes equal to 0.

The test at line 179 might help bailing out to error when the product
parm->nkeys * sizeof(struct tc_pedit_key) does an integer overflow, but 
I'm quite sure that negative or zero values of ksize are "unwanted" here
and probably it's still possible to craft a netlink request where parm-
>nkeys is 536870912 and nla_len(pattr) is bigger than sizeof(*parm).

Then, tcf_pedit_keys_ex_parse() might still help us detecting a bad
message, but to stay safe:

> > Then, we can also remove all the tests on the positiveness of
> > tcfp_nkeys
> > and the one you removed with your patch. WDYT?
> 
> Yes,  remove tests on the positiveness of tcfp_nkeys in this case can
> also make code more robust,
> In particular,  at some abnormal situations. Should we do it now?

I think it's correct to use an unsigned value for ksize, and protect
against the integer overflow anyway. If you want to re-submit a patch
for that, I will be happy to pass it through tdc.py selftest :)


>  I will retest with your code merged,  thanks.

either ways ok, just let me know.

thanks!
-- 
davide

